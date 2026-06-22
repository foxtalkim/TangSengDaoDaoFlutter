import '../social/social_service.dart';
import 'chat_inline_text.dart';
import 'models/contact_models.dart';

typedef MentionPick = ({String uid, String label});

class MentionQuery {
  const MentionQuery({required this.query, required this.anchor});

  final String query;
  final int anchor;
}

class MentionDeleteRewrite {
  const MentionDeleteRewrite({
    required this.text,
    required this.selectionOffset,
  });

  final String text;
  final int selectionOffset;
}

class MentionReconcileResult {
  const MentionReconcileResult({
    required this.picks,
    required this.mentionAllLabel,
  });

  final List<MentionPick> picks;
  final String mentionAllLabel;
}

enum MentionTapResolutionKind {
  empty,
  groupDuplicate,
  contactDuplicate,
  notFound,
  contact,
  uid,
}

class MentionTapResolution {
  const MentionTapResolution({
    required this.kind,
    this.name = '',
    this.uid,
    this.contact,
  });

  final MentionTapResolutionKind kind;
  final String name;
  final String? uid;
  final UiContact? contact;
}

/// Synthetic ChatContact representing the mention-all row. uid `all` is the
/// wire-level sentinel the server / IM gateway expects for `mention.all = 1`.
ChatContact allMembersMentionContact({
  required String name,
  required String subtitle,
}) => ChatContact(uid: 'all', name: name, subtitle: subtitle);

MentionQuery? detectMentionQuery(String text, int caret) {
  if (caret < 0 || caret > text.length) return null;
  final atIndex = text.lastIndexOf('@', caret - 1);
  if (atIndex < 0) return null;
  final segment = text.substring(atIndex + 1, caret);
  if (segment.contains(RegExp(r'\s'))) return null;
  return MentionQuery(query: segment.toLowerCase(), anchor: atIndex);
}

MentionDeleteRewrite? atomicMentionDeleteRewrite({
  required String newText,
  required String oldText,
  required Iterable<String> labels,
}) {
  var diff = 0;
  final len = newText.length < oldText.length ? newText.length : oldText.length;
  while (diff < len && newText.codeUnitAt(diff) == oldText.codeUnitAt(diff)) {
    diff++;
  }
  for (final label in labels) {
    if (label.isEmpty) continue;
    var search = 0;
    while (true) {
      final start = oldText.indexOf(label, search);
      if (start < 0) break;
      final end = start + label.length;
      if (diff >= start && diff < end) {
        return MentionDeleteRewrite(
          text: oldText.substring(0, start) + oldText.substring(end),
          selectionOffset: start,
        );
      }
      search = end;
    }
  }
  return null;
}

MentionReconcileResult reconcileMentionPicks({
  required String text,
  required List<MentionPick> picks,
  required String mentionAllLabel,
}) {
  if (picks.isEmpty && mentionAllLabel.isEmpty) {
    return MentionReconcileResult(
      picks: picks,
      mentionAllLabel: mentionAllLabel,
    );
  }
  final remaining = <String, int>{};
  for (final pick in picks) {
    remaining[pick.label] ??= countMentionOccurrences(text, pick.label);
  }
  final keep = <MentionPick>[];
  for (final pick in picks) {
    final count = remaining[pick.label] ?? 0;
    if (count > 0) {
      keep.add(pick);
      remaining[pick.label] = count - 1;
    }
  }
  return MentionReconcileResult(
    picks: List.unmodifiable(keep),
    mentionAllLabel: mentionStillPresent(text, mentionAllLabel)
        ? mentionAllLabel
        : '',
  );
}

int countMentionOccurrences(String text, String label) {
  if (label.isEmpty) return 0;
  return _mentionRegex(label).allMatches(text).length;
}

bool mentionStillPresent(String text, String label) {
  if (label.isEmpty) return false;
  return _mentionRegex(label).hasMatch(text);
}

RegExp _mentionRegex(String label) {
  final escaped = escapeRegexLiteral(label);
  return RegExp('@$escaped(?![一-龥\\w])(?![.\\-][一-龥\\w])');
}

List<ChatContact> filterMentionMembers({
  required String query,
  required List<ChatContact> members,
  required String loginUid,
  required bool isGroupAdmin,
  required String mentionAllName,
  required String mentionAllSubtitle,
}) {
  final lower = query.toLowerCase();
  final list = <ChatContact>[];
  if (isGroupAdmin && matchesAllMembersSentinel(lower)) {
    list.add(
      allMembersMentionContact(
        name: mentionAllName,
        subtitle: mentionAllSubtitle,
      ),
    );
  }
  for (final member in members) {
    if (member.uid == loginUid) continue;
    if (lower.isEmpty ||
        member.name.toLowerCase().contains(lower) ||
        member.remark.toLowerCase().contains(lower)) {
      list.add(member);
    }
    if (list.length >= 8) break;
  }
  return list;
}

bool matchesAllMembersSentinel(String lowerQuery) {
  if (lowerQuery.isEmpty) return true;
  const tokens = ['全', '全体', '全体成员', 'all', 'qt', 'qtcy'];
  for (final token in tokens) {
    if (token.startsWith(lowerQuery) || lowerQuery.startsWith(token)) {
      return true;
    }
  }
  return false;
}

List<String> buildMentionCandidateLabels({
  required List<ChatContact> groupMembers,
  required List<UiContact> contacts,
}) {
  final names = <String>{};
  for (final member in groupMembers) {
    if (member.name.isNotEmpty) names.add(member.name);
    if (member.remark.isNotEmpty) names.add(member.remark);
    if (member.username.isNotEmpty) names.add(member.username);
  }
  for (final contact in contacts) {
    if (contact.name.isNotEmpty) names.add(contact.name);
    if (contact.rawName.isNotEmpty) names.add(contact.rawName);
    if (contact.remark.isNotEmpty) names.add(contact.remark);
    // username 也作为 mention 候选 (BotFather token 消息 @<bot_xxx> 用 username).
    if (contact.username.isNotEmpty) names.add(contact.username);
  }
  return names.toList()..sort((a, b) => b.length.compareTo(a.length));
}

String trimMentionTrailingPunctuation(String name) {
  var result = name;
  while (result.isNotEmpty &&
      _mentionTrailingPunctuation.contains(result[result.length - 1])) {
    result = result.substring(0, result.length - 1);
  }
  return result;
}

MentionTapResolution resolveMentionTapTarget({
  required String rawName,
  required List<ChatContact> groupMembers,
  required List<UiContact> contacts,
}) {
  final name = trimMentionTrailingPunctuation(rawName);
  if (name.isEmpty) {
    return const MentionTapResolution(kind: MentionTapResolutionKind.empty);
  }

  final memberHits = <String>{};
  for (final member in groupMembers) {
    if (member.uid.isEmpty) continue;
    if (member.name == name ||
        member.remark == name ||
        member.username == name) {
      memberHits.add(member.uid);
    }
  }
  if (memberHits.length > 1) {
    return MentionTapResolution(
      kind: MentionTapResolutionKind.groupDuplicate,
      name: name,
    );
  }

  final memberUid = memberHits.isEmpty ? null : memberHits.first;
  if (memberUid != null) {
    for (final contact in contacts) {
      if (contact.uid == memberUid) {
        return MentionTapResolution(
          kind: MentionTapResolutionKind.contact,
          name: name,
          uid: memberUid,
          contact: contact,
        );
      }
    }
    return MentionTapResolution(
      kind: MentionTapResolutionKind.uid,
      name: name,
      uid: memberUid,
    );
  }

  final contactHits = <String, UiContact>{};
  for (final contact in contacts) {
    if (contact.uid.isEmpty) continue;
    final matches =
        contact.name == name ||
        (contact.rawName.isNotEmpty && contact.rawName == name) ||
        (contact.remark.isNotEmpty && contact.remark == name) ||
        // 给 bot mention 跳转用 (@bot_xxx). username 唯一所以不会重复.
        (contact.username.isNotEmpty && contact.username == name);
    if (matches) {
      contactHits[contact.uid] = contact;
      if (contactHits.length > 1) break;
    }
  }
  if (contactHits.length > 1) {
    return MentionTapResolution(
      kind: MentionTapResolutionKind.contactDuplicate,
      name: name,
    );
  }
  if (contactHits.length == 1) {
    final contact = contactHits.values.first;
    return MentionTapResolution(
      kind: MentionTapResolutionKind.contact,
      name: name,
      uid: contact.uid,
      contact: contact,
    );
  }
  return MentionTapResolution(
    kind: MentionTapResolutionKind.notFound,
    name: name,
  );
}

const Set<String> _mentionTrailingPunctuation = {
  '.',
  ',',
  ';',
  ':',
  '!',
  '?',
  '。',
  '，',
  '；',
  '：',
  '！',
  '？',
};
