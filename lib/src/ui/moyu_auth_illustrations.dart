import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

enum MoyuAuthIllustrationKind { chat, register, security, reset }

class MoyuAuthIllustration extends StatelessWidget {
  const MoyuAuthIllustration({
    super.key,
    required this.kind,
    this.height = 196,
  });

  final MoyuAuthIllustrationKind kind;
  final double height;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return SizedBox(
      height: height,
      child: Center(
        child: Image.asset(
          kind.assetPath,
          height: height,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          semanticLabel: kind.semanticLabel(t),
        ),
      ),
    );
  }
}

extension _MoyuAuthIllustrationKindX on MoyuAuthIllustrationKind {
  String get assetPath => switch (this) {
    MoyuAuthIllustrationKind.chat => 'assets/auth_illustrations/auth_login.png',
    MoyuAuthIllustrationKind.register =>
      'assets/auth_illustrations/auth_register.png',
    MoyuAuthIllustrationKind.security =>
      'assets/auth_illustrations/auth_security.png',
    MoyuAuthIllustrationKind.reset =>
      'assets/auth_illustrations/auth_reset.png',
  };

  String semanticLabel(AppLocalizations t) => switch (this) {
    MoyuAuthIllustrationKind.chat => t.authLoginIllustration,
    MoyuAuthIllustrationKind.register => t.authRegisterIllustration,
    MoyuAuthIllustrationKind.security => t.authSecurityIllustration,
    MoyuAuthIllustrationKind.reset => t.authResetIllustration,
  };
}
