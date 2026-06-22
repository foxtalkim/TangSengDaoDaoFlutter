import 'package:forui/forui.dart';

import '../auth/auth_repository.dart';
import '../chat/chat_message.dart';
import '../chat/chat_message_action.dart';
import '../l10n/app_localizations.dart';
import '../media/chat_media_service.dart';
import '../modules/module_ids.dart';

// Action menu rules mirror native iOS WKApp.m WKPOINT_LONGMENUS_*
// handlers — see docs/flutter-ui-polish-plan.md 批 2.1.
List<ChatMessageAction> messageActionsFor(
  ChatMessage message, {
  required AppLocalizations l10n,
  required ChatServerAppConfig serverAppConfig,
  // 对齐 iOS WKPinnedModule —— pin/unpin 切换 + 群权限。
  bool isAlreadyPinned = false,
  bool canPin = true,
  bool messageAiModuleAvailable = false,
  Iterable<ChatMessageAction> moduleLongPressActions =
      const <ChatMessageAction>[],
  Iterable<ChatMessageActionFactory> moduleMessageActionFactories =
      const <ChatMessageActionFactory>[],
}) {
  final actions = <ChatMessageAction>[];
  // Unknown message — the wire payload is opaque so 复制 / 转发 / 收藏 /
  // 翻译 / 编辑 / 回复 all silently break or carry meaningless data.
  // Mirror native iOS WKUnkownMessageCell which surfaces only 多选,
  // 删除, and 撤回 (when own + within revoke window).
  if (message.isUnknownMessage) {
    actions.add(
      ChatMessageAction(
        id: 'message.multi_select',
        title: l10n.chatActionMultiSelect,
        icon: FIcons.squareCheck,
      ),
    );
    final canRevoke = _canRevokeMessage(message, serverAppConfig);
    if (canRevoke) {
      actions.add(
        ChatMessageAction(
          id: 'message.revoke',
          title: l10n.chatActionRevoke,
          icon: FIcons.undo2,
        ),
      );
    } else {
      actions.add(
        ChatMessageAction(
          id: 'message.delete',
          title: l10n.chatActionDelete,
          icon: FIcons.trash2,
        ),
      );
    }
    return actions;
  }
  // 回复 — any message that has a real server-side id
  if (message.messageId.isNotEmpty) {
    actions.add(
      ChatMessageAction(
        id: 'message.reply',
        title: l10n.chatActionReply,
        icon: FIcons.reply,
      ),
    );
  }
  // 复制 — text only (allowMessageCopy in native defaults to TEXT only)
  if (message.kind == ChatMediaKind.file && message.text.isNotEmpty) {
    actions.add(
      ChatMessageAction(
        id: 'message.copy',
        title: l10n.chatActionCopy,
        icon: FIcons.copy,
      ),
    );
  }
  // 翻译 — text only, and only when MessageAI is included/enabled.
  if (messageAiModuleAvailable &&
      message.kind == ChatMediaKind.file &&
      message.text.isNotEmpty) {
    actions.add(
      ChatMessageAction(
        id: 'message.translate',
        title: l10n.chatActionTranslate,
        icon: FIcons.languages,
        moduleId: ExtensionModuleIds.messageAi,
      ),
    );
  }
  // 转文字 — received voice keeps the inline side action; own voice uses the
  // long-press menu so the outgoing bubble row stays clean.
  if (messageAiModuleAvailable &&
      message.isMine &&
      !message.revoked &&
      message.kind == ChatMediaKind.voice &&
      message.messageId.isNotEmpty) {
    actions.add(
      ChatMessageAction(
        id: 'message.transcribe',
        title: l10n.chatActionTranscribe,
        icon: FIcons.textCursorInput,
        moduleId: ExtensionModuleIds.messageAi,
      ),
    );
  }
  // 转发 — text / image / GIF (allowMessageForward defaults)
  if (_canForward(message)) {
    actions.add(
      ChatMessageAction(
        id: 'message.forward',
        title: l10n.chatActionForward,
        icon: FIcons.forward,
      ),
    );
  }
  // 收藏 — text / image, must have server id
  if (_canFavorite(message)) {
    for (final action in moduleLongPressActions) {
      if (action.id == ModuleActionIds.messageFavorite) {
        actions.add(_localizedModuleAction(l10n, action));
        break;
      }
    }
  }
  // 加好友 — 名片消息 action, 对齐 iOS WKCardCell long-press sheet.
  // 用户长按一张名片可以快速对 cardUid 发好友申请, 不用先 push 名片详情
  // 页再点"加好友". 自己发给自己的名片 + 已经是好友的 cardUid server
  // 端会判重, 客户端这里不预判.
  if (message.isCardMessage && message.cardUid.isNotEmpty) {
    actions.add(
      ChatMessageAction(
        id: 'message.add_friend',
        title: l10n.chatActionAddFriend,
        icon: FIcons.userPlus,
      ),
    );
  }
  // 多选 — any
  actions.add(
    ChatMessageAction(
      id: 'message.multi_select',
      title: l10n.chatActionMultiSelect,
      icon: FIcons.squareCheck,
    ),
  );
  // 编辑 — own text message within revoke window (mirrors native "编辑"
  // gating — same window as 撤回 because the edit also goes through
  // server message_extra)
  final canRevoke = _canRevokeMessage(message, serverAppConfig);
  if (canRevoke &&
      message.kind == ChatMediaKind.file &&
      message.text.isNotEmpty &&
      !message.revoked) {
    actions.add(
      ChatMessageAction(
        id: 'message.edit',
        title: l10n.chatActionEdit,
        icon: FIcons.pencil,
      ),
    );
  }
  if (_canEditImage(message)) {
    for (final action in moduleLongPressActions) {
      if (action.id == ModuleActionIds.messageEditImage) {
        actions.add(_localizedModuleAction(l10n, action));
        break;
      }
    }
  }
  // 撤回 — own message within revoke window
  if (canRevoke) {
    actions.add(
      ChatMessageAction(
        id: 'message.revoke',
        title: l10n.chatActionRevoke,
        icon: FIcons.undo2,
      ),
    );
  }
  // 删除 — hidden when 撤回 is shown to mirror native mutual exclusion
  if (!canRevoke) {
    actions.add(
      ChatMessageAction(
        id: 'message.delete',
        title: l10n.chatActionDelete,
        icon: FIcons.trash2,
      ),
    );
  }
  if (moduleMessageActionFactories.isNotEmpty) {
    final context = ChatMessageActionContext(
      messageId: message.messageId,
      isMine: message.isMine,
      readedCount: message.readedCount,
      reactions: message.reactions,
    );
    final moduleActions = [
      for (final factory in moduleMessageActionFactories)
        ...factory(context, l10n),
    ];
    actions.insertAll(0, moduleActions);
  }
  // 置顶 / 取消置顶 — 对齐 iOS WKPinnedModule:
  //   * 群里非管理员看不到该 item (canPin=false 时跳过)
  //   * 已 pin 显"取消置顶"，未 pin 显"置顶"
  if (message.messageId.isNotEmpty && canPin) {
    final targetId = isAlreadyPinned
        ? ModuleActionIds.messageUnpin
        : ModuleActionIds.messagePin;
    for (final action in moduleLongPressActions) {
      if (action.id == targetId) {
        actions.add(_localizedModuleAction(l10n, action));
        break;
      }
    }
  }
  return actions;
}

ChatMessageAction _localizedModuleAction(
  AppLocalizations t,
  ChatMessageAction action,
) {
  final title = switch (action.id) {
    ModuleActionIds.messageFavorite => t.chatActionFavorite,
    ModuleActionIds.messageEditImage => t.chatActionEditImage,
    ModuleActionIds.messagePin => t.chatActionPin,
    ModuleActionIds.messageUnpin => t.chatActionUnpin,
    _ => action.title,
  };
  if (title == action.title) return action;
  return ChatMessageAction(
    id: action.id,
    title: title,
    icon: action.icon,
    moduleId: action.moduleId,
  );
}

bool _canForward(ChatMessage message) {
  // Card / merge-forward / video / voice / sticker bubbles are all
  // forwardable via the per-content-type clone path in `_forwardSingle`.
  // The previous restriction to image+text-file only made the new
  // contentType branches (7, 11, etc.) unreachable from the long-press
  // 转发 menu — only multi-select 转发 hit them.
  if (message.isCardMessage) return true;
  if (message.isMergeForwardMessage) return true;
  switch (message.kind) {
    case ChatMediaKind.image:
    case ChatMediaKind.video:
    case ChatMediaKind.voice:
    case ChatMediaKind.sticker:
    case ChatMediaKind.livePhoto:
      return true;
    case ChatMediaKind.file:
      return message.text.isNotEmpty || message.attachment != null;
  }
}

bool _canFavorite(ChatMessage message) {
  // 对齐 iOS WuKongFavorite addMessageAllowFavorite:WK_TEXT/WK_IMAGE —
  // 只支持文本和图片，文件/语音/视频/表情等不出"收藏"菜单。
  if (message.messageId.isEmpty) return false;
  if (message.revoked) return false;
  switch (message.kind) {
    case ChatMediaKind.image:
      // 必须已上传拿到 remoteUrl，否则收藏后无法在 favorites 里显示
      return message.attachment?.remoteUrl.isNotEmpty ?? false;
    case ChatMediaKind.file:
      // 文件 attachment 不允许；仅纯文本 (attachment == null && text 非空)
      return message.attachment == null && message.text.isNotEmpty;
    default:
      return false;
  }
}

bool _canEditImage(ChatMessage message) {
  // 对齐 iOS WuKongBase WKImageBrowser.handleEdit (长按图片消息调起
  // ZLImageEditor 编辑后作为新消息发). 要求: image 类型 + 有本地路径或
  // 远程 URL (能拿到图源), 不限自己 / 对方。
  if (message.kind != ChatMediaKind.image) return false;
  if (message.revoked) return false;
  return message.attachment?.localPath.isNotEmpty == true ||
      message.attachment?.remoteUrl.isNotEmpty == true;
}

bool _canRevokeMessage(
  ChatMessage message,
  ChatServerAppConfig serverAppConfig,
) {
  if (!message.isMine || message.status != '已发送') {
    return false;
  }
  if (message.messageId.isEmpty) {
    return false;
  }
  final revokeSecond = serverAppConfig.revokeSecond == 0
      ? 120
      : serverAppConfig.revokeSecond;
  if (revokeSecond == -1) {
    return true;
  }
  if (message.timestamp <= 0) {
    return false;
  }
  final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  return nowSeconds - message.timestamp < revokeSecond;
}
