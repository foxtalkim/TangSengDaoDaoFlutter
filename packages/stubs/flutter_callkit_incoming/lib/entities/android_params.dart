library;

class AndroidParams {
  const AndroidParams({
    this.isCustomNotification,
    this.isShowLogo,
    this.isShowCallID,
    this.ringtonePath,
    this.backgroundColor,
    this.actionColor,
    this.textColor,
    this.incomingCallNotificationChannelName,
    this.missedCallNotificationChannelName,
    this.isShowFullLockedScreen,
    this.isImportant,
  });

  final bool? isCustomNotification;
  final bool? isShowLogo;
  final bool? isShowCallID;
  final String? ringtonePath;
  final String? backgroundColor;
  final String? actionColor;
  final String? textColor;
  final String? incomingCallNotificationChannelName;
  final String? missedCallNotificationChannelName;
  final bool? isShowFullLockedScreen;
  final bool? isImportant;
}
