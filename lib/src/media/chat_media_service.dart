import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../network/api_client.dart';
import 'live_photo_picker.dart';

abstract interface class ChatMediaGateway {
  Future<ChatMediaAttachment?> pickImage({bool camera = false});

  /// 微信式相机入口 — 短按拍照 / 长按录像。对齐 iOS WKPhotoBrowser
  /// takePhoto: 内部用的 ZLCustomCamera。返回的 ChatMediaAttachment
  /// 的 kind 字段区分 image 或 video, video 时附带 coverLocalPath (首帧 JPG)
  /// + durationSeconds + width/height。
  Future<ChatMediaAttachment?> pickFromCamera(BuildContext context);

  /// 微信式相册入口 — 图片+视频混选。对齐 iOS WKPhotoBrowser
  /// showPreviewWithSender:...allowSelectVideo:YES (WKMoreItemClickEvent.m:111).
  /// 返回的 ChatMediaAttachment 按 entity.type 分到 image 或 video。
  /// 头像上传场景继续走 pickImage (只要图片).
  Future<ChatMediaAttachment?> pickFromGallery(BuildContext context);

  Future<ChatMediaAttachment?> pickFile();

  Future<void> startVoiceRecording();

  Future<ChatMediaAttachment?> stopVoiceRecording();

  Future<void> cancelVoiceRecording();

  /// Live amplitude stream while recording. Each event is the current
  /// peak normalized to 0..1 (0=silent, 1=clipping). UI uses this to
  /// drive a real-time waveform visualizer. Returns null when no
  /// recording is in flight or the platform doesn't support it.
  Stream<double>? voiceAmplitudes({
    Duration interval = const Duration(milliseconds: 100),
  });

  Future<void> saveImageToAlbum(String imagePath);

  Future<ChatMediaAttachment> uploadAttachment({
    required String channelId,
    required int channelType,
    required ChatMediaAttachment attachment,
    void Function(double progress)? onProgress,
  });

  /// Fetch a media URL through the authenticated ApiClient and write it to
  /// a stable cache path. Used for voice (audioplayers UrlSource cannot
  /// pass auth headers) and as a fallback for any URL whose server requires
  /// the `token` header. Returns `null` on failure.
  Future<File?> downloadToCache({
    required String url,
    required String filename,
  });
}

enum ChatMediaKind { image, file, voice, video, sticker, livePhoto }

class ChatMediaAttachment {
  const ChatMediaAttachment({
    required this.kind,
    required this.localPath,
    required this.fileName,
    this.fileSize = 0,
    this.remoteUrl = '',
    this.coverUrl = '',
    this.coverLocalPath = '',
    this.livePhotoVideoLocalPath = '',
    this.livePhotoVideoUrl = '',
    this.livePhotoVideoSize = 0,
    this.width = 0,
    this.height = 0,
    this.durationSeconds = 0,
  });

  final ChatMediaKind kind;
  final String localPath;
  final String fileName;
  final int fileSize;
  final String remoteUrl;

  /// Absolute thumbnail URL — populated for video messages so the bubble
  /// can render a poster frame without downloading the whole video first.
  final String coverUrl;

  /// Local cover JPG path for video messages (抽出来的首帧). uploadAttachment
  /// 先上传它拿 coverUrl, 再传主视频, 对齐 iOS WKSmallVideoContent 的两段式
  /// 上传。
  final String coverLocalPath;

  /// Live Photo paired MOV 本地路径. 仅 kind == livePhoto 时非空.
  /// uploadAttachment 把它跟静态图一起上传, 拿 livePhotoVideoUrl.
  final String livePhotoVideoLocalPath;

  /// Live Photo paired MOV 绝对 URL (上传后).
  final String livePhotoVideoUrl;
  final int livePhotoVideoSize;
  final int width;
  final int height;
  final int durationSeconds;

  ChatMediaAttachment copyWith({
    String? remoteUrl,
    String? coverUrl,
    String? livePhotoVideoUrl,
  }) {
    return ChatMediaAttachment(
      kind: kind,
      localPath: localPath,
      fileName: fileName,
      fileSize: fileSize,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      coverLocalPath: coverLocalPath,
      livePhotoVideoLocalPath: livePhotoVideoLocalPath,
      livePhotoVideoUrl: livePhotoVideoUrl ?? this.livePhotoVideoUrl,
      livePhotoVideoSize: livePhotoVideoSize,
      width: width,
      height: height,
      durationSeconds: durationSeconds,
    );
  }

  String get displayText {
    return switch (kind) {
      ChatMediaKind.image => '[图片]',
      ChatMediaKind.file => '[文件] $fileName',
      ChatMediaKind.voice =>
        '[语音 · 0:${durationSeconds.clamp(1, 59).toString().padLeft(2, '0')}]',
      ChatMediaKind.video => '[视频]',
      ChatMediaKind.sticker => '[表情]',
      ChatMediaKind.livePhoto => '[Live Photo]',
    };
  }
}

Future<ChatMediaAttachment?> chatMediaAttachmentFromGalleryAsset(
  AssetEntity entity, {
  bool keepLive = false,
}) {
  return ChatMediaService.attachmentFromGalleryAsset(
    entity,
    keepLive: keepLive,
  );
}

class ChatMediaService implements ChatMediaGateway {
  ChatMediaService({
    required this.client,
    ImagePicker? imagePicker,
    MethodChannel? channel,
  }) : _imagePicker = imagePicker ?? ImagePicker(),
       _channel = channel ?? const MethodChannel('foxtalk/media');

  final ApiClient client;
  final ImagePicker _imagePicker;
  final MethodChannel _channel;
  AudioRecorder? _voiceRecorder;
  DateTime? _voiceRecordingStartedAt;
  String? _voiceRecordingPath;

  @override
  Future<ChatMediaAttachment?> pickImage({bool camera = false}) async {
    final file = await _imagePicker.pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 88,
    );
    if (file == null) {
      return null;
    }
    final stat = await File(file.path).stat();
    return ChatMediaAttachment(
      kind: ChatMediaKind.image,
      localPath: file.path,
      fileName: file.name,
      fileSize: stat.size,
    );
  }

  @override
  Future<ChatMediaAttachment?> pickFromCamera(BuildContext context) async {
    final entity = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: const CameraPickerConfig(
        enableRecording: true,
        // 60s 上限对齐 iOS WKPhotoBrowser 默认行为 (ZLCustomCamera 默认 30s,
        // 但 iOS 实际未限制) — 取常见 60s 上限避免过大文件失败.
        maximumRecordingDuration: Duration(seconds: 60),
        resolutionPreset: ResolutionPreset.high,
      ),
    );
    if (entity == null) return null;
    final file = await entity.file;
    if (file == null || !await file.exists()) return null;

    final stat = await file.stat();
    final fileName = file.path.split(Platform.pathSeparator).last;

    if (entity.type == AssetType.image) {
      // **关键 fix**: AssetEntity.width/height 来自 PHAsset (iOS) /
      // MediaStore (Android) 元数据 — HEIC 转 JPEG 时 file 实际 decode
      // dimensions 可能跟元数据不一致 (e.g. EXIF orientation 未 apply 让
      // 横竖颠倒). 用 file decode 拿真实 dimensions 跟接收方 ImageStream
      // resolve 值一致, 双方都不变形.
      final (camW, camH) = await _decodeImageDimensions(
        file,
        fallbackW: entity.width,
        fallbackH: entity.height,
      );
      return ChatMediaAttachment(
        kind: ChatMediaKind.image,
        localPath: file.path,
        fileName: fileName,
        fileSize: stat.size,
        width: camW,
        height: camH,
      );
    }

    // Video: 抽首帧 cover 写到 tmp, 与主视频一起上传.
    String coverLocalPath = '';
    try {
      final coverBytes = await entity.thumbnailData;
      if (coverBytes != null && coverBytes.isNotEmpty) {
        final dir = await getTemporaryDirectory();
        final coverFile = File(
          '${dir.path}/cover_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await coverFile.writeAsBytes(coverBytes, flush: true);
        coverLocalPath = coverFile.path;
      }
    } catch (_) {
      // 首帧抽不到不致命 — 接收端用 video player 自己 seek 出来.
    }

    return ChatMediaAttachment(
      kind: ChatMediaKind.video,
      localPath: file.path,
      fileName: fileName,
      fileSize: stat.size,
      coverLocalPath: coverLocalPath,
      width: entity.width,
      height: entity.height,
      durationSeconds: entity.duration,
    );
  }

  @override
  Future<ChatMediaAttachment?> pickFromGallery(BuildContext context) async {
    // 用 pickAssetsWithDelegate + LivePhotoTogglePickerDelegate 接管 picker UI:
    // 每张 Live Photo 缩略图右下角的 LIVE 角标变 tap toggle, 默认保留, 点一下
    // 切灰 + 划线 = 当作普通图发送 (跟微信 picker 内 toggle 一致). picker 关闭
    // 后通过 delegate.isKeepLive(asset) 读取最终状态.
    //
    // 流程严格对齐 wechat_assets_picker default `pickAssets` (asset_picker_delegate.dart:66-140):
    // 1. permissionCheck 拿真实 PermissionState (硬编码 authorized 会让没授权
    //    的设备看到 picker 但内部抓不到 asset → 灰屏)
    // 2. provider 必须传 initializeDelayDuration = route.transitionDuration
    //    (defaults to Duration.zero 会让 provider 在 push 动画中过早 init,
    //    在某些设备上触发渲染竞态)
    final permissionRequestOption = PermissionRequestOption(
      androidPermission: AndroidPermission(
        type: RequestType.common,
        mediaLocation: false,
      ),
    );
    final ps = await AssetPicker.permissionCheck(
      requestOption: permissionRequestOption,
    );
    final route = AssetPickerPageRoute<List<AssetEntity>>(
      builder: (_) => const SizedBox.shrink(),
    );
    final provider = DefaultAssetPickerProvider(
      maxAssets: 1,
      // RequestType.common = image | video, 对齐 iOS allowSelectVideo:YES.
      requestType: RequestType.common,
      initializeDelayDuration: route.transitionDuration,
    );
    final delegate = LivePhotoTogglePickerDelegate(
      provider: provider,
      initialPermission: ps,
    );
    // 必须显式指定 4 个 generic type args (wechat_assets_picker 10.0 breaking
    // change): Asset / Path / PickerProvider / Delegate. 不显式给 Dart 会
    // 推 dynamic, 导致 AssetPickerState<dynamic, dynamic, ...> 跟 build
    // 内的 widget tree state 类型不匹配, runtime push picker 时红屏.
    final result =
        await AssetPicker.pickAssetsWithDelegate<
          AssetEntity,
          AssetPathEntity,
          DefaultAssetPickerProvider,
          LivePhotoTogglePickerDelegate
        >(
          context,
          delegate: delegate,
          permissionRequestOption: permissionRequestOption,
        );
    if (result == null || result.isEmpty) return null;
    final entity = result.first;
    return attachmentFromGalleryAsset(
      entity,
      keepLive: entity.type == AssetType.image && delegate.isKeepLive(entity),
    );
  }

  static Future<ChatMediaAttachment?> attachmentFromGalleryAsset(
    AssetEntity entity, {
    bool keepLive = false,
  }) async {
    final file = await entity.file;
    if (file == null || !await file.exists()) return null;

    final stat = await file.stat();
    final fileName = file.path.split(Platform.pathSeparator).last;

    if (entity.type == AssetType.image) {
      // Live Photo 路径: 必须 entity.isLivePhoto && delegate 标记 keepLive
      // (用户没把它 toggle 成普通图) && iOS (Android 没 Live Photo 概念).
      // 协议形态参考 Telegram InputMediaLivePhoto, 接收端点击 bubble 播放
      // MOV (含声音).
      if (entity.isLivePhoto && keepLive && Platform.isIOS) {
        final pairedVideo = await entity.loadFile(
          withSubtype: true,
          darwinFileType: PMDarwinAVFileType.mov,
        );
        if (pairedVideo != null && await pairedVideo.exists()) {
          final videoStat = await pairedVideo.stat();
          // Live Photo 静态部分实际 dimensions 跟普通图同样需要 decode 校
          // 准, 不能信 entity.width/height (见下方 image 分支 fix 注释).
          final (lpW, lpH) = await _decodeImageDimensions(
            file,
            fallbackW: entity.width,
            fallbackH: entity.height,
          );
          return ChatMediaAttachment(
            kind: ChatMediaKind.livePhoto,
            localPath: file.path,
            fileName: fileName,
            fileSize: stat.size,
            livePhotoVideoLocalPath: pairedVideo.path,
            livePhotoVideoSize: videoStat.size,
            width: lpW,
            height: lpH,
            durationSeconds: entity.duration,
          );
        }
        // Paired MOV 拿不到 (iCloud 没下载完整 / 权限不全), 降级走普通图.
      }
      // **关键 fix**: AssetEntity.width/height 元数据可能跟 file decode
      // 后的 dimensions 不一致 (HEIC 转 JPEG 时 EXIF orientation, 或 picker
      // resize). 用 instantiateImageCodec decode 拿真实 dimensions, 跟接收方
      // ImageStream resolve 值一致, 双方都不变形.
      final (gW, gH) = await _decodeImageDimensions(
        file,
        fallbackW: entity.width,
        fallbackH: entity.height,
      );
      return ChatMediaAttachment(
        kind: ChatMediaKind.image,
        localPath: file.path,
        fileName: fileName,
        fileSize: stat.size,
        width: gW,
        height: gH,
      );
    }

    // Video: 抽首帧 cover 写到 tmp, 与主视频一起上传 (跟 pickFromCamera 同款逻辑).
    String coverLocalPath = '';
    try {
      final coverBytes = await entity.thumbnailData;
      if (coverBytes != null && coverBytes.isNotEmpty) {
        final dir = await getTemporaryDirectory();
        final coverFile = File(
          '${dir.path}/cover_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await coverFile.writeAsBytes(coverBytes, flush: true);
        coverLocalPath = coverFile.path;
      }
    } catch (_) {
      // 首帧抽不到不致命 — 接收端可用 video player 自己 seek.
    }

    return ChatMediaAttachment(
      kind: ChatMediaKind.video,
      localPath: file.path,
      fileName: fileName,
      fileSize: stat.size,
      coverLocalPath: coverLocalPath,
      width: entity.width,
      height: entity.height,
      durationSeconds: entity.duration,
    );
  }

  @override
  Future<ChatMediaAttachment?> pickFile() async {
    final result = await FilePicker.pickFiles(withData: false);
    final file = result?.files.single;
    final path = file?.path;
    if (file == null || path == null || path.isEmpty) {
      return null;
    }
    return ChatMediaAttachment(
      kind: ChatMediaKind.file,
      localPath: path,
      fileName: file.name,
      fileSize: file.size,
    );
  }

  @override
  Future<void> startVoiceRecording() async {
    final recorder = _voiceRecorder ??= AudioRecorder();
    if (!await recorder.hasPermission()) {
      throw const ApiException('没有麦克风权限');
    }
    if (!await recorder.isEncoderSupported(AudioEncoder.aacLc)) {
      throw const ApiException('当前设备不支持 AAC 语音录制');
    }
    final directory = await getTemporaryDirectory();
    final path =
        '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, numChannels: 1),
      path: path,
    );
    _voiceRecordingPath = path;
    _voiceRecordingStartedAt = DateTime.now();
  }

  @override
  Future<ChatMediaAttachment?> stopVoiceRecording() async {
    final recorder = _voiceRecorder;
    if (recorder == null) {
      return null;
    }
    final path = await recorder.stop();
    final startedAt = _voiceRecordingStartedAt;
    _voiceRecordingStartedAt = null;
    _voiceRecordingPath = null;
    if (path == null || path.isEmpty) {
      return null;
    }
    final file = File(path);
    final stat = await file.stat();
    final duration = startedAt == null
        ? 1
        : DateTime.now().difference(startedAt).inSeconds.clamp(1, 59).toInt();
    return ChatMediaAttachment(
      kind: ChatMediaKind.voice,
      localPath: path,
      fileName: path.split(Platform.pathSeparator).last,
      fileSize: stat.size,
      durationSeconds: duration,
    );
  }

  @override
  Future<void> cancelVoiceRecording() async {
    final recorder = _voiceRecorder;
    if (recorder == null) {
      return;
    }
    final path = await recorder.stop() ?? _voiceRecordingPath;
    _voiceRecordingStartedAt = null;
    _voiceRecordingPath = null;
    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  @override
  Future<void> saveImageToAlbum(String imagePath) async {
    final path = imagePath.trim();
    if (path.isEmpty) {
      throw const ApiException('图片路径为空');
    }
    try {
      await _channel.invokeMethod<void>('saveImageToAlbum', {'path': path});
    } on MissingPluginException {
      throw const ApiException('当前平台不支持保存图片');
    }
  }

  Future<void> dispose() async {
    await _voiceRecorder?.dispose();
    _voiceRecorder = null;
  }

  @override
  Stream<double>? voiceAmplitudes({
    Duration interval = const Duration(milliseconds: 100),
  }) {
    final recorder = _voiceRecorder;
    if (recorder == null) return null;
    // record package emits Amplitude{current, max}, both in dBFS
    // (negative). Normalize to 0..1: clamp dB to [-60, 0] then map
    // -60→0 / 0→1 (treats below -60 dB as silence).
    return recorder.onAmplitudeChanged(interval).map((a) {
      final db = a.current;
      if (db.isNaN || db.isInfinite) return 0.0;
      final clamped = db.clamp(-60.0, 0.0);
      return (clamped + 60) / 60;
    });
  }

  @override
  Future<File?> downloadToCache({
    required String url,
    required String filename,
  }) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return null;
    try {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$filename';
      final file = File(path);
      if (await file.exists() && (await file.length()) > 0) {
        return file;
      }
      final bytes = await client.downloadBytes(trimmed);
      if (bytes.isEmpty) return null;
      await file.writeAsBytes(bytes, flush: true);
      return file;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ChatMediaAttachment> uploadAttachment({
    required String channelId,
    required int channelType,
    required ChatMediaAttachment attachment,
    void Function(double progress)? onProgress,
  }) async {
    if (attachment.remoteUrl.isNotEmpty) {
      return attachment;
    }

    // 视频两段式上传 (对齐 iOS WKSmallVideoContent): 先上传首帧 cover JPG 拿
    // coverUrl, 进度条只跟主视频, cover 一般 <50KB 上传瞬间完成.
    String coverUrl = attachment.coverUrl;
    if (attachment.kind == ChatMediaKind.video &&
        attachment.coverLocalPath.isNotEmpty &&
        coverUrl.isEmpty) {
      coverUrl = await _uploadOne(
        channelId: channelId,
        channelType: channelType,
        localPath: attachment.coverLocalPath,
        fileName: 'cover_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
    }

    // Live Photo 两段式上传: 主图走 remoteUrl, paired MOV 走 livePhotoVideoUrl.
    // 进度条以静态图为准 (主图通常更小, 优先完成视觉反馈).
    String livePhotoVideoUrl = attachment.livePhotoVideoUrl;
    if (attachment.kind == ChatMediaKind.livePhoto &&
        attachment.livePhotoVideoLocalPath.isNotEmpty &&
        livePhotoVideoUrl.isEmpty) {
      livePhotoVideoUrl = await _uploadOne(
        channelId: channelId,
        channelType: channelType,
        localPath: attachment.livePhotoVideoLocalPath,
        fileName: 'livephoto_${DateTime.now().millisecondsSinceEpoch}.mov',
      );
    }

    final remoteUrl = await _uploadOne(
      channelId: channelId,
      channelType: channelType,
      localPath: attachment.localPath,
      fileName: attachment.fileName,
      onProgress: onProgress,
    );
    return attachment.copyWith(
      remoteUrl: remoteUrl,
      coverUrl: coverUrl,
      livePhotoVideoUrl: livePhotoVideoUrl,
    );
  }

  Future<String> _uploadOne({
    required String channelId,
    required int channelType,
    required String localPath,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    final uploadPath = _uploadPath(channelId, channelType, fileName);
    final query = Uri(queryParameters: {'type': 'chat', 'path': uploadPath});
    final uploadInfo = await client.getJson('file/upload?${query.query}');
    final uploadUrl = _string(_source(uploadInfo)['url']);
    if (uploadUrl.isEmpty) {
      throw const ApiException('上传地址为空');
    }

    // The upload URL may be an absolute API endpoint (server) or a presigned
    // object-storage URL (MinIO). Use ApiClient.uploadFile so the request
    // includes our auth token header — the previous direct dio.post bypassed
    // _options() and 401'd on auth-protected upload routes.
    final uploadResult = await client.uploadFile(
      uploadUrl,
      localPath,
      onSendProgress: onProgress == null
          ? null
          : (sent, total) {
              if (total > 0) onProgress(sent / total);
            },
    );
    final result = _readMap(uploadResult);
    final relative = _string(result['path']).isEmpty
        ? uploadPath
        : _string(result['path']);
    // Persist the *absolute* URL so the remote peer (who has no local file)
    // can display the image / play the voice immediately. The server's
    // `path` field is a relative slug like `/1/uid/123.m4a` which the IM
    // payload would otherwise propagate as-is — receivers checking
    // `startsWith('http')` would then drop the attachment.
    return client.config.showUrl(relative);
  }

  static String _uploadPath(
    String channelId,
    int channelType,
    String fileName,
  ) {
    final extension = fileName.contains('.') ? fileName.split('.').last : 'bin';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '/$channelType/$channelId/$timestamp.$extension';
  }

  static Map<String, dynamic> _source(Map<String, dynamic> value) {
    final data = value['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return value;
  }

  static Map<String, dynamic> _readMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return const {};
  }

  static String _string(Object? value) => value?.toString() ?? '';

  /// Decode image file 拿真实 dimensions — AssetEntity.width/height 在
  /// HEIC 转 JPEG / EXIF orientation 处理时跟 file 实际 decode dimensions
  /// 可能不一致, 导致接收方 ImageStream resolve 值跟发送方 attachment 字段
  /// mismatch → image bubble 容器 aspect 错 → 变形.
  ///
  /// decode 失败时 fallback 到 picker 元数据值 (兜底, 总比 0 强).
  static Future<(int, int)> _decodeImageDimensions(
    File file, {
    required int fallbackW,
    required int fallbackH,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final w = frame.image.width;
      final h = frame.image.height;
      frame.image.dispose();
      return (w, h);
    } catch (_) {
      return (fallbackW, fallbackH);
    }
  }
}
