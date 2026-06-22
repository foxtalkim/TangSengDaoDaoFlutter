import 'package:flutter/material.dart';

import '../im/wukong_im_service.dart';

class ChatConversation {
  const ChatConversation({
    required this.channelId,
    required this.channelType,
    required this.name,
    required this.avatarLabel,
    required this.preview,
    required this.time,
    required this.colors,
    this.avatarPath = '',
    this.draft = '',
    this.lastSenderName = '',
    this.lastSenderUid = '',
    this.lastIsMine = false,
    this.lastMsgFailed = false,
    this.lastMsgSending = false,
    this.lastMsgRead = false,
    this.lastMsgSeq = 0,
    this.lastMsgTimestamp = 0,
    this.lastClientMsgNo = '',
    this.reminderText = '',
    this.unread = 0,
    this.online = false,
    this.muted = false,
    this.pinned = false,
    this.receiptEnabled = false,
    this.chatPasswordEnabled = false,
    this.flameEnabled = false,
    this.flameSecond = 0,
    this.notifyScreenshot = false,
    this.isRemote = false,
    this.forbidden = false,
    this.memberRemoved = false,
    this.memberCount = 0,
    this.channelCategory = '',
    this.isRobot = false,
    this.msgAutoDeleteSeconds = 0,
    this.searchAnchorMessageId = '',
  });

  factory ChatConversation.fromSnapshot(
    WukongConversationSnapshot snapshot, {
    required List<Color> colors,
  }) {
    return ChatConversation(
      channelId: snapshot.channelId,
      channelType: snapshot.channelType,
      name: snapshot.title,
      avatarLabel: snapshot.avatarLabel,
      avatarPath: snapshot.avatarPath,
      draft: snapshot.draft,
      lastSenderName: snapshot.lastSenderName,
      lastSenderUid: snapshot.lastSenderUid,
      lastIsMine: snapshot.lastIsMine,
      lastMsgFailed: snapshot.lastMsgFailed,
      lastMsgSending: snapshot.lastMsgSending,
      lastMsgRead: snapshot.lastMsgRead,
      lastMsgSeq: snapshot.lastMsgSeq,
      lastMsgTimestamp: snapshot.timestamp,
      lastClientMsgNo: snapshot.lastClientMsgNo,
      reminderText: snapshot.reminderText,
      preview: snapshot.preview,
      time: snapshot.timeLabel,
      unread: snapshot.unread,
      online: snapshot.online,
      muted: snapshot.muted,
      pinned: snapshot.pinned,
      receiptEnabled: snapshot.receiptEnabled,
      chatPasswordEnabled: snapshot.chatPasswordEnabled,
      flameEnabled: snapshot.flameEnabled,
      flameSecond: snapshot.flameSecond,
      notifyScreenshot: snapshot.notifyScreenshot,
      colors: colors,
      isRemote: true,
      forbidden: snapshot.forbidden,
      memberRemoved: snapshot.memberRemoved,
      channelCategory: snapshot.channelCategory,
      isRobot: snapshot.isRobot,
      msgAutoDeleteSeconds: snapshot.msgAutoDeleteSeconds,
    );
  }

  final String channelId;
  final int channelType;
  final String name;
  final String avatarLabel;
  final String avatarPath;
  final String draft;
  final String lastSenderName;
  final String lastSenderUid;
  final bool lastIsMine;
  final bool lastMsgFailed;
  final bool lastMsgSending;
  final bool lastMsgRead;
  final int lastMsgSeq;
  final int lastMsgTimestamp;
  final String lastClientMsgNo;
  final String reminderText;
  final String preview;
  final String time;
  final List<Color> colors;
  final int unread;
  final bool online;
  final bool muted;
  final bool pinned;
  final bool receiptEnabled;
  final bool chatPasswordEnabled;
  final bool flameEnabled;
  final int flameSecond;
  final bool notifyScreenshot;
  final bool isRemote;
  final bool forbidden;
  final bool memberRemoved;
  final int memberCount;
  final String channelCategory;
  final bool isRobot;
  final int msgAutoDeleteSeconds;
  final String searchAnchorMessageId;

  ChatConversation copyWith({
    String? preview,
    String? time,
    int? unread,
    String? draft,
    int? memberCount,
    int? lastMsgSeq,
    int? lastMsgTimestamp,
    String? lastClientMsgNo,
  }) {
    return ChatConversation(
      channelId: channelId,
      channelType: channelType,
      name: name,
      avatarLabel: avatarLabel,
      avatarPath: avatarPath,
      draft: draft ?? this.draft,
      lastSenderName: lastSenderName,
      lastSenderUid: lastSenderUid,
      lastIsMine: lastIsMine,
      lastMsgFailed: lastMsgFailed,
      lastMsgSending: lastMsgSending,
      lastMsgRead: lastMsgRead,
      lastMsgSeq: lastMsgSeq ?? this.lastMsgSeq,
      lastMsgTimestamp: lastMsgTimestamp ?? this.lastMsgTimestamp,
      lastClientMsgNo: lastClientMsgNo ?? this.lastClientMsgNo,
      reminderText: reminderText,
      preview: preview ?? this.preview,
      time: time ?? this.time,
      unread: unread ?? this.unread,
      online: online,
      muted: muted,
      pinned: pinned,
      receiptEnabled: receiptEnabled,
      chatPasswordEnabled: chatPasswordEnabled,
      flameEnabled: flameEnabled,
      flameSecond: flameSecond,
      notifyScreenshot: notifyScreenshot,
      colors: colors,
      isRemote: isRemote,
      forbidden: forbidden,
      memberRemoved: memberRemoved,
      memberCount: memberCount ?? this.memberCount,
      channelCategory: channelCategory,
      isRobot: isRobot,
      msgAutoDeleteSeconds: msgAutoDeleteSeconds,
      searchAnchorMessageId: searchAnchorMessageId,
    );
  }

  bool matches(String id, int type) {
    return channelId == id && channelType == type;
  }

  bool shouldPromoteSnapshot(WukongMessageSnapshot snapshot) {
    if (!matches(snapshot.channelId, snapshot.channelType)) {
      return false;
    }
    if (snapshot.messageSeq > 0 && lastMsgSeq > 0) {
      return snapshot.messageSeq > lastMsgSeq;
    }
    if (snapshot.timestamp != lastMsgTimestamp) {
      return snapshot.timestamp > lastMsgTimestamp;
    }
    if (snapshot.messageSeq != lastMsgSeq) {
      return snapshot.messageSeq > lastMsgSeq;
    }
    if (snapshot.clientMsgNo.isNotEmpty && lastClientMsgNo.isEmpty) {
      return true;
    }
    return false;
  }
}
