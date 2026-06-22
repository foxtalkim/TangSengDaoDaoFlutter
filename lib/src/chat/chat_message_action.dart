import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

typedef ModuleEnabledPredicate = bool Function(String moduleId);
typedef ChatMessageActionFactory =
    Iterable<ChatMessageAction> Function(
      ChatMessageActionContext context,
      AppLocalizations l10n,
    );

final class ChatMessageActionContext {
  const ChatMessageActionContext({
    required this.messageId,
    required this.isMine,
    required this.readedCount,
    required this.reactions,
  });

  final String messageId;
  final bool isMine;
  final int readedCount;
  final List<Map<String, Object>> reactions;
}

final class ChatMessageAction {
  const ChatMessageAction({
    required this.id,
    required this.title,
    required this.icon,
    this.moduleId,
  });

  final String id;
  final String title;
  final IconData icon;
  final String? moduleId;

  @override
  bool operator ==(Object other) {
    return other is ChatMessageAction &&
        other.id == id &&
        other.title == title &&
        other.icon == icon &&
        other.moduleId == moduleId;
  }

  @override
  int get hashCode => Object.hash(id, title, icon, moduleId);
}

List<ChatMessageAction> filterChatMessageActionsForModules(
  Iterable<ChatMessageAction> actions, {
  required ModuleEnabledPredicate isModuleEnabled,
}) {
  return [
    for (final action in actions)
      if (action.moduleId == null || isModuleEnabled(action.moduleId!)) action,
  ];
}
