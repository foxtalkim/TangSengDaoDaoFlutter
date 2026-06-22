abstract final class CoreModuleIds {
  static const auth = 'core.auth';
  static const chat = 'core.chat';
  static const contacts = 'core.contacts';
  static const conversation = 'core.conversation';
  static const groups = 'core.groups';
  static const im = 'core.im';
  static const push = 'core.push';
  static const settings = 'core.settings';
}

abstract final class ExtensionModuleIds {
  static const advanced = 'advanced';
  static const favorite = 'favorite';
  static const file = 'file';
  static const imageEditor = 'image_editor';
  static const location = 'location';
  static const messageAi = 'message_ai';
  static const moment = 'moment';
  static const pinned = 'pinned';
  static const richText = 'richtext';
  static const rtc = 'rtc';
  static const smallVideo = 'smallvideo';
  static const stickerStore = 'stickerstore';
  static const tags = 'tags';
  static const vendorPush = 'vendor_push';
}

abstract final class ModuleRouteIds {
  static const chat = 'route.chat';
  static const favorite = 'route.favorite';
  static const locationPicker = 'route.location_picker';
  static const locationViewer = 'route.location_viewer';
  static const moment = 'route.moment';
  static const rtcCall = 'route.rtc.call';
  static const rtcIncomingCall = 'route.rtc.incoming_call';
  static const tags = 'route.tags';
}

abstract final class ModuleFeatureIds {
  static const rtcCallGatewayFactory = 'rtc.call_gateway_factory';
  static const rtcSessionApi = 'rtc.session_api';
  static const momentNotificationGatewayFactory =
      'moment.notification_gateway_factory';
  static const imageEditorLauncher = 'image_editor.launcher';
  static const imageCropLauncher = 'image_editor.crop_launcher';
  static const fileInfoPageBuilder = 'file.info_page_builder';
  static const videoPlayerPageBuilder = 'smallvideo.video_player_page_builder';
  static const livePhotoViewerPageBuilder =
      'smallvideo.live_photo_viewer_page_builder';
  static const stickerThumbnailBuilder = 'sticker_store.thumbnail_builder';
  static const stickerStorePageBuilder = 'sticker_store.page_builder';
  static const stickerManagerPageBuilder = 'sticker_store.manager_page_builder';
  static const socialProcessCache = 'social.process_cache';
  static const messageAiGatewayFactory = 'message_ai.gateway_factory';
}

abstract final class ModuleCmdHandlerIds {
  static const pinnedSync = 'cmd.pinned.sync';
  static const momentNotification = 'cmd.moment.notification';
  static const rtcIncomingCall = 'cmd.rtc.incoming_call';
}

abstract final class ModuleHydrationHookIds {
  static const favoriteSync = 'hydration.favorite.sync';
  static const activePinnedSync = 'hydration.pinned.active_sync';
  static const rtcPendingInvites = 'hydration.rtc.pending_invites';
}

abstract final class ModuleMessageContentTypeIds {
  static const file = 8;
  static const location = 6;
  static const gifSticker = 3;
  static const lottieSticker = 12;
  static const emojiSticker = 13;
}

abstract final class ModuleActionIds {
  static const composerAlbum = 'composer.album';
  static const composerCamera = 'composer.camera';
  static const composerContactCard = 'composer.contact_card';
  static const composerFile = 'composer.file';
  static const composerLocation = 'composer.location';
  static const composerAudioCall = 'composer.audio_call';
  static const composerVideoCall = 'composer.video_call';
  static const messageFavorite = 'message.favorite';
  static const messagePin = 'message.pin';
  static const messageUnpin = 'message.unpin';
  static const messageAdvancedDynamicActions =
      'message.advanced.dynamic_actions';
  static const messageEditImage = 'message.edit_image';
  static const messageFileContent = 'message.file.content';
  static const messageLocationContent = 'message.location.content';
  static const messageGifStickerContent = 'message.sticker.gif.content';
  static const messageLottieStickerContent = 'message.sticker.lottie.content';
  static const messageEmojiStickerContent = 'message.sticker.emoji.content';
  static const messageRtcCallSystemContent = 'message.rtc.call_system.content';
  static const messageRichTextContent = 'message.rich_text.content';
  static const messageSmallVideoContent = 'message.small_video.content';
  static const messageReactions = 'message.reactions';
  static const messageReceipts = 'message.receipts';
  static const contactProfileMoment = 'profile.moment';
  static const contactTags = 'contact.tags';
  static const discoverMoment = 'discover.moment';
  static const stickerStoreOpen = 'sticker_store.open';
  static const vendorPushStart = 'push.vendor.start';
}
