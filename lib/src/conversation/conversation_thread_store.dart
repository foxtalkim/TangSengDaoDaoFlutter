import '../chat/chat_message.dart';
import 'chat_conversation.dart';

class ConversationThreadStore {
  ConversationThreadStore._(this._threads);

  factory ConversationThreadStore.seed(
    List<ChatConversation> conversations, {
    required List<ChatMessage> Function(ChatConversation conversation)
    fallbackBuilder,
  }) {
    return ConversationThreadStore._({
      for (final conversation in conversations)
        keyOf(conversation): List.of(fallbackBuilder(conversation)),
    });
  }

  final Map<String, List<ChatMessage>> _threads;

  static String keyOf(ChatConversation conversation) =>
      keyFor(conversation.channelId, conversation.channelType);

  static String keyFor(String channelId, int channelType) =>
      '$channelType:$channelId';

  void retainConversations(List<ChatConversation> conversations) {
    final next = <String, List<ChatMessage>>{};
    for (final conversation in conversations) {
      final key = keyOf(conversation);
      next[key] = _threads[key] ?? [];
    }
    _threads
      ..clear()
      ..addAll(next);
  }

  List<ChatMessage> initialMessagesFor(
    ChatConversation conversation, {
    required List<ChatMessage> Function() fallback,
  }) {
    return List.of(_threads[keyOf(conversation)] ?? fallback());
  }

  void ensureEmpty(ChatConversation conversation) {
    _threads[keyOf(conversation)] = [];
  }

  void appendOptimistic(ChatConversation conversation, ChatMessage message) {
    _threads.update(
      keyOf(conversation),
      (messages) => [...messages, message],
      ifAbsent: () => [message],
    );
  }

  void upsertMessage(ChatConversation conversation, ChatMessage message) {
    _threads.update(keyOf(conversation), (messages) {
      final existing = messages.indexWhere(
        (item) =>
            (message.messageId.isNotEmpty &&
                item.messageId == message.messageId) ||
            (message.clientMsgNo.isNotEmpty &&
                item.clientMsgNo == message.clientMsgNo),
      );
      if (existing >= 0) {
        final next = List<ChatMessage>.of(messages);
        next[existing] = message;
        return next;
      }
      return _insertSorted(messages, message);
    }, ifAbsent: () => [message]);
  }

  void clearConversation(ChatConversation conversation) {
    _threads[keyOf(conversation)] = [];
  }

  bool containsChannel(String channelId, int channelType) {
    return _threads.containsKey(keyFor(channelId, channelType));
  }

  void removeChannel(String channelId, int channelType) {
    _threads.remove(keyFor(channelId, channelType));
  }

  void removeConversation(ChatConversation conversation) {
    _threads.remove(keyOf(conversation));
  }

  bool deleteByClientMsgNo(String clientMsgNo) {
    var changed = false;
    final next = <String, List<ChatMessage>>{};
    _threads.forEach((key, messages) {
      final filtered = messages
          .where((message) => message.clientMsgNo != clientMsgNo)
          .toList(growable: false);
      if (filtered.length != messages.length) {
        changed = true;
      }
      next[key] = filtered;
    });
    if (!changed) {
      return false;
    }
    _threads
      ..clear()
      ..addAll(next);
    return true;
  }

  static List<ChatMessage> _insertSorted(
    List<ChatMessage> messages,
    ChatMessage fresh,
  ) {
    if (messages.isEmpty) {
      return [fresh];
    }
    final last = messages.last;
    if (fresh.timestamp > last.timestamp ||
        (fresh.timestamp == last.timestamp &&
            fresh.messageSeq >= last.messageSeq)) {
      return [...messages, fresh];
    }
    var lo = 0;
    var hi = messages.length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      final message = messages[mid];
      final less =
          message.timestamp < fresh.timestamp ||
          (message.timestamp == fresh.timestamp &&
              message.messageSeq < fresh.messageSeq);
      if (less) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    final next = List<ChatMessage>.of(messages);
    next.insert(lo, fresh);
    return next;
  }
}
