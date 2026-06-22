import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/forui.dart';

import 'app_runtime.dart';
import '../auth/auth_repository.dart';
import '../auth/locale_controller.dart';
import '../auth/locale_store.dart';
import '../auth/onboarding_store.dart';
import '../auth/recent_account_store.dart';
import '../auth/session_store.dart';
import '../db/database.dart';
import '../settings/bubble_color_controller.dart';
import '../settings/bubble_color_store.dart';
import '../settings/bubble_radius_controller.dart';
import '../settings/bubble_radius_store.dart';
import '../settings/font_scale_controller.dart';
import '../settings/font_scale_store.dart';
import '../settings/tab_bar_style_controller.dart';
import '../settings/tab_bar_style_store.dart';
import '../settings/theme_mode_controller.dart';
import '../settings/theme_mode_store.dart';
import '../l10n/app_localizations.dart';
import '../auth/user_session.dart';
import '../call/call_session_lifecycle.dart';
import '../call/chat_call_gateway.dart';
import '../config/app_brand.dart';
import '../config/app_config.dart';
import '../im/wukong_im_service.dart';
import '../media/chat_media_service.dart';
import '../modules/module_ids.dart';
import '../network/api_client.dart';
import '../push/push_service.dart' show PushService, LocalNotificationCenter;
import '../scan/chat_scan_service.dart';
import '../server/server_profile.dart';
import '../server/server_profile_store.dart';
import '../social/social_cache_lifecycle.dart';
import '../social/social_service.dart';
import '../ui/home_shell.dart';
import '../ui/login_screen.dart';
import '../ui/moyu_theme.dart';
import '../ui/moyu_widgets.dart';
import '../ui/onboarding_screen.dart';
import '../ui/pages/account_pages.dart' show CompleteProfilePage;

class ChatImApp extends StatefulWidget {
  const ChatImApp({
    super.key,
    this.authRepositoryFactory,
    this.runtime,
    this.serverProfileResolver,
    this.loginServerSwitchEnabled = true,
  });

  final AuthRepositoryFactory? authRepositoryFactory;
  final AppRuntime? runtime;
  final ServerProfileResolver? serverProfileResolver;
  final bool loginServerSwitchEnabled;

  @override
  State<ChatImApp> createState() => _ChatImAppState();
}

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

class _ChatImAppState extends State<ChatImApp> with WidgetsBindingObserver {
  UserSession? _session;
  AppConfig _config = AppConfig.defaultConfig();
  late ServerProfile _serverProfile = ServerProfile.fromConfig(_config);
  ChatServerAppConfig _serverAppConfig = const ChatServerAppConfig();
  WukongImService? _imService;
  ChatSocialService? _socialService;
  ChatMediaService? _mediaService;
  ChatScanService? _scanService;
  ChatCallGateway? _callGateway;
  final PushService _pushService = PushService();
  StreamSubscription<void>? _kickedSubscription;
  bool _bootRestoring = true;
  bool _onboardingCompleted = false;

  /// Wall-clock instant when the app last entered background. Used by
  /// `_maybeShowLockScreen` on resume to compute idle time against the
  /// session's `lockAfterMinute` threshold. Mirrors iOS
  /// `loginInfo.extra['enter_background_time']` (WKApp.m:655).
  DateTime? _enterBgAt;

  /// iOS only — paused 立即 disconnect IM 长连接, wukongim 立即判定
  /// offline → fire `msg.offline` → server 推 APNS (跟微信 / WhatsApp
  /// 同模式).
  ///
  /// **不能用 Timer 延迟** — iOS 系统在 `applicationDidEnterBackground`
  /// 后 ~5 秒挂起 Dart isolate (除非 native 申请 beginBackgroundTask), Timer
  /// fire 不了. 原版 iOS WKApp.m:648-652 用 native beginBackgroundTask
  /// 申请 30s grace period, Flutter Dart 端没这个能力, 必须立即 disconnect.
  ///
  /// Android 不做 (后台 process 一直活, 走本地通知更省电).

  /// Re-entrancy guard so the lock-screen modal isn't pushed twice if
  /// the app cycles backgrounded→foregrounded while the page is up.
  bool _showingLockScreen = false;

  /// Persisted language preference (`system` / `zh` / `en`). Loaded in
  /// initState so the very first `build` already uses the right
  /// locale — otherwise the app would flash zh for one frame before
  /// switching to the user's pinned English. Mutated by the 通用 → 语言
  /// picker via `_setLocalePreference`, which writes through to
  /// SharedPreferences AND `setState`s the app.
  String _localePref = LocaleStore.systemPreference;

  /// 字号缩放偏好 (canonical key — small / standard / large / extra_large).
  /// 跟 _localePref 同模式 — initState load, 设置页改时 setState + save.
  /// 应用到 MediaQuery.textScaler 在 builder 内做 (TextScaler.linear).
  String _fontScalePref = FontScaleStore.defaultPreference;

  /// 深色模式偏好 (canonical key — system / light / dark). 对齐 iOS
  /// WKDarkModeVC 三态. 应用到 MaterialApp.themeMode + forui FTheme
  /// brightness 切换 (zinc.dark vs zinc.light).
  String _themeModePref = ThemeModeStore.systemPreference;

  /// 聊天气泡圆角偏好 (4-24pt double). 默认 18 跟原 hardcode 一致.
  /// 设置页 Slider 拖动改这个 → BubbleRadiusController.of(ctx).current
  /// → 所有气泡 borderRadius 实时刷新.
  double _bubbleRadiusPref = BubbleRadiusStore.defaultRadius;

  /// 聊天颜色偏好 (canonical key — ink/purple/green/blue/orange/pink).
  /// 默认 'ink' (Moyu ink 黑). 外观 → 聊天颜色 swatch 改这个 →
  /// BubbleColorController.of(ctx).current → 自己气泡 bg + fg 实时变.
  String _bubbleColorPref = BubbleColorStore.defaultPreference;
  String _tabBarStylePref = TabBarStyleStore.glassDock;
  bool _dockFollowsChatColorPref = false;

  ServerProfileResolver get _profileResolver =>
      widget.serverProfileResolver ?? const OpenSourceServerProfileResolver();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_restoreLocalePreference());
    unawaited(_restoreFontScalePreference());
    unawaited(_restoreThemeModePreference());
    unawaited(_restoreBubbleRadiusPreference());
    unawaited(_restoreBubbleColorPreference());
    unawaited(_restoreTabBarStylePreference());
    unawaited(_restoreDockFollowsChatColorPreference());
    unawaited(_restorePersistedSession());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _enterBgAt = DateTime.now();
      _scheduleBgDisconnect();
    } else if (state == AppLifecycleState.resumed) {
      _cancelBgDisconnectAndReconnect();
      // 标记 resume 时间 — 5 秒内不弹本地通知 (paused 期间 APNS 已显示
      // 过, SDK reconnect 补送同条避免横幅重复). 见 LocalNotificationCenter.
      LocalNotificationCenter.instance.markResumed();
      _maybeShowLockScreen();
      _enterBgAt = null;
    }
  }

  /// iOS 切后台后主动 disconnect, 让 wukongim 立即判定离线 → server 推 APNS.
  /// 原版 WKApp.m:648-652 靠 native background task 等 30s; Flutter Dart
  /// isolate 后台会被挂起, 这里直接断开. Android 不动 (后台保持长连接走本地通知).
  void _scheduleBgDisconnect() {
    if (!Platform.isIOS) return;
    if (_imService == null) return;
    // 立即 disconnect — iOS 5 秒后 suspend Dart isolate, Timer 没用.
    debugPrint('[lifecycle][bg] immediate disconnect');
    WukongImService.disconnect();
  }

  /// 切回前台 — 统一走 IM recovery。iOS 后台会主动 disconnect；Android
  /// Doze / 长后台回来即使 UI 还显示 connected，也做一次轻量 hydration，
  /// 长后台则强制 reconnect，避免假在线。
  void _cancelBgDisconnectAndReconnect() {
    debugPrint('[lifecycle][fg] recover connection');
    final session = _session;
    final imService = _imService;
    if (session == null || imService == null) return;
    final bgDuration = _enterBgAt == null
        ? Duration.zero
        : DateTime.now().difference(_enterBgAt!);
    final forceReconnect =
        Platform.isIOS ||
        bgDuration >= const Duration(seconds: 30) ||
        imService.currentConnectionStatus != ChatConnectionStatus.connected;
    unawaited(
      imService
          .recoverConnection(
            session,
            reason: 'foreground_resume',
            forceReconnect: forceReconnect,
          )
          .catchError((e) {
            debugPrint('[lifecycle] foreground recovery fail: $e');
          }),
    );
  }

  /// Decide whether the foreground transition should prompt for the
  /// lock-screen password. Mirrors iOS
  /// `WKApp.showLockScreenProtectIfNeed` (WKApp.m:1519-1540):
  ///   * no logged-in session → skip
  ///   * `lockScreenPwd` empty (user never set one) → skip
  ///   * already showing the modal → skip
  ///   * `lockAfterMinute == 0` ("立即") → always prompt
  ///   * elapsed bg time < lockAfterMinute*60 → skip
  /// On every other path we push a full-screen `_LockScreenInputPage`
  /// onto the root navigator so the home shell stays underneath.
  void _maybeShowLockScreen() {
    final session = _session;
    if (session == null) return;
    // 优先读 UserSession.current — settings page (_closePassword / _setPassword
    // / _setLockAfterMinute) 改完只写 UserSession.current + SessionStore.save,
    // 不动 _ChatImAppState._session. 不读 latest 会导致 "关了锁屏密码后回前台
    // 仍要密码" / "刚设了密码没拦" 等 stale 行为. _session 字段保留只为不影响
    // 别的 widget tree rebuild trigger.
    final latest = UserSession.current ?? session;
    if (latest.lockScreenPwd.isEmpty) return;
    if (_showingLockScreen) return;
    final bgAt = _enterBgAt;
    final thresholdSec = latest.lockAfterMinute * 60;
    if (latest.lockAfterMinute > 0 && bgAt != null) {
      final elapsedSec = DateTime.now().difference(bgAt).inSeconds;
      if (elapsedSec < thresholdSec) return;
    }
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;
    _showingLockScreen = true;
    navigator
        .push(
          MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (_) => _LockScreenInputPage(session: latest),
          ),
        )
        .whenComplete(() {
          _showingLockScreen = false;
        });
  }

  Future<void> _restoreLocalePreference() async {
    final pref = await LocaleStore.loadPreference();
    if (!mounted || pref == _localePref) return;
    setState(() => _localePref = pref);
  }

  /// Update the persisted language choice and re-render so MaterialApp
  /// flips locale immediately. Called from the 我 → 通用 → 语言 picker.
  Future<void> _setLocalePreference(String pref) async {
    await LocaleStore.savePreference(pref);
    if (!mounted) return;
    setState(() => _localePref = pref);
  }

  Future<void> _restoreFontScalePreference() async {
    final pref = await FontScaleStore.loadPreference();
    if (!mounted || pref == _fontScalePref) return;
    setState(() => _fontScalePref = pref);
  }

  /// 设置页选定字号档调这个 — 写 SharedPreferences 并 setState 让全局
  /// MediaQuery.textScaler 立刻 rebuild.
  Future<void> _setFontScalePreference(String pref) async {
    await FontScaleStore.savePreference(pref);
    if (!mounted) return;
    setState(() => _fontScalePref = pref);
  }

  Future<void> _restoreThemeModePreference() async {
    final pref = await ThemeModeStore.loadPreference();
    if (!mounted || pref == _themeModePref) return;
    setState(() => _themeModePref = pref);
  }

  /// 设置页选定深色模式档调这个 — 写 SharedPreferences 并 setState 让
  /// MaterialApp.themeMode / FTheme.brightness 立刻 rebuild.
  Future<void> _setThemeModePreference(String pref) async {
    await ThemeModeStore.savePreference(pref);
    if (!mounted) return;
    setState(() => _themeModePref = pref);
  }

  Future<void> _restoreBubbleRadiusPreference() async {
    final pref = await BubbleRadiusStore.loadPreference();
    if (!mounted || pref == _bubbleRadiusPref) return;
    setState(() => _bubbleRadiusPref = pref);
  }

  /// 设置页 Slider 拖动 / 松手时调 — 写 SharedPreferences + setState 让
  /// BubbleRadiusController 触发所有气泡 borderRadius rebuild.
  Future<void> _setBubbleRadiusPreference(double radius) async {
    await BubbleRadiusStore.savePreference(radius);
    if (!mounted) return;
    setState(() => _bubbleRadiusPref = radius);
  }

  Future<void> _restoreBubbleColorPreference() async {
    final pref = await BubbleColorStore.loadPreference();
    if (!mounted || pref == _bubbleColorPref) return;
    setState(() => _bubbleColorPref = pref);
  }

  /// 设置页 swatch tap 时调 — 写 SharedPreferences + setState 让
  /// BubbleColorController 触发所有自己气泡 bg/fg rebuild.
  Future<void> _setBubbleColorPreference(String pref) async {
    await BubbleColorStore.savePreference(pref);
    if (!mounted) return;
    setState(() => _bubbleColorPref = pref);
  }

  Future<void> _restoreTabBarStylePreference() async {
    final pref = await TabBarStyleStore.loadPreference();
    if (!mounted || pref == _tabBarStylePref) return;
    setState(() => _tabBarStylePref = pref);
  }

  Future<void> _setTabBarStylePreference(String pref) async {
    await TabBarStyleStore.savePreference(pref);
    if (!mounted || pref == _tabBarStylePref) return;
    setState(() => _tabBarStylePref = pref);
  }

  Future<void> _restoreDockFollowsChatColorPreference() async {
    final pref = await TabBarStyleStore.loadDockFollowsChatColor();
    if (!mounted || pref == _dockFollowsChatColorPref) return;
    setState(() => _dockFollowsChatColorPref = pref);
  }

  Future<void> _setDockFollowsChatColorPreference(bool pref) async {
    await TabBarStyleStore.saveDockFollowsChatColor(pref);
    if (!mounted || pref == _dockFollowsChatColorPref) return;
    setState(() => _dockFollowsChatColorPref = pref);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _kickedSubscription?.cancel();
    _imService?.dispose();
    super.dispose();
  }

  /// Re-hydrate a saved session on cold start so the user doesn't have
  /// to re-enter credentials after every install. Mirrors iOS native
  /// `WKLoginInfo.load` which decodes the archive at app launch and
  /// drives `WKApp.isLogined`. If the IM handshake fails (token
  /// expired / server rejected), drop the saved blob and fall back
  /// to the login screen so the user sees a clean state instead of
  /// a hung app.
  /// Boot 完成的统一收尾: 翻 `_bootRestoring` flag + 移除 native splash。
  /// app_bootstrap 里 `FlutterNativeSplash.preserve()` 保留 splash 直到这里
  /// 触发 remove, 消除"native splash → 白屏 → 首屏"中间过渡。所有 boot
  /// 退出路径 (无 saved / saved 成功 / saved 失败) finally 块都走它, 不漏调
  /// 也不重复 setState。
  void _finishBoot() {
    if (!mounted) return;
    setState(() => _bootRestoring = false);
    FlutterNativeSplash.remove();
  }

  Future<void> _restorePersistedSession() async {
    final onboardingCompleted = await OnboardingStore.isCompleted();
    if (mounted && onboardingCompleted != _onboardingCompleted) {
      setState(() => _onboardingCompleted = onboardingCompleted);
    }
    final profile = await ServerProfileStore.loadActive(
      resolver: _profileResolver,
    );
    widget.runtime?.applyServerProfile(profile);
    if (mounted) {
      setState(() {
        _config = profile.config;
        _serverProfile = profile;
      });
    }
    final saved = await SessionStore.load(serverScope: profile.storageScope);
    if (saved == null) {
      _finishBoot();
      return;
    }
    if (!onboardingCompleted) {
      await OnboardingStore.markCompleted();
      if (mounted) setState(() => _onboardingCompleted = true);
    }
    try {
      await _activateSession(
        profile: profile,
        client: ApiClient(config: profile.config)..token = saved.token,
        session: saved,
      );
    } catch (_) {
      // Token rejected / IM unreachable — let the user sign in again.
      await SessionStore.clear(serverScope: profile.storageScope);
      if (mounted) {
        setState(() {
          _session = null;
          _imService = null;
          _socialService = null;
          _mediaService = null;
          _scanService = null;
          _callGateway = null;
        });
      }
    } finally {
      _finishBoot();
    }
  }

  @override
  Widget build(BuildContext context) {
    final foruiLightTheme = MoyuTheme.forui();
    final foruiDarkTheme = MoyuTheme.foruiDark();

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: AppBrand.displayName,
      debugShowCheckedModeBanner: false,
      // App's own ARB-generated localizations sit alongside the forui
      // delegates — both must be present so `AppLocalizations.of` and
      // FLocalizations both work. `locale: null` lets MaterialApp use
      // the system locale; pinning to zh / en bypasses that fallback.
      locale: LocaleStore.toLocale(_localePref),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        ...FLocalizations.localizationsDelegates,
      ],
      // light + dark Material theme + themeMode 由设置页 ThemeModeController
      // 决定. 当前 _themeModePref ∈ {system, light, dark} → 对应 ThemeMode.
      // 注意: MoyuColors 还是 hardcode light 配色, 真正深色生效需要后续
      // 把 MoyuColors 改成 InheritedWidget-aware + 全代码 .of(context).xxx.
      theme: foruiLightTheme.toApproximateMaterialTheme(),
      darkTheme: foruiDarkTheme.toApproximateMaterialTheme(),
      themeMode: ThemeModeStore.toThemeMode(_themeModePref),
      builder: (ctx, child) {
        // 字号缩放注入 — TextScaler.linear 让所有 Text 跟着用户档位变.
        // MediaQuery.withClampedTextScaling 不用 (clamp 是限制 OS 系统级
        // 字号, 这里需要的是覆盖). 直接 wrap MediaQuery + 替换 textScaler.
        final mq = MediaQuery.of(ctx);
        final scale = FontScaleStore.scaleFor(_fontScalePref);
        // FTheme + MoyuColors.of(context) 都需要正确的 effective brightness.
        // builder 内 Theme.of(ctx) 在某些 Flutter 版本上可能返回 MaterialApp
        // 没注入的 default light theme (跟 themeMode = dark 不一致), 导致
        // MoyuColors.of(context) 在子级读到错 brightness. 直接根据
        // _themeModePref + platformBrightness 自己 resolve 最可靠.
        final effectiveBrightness = switch (_themeModePref) {
          ThemeModeStore.lightPreference => Brightness.light,
          ThemeModeStore.darkPreference => Brightness.dark,
          _ => MediaQuery.platformBrightnessOf(ctx),
        };
        final foruiTheme = effectiveBrightness == Brightness.dark
            ? foruiDarkTheme
            : foruiLightTheme;
        return MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(scale)),
          child: LocaleController(
            current: _localePref,
            change: _setLocalePreference,
            child: FontScaleController(
              current: _fontScalePref,
              change: _setFontScalePreference,
              child: ThemeModeController(
                current: _themeModePref,
                change: _setThemeModePreference,
                child: TabBarStyleController(
                  current: _tabBarStylePref,
                  change: _setTabBarStylePreference,
                  dockFollowsChatColor: _dockFollowsChatColorPref,
                  changeDockFollowsChatColor:
                      _setDockFollowsChatColorPreference,
                  child: BubbleRadiusController(
                    current: _bubbleRadiusPref,
                    change: _setBubbleRadiusPreference,
                    child: BubbleColorController(
                      current: _bubbleColorPref,
                      change: _setBubbleColorPreference,
                      child: FTheme(
                        data: foruiTheme,
                        child: FToaster(child: FTooltipGroup(child: child!)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      home: _bootRestoring
          ? const _SessionRestoreSplash()
          : _session == null
          ? !_onboardingCompleted
                ? OnboardingScreen(
                    onComplete: () => unawaited(_completeOnboarding()),
                  )
                : LoginScreen(
                    initialConfig: _config,
                    onLogin: _handleLogin,
                    onVerifyLogin: _handleVerificationLogin,
                    onRegister: _handleRegisterSession,
                    showServerSwitch: widget.loginServerSwitchEnabled,
                    authRepositoryFactory:
                        widget.authRepositoryFactory ?? _authRepositoryFor,
                  )
          : _serverAppConfig.registerUserMustCompleteInfoOn &&
                _session!.name.isEmpty
          ? CompleteProfilePage(
              session: _session!,
              socialGateway: _socialService,
              mediaGateway: _mediaService,
              onComplete: _handleProfileComplete,
            )
          : HomeShell(
              session: _session!,
              config: _config,
              serverScope: _serverProfile.storageScope,
              imGateway: _imService,
              socialGateway: _socialService,
              mediaGateway: _mediaService,
              scanGateway: _scanService,
              callGateway: _callGateway,
              runtime: widget.runtime,
              serverAppConfig: _serverAppConfig,
              onLogout: _handleLogout,
            ),
    );
  }

  Future<void> _completeOnboarding() async {
    await OnboardingStore.markCompleted();
    if (!mounted) return;
    setState(() => _onboardingCompleted = true);
  }

  AuthRepository _authRepositoryFor(AppConfig config) =>
      AuthRepository(client: ApiClient(config: config));

  Future<UserSession> _handleLogin({
    required AppConfig config,
    required String username,
    required String password,
  }) async {
    final profile = await _resolveServerProfile(config);
    final client = ApiClient(config: profile.config);
    final repository = AuthRepository(client: client);
    final session = await repository.login(
      username: username,
      password: password,
    );
    return _activateSession(profile: profile, client: client, session: session);
  }

  Future<UserSession> _handleVerificationLogin({
    required AppConfig config,
    required String uid,
    required String code,
  }) async {
    final profile = await _resolveServerProfile(config);
    final client = ApiClient(config: profile.config);
    final repository = AuthRepository(client: client);
    final session = await repository.loginCheckPhone(uid: uid, code: code);
    return _activateSession(profile: profile, client: client, session: session);
  }

  Future<UserSession> _handleRegisterSession({
    required AppConfig config,
    required UserSession session,
  }) async {
    final profile = await _resolveServerProfile(config);
    final client = ApiClient(config: profile.config);
    client.token = session.token;
    return _activateSession(profile: profile, client: client, session: session);
  }

  Future<ServerProfile> _resolveServerProfile(AppConfig config) async {
    try {
      return await _profileResolver.resolve(config);
    } catch (error) {
      debugPrint('[server] profile resolve fail: $error');
      return ServerProfile.fromConfig(config);
    }
  }

  Future<UserSession> _activateSession({
    required ServerProfile profile,
    required ApiClient client,
    required UserSession session,
  }) async {
    widget.runtime?.applyServerProfile(profile);
    final imService = WukongImService(
      client: client,
      featureRegistry: widget.runtime?.registry,
    );
    await imService.connect(session);
    // 预加载会话列表 + 拉 server app config: 之前是顺序 await, cold-start 加起来
    // 1-3s, 总启动卡 5-8s 体验差。改为 fire-and-forget — HomeShell 内部有
    // `_loadRemoteConversations` 兜底拉, `_serverAppConfig` 默认值不影响主路径
    // (register-must-complete-info 等配置完成后 setState 再生效)。session +
    // imService ready 后立即 setState 让 HomeShell 显示, 总启动 ~ connect()
    // 本身耗时 (2-4s)。
    unawaited(
      imService.loadConversations().catchError((e) {
        debugPrint('[main] preload conversations fail: $e');
        return const <WukongConversationSnapshot>[];
      }),
    );
    final authRepo = AuthRepository(client: client);
    unawaited(
      authRepo
          .loadAppConfig()
          .then((cfg) {
            if (mounted) setState(() => _serverAppConfig = cfg);
          })
          .catchError((_) {}),
    );
    const serverAppConfig = ChatServerAppConfig();
    final socialService = ChatSocialService(
      client: client,
      loginUid: session.uid,
      serverScope: profile.storageScope,
    );
    final mediaService = ChatMediaService(client: client);
    final scanService = ChatScanService();
    final callGateway = _createCallGateway(client, widget.runtime);
    // Keep the session for the next launch — same key (`WKLoginInfo`)
    // and same intent as the iOS `WKLoginInfo.save` path. Awaited so
    // the prefs write is durable before the UI flips to the home
    // shell.
    await ServerProfileStore.saveActive(profile);
    await SessionStore.save(session, serverScope: profile.storageScope);
    await RecentAccountStore.saveFromSession(
      session,
      serverScope: profile.storageScope,
    );
    // Re-arm the kicked-by-other-device subscription against the new
    // service instance so a re-login after kick keeps working.
    await _kickedSubscription?.cancel();
    _kickedSubscription = imService.kickedSignals.listen(
      (_) => unawaited(_handleKickedByOtherDevice()),
    );
    // Push 注册 — login 成功后 fire-and-forget 拿 device_token + 上报 server.
    // iOS 走 APNS (flutter_apns_only), Android 走 FCM (firebase_messaging).
    // 失败不阻塞 login (server 没推也走长连接 fallback). 见 push_service.dart.
    if (_shouldStartVendorPush(widget.runtime)) {
      unawaited(_pushService.start(socialService));
    }
    // 本地通知 init — app 在后台 process 活时, IM 长连接收到消息走
    // `_applyRemoteMessage` → `LocalNotificationCenter.showMessage` 弹横幅.
    // 跟微信"app 在后台收新消息有横幅" 行为一致, 不依赖 FCM/APNS.
    unawaited(LocalNotificationCenter.instance.init());
    if (mounted) {
      setState(() {
        _config = profile.config;
        _serverProfile = profile;
        _serverAppConfig = serverAppConfig;
        _session = session;
        _imService = imService;
        _socialService = socialService;
        _mediaService = mediaService;
        _scanService = scanService;
        _callGateway = callGateway;
      });
    }
    return session;
  }

  Future<void> _handleKickedByOtherDevice() async {
    // Mirrors iOS `WKSystemMessageHandler.onKick:` — drop local
    // session, surface a system alert, and bounce to login. The
    // alert copy matches WuKongBase `Localizable.strings`.
    await SessionStore.clear(serverScope: _serverProfile.storageScope);
    // Push: 跟 logout 同模式 — 异地登录被踢后, server 不应该再把通知
    // 推到 this 进程的 token 上 (B 端已是新 active session). fire-and-forget.
    unawaited(_pushService.stop());
    // 本地 dispose. 之前只本地 dispose → 对端 LiveKit 占着, 卡在"通话中"
    // 等到超时才自动结束.
    await notifyActiveCallPeerOnExit();
    // Tear down any active RTC call so the kicked user doesn't keep
    // a hot mic + LiveKit room + PIP overlay floating after logout.
    // _CallSessionStore.end() also clears the floating PIP entry.
    try {
      await _callGateway?.dispose();
    } catch (e) {
      // logout 路径 dispose 失败 = 通话资源可能残留 (hot mic / LiveKit
      // room / PIP). 关键路径必 log.
      debugPrint('[main][logout] callGateway dispose failed: $e');
    }
    endActiveRtcSession();
    _imService?.dispose();
    WukongImService.disconnect();
    // 关 app 层 sqflite 连接 — db 文件按 uid 隔离自然不串台 (foxtalk_<uid>.db),
    // close 只释放当前 file handle, 下次同 uid 登录直接命中本地 cache.
    unawaited(FoxTalkDatabase.instance.close());
    // 清朋友圈进程内 cache, 防止 logout-切账号-同 process 时 B 看到 A
    // 没 loginUid scope). HomeShell.initState 的 bindAccount 也会检测, 双保险.
    clearSocialProcessCaches();
    unawaited(_mediaService?.dispose() ?? Future.value());
    if (!mounted) return;
    setState(() {
      _session = null;
      _serverAppConfig = const ChatServerAppConfig();
      _imService = null;
      _socialService = null;
      _mediaService = null;
      _scanService = null;
      _callGateway = null;
    });
    _returnToLoginRoot();
    final navigatorContext = _navigatorKey.currentContext;
    if (navigatorContext == null) return;
    if (!navigatorContext.mounted) return;
    await MoyuActionSheet.show(
      navigatorContext,
      title: AppLocalizations.of(navigatorContext).authKickedTitle,
      showCancel: false,
      items: [
        MoyuActionSheetItem(
          title: AppLocalizations.of(navigatorContext).actionConfirm,
          onSelected: _returnToLoginRoot,
        ),
      ],
    );
  }

  void _returnToLoginRoot() {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;
    if (navigator.canPop()) {
      navigator.popUntil((route) => route.isFirst);
    }
  }

  void _handleLogout() {
    unawaited(SessionStore.clear(serverScope: _serverProfile.storageScope));
    // Push: 通知 server 取消 device_token, 不再推. fire-and-forget, 错误
    // 不阻塞 logout 主流程 (server 端 TTL 也会自动清理 stale token).
    unawaited(_pushService.stop());
    // notifyPeerOnExit 内有 timeout, 不阻塞 logout 主流程太久).
    unawaited(notifyActiveCallPeerOnExit());
    // Same RTC teardown as the kicked path. Logout while in a call
    // previously left mic + LiveKit room running with no UI to control
    // them — only kill-app could break out.
    final activeGateway = _callGateway;
    if (activeGateway != null) {
      // dispose 比 disconnectActiveRoom 更彻底 — 同时关 callStates
      unawaited(activeGateway.dispose().catchError((_) {}));
    }
    endActiveRtcSession();
    _imService?.dispose();
    WukongImService.disconnect();
    // 同 kicked path: 关 app 层 sqflite (db 文件按 uid 隔离永久保留).
    unawaited(FoxTalkDatabase.instance.close());
    // 清朋友圈进程内 cache, 防止 logout-切账号-同 process 时 B 看到 A
    // 没 loginUid scope). HomeShell.initState 的 bindAccount 也会检测, 双保险.
    clearSocialProcessCaches();
    unawaited(_mediaService?.dispose() ?? Future.value());
    _kickedSubscription?.cancel();
    _kickedSubscription = null;
    setState(() {
      _session = null;
      _serverAppConfig = const ChatServerAppConfig();
      _imService = null;
      _socialService = null;
      _mediaService = null;
      _scanService = null;
      _callGateway = null;
    });
  }

  void _handleProfileComplete(UserSession session) {
    unawaited(
      SessionStore.save(session, serverScope: _serverProfile.storageScope),
    );
    unawaited(
      RecentAccountStore.saveFromSession(
        session,
        serverScope: _serverProfile.storageScope,
      ),
    );
    setState(() => _session = session);
  }
}

bool _shouldStartVendorPush(AppRuntime? runtime) {
  final registry = runtime?.registry;
  final feature = registry?.featureById(ModuleActionIds.vendorPushStart);
  return feature != null &&
      (registry?.isModuleEnabled(feature.moduleId) ?? false);
}

ChatCallGateway? _createCallGateway(ApiClient client, AppRuntime? runtime) {
  final registry = runtime?.registry;
  final feature = registry?.featureById(ModuleFeatureIds.rtcCallGatewayFactory);
  if (feature == null ||
      !(registry?.isModuleEnabled(feature.moduleId) ?? false)) {
    return null;
  }
  final value = feature.value;
  if (value is ChatCallGateway Function(ApiClient)) {
    return value(client);
  }
  return null;
}

/// Branded splash shown while `SessionStore.load` and the subsequent
/// IM handshake are in flight. Avoids the login-screen flash that would
/// otherwise appear for the brief moment between app boot and the
/// persisted session being applied.
class _SessionRestoreSplash extends StatelessWidget {
  const _SessionRestoreSplash();

  @override
  Widget build(BuildContext context) {
    return const FScaffold(
      childPad: false,
      child: ColoredBox(color: Colors.white),
    );
  }
}

/// Full-screen modal that gates the app after a backgrounded resume
/// when the user has set a lock-screen password. Mirrors iOS
/// `WKScreenPasswordVC`: 6-digit numeric password, verified locally
/// against the digest stored in `UserSession.lockScreenPwd` (no
/// server round-trip — same as iOS comparing `loginInfo.extra
/// ['lock_screen_pwd']`). Back gesture and system back are blocked
/// via PopScope so the user can't dismiss without entering the
/// correct password.
class _LockScreenInputPage extends StatefulWidget {
  const _LockScreenInputPage({required this.session});
  final UserSession session;

  @override
  State<_LockScreenInputPage> createState() => _LockScreenInputPageState();
}

class _LockScreenInputPageState extends State<_LockScreenInputPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _error = '';
  bool _shaking = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_error.isNotEmpty) setState(() => _error = '');
    // 6 位输完 → 自动 verify, 不要"解锁"按钮 (iOS 系统锁屏 + 微信支付密码
    // 同款 UX). 验证失败 → 震动 + 清空 + 红字, 重新输.
    if (value.length == 6) _submit();
  }

  void _submit() {
    final pwd = _controller.text.trim();
    if (pwd.length != 6) {
      setState(
        () => _error = AppLocalizations.of(context).lockSixDigitsRequired,
      );
      return;
    }
    final digest = lockScreenDigest(uid: widget.session.uid, password: pwd);
    if (digest != widget.session.lockScreenPwd) {
      // 触发震动反馈 (iOS 系统锁屏密码错误同款).
      HapticFeedback.heavyImpact();
      setState(() {
        _error = AppLocalizations.of(context).lockWrongPassword;
        _controller.clear();
        _shaking = true;
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) setState(() => _shaking = false);
      });
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = MoyuColors.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: GestureDetector(
            // 点空白处 refocus 调起键盘 (避免误操作 dismiss 后没办法继续输).
            onTap: () => _focusNode.requestFocus(),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 居中圆角图标 — primary 色系背板 + 白 lock icon, 跟
                  // chatim composer / Moyu pill 一致.
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        FIcons.lockKeyhole,
                        size: 32,
                        color: colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      AppLocalizations.of(context).lockInputTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).lockInputSubtitle(AppBrand.displayName),
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textTertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // 6 dot indicator — 用 ValueListenableBuilder 监听
                  // 靠 _onChanged setState 不可靠 — 第一笔输入 _error 空时
                  // setState 没触发, dot 永不填充).
                  // 错误时整行水平抖动 (AnimatedSlide).
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 90),
                    offset: _shaking ? const Offset(0.02, 0) : Offset.zero,
                    curve: Curves.elasticIn,
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _controller,
                      builder: (context, value, child) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (i) {
                          final filled = i < value.text.length;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: filled ? colors.textPrimary : null,
                                border: Border.all(
                                  color: colors.textPrimary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_error.isNotEmpty)
                    Center(
                      child: Text(
                        _error,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  // 可见但完全透明的 TextField — autofocus 必生效 + 接键盘.
                  // 之前用 Offstage / SizedBox(0) 在 PopScope + Scaffold 嵌套
                  // 下 autofocus 不稳定 (Flutter 已知问题), dot 不跟随输入.
                  // 改用 transparent text + transparent cursor + 0 fontSize,
                  // 保持 widget 参与 layout, autofocus / 键盘 input 都 work,
                  // 但视觉上完全看不见. 用户看到的是上面的 6 dot indicator.
                  SizedBox(
                    height: 1,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      obscureText: true,
                      showCursor: false,
                      cursorColor: Colors.transparent,
                      enableInteractiveSelection: false,
                      style: const TextStyle(
                        color: Colors.transparent,
                        fontSize: 0.01,
                        height: 0.01,
                      ),
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: _onChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
