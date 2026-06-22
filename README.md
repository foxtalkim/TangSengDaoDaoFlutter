# FoxTalk Flutter Client

[中文文档](README_zh.md)

FoxTalk is a Flutter IM client built around the TangSengDaoDao / WuKongIM
protocol stack. The client is compatible with TangSengDaoDao / tsdaodao-style
server deployments, including self-hosted open-source server instances. This
repository contains the public client profile: core login, conversation,
contacts, groups, chat, media messages, settings, and the mobile UI foundation.

This repo is client-only. To run the app end to end, point it at a compatible
TangSengDaoDao server and WuKongIM deployment.

## Requirements

- Flutter SDK with Dart `^3.11.3`
- Android Studio / Android SDK for Android builds
- Xcode and CocoaPods for iOS builds
- A reachable backend base URL for your own deployment

## Configure Server

Provide your server at build or run time:

```bash
--dart-define=CHATIM_SERVER_BASE_URL=<your-server-base-url>
```

The app derives API and web endpoints from that base URL:

- API: `<server>/v1/`
- Web: `<server>/web/`

Choose the target server through build configuration.

## Run

```bash
flutter pub get
flutter run --flavor free -t lib/main_free.dart \
  --dart-define=CHATIM_SERVER_BASE_URL=<your-server-base-url>
```

## Build

Android debug APK:

```bash
flutter build apk --debug --flavor free -t lib/main_free.dart \
  --dart-define=CHATIM_SERVER_BASE_URL=<your-server-base-url>
```

iOS release build:

```bash
cd ios
pod install
cd ..
flutter build ios --release -t lib/main_free.dart \
  --dart-define=CHATIM_SERVER_BASE_URL=<your-server-base-url>
```

## Project Layout

```text
lib/
  main.dart                   App entry
  main_free.dart              Public profile entry
  src/app/                    App bootstrap and runtime
  src/auth/                   Session, login, account state
  src/im/                     WuKongIM integration
  src/social/                 Contacts, groups, user APIs
  src/ui/                     Chat UI and shared components
  src/modules/                Feature registry and public profile
packages/
  wukongimfluttersdk_patched/ Patched WuKongIM Flutter SDK
  stubs/                      Stubs for modules excluded from this profile
```

## Notes

- Keep `lib/main_free.dart` as the public build entry.
- Use `CHATIM_SERVER_BASE_URL` for environment-specific server configuration.
- Generated files under `lib/src/l10n/` come from `lib/l10n/*.arb`.
- Native build artifacts such as `build/`, `.dart_tool/`, and `.gradle/` are
  ignored by Git.
