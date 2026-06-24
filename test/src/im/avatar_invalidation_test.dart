import 'package:flutter_test/flutter_test.dart';
import 'package:wukongimfluttersdk/type/const.dart';

import 'package:foxtalk/src/im/wukong_im_service.dart';

void main() {
  test('maps channel update commands to fixed avatar cache paths', () {
    final personalTargets = WukongImService.avatarInvalidationTargetsForCommand(
      'channelUpdate',
      {'channel_id': 'user-b', 'channel_type': WKChannelType.personal},
    );

    expect(personalTargets, hasLength(1));
    expect(personalTargets.single.channelId, 'user-b');
    expect(personalTargets.single.channelType, WKChannelType.personal);
    expect(personalTargets.single.avatarPath, 'users/user-b/avatar');

    final groupTargets = WukongImService.avatarInvalidationTargetsForCommand(
      'channelUpdate',
      {'channel_id': 'group-a', 'channel_type': WKChannelType.group},
    );

    expect(groupTargets, hasLength(1));
    expect(groupTargets.single.channelId, 'group-a');
    expect(groupTargets.single.channelType, WKChannelType.group);
    expect(groupTargets.single.avatarPath, 'groups/group-a/avatar');
  });

  test('maps dedicated avatar update commands to cache paths', () {
    final userTargets = WukongImService.avatarInvalidationTargetsForCommand(
      'userAvatarUpdate',
      {'uid': 'user-b'},
    );

    expect(userTargets, hasLength(1));
    expect(userTargets.single.channelId, 'user-b');
    expect(userTargets.single.channelType, WKChannelType.personal);
    expect(userTargets.single.avatarPath, 'users/user-b/avatar');

    final groupTargets = WukongImService.avatarInvalidationTargetsForCommand(
      'groupAvatarUpdate',
      {'group_no': 'group-a'},
    );

    expect(groupTargets, hasLength(1));
    expect(groupTargets.single.channelId, 'group-a');
    expect(groupTargets.single.channelType, WKChannelType.group);
    expect(groupTargets.single.avatarPath, 'groups/group-a/avatar');
  });
}
