# WuKongIM Flutter SDK Patch Notes

This directory is a vendored patched copy of `wukongimfluttersdk`.

Upstream reference currently used by the app:

- package: `wukongimfluttersdk`
- version: `1.7.9`
- source: `https://github.com/wzyonggege/WuKongIMFlutterSDK.git`
- commit observed by Flutter dependency resolution: `b909ec`

## Local Patch Series

### 0001 - Stabilize connect lifecycle and offline resend aging

Local commit: `8da4cb5f`

Files:

- `lib/manager/connect_manager.dart`
- `test/connect_manager_send_queue_test.dart`

Intent:

- Route socket `onDone` / `onError` into one disconnect path.
- Add connect generation and reconnect gate so stale async callbacks cannot win.
- Replace fixed reconnect delay with capped exponential backoff.
- Pause reconnect churn while network is unavailable.
- Close stale sockets before ping-timeout reconnect.
- Prevent offline / reconnecting send-queue checks from aging pending messages.

Replay guidance for upstream sync:

1. Rebase upstream to the reference commit or newer.
2. Re-apply the changes above in the listed file order.
3. Run:

```bash
cd repo/TangSengDaoDaoFlutter/packages/wukongimfluttersdk_patched
flutter analyze lib/manager/connect_manager.dart
flutter test test/connect_manager_send_queue_test.dart --plain-name "offline send queue check does not age pending messages"
```

4. Then run the app-level IM reconnect tests from the Flutter app root.

Do not edit the app service layer to compensate for SDK connection ownership
unless this patch has first been checked against the new upstream implementation.

### 0002 - Guard live conversation latest against stale message replay

Local commit: pending

Files:

- `lib/db/conversation.dart`
- `test/conversation_freshness_test.dart`

Intent:

- Match iOS `WKConversationManager.needUpdate`: a live message may increment
  and refresh the conversation only when it is newer than the current latest
  message.
- Let local optimistic messages with `message_seq=0` still promote by newer
  timestamp.
- Let send ack promote the same local message from `message_seq=0` to the
  server-assigned seq.
- Drop stale server replay / reconnect sync messages before they overwrite
  `last_msg_seq`, `last_client_msg_no`, `last_msg_timestamp`, or unread count.

Replay guidance for upstream sync:

1. Re-apply the `ConversationDB.shouldReplaceLiveLastMessage` helper and call it
   from `insertOrUpdateWithConvMsg` before mutating the existing conversation.
2. Run:

```bash
cd repo/TangSengDaoDaoFlutter/packages/wukongimfluttersdk_patched
flutter test test/conversation_freshness_test.dart
```

3. Then run the app-level conversation freshness tests from the Flutter app root.
