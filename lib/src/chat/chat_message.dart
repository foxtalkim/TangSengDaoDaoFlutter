import '../im/wukong_im_service.dart';
import '../media/chat_media_service.dart';

const chatMessageAguiStreamingKey = 'agui_streaming';
const chatMessageAguiStreamingPlaceholderKey = 'agui_streaming_placeholder';

class ChatMessage {
  const ChatMessage.left(
    this.text, {
    this.messageId = '',
    this.messageSeq = 0,
    this.clientMsgNo = '',
    this.timestamp = 0,
    this.kind = ChatMediaKind.file,
    this.fileName = '',
    this.attachment,
    this.fromUid = '',
    this.fromName = '',
    this.fromAvatarUrl = '',
    this.contentType = 0,
    this.callType = 0,
    this.mergeForwardTitle = '',
    this.mergeForwardEntries = const [],
    this.cardVercode = '',
    this.mergeForwardSourceChannelType = 0,
    this.mergeForwardUsers = const [],
    this.data = const {},
    this.replyToSender = '',
    this.replyToText = '',
    this.replyToMessageId = '',
    this.replyToRevoked = false,
    this.mentionUids = const [],
    this.mentionAll = false,
    this.voiceStatus = 0,
    this.locationLat = 0,
    this.locationLng = 0,
    this.locationTitle = '',
    this.locationAddress = '',
    this.locationImageUrl = '',
    this.revoked = false,
    this.revoker = '',
    this.editedText = '',
    this.editedAt = 0,
    this.reactions = const [],
    this.cardUid = '',
    this.cardName = '',
    this.screenshotFromName = '',
    this.replyCount = 0,
  }) : isMine = false,
       status = null,
       readed = false,
       readedCount = 0,
       unreadCount = 0;

  const ChatMessage.right(
    this.text, {
    this.status,
    this.messageId = '',
    this.messageSeq = 0,
    this.clientMsgNo = '',
    this.timestamp = 0,
    this.readed = false,
    this.readedCount = 0,
    // ignore: unused_element_parameter
    this.unreadCount = 0,
    this.contentType = 0,
    this.callType = 0,
    this.mergeForwardTitle = '',
    this.mergeForwardEntries = const [],
    this.cardVercode = '',
    this.mergeForwardSourceChannelType = 0,
    this.mergeForwardUsers = const [],
    this.data = const {},
    this.replyToSender = '',
    this.replyToText = '',
    this.replyToMessageId = '',
    this.replyToRevoked = false,
    this.mentionUids = const [],
    this.mentionAll = false,
    this.voiceStatus = 0,
    this.locationLat = 0,
    this.locationLng = 0,
    this.locationTitle = '',
    this.locationAddress = '',
    this.locationImageUrl = '',
    this.revoked = false,
    this.revoker = '',
    this.editedText = '',
    this.editedAt = 0,
    this.reactions = const [],
    this.cardUid = '',
    this.cardName = '',
    this.screenshotFromName = '',
    this.replyCount = 0,
  }) : isMine = true,
       kind = ChatMediaKind.file,
       fileName = '',
       attachment = null,
       fromUid = '',
       fromName = '',
       fromAvatarUrl = '';

  const ChatMessage.rightMedia(
    this.text, {
    required this.kind,
    required this.fileName,
    this.attachment,
    this.status,
    this.messageId = '',
    this.messageSeq = 0,
    this.clientMsgNo = '',
    this.timestamp = 0,
    this.readed = false,
    this.readedCount = 0,
    this.unreadCount = 0,
    this.contentType = 0,
    this.callType = 0,
    this.mergeForwardTitle = '',
    this.mergeForwardEntries = const [],
    this.cardVercode = '',
    this.mergeForwardSourceChannelType = 0,
    this.mergeForwardUsers = const [],
    this.data = const {},
    this.replyToSender = '',
    this.replyToText = '',
    this.replyToMessageId = '',
    this.replyToRevoked = false,
    this.mentionUids = const [],
    this.mentionAll = false,
    this.voiceStatus = 0,
    this.locationLat = 0,
    this.locationLng = 0,
    this.locationTitle = '',
    this.locationAddress = '',
    this.locationImageUrl = '',
    this.revoked = false,
    this.revoker = '',
    this.editedText = '',
    this.editedAt = 0,
    this.reactions = const [],
    this.cardUid = '',
    this.cardName = '',
    this.screenshotFromName = '',
    this.replyCount = 0,
  }) : isMine = true,
       fromUid = '',
       fromName = '',
       fromAvatarUrl = '';

  factory ChatMessage.fromSnapshot(WukongMessageSnapshot snapshot) {
    final kind = switch (snapshot.kind) {
      WukongMessageKind.image => ChatMediaKind.image,
      WukongMessageKind.file => ChatMediaKind.file,
      WukongMessageKind.voice => ChatMediaKind.voice,
      WukongMessageKind.video => ChatMediaKind.video,
      WukongMessageKind.sticker => ChatMediaKind.sticker,
      WukongMessageKind.livePhoto => ChatMediaKind.livePhoto,
      _ => null,
    };
    final attachment = kind == null
        ? null
        : ChatMediaAttachment(
            kind: kind,
            localPath: snapshot.localPath,
            fileName: snapshot.fileName,
            fileSize: snapshot.fileSize,
            remoteUrl: snapshot.remoteUrl,
            durationSeconds: snapshot.durationSeconds,
            coverUrl: snapshot.coverUrl,
            livePhotoVideoUrl: snapshot.livePhotoVideoUrl,
            livePhotoVideoLocalPath: snapshot.livePhotoVideoLocalPath,
            width: snapshot.mediaWidth,
            height: snapshot.mediaHeight,
          );
    if (snapshot.isMine) {
      if (kind != null) {
        return ChatMessage.rightMedia(
          snapshot.text,
          kind: kind,
          fileName: snapshot.fileName,
          attachment: attachment,
          status: snapshot.status,
          messageId: snapshot.messageId,
          messageSeq: snapshot.messageSeq,
          clientMsgNo: snapshot.clientMsgNo,
          timestamp: snapshot.timestamp,
          readed: snapshot.readed,
          readedCount: snapshot.readedCount,
          unreadCount: snapshot.unreadCount,
          contentType: snapshot.contentType,
          callType: snapshot.callType,
          mergeForwardTitle: snapshot.mergeForwardTitle,
          mergeForwardEntries: snapshot.mergeForwardEntries,
          mergeForwardSourceChannelType: snapshot.mergeForwardSourceChannelType,
          mergeForwardUsers: snapshot.mergeForwardUsers,
          cardVercode: snapshot.cardVercode,
          data: snapshot.data,
          revoked: snapshot.revoked,
          revoker: snapshot.revoker,
          replyToSender: snapshot.replyToSender,
          replyToText: snapshot.replyToText,
          replyToMessageId: snapshot.replyToMessageId,
          replyToRevoked: snapshot.replyToRevoked,
          mentionUids: snapshot.mentionUids,
          mentionAll: snapshot.mentionAll,
          voiceStatus: snapshot.voiceStatus,
          locationLat: snapshot.locationLat,
          locationLng: snapshot.locationLng,
          locationTitle: snapshot.locationTitle,
          locationAddress: snapshot.locationAddress,
          locationImageUrl: snapshot.locationImageUrl,
          editedText: snapshot.editedText,
          editedAt: snapshot.editedAt,
          reactions: snapshot.reactions,
          cardUid: snapshot.cardUid,
          cardName: snapshot.cardName,
          screenshotFromName: snapshot.screenshotFromName,
          replyCount: snapshot.replyCount,
        );
      }
      return ChatMessage.right(
        snapshot.text,
        status: snapshot.status,
        messageId: snapshot.messageId,
        messageSeq: snapshot.messageSeq,
        clientMsgNo: snapshot.clientMsgNo,
        timestamp: snapshot.timestamp,
        readed: snapshot.readed,
        readedCount: snapshot.readedCount,
        unreadCount: snapshot.unreadCount,
        contentType: snapshot.contentType,
        callType: snapshot.callType,
        mergeForwardTitle: snapshot.mergeForwardTitle,
        mergeForwardEntries: snapshot.mergeForwardEntries,
        mergeForwardSourceChannelType: snapshot.mergeForwardSourceChannelType,
        mergeForwardUsers: snapshot.mergeForwardUsers,
        cardVercode: snapshot.cardVercode,
        data: snapshot.data,
        revoked: snapshot.revoked,
        revoker: snapshot.revoker,
        replyToSender: snapshot.replyToSender,
        replyToText: snapshot.replyToText,
        replyToMessageId: snapshot.replyToMessageId,
        replyToRevoked: snapshot.replyToRevoked,
        mentionUids: snapshot.mentionUids,
        mentionAll: snapshot.mentionAll,
        voiceStatus: snapshot.voiceStatus,
        locationLat: snapshot.locationLat,
        locationLng: snapshot.locationLng,
        locationTitle: snapshot.locationTitle,
        locationAddress: snapshot.locationAddress,
        locationImageUrl: snapshot.locationImageUrl,
        editedText: snapshot.editedText,
        editedAt: snapshot.editedAt,
        reactions: snapshot.reactions,
        cardUid: snapshot.cardUid,
        cardName: snapshot.cardName,
        screenshotFromName: snapshot.screenshotFromName,
        replyCount: snapshot.replyCount,
      );
    }
    return ChatMessage.left(
      snapshot.text,
      kind: kind ?? ChatMediaKind.file,
      fileName: snapshot.fileName,
      attachment: attachment,
      messageId: snapshot.messageId,
      messageSeq: snapshot.messageSeq,
      clientMsgNo: snapshot.clientMsgNo,
      timestamp: snapshot.timestamp,
      fromUid: snapshot.fromUid,
      fromName: snapshot.fromName,
      fromAvatarUrl: snapshot.fromAvatarUrl,
      contentType: snapshot.contentType,
      callType: snapshot.callType,
      mergeForwardTitle: snapshot.mergeForwardTitle,
      mergeForwardEntries: snapshot.mergeForwardEntries,
      mergeForwardSourceChannelType: snapshot.mergeForwardSourceChannelType,
      mergeForwardUsers: snapshot.mergeForwardUsers,
      cardVercode: snapshot.cardVercode,
      data: snapshot.data,
      revoked: snapshot.revoked,
      revoker: snapshot.revoker,
      replyToSender: snapshot.replyToSender,
      replyToText: snapshot.replyToText,
      replyToMessageId: snapshot.replyToMessageId,
      replyToRevoked: snapshot.replyToRevoked,
      mentionUids: snapshot.mentionUids,
      mentionAll: snapshot.mentionAll,
      voiceStatus: snapshot.voiceStatus,
      locationLat: snapshot.locationLat,
      locationLng: snapshot.locationLng,
      locationTitle: snapshot.locationTitle,
      locationAddress: snapshot.locationAddress,
      locationImageUrl: snapshot.locationImageUrl,
      editedText: snapshot.editedText,
      editedAt: snapshot.editedAt,
      reactions: snapshot.reactions,
      cardUid: snapshot.cardUid,
      cardName: snapshot.cardName,
      screenshotFromName: snapshot.screenshotFromName,
      replyCount: snapshot.replyCount,
    );
  }

  final String text;
  final String messageId;
  final int messageSeq;
  final String clientMsgNo;
  final int timestamp;
  final bool isMine;
  final String? status;
  final ChatMediaKind kind;
  final String fileName;
  final ChatMediaAttachment? attachment;
  final String fromUid;
  final String fromName;
  final String fromAvatarUrl;
  final bool readed;
  final int readedCount;
  final int unreadCount;

  /// 被回复次数 — server `message_extra.reply_count` 同步过来。
  /// 对方/群消息气泡末尾显示 `⬅️N` (>0 才显)，自己气泡不显。
  /// 计数路径: WuKongIM webhook → Redis Incr → 3s 落库 → CMDSyncMessageExtra
  /// → SDK 本地 message_extra 表 → `WKMsgExtra.replyCount` → 这里。
  final int replyCount;
  final int contentType;

  /// RTC call-type for `WKCallSystemContent` messages (9989-9999):
  /// 0 = audio, 1 = video. 0 for non-call messages. Drives `_CallBubble`
  /// icon (phone vs videocam) and tap-to-recall preserves the original
  /// modality instead of always defaulting to audio.
  final int callType;

  /// Resolved bubble title for a merge-forward message, e.g.
  /// "张三和李四的聊天记录" / "群的聊天记录". Empty for non-merge.
  final String mergeForwardTitle;

  /// List of original messages embedded inside a merge-forward bubble.
  /// Empty for non-merge messages.
  final List<MergeForwardEntry> mergeForwardEntries;

  /// Original `channel_type` of the merge-forward payload — preserved so
  /// re-forward keeps the title resolution (1:1 vs group).
  final int mergeForwardSourceChannelType;

  /// Original `users[]` from the merge-forward payload — preserved so
  /// re-forward keeps name lookups + title intact.
  final List<Map<String, dynamic>> mergeForwardUsers;

  /// Original `WKCardContent.vercode` — preserved so card-forward keeps
  /// auto-add-friend behavior. Empty when not a card.
  final String cardVercode;

  /// True iff the message is a merge-forward (contentType 11) with
  /// at least one embedded entry.
  bool get isMergeForwardMessage =>
      contentType == 11 && mergeForwardEntries.isNotEmpty;
  final Map<String, Object?> data;
  final String replyToSender;
  final String replyToText;
  final String replyToMessageId;

  /// True when the message this one quotes has itself been revoked.
  /// Causes `_BubbleQuote` to swap its body to `原消息已撤回` instead
  /// of the cached preview text. Sourced from the gateway's
  /// `WukongMessageSnapshot.replyToRevoked` (server flag inside
  /// `content.reply.revoke`) — and also flipped client-side when the
  /// user revokes a message that other bubbles in the open chat
  /// already quote, so the fallback is immediate.
  final bool replyToRevoked;

  /// uids the sender explicitly @-mentioned. Sourced from
  /// `WukongMessageSnapshot.mentionUids` decoded by the SDK from
  /// `WKMentionInfo.uids`. Empty when nothing was mentioned.
  /// Drives the `@-mention` scroll FAB and red-dot logic.
  final List<String> mentionUids;

  /// True when the sender targeted `@全体成员`. Server uses
  /// `mention.all = 1`; SDK exposes via `WKMentionInfo.mentionAll`.
  /// Treated as "everyone in the channel" for scroll-FAB purposes.
  final bool mentionAll;

  /// Voice-message listen state from `WukongMessageSnapshot.voiceStatus`.
  /// 0 = unheard, 1 = listened. Drives the bubble's red unread dot
  /// for received voice messages and is flipped to 1 on first play
  /// via `markVoiceMessageRead`. Always 0 for non-voice messages.
  final int voiceStatus;

  /// Location coordinates and place metadata for contentType=6
  /// (`WKLocationContent`) messages. Drive the
  /// `_LocationBubbleContent` rendering (title + address) and the
  /// system-map deep-link on tap. All zero / empty for non-location
  /// messages — UI gates rendering on `isLocationMessage`.
  final double locationLat;
  final double locationLng;
  final String locationTitle;
  final String locationAddress;

  /// 服务端 mini-map 截图 URL — 对齐 iOS WKLocationContent.img.
  /// picker takeSnapshot → 上传 → 拿 URL 填这里. 空时气泡 preview 显占位.
  final String locationImageUrl;

  /// True for `contentType == 6` (location) messages with any
  /// populated data — title, address, OR coordinates. Coordinate-
  /// only payloads from peers without a geocoded label still
  /// render as a location bubble so tap-to-map works.
  bool get isLocationMessage =>
      contentType == 6 &&
      (locationTitle.isNotEmpty ||
          locationAddress.isNotEmpty ||
          locationLat != 0 ||
          locationLng != 0);

  /// True iff this incoming message names the current login user
  /// (either via `mentionAll` or by listing `loginUid` in
  /// `mentionUids`). Outgoing messages always return false. Caller
  /// passes `loginUid` since the message instance doesn't know
  /// which user is logged in.
  bool mentionsLoginUser(String loginUid) {
    if (isMine) return false;
    if (loginUid.isEmpty) return false;
    if (mentionAll) return true;
    return mentionUids.contains(loginUid);
  }

  /// Edited content text — non-empty when the message has been edited
  /// via `message/edit`. Render this instead of `text` and append a
  /// "(已编辑)" suffix to the bubble.
  final String editedText;
  final int editedAt;
  bool get isEdited => editedText.isNotEmpty;
  String get effectiveText => isEdited ? editedText : text;

  /// Aggregated reactions: list of {emoji, count, mine}.
  final List<Map<String, Object>> reactions;

  /// Contact-card payload — uid + display name from WKCardContent.
  final String cardUid;
  final String cardName;

  /// Screenshot-notice display name (contentType 20). Non-empty when
  /// the message should render as "{name}在聊天中截屏了".
  final String screenshotFromName;
  bool get isScreenshotMessage =>
      contentType == 20 && screenshotFromName.isNotEmpty;

  /// Whether the message has been revoked. Revoked messages render as a
  /// centered system row instead of a bubble (matches native).
  final bool revoked;

  /// uid of whoever performed the revoke (sender themselves for normal
  /// recall, group admin for group recall). Used to compose the system row
  /// label `你/<name> 撤回了一条消息`.
  final String revoker;

  bool get isGroupInviteApproval =>
      contentType == 1009 && groupInviteNo.isNotEmpty;

  /// True when this message should render as a centered system row instead of
  /// a chat bubble. Mirrors native iOS WKSystemMessageCell taxonomy:
  ///   - 1000..1099 generic system content (excluding 1009 group invite which
  ///     has its own bubble), e.g. screenshot, end-to-end notice, group
  ///     create/join/leave, friend apply
  ///   - 6000..6999 group join / leave / kick / promote (legacy range)
  /// Note: RTC call timer (9989..9999) is NOT a system message — it renders
  /// as a special call bubble (left/right side based on direction) so we can
  /// surface phone icon + duration like native WKMessageCell.
  bool get isSystemMessage {
    if (contentType >= 6000 && contentType < 7000) return true;
    if (contentType >= 1000 && contentType < 1100 && contentType != 1009) {
      return true;
    }
    // Hotline range — `已分配客服` / `会话已解决` / `会话已重新打开` etc.
    // Server emits 12xx codes when a customer-service session changes
    // state; native iOS renders these as centered system rows.
    if (contentType >= 1200 && contentType < 1300) return true;
    // Generic server-pushed tip (`提示` content). Used for ad-hoc
    // notices like "会话已结束" or banner-style announcements that
    // don't have their own content class.
    if (contentType == 2000) return true;
    if (contentType == 9988) return true;
    return false;
  }

  /// True for the group-call invite system message (contentType
  /// 9988). When true, the chat-screen renders a tappable system row
  /// that joins the live LiveKit room (`data['room_id']`).
  bool get isGroupCallInvite =>
      contentType == 9988 && _groupCallInviteRoomId.isNotEmpty;

  /// Extracted from the snapshot's `data` map (server payload
  /// `room_id`). Empty when the invite was malformed or the message
  /// isn't a 9988.
  String get _groupCallInviteRoomId {
    final v = data['room_id'];
    return v == null ? '' : v.toString();
  }

  /// Public accessor for the chat-screen onTap wiring.
  String get groupCallInviteRoomId => _groupCallInviteRoomId;

  /// True for RTC call **terminal-state** messages that should render as a
  /// compact call bubble (phone/videocam icon + status text), anchored on the
  /// same side as a normal text bubble — left for inbound, right for outbound,
  /// mirroring native iOS WKVideoCallSystemCell.
  ///
  /// Only the 5 terminal codes are bubble-rendered, matching native:
  ///   - 9989 RESULT (own/peer hung up after a successful call — duration
  ///     formatted as "通话时长 MM:SS")
  ///   - 9992 CANCEL (caller cancelled before peer accepted — "已取消")
  ///   - 9995 MISSED (60s timeout, no answer — "未接听")
  ///   - 9997 REFUSE (peer declined — "已拒绝")
  ///   - 9999 HANGUP (terminal hangup variant — same shape as RESULT)
  ///
  /// The non-terminal codes (9990 SWITCH_TO_VIDEO, 9991 SWITCH_REPLY,
  /// 9993 SWITCH, 9994 RTC_DATA, 9996 RECEIVED, 9998 ACCEPT) are signaling
  /// frames consumed by `WKRTCManager` mid-call and should never render in
  /// the message list. The previous `>=9989 && <=9999` check accidentally
  /// produced "call ended" bubbles for these signaling frames if the server
  /// ever leaked one through. See call-bubble.md §2.1.
  bool get isCallMessage {
    return contentType == 9989 ||
        contentType == 9992 ||
        contentType == 9995 ||
        contentType == 9997 ||
        contentType == 9999;
  }

  /// True for non-terminal RTC signaling frames (9990 SWITCH_TO_VIDEO,
  /// 9991 SWITCH_REPLY, 9993 SWITCH, 9994 RTC_DATA, 9996 RECEIVED,
  /// 9998 ACCEPT). These are mid-call control frames consumed by
  /// `WKRTCManager`; they must not produce chat rows OR participate in
  /// neighbor-sensitive logic (date stamps, unread divider, sender
  /// streak grouping). Single source of truth so the row builder
  /// `continue` and `_isSameLeftStreak` stay in sync.
  bool get isHiddenRtcSignalingFrame {
    if (isCallMessage) return false;
    return contentType >= 9990 && contentType <= 9998;
  }

  /// True when this is a contact-card message (WKCardContent, contentType
  /// 4 in the wukong protocol). The bubble shows the carded user's name
  /// + uid + a tap target to open their profile.
  /// True when this is a contact-card message (`WKCardContent`,
  /// contentType **7** per `WkMessageContentType.card`). The bubble
  /// shows the carded user's name + tap target to open their profile.
  ///
  /// Earlier code checked `contentType == 4` here — that's `WK_VOICE`,
  /// not card. Voice messages already render via the kind=voice media
  /// path so the bug only surfaced when forwarding a card and seeing it
  /// degrade to a text bubble. Corrected to 7 (the real WK_CARD).
  bool get isCardMessage => contentType == 7 && cardUid.isNotEmpty;

  /// True iff this is an "unknown message" — a wire-level contentType
  /// the Flutter app doesn't know how to render, so the SDK falls back
  /// to `WKUnknownContent` whose `displayText()` returns the literal
  /// `[未知消息]`. Mirrors native iOS WK_UNKNOWN handling
  /// (`WKConst.h:19`, displayed via `WKUnkownMessageCell`).
  ///
  /// Detection is the exact SDK fallback string PLUS a contentType
  /// that's NOT real text. A user typing the literal `[未知消息]` lands
  /// with `contentType == 1` (server-confirmed text) or `contentType
  /// == 0` (optimistic local pre-roundtrip), and we don't want them
  /// to get the trimmed menu. Genuine unknowns carry the
  /// server-original contentType (e.g. 99999 for a future feature
  /// type the client can't decode), which falls outside {0, 1} —
  /// hence the gate.
  bool get isUnknownMessage {
    if (text.trim() != '[未知消息]') return false;
    if (contentType == 0 || contentType == 1) return false;
    if (attachment != null) return false;
    if (kind != ChatMediaKind.file) return false;
    if (isCallMessage) return false;
    if (isCardMessage) return false;
    if (isMergeForwardMessage) return false;
    if (isLocationMessage) return false;
    if (isHiddenRtcSignalingFrame) return false;
    if (isScreenshotMessage) return false;
    if (isSystemMessage) return false;
    if (isGroupInviteApproval) return false;
    return true;
  }

  /// True iff this message renders as a plain text bubble — i.e. it's
  /// neither media (image/video/voice/file/sticker) nor a special
  /// content type (call/card/merge/system/screenshot/group-invite).
  /// Used by the sensitive-word warning row to skip non-text bubbles
  /// without paying the substring-scan cost. Mirrors the implicit
  /// "else" branch in `_Bubble.build`.
  bool get isTextMessage {
    if (attachment != null) return false;
    if (kind != ChatMediaKind.file) return false;
    if (isCallMessage) return false;
    if (isCardMessage) return false;
    if (isMergeForwardMessage) return false;
    if (isHiddenRtcSignalingFrame) return false;
    if (isScreenshotMessage) return false;
    if (isSystemMessage) return false;
    if (isGroupInviteApproval) return false;
    return true;
  }

  bool get isAguiStreamingPlaceholder {
    return data[chatMessageAguiStreamingPlaceholderKey] == true;
  }

  bool get isEmptyInboundTextMessage {
    if (isMine) return false;
    if (revoked) return false;
    if (isAguiStreamingPlaceholder) return false;
    if (effectiveText.trim().isNotEmpty) return false;
    if (contentType != 0 && contentType != 1) return false;
    return isTextMessage;
  }

  bool get hasReplyQuote => replyToText.isNotEmpty || replyToSender.isNotEmpty;

  String get groupInviteNo {
    final value = data['invite_no'] ?? data['inviteNo'] ?? data['id'];
    return value?.toString().trim() ?? '';
  }

  String get groupInviteGroupNo {
    final value = data['group_no'] ?? data['groupNo'];
    return value?.toString().trim() ?? '';
  }

  ChatMessage copyWith({
    String? status,
    ChatMediaAttachment? attachment,
    String? locationImageUrl,
  }) {
    if (!isMine) {
      return this;
    }
    if (attachment != null || this.attachment != null) {
      return ChatMessage.rightMedia(
        text,
        kind: kind,
        fileName: fileName,
        attachment: attachment ?? this.attachment,
        status: status ?? this.status,
        messageId: messageId,
        messageSeq: messageSeq,
        clientMsgNo: clientMsgNo,
        timestamp: timestamp,
        readed: readed,
        readedCount: readedCount,
        unreadCount: unreadCount,
        replyCount: replyCount,
        contentType: contentType,
        callType: callType,
        mergeForwardTitle: mergeForwardTitle,
        mergeForwardEntries: mergeForwardEntries,
        mergeForwardSourceChannelType: mergeForwardSourceChannelType,
        mergeForwardUsers: mergeForwardUsers,
        cardVercode: cardVercode,
        data: data,
        replyToSender: replyToSender,
        replyToText: replyToText,
        replyToMessageId: replyToMessageId,
        replyToRevoked: replyToRevoked,
        locationLat: locationLat,
        locationLng: locationLng,
        locationTitle: locationTitle,
        locationAddress: locationAddress,
        locationImageUrl: locationImageUrl ?? this.locationImageUrl,
      );
    }
    return ChatMessage.right(
      text,
      status: status ?? this.status,
      messageId: messageId,
      messageSeq: messageSeq,
      clientMsgNo: clientMsgNo,
      timestamp: timestamp,
      readed: readed,
      readedCount: readedCount,
      unreadCount: unreadCount,
      replyCount: replyCount,
      contentType: contentType,
      callType: callType,
      mergeForwardTitle: mergeForwardTitle,
      mergeForwardEntries: mergeForwardEntries,
      mergeForwardSourceChannelType: mergeForwardSourceChannelType,
      mergeForwardUsers: mergeForwardUsers,
      cardVercode: cardVercode,
      data: data,
      replyToSender: replyToSender,
      replyToText: replyToText,
      replyToMessageId: replyToMessageId,
      replyToRevoked: replyToRevoked,
      locationLat: locationLat,
      locationLng: locationLng,
      locationTitle: locationTitle,
      locationAddress: locationAddress,
      locationImageUrl: locationImageUrl ?? this.locationImageUrl,
    );
  }

  /// Optimistically flip the user's reaction for the given emoji. If the
  /// emoji is already counted as "mine" we decrement (or remove the chip
  /// entirely if count goes to 0); otherwise we add / increment.
  ChatMessage toggleReaction(String emoji) {
    final next = <Map<String, Object>>[];
    var matched = false;
    for (final r in reactions) {
      if (r['emoji'] != emoji) {
        next.add(r);
        continue;
      }
      matched = true;
      final mine = r['mine'] == true;
      final count = (r['count'] is int ? r['count'] as int : 0);
      if (mine) {
        if (count > 1) {
          next.add({'emoji': emoji, 'count': count - 1, 'mine': false});
        }
      } else {
        next.add({'emoji': emoji, 'count': count + 1, 'mine': true});
      }
    }
    if (!matched) {
      next.add({'emoji': emoji, 'count': 1, 'mine': true});
    }
    return _withReactions(next);
  }

  ChatMessage _withReactions(List<Map<String, Object>> next) {
    if (isMine && attachment != null) {
      return ChatMessage.rightMedia(
        text,
        kind: kind,
        fileName: fileName,
        attachment: attachment,
        status: status,
        messageId: messageId,
        messageSeq: messageSeq,
        clientMsgNo: clientMsgNo,
        timestamp: timestamp,
        readed: readed,
        readedCount: readedCount,
        unreadCount: unreadCount,
        replyCount: replyCount,
        contentType: contentType,
        callType: callType,
        mergeForwardTitle: mergeForwardTitle,
        mergeForwardEntries: mergeForwardEntries,
        mergeForwardSourceChannelType: mergeForwardSourceChannelType,
        mergeForwardUsers: mergeForwardUsers,
        cardVercode: cardVercode,
        data: data,
        replyToSender: replyToSender,
        replyToText: replyToText,
        replyToRevoked: replyToRevoked,
        replyToMessageId: replyToMessageId,
        revoked: revoked,
        revoker: revoker,
        editedText: editedText,
        editedAt: editedAt,
        reactions: next,
        voiceStatus: voiceStatus,
        locationLat: locationLat,
        locationLng: locationLng,
        locationTitle: locationTitle,
        locationAddress: locationAddress,
      );
    }
    if (isMine) {
      return ChatMessage.right(
        text,
        status: status,
        messageId: messageId,
        messageSeq: messageSeq,
        clientMsgNo: clientMsgNo,
        timestamp: timestamp,
        readed: readed,
        readedCount: readedCount,
        unreadCount: unreadCount,
        replyCount: replyCount,
        contentType: contentType,
        callType: callType,
        mergeForwardTitle: mergeForwardTitle,
        mergeForwardEntries: mergeForwardEntries,
        mergeForwardSourceChannelType: mergeForwardSourceChannelType,
        mergeForwardUsers: mergeForwardUsers,
        cardVercode: cardVercode,
        data: data,
        replyToSender: replyToSender,
        replyToText: replyToText,
        replyToRevoked: replyToRevoked,
        replyToMessageId: replyToMessageId,
        revoked: revoked,
        revoker: revoker,
        editedText: editedText,
        editedAt: editedAt,
        reactions: next,
        voiceStatus: voiceStatus,
        locationLat: locationLat,
        locationLng: locationLng,
        locationTitle: locationTitle,
        locationAddress: locationAddress,
      );
    }
    return ChatMessage.left(
      text,
      kind: kind,
      fileName: fileName,
      attachment: attachment,
      messageId: messageId,
      messageSeq: messageSeq,
      clientMsgNo: clientMsgNo,
      timestamp: timestamp,
      fromUid: fromUid,
      fromName: fromName,
      fromAvatarUrl: fromAvatarUrl,
      contentType: contentType,
      callType: callType,
      mergeForwardTitle: mergeForwardTitle,
      mergeForwardEntries: mergeForwardEntries,
      mergeForwardSourceChannelType: mergeForwardSourceChannelType,
      mergeForwardUsers: mergeForwardUsers,
      cardVercode: cardVercode,
      data: data,
      replyToSender: replyToSender,
      replyToText: replyToText,
      replyToRevoked: replyToRevoked,
      replyToMessageId: replyToMessageId,
      revoked: revoked,
      revoker: revoker,
      editedText: editedText,
      editedAt: editedAt,
      reactions: next,
      voiceStatus: voiceStatus,
      locationLat: locationLat,
      locationLng: locationLng,
      locationTitle: locationTitle,
      locationAddress: locationAddress,
      replyCount: replyCount,
    );
  }

  /// Optimistically flip this message to an edited state with a new text
  /// body. Server refresh will land the canonical edit later but the user
  /// sees their change immediately.
  ChatMessage markEdited(String newText) {
    if (!isMine) return this;
    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (attachment != null) {
      return ChatMessage.rightMedia(
        text,
        kind: kind,
        fileName: fileName,
        attachment: attachment,
        status: status,
        messageId: messageId,
        messageSeq: messageSeq,
        clientMsgNo: clientMsgNo,
        timestamp: timestamp,
        readed: readed,
        readedCount: readedCount,
        unreadCount: unreadCount,
        replyCount: replyCount,
        contentType: contentType,
        callType: callType,
        mergeForwardTitle: mergeForwardTitle,
        mergeForwardEntries: mergeForwardEntries,
        mergeForwardSourceChannelType: mergeForwardSourceChannelType,
        mergeForwardUsers: mergeForwardUsers,
        cardVercode: cardVercode,
        data: data,
        replyToSender: replyToSender,
        replyToText: replyToText,
        replyToRevoked: replyToRevoked,
        replyToMessageId: replyToMessageId,
        revoked: revoked,
        revoker: revoker,
        editedText: newText,
        editedAt: nowSeconds,
      );
    }
    return ChatMessage.right(
      text,
      status: status,
      messageId: messageId,
      messageSeq: messageSeq,
      clientMsgNo: clientMsgNo,
      timestamp: timestamp,
      readed: readed,
      readedCount: readedCount,
      unreadCount: unreadCount,
      replyCount: replyCount,
      contentType: contentType,
      callType: callType,
      mergeForwardTitle: mergeForwardTitle,
      mergeForwardEntries: mergeForwardEntries,
      mergeForwardSourceChannelType: mergeForwardSourceChannelType,
      mergeForwardUsers: mergeForwardUsers,
      cardVercode: cardVercode,
      data: data,
      replyToSender: replyToSender,
      replyToText: replyToText,
      replyToRevoked: replyToRevoked,
      replyToMessageId: replyToMessageId,
      revoked: revoked,
      revoker: revoker,
      editedText: newText,
      editedAt: nowSeconds,
    );
  }

  /// Optimistically flip this received voice message's listen state
  /// from 0 (unheard) to 1 (listened). Mirrors the local effect of
  /// `markVoiceMessageRead` POST without waiting for the server's
  /// snapshot refresh — clears the bubble's unread red dot the
  /// instant the user taps play. No-op for own / non-voice / already-
  /// listened messages. Preserves all other state via the matching
  /// constructor's full field-list, same pattern as `markRevoked`.
  ChatMessage markVoiceListened() {
    if (isMine) return this;
    if (kind != ChatMediaKind.voice) return this;
    if (voiceStatus == 1) return this;
    return ChatMessage.left(
      text,
      kind: kind,
      fileName: fileName,
      attachment: attachment,
      messageId: messageId,
      messageSeq: messageSeq,
      clientMsgNo: clientMsgNo,
      timestamp: timestamp,
      fromUid: fromUid,
      fromName: fromName,
      fromAvatarUrl: fromAvatarUrl,
      contentType: contentType,
      callType: callType,
      mergeForwardTitle: mergeForwardTitle,
      mergeForwardEntries: mergeForwardEntries,
      mergeForwardSourceChannelType: mergeForwardSourceChannelType,
      mergeForwardUsers: mergeForwardUsers,
      cardVercode: cardVercode,
      data: data,
      replyToSender: replyToSender,
      replyToText: replyToText,
      replyToMessageId: replyToMessageId,
      replyToRevoked: replyToRevoked,
      mentionUids: mentionUids,
      mentionAll: mentionAll,
      voiceStatus: 1,
      revoked: revoked,
      revoker: revoker,
      editedText: editedText,
      editedAt: editedAt,
      reactions: reactions,
      cardUid: cardUid,
      cardName: cardName,
      screenshotFromName: screenshotFromName,
      replyCount: replyCount,
    );
  }

  /// Optimistically flip this message to the revoked state. Preserves the
  /// original text so the "重新编辑" button can restore it; the bubble is
  /// rendered as a centered system row instead of the original cell.
  ChatMessage markRevoked(String selfUid) {
    if (revoked) return this;
    if (isMine && attachment != null) {
      return ChatMessage.rightMedia(
        text,
        kind: kind,
        fileName: fileName,
        attachment: attachment,
        status: status,
        messageId: messageId,
        messageSeq: messageSeq,
        clientMsgNo: clientMsgNo,
        timestamp: timestamp,
        readed: readed,
        readedCount: readedCount,
        unreadCount: unreadCount,
        replyCount: replyCount,
        contentType: contentType,
        callType: callType,
        mergeForwardTitle: mergeForwardTitle,
        mergeForwardEntries: mergeForwardEntries,
        mergeForwardSourceChannelType: mergeForwardSourceChannelType,
        mergeForwardUsers: mergeForwardUsers,
        cardVercode: cardVercode,
        data: data,
        replyToSender: replyToSender,
        replyToText: replyToText,
        replyToMessageId: replyToMessageId,
        replyToRevoked: replyToRevoked,
        revoked: true,
        revoker: selfUid,
        // Preserve edited state across revoke so the re-edit guard
        // can hide '重新编辑' on already-edited messages (mirrors
        // native iOS spec composer-locked.md / revoke-row.md §6 P2).
        editedText: editedText,
        editedAt: editedAt,
      );
    }
    if (isMine) {
      return ChatMessage.right(
        text,
        status: status,
        messageId: messageId,
        messageSeq: messageSeq,
        clientMsgNo: clientMsgNo,
        timestamp: timestamp,
        readed: readed,
        readedCount: readedCount,
        unreadCount: unreadCount,
        replyCount: replyCount,
        contentType: contentType,
        callType: callType,
        mergeForwardTitle: mergeForwardTitle,
        mergeForwardEntries: mergeForwardEntries,
        mergeForwardSourceChannelType: mergeForwardSourceChannelType,
        mergeForwardUsers: mergeForwardUsers,
        cardVercode: cardVercode,
        data: data,
        replyToSender: replyToSender,
        replyToText: replyToText,
        replyToMessageId: replyToMessageId,
        replyToRevoked: replyToRevoked,
        revoked: true,
        revoker: selfUid,
        // Preserve edited state across revoke so the re-edit guard
        // can hide '重新编辑' on already-edited messages (mirrors
        // native iOS spec composer-locked.md / revoke-row.md §6 P2).
        editedText: editedText,
        editedAt: editedAt,
      );
    }
    return ChatMessage.left(
      text,
      kind: kind,
      fileName: fileName,
      attachment: attachment,
      messageId: messageId,
      messageSeq: messageSeq,
      clientMsgNo: clientMsgNo,
      timestamp: timestamp,
      fromUid: fromUid,
      fromName: fromName,
      fromAvatarUrl: fromAvatarUrl,
      contentType: contentType,
      callType: callType,
      mergeForwardTitle: mergeForwardTitle,
      mergeForwardEntries: mergeForwardEntries,
      mergeForwardSourceChannelType: mergeForwardSourceChannelType,
      mergeForwardUsers: mergeForwardUsers,
      cardVercode: cardVercode,
      data: data,
      replyToSender: replyToSender,
      replyToText: replyToText,
      replyToMessageId: replyToMessageId,
      replyToRevoked: replyToRevoked,
      revoked: true,
      revoker: selfUid,
      // Preserve edited state on left/peer revoke too — same
      // re-edit guard semantics as the mine branches.
      editedText: editedText,
      editedAt: editedAt,
      replyCount: replyCount,
    );
  }

  /// Flip the `replyToRevoked` flag on a message that quotes a now-
  /// revoked source. Used when the user revokes a message in the open
  /// chat — every other bubble already showing the quote needs to
  /// swap its preview to `原消息已撤回` immediately, before the
  /// server's revoke-cmd round-trip lands. No-op when the field is
  /// already true or when the message has no reply quote at all.
  ChatMessage markReplyRevoked() {
    if (replyToRevoked) return this;
    if (replyToMessageId.isEmpty &&
        replyToText.isEmpty &&
        replyToSender.isEmpty) {
      return this;
    }
    if (isMine && attachment != null) {
      return ChatMessage.rightMedia(
        text,
        kind: kind,
        fileName: fileName,
        attachment: attachment,
        status: status,
        messageId: messageId,
        messageSeq: messageSeq,
        clientMsgNo: clientMsgNo,
        timestamp: timestamp,
        readed: readed,
        readedCount: readedCount,
        unreadCount: unreadCount,
        replyCount: replyCount,
        contentType: contentType,
        callType: callType,
        mergeForwardTitle: mergeForwardTitle,
        mergeForwardEntries: mergeForwardEntries,
        mergeForwardSourceChannelType: mergeForwardSourceChannelType,
        mergeForwardUsers: mergeForwardUsers,
        cardVercode: cardVercode,
        data: data,
        replyToSender: replyToSender,
        replyToText: replyToText,
        replyToMessageId: replyToMessageId,
        replyToRevoked: true,
        revoked: revoked,
        revoker: revoker,
        editedText: editedText,
        editedAt: editedAt,
        reactions: reactions,
        cardUid: cardUid,
        cardName: cardName,
        screenshotFromName: screenshotFromName,
        voiceStatus: voiceStatus,
        locationLat: locationLat,
        locationLng: locationLng,
        locationTitle: locationTitle,
        locationAddress: locationAddress,
      );
    }
    if (isMine) {
      return ChatMessage.right(
        text,
        status: status,
        messageId: messageId,
        messageSeq: messageSeq,
        clientMsgNo: clientMsgNo,
        timestamp: timestamp,
        readed: readed,
        readedCount: readedCount,
        unreadCount: unreadCount,
        replyCount: replyCount,
        contentType: contentType,
        callType: callType,
        mergeForwardTitle: mergeForwardTitle,
        mergeForwardEntries: mergeForwardEntries,
        mergeForwardSourceChannelType: mergeForwardSourceChannelType,
        mergeForwardUsers: mergeForwardUsers,
        cardVercode: cardVercode,
        data: data,
        replyToSender: replyToSender,
        replyToText: replyToText,
        replyToMessageId: replyToMessageId,
        replyToRevoked: true,
        revoked: revoked,
        revoker: revoker,
        editedText: editedText,
        editedAt: editedAt,
        reactions: reactions,
        cardUid: cardUid,
        cardName: cardName,
        screenshotFromName: screenshotFromName,
        voiceStatus: voiceStatus,
        locationLat: locationLat,
        locationLng: locationLng,
        locationTitle: locationTitle,
        locationAddress: locationAddress,
      );
    }
    return ChatMessage.left(
      text,
      kind: kind,
      fileName: fileName,
      attachment: attachment,
      messageId: messageId,
      messageSeq: messageSeq,
      clientMsgNo: clientMsgNo,
      timestamp: timestamp,
      fromUid: fromUid,
      fromName: fromName,
      fromAvatarUrl: fromAvatarUrl,
      contentType: contentType,
      callType: callType,
      mergeForwardTitle: mergeForwardTitle,
      mergeForwardEntries: mergeForwardEntries,
      mergeForwardSourceChannelType: mergeForwardSourceChannelType,
      mergeForwardUsers: mergeForwardUsers,
      cardVercode: cardVercode,
      data: data,
      replyToSender: replyToSender,
      replyToText: replyToText,
      replyToMessageId: replyToMessageId,
      replyToRevoked: true,
      revoked: revoked,
      revoker: revoker,
      editedText: editedText,
      editedAt: editedAt,
      reactions: reactions,
      cardUid: cardUid,
      cardName: cardName,
      screenshotFromName: screenshotFromName,
      voiceStatus: voiceStatus,
      locationLat: locationLat,
      locationLng: locationLng,
      locationTitle: locationTitle,
      locationAddress: locationAddress,
      replyCount: replyCount,
    );
  }

  /// Adopt the SDK-assigned identity (messageId / messageSeq / clientMsgNo /
  /// timestamp) onto a local optimistic placeholder. Preserves everything
  /// else — bubble status, attachment, reply quote — so the visible bubble
  /// doesn't flicker when the SDK reports its `onMsgInserted`. The new
  /// identity lets later refreshes (read-receipt acks) match this row.
  ChatMessage withSdkIdentity(WukongMessageSnapshot snapshot) {
    if (!isMine) return this;
    if (attachment != null) {
      return ChatMessage.rightMedia(
        text,
        kind: kind,
        fileName: fileName,
        attachment: attachment,
        status: status,
        messageId: snapshot.messageId,
        messageSeq: snapshot.messageSeq,
        clientMsgNo: snapshot.clientMsgNo,
        timestamp: snapshot.timestamp > 0 ? snapshot.timestamp : timestamp,
        readed: readed,
        readedCount: readedCount,
        unreadCount: unreadCount,
        replyCount: replyCount,
        contentType: contentType,
        callType: callType,
        mergeForwardTitle: mergeForwardTitle,
        mergeForwardEntries: mergeForwardEntries,
        mergeForwardSourceChannelType: mergeForwardSourceChannelType,
        mergeForwardUsers: mergeForwardUsers,
        cardVercode: cardVercode,
        data: data,
        replyToSender: replyToSender,
        replyToText: replyToText,
        replyToMessageId: replyToMessageId,
        replyToRevoked: replyToRevoked,
        locationLat: locationLat,
        locationLng: locationLng,
        locationTitle: locationTitle,
        locationAddress: locationAddress,
        locationImageUrl: locationImageUrl,
      );
    }
    return ChatMessage.right(
      text,
      status: status,
      messageId: snapshot.messageId,
      messageSeq: snapshot.messageSeq,
      clientMsgNo: snapshot.clientMsgNo,
      timestamp: snapshot.timestamp > 0 ? snapshot.timestamp : timestamp,
      readed: readed,
      readedCount: readedCount,
      unreadCount: unreadCount,
      replyCount: replyCount,
      contentType: contentType,
      callType: callType,
      mergeForwardTitle: mergeForwardTitle,
      mergeForwardEntries: mergeForwardEntries,
      mergeForwardSourceChannelType: mergeForwardSourceChannelType,
      mergeForwardUsers: mergeForwardUsers,
      cardVercode: cardVercode,
      data: data,
      replyToSender: replyToSender,
      replyToText: replyToText,
      replyToMessageId: replyToMessageId,
      replyToRevoked: replyToRevoked,
      locationLat: locationLat,
      locationLng: locationLng,
      locationTitle: locationTitle,
      locationAddress: locationAddress,
    );
  }
}
