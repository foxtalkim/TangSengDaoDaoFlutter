// Android FCM 后台 RTC invite handler — 唤醒系统级 CallKit / ConnectionService
// 来电界面 (锁屏 + 杀进程都能唤起).
//
// 触发链:
//   1. server 通过 FCM 发 high-priority data message, payload 字段:
//        cmd: "rtc.p2p.invoke" / "room.invoke"
//        id: "<UUID, 跟 Dart CallKitBridge.uuidFor 算出来的同款>"
//        name_caller: 显示名 (server 解出 fromUid 对应的 nickname)
//        handle: from_uid (P2P) 或 group_channel_id (group)
//        is_video: "true" / "false" (FCM data 全是 string)
//        from_uid / from_name / room_id / channel_id / channel_type /
//        call_type: 原 IM CMD 同款语义
//   2. Android FCM 收到 high-priority data → 启 background isolate 跑这个
//      top-level 函数 (主 isolate 可能根本没 start)
//   3. 函数调 FlutterCallkitIncoming.showCallkitIncoming → plugin 启
//      ConnectionService 弹全屏来电
//   4. 用户接听 → app 启动, CallKitBridge subscribe plugin event channel →
//      路由到 home_shell → gateway.accept
//
// **现阶段 backend 还没推 high-priority data with `cmd: rtc.p2p.invoke`,
// 这个 handler 是 dead code 等 backend 接通**. 加上去之后, server 改一条
// FCM 推送代码即可启用.
//
// 对应 iOS 路径: ios/Runner/AppDelegate.swift pushRegistry
// didReceiveIncomingPushWith (走 PushKit + plugin showCallkitIncoming
// fromPushKit:true), 设计对称.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import '../config/app_brand.dart';
import '../ui/identity_display.dart';

/// **必须** top-level + `@pragma('vm:entry-point')` — FirebaseMessaging
/// 后台 isolate 通过 lookup function ptr 调起, 没 `vm:entry-point` Dart AOT
/// 编译会 tree-shake 掉.
@pragma('vm:entry-point')
Future<void> foxtalkFcmBackgroundHandler(RemoteMessage message) async {
  final data = message.data;
  final cmd = (data['cmd'] as String?) ?? '';
  // 只处理 RTC 邀请类 — 普通聊天消息走 IM 长连接 + flutter_local_notifications,
  // background isolate 没必要弹 CallKit.
  if (cmd != 'rtc.p2p.invoke' && cmd != 'room.invoke') {
    return;
  }
  final isGroup = cmd == 'room.invoke';
  final id = (data['id'] as String?) ?? '';
  final fromUid = (data['from_uid'] as String?) ?? '';
  final fromName = (data['from_name'] as String?) ?? '';
  final handle =
      (data['handle'] as String?) ??
      (isGroup ? (data['channel_id'] as String? ?? '') : fromUid);
  final groupChannelId = isGroup ? (data['channel_id'] as String? ?? '') : '';
  final nameCaller = moyuIncomingCallTitle(
    isGroupCall: isGroup,
    payloadName: (data['name_caller'] as String?) ?? '',
    cachedName: fromName,
    rawIdentity: isGroup ? groupChannelId : fromUid,
  );
  final callTypeStr = (data['call_type'] as String?) ?? '0';
  final callType = int.tryParse(callTypeStr) ?? 0;
  final isVideo =
      callType == 1 || (data['is_video'] as String?)?.toLowerCase() == 'true';
  // id 是 server 算的, 跟 CallKitBridge.uuidFor 同 hash 规则. 空 → 用 fromUid
  // 兜底 (CallKit 必须有 id, 但 server 端永远应该填). 真不行至少不崩.
  final uuid = id.isNotEmpty
      ? id
      : '$fromUid-${DateTime.now().millisecondsSinceEpoch}';
  debugPrint(
    '[fcm-bg] RTC invite handler: cmd=$cmd uuid=$uuid name=$nameCaller '
    'fromUid=$fromUid isVideo=$isVideo',
  );
  final params = CallKitParams(
    id: uuid,
    nameCaller: nameCaller,
    appName: AppBrand.displayName,
    handle: handle,
    type: isVideo ? 1 : 0,
    duration: 60000,
    textAccept: '接听',
    textDecline: '拒绝',
    missedCallNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: false,
      subtitle: '未接来电',
    ),
    extra: <String, dynamic>{
      // 跟 CallKitBridge.showIncoming 同款 extra schema, 让 plugin event
      // payload 把 extra 回传 home_shell 时 _handleCallKitAccept 可以
      // reconstruct event 走 gateway.accept/refuse.
      'fromUid': fromUid,
      'fromName': fromName,
      'roomId': (data['room_id'] as String?) ?? '',
      'isGroup': isGroup,
      'groupChannelId': groupChannelId,
      'groupChannelType':
          int.tryParse(data['channel_type'] as String? ?? '0') ?? 0,
      'callType': callType,
      'callInstanceId': (data['call_instance_id'] as String?) ?? '',
    },
    ios: IOSParams(
      iconName: 'AppIcon',
      handleType: 'generic',
      supportsVideo: isVideo,
      maximumCallGroups: 1,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      configureAudioSession: true,
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
  } catch (e, st) {
    debugPrint('[fcm-bg] showCallkitIncoming failed: $e\n$st');
  }
}
