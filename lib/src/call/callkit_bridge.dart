// 系统级来电 UI 桥接 (iOS CallKit + Android ConnectionService).
//
// 集成范围:
//   * 收到 RTC `invoke` CMD → 调 `showIncoming` 让系统弹来电 UI
//     (锁屏 / 后台 / 前台都覆盖, 替代纯 Flutter 的 IncomingCallPage)
//   * 来电被对方 cancel / 自己 refuse / 自己 hangup / timeout → 调 `endCall`
//     关掉系统 UI
//   * 监听 plugin event channel, accept/decline 事件转 broadcast stream
//     让 home_shell 用 (现有 IncomingCallPage 的 accept/refuse 路径复用)
//
// **scope**: 现阶段只做 client 端框架 — backend 还没 VoIP push, 杀进程 + 锁
// 屏场景靠 IM 长连接活的时候才能弹起 CallKit. 等 backend 推 VoIP / FCM data
// 之后, AppDelegate.swift / FCM service 收到 push 时也调 plugin 同一套
// showCallkitIncoming → 锁屏 / 杀进程都唤醒.
//
// 对齐参考: OpenIM 开源版 demo 用纯 IM 信令 + Android 自研 alert (没接 CallKit
// / VoIP push), chatim 这里走 plugin 自带 CXProvider + ConnectionService 一步
// 到 production-grade UI.

import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show debugPrint, visibleForTesting;
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import '../config/app_brand.dart';
import '../im/wukong_im_service.dart' show IncomingCallEvent;
import '../ui/identity_display.dart';

/// **FEATURE FLAG — CallKit 临时禁用**
/// 仍然不稳: native event 跨 isolate race, lifecycle resume race, accept
/// echo 误触发业务 hangup, audio session 死锁 等 多种 bug 一起作怪. 多次
/// "修" 反而越改越坏, 用户基础通话功能都被波及.
/// **战略决策**: 关闭整个 CallKit 链路, 回到 IM CMD invoke → IncomingCallPage
/// 这条 baseline 可用流程. 失去锁屏/杀进程的系统级唤醒, 但所有通话不再坏.
/// **恢复路径**: 拿到 Apple `com.apple.developer.pushkit.unrestricted-voip`
/// entitlement 后, 重新设计 CallKit accept event 跟 Flutter app 状态的同步
/// 模型 (持久化 native event queue, lifecycle 拉起 + IncomingCallPage 收口,
/// 等等). 现在 server 端 call_instance_id / VoIP token register / FCM data
/// schema 都保留, 客户端 flag 翻回 false 即可重启集成.
/// 改这个 flag 时记得同步 push_service.dart `_startAndroid` 的
/// `FirebaseMessaging.onBackgroundMessage(foxtalkFcmBackgroundHandler)`
/// 注册 — bg handler 内有 plugin showCallkitIncoming, 不一起关会绕过 flag.
const bool kCallKitDisabled = true;

/// CallKit event payload — 简化版, 给 home_shell 用. plugin 的 [Event] enum
/// 字段名很啰嗦, 这里转成业务语义.
class CallKitAction {
  const CallKitAction({required this.uuid, required this.extra});

  /// CallKit 用 UUID, 来源是 [CallKitBridge.uuidFor]. 拿来跟 IncomingCallEvent
  /// 对回去 (home_shell 持有 _currentIncomingEvent).
  final String uuid;

  /// `extra` map — 从 [showIncoming] 调用时塞进去的 (fromUid / roomId /
  /// isGroup / groupChannelId / callType). 用户点 native UI 接听/拒绝时,
  /// plugin event payload 回传同一份 extra → 不需要 home_shell 缓存事件.
  final Map<String, dynamic> extra;
}

/// 单例 — 整个 app 只有一个 plugin event channel listener (重复 listen 会
/// 收到重复事件 → 双倍接听 / 双倍拒绝).
class CallKitBridge {
  CallKitBridge._();
  static final CallKitBridge instance = CallKitBridge._();

  // ── streams (home_shell 订阅) ──────────────────────────────────────
  final StreamController<CallKitAction> _acceptController =
      StreamController<CallKitAction>.broadcast();
  final StreamController<CallKitAction> _declineController =
      StreamController<CallKitAction>.broadcast();
  final StreamController<CallKitAction> _endController =
      StreamController<CallKitAction>.broadcast();
  final StreamController<String> _voipTokenController =
      StreamController<String>.broadcast();

  /// 订阅 accept/decline/end 时如果有 pending action (HomeShell listener
  /// 还没起来时 plugin 已经 fire), 立即 replay 给新 subscriber. 解决 cold
  /// -start FCM data 唤醒 → app 启动 → 用户点 accept 早于 home_shell mount
  /// 一通通话, 单事件够用).
  Stream<CallKitAction> get onAccept async* {
    final pending = _pendingAccept;
    _pendingAccept = null;
    if (pending != null) yield pending;
    yield* _acceptController.stream;
  }

  Stream<CallKitAction> get onDecline async* {
    final pending = _pendingDecline;
    _pendingDecline = null;
    if (pending != null) yield pending;
    yield* _declineController.stream;
  }

  Stream<CallKitAction> get onEnd async* {
    final pending = _pendingEnd;
    _pendingEnd = null;
    if (pending != null) yield pending;
    yield* _endController.stream;
  }

  CallKitAction? _pendingAccept;
  CallKitAction? _pendingDecline;
  CallKitAction? _pendingEnd;

  /// 程序触发的 endCall (e.g. accept 完成 / 对端 CMD 到达) 期望 plugin
  /// fire 一条 actionCallEnded 回来. 加这个 set 让 _handleEvent 识别这条
  /// "echo end" → 只清 UI state, 不再走 _endController 触发业务 hangup.
  ///
  /// 没这个判断 → 我们 accept 后 endCall 自己 → plugin 触发 ended →
  /// _handleCallKitEnd 误判用户挂断 → POST hangup → 对端立即结束 + 本端
  /// 也立即结束 (用户报"接听通了立马挂断卡死"根因).
  ///
  /// Set 是 hot path, 一般 1-2 个 uuid; 加 cap 防异常分支累积.
  final Set<String> _expectedEndUuids = <String>{};
  static const int _expectedEndUuidsMax = 8;

  /// iOS VoIP push token (PKPushRegistry didUpdate). backend cert 配好后用来
  /// 注册到 server (跟普通 APNS token 路径平行 — server 区分 alert vs voip
  /// topic). 现阶段先 expose stream, 等 backend 接通时 push_service 订阅.
  Stream<String> get onVoipTokenChange => _voipTokenController.stream;

  String _currentVoipToken = '';
  String get currentVoipToken => _currentVoipToken;

  StreamSubscription<CallEvent?>? _eventSub;
  bool _initialized = false;

  /// 当前活跃的 CallKit incoming uuid (单通话 in flight). 用来 end-all-from-
  /// caller-side. **chatim 同时只允许一通来电** (home_shell `_incomingCallVisible`
  /// guard), 单值够用.
  String _activeUuid = '';
  Map<String, dynamic> _activeExtra = const <String, dynamic>{};

  // ── init / dispose ──────────────────────────────────────────────────
  /// HomeShell.initState 时调 (login 后, 至少在 _onIncomingCallEvent listener
  /// 之前). 重复调 idempotent.
  ///
  /// **重要 race**: PKPushRegistry 在 AppDelegate.didFinishLaunchingWithOptions
  /// 已经 init, Apple 异步回调 didUpdate token 可能**早于** CallKitBridge
  /// initialize() 被调 (cold-start 时 Flutter engine boot + Dart runApp 之前).
  /// plugin event channel 不 buffer, 这一次 token event 会丢. 兜底: 主动调
  /// plugin `getDevicePushTokenVoIP()` 拉 cached token, 跟 event listen 双
  /// 通道, 任一拿到都 emit. push_service _subscribeVoipToken 还会 listen +
  /// 二次 fetch (currentVoipToken) 三道保险.
  Future<void> initialize() async {
    if (kCallKitDisabled) {
      debugPrint('[callkit] kCallKitDisabled=true, initialize() no-op');
      return;
    }
    if (_initialized) return;
    _initialized = true;
    _eventSub = FlutterCallkitIncoming.onEvent.listen(_handleEvent);
    debugPrint('[callkit] bridge initialized');
    // 主动 poll cached VoIP token — 防 event channel race.
    try {
      final cached = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
      if (cached is String && cached.isNotEmpty) {
        if (cached != _currentVoipToken) {
          _currentVoipToken = cached;
          if (!_voipTokenController.isClosed) {
            _voipTokenController.add(cached);
          }
        }
        debugPrint('[callkit] polled voip token len=${cached.length}');
      } else {
        debugPrint(
          '[callkit] no cached voip token yet (will arrive via event)',
        );
      }
    } catch (e) {
      debugPrint('[callkit] getDevicePushTokenVoIP failed: $e');
    }
  }

  /// HomeShell.dispose / logout 时调.
  Future<void> dispose() async {
    await _eventSub?.cancel();
    _eventSub = null;
    _initialized = false;
    try {
      await FlutterCallkitIncoming.endAllCalls();
    } catch (_) {}
    _activeUuid = '';
    _activeExtra = const <String, dynamic>{};
  }

  // ── intent API ──────────────────────────────────────────────────────

  /// 把一个 IncomingCallEvent 转成稳定的 UUID. 同一通通话始终算出同一
  /// UUID, 接听 → end CallKit UI 才能匹配上. CallKit / ConnectionService
  /// 都要求 RFC4122 v4 格式 `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` (32
  /// hex + 4 dash).
  ///
  /// **优先用 callInstanceId** (server invoke 时生成的 uuid, 一次通话唯一);
  /// 回退用 (fromUid + roomId) — 老版 server / cache miss. P2P deterministic
  static String uuidFor(IncomingCallEvent event) {
    final String key;
    if (event.callInstanceId.isNotEmpty) {
      key = 'call:${event.callInstanceId}';
    } else if (event.isGroupCall) {
      key = 'group:${event.roomId}';
    } else {
      key = 'p2p:${event.fromUid}:${event.roomId}';
    }
    final hash = md5.convert(utf8.encode(key)).toString();
    return '${hash.substring(0, 8)}-${hash.substring(8, 12)}-'
        '${hash.substring(12, 16)}-${hash.substring(16, 20)}-'
        '${hash.substring(20, 32)}';
  }

  @visibleForTesting
  static String safeDisplayNameFor({
    required IncomingCallEvent event,
    required String displayName,
  }) {
    return moyuIncomingCallTitle(
      isGroupCall: event.isGroupCall,
      payloadName: displayName,
      rawIdentity: event.isGroupCall ? event.groupChannelId : event.fromUid,
    );
  }

  /// 弹系统来电 UI. home_shell._onIncomingCallEvent invoke case 调.
  ///
  /// - [displayName]: 来电方显示名 (P2P=对方名 / group=群名). home_shell
  ///   已经做完 name resolution (走 moyuIncomingCallTitle), 这里直接用.
  /// - [avatarUrl]: 全 URL (不是相对路径). iOS 不展示, Android 全屏来电界面
  ///   会用. 空串 OK.
  Future<void> showIncoming({
    required IncomingCallEvent event,
    required String displayName,
    String avatarUrl = '',
  }) async {
    if (kCallKitDisabled) {
      debugPrint('[callkit] kCallKitDisabled=true, showIncoming() no-op');
      return;
    }
    final uuid = uuidFor(event);
    final extra = <String, dynamic>{
      'fromUid': event.fromUid,
      'fromName': event.fromName,
      'roomId': event.roomId,
      'isGroup': event.isGroupCall,
      'groupChannelId': event.groupChannelId,
      'groupChannelType': event.groupChannelType,
      'callType': event.callType,
      'callInstanceId': event.callInstanceId,
    };
    _activeUuid = uuid;
    _activeExtra = extra;
    final safeDisplayName = safeDisplayNameFor(
      event: event,
      displayName: displayName,
    );
    final params = CallKitParams(
      id: uuid,
      nameCaller: safeDisplayName,
      appName: AppBrand.displayName,
      avatar: avatarUrl,
      handle: event.isGroupCall ? event.groupChannelId : event.fromUid,
      // 0 = audio, 1 = video — 跟 IncomingCallEvent.callType 一致.
      type: event.callType,
      // ringing 超时 — 跟 CallSessionController.ringingTimeout (60s) 对齐.
      duration: 60000,
      textAccept: '接听',
      textDecline: '拒绝',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: false,
        subtitle: '未接来电',
      ),
      extra: extra,
      ios: IOSParams(
        iconName: 'AppIcon',
        handleType: 'generic',
        supportsVideo: event.callType == 1,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        configureAudioSession: true,
        supportsDTMF: false,
        supportsHolding: false,
        supportsGrouping: false,
        supportsUngrouping: false,
        // 跟 assets 里的 call.aac (语音邀请铃声) 对齐 — IOSParams.ringtonePath
        // 必须是 bundle 内文件名, plugin 会在 Resources 内查找. 用项目已
        // bundle 的 call.aac.
        ringtonePath: 'call.aac',
      ),
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        isShowCallID: false,
        ringtonePath: 'call',
        backgroundColor: '#0955fa',
        actionColor: '#4CAF50',
        textColor: '#ffffff',
        incomingCallNotificationChannelName: 'Incoming Call',
        missedCallNotificationChannelName: 'Missed Call',
        isShowFullLockedScreen: true,
        isImportant: true,
      ),
    );
    try {
      await FlutterCallkitIncoming.showCallkitIncoming(params);
      debugPrint(
        '[callkit] showIncoming uuid=$uuid name=$safeDisplayName '
        'isVideo=${event.callType == 1}',
      );
    } catch (e, st) {
      debugPrint('[callkit] showIncoming failed: $e\n$st');
    }
  }

  /// 来电被 cancel / 自己 refuse / accept 后转给 _CallPage / timeout → 关掉
  /// 系统 UI. 传 event 让 uuid 对得上; 没传就关 active uuid.
  ///
  /// **会触发 plugin fire actionCallEnded 回来** — 主动标记 expectedEnd
  /// 让 _handleEvent 知道这是我们自己 end, 不再 fire _endController (否则
  /// _handleCallKitEnd 误判用户系统挂断走 POST hangup → 双方挂).
  Future<void> endCall({IncomingCallEvent? event}) async {
    if (kCallKitDisabled) return;
    final uuid = event != null ? uuidFor(event) : _activeUuid;
    if (uuid.isEmpty) return;
    _markExpectedEnd(uuid);
    try {
      await FlutterCallkitIncoming.endCall(uuid);
      debugPrint('[callkit] endCall uuid=$uuid (expected)');
    } catch (e) {
      debugPrint('[callkit] endCall failed: $e');
    }
    if (uuid == _activeUuid) {
      _activeUuid = '';
      _activeExtra = const <String, dynamic>{};
    }
  }

  void _markExpectedEnd(String uuid) {
    if (uuid.isEmpty) return;
    _expectedEndUuids.add(uuid);
    // FIFO cap — 8 个之外的最旧的 drop.
    while (_expectedEndUuids.length > _expectedEndUuidsMax) {
      _expectedEndUuids.remove(_expectedEndUuids.first);
    }
  }

  /// 标记 CallKit / ConnectionService 通话已 connected — 给 iOS CXProvider
  /// + Android Telecom 跟进 audio session lifecycle. plugin setCallConnected
  /// 内部走 CallKit `provider.reportOutgoingCall(uuid, connectedAt:)` 或
  /// ConnectionService `setActive()`. 没 markConnected 就 endCall → iOS 直接
  /// 评审根因 #4).
  ///
  /// 调用时机: gateway.accept 成功 + LiveKit 已 join room. 之后 _CallPage
  /// 接管 UI; CallKit 在系统层"通话中"状态停留, 直到我方 hangup 调 endCall
  /// 真正终止.
  Future<void> markConnected({IncomingCallEvent? event}) async {
    if (kCallKitDisabled) return;
    final uuid = event != null ? uuidFor(event) : _activeUuid;
    if (uuid.isEmpty) return;
    try {
      await FlutterCallkitIncoming.setCallConnected(uuid);
      debugPrint('[callkit] markConnected uuid=$uuid');
    } catch (e) {
      debugPrint('[callkit] markConnected failed: $e');
    }
  }

  /// logout / 切账号 nuclear option — 关掉所有挂着的 CallKit UI.
  Future<void> endAllCalls() async {
    if (kCallKitDisabled) return;
    try {
      await FlutterCallkitIncoming.endAllCalls();
    } catch (_) {}
    _activeUuid = '';
    _activeExtra = const <String, dynamic>{};
  }

  // ── event handler ───────────────────────────────────────────────────
  void _handleEvent(CallEvent? event) {
    if (event == null) return;
    final body = event.body;
    final id = (body is Map && body['id'] is String)
        ? body['id'] as String
        : '';
    // plugin event payload 把 [showIncoming] 传的 `extra` map 原样回传.
    final Map<String, dynamic> extra = (body is Map && body['extra'] is Map)
        ? Map<String, dynamic>.from(body['extra'] as Map)
        : Map<String, dynamic>.from(_activeExtra);
    final action = CallKitAction(uuid: id, extra: extra);
    debugPrint('[callkit] event=${event.event} id=$id extra=$extra');
    switch (event.event) {
      case Event.actionDidUpdateDevicePushTokenVoip:
        // iOS PushKit registry didUpdate → plugin 转发 token (hex string).
        final token = body is String ? body : (body['token']?.toString() ?? '');
        if (token.isNotEmpty && token != _currentVoipToken) {
          _currentVoipToken = token;
          if (!_voipTokenController.isClosed) {
            _voipTokenController.add(token);
          }
        }
      case Event.actionCallAccept:
        // 缓存 pending — 防 HomeShell 还没 listen 时丢事件 (cold-start race).
        // 后到的覆盖前一条 (同一通通话只一次有效 accept). 新 subscriber 走
        // onAccept getter 时立即 yield + 清.
        _pendingAccept = action;
        if (!_acceptController.isClosed && _acceptController.hasListener) {
          _acceptController.add(action);
          _pendingAccept = null;
        }
      case Event.actionCallDecline:
        _pendingDecline = action;
        if (!_declineController.isClosed && _declineController.hasListener) {
          _declineController.add(action);
          _pendingDecline = null;
        }
      case Event.actionCallEnded:
      case Event.actionCallTimeout:
        // 区分: 用户系统挂断 (status bar / Dynamic Island) → 走业务 hangup;
        // 程序 endCall echo → 只清 state 不走 hangup. expectedEnd set 是
        // 我们自己 endCall 时 mark 的, 命中即跳过 _endController fire.
        final isExpected = id.isNotEmpty && _expectedEndUuids.remove(id);
        if (isExpected) {
          debugPrint(
            '[callkit] ended echo for our endCall uuid=$id (skip business hangup)',
          );
        } else {
          _pendingEnd = action;
          if (!_endController.isClosed && _endController.hasListener) {
            _endController.add(action);
            _pendingEnd = null;
          }
        }
        if (id.isNotEmpty && id == _activeUuid) {
          _activeUuid = '';
          _activeExtra = const <String, dynamic>{};
        }
      case Event.actionCallIncoming:
      case Event.actionCallStart:
      case Event.actionCallConnected:
      case Event.actionCallCallback:
      case Event.actionCallToggleHold:
      case Event.actionCallToggleMute:
      case Event.actionCallToggleDmtf:
      case Event.actionCallToggleGroup:
      case Event.actionCallToggleAudioSession:
      case Event.actionCallCustom:
        // 这些目前不需要 home_shell 反应 (mute / hold etc. iOS-only,
        // 不强求 sync; chatim 用 in-app UI 控 mute).
        break;
    }
  }
}
