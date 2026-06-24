# FoxTalk Flutter Client

[English](README.md)

FoxTalk 是一个基于 TangSengDaoDao / WuKongIM 协议栈的 Flutter 即时通讯客户端。
客户端兼容 TangSengDaoDao / tsdaodao 风格的服务端部署，包括自行部署的开源服务端实例。
这个仓库包含公开客户端配置：登录、会话、通讯录、群聊、聊天、媒体消息、设置，以及移动端 UI 基础组件。

本仓库只包含客户端代码。完整运行需要连接到兼容的 TangSengDaoDao 服务端和 WuKongIM 部署。

## 环境要求

- Flutter SDK，Dart `^3.11.3`
- Android Studio / Android SDK，用于 Android 构建
- Xcode 和 CocoaPods，用于 iOS 构建
- 一个你自己部署的后端地址

## 配置服务端

运行或构建时通过 `CHATIM_SERVER_BASE_URL` 指定自己的服务端：

```bash
--dart-define=CHATIM_SERVER_BASE_URL=<your-server-base-url>
```

客户端会基于该地址派生接口和 Web 地址：

- API: `<server>/v1/`
- Web: `<server>/web/`

不同环境的服务端地址建议通过构建参数管理。

## 本地运行

```bash
flutter pub get
flutter run \
  --dart-define=CHATIM_SERVER_BASE_URL=<your-server-base-url>
```

## 构建

Android Debug APK：

```bash
flutter build apk --debug \
  --dart-define=CHATIM_SERVER_BASE_URL=<your-server-base-url>
```

iOS Release：

```bash
cd ios
pod install
cd ..
flutter build ios --release \
  --dart-define=CHATIM_SERVER_BASE_URL=<your-server-base-url>
```

## 目录结构

```text
lib/
  main.dart                    公开客户端入口
  src/app/                     应用启动与运行时
  src/auth/                    登录、会话、账号状态
  src/im/                      WuKongIM 接入
  src/social/                  通讯录、群组、用户接口
  src/ui/                      聊天界面与通用组件
  src/modules/                 功能注册与公开 profile
packages/
  wukongimfluttersdk_patched/   调整后的 WuKongIM Flutter SDK
  stubs/                        当前 profile 未启用模块的占位实现
```

## 说明

- 公开客户端入口为 `lib/main.dart`。
- 服务端地址通过 `CHATIM_SERVER_BASE_URL` 配置。
- `lib/src/l10n/` 下的本地化代码由 `lib/l10n/*.arb` 生成。
- `build/`、`.dart_tool/`、`.gradle/` 等本地构建产物已在 Git 中忽略。
