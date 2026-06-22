import '../ui/identity_display.dart';

const String kTypingPeerPlaceholder = '对方';
const String kTypingGroupMemberPlaceholder = '成员';
const int kTypingPersonChannelType = 1;
const int kTypingGroupChannelType = 2;

String buildTypingDisplayName({
  required int channelType,
  required String fromName,
  required String fromUid,
}) {
  final placeholder = channelType == kTypingGroupChannelType
      ? kTypingGroupMemberPlaceholder
      : kTypingPeerPlaceholder;
  return moyuDisplayName(
    name: fromName,
    rawIdentity: channelType == kTypingGroupChannelType ? '' : fromUid,
    placeholder: placeholder,
  );
}

String buildTypingLabel({
  required int channelType,
  required List<String> displayNames,
}) {
  if (displayNames.isEmpty) return '';
  final names = <String>[];
  for (var i = 0; i < displayNames.length; i++) {
    var name = displayNames[i].trim();
    if (channelType == kTypingGroupChannelType &&
        name == kTypingPeerPlaceholder) {
      name = kTypingGroupMemberPlaceholder;
    }
    if (name.isEmpty) {
      name = channelType == kTypingGroupChannelType
          ? kTypingGroupMemberPlaceholder
          : kTypingPeerPlaceholder;
    }
    names.add(name);
  }
  if (names.length == 1) {
    if (channelType == kTypingPersonChannelType &&
        names.first == kTypingPeerPlaceholder) {
      return '$kTypingPeerPlaceholder正在输入...';
    }
    if (channelType == kTypingGroupChannelType &&
        names.first == kTypingGroupMemberPlaceholder) {
      return '$kTypingGroupMemberPlaceholder正在输入...';
    }
    return '${names.first} 正在输入...';
  }
  if (names.length == 2) {
    return '${names[0]} 和 ${names[1]} 正在输入...';
  }
  return '几位成员正在输入...';
}
