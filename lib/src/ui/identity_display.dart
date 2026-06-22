/// User-visible identity fallback helpers.
/// IM/social payloads often carry only uid/channelId. Those ids are valid for
/// API calls and cache keys, but they must not become display names.
bool moyuLooksLikeRawIdentity(String value) {
  final trimmed = value.trim();
  if (trimmed.length < 24) return false;
  return RegExp(r'^[0-9a-fA-F]+$').hasMatch(trimmed);
}

String _firstVisibleIdentityCandidate(
  Iterable<String> candidates,
  String rawIdentity,
) {
  final raw = rawIdentity.trim();
  for (final candidate in candidates) {
    final trimmed = candidate.trim();
    if (trimmed.isNotEmpty &&
        trimmed != raw &&
        !moyuLooksLikeRawIdentity(trimmed)) {
      return trimmed;
    }
  }
  return '';
}

String moyuDisplayName({
  String remark = '',
  String name = '',
  String rawIdentity = '',
  required String placeholder,
}) {
  final resolved = _firstVisibleIdentityCandidate([remark, name], rawIdentity);
  return resolved.isEmpty ? placeholder : resolved;
}

String moyuSelfDisplayName({
  String loginName = '',
  String sessionName = '',
  String sessionUsername = '',
  String contactName = '',
  String rawIdentity = '',
  String placeholder = '我',
}) {
  final resolved = _firstVisibleIdentityCandidate([
    loginName,
    sessionName,
    sessionUsername,
    contactName,
  ], rawIdentity);
  return resolved.isEmpty ? placeholder : resolved;
}

String moyuSenderDisplayName({
  String friendRemark = '',
  String memberRemark = '',
  String memberName = '',
  String channelRemark = '',
  String channelName = '',
  String rawIdentity = '',
}) {
  return _firstVisibleIdentityCandidate([
    friendRemark,
    memberRemark,
    memberName,
    channelRemark,
    channelName,
  ], rawIdentity);
}

String moyuChannelPlaceholder(int channelType) {
  if (channelType == 2) return '群聊';
  if (channelType == 1) return '对方';
  return '聊天';
}

String moyuIncomingCallTitle({
  required bool isGroupCall,
  String payloadName = '',
  String cachedName = '',
  String rawIdentity = '',
}) {
  return moyuDisplayName(
    remark: payloadName,
    name: cachedName,
    rawIdentity: rawIdentity,
    placeholder: isGroupCall ? '群通话邀请' : '未知来电',
  );
}

String moyuProfileFallbackNotice({
  required String rawIdentity,
  bool notFound = false,
}) {
  return notFound ? '未找到用户' : '无法打开名片';
}
