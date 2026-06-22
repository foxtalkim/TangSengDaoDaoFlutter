import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../config/app_brand.dart';
import '../../config/app_config.dart';
import '../../l10n/app_localizations.dart';
import '../../social/social_service.dart';
import '../detail_scaffold.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';

class MyQrCodePage extends StatefulWidget {
  const MyQrCodePage({
    super.key,
    this.displayName = '',
    this.socialGateway,
    this.config,
    this.loginUid = '',
  });

  final String displayName;
  final ChatSocialGateway? socialGateway;

  /// Drives the avatar image URL so the QR header shows the real
  /// uploaded avatar instead of just the gradient + first character
  /// fallback. `loginUid` empty falls back to gradient.
  final AppConfig? config;
  final String loginUid;

  @override
  State<MyQrCodePage> createState() => _MyQrCodePageState();
}

class _MyQrCodePageState extends State<MyQrCodePage> {
  late final Future<ChatQrCode> _qrCode =
      widget.socialGateway?.loadUserQrCode() ??
      Future.value(ChatQrCode(data: ''));

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final displayName = widget.displayName.trim().isEmpty
        ? t.profileDefaultName
        : widget.displayName;
    return DetailScaffold(
      title: t.myQrCodeTitle,
      children: [
        MoyuSection(
          padding: EdgeInsets.fromLTRB(22, 26, 22, 24),
          children: [
            Center(
              child: MoyuResolvedAvatar.raw(
                label: displayName,
                size: 58,
                colors: [Color(0xFFFF9A8B), MoyuColors.of(context).primary],
                online: true,
                imageUrl: AvatarResolver.user(
                  config: widget.config,
                  uid: widget.loginUid,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                displayName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: 20),
            QrCodeFutureView(future: _qrCode),
            SizedBox(height: 16),
            Center(
              child: Text(
                t.myQrCodeSubtitle(AppBrand.displayName),
                style: TextStyle(color: MoyuColors.of(context).textTertiary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class QrCodeFutureView extends StatelessWidget {
  const QrCodeFutureView({super.key, required this.future, this.emptyText});

  final Future<ChatQrCode> future;
  final String? emptyText;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChatQrCode>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _QrLoadingBox();
        }
        final code = snapshot.data;
        if (snapshot.hasError || code == null || code.data.isEmpty) {
          return _QrPlaceholder(
            text: emptyText ?? AppLocalizations.of(context).myQrCodeEmpty,
          );
        }
        return _QrImageBox(data: code.data);
      },
    );
  }
}

class _QrImageBox extends StatelessWidget {
  const _QrImageBox({required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 190,
        height: 190,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: MoyuColors.of(context).background,
          border: Border.all(color: MoyuColors.of(context).line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: QrImageView(data: data, backgroundColor: Colors.white),
      ),
    );
  }
}

class _QrLoadingBox extends StatelessWidget {
  const _QrLoadingBox();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 190,
        height: 190,
        decoration: BoxDecoration(
          color: MoyuColors.of(context).background,
          border: Border.all(color: MoyuColors.of(context).line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _QrPlaceholder extends StatelessWidget {
  const _QrPlaceholder({this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 190,
        height: 190,
        decoration: BoxDecoration(
          color: MoyuColors.of(context).background,
          border: Border.all(color: MoyuColors.of(context).line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: text == null
              ? Icon(
                  FIcons.qrCode,
                  size: 118,
                  color: MoyuColors.of(context).textPrimary,
                )
              : Text(
                  text!,
                  style: TextStyle(color: MoyuColors.of(context).textTertiary),
                ),
        ),
      ),
    );
  }
}
