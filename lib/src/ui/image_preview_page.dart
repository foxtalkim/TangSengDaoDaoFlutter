import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../chat/chat_message.dart';
import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../media/chat_media_service.dart';
import '../scan/chat_scan_service.dart';
import '../social/social_service.dart';
import 'detail_scaffold.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

/// Kept-around long-form image preview used by legacy preview routes. The
/// primary tap-image flow now uses [ImageLightbox].
class ImagePreviewPage extends StatefulWidget {
  const ImagePreviewPage({
    super.key,
    required this.message,
    this.config,
    this.socialGateway,
    this.mediaGateway,
    this.scanGateway,
  });

  final ChatMessage message;
  final AppConfig? config;
  final ChatSocialGateway? socialGateway;
  final ChatMediaGateway? mediaGateway;
  final ChatScanGateway? scanGateway;

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  bool _saving = false;
  bool _recognizing = false;
  bool _addingSticker = false;
  bool _grantingScanLogin = false;
  String _notice = '';
  String _qrResult = '';
  String _scanAuthCode = '';
  String _scanLinkUrl = '';

  String get _localPath => widget.message.attachment?.localPath.trim() ?? '';

  String get _remoteUrl => widget.message.attachment?.remoteUrl.trim() ?? '';

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.imagePreviewTitle,
      children: [
        MoyuSection(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
          children: [
            Center(child: _previewImage()),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FButton(
                    onPress: _saving ? null : () => unawaited(_saveToAlbum()),
                    child: Text(
                      _saving ? t.imagePreviewSavingToAlbum : t.saveToAlbum,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FButton(
                    onPress: _addingSticker
                        ? null
                        : () => unawaited(_addToStickers()),
                    child: Text(
                      _addingSticker
                          ? t.imagePreviewAddingToSticker
                          : t.imagePreviewAddToSticker,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FButton(
                onPress: _recognizing ? null : () => unawaited(_recognizeQr()),
                child: Text(
                  _recognizing
                      ? t.imagePreviewRecognizingQr
                      : t.imagePreviewRecognizeQr,
                ),
              ),
            ),
            if (_notice.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _notice,
                style: TextStyle(
                  color: MoyuColors.of(context).primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (_qrResult.isNotEmpty) ...[
              const SizedBox(height: 8),
              SelectableText(
                _qrResult,
                style: TextStyle(
                  color: MoyuColors.of(context).textSecondary,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ],
            if (_scanAuthCode.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: FButton(
                  onPress: _grantingScanLogin
                      ? null
                      : () => unawaited(_grantScanLogin()),
                  child: Text(
                    _grantingScanLogin
                        ? t.imagePreviewConfirmingWebLogin
                        : t.imagePreviewConfirmWebLogin,
                  ),
                ),
              ),
            ],
            if (_scanLinkUrl.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: FButton(
                  onPress: () => unawaited(_openScanLink()),
                  child: Text(t.imagePreviewOpenLink),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _previewImage() {
    final placeholder = Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        FIcons.image,
        color: MoyuColors.of(context).textSecondary,
        size: 56,
      ),
    );
    Widget? body;
    if (_localPath.isNotEmpty && File(_localPath).existsSync()) {
      body = Image.file(
        File(_localPath),
        width: double.infinity,
        height: 300,
        fit: BoxFit.contain,
      );
    } else if (_remoteUrl.startsWith('http://') ||
        _remoteUrl.startsWith('https://')) {
      body = CachedNetworkImage(
        imageUrl: _remoteUrl,
        width: double.infinity,
        height: 300,
        fit: BoxFit.contain,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        errorWidget: (context, error, stackTrace) => placeholder,
      );
    }
    if (body == null) {
      return placeholder;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        clipBehavior: Clip.hardEdge,
        child: body,
      ),
    );
  }

  Future<void> _saveToAlbum() async {
    final t = AppLocalizations.of(context);
    final path = _localPath;
    if (path.isEmpty) {
      setState(() => _notice = t.imagePreviewImageNotDownloadedSave);
      return;
    }
    final gateway = widget.mediaGateway;
    if (gateway == null) {
      setState(() => _notice = t.imagePreviewMediaUnavailable);
      return;
    }
    setState(() {
      _saving = true;
      _notice = '';
    });
    try {
      await gateway.saveImageToAlbum(path);
      if (mounted) {
        setState(() => _notice = t.savedToAlbum);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _notice = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _addToStickers() async {
    final t = AppLocalizations.of(context);
    final path = _remoteUrl.isNotEmpty ? _remoteUrl : _localPath;
    if (path.isEmpty) {
      setState(() => _notice = t.imagePreviewImageNotUploadedSticker);
      return;
    }
    final gateway = widget.socialGateway;
    if (gateway == null) {
      setState(() => _notice = t.imagePreviewStickerUnavailable);
      return;
    }
    final attachment = widget.message.attachment;
    setState(() {
      _addingSticker = true;
      _notice = '';
    });
    try {
      await gateway.addCustomSticker(
        ChatSticker(
          path: path,
          title: widget.message.text,
          placeholder: widget.message.text,
          width: attachment?.width ?? 0,
          height: attachment?.height ?? 0,
          format: _stickerFormat(path),
        ),
      );
      if (mounted) {
        setState(() => _notice = t.imagePreviewAddedToSticker);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _notice = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _addingSticker = false);
      }
    }
  }

  Future<void> _recognizeQr() async {
    final t = AppLocalizations.of(context);
    final path = _localPath;
    if (path.isEmpty) {
      setState(() => _notice = t.imagePreviewImageNotDownloadedRecognize);
      return;
    }
    final gateway = widget.scanGateway ?? ChatScanService();
    setState(() {
      _recognizing = true;
      _notice = '';
      _qrResult = '';
      _scanAuthCode = '';
      _scanLinkUrl = '';
    });
    try {
      final result = await gateway.decodeQrImage(path);
      if (!mounted) {
        return;
      }
      final value = result?.trim() ?? '';
      if (value.isEmpty) {
        setState(() => _notice = t.imagePreviewQrNotFound);
        return;
      }
      await _handleRecognizedQr(value, t);
    } catch (error) {
      if (mounted) {
        setState(() => _notice = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _recognizing = false);
      }
    }
  }

  Future<void> _handleRecognizedQr(String value, AppLocalizations t) async {
    final uri = Uri.tryParse(value);
    if (_isServerQrcodeUrl(uri) && widget.socialGateway != null) {
      final result = await widget.socialGateway!.resolveScanResult(value);
      if (!mounted) {
        return;
      }
      if (result.type == 'loginConfirm' && result.authCode.isNotEmpty) {
        setState(() {
          _notice = t.imagePreviewWebLoginQrRecognized;
          _qrResult = result.authCode;
          _scanAuthCode = result.authCode;
        });
        return;
      }
      if (result.forward == 'h5' && result.url.isNotEmpty) {
        setState(() {
          _notice = t.imagePreviewWebLinkRecognized;
          _qrResult = result.url;
          _scanLinkUrl = result.url;
        });
        return;
      }
    }

    setState(() {
      _notice = t.imagePreviewQrRecognized;
      _qrResult = value;
    });
  }

  Future<void> _grantScanLogin() async {
    final t = AppLocalizations.of(context);
    final authCode = _scanAuthCode.trim();
    if (authCode.isEmpty) {
      return;
    }
    setState(() {
      _grantingScanLogin = true;
      _notice = '';
    });
    try {
      await widget.socialGateway?.grantWebLogin(authCode);
      if (mounted) {
        setState(() => _notice = t.imagePreviewWebLoginConfirmed);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _notice = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _grantingScanLogin = false);
      }
    }
  }

  Future<void> _openScanLink() async {
    await launchUrl(
      Uri.parse(_scanLinkUrl),
      mode: LaunchMode.externalApplication,
    );
  }

  bool _isServerQrcodeUrl(Uri? uri) {
    if (uri == null) return false;
    if (!uri.path.contains('/qrcode/')) {
      return false;
    }
    final config = widget.config;
    if (config == null) {
      return true;
    }
    final serverUri = Uri.tryParse(config.serverBaseUrl);
    return serverUri != null &&
        uri.scheme == serverUri.scheme &&
        uri.host == serverUri.host &&
        uri.port == serverUri.port;
  }
}

String _stickerFormat(String path) {
  final lower = path.toLowerCase();
  if (lower.endsWith('.webp')) return 'webp';
  if (lower.endsWith('.gif')) return 'gif';
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'jpg';
  return 'png';
}
