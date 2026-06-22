// 扫一扫页面 + ScanPillButton。从 home_shell.dart 拆出。
import 'dart:async' show StreamSubscription, unawaited;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show HapticFeedback, SystemUiOverlayStyle;
import 'package:forui/forui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../call/chat_call_gateway.dart' show ChatCallGateway;
import '../../config/app_config.dart';
import '../../l10n/app_localizations.dart';
import '../../scan/chat_scan_service.dart'
    show ChatScanGateway, ChatScanService;
import '../../social/social_service.dart'
    show ChatContact, ChatGroup, ChatScanResult, ChatSocialGateway;
import '../chat_navigation.dart';
import '../home_seed_data.dart' show conversationColors;
import '../models/contact_models.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';
import 'my_qr_code_page.dart';

typedef ScanWebLoginConfirmPageBuilder =
    Widget Function(
      BuildContext context,
      String authCode,
      ChatSocialGateway? socialGateway,
    );

typedef ScanContactDetailPageBuilder =
    Widget Function(
      BuildContext context, {
      required UiContact contact,
      required bool isStranger,
    });

class ScanPage extends StatefulWidget {
  const ScanPage({
    super.key,
    this.config,
    this.socialGateway,
    this.scanGateway,
    this.callGateway,
    this.contacts = const [],
    this.onOpenContactChat,
    this.onOpenGroupChat,
    this.loginUid = '',
    this.loginName = '',
    required this.webLoginConfirmPageBuilder,
    required this.contactDetailPageBuilder,
  });

  final AppConfig? config;
  final ChatSocialGateway? socialGateway;
  final ChatScanGateway? scanGateway;

  /// Forwarded to ContactDetailPage when a `userInfo` scan resolves to
  /// an existing friend (so 发消息 leads back into the call gateway).
  /// Optional — stranger-mode detail pages don't render call buttons.
  final ChatCallGateway? callGateway;

  /// Lookup list used to detect "scanned a friend's qr". When the
  /// scanned uid matches an entry the detail page opens in friend
  /// mode; otherwise stranger mode (with 添加到通讯录 button).
  final List<UiContact> contacts;
  final Future<void> Function(UiContact contact)? onOpenContactChat;
  final Future<bool> Function(String groupNo)? onOpenGroupChat;
  final String loginUid;
  final String loginName;
  final ScanWebLoginConfirmPageBuilder webLoginConfirmPageBuilder;
  final ScanContactDetailPageBuilder contactDetailPageBuilder;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool _scanningAlbum = false;

  // Live camera state. `_cameraStatus`:
  //   'unknown'  — initial, while permission is being requested
  //   'granted'  — camera preview rendered
  //   'denied'   — user refused, show "需要相机权限" hint + 打开设置 btn
  //   'unavailable' — plugin runtime error
  String _cameraStatus = 'unknown';

  /// GlobalKey required by QRView — qr_code_scanner_plus passes it to
  /// the underlying PlatformView so `updateDimensions` can locate the
  /// camera surface bounds when the scan window changes.
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'foxtalk-qr-view');

  /// Issued by `QRView.onQRViewCreated` once the camera is ready.
  /// Holds the active scan subscription so dispose can cancel it.
  QRViewController? _scanner;
  StreamSubscription<Barcode>? _scanSub;

  // Re-entry lock: once a barcode is consumed we set this to true and
  // pause the camera. Resets only on dispose / explicit "scan again".
  // Without it the camera keeps firing the listener for the same QR
  // every frame (~30/s on Android) and `_handleScanInput` runs many
  // times, hitting `resolveScanResult` repeatedly and replaying haptics.
  bool _scanConsumed = false;

  /// Flash / torch toggle. Driven by the bottom "开灯" pill button;
  /// QRViewController.toggleFlash flips the system state and we
  /// mirror it for the button highlight.
  bool _torchOn = false;

  /// Animates the green sweep line up-and-down inside the scan window.
  /// Mirrors the iOS WKScanVC scanline animation — a value of 0
  /// places the line at the top of the window, 1 at the bottom.
  late final AnimationController _scanLineCtrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scanLineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    unawaited(_initCamera());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scanLineCtrl.dispose();
    unawaited(_scanSub?.cancel());
    _scanner?.dispose();
    super.dispose();
  }

  Future<void> _toggleTorch() async {
    final scanner = _scanner;
    if (scanner == null) return;
    try {
      await scanner.toggleFlash();
      if (!mounted) return;
      setState(() => _torchOn = !_torchOn);
    } catch (error) {
      debugPrint('[scan] toggleFlash failed: $error');
    }
  }

  /// Pause / resume the camera in sync with app lifecycle so the
  /// preview doesn't keep churning frames while the app is backgrounded
  /// or another route is on top.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final scanner = _scanner;
    if (scanner == null) return;
    if (state == AppLifecycleState.resumed) {
      if (!_scanConsumed) unawaited(scanner.resumeCamera());
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      unawaited(scanner.pauseCamera());
    }
  }

  /// Pre-flight camera permission so the UI can show a meaningful
  /// "需要相机权限" denied branch. qr_code_scanner_plus internally
  /// requests on first preview, but we keep the explicit check so the
  /// page renders the right branch even before QRView mounts.
  Future<void> _initCamera() async {
    try {
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        status = await Permission.camera.request();
      }
      if (!mounted) return;
      if (!status.isGranted) {
        setState(() => _cameraStatus = 'denied');
        return;
      }
      setState(() => _cameraStatus = 'granted');
    } catch (_) {
      if (mounted) {
        setState(() => _cameraStatus = 'unavailable');
      }
    }
  }

  /// Wire the stream once QRView creates the controller.
  void _onQRViewCreated(QRViewController ctrl) {
    _scanner = ctrl;
    _scanSub = ctrl.scannedDataStream.listen(_onBarcode);
  }

  Future<void> _onBarcode(Barcode barcode) async {
    if (_scanConsumed) return;
    final raw = barcode.code?.trim() ?? '';
    debugPrint(
      '[scan] onBarcode raw="$raw" (len=${raw.length}) format=${barcode.format}',
    );
    if (raw.isEmpty) return;
    _scanConsumed = true;
    unawaited(_scanner?.pauseCamera());
    HapticFeedback.mediumImpact();
    await _handleScanInput(raw);
  }

  /// User-visible "scan again" affordance. Called from a button shown
  /// after a successful scan / from the camera tap-to-rescan gesture.
  void _resumeScan() {
    if (!_scanConsumed) return;
    _scanConsumed = false;
    unawaited(_scanner?.resumeCamera());
  }

  /// User just came back from system Settings via the "打开设置" button.
  /// Re-check permission so the page recovers without requiring a
  /// manual back-and-relaunch.
  Future<void> _recheckPermissionAfterSettings() async {
    await openAppSettings();
    if (!mounted) return;
    final status = await Permission.camera.status;
    if (!mounted) return;
    if (status.isGranted && _cameraStatus != 'granted') {
      await _initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    // Pure-scan UI aligned with iOS WKScanVC:
    //   * Full-bleed camera preview behind everything.
    //   * Semi-transparent dark overlay with a square window cutout in
    //     the centre — outside the window is dimmed to ~50% to draw
    //     focus to the framing target.
    //   * 4 green L-corners + animated green sweep line in the window.
    //   * Top: centred 扫一扫 title (no nav buttons — there's no
    //     standard back chrome on iOS WKScanVC; we keep a subtle back
    //     button below the title because Android lacks edge swipe).
    //   * Bottom: 3-button pill (相册 / 开灯 / 二维码) like the
    //     screenshot.
    final viewSize = MediaQuery.of(context).size;
    final windowSize = math.min(viewSize.width * 0.7, 280.0);
    final windowRect = Rect.fromCenter(
      center: Offset(viewSize.width / 2, viewSize.height * 0.46),
      width: windowSize,
      height: windowSize,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            Positioned.fill(child: _buildCameraPreview()),
            // Mask + green corner frame + animated sweep line.
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _scanLineCtrl,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _ScanOverlayPainter(
                        windowRect: windowRect,
                        scanLineY:
                            windowRect.top +
                            windowRect.height * _scanLineCtrl.value,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Top centred title.
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  t.scanTitle,
                  style: TextStyle(
                    color: MoyuColors.of(context).background,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Small back button under the title's left side. iOS hides
            // this entirely and relies on edge swipe; we keep it
            // because Android cannot do that without extra setup.
            Positioned(
              top: MediaQuery.of(context).padding.top + 4,
              left: 8,
              child: _ScanRoundIconButton(
                icon: moyuBackChevronIcon(context),
                size: 36,
                background: Colors.white.withValues(alpha: 0.16),
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
            // Bottom pill: 相册 / 开灯 / 二维码.
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 36,
              child: Center(child: _buildBottomPill()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAlbumQr() async {
    final gateway = widget.scanGateway ?? ChatScanService();
    setState(() {
      _scanningAlbum = true;
    });
    try {
      final result = await gateway.pickQrCodeFromAlbum();
      if (!mounted) {
        return;
      }
      if (result == null || result.trim().isEmpty) {
        _showScanIssue(AppLocalizations.of(context).scanQrNotFound);
        return;
      }
      await _handleScanInput(result);
    } catch (error) {
      if (mounted) {
        _showScanIssue(error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _scanningAlbum = false);
      }
    }
  }

  Future<void> _handleScanInput(String input) async {
    final value = input.trim();
    if (value.isEmpty) {
      _showScanIssue(AppLocalizations.of(context).scanQrNotFound);
      return;
    }

    final uri = Uri.tryParse(value);
    final isHttp =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');

    debugPrint(
      '[scan] raw=$value isHttp=$isHttp isServerQr=${_isServerQrcodeUrl(uri)}',
    );
    if (isHttp && widget.socialGateway != null && _isServerQrcodeUrl(uri)) {
      ChatScanResult result;
      try {
        result = await widget.socialGateway!.resolveScanResult(value);
      } catch (error) {
        debugPrint('[scan] resolveScanResult threw: $error');
        if (mounted) {
          _showScanIssue(
            AppLocalizations.of(context).scanResolveFailed('$error'),
          );
        }
        return;
      }
      if (!mounted) {
        return;
      }
      debugPrint(
        '[scan] resolved type=${result.type} forward=${result.forward} '
        'uid=${result.uid} groupNo=${result.groupNo} '
        'authCode=${result.authCode.isEmpty ? "no" : "yes"} '
        'url=${result.url} data=${result.data}',
      );
      // Web-login qr → push a dedicated confirm page (Yes/Cancel).
      // Name-cards open the contact detail. Group qrs returned as
      // native mean the scanner is already a member, so mirror native
      // iOS and open the group conversation directly.
      if (result.type == 'loginConfirm' && result.authCode.isNotEmpty) {
        await pushPage(
          context,
          widget.webLoginConfirmPageBuilder(
            context,
            result.authCode,
            widget.socialGateway,
          ),
        );
        if (mounted) Navigator.of(context).maybePop();
        return;
      }
      // Server qrcode handler (modules/qrcode/api.go) returns
      //   {forward:"native", type:"userInfo", data:{uid, vercode}}
      // for both `user_xxx` and `vercode_xxx` qr codes. Jump straight
      // into the name-card page in stranger or friend mode depending
      // on whether the scanned uid is already in widget.contacts.
      if (result.type == 'userInfo' && result.uid.isNotEmpty) {
        await _openScannedUserCard(
          result.uid,
          result.data['vercode']?.toString() ?? '',
        );
        return;
      }
      if (result.type == 'group' && result.groupNo.isNotEmpty) {
        await _openScannedGroup(result.groupNo);
        return;
      }
      if (result.isJoinGroupConfirm) {
        await _confirmScannedGroupJoin(result);
        return;
      }
      if (result.forward == 'h5' && result.url.isNotEmpty) {
        _showScanIssue(AppLocalizations.of(context).scanUnrecognized);
        return;
      }
    }

    // Unrecognised payload (non-server URL, plain text, etc.) — let
    // the user know rather than silently dropping the scan. The
    // previous fallback dumped the raw value into the now-removed
    // text input.
    _showScanIssue(AppLocalizations.of(context).scanUnrecognized);
  }

  void _showScanIssue(String message) {
    final text = message.trim().isEmpty
        ? AppLocalizations.of(context).scanUnrecognized
        : message.trim();
    debugPrint('[scan] $text');
    if (mounted) {
      MoyuToast.show(context, text);
    }
    _resumeScan();
  }

  Future<void> _confirmScannedGroupJoin(ChatScanResult result) async {
    final groupNo = result.joinGroupNo;
    final authCode = result.joinGroupAuthCode;
    final gateway = widget.socialGateway;
    if (groupNo.isEmpty || authCode.isEmpty) {
      _showScanIssue(AppLocalizations.of(context).scanInfoIncomplete);
      return;
    }
    if (gateway == null) {
      _showScanIssue(AppLocalizations.of(context).scanSocialUnavailable);
      return;
    }
    final joined = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x66000000),
      isScrollControlled: true,
      builder: (sheetContext) {
        return _ScanJoinGroupSheet(
          config: widget.config,
          groupNo: groupNo,
          loadGroup: () => gateway.loadPublicGroupInfo(groupNo),
          onJoin: () =>
              gateway.scanJoinGroup(groupNo: groupNo, authCode: authCode),
        );
      },
    );
    if (!mounted) return;
    if (joined == true) {
      MoyuToast.show(context, AppLocalizations.of(context).scanJoinedGroup);
      await _openScannedGroup(groupNo);
    } else {
      _resumeScan();
    }
  }

  Future<void> _openScannedGroup(String groupNo) async {
    final normalized = groupNo.trim();
    if (normalized.isEmpty) {
      return;
    }
    final opener = widget.onOpenGroupChat;
    if (opener == null) {
      _showScanIssue(AppLocalizations.of(context).scanCannotOpenGroup);
      return;
    }
    try {
      final opened = await opener(normalized);
      if (!mounted) {
        return;
      }
      if (opened) {
        Navigator.of(context).maybePop();
      } else {
        _showScanIssue(AppLocalizations.of(context).scanGroupNotFound);
      }
    } catch (error) {
      debugPrint('[scan] open group($normalized) failed: $error');
      if (!mounted) return;
      _showScanIssue(AppLocalizations.of(context).scanOpenGroupFailed);
    }
  }

  /// Resolve a scanned uid against the local contact list and push
  /// the appropriate variant of ContactDetailPage. Threads vercode
  /// through to the apply-friend page so the eventual friend/apply
  /// POST carries server-validated proof of source.
  ///
  /// Aligns with iOS WKUserInfoVC: viewDidLoad calls
  /// `channelManager.fetchChannelInfo` to populate the card with the
  /// real name/avatar/short_no. If we can't resolve the user we show
  /// a "用户不存在" notice and stay on the scan page — pushing a card
  /// with the raw uid as the display name (which is what the previous
  /// fallback did) looks like a hex-string bug to the user.
  Future<void> _openScannedUserCard(String uid, String vercode) async {
    if (uid.isEmpty) return;
    // Self-scan: avoid jumping into your own name-card.
    if (widget.loginUid.isNotEmpty && uid == widget.loginUid) {
      _showScanIssue(AppLocalizations.of(context).scanSelfQr);
      return;
    }
    // Already-a-friend hit: replace scan with the existing contact card
    // (no extra GET needed, we have name + avatar + remark cached).
    // iOS uses replacePushViewController for userInfo scan results,
    // so backing out of the card should not reveal the scan page.
    for (final c in widget.contacts) {
      if (c.uid == uid) {
        if (!mounted) return;
        await _replaceWithPage(
          widget.contactDetailPageBuilder(
            context,
            contact: c,
            isStranger: false,
          ),
        );
        return;
      }
    }

    // Stranger path — must resolve name via getUserInfo before
    // pushing the card. Otherwise the card header would render the
    // 32-char uid as the user's name, exactly the "长 ID" bug.
    final gateway = widget.socialGateway;
    if (gateway == null) {
      _showScanIssue(AppLocalizations.of(context).scanSocialUnavailable);
      return;
    }
    ChatContact? info;
    try {
      info = await gateway.getUserInfo(uid);
    } catch (error) {
      debugPrint('[scan] getUserInfo($uid) failed: $error');
    }
    if (!mounted) return;
    debugPrint(
      '[scan] getUserInfo($uid) → '
      'uid=${info?.uid} name="${info?.name}" remark="${info?.remark}" '
      'avatar="${info?.avatar}" short="${info?.subtitle}"',
    );
    // Server's _contactFromJson falls name back to uid when the
    // payload has no `name` field, so a non-empty name alone doesn't
    // prove we got real data. Detect the fallback explicitly.
    final hasRealName =
        info != null &&
        info.uid.isNotEmpty &&
        info.name.trim().isNotEmpty &&
        info.name != info.uid;
    if (!hasRealName) {
      _showScanIssue(AppLocalizations.of(context).scanUserNotFound);
      return;
    }
    final upgraded = UiContact.fromSocial(
      ChatContact(
        uid: info.uid,
        name: info.name,
        remark: info.remark,
        subtitle: info.subtitle,
        avatar: info.avatar,
        // Prefer the qr-scan vercode (matches the scan-of-record on
        // the server side); fall back to whatever userDetail returned.
        vercode: vercode.isNotEmpty ? vercode : info.vercode,
      ),
      colors: conversationColors(uid.hashCode.abs()),
      config: widget.config,
    );
    debugPrint(
      '[scan] resolved contact name="${upgraded.name}" '
      'subtitle="${upgraded.subtitle}" avatarPath="${upgraded.avatarPath}"',
    );
    await _replaceWithPage(
      widget.contactDetailPageBuilder(
        context,
        contact: upgraded,
        isStranger: true,
      ),
    );
  }

  Future<void> _replaceWithPage(Widget page) {
    return Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute<void>(builder: (_) => page));
  }

  bool _isServerQrcodeUrl(Uri? uri) {
    if (uri == null) return false;
    // Server (modules/qrcode/api.go) registers the route under whatever
    // QRCodeInfoURL is configured — in practice `/v1/qrcode/:code`,
    // i.e. the API-versioned mount. Earlier we matched `/qrcode/`
    // strictly which dropped real-world `/v1/qrcode/vercode_xxx@N`
    // payloads into the fallback "无法识别" path. Accept any path
    // containing `/qrcode/`.
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

  Widget _buildCameraPreview() {
    final t = AppLocalizations.of(context);
    if (_cameraStatus == 'granted') {
      return Stack(
        fit: StackFit.expand,
        children: [
          // qr_code_scanner_plus QRView. Pure AVFoundation on iOS +
          // ZXing on Android — no Google ML Kit, so the arm64
          // simulator slice issue that crippled mobile_scanner does
          // not apply here. The overlay is left null so our own
          // CustomPaint (mask + corners + sweep line) drawn at a
          // higher z-index in the parent Stack stays the source of
          // truth for the framing UI.
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
            formatsAllowed: const [BarcodeFormat.qrcode],
          ),
        ],
      );
    }
    final iconColor = _cameraStatus == 'denied'
        ? Colors.white60
        : Colors.white38;
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FIcons.scanQrCode, color: iconColor, size: 72),
            const SizedBox(height: 12),
            if (_cameraStatus == 'denied') ...[
              Text(
                t.scanCameraPermissionRequired,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              FButton(
                variant: FButtonVariant.outline,
                onPress: () => unawaited(_recheckPermissionAfterSettings()),
                child: Text(
                  t.scanOpenSettings,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ] else if (_cameraStatus == 'unavailable')
              Text(
                t.scanCameraUnavailable,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              )
            else
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(Colors.white60),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Floating dark pill at the bottom of the scan page — matches
  /// the reference screenshot: 相册 / 开灯 / 二维码. The "二维码"
  /// slot opens the user's own qr card so others can scan you back
  /// (consistent with iOS WKScanVC bottom toolbar).
  Widget _buildBottomPill() {
    final t = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ScanPillButton(
            icon: FIcons.image,
            label: t.scanAlbum,
            onTap: _scanningAlbum ? null : () => unawaited(_pickAlbumQr()),
          ),
          _ScanPillButton(
            icon: _torchOn ? FIcons.flashlightOff : FIcons.flashlight,
            label: _torchOn ? t.scanLightOff : t.scanLightOn,
            onTap: _cameraStatus == 'granted'
                ? () => unawaited(_toggleTorch())
                : null,
          ),
          _ScanPillButton(
            icon: FIcons.qrCode,
            label: t.scanQrCode,
            onTap: () => pushPage(
              context,
              MyQrCodePage(
                socialGateway: widget.socialGateway,
                config: widget.config,
                loginUid: widget.loginUid,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanRoundIconButton extends StatelessWidget {
  const _ScanRoundIconButton({
    required this.icon,
    required this.onTap,
    this.size = 36,
    this.background = const Color(0x1AFFFFFF),
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: background, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 21),
        ),
      ),
    );
  }
}

class _ScanJoinGroupSheet extends StatefulWidget {
  const _ScanJoinGroupSheet({
    required this.groupNo,
    required this.loadGroup,
    required this.onJoin,
    this.config,
  });

  final String groupNo;
  final Future<ChatGroup?> Function() loadGroup;
  final Future<void> Function() onJoin;
  final AppConfig? config;

  @override
  State<_ScanJoinGroupSheet> createState() => _ScanJoinGroupSheetState();
}

class _ScanJoinGroupSheetState extends State<_ScanJoinGroupSheet> {
  late final Future<ChatGroup?> _groupFuture = widget.loadGroup();
  bool _joining = false;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8 + safeBottom),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: ColoredBox(
          color: MoyuColors.of(context).background,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: FutureBuilder<ChatGroup?>(
              future: _groupFuture,
              builder: (context, snapshot) {
                final group = snapshot.data;
                final title = group?.name.trim().isNotEmpty == true
                    ? group!.name.trim()
                    : t.scanGroupFallback;
                final memberText = group == null
                    ? t.scanGroupLoadingInfo
                    : t.scanGroupMemberCount(group.memberCount);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: MoyuColors.of(context).line,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      t.scanJoinGroupConfirm,
                      style: TextStyle(
                        color: MoyuColors.of(context).textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    MoyuResolvedAvatar.raw(
                      label: title,
                      size: 64,
                      imageUrl: AvatarResolver.group(
                        config: widget.config,
                        groupNo: widget.groupNo,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: MoyuColors.of(context).textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.08,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      memberText,
                      style: TextStyle(
                        color: MoyuColors.of(context).textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    if (_error.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MoyuColors.of(context).red,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FButton(
                        onPress: _joining ? null : () => unawaited(_join()),
                        child: Text(_joining ? t.scanJoining : t.scanJoinGroup),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FButton(
                        variant: FButtonVariant.ghost,
                        onPress: _joining
                            ? null
                            : () => Navigator.of(context).pop(false),
                        child: Text(t.actionCancel),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _join() async {
    setState(() {
      _joining = true;
      _error = '';
    });
    try {
      await widget.onJoin();
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _joining = false;
        _error = AppLocalizations.of(context).scanJoinFailed('$error');
      });
    }
  }
}

/// Dim-everything-except-the-window overlay drawn over the camera
/// preview. Renders:
///   * full-screen black at ~50% alpha with the central scan window
///     punched out (saveLayer + clearRect approach via
///     `evenOdd` path),
///   * 4 short green L-corners pinned to the window's corners,
///   * a thin green sweep line that animates top→bottom→top via
///     `scanLineY`.
/// Mirrors iOS WKScanCoverView from the WuKongBase scan module.
class _ScanOverlayPainter extends CustomPainter {
  const _ScanOverlayPainter({
    required this.windowRect,
    required this.scanLineY,
  });

  final Rect windowRect;
  final double scanLineY;

  static const _cornerColor = Color(0xFF34C759); // iOS systemGreen
  static const _maskColor = Color(0x99000000); // 60% black
  static const _cornerArm = 22.0;
  static const _cornerStroke = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Mask: full-screen path minus window, even-odd fill.
    final maskPath = Path()
      ..addRect(Offset.zero & size)
      ..addRect(windowRect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(maskPath, Paint()..color = _maskColor);

    // 4 green L-corners.
    final cornerPaint = Paint()
      ..color = _cornerColor
      ..strokeWidth = _cornerStroke
      ..strokeCap = StrokeCap.square;
    final tl = windowRect.topLeft;
    final tr = windowRect.topRight;
    final bl = windowRect.bottomLeft;
    final br = windowRect.bottomRight;
    canvas.drawLine(tl, tl + const Offset(_cornerArm, 0), cornerPaint);
    canvas.drawLine(tl, tl + const Offset(0, _cornerArm), cornerPaint);
    canvas.drawLine(tr, tr - const Offset(_cornerArm, 0), cornerPaint);
    canvas.drawLine(tr, tr + const Offset(0, _cornerArm), cornerPaint);
    canvas.drawLine(bl, bl + const Offset(_cornerArm, 0), cornerPaint);
    canvas.drawLine(bl, bl - const Offset(0, _cornerArm), cornerPaint);
    canvas.drawLine(br, br - const Offset(_cornerArm, 0), cornerPaint);
    canvas.drawLine(br, br - const Offset(0, _cornerArm), cornerPaint);

    // Sweep line — radial gradient fading at the edges so it reads
    // as a moving laser rather than a hard rectangle.
    final lineRect = Rect.fromLTWH(
      windowRect.left + 8,
      scanLineY - 1,
      windowRect.width - 16,
      2,
    );
    final linePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          _cornerColor.withValues(alpha: 0),
          _cornerColor.withValues(alpha: 0.95),
          _cornerColor.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(lineRect);
    canvas.drawRect(lineRect, linePaint);
  }

  @override
  bool shouldRepaint(covariant _ScanOverlayPainter old) =>
      old.windowRect != windowRect || old.scanLineY != scanLineY;
}

/// One slot of the bottom 相册/开灯/二维码 pill. Tightly packed icon +
/// label, transparent background; the parent pill provides the dark
/// chrome.
class _ScanPillButton extends StatelessWidget {
  const _ScanPillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: disabled ? Colors.white38 : Colors.white,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: disabled ? Colors.white38 : Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
