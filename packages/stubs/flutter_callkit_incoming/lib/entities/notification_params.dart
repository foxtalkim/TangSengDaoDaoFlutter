library;

class NotificationParams {
  const NotificationParams({
    this.showNotification,
    this.isShowCallback,
    this.subtitle,
  });

  final bool? showNotification;
  final bool? isShowCallback;
  final String? subtitle;
}
