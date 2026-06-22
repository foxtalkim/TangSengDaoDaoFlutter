import 'dart:async';

import 'package:flutter/widgets.dart';

import '../im/wukong_im_service.dart';
import '../l10n/app_localizations.dart';
import '../modules/module_ids.dart';

typedef ModuleEnabledPredicate = bool Function(String moduleId);
typedef ChatToolActionHandler =
    FutureOr<void> Function(ChatToolActionContext context);

final class ChatToolActionContext {
  const ChatToolActionContext({
    required this.buildContext,
    required this.pushPage,
    required this.pickAndSendFile,
    required this.sendLocation,
    required this.openAudioCall,
    required this.openVideoCall,
  });

  final BuildContext buildContext;
  final Future<void> Function(Widget page) pushPage;
  final FutureOr<void> Function() pickAndSendFile;
  final void Function(ChatLocation location, String? snapshotPath) sendLocation;
  final FutureOr<void> Function() openAudioCall;
  final FutureOr<void> Function() openVideoCall;
}

final class ChatToolAction {
  const ChatToolAction({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.sortOrder,
    this.moduleId,
    this.onSelected,
  });

  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final int sortOrder;
  final String? moduleId;
  final ChatToolActionHandler? onSelected;

  @override
  bool operator ==(Object other) {
    return other is ChatToolAction &&
        other.id == id &&
        other.title == title &&
        other.icon == icon &&
        other.color == color &&
        other.sortOrder == sortOrder &&
        other.moduleId == moduleId &&
        other.onSelected == onSelected;
  }

  @override
  int get hashCode =>
      Object.hash(id, title, icon, color, sortOrder, moduleId, onSelected);
}

List<ChatToolAction> mergeChatToolActions(
  Iterable<ChatToolAction> coreActions,
  Iterable<ChatToolAction> moduleActions,
) {
  final actions = [...coreActions, ...moduleActions];
  final indexed = <({int index, ChatToolAction action})>[
    for (var index = 0; index < actions.length; index++)
      (index: index, action: actions[index]),
  ];
  indexed.sort((a, b) {
    final byOrder = a.action.sortOrder.compareTo(b.action.sortOrder);
    if (byOrder != 0) return byOrder;
    return a.index.compareTo(b.index);
  });
  return [for (final item in indexed) item.action];
}

String chatToolActionTitle(AppLocalizations t, ChatToolAction action) {
  return switch (action.id) {
    ModuleActionIds.composerAlbum => t.chatToolAlbum,
    ModuleActionIds.composerCamera => t.chatToolCamera,
    ModuleActionIds.composerFile => t.chatToolFile,
    ModuleActionIds.composerLocation => t.chatToolLocation,
    ModuleActionIds.composerContactCard => t.chatToolContactCard,
    ModuleActionIds.composerAudioCall => t.chatToolAudioCall,
    ModuleActionIds.composerVideoCall => t.chatToolVideoCall,
    _ => action.title,
  };
}

List<ChatToolAction> filterChatToolActionsForModules(
  Iterable<ChatToolAction> actions, {
  required ModuleEnabledPredicate isModuleEnabled,
}) {
  return [
    for (final action in actions)
      if (action.moduleId == null || isModuleEnabled(action.moduleId!)) action,
  ];
}
