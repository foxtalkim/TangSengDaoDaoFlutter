import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_repository.dart';
import '../auth/locale_controller.dart';
import '../auth/locale_store.dart';
import '../auth/recent_account_store.dart';
import '../auth/user_session.dart';
import '../config/app_brand.dart';
import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../network/api_client.dart';
import 'moyu_auth_illustrations.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

typedef LoginHandler =
    Future<UserSession> Function({
      required AppConfig config,
      required String username,
      required String password,
    });

typedef LoginVerificationHandler =
    Future<UserSession> Function({
      required AppConfig config,
      required String uid,
      required String code,
    });

typedef RegisterSessionHandler =
    Future<UserSession> Function({
      required AppConfig config,
      required UserSession session,
    });

typedef AuthRepositoryFactory = AuthRepository Function(AppConfig config);

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.initialConfig,
    required this.onLogin,
    this.onVerifyLogin,
    this.onRegister,
    this.showServerSwitch = true,
    this.initialPhone,
    this.authRepositoryFactory,
  });

  final AppConfig initialConfig;
  final LoginHandler onLogin;
  final LoginVerificationHandler? onVerifyLogin;
  final RegisterSessionHandler? onRegister;
  final bool showServerSwitch;
  final String? initialPhone;
  final AuthRepositoryFactory? authRepositoryFactory;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// SharedPreferences key for the most-recent phone number. Survives
  /// logout (we never clear it) so re-login pre-fills the previous
  /// account's phone; password is NEVER persisted — user retypes.
  static const _kLastPhonePrefsKey = 'foxtalk.login.last_phone';

  late final TextEditingController _serverController;
  // Phone + password start empty. The phone is hydrated from prefs
  // in initState (last successful login phone), so on first launch
  // the form is blank and on subsequent launches the previous
  // account's phone reappears for one tap → password.
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _serverController = TextEditingController(
      text: widget.initialConfig.serverBaseUrl,
    );
    final initialPhone = widget.initialPhone?.trim();
    if (initialPhone != null) {
      _phoneController.text = initialPhone;
    }
    if (widget.authRepositoryFactory != null) {
      unawaited(_loadAppConfig());
    }
    unawaited(_hydrateLoginPhone());
    const autologin = bool.fromEnvironment('DEV_AUTOLOGIN');
    if (autologin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_loading) {
          _submit();
        }
      });
    }
  }

  Future<void> _hydrateLoginPhone() async {
    try {
      final prefill = await RecentAccountStore.consumeLoginPrefill();
      if (prefill != null) {
        if (mounted) {
          setState(() => _phoneController.text = prefill);
        }
        return;
      }
      if (_phoneController.text.isNotEmpty) {
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_kLastPhonePrefsKey)?.trim() ?? '';
      if (stored.isNotEmpty && mounted && _phoneController.text.isEmpty) {
        setState(() => _phoneController.text = stored);
      }
    } catch (_) {
      // prefs unavailable — leave field empty.
    }
  }

  Future<void> _persistLastPhone(String phone) async {
    if (phone.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLastPhonePrefsKey, phone);
    } catch (_) {
      // prefs unavailable — silently skip; next login will rebuild fresh.
    }
  }

  @override
  void dispose() {
    _serverController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Semantics(
      identifier: 'moyu.login.screen',
      container: true,
      child: FScaffold(
        childPad: false,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _dismissKeyboard,
          child: SafeArea(
            child: ColoredBox(
              color: MoyuColors.of(context).background,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: MoyuColors.of(context).background,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final keyboardVisible =
                        MediaQuery.viewInsetsOf(context).bottom > 0;
                    const loginIllustration = MoyuAuthIllustration(
                      kind: MoyuAuthIllustrationKind.chat,
                    );
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                const Spacer(),
                                // #4: 右上角语言切换 (登录页未登录也能切)。
                                const _LoginLanguageButton(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, bodyConstraints) {
                                return SingleChildScrollView(
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  padding: EdgeInsets.zero,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: bodyConstraints.maxHeight,
                                    ),
                                    child: Center(
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 430,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            _LoginHero(
                                              // 去副标题 (用户要求): 只留插画+标题,
                                              // 降低顶部信息密度。
                                              title: AppBrand.displayName,
                                              illustration: keyboardVisible
                                                  ? null
                                                  : loginIllustration,
                                              titleSize: keyboardVisible
                                                  ? 28
                                                  : 30,
                                            ),
                                            SizedBox(
                                              height: keyboardVisible ? 18 : 32,
                                            ),
                                            Semantics(
                                              identifier: 'moyu.login.phone',
                                              textField: true,
                                              child: FTextField(
                                                control:
                                                    FTextFieldControl.managed(
                                                      controller:
                                                          _phoneController,
                                                    ),
                                                keyboardType:
                                                    TextInputType.phone,
                                                textInputAction:
                                                    TextInputAction.next,
                                                label: Text(t.authPhoneLabel),
                                                prefixBuilder:
                                                    (
                                                      context,
                                                      style,
                                                      variants,
                                                    ) =>
                                                        FTextField.prefixIconBuilder(
                                                          context,
                                                          style,
                                                          variants,
                                                          const Icon(
                                                            FIcons.smartphone,
                                                          ),
                                                        ),
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            Semantics(
                                              identifier: 'moyu.login.password',
                                              textField: true,
                                              child: FTextField.password(
                                                control:
                                                    FTextFieldControl.managed(
                                                      controller:
                                                          _passwordController,
                                                    ),
                                                textInputAction:
                                                    TextInputAction.done,
                                                label: Text(
                                                  t.authPasswordLabel,
                                                ),
                                                prefixBuilder:
                                                    (
                                                      context,
                                                      style,
                                                      _,
                                                      variants,
                                                    ) =>
                                                        FTextField.prefixIconBuilder(
                                                          context,
                                                          style,
                                                          variants,
                                                          const Icon(
                                                            FIcons.lock,
                                                          ),
                                                        ),
                                                onSubmit: (_) {
                                                  if (!_loading) {
                                                    _submit();
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: keyboardVisible ? 6 : 10,
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: FButton(
                                                variant: FButtonVariant.ghost,
                                                size: FButtonSizeVariant.sm,
                                                mainAxisSize: MainAxisSize.min,
                                                onPress: () => _pushLoginPage(
                                                  context,
                                                  _PasswordResetPage(
                                                    config: _currentConfig,
                                                    authRepositoryFactory: widget
                                                        .authRepositoryFactory,
                                                  ),
                                                ),
                                                child: Text(
                                                  t.authForgotPassword,
                                                  style: TextStyle(
                                                    color: MoyuColors.of(
                                                      context,
                                                    ).primary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 430),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Semantics(
                                    identifier: 'moyu.login.submit',
                                    container: true,
                                    child: MoyuPrimaryButton(
                                      label: t.authLoginButton,
                                      loadingLabel: t.authLoginLoading,
                                      loading: _loading,
                                      onPressed: _submit,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // 注册改小文字链接 (用户要求字别大) — 砍掉第二个
                                  // 全宽按钮, 大幅降低页面高度 + 减视觉重量。
                                  Center(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => _pushLoginPage(
                                        context,
                                        _RegisterPage(
                                          config: _currentConfig,
                                          onRegister: widget.onRegister,
                                          authRepositoryFactory:
                                              widget.authRepositoryFactory,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          t.authRegisterButton,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: MoyuColors.of(
                                              context,
                                            ).primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!keyboardVisible) ...[
                                    const SizedBox(height: 12),
                                    Text.rich(
                                      TextSpan(
                                        text: t.authLoginAgreementPrefix,
                                        children: [
                                          TextSpan(
                                            text: t.authTermsTitle,
                                            style: TextStyle(
                                              color: MoyuColors.of(
                                                context,
                                              ).primary,
                                            ),
                                          ),
                                          TextSpan(
                                            text: t.authAgreementConnector,
                                          ),
                                          TextSpan(
                                            text: t.authPrivacyTitle,
                                            style: TextStyle(
                                              color: MoyuColors.of(
                                                context,
                                              ).primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.45,
                                        color: MoyuColors.of(
                                          context,
                                        ).textTertiary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppConfig get _currentConfig =>
      AppConfig.fromServerBaseUrl(_serverController.text);

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  AuthRepository get _repository =>
      widget.authRepositoryFactory?.call(_currentConfig) ??
      AuthRepository(client: ApiClient(config: _currentConfig));

  Future<void> _loadAppConfig() async {
    try {
      await _repository.loadAppConfig();
    } catch (_) {
      // Keep the editable server field available for local/dev fallback.
    }
  }

  Future<void> _submit() async {
    _dismissKeyboard();
    setState(() => _loading = true);
    final phone = _phoneController.text.trim();
    try {
      await widget.onLogin(
        config: _currentConfig,
        username: phone,
        password: _passwordController.text,
      );
      // Login succeeded → persist the phone so re-login pre-fills it
      // after the user logs out. Skipped on verification / failure
      // paths so we don't memorise a bogus number.
      unawaited(_persistLastPhone(phone));
    } on LoginVerificationRequiredException catch (error) {
      if (mounted) {
        setState(() => _loading = false);
        await Navigator.of(context).push<UserSession>(
          MaterialPageRoute(
            builder: (_) => _VerificationLoginPage(
              config: _currentConfig,
              uid: error.uid,
              maskedPhone: error.phone,
              onVerifyLogin: widget.onVerifyLogin,
              authRepositoryFactory: widget.authRepositoryFactory,
            ),
          ),
        );
      }
    } on ApiException catch (error) {
      if (mounted) MoyuToast.show(context, error.message);
    } catch (error) {
      if (mounted) MoyuToast.show(context, error.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }
}

void _pushLoginPage(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}

/// #4: 登录/注册页右上角语言切换按钮。复用 LocaleController + LocaleStore
/// (跟设置页语言行同一套), 点击弹 showChoice 选语言, 立即切换并持久化。
class _LoginLanguageButton extends StatelessWidget {
  const _LoginLanguageButton();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return MoyuRoundIconButton(
      icon: FIcons.languages,
      tooltip: t.settingsLanguageRow,
      onPressed: () => unawaited(_pick(context)),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final controller = LocaleController.of(context);
    final ordered = <String>[
      LocaleStore.systemPreference,
      ...LocaleStore.supportedPreferences,
    ];
    String labelFor(String key) => key == LocaleStore.systemPreference
        ? t.settingsLanguageSystem
        : LocaleStore.nativeLanguageName(key);
    final current = LocaleStore.normalizePreference(controller.current);
    final picked = await MoyuActionSheet.showChoice<String>(
      context,
      title: t.settingsLanguageRow,
      items: [
        for (final key in ordered)
          MoyuActionSheetChoiceItem<String>(title: labelFor(key), value: key),
      ],
    );
    if (picked != null && picked != current) {
      await controller.change(picked);
    }
  }
}

class _LoginFlowScaffold extends StatelessWidget {
  const _LoginFlowScaffold({
    required this.heading,
    required this.subtitle,
    required this.illustrationKind,
    required this.actions,
    required this.children,
  });

  final String heading;
  final String subtitle;
  final MoyuAuthIllustrationKind illustrationKind;
  final Widget? actions;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    return FScaffold(
      childPad: false,
      child: SafeArea(
        child: ColoredBox(
          color: MoyuColors.of(context).background,
          child: Column(
            children: [
              Container(
                color: MoyuColors.of(context).background,
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
                child: Row(
                  children: [
                    MoyuRoundIconButton(
                      icon: moyuBackChevronIcon(context),
                      tooltip: t.actionBack,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    // #4: 注册流程页也带语言切换 (右上角)。
                    const _LoginLanguageButton(),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.zero,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 430),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _LoginHero(
                                    title: heading,
                                    subtitle: subtitle,
                                    illustration: keyboardVisible
                                        ? null
                                        : MoyuAuthIllustration(
                                            kind: illustrationKind,
                                          ),
                                    titleSize: keyboardVisible ? 26 : 30,
                                    centered: true,
                                  ),
                                  SizedBox(height: keyboardVisible ? 12 : 28),
                                  ...children,
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (actions != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: actions!,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero({
    required this.title,
    this.subtitle = '',
    this.illustration,
    this.titleSize = 30,
    this.centered = true,
  });

  final String title;
  final String subtitle;
  final Widget? illustration;
  final double titleSize;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (illustration != null) ...[
          illustration!,
          const SizedBox(height: 18),
        ],
        Text(
          title,
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            color: MoyuColors.of(context).textPrimary,
            fontSize: titleSize,
            height: 1.08,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.42,
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: centered ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              color: MoyuColors.of(context).textSecondary,
              fontSize: 14,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }
}

Widget _codeSuffixAction(
  BuildContext context, {
  required String label,
  required VoidCallback? onPressed,
}) {
  final enabled = onPressed != null;
  return Padding(
    padding: const EdgeInsetsDirectional.only(end: 8),
    child: FButton(
      variant: FButtonVariant.ghost,
      size: FButtonSizeVariant.sm,
      mainAxisSize: MainAxisSize.min,
      onPress: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: enabled
              ? MoyuColors.of(context).primary
              : MoyuColors.of(context).textTertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

class _VerificationLoginPage extends StatefulWidget {
  const _VerificationLoginPage({
    required this.config,
    this.uid = '',
    this.maskedPhone = '',
    this.onVerifyLogin,
    this.authRepositoryFactory,
  });

  final AppConfig config;
  final String uid;
  final String maskedPhone;
  final LoginVerificationHandler? onVerifyLogin;
  final AuthRepositoryFactory? authRepositoryFactory;

  @override
  State<_VerificationLoginPage> createState() => _VerificationLoginPageState();
}

class _VerificationLoginPageState extends State<_VerificationLoginPage> {
  final _codeController = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.uid.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(_sendLoginCheckCode());
        }
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return _LoginFlowScaffold(
      heading: t.authVerifyTitle,
      subtitle: widget.maskedPhone.isNotEmpty
          ? t.authVerifySubtitleWithPhone(widget.maskedPhone)
          : t.authVerifySubtitlePasswordFirst,
      illustrationKind: MoyuAuthIllustrationKind.security,
      actions: MoyuPrimaryButton(
        label: t.authVerifyButton,
        loadingLabel: t.authVerifyLoading,
        loading: _submitting,
        onPressed: () => unawaited(_verify()),
      ),
      children: [
        _LoginFormCard(
          children: [
            MoyuOtpCodeField(
              controller: _codeController,
              onCompleted: (_) {
                if (!_submitting) {
                  unawaited(_verify());
                }
              },
            ),
            const SizedBox(height: 14),
            Center(
              child: FButton(
                variant: FButtonVariant.ghost,
                size: FButtonSizeVariant.sm,
                mainAxisSize: MainAxisSize.min,
                onPress: _submitting
                    ? null
                    : () => unawaited(_sendLoginCheckCode()),
                child: Text(
                  t.authResendCode,
                  style: TextStyle(
                    color: MoyuColors.of(context).primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _toast(String message) {
    if (!mounted) return;
    MoyuToast.show(context, message);
  }

  Future<void> _sendLoginCheckCode() async {
    final uid = widget.uid.trim();
    final t = AppLocalizations.of(context);
    if (uid.isEmpty) {
      _toast(t.authVerifySubtitlePasswordFirst);
      return;
    }
    setState(() => _submitting = true);
    try {
      await _repository.sendLoginCheckCode(uid: uid);
      _toast(t.authVerificationCodeSent);
    } catch (error) {
      _toast(_errorMessage(error));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _verify() async {
    final uid = widget.uid.trim();
    final code = _codeController.text.trim();
    final t = AppLocalizations.of(context);
    if (uid.isEmpty) {
      _toast(t.authVerifySubtitlePasswordFirst);
      return;
    }
    if (code.isEmpty) {
      _toast(t.authVerificationCodeRequired);
      return;
    }
    if (code.length < 6) {
      _toast(t.authVerificationCodeSixDigits);
      return;
    }
    setState(() => _submitting = true);
    try {
      final session = widget.onVerifyLogin == null
          ? await _repository.loginCheckPhone(uid: uid, code: code)
          : await widget.onVerifyLogin!(
              config: widget.config,
              uid: uid,
              code: code,
            );
      if (mounted) {
        Navigator.of(context).pop(session);
      }
    } catch (error) {
      _toast(_errorMessage(error));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  AuthRepository get _repository =>
      widget.authRepositoryFactory?.call(widget.config) ??
      AuthRepository(client: ApiClient(config: widget.config));
}

class _PasswordResetPage extends StatefulWidget {
  const _PasswordResetPage({required this.config, this.authRepositoryFactory});

  final AppConfig config;
  final AuthRepositoryFactory? authRepositoryFactory;

  @override
  State<_PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<_PasswordResetPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return _LoginFlowScaffold(
      heading: t.authPasswordResetTitle,
      subtitle: t.authPasswordResetSubtitle,
      illustrationKind: MoyuAuthIllustrationKind.reset,
      actions: MoyuPrimaryButton(
        label: t.authPasswordResetButton,
        loadingLabel: t.authSubmitting,
        loading: _submitting,
        onPressed: () => unawaited(_reset()),
      ),
      children: [
        _LoginFormCard(
          children: [
            FTextField(
              control: FTextFieldControl.managed(controller: _phoneController),
              keyboardType: TextInputType.phone,
              label: Text(t.authPhoneLabel),
              prefixBuilder: (context, style, variants) =>
                  FTextField.prefixIconBuilder(
                    context,
                    style,
                    variants,
                    const Icon(FIcons.smartphone),
                  ),
            ),
            const SizedBox(height: 12),
            FTextField(
              control: FTextFieldControl.managed(controller: _codeController),
              keyboardType: TextInputType.number,
              label: Text(t.authVerificationCodeLabel),
              prefixBuilder: (context, style, variants) =>
                  FTextField.prefixIconBuilder(
                    context,
                    style,
                    variants,
                    const Icon(FIcons.messageSquareText),
                  ),
              suffixBuilder: (context, style, variants) => _codeSuffixAction(
                context,
                label: t.authGetVerificationCode,
                onPressed: _submitting
                    ? null
                    : () => unawaited(_sendPasswordResetCode()),
              ),
            ),
            const SizedBox(height: 12),
            FTextField.password(
              control: FTextFieldControl.managed(
                controller: _passwordController,
              ),
              label: Text(t.authNewPasswordLabel),
              prefixBuilder: (context, style, _, variants) =>
                  FTextField.prefixIconBuilder(
                    context,
                    style,
                    variants,
                    const Icon(FIcons.lock),
                  ),
            ),
          ],
        ),
      ],
    );
  }

  void _toast(String message) {
    if (!mounted) return;
    MoyuToast.show(context, message);
  }

  Future<void> _sendPasswordResetCode() async {
    final t = AppLocalizations.of(context);
    setState(() => _submitting = true);
    try {
      await _repository.sendPasswordResetCode(phone: _phoneController.text);
      _toast(t.authVerificationCodeSent);
    } catch (error) {
      _toast(_errorMessage(error));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _reset() async {
    final t = AppLocalizations.of(context);
    setState(() => _submitting = true);
    try {
      await _repository.resetPassword(
        phone: _phoneController.text,
        code: _codeController.text,
        password: _passwordController.text,
      );
      _toast(t.authPasswordResetSuccess);
    } catch (error) {
      _toast(_errorMessage(error));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  AuthRepository get _repository =>
      widget.authRepositoryFactory?.call(widget.config) ??
      AuthRepository(client: ApiClient(config: widget.config));
}

class _RegisterPage extends StatefulWidget {
  const _RegisterPage({
    required this.config,
    this.onRegister,
    this.authRepositoryFactory,
  });

  final AppConfig config;
  final RegisterSessionHandler? onRegister;
  final AuthRepositoryFactory? authRepositoryFactory;

  @override
  State<_RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<_RegisterPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  bool _submitting = false;
  bool _inviteRequired = false;
  bool _agreementAccepted = false;
  Timer? _codeCountdownTimer;
  int _codeCountdown = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_loadAppConfig());
  }

  @override
  void dispose() {
    _codeCountdownTimer?.cancel();
    _phoneController.dispose();
    _codeController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  void _startCodeCountdown() {
    _codeCountdownTimer?.cancel();
    setState(() => _codeCountdown = 60);
    _codeCountdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _codeCountdown -= 1;
        if (_codeCountdown <= 0) t.cancel();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return _LoginFlowScaffold(
      heading: t.authRegisterTitle(AppBrand.displayName),
      subtitle: t.authRegisterSubtitle,
      illustrationKind: MoyuAuthIllustrationKind.register,
      actions: MoyuPrimaryButton(
        label: t.authCreateAccount,
        loadingLabel: t.authSubmitting,
        loading: _submitting,
        onPressed: () => unawaited(_register()),
      ),
      children: [
        _LoginFormCard(
          children: [
            FTextField(
              control: FTextFieldControl.managed(controller: _phoneController),
              keyboardType: TextInputType.phone,
              label: Text(t.authPhoneLabel),
              prefixBuilder: (context, style, variants) =>
                  FTextField.prefixIconBuilder(
                    context,
                    style,
                    variants,
                    const Icon(FIcons.smartphone),
                  ),
            ),
            const SizedBox(height: 12),
            FTextField(
              control: FTextFieldControl.managed(controller: _codeController),
              keyboardType: TextInputType.number,
              label: Text(t.authVerificationCodeLabel),
              prefixBuilder: (context, style, variants) =>
                  FTextField.prefixIconBuilder(
                    context,
                    style,
                    variants,
                    const Icon(FIcons.messageSquareText),
                  ),
              suffixBuilder: (context, style, variants) => _codeSuffixAction(
                context,
                label: _codeCountdown > 0
                    ? t.authCodeRetryAfter(_codeCountdown)
                    : t.authGetVerificationCode,
                onPressed: (_submitting || _codeCountdown > 0)
                    ? null
                    : () => unawaited(_sendRegisterCode()),
              ),
            ),
            const SizedBox(height: 12),
            FTextField(
              control: FTextFieldControl.managed(controller: _nameController),
              label: Text(t.authNicknameLabel),
              prefixBuilder: (context, style, variants) =>
                  FTextField.prefixIconBuilder(
                    context,
                    style,
                    variants,
                    const Icon(FIcons.userRound),
                  ),
            ),
            const SizedBox(height: 12),
            FTextField.password(
              control: FTextFieldControl.managed(
                controller: _passwordController,
              ),
              label: Text(t.authPasswordLabel),
              prefixBuilder: (context, style, _, variants) =>
                  FTextField.prefixIconBuilder(
                    context,
                    style,
                    variants,
                    const Icon(FIcons.lock),
                  ),
            ),
            if (_inviteRequired) ...[
              const SizedBox(height: 12),
              FTextField(
                control: FTextFieldControl.managed(
                  controller: _inviteCodeController,
                ),
                label: Text(t.authInviteCodeRequiredLabel),
                prefixBuilder: (context, style, variants) =>
                    FTextField.prefixIconBuilder(
                      context,
                      style,
                      variants,
                      const Icon(FIcons.ticket),
                    ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: GestureDetector(
                    onTap: () => setState(
                      () => _agreementAccepted = !_agreementAccepted,
                    ),
                    child: Icon(
                      _agreementAccepted ? FIcons.squareCheck : FIcons.square,
                      size: 18,
                      color: _agreementAccepted
                          ? MoyuColors.of(context).primary
                          : MoyuColors.of(context).textTertiary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(
                      () => _agreementAccepted = !_agreementAccepted,
                    ),
                    child: Text(
                      t.authRegisterAgreement,
                      style: TextStyle(
                        color: MoyuColors.of(context).textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _toast(String message) {
    if (!mounted) return;
    MoyuToast.show(context, message);
  }

  Future<void> _sendRegisterCode() async {
    final phone = _phoneController.text.trim();
    final t = AppLocalizations.of(context);
    if (!_validMainlandPhone(phone)) {
      _toast(t.authInvalidPhone);
      return;
    }
    setState(() => _submitting = true);
    try {
      await _repository.sendRegisterCode(phone: phone);
      if (mounted) {
        MoyuToast.show(context, t.authVerificationCodeSent);
        _startCodeCountdown();
      }
    } catch (error) {
      _toast(_errorMessage(error));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _register() async {
    final t = AppLocalizations.of(context);
    if (!_agreementAccepted) {
      _toast(t.authAcceptAgreementFirst);
      return;
    }
    final phone = _phoneController.text.trim();
    final code = _codeController.text.trim();
    final password = _passwordController.text;
    if (!_validMainlandPhone(phone)) {
      _toast(t.authInvalidPhone);
      return;
    }
    if (code.isEmpty) {
      _toast(t.authCodeEmpty);
      return;
    }
    if (!_validPassword(password)) {
      _toast(t.authPasswordLengthInvalid);
      return;
    }
    if (_inviteRequired && _inviteCodeController.text.trim().isEmpty) {
      _toast(t.authInviteCodeEmpty);
      return;
    }
    setState(() => _submitting = true);
    try {
      final session = await _repository.register(
        phone: phone,
        code: code,
        name: _nameController.text,
        password: password,
        inviteCode: _inviteCodeController.text,
      );
      final onRegister = widget.onRegister;
      if (onRegister != null) {
        await onRegister(config: widget.config, session: session);
      }
      if (mounted) {
        MoyuToast.show(context, t.authRegisterSuccess);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (error) {
      _toast(_errorMessage(error));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  AuthRepository get _repository =>
      widget.authRepositoryFactory?.call(widget.config) ??
      AuthRepository(client: ApiClient(config: widget.config));

  Future<void> _loadAppConfig() async {
    try {
      final config = await _repository.loadAppConfig();
      if (!mounted) {
        return;
      }
      setState(() => _inviteRequired = config.registerInviteOn);
    } catch (_) {
      // Native keeps registration usable when app config cannot be loaded.
    }
  }
}

String _errorMessage(Object error) {
  if (error is ApiException) {
    return error.message;
  }
  return error.toString();
}

bool _validMainlandPhone(String value) {
  return value.length == 11 && RegExp(r'^\d+$').hasMatch(value);
}

bool _validPassword(String value) {
  return value.length >= 6 && value.length <= 16;
}

class _LoginFormCard extends StatelessWidget {
  const _LoginFormCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
