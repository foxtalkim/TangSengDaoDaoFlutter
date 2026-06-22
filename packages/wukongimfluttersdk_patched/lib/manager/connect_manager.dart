import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:wukongimfluttersdk/db/const.dart';

import 'package:wukongimfluttersdk/db/wk_db_helper.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/channel_member.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/proto/write_read.dart';
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:wukongimfluttersdk/common/crypto_utils.dart';
import '../common/logs.dart';
import '../entity/conversation.dart';
import '../proto/packet.dart';
import '../proto/proto.dart';
import '../type/const.dart';

class _WKSocket {
  Socket? _socket; // 将 _socket 声明为可空类型
  WebSocket? _webSocket;
  bool _isListening = false;
  static _WKSocket? _instance;
  _WKSocket._internal({Socket? socket, WebSocket? webSocket})
      : _socket = socket,
        _webSocket = webSocket;

  factory _WKSocket.newSocket(Socket socket) {
    if (_instance != null) {
      // 销毁旧的 socket
      _instance!._destroySocket();
    }
    _instance = _WKSocket._internal(socket: socket);
    return _instance!;
  }

  factory _WKSocket.newWebSocket(WebSocket socket) {
    if (_instance != null) {
      _instance!._destroySocket();
    }
    _instance = _WKSocket._internal(webSocket: socket);
    return _instance!;
  }

  /// 内部方法：仅销毁 socket，不清除实例
  void _destroySocket() {
    _isListening = false;
    try {
      _socket?.close();
      _webSocket?.close();
    } catch (e) {
      Logs.debug('关闭socket错误: $e');
    } finally {
      _socket = null;
      _webSocket = null;
    }
  }

  void close() {
    _isListening = false;
    _instance = null;
    try {
      _socket?.close();
      _webSocket?.close();
      // _socket?.destroy();
    } finally {
      _socket = null; // 现在可以将 _socket 设置为 null
      _webSocket = null;
    }
  }

  send(Uint8List data) {
    try {
      if (_socket?.remotePort != null) {
        _socket?.add(data); // 使用安全调用操作符
        return _socket?.flush();
      }
      if (_webSocket?.readyState == WebSocket.open) {
        _webSocket?.add(data);
        return Future.value();
      }
    } catch (e) {
      Logs.debug('发送消息错误$e');
    }
  }

  void listen(void Function(Uint8List data) onData, void Function() error) {
    if (_isListening) {
      return;
    }
    final socket = _socket;
    final webSocket = _webSocket;
    if (socket != null) {
      var handledDisconnect = false;
      void handleDisconnect([Object? err]) {
        if (handledDisconnect) {
          return;
        }
        handledDisconnect = true;
        if (err != null) {
          Logs.debug('socket断开了${err.toString()}');
        } else {
          Logs.debug('socket断开了');
        }
        close();
        error();
      }

      socket.listen(
        onData,
        onError: (err) {
          handleDisconnect(err);
        },
        onDone: handleDisconnect,
      );
      _isListening = true;
    } else if (webSocket != null) {
      var handledDisconnect = false;
      void handleDisconnect([Object? err]) {
        if (handledDisconnect) {
          return;
        }
        handledDisconnect = true;
        if (err != null) {
          Logs.debug('websocket断开了${err.toString()}');
        } else {
          Logs.debug('websocket断开了');
        }
        close();
        error();
      }

      webSocket.listen(
        (dynamic data) {
          if (data is Uint8List) {
            onData(data);
          } else if (data is List<int>) {
            onData(Uint8List.fromList(data));
          } else if (data is String) {
            onData(Uint8List.fromList(utf8.encode(data)));
          }
        },
        onError: (err) {
          handleDisconnect(err);
        },
        onDone: handleDisconnect,
      );
      _isListening = true;
    }
  }
}

class WKConnectionManager {
  WKConnectionManager._privateConstructor();
  static final WKConnectionManager _instance =
      WKConnectionManager._privateConstructor();
  static WKConnectionManager get shared => _instance;
  // bool _isLogout = false;
  bool isDisconnection = false;
  bool isReconnection = false;
  bool isNetworkUnavailable = false;
  static const List<int> _reconnectDelaySeconds = [1, 2, 4, 8, 16, 30];
  int _activeConnectId = 0;
  bool _connecting = false;
  int _reconnectAttempt = 0;
  Timer? _reconnectTimer;
  Timer? heartTimer;
  Timer? checkNetworkTimer;
  final heartIntervalSecond = const Duration(seconds: 20);
  final checkNetworkSecond = const Duration(seconds: 1);
  int unReceivePongCount = 0;
  final LinkedHashMap<int, SendingMsg> _sendingMsgMap = LinkedHashMap();
  HashMap<String, Function(int, int?, ConnectionInfo?)>? _connectionListenerMap;
  _WKSocket? _socket;
  ConnectivityResult? lastConnectivityResult;
  final Connectivity _connectivity = Connectivity();

  addOnConnectionStatus(String key, Function(int, int?, ConnectionInfo?) back) {
    _connectionListenerMap ??= HashMap();
    _connectionListenerMap![key] = back;
  }

  removeOnConnectionStatus(String key) {
    if (_connectionListenerMap != null) {
      _connectionListenerMap!.remove(key);
    }
  }

  setConnectionStatus(int status, {int? reasoncode, ConnectionInfo? info}) {
    if (_connectionListenerMap != null) {
      _connectionListenerMap!.forEach((key, back) {
        back(status, reasoncode, info);
      });
    }
  }

  connect({bool resetBackoff = true}) {
    if (_connecting) {
      Logs.debug("连接中，跳过重复connect");
      return;
    }
    var addr = WKIM.shared.options.addr;
    if ((addr == null || addr == "") && WKIM.shared.options.getAddr == null) {
      Logs.info("没有配置addr！");
      return;
    }
    if (WKIM.shared.options.uid == "" ||
        WKIM.shared.options.uid == null ||
        WKIM.shared.options.token == "" ||
        WKIM.shared.options.token == null) {
      Logs.error("没有初始化uid或token");
      return;
    }
    if (isNetworkUnavailable) {
      isReconnection = true;
      Logs.debug("网络不可用，等待网络恢复后重连");
      return;
    }
    if (resetBackoff) {
      _resetReconnectBackoff();
    }
    final connectId = ++_activeConnectId;
    _cancelReconnectTimer();
    disconnect(false, invalidateConnect: false);
    isDisconnection = false;
    _connecting = true;
    if (WKIM.shared.options.getAddr != null) {
      try {
        final result = WKIM.shared.options.getAddr!((String addr) {
          if (!_isActiveConnect(connectId)) {
            return;
          }
          _socketConnect(addr, connectId);
        });
        if (result is Future) {
          result.catchError((err) {
            _connectFail(err, connectId);
          });
        }
      } catch (err) {
        _connectFail(err, connectId);
      }
    } else {
      _socketConnect(addr!, connectId);
    }
  }

  disconnect(bool isLogout, {bool invalidateConnect = true}) {
    if (invalidateConnect) {
      _activeConnectId++;
    }
    _connecting = false;
    if (invalidateConnect || isLogout) {
      _resetReconnectBackoff();
    }
    _cancelReconnectTimer();
    isDisconnection = true;
    if (_socket != null) {
      _socket!.close();
    }
    if (isLogout) {
      // _isLogout = true;
      WKIM.shared.options.uid = '';
      WKIM.shared.options.token = '';
      WKIM.shared.messageManager.updateSendingMsgFail();
      WKDBHelper.shared.close();
    }
    _closeAll();
    WKIM.shared.connectionManager.setConnectionStatus(WKConnectStatus.fail);
  }

  bool _isActiveConnect(int connectId) {
    return connectId == _activeConnectId && !isDisconnection;
  }

  _socketConnect(String addr, int connectId) {
    if (!_isActiveConnect(connectId)) {
      return;
    }
    Logs.info("连接地址--->$addr");
    if (addr == '') {
      _connectFail('连接地址为空', connectId);
      return;
    }
    if (_isWebSocketAddress(addr)) {
      _webSocketConnect(addr, connectId);
      return;
    }
    var addrs = addr.split(":");
    if (addrs.length < 2) {
      _connectFail('连接地址格式错误:$addr', connectId);
      return;
    }
    var host = addrs[0];
    var port = addrs[1];
    try {
      setConnectionStatus(WKConnectStatus.connecting);
      Socket.connect(host, int.parse(port), timeout: const Duration(seconds: 5))
          .then((socket) {
        if (!_isActiveConnect(connectId)) {
          socket.close();
          return;
        }
        _socket = _WKSocket.newSocket(socket);
        _connectSuccess(connectId);
      }).catchError((err) {
        _connectFail(err, connectId);
      }).onError((err, stackTrace) {
        _connectFail(err, connectId);
      });
    } catch (e) {
      Logs.error(e.toString());
      _connectFail(e, connectId);
    }
  }

  bool _isWebSocketAddress(String addr) {
    final lower = addr.trim().toLowerCase();
    return lower.startsWith('ws://') || lower.startsWith('wss://');
  }

  _webSocketConnect(String addr, int connectId) {
    try {
      setConnectionStatus(WKConnectStatus.connecting);
      WebSocket.connect(addr)
          .timeout(const Duration(seconds: 5))
          .then((socket) {
        if (!_isActiveConnect(connectId)) {
          socket.close();
          return;
        }
        _socket = _WKSocket.newWebSocket(socket);
        _connectSuccess(connectId);
      }).catchError((err) {
        _connectFail(err, connectId);
      }).onError((err, stackTrace) {
        _connectFail(err, connectId);
      });
    } catch (e) {
      Logs.error(e.toString());
      _connectFail(e, connectId);
    }
  }

  // socket 连接成功
  _connectSuccess(int connectId) {
    if (!_isActiveConnect(connectId)) {
      return;
    }
    // 监听消息
    _socket?.listen(
      (Uint8List data) {
        if (!_isActiveConnect(connectId)) {
          return;
        }
        _cutDatas(data);
        // _decodePacket(data);
      },
      () {
        _scheduleReconnect(connectId, "socket断开");
      },
    );
    // 发送连接包
    _sendConnectPacket();
  }

  _connectFail(error, int connectId) {
    if (!_isActiveConnect(connectId)) {
      return;
    }
    Logs.debug("连接失败，准备重连: $error");
    _scheduleReconnect(connectId, error.toString());
  }

  _scheduleReconnect(int connectId, String reason) {
    if (!_isActiveConnect(connectId)) {
      Logs.debug("旧连接回调忽略: $reason");
      return;
    }
    if (isDisconnection) {
      Logs.debug("登出了");
      return;
    }
    _connecting = false;
    if (isNetworkUnavailable) {
      isReconnection = true;
      setConnectionStatus(WKConnectStatus.noNetwork);
      Logs.debug("网络不可用，暂停重连: $reason");
      return;
    }
    if (_reconnectTimer?.isActive ?? false) {
      Logs.debug("已有重连任务，跳过: $reason");
      return;
    }
    final delay = _nextReconnectDelay();
    Logs.debug("安排重连: ${delay.inSeconds}s reason=$reason");
    _reconnectTimer = Timer(delay, () {
      if (!_isActiveConnect(connectId)) {
        return;
      }
      connect(resetBackoff: false);
    });
  }

  Duration _nextReconnectDelay() {
    final index = _reconnectAttempt < _reconnectDelaySeconds.length
        ? _reconnectAttempt
        : _reconnectDelaySeconds.length - 1;
    _reconnectAttempt++;
    return Duration(seconds: _reconnectDelaySeconds[index]);
  }

  _resetReconnectBackoff() {
    _reconnectAttempt = 0;
  }

  _cancelReconnectTimer() {
    if (_reconnectTimer != null) {
      _reconnectTimer!.cancel();
      _reconnectTimer = null;
    }
  }

  _closeSocketBeforeReconnect(String reason) {
    Logs.debug("关闭旧socket后重连: $reason");
    _stopHeartTimer();
    if (_socket != null) {
      _socket!.close();
      _socket = null;
    }
  }

  testCutData(Uint8List data) {
    _cutDatas(data);
  }

  Uint8List? _cacheData;
  _cutDatas(Uint8List data) {
    if (_cacheData == null || _cacheData!.isEmpty) {
      _cacheData = data;
    } else {
      // 上次存在未解析完的消息
      Uint8List temp = Uint8List(_cacheData!.length + data.length);
      for (var i = 0; i < _cacheData!.length; i++) {
        temp[i] = _cacheData![i];
      }
      for (var i = 0; i < data.length; i++) {
        temp[i + _cacheData!.length] = data[i];
      }
      _cacheData = temp;
    }
    Uint8List lastMsgBytes = _cacheData!;
    int readLength = 0;
    while (lastMsgBytes.isNotEmpty && readLength != lastMsgBytes.length) {
      readLength = lastMsgBytes.length;
      ReadData readData = ReadData(lastMsgBytes);
      var b = readData.readUint8();
      var packetType = b >> 4;
      if (packetType < PacketType.values.length &&
          PacketType.values[packetType] == PacketType.pong) {
        Logs.debug('pong');
        unReceivePongCount = 0;
        Uint8List bytes = lastMsgBytes.sublist(1, lastMsgBytes.length);
        _cacheData = lastMsgBytes = bytes;
      } else {
        if (packetType < PacketType.values.length) {
          if (lastMsgBytes.length < 5) {
            _cacheData = lastMsgBytes;
            break;
          }
          int remainingLength = readData.readVariableLength();
          if (remainingLength == -1) {
            //剩余长度被分包
            _cacheData = lastMsgBytes;
            break;
          }
          if (remainingLength > 1 << 21) {
            _cacheData = null;
            break;
          }
          List<int> bytes = encodeVariableLength(remainingLength);

          if (remainingLength + 1 + bytes.length > lastMsgBytes.length) {
            //半包情况
            _cacheData = lastMsgBytes;
          } else {
            Uint8List msg = lastMsgBytes.sublist(
              0,
              remainingLength + 1 + bytes.length,
            );
            _decodePacket(msg);
            Uint8List temps = lastMsgBytes.sublist(
              msg.length,
              lastMsgBytes.length,
            );
            _cacheData = lastMsgBytes = temps;
          }
        } else {
          _cacheData = null;
          // 数据包错误，重连
          _scheduleReconnect(_activeConnectId, "数据包错误");
          break;
        }
      }
    }
  }

  _decodePacket(Uint8List data) {
    var packet = WKIM.shared.options.proto.decode(data);
    Logs.debug('解码出包->$packet');
    if (packet is UnsupportedPacket) {
      return;
    }
    unReceivePongCount = 0;
    if (packet.header.packetType == PacketType.connack) {
      var connackPacket = packet as ConnackPacket;
      if (connackPacket.reasonCode == 1) {
        Logs.debug('连接成功！');
        _connecting = false;
        isReconnection = false;
        unReceivePongCount = 0;
        _resetReconnectBackoff();
        _cancelReconnectTimer();
        WKIM.shared.options.protoVersion = connackPacket.serviceProtoVersion;
        CryptoUtils.setServerKeyAndSalt(
          connackPacket.serverKey,
          connackPacket.salt,
        );
        setConnectionStatus(
          WKConnectStatus.success,
          reasoncode: connackPacket.reasonCode,
          info: ConnectionInfo(connackPacket.nodeId),
        );
        // Future.delayed(Duration(seconds: 1), () {

        // });
        try {
          WKIM.shared.conversationManager.setSyncConversation(() {
            setConnectionStatus(WKConnectStatus.syncCompleted);
            _resendMsg();
          });
        } catch (e) {
          Logs.error(e.toString());
        }

        _startHeartTimer();
        _startCheckNetworkTimer();
      } else {
        _connecting = false;
        setConnectionStatus(
          WKConnectStatus.fail,
          reasoncode: connackPacket.reasonCode,
        );
        Logs.debug('连接失败！错误->${connackPacket.reasonCode}');
        _scheduleReconnect(
            _activeConnectId, "connack:${connackPacket.reasonCode}");
      }
    } else if (packet.header.packetType == PacketType.recv) {
      Logs.debug('收到消息');
      var recvPacket = packet as RecvPacket;
      _verifyRecvMsg(recvPacket);
      if (!recvPacket.header.noPersist) {
        _sendReceAckPacket(
          recvPacket.messageID,
          recvPacket.messageSeq,
          recvPacket.header,
        );
      }
    } else if (packet.header.packetType == PacketType.sendack) {
      var sendack = packet as SendAckPacket;
      Logs.debug('发送结果：${sendack.reasonCode}');
      WKIM.shared.messageManager.updateSendResult(
        sendack.messageID,
        sendack.clientSeq,
        sendack.messageSeq,
        sendack.reasonCode,
      );
      if (_sendingMsgMap.containsKey(sendack.clientSeq)) {
        _sendingMsgMap[sendack.clientSeq]!.isCanResend = false;
      }
    } else if (packet.header.packetType == PacketType.event) {
      WKIM.shared.eventManager.pushEvent(packet as EventPacket);
    } else if (packet.header.packetType == PacketType.disconnect) {
      disconnect(true);
      // _closeAll();
      setConnectionStatus(WKConnectStatus.kicked);
    } else if (packet.header.packetType == PacketType.pong) {
      Logs.info('pong...');
    }
  }

  _closeAll() {
    // _isLogout = true;
    // WKIM.shared.options.uid = '';
    // WKIM.shared.options.token = '';
    // WKIM.shared.messageManager.updateSendingMsgFail();
    _stopCheckNetworkTimer();
    _stopHeartTimer();
    if (_socket != null) {
      _socket!.close();
    }

    // WKDBHelper.shared.close();
  }

  _sendReceAckPacket(BigInt messageID, int messageSeq, PacketHeader header) {
    RecvAckPacket ackPacket = RecvAckPacket();
    ackPacket.header.noPersist = header.noPersist;
    ackPacket.header.syncOnce = header.syncOnce;
    ackPacket.header.showUnread = header.showUnread;
    ackPacket.messageID = messageID;
    ackPacket.messageSeq = messageSeq;
    _sendPacket(ackPacket);
  }

  _sendConnectPacket() async {
    CryptoUtils.init();
    var deviceID = await _getDeviceID();
    var connectPacket = ConnectPacket(
      uid: WKIM.shared.options.uid!,
      token: WKIM.shared.options.token!,
      version: WKIM.shared.options.protoVersion,
      clientKey: base64Encode(CryptoUtils.dhPublicKey!),
      deviceID: deviceID,
      clientTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
    connectPacket.deviceFlag = WKIM.shared.deviceFlagApp;
    _sendPacket(connectPacket);
  }

  _sendPacket(Packet packet) async {
    var data = WKIM.shared.options.proto.encode(packet);
    if (!isReconnection) {
      await _socket?.send(data);
    }
  }

  _startCheckNetworkTimer() {
    _stopCheckNetworkTimer();
    checkNetworkTimer = Timer.periodic(checkNetworkSecond, (timer) {
      var connectivityResult = _connectivity.checkConnectivity();
      connectivityResult.then((value) {
        /**
         * 经过查阅 connectivity_plus 官方文档和源码确认：                                                                                                   
          checkConnectivity() 返回的 List<ConnectivityResult> 中，ConnectivityResult.none 只会单独出现，不会和其他连接类型（如 wifi、mobile）混合在同一个列表中。官方文档原文：               
          "The returned list is never empty. In case of no connectivity, the list contains a single element of [ConnectivityResult.none]. Note also that this is the only case where
          ConnectivityResult.none is present."
          参考链接：
          - https://pub.dev/documentation/connectivity_plus_platform_interface/latest/connectivity_plus_platform_interface/ConnectivityResult.html
          - https://github.com/fluttercommunity/plus_plugins/blob/main/packages/connectivity_plus/connectivity_plus/lib/connectivity_plus.dart
          所以 value.contains(ConnectivityResult.none) 在真机上的判断是可靠的，不会出现混合值误触发的情况。
          如果你是在模拟器上遇到反复触发"网络断开了"的问题，这通常是模拟器本身网络状态不稳定导致的，建议在真机上验证一下。
        */
        if (value.contains(ConnectivityResult.none)) {
          isReconnection = true;
          isNetworkUnavailable = true;
          Logs.debug('网络断开了');
          _cancelReconnectTimer();
          _closeSocketBeforeReconnect("网络断开");
          setConnectionStatus(WKConnectStatus.noNetwork);
          lastConnectivityResult = ConnectivityResult.none;
        } else {
          final wasNetworkUnavailable = isNetworkUnavailable;
          isNetworkUnavailable = false;
          if (lastConnectivityResult != null &&
              !value.contains(lastConnectivityResult)) {
            isReconnection = true;
          }
          if (wasNetworkUnavailable) {
            isReconnection = true;
          }
          if (isReconnection) {
            isReconnection = false;
            _scheduleReconnect(_activeConnectId, "网络恢复");
          }
        }
        if (value.isNotEmpty) {
          lastConnectivityResult = value[0];
        }
      });
    });
  }

  _stopCheckNetworkTimer() {
    // if (_connectivitySubscription != null) {
    // _connectivitySubscription?.cancel();
    // }
    if (checkNetworkTimer != null) {
      checkNetworkTimer!.cancel();
      checkNetworkTimer = null;
    }
  }

  _startHeartTimer() {
    _stopHeartTimer();
    heartTimer = Timer.periodic(heartIntervalSecond, (timer) {
      if (unReceivePongCount > 0) {
        Logs.debug('心跳包未收到pong，重连中...');
        isReconnection = false;
        _closeSocketBeforeReconnect("ping_timeout");
        _scheduleReconnect(_activeConnectId, "ping_timeout");
        return;
      }
      Logs.info('ping...');
      unReceivePongCount++;
      _sendPacket(PingPacket());
    });
  }

  _stopHeartTimer() {
    if (heartTimer != null) {
      heartTimer!.cancel();
      heartTimer = null;
    }
  }

  sendMessage(WKMsg wkMsg) {
    SendPacket packet = SendPacket();
    packet.setting = wkMsg.setting;
    packet.header.noPersist = wkMsg.header.noPersist;
    packet.header.showUnread = wkMsg.header.redDot;
    packet.header.syncOnce = wkMsg.header.syncOnce;
    packet.channelID = wkMsg.channelID;
    packet.channelType = wkMsg.channelType;
    packet.clientSeq = wkMsg.clientSeq;
    packet.clientMsgNO = wkMsg.clientMsgNO;
    packet.topic = wkMsg.topicID;
    packet.expire = wkMsg.expireTime;
    packet.payload = wkMsg.content;
    _addSendingMsg(packet);
    _sendPacket(packet);
  }

  _verifyRecvMsg(RecvPacket recvMsg) {
    StringBuffer sb = StringBuffer();
    sb.writeAll([
      recvMsg.messageID,
      recvMsg.messageSeq,
      recvMsg.clientMsgNO,
      recvMsg.messageTime,
      recvMsg.fromUID,
      recvMsg.channelID,
      recvMsg.channelType,
      recvMsg.payload,
    ]);
    var encryptContent = sb.toString();
    var result = CryptoUtils.aesEncrypt(encryptContent);
    String localMsgKey = CryptoUtils.generateMD5(result);
    if (recvMsg.msgKey != localMsgKey) {
      Logs.error('非法消息-->期望msgKey：$localMsgKey，实际msgKey：${recvMsg.msgKey}');
      return;
    } else {
      recvMsg.payload = CryptoUtils.aesDecrypt(recvMsg.payload);
      Logs.debug(recvMsg.toString());
      _saveRecvMsg(recvMsg);
    }
  }

  _saveRecvMsg(RecvPacket recvMsg) async {
    WKMsg msg = WKMsg();
    msg.header.redDot = recvMsg.header.showUnread;
    msg.header.noPersist = recvMsg.header.noPersist;
    msg.header.syncOnce = recvMsg.header.syncOnce;
    msg.setting = recvMsg.setting;
    msg.channelType = recvMsg.channelType;
    msg.channelID = recvMsg.channelID;
    msg.content = recvMsg.payload;
    msg.messageID = recvMsg.messageID.toString();
    msg.messageSeq = recvMsg.messageSeq;
    msg.streamNo = recvMsg.streamNo;
    msg.streamSeq = recvMsg.streamSeq;
    msg.streamFlag = recvMsg.streamFlag;
    msg.timestamp = recvMsg.messageTime;
    msg.fromUID = recvMsg.fromUID;
    msg.clientMsgNO = recvMsg.clientMsgNO;
    msg.expireTime = recvMsg.expire;
    if (msg.expireTime > 0) {
      msg.expireTimestamp = msg.expireTime + msg.timestamp;
    }
    msg.status = WKSendMsgResult.sendSuccess;
    msg.topicID = recvMsg.topic;
    msg.orderSeq = await WKIM.shared.messageManager.getMessageOrderSeq(
      msg.messageSeq,
      msg.channelID,
      msg.channelType,
    );
    dynamic contentJson = jsonDecode(msg.content);
    msg.contentType = WKDBConst.readInt(contentJson, 'type');
    msg.isDeleted = _isDeletedMsg(contentJson);
    msg.messageContent = WKIM.shared.messageManager.getMessageModel(
      msg.contentType,
      contentJson,
    );
    WKChannel? fromChannel = await WKIM.shared.channelManager.getChannel(
      msg.fromUID,
      WKChannelType.personal,
    );
    if (fromChannel != null) {
      msg.setFrom(fromChannel);
    }
    if (msg.channelType == WKChannelType.group) {
      WKChannelMember? memberChannel = await WKIM.shared.channelMemberManager
          .getMember(msg.channelID, WKChannelType.group, msg.fromUID);
      if (memberChannel != null) {
        msg.setMemberOfFrom(memberChannel);
      }
    }
    WKIM.shared.messageManager.parsingMsg(msg);
    final isStreamUpdate = msg.streamNo.isNotEmpty && msg.streamFlag != 0;
    if (msg.isDeleted == 0 &&
        !msg.header.noPersist &&
        !isStreamUpdate &&
        msg.contentType != WkMessageContentType.insideMsg) {
      int row = await WKIM.shared.messageManager.saveMsg(msg);
      msg.clientSeq = row;
      WKUIConversationMsg? uiMsg = await WKIM.shared.conversationManager
          .saveWithLiMMsg(msg, msg.header.redDot ? 1 : 0);
      if (uiMsg != null) {
        List<WKUIConversationMsg> list = [];
        list.add(uiMsg);
        WKIM.shared.conversationManager.setRefreshUIMsgs(list);
      }
    } else {
      Logs.debug(
        '消息不能存库:is_deleted=${msg.isDeleted},no_persist=${msg.header.noPersist},content_type:${msg.contentType}',
      );
    }
    if (msg.contentType != WkMessageContentType.insideMsg) {
      List<WKMsg> list = [];
      list.add(msg);
      WKIM.shared.messageManager.pushNewMsg(list);
    }
  }

  int _isDeletedMsg(dynamic jsonObject) {
    int isDelete = 0;
    if (jsonObject != null) {
      var visibles = jsonObject['visibles'];
      if (visibles != null && visibles is List) {
        bool isIncludeLoginUser = false;
        for (int i = 0, size = visibles.length; i < size; i++) {
          if (visibles[i] == WKIM.shared.options.uid) {
            isIncludeLoginUser = true;
            break;
          }
        }
        isDelete = isIncludeLoginUser ? 0 : 1;
      }
    }
    return isDelete;
  }

  _resendMsg() async {
    _removeSendingMsg();
    if (_sendingMsgMap.isNotEmpty) {
      for (var entry in _sendingMsgMap.entries) {
        if (entry.value.isCanResend) {
          Logs.debug("重发消息：${entry.value.sendPacket.clientSeq}");
          await _sendPacket(entry.value.sendPacket);
        }
      }
    }
  }

  _addSendingMsg(SendPacket sendPacket) {
    _removeSendingMsg();
    _sendingMsgMap[sendPacket.clientSeq] = SendingMsg(sendPacket);
  }

  _removeSendingMsg() {
    if (_sendingMsgMap.isNotEmpty) {
      List<int> ids = [];
      _sendingMsgMap.forEach((key, sendingMsg) {
        if (!sendingMsg.isCanResend) {
          ids.add(key);
        }
      });
      if (ids.isNotEmpty) {
        for (var i = 0; i < ids.length; i++) {
          _sendingMsgMap.remove(ids[i]);
        }
      }
    }
  }

  _checkSedingMsg() {
    if (isNetworkUnavailable || isReconnection) {
      Logs.debug("网络不可用或重连中，暂停发送队列检查");
      return;
    }
    if (_sendingMsgMap.isNotEmpty) {
      final it = _sendingMsgMap.entries.iterator;
      while (it.moveNext()) {
        var key = it.current.key;
        var wkSendingMsg = it.current.value;
        if (wkSendingMsg.sendCount == 5 && wkSendingMsg.isCanResend) {
          WKIM.shared.messageManager.updateMsgStatusFail(key);
          wkSendingMsg.isCanResend = false;
        } else {
          var nowTime =
              (DateTime.now().millisecondsSinceEpoch / 1000).truncate();
          if (nowTime - wkSendingMsg.sendTime > 10) {
            wkSendingMsg.sendTime =
                (DateTime.now().millisecondsSinceEpoch / 1000).truncate();
            wkSendingMsg.sendCount++;
            _sendingMsgMap[key] = wkSendingMsg;
            _sendPacket(wkSendingMsg.sendPacket);
            Logs.debug("消息发送失败，尝试重发中...");
          }
        }
      }

      _removeSendingMsg();
    }
  }

  @visibleForTesting
  void debugClearSendingMessages() {
    _sendingMsgMap.clear();
  }

  @visibleForTesting
  void debugAddSendingPacket(
    SendPacket sendPacket, {
    int sendCount = 0,
    int? sendTime,
    bool isCanResend = true,
  }) {
    _sendingMsgMap[sendPacket.clientSeq] = SendingMsg(sendPacket)
      ..sendCount = sendCount
      ..sendTime =
          sendTime ?? (DateTime.now().millisecondsSinceEpoch / 1000).truncate()
      ..isCanResend = isCanResend;
  }

  @visibleForTesting
  void debugCheckSendingMessages() {
    _checkSedingMsg();
  }

  @visibleForTesting
  int? debugSendingMessageSendCount(int clientSeq) {
    return _sendingMsgMap[clientSeq]?.sendCount;
  }

  @visibleForTesting
  bool? debugSendingMessageCanResend(int clientSeq) {
    return _sendingMsgMap[clientSeq]?.isCanResend;
  }
}

Future<String> _getDeviceID() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String wkUid = WKIM.shared.options.uid!;
  String key = "${wkUid}_device_id";
  var deviceID = preferences.getString(key);
  if (deviceID == null || deviceID == "") {
    deviceID = const Uuid().v4().toString().replaceAll("-", "");
    preferences.setString(key, deviceID);
  }
  return "${deviceID}F";
}

class SendingMsg {
  SendPacket sendPacket;
  int sendCount = 0;
  int sendTime = 0;
  bool isCanResend = true;
  SendingMsg(this.sendPacket) {
    sendTime = (DateTime.now().millisecondsSinceEpoch / 1000).truncate();
  }
}

class ConnectionInfo {
  int nodeId;
  ConnectionInfo(this.nodeId);
}
