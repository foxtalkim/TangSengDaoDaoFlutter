// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get tabMessages => 'Trò chuyện';

  @override
  String get tabContacts => 'Liên hệ';

  @override
  String get tabDiscover => 'Khám phá';

  @override
  String get tabMe => 'Tôi';

  @override
  String get pageMessagesTitle => 'Trò chuyện';

  @override
  String get pageContactsTitle => 'Liên hệ';

  @override
  String get pageDiscoverTitle => 'Khám phá';

  @override
  String get pageMeTitle => 'Tôi';

  @override
  String get actionCancel => 'Hủy';

  @override
  String get actionConfirm => 'Xác nhận';

  @override
  String get actionDone => 'Xong';

  @override
  String get actionSave => 'Lưu';

  @override
  String get actionDelete => 'Xóa';

  @override
  String get actionEdit => 'Chỉnh sửa';

  @override
  String get actionAdd => 'Thêm';

  @override
  String get actionRemove => 'Xóa';

  @override
  String get actionInvite => 'Mời';

  @override
  String get actionSearch => 'Tìm kiếm';

  @override
  String get actionSend => 'Gửi';

  @override
  String get actionRetry => 'Thử lại';

  @override
  String get actionBack => 'Quay lại';

  @override
  String get actionMore => 'Thêm';

  @override
  String get actionJoin => 'Tham gia';

  @override
  String get actionSkip => 'Bỏ qua';

  @override
  String get actionContinue => 'Tiếp tục';

  @override
  String get actionGetStarted => 'Bắt đầu';

  @override
  String get actionSaving => 'Đang lưu...';

  @override
  String get moduleUnsupported => 'Tính năng này không có trong phiên bản này';

  @override
  String get moduleLoading =>
      'Kiểm tra quyền truy cập tính năng. Hãy thử lại sau.';

  @override
  String get moduleOfflineStale =>
      'Kết nối mạng để xác nhận quyền truy cập tính năng';

  @override
  String get onboardingMenuTitle => 'Hướng dẫn nhanh';

  @override
  String onboardingChatTitle(Object appName) {
    return 'Chào mừng đến với $appName';
  }

  @override
  String get onboardingChatSubtitle =>
      'Một nơi sạch sẽ, nhẹ nhàng để trò chuyện thoải mái hơn.';

  @override
  String get onboardingFriendsTitle =>
      'Giúp việc giữ liên lạc trở nên đơn giản';

  @override
  String get onboardingFriendsSubtitle =>
      'Bạn bè, nhóm và chia sẻ dễ dàng tìm thấy hơn.';

  @override
  String get onboardingSecurityTitle =>
      'Nói chuyện thoải mái. Sử dụng nó với sự tự tin.';

  @override
  String get onboardingSecuritySubtitle =>
      'Bảo mật tài khoản và bảo vệ quyền riêng tư giúp bảo vệ ranh giới của bạn.';

  @override
  String get onboardingChatSemantic =>
      'Hình minh họa giới thiệu đồng bộ hóa tin nhắn';

  @override
  String get onboardingFriendsSemantic => 'Minh họa giới thiệu nhóm và bạn bè';

  @override
  String get onboardingSecuritySemantic =>
      'Hình minh họa giới thiệu về bảo mật và quyền riêng tư';

  @override
  String get settingsLanguageRow => 'Ngôn ngữ';

  @override
  String get settingsLanguageSystem => 'Mặc định hệ thống';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => 'Tiếng Anh';

  @override
  String get profileRowFavorites => 'Mục yêu thích';

  @override
  String get profileRowSecurityPrivacy => 'Bảo mật và quyền riêng tư';

  @override
  String get profileRowNotifications => 'Thông báo';

  @override
  String get profileRowInviteCode => 'Mã mời';

  @override
  String get profileRowGeneral => 'Chung';

  @override
  String profileRowAbout(Object appName) {
    return 'Giới thiệu về $appName';
  }

  @override
  String get profileLogout => 'Đăng xuất';

  @override
  String get profileLogoutConfirm =>
      'Đăng xuất sẽ không xóa bất kỳ lịch sử nào. Bạn có thể đăng nhập lại bằng tài khoản này bất cứ lúc nào.';

  @override
  String profileMoyuIdLabel(Object appName, Object value) {
    return '$appName ID: $value';
  }

  @override
  String get profileDefaultName => 'Tôi';

  @override
  String get profileDetailTitle => 'Hồ sơ';

  @override
  String get profileAvatar => 'Hình đại diện';

  @override
  String get profileNickname => 'Biệt hiệu';

  @override
  String get profileEditNickname => 'Chỉnh sửa biệt hiệu';

  @override
  String profileEditFoxId(Object appName) {
    return 'Chỉnh sửa $appName ID';
  }

  @override
  String get profileGender => 'Giới tính';

  @override
  String get profileGenderMale => 'Nam';

  @override
  String get profileGenderFemale => 'Nữ';

  @override
  String get profileGenderSelected => 'Đã chọn';

  @override
  String get profileGenderUnset => 'Chưa được đặt';

  @override
  String get profilePhoneUnbound => 'Không được liên kết';

  @override
  String get profileAvatarUpdated => 'Đã cập nhật hình đại diện';

  @override
  String get profileAvatarUpdateFailed =>
      'Không tải được hình đại diện lên. Hãy thử lại.';

  @override
  String get generalPageTitle => 'Chung';

  @override
  String get generalFontSize => 'Cỡ chữ';

  @override
  String get generalChatBackground => 'Nền trò chuyện';

  @override
  String get generalDarkMode => 'Chế độ tối';

  @override
  String get generalClearCache => 'Xóa bộ nhớ đệm';

  @override
  String get generalClearMessages => 'Xóa lịch sử trò chuyện';

  @override
  String get generalAppModules => 'Tính năng';

  @override
  String get generalErrorLogs => 'Nhật ký lỗi';

  @override
  String get generalThirdShare => 'Bên thứ ba SDKs';

  @override
  String get fontSizeSmall => 'Nhỏ';

  @override
  String get fontSizeStandard => 'Tiêu chuẩn';

  @override
  String get fontSizeLarge => 'Lớn';

  @override
  String get fontSizeExtraLarge => 'Cực lớn';

  @override
  String get darkModeSystem => 'Mặc định hệ thống';

  @override
  String get darkModeLight => 'Ánh sáng';

  @override
  String get darkModeDark => 'Tối';

  @override
  String get valueConfigure => 'Định cấu hình';

  @override
  String get valueManage => 'Quản lý';

  @override
  String get valueClear => 'Xóa';

  @override
  String get valueUpload => 'Tải lên';

  @override
  String get valueDownload => 'Tải xuống';

  @override
  String get valueView => 'Xem';

  @override
  String get valueEnabled => 'Đã bật';

  @override
  String get valueDisabled => 'Đã tắt';

  @override
  String get valueOn => 'Bật';

  @override
  String get valueOff => 'Tắt';

  @override
  String get valueConfigured => 'Bộ';

  @override
  String get valueNotEnabled => 'Chưa bật';

  @override
  String get valueSelected => 'Đã chọn';

  @override
  String get valueCurrentDevice => 'Thiết bị này';

  @override
  String get valueSdkInfo => 'SDK Thông tin';

  @override
  String get statusProcessing => 'Đang xử lý';

  @override
  String get statusLoading => 'Đang tải';

  @override
  String get statusSending => 'Đang gửi';

  @override
  String get statusSaving => 'Đang lưu';

  @override
  String get statusSaved => 'Đã lưu';

  @override
  String get statusSent => 'Đã gửi';

  @override
  String get statusSubmitted => 'Đã gửi';

  @override
  String get dateJustNow => 'Vừa rồi';

  @override
  String get dateToday => 'Hôm nay';

  @override
  String get dateYesterday => 'Hôm qua';

  @override
  String get dateDayBeforeYesterday => 'Ngày hôm kia';

  @override
  String dateTodayTime(Object time) {
    return 'Hôm nay $time';
  }

  @override
  String dateYesterdayTime(Object time) {
    return 'Hôm qua $time';
  }

  @override
  String dateDayBeforeYesterdayTime(Object time) {
    return 'Hai ngày trước $time';
  }

  @override
  String dateWeekdayTime(Object time, Object weekday) {
    return '$weekday $time';
  }

  @override
  String dateMonthDayTime(Object day, Object month, Object time) {
    return '$day/$month $time';
  }

  @override
  String dateYearMonthDayTime(
    Object day,
    Object month,
    Object time,
    Object year,
  ) {
    return '$day/$month/$year $time';
  }

  @override
  String dateMonthDay(Object day, Object month) {
    return '$day/$month';
  }

  @override
  String dateYearMonthDay(Object day, Object month, Object year) {
    return '$day/$month/$year';
  }

  @override
  String get weekdayMonday => 'Thứ Hai';

  @override
  String get weekdayTuesday => 'Thứ ba';

  @override
  String get weekdayWednesday => 'Thứ Tư';

  @override
  String get weekdayThursday => 'Thứ năm';

  @override
  String get weekdayFriday => 'Thứ sáu';

  @override
  String get weekdaySaturday => 'Thứ bảy';

  @override
  String get weekdaySunday => 'Chủ nhật';

  @override
  String get dialogClearAllTitle => 'Xóa tất cả lịch sử trò chuyện?';

  @override
  String get dialogClearAllBody =>
      'Tất cả lịch sử trò chuyện cục bộ và các mục trò chuyện sẽ bị xóa.';

  @override
  String get authLoginSubtitle =>
      'Đăng nhập bằng số điện thoại của bạn và tiếp tục trò chuyện với bạn bè';

  @override
  String get authLoginIllustration => 'Minh họa đăng nhập';

  @override
  String get authRegisterIllustration => 'Đăng ký minh họa';

  @override
  String get authSecurityIllustration => 'Minh họa xác minh';

  @override
  String get authResetIllustration => 'Hình minh họa đặt lại mật khẩu';

  @override
  String get authServerLabel => 'Máy chủ';

  @override
  String get authServerCustomLabel => 'Custom server';

  @override
  String get authServerCustomHint => 'Enter server address';

  @override
  String get authPhoneLabel => 'Số điện thoại';

  @override
  String get authPasswordLabel => 'Mật khẩu';

  @override
  String get authForgotPassword => 'Quên mật khẩu?';

  @override
  String get authLoginButton => 'Đăng nhập';

  @override
  String get authLoginLoading => 'Đang đăng nhập...';

  @override
  String get authRegisterButton => 'Đăng ký';

  @override
  String get authLoginWithApple => 'Sign in with Apple';

  @override
  String get authLoginWithGoogle => 'Sign in with Google';

  @override
  String get authLoginWithGithub => 'Sign in with GitHub';

  @override
  String get authLoginAgreementPrefix => 'Bằng cách đăng nhập, bạn đồng ý với';

  @override
  String get authTermsTitle => 'Điều khoản dịch vụ';

  @override
  String get authAgreementConnector => 'và';

  @override
  String get authPrivacyTitle => 'Chính sách quyền riêng tư';

  @override
  String get authVerifyTitle => 'Xác minh Đăng nhập';

  @override
  String authVerifySubtitleWithPhone(Object phone) {
    return 'Nhập mã được gửi tới $phone';
  }

  @override
  String get authVerifySubtitlePasswordFirst =>
      'Trước tiên hãy đăng nhập bằng mật khẩu của bạn để bắt đầu xác minh bảo mật';

  @override
  String get authVerifyButton => 'Xác minh';

  @override
  String get authVerifyLoading => 'Đang xác minh...';

  @override
  String get authResendCode => 'Bạn chưa nhận được mã? Gửi lại';

  @override
  String get authVerificationCodeSent => 'Đã gửi mã xác minh';

  @override
  String get authVerificationCodeRequired => 'Nhập mã xác minh';

  @override
  String get authVerificationCodeSixDigits => 'Nhập mã gồm 6 chữ số';

  @override
  String get authPasswordResetTitle => 'Đặt lại mật khẩu đăng nhập';

  @override
  String get authPasswordResetSubtitle =>
      'Xác minh số điện thoại của bạn, sau đó đặt mật khẩu đăng nhập mới';

  @override
  String get authPasswordResetButton => 'Đặt lại mật khẩu';

  @override
  String get authKickedTitle =>
      'Tài khoản của bạn đã được đăng nhập trên một thiết bị khác.';

  @override
  String get authSubmitting => 'Đang gửi...';

  @override
  String get authVerificationCodeLabel => 'Mã xác minh';

  @override
  String get authGetVerificationCode => 'Nhận mã';

  @override
  String get authNewPasswordLabel => 'Mật khẩu mới';

  @override
  String get authPasswordResetSuccess => 'Đặt lại mật khẩu';

  @override
  String authRegisterTitle(Object appName) {
    return 'Tạo tài khoản $appName';
  }

  @override
  String get authRegisterSubtitle =>
      'Đăng ký bằng số điện thoại của bạn và bắt đầu trò chuyện ngay';

  @override
  String get authCreateAccount => 'Tạo tài khoản';

  @override
  String get authNicknameLabel => 'Biệt danh';

  @override
  String get authInviteCodeRequiredLabel => 'Mã mời (bắt buộc)';

  @override
  String authCodeRetryAfter(Object seconds) {
    return 'Thử lại sau $seconds giây';
  }

  @override
  String get authRegisterAgreement =>
      'Tôi đã đọc và đồng ý với Điều khoản dịch vụ và Chính sách quyền riêng tư';

  @override
  String get authInvalidPhone => 'Số điện thoại không hợp lệ';

  @override
  String get authAcceptAgreementFirst =>
      'Vui lòng đồng ý với Điều khoản dịch vụ và Chính sách quyền riêng tư trước';

  @override
  String get authCodeEmpty => 'Cần có mã xác minh';

  @override
  String get authPasswordLengthInvalid => 'Mật khẩu phải có 6-16 ký tự';

  @override
  String get authInviteCodeEmpty => 'Cần có mã mời';

  @override
  String get authRegisterSuccess => 'Đã đăng ký thành công';

  @override
  String get settingsCheckNewVersion => 'Kiểm tra cập nhật';

  @override
  String get settingsChecking => 'Đang kiểm tra';

  @override
  String get settingsVersionFound => 'Đã có bản cập nhật';

  @override
  String get settingsUserAgreement => 'Điều khoản dịch vụ';

  @override
  String get settingsPrivacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get settingsView => 'Xem';

  @override
  String get settingsSwitchAccount => 'Chuyển đổi tài khoản';

  @override
  String get settingsCacheCleared => 'Đã xóa bộ nhớ đệm';

  @override
  String get settingsClearCacheSheetTitle =>
      'Xóa bộ nhớ đệm hình ảnh/video?\nHình ảnh trò chuyện, ảnh bìa video và hình đại diện sẽ được tải xuống lại.';

  @override
  String get settingsClearCacheAction => 'Xóa bộ nhớ đệm';

  @override
  String get settingsMessagesCleared => 'Đã xóa lịch sử trò chuyện';

  @override
  String settingsClearMessagesFailed(Object error) {
    return 'Không xóa được lịch sử trò chuyện: $error';
  }

  @override
  String get settingsAlreadyLatestVersion => 'Bạn đã có phiên bản mới nhất';

  @override
  String get settingsCheckFailed => 'Kiểm tra không thành công';

  @override
  String settingsUpdateDialogTitle(Object version) {
    return 'Đã có bản cập nhật\nPhiên bản mới nhất: $version';
  }

  @override
  String settingsUpdateDialogTitleWithDescription(
    Object description,
    Object version,
  ) {
    return 'Đã có bản cập nhật\nPhiên bản mới nhất: $version\n$description';
  }

  @override
  String get settingsLater => 'Sau';

  @override
  String get settingsUpdateNow => 'Cập nhật ngay';

  @override
  String get settingsSaveFailedRetry => 'Không lưu được. Hãy thử lại.';

  @override
  String get securityAllowPhoneSearch =>
      'Cho phép người khác tìm thấy tôi qua số điện thoại';

  @override
  String securityAllowFoxIdSearch(Object appName) {
    return 'Cho phép người khác tìm thấy tôi bằng $appName ID';
  }

  @override
  String get securitySearchRemark =>
      'Khi tắt, người dùng khác không thể tìm thấy bạn thông qua thông tin trên.';

  @override
  String get securityJoinGroupNeedConfirm =>
      'Require confirmation to join groups';

  @override
  String get securityJoinGroupNeedConfirmRemark =>
      'When on, invitations to add you to a group must be confirmed by you first.';

  @override
  String get securityLoginPassword => 'Mật khẩu đăng nhập';

  @override
  String get securityChatPassword => 'Mật khẩu trò chuyện';

  @override
  String get securityScreenProtection => 'Bảo vệ màn hình';

  @override
  String get securityLockPassword => 'Khóa mật khẩu';

  @override
  String get securityOfflineProtection => 'Khóa màn hình ngoại tuyến';

  @override
  String get securityDeviceManagement => 'Quản lý thiết bị đăng nhập';

  @override
  String get securityDeviceRemark =>
      'Xem và quản lý thiết bị, bật bảo vệ đăng nhập và giữ an toàn cho tài khoản của bạn.';

  @override
  String get securityBlacklist => 'Danh sách đen';

  @override
  String get securityAccountDeletion => 'Xóa tài khoản';

  @override
  String get accountDeletionBody =>
      'Việc xóa tài khoản không thể hoàn tác được. Sau khi xác nhận, mã xác minh sẽ được gửi qua SMS để hoàn tất việc xóa.';

  @override
  String get accountDeletionSubmitted => 'Đã gửi yêu cầu xóa';

  @override
  String get accountDeletionGetCode => 'Nhận mã';

  @override
  String get passwordResetInstruction =>
      'Việc thay đổi mật khẩu đăng nhập của bạn yêu cầu mã SMS. Mật khẩu mới phải có ít nhất 6 ký tự.';

  @override
  String get accountPhoneLabel => 'Số điện thoại';

  @override
  String get passwordRuleLabel => 'Quy tắc mật khẩu';

  @override
  String get passwordAtLeastSix => 'Ít nhất 6 ký tự';

  @override
  String get passwordConfirmLabel => 'Xác nhận mật khẩu';

  @override
  String get passwordConfirmHint => 'Nhập lại mật khẩu đăng nhập';

  @override
  String get passwordChanged => 'Mật khẩu đăng nhập đã thay đổi';

  @override
  String get phoneRequired => 'Cần có số điện thoại';

  @override
  String get passwordMismatch => 'Mật khẩu không khớp';

  @override
  String get chatPasswordInstruction =>
      'Khi được bật, mật khẩu gồm 6 chữ số này là bắt buộc trước khi mở các cuộc trò chuyện được bảo vệ.';

  @override
  String get currentStatusLabel => 'Trạng thái hiện tại';

  @override
  String get passwordSixDigits => '6 chữ số';

  @override
  String get chatPasswordEnableAction => 'Kích hoạt mật khẩu trò chuyện';

  @override
  String get loginPasswordRequired => 'Cần có mật khẩu đăng nhập';

  @override
  String get chatPasswordSixDigitsRequired =>
      'Mật khẩu trò chuyện phải có 6 chữ số';

  @override
  String get lockSetTitle => 'Đặt mật khẩu khóa gồm 6 chữ số';

  @override
  String lockSetSubtitle(Object appName) {
    return 'Bắt buộc phải mở khóa $appName';
  }

  @override
  String get lockCurrentPromptTitle => 'Nhập mật khẩu khóa hiện tại';

  @override
  String get lockCurrentPromptSubtitle =>
      'Xác minh trước khi thay đổi hoặc tắt';

  @override
  String get lockAutoLock => 'Khóa tự động';

  @override
  String get lockChangePassword => 'Thay đổi mật khẩu mở khóa';

  @override
  String get lockClosePassword => 'Tắt mật khẩu mở khóa';

  @override
  String get lockWrongPassword => 'Mật khẩu sai. Hãy thử lại.';

  @override
  String get lockSixDigitsRequired => 'Mật khẩu khóa phải có 6 chữ số';

  @override
  String get lockInputTitle => 'Nhập mật khẩu khóa';

  @override
  String lockInputSubtitle(Object appName) {
    return 'Mở khóa để tiếp tục sử dụng $appName';
  }

  @override
  String get lockSetFailed => 'Không đặt được. Hãy thử lại.';

  @override
  String get lockImmediately => 'Ngay lập tức';

  @override
  String get lockAfter5Minutes => 'Sau 5 phút nữa';

  @override
  String get lockAfter30Minutes => 'Sau 30 phút nữa';

  @override
  String get lockAfter1Hour => 'Sau 1 giờ nữa';

  @override
  String get deviceLoginProtection => 'Bảo vệ đăng nhập';

  @override
  String get deviceProtectionRemark =>
      'Khi bật tính năng bảo vệ đăng nhập, yêu cầu xác minh bảo mật trên các thiết bị không quen thuộc. Được khuyến nghị để đảm bảo an toàn cho tài khoản.';

  @override
  String get deviceNone => 'Không có thiết bị đăng nhập nào';

  @override
  String get deviceDebugName => 'Thiết bị hiện tại';

  @override
  String get deviceDebugPlatform => 'Thiết bị gỡ lỗi iPhone / Android';

  @override
  String get deviceProtectionEnabled => 'Đã bật tính năng bảo vệ đăng nhập';

  @override
  String get deviceProtectionDisabled => 'Bảo vệ đăng nhập bị tắt';

  @override
  String get deviceProtectionUpdateFailed =>
      'Không cập nhật được biện pháp bảo vệ đăng nhập. Hãy thử lại.';

  @override
  String get blacklistEmpty =>
      'Không có địa chỉ liên hệ nào nằm trong danh sách đen';

  @override
  String get switchAccountRecent => 'Tài khoản gần đây';

  @override
  String get switchAccountLoading => 'Đọc tài khoản gần đây';

  @override
  String get switchAccountAddOther => 'Thêm hoặc đăng nhập vào tài khoản khác';

  @override
  String get switchAccountCurrent => 'Hiện tại';

  @override
  String get appModulesLoading => 'Đang tải mô-đun tính năng';

  @override
  String get appModulesEmpty => 'Không có mô-đun tính năng';

  @override
  String get appModulesUnavailable => 'Mô-đun không có sẵn';

  @override
  String get errorLogsLoading => 'Đọc nhật ký lỗi';

  @override
  String get errorLogsEmpty => 'Không có nhật ký lỗi';

  @override
  String get errorLogFileName => 'Tên tệp';

  @override
  String get errorLogFileSize => 'Kích thước tệp';

  @override
  String get errorLogGeneratedAt => 'Được tạo vào lúc';

  @override
  String get errorLogFilePath => 'Đường dẫn tệp';

  @override
  String get notificationReceiveNew => 'Nhận thông báo tin nhắn mới';

  @override
  String get notificationSound => 'Âm thanh';

  @override
  String get notificationVibration => 'Rung';

  @override
  String get notificationShowDetails => 'Hiển thị chi tiết thông báo';

  @override
  String get notificationSystem => 'Thông báo tin nhắn hệ thống';

  @override
  String get notificationCalls => 'Thông báo cuộc gọi âm thanh/video';

  @override
  String get settingsGoToSystem => 'Cài đặt';

  @override
  String aboutAppIconSemantic(Object appName) {
    return '$appName biểu tượng';
  }

  @override
  String aboutCopyright(Object appName) {
    return 'Bản quyền © 2026\n$appName. Mọi quyền được bảo lưu.';
  }

  @override
  String get policyWebUrl => 'Web URL';

  @override
  String get appearanceTitle => 'Ngoại hình';

  @override
  String get appearanceAppIcon => 'Biểu tượng ứng dụng';

  @override
  String get appearanceTabBarStyle => 'Bottom Navigation';

  @override
  String get appearanceTabBarStyleMode => 'Display Style';

  @override
  String get appearanceTabBarStyleGlassDock => 'Glass Dock';

  @override
  String get appearanceTabBarStyleClassic => 'Classic';

  @override
  String get appearanceDockFollowsChatColor => 'Dock Follows Chat Color';

  @override
  String get appearanceChatColor => 'Màu trò chuyện';

  @override
  String get appearanceBubbleRadius => 'Bán kính góc bong bóng';

  @override
  String get appearanceBubbleColorInk => 'Mực đen';

  @override
  String get appearanceSquare => 'Hình vuông';

  @override
  String get appearanceRound => 'Vòng';

  @override
  String get appearancePreviewOne => 'Anh ấy muốn tôi rẽ phải hay trái? 🤔';

  @override
  String get appearancePreviewTwo =>
      'Đúng rồi. Và, à, hãy làm cho nó mạnh mẽ lên.';

  @override
  String get appearancePreviewThree =>
      'Chỉ vậy thôi sao? Tôi cảm thấy như anh ấy đã nói nhiều hơn thế. 😯';

  @override
  String get appearancePreviewFour =>
      'Chỉ vậy thôi. Tôi sẽ gửi tin nhắn thoại với nhiều chi tiết hơn sau.';

  @override
  String get contactsEmptyTitle => 'Chưa có liên hệ nào';

  @override
  String get contactsEmptySubtitle =>
      'Thêm bạn bè từ trên cùng bên phải hoặc quét thẻ hồ sơ';

  @override
  String contactsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count liên hệ',
      one: '1 liên hệ',
    );
    return '$_temp0';
  }

  @override
  String get contactAddTooltip => 'Thêm bạn bè';

  @override
  String get contactSearchHint => 'Tìm kiếm liên hệ và nhóm';

  @override
  String get contactSetRemark => 'Đặt chú thích';

  @override
  String get contactAddToBlacklist => 'Thêm vào danh sách đen';

  @override
  String get contactDeleteFriend => 'Xóa bạn bè';

  @override
  String get contactAddedToBlacklist => 'Đã thêm vào danh sách đen';

  @override
  String get operationFailed => 'Thao tác không thành công. Hãy thử lại.';

  @override
  String operationFailedWithError(String error) {
    return 'Thao tác không thành công: $error';
  }

  @override
  String contactDeleteFriendConfirm(Object name) {
    return 'Xóa bạn bè \"$name\"?\nLịch sử trò chuyện cũng sẽ bị xóa.';
  }

  @override
  String get contactConfirmDelete => 'Xác nhận Xóa';

  @override
  String get contactDeleted => 'Bạn bè đã xóa';

  @override
  String get contactUnknownUser => 'Người dùng không xác định';

  @override
  String get contactActionNewFriends => 'Những người bạn mới';

  @override
  String get contactActionSavedGroups => 'Nhóm đã lưu';

  @override
  String get contactSearchNoMatches => 'Không có địa chỉ liên hệ nào phù hợp';

  @override
  String get addFriendTitle => 'Thêm bạn bè';

  @override
  String addFriendSearchHint(Object appName) {
    return 'Điện thoại / $appName ID';
  }

  @override
  String get addFriendNotFound => 'Không tìm thấy tài khoản';

  @override
  String get myQrCodeTitle => 'Mã QR của tôi';

  @override
  String myQrCodeSubtitle(Object appName) {
    return 'Quét mã QR này để thêm tôi vào $appName';
  }

  @override
  String get myQrCodeEmpty => 'Không có mã QR';

  @override
  String get scanTitle => 'Quét';

  @override
  String get scanQrNotFound => 'Không nhận dạng được mã QR';

  @override
  String scanResolveFailed(String error) {
    return 'Không phân tích được mã QR: $error';
  }

  @override
  String get scanUnrecognized => 'Mã QR này không thể nhận dạng được';

  @override
  String get scanInfoIncomplete => 'Thông tin mã QR chưa đầy đủ';

  @override
  String get scanSocialUnavailable => 'Dịch vụ xã hội chưa được khởi tạo';

  @override
  String get scanJoinedGroup => 'Đã tham gia trò chuyện nhóm';

  @override
  String get scanCannotOpenGroup =>
      'Trang này không thể mở cuộc trò chuyện nhóm';

  @override
  String get scanGroupNotFound => 'Không tìm thấy trò chuyện nhóm';

  @override
  String get scanOpenGroupFailed => 'Không mở được trò chuyện nhóm';

  @override
  String get scanSelfQr => 'Đây là mã QR của riêng bạn';

  @override
  String get scanUserNotFound => 'Không tìm thấy người dùng';

  @override
  String get scanCameraPermissionRequired => 'Cần có sự cho phép của máy ảnh';

  @override
  String get scanOpenSettings => 'Mở Cài đặt';

  @override
  String get scanCameraUnavailable => 'Máy ảnh không có sẵn';

  @override
  String get scanAlbum => 'Album';

  @override
  String get scanLightOn => 'Bật đèn';

  @override
  String get scanLightOff => 'Tắt đèn';

  @override
  String get scanQrCode => 'Mã QR';

  @override
  String get scanGroupFallback => 'Trò chuyện nhóm';

  @override
  String get scanGroupLoadingInfo => 'Đang tải thông tin nhóm';

  @override
  String scanGroupMemberCount(int count) {
    return '$count thành viên';
  }

  @override
  String get scanJoinGroupConfirm => 'Tham gia trò chuyện nhóm';

  @override
  String get scanJoining => 'Đang tham gia';

  @override
  String get scanJoinGroup => 'Tham gia trò chuyện nhóm';

  @override
  String scanJoinFailed(String error) {
    return 'Không tham gia được: $error';
  }

  @override
  String get tagsTitle => 'Thẻ';

  @override
  String get tagsCreateTooltip => 'Thẻ mới';

  @override
  String get tagsContactSection => 'Thẻ liên hệ';

  @override
  String get tagsEmptyTitle => 'Không có thẻ';

  @override
  String get tagsEmptySubtitle =>
      'Nhấn vào dấu + ở trên cùng bên phải để nhóm các liên hệ hoặc cuộc trò chuyện.';

  @override
  String tagsCreateFailed(Object error) {
    return 'Không tạo được thẻ: $error';
  }

  @override
  String tagsUpdateFailed(Object error) {
    return 'Không cập nhật được thẻ: $error';
  }

  @override
  String tagsDeleteFailed(Object error) {
    return 'Không xóa được thẻ: $error';
  }

  @override
  String tagsLoadFailed(Object error) {
    return 'Không tải được thẻ: $error';
  }

  @override
  String tagsDeleteConfirm(String name) {
    return 'Xóa thẻ \"$name\"?\nCác liên hệ và nhóm trong thẻ này sẽ không bị xóa.';
  }

  @override
  String get tagsEditTitle => 'Chỉnh sửa thẻ';

  @override
  String get tagsCreateTitle => 'Thẻ mới';

  @override
  String get tagsNameSection => 'Tên thẻ';

  @override
  String get tagsNameHint => 'Gia đình, bạn bè';

  @override
  String tagsMembersSection(int count) {
    return 'Gắn thẻ thành viên ($count)';
  }

  @override
  String get tagsAddMember => 'Thêm thành viên';

  @override
  String get tagsDelete => 'Xóa thẻ';

  @override
  String get tagsGroupInitial => 'G';

  @override
  String get tagsUnknownUser => 'Người dùng không xác định';

  @override
  String get tagsSelectMembersTitle => 'Chọn thành viên';

  @override
  String tagsDoneCount(int count) {
    return 'Xong ($count)';
  }

  @override
  String get tagsSearchHint => 'Tìm kiếm liên hệ hoặc nhóm';

  @override
  String get tagsGroupsSection => 'Trò chuyện nhóm';

  @override
  String get tagsContactsSection => 'Liên hệ';

  @override
  String get tagsNoMatchesTitle => 'Không có kết quả phù hợp';

  @override
  String get tagsNoMatchesSubtitle => 'Thử từ khóa khác';

  @override
  String tagsRowTitle(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get phoneContactsTitle => 'Danh bạ điện thoại';

  @override
  String get phoneContactsSection => 'Thêm từ danh bạ điện thoại';

  @override
  String get phoneContactsEmpty => 'Không có danh bạ trên điện thoại';

  @override
  String get phoneContactsNoAddable =>
      'Không có liên hệ điện thoại nào để thêm';

  @override
  String get phoneContactsServerSyncFailed =>
      'Đồng bộ hóa máy chủ không thành công. Hiển thị các liên hệ hiện có.';

  @override
  String get friendAlreadyAdded => 'Đã thêm';

  @override
  String get friendRequestSent => 'Đã gửi yêu cầu kết bạn';

  @override
  String phoneContactsInviteSmsBody(Object appName) {
    return 'Tôi đang sử dụng $appName. Trải nghiệm trò chuyện khá thú vị. Hãy cũng đến thử nhé.';
  }

  @override
  String get phoneContactsInviteOpened => 'Đã mở lời mời qua SMS';

  @override
  String get phoneContactsInviteFailed =>
      'Không thể mở SMS. Vui lòng mời thủ công.';

  @override
  String get friendRequestsEmptyTitle => 'Không có bạn mới';

  @override
  String get friendRequestsEmptySubtitle => 'Mời bạn bè quét mã QR của bạn';

  @override
  String get friendRequestsPendingSection => 'Đang chờ xử lý';

  @override
  String get friendRequestRefused => 'Từ chối';

  @override
  String contactOpenFromContacts(Object name) {
    return 'Mở cuộc trò chuyện của @$name từ Danh bạ';
  }

  @override
  String get fileHelperIntro =>
      'Đăng nhập phiên bản web và gửi tin nhắn cho tôi để chuyển văn bản, ảnh, âm thanh, video và tập tin giữa điện thoại và máy tính.';

  @override
  String get fileHelperName => 'File Transfer';

  @override
  String get systemAccountName => 'System';

  @override
  String systemAccountIntro(Object appName) {
    return 'Tài khoản $appName chính thức để gửi thông báo.';
  }

  @override
  String get contactIntroTitle => 'Giới thiệu';

  @override
  String get contactSource => 'Nguồn';

  @override
  String get contactRemoveFriendRelation => 'Xóa bạn bè';

  @override
  String get contactRemoveFromBlacklist => 'Xóa khỏi danh sách đen';

  @override
  String get contactSendMessage => 'Tin nhắn';

  @override
  String get contactAddToContacts => 'Thêm vào Danh bạ';

  @override
  String get contactRemoveFriendConfirm => 'Xóa người bạn này?';

  @override
  String contactNicknameLine(Object name) {
    return 'Biệt danh: $name';
  }

  @override
  String get contactRemoveFromBlacklistConfirm =>
      'Xóa địa chỉ liên hệ này khỏi danh sách đen?';

  @override
  String get webLoginTitle => 'Web Đăng nhập';

  @override
  String get webLoginConfirmTitle => 'Xác nhận đăng nhập web?';

  @override
  String get webLoginConfirmBody =>
      'Điều này sẽ cho phép tài khoản của bạn đăng nhập vào trình duyệt hoặc máy tính để bàn hiện tại. Nếu đây không phải là bạn, hãy nhấn vào Hủy.';

  @override
  String get webLoginConfirmAction => 'Xác nhận đăng nhập';

  @override
  String get webLoginConfirming => 'Đang xác nhận...';

  @override
  String get webLoginConfirmed => 'Web xác nhận đăng nhập';

  @override
  String webLoginConfirmFailed(Object error) {
    return 'Xác nhận không thành công: $error';
  }

  @override
  String get applyFriendTitle => 'Yêu cầu kết bạn';

  @override
  String get applyFriendSectionTitle => 'Gửi yêu cầu kết bạn';

  @override
  String get applyFriendRemarkHint => 'Xin chào, tôi...';

  @override
  String friendRequestSendFailed(Object error) {
    return 'Không gửi được: $error';
  }

  @override
  String get contactRemarkHint => 'Ghi chú';

  @override
  String get momentPermissionsTitle => 'Khoảnh khắc riêng tư';

  @override
  String get momentHideMineFromContact => 'Ẩn khoảnh khắc của tôi với họ';

  @override
  String get momentHideContactFromMe => 'Ẩn khoảnh khắc của họ với tôi';

  @override
  String get momentTitle => 'Khoảnh khắc';

  @override
  String get momentPersonalEmpty => 'Chưa có bài đăng nào';

  @override
  String get momentEmpty => 'Chưa có khoảnh khắc nào';

  @override
  String get momentCoverUploadFailed => 'Không tải được bìa lên';

  @override
  String momentCoverUploadFailedWithError(Object error) {
    return 'Không tải được bìa lên: $error';
  }

  @override
  String get momentDeleteConfirm => 'Xóa khoảnh khắc này?';

  @override
  String get momentJustNow => 'Vừa rồi';

  @override
  String get momentPublishing => 'Posting…';

  @override
  String get momentPublishFailed => 'Failed to post. Tap to dismiss.';

  @override
  String get momentRemindedYou => 'Đã nhắc bạn xem Khoảnh khắc này';

  @override
  String momentRemindedNames(Object names) {
    return 'Đã nhắc $names';
  }

  @override
  String get momentKeepEditingConfirm => 'Giữ bản chỉnh sửa này?';

  @override
  String get momentContinueEditing => 'Tiếp tục chỉnh sửa';

  @override
  String get momentSaveDraft => 'Lưu bản nháp';

  @override
  String get momentDiscardDraft => 'Bỏ đi';

  @override
  String get momentPublishTitle => 'Bài đăng';

  @override
  String get momentPublishHint => 'Bạn đang nghĩ gì vậy...';

  @override
  String get momentLocationTitle => 'Vị trí';

  @override
  String get momentRemindWho => 'Nhắc nhở';

  @override
  String get locationUnsupported => 'Vị trí không có sẵn trong phiên bản này';

  @override
  String momentPrivacyContactCount(Object count, Object label) {
    return '$label · $count';
  }

  @override
  String get momentSelectVisibleContacts => 'Chọn Danh sách liên hệ hiển thị';

  @override
  String get momentSelectHiddenContacts => 'Chọn Danh bạ ẩn';

  @override
  String get momentPrivacyPublic => 'Công khai';

  @override
  String get momentPrivacyPrivate => 'Riêng tư';

  @override
  String get momentPrivacyInternal => 'Hiển thị với một số người';

  @override
  String get momentPrivacyProhibit => 'Ẩn khỏi';

  @override
  String get momentPrivacyWhoCanSee => 'Ai có thể xem';

  @override
  String momentCommentFailed(Object error) {
    return 'Bình luận không thành công: $error';
  }

  @override
  String get momentDetailTitle => 'Chi tiết';

  @override
  String get momentDeleted => 'Khoảnh khắc này đã bị xóa';

  @override
  String get momentCollapse => 'Thu gọn';

  @override
  String get momentFullText => 'Toàn văn';

  @override
  String get momentDeleteCommentConfirm => 'Xóa nhận xét này?';

  @override
  String get momentCommentPlaceholder => 'Bình luận';

  @override
  String momentReplyPlaceholder(Object name) {
    return 'Trả lời $name';
  }

  @override
  String get momentLikeAction => 'Thích';

  @override
  String get momentCommentAction => 'Bình luận';

  @override
  String momentNewMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tin nhắn mới',
      one: '1 tin nhắn mới',
    );
    return '$_temp0';
  }

  @override
  String get messagesTitle => 'Tin nhắn';

  @override
  String get messagesEmpty => 'Không có tin nhắn';

  @override
  String get messagesEmptyTitle => 'Chưa có tin nhắn nào';

  @override
  String get messagesEmptySubtitle =>
      'Bắt đầu cuộc trò chuyện mới từ trên cùng bên phải';

  @override
  String get messagesNewConversation => 'Mới';

  @override
  String get messagesStartGroupChat => 'Bắt đầu trò chuyện nhóm';

  @override
  String get messagesImDisconnected => 'IM chưa được kết nối';

  @override
  String get messagesPinned => 'Đã ghim';

  @override
  String get messagesUnpinned => 'Đã bỏ ghim';

  @override
  String get messagesMuted => 'Đã tắt tiếng';

  @override
  String get messagesNotificationsOn => 'Thông báo đang bật';

  @override
  String messagesDeleteConversationTitle(String name) {
    return 'Xóa \"$name\"?';
  }

  @override
  String get messagesConfirmDelete => 'Xóa';

  @override
  String get messagesCleared => 'Đã xóa lịch sử trò chuyện';

  @override
  String get messagesConversationDeleted => 'Đã xóa cuộc trò chuyện';

  @override
  String get messagesUnknownUser => 'Người dùng không xác định';

  @override
  String get messagesFriendAvatarFallback => 'F';

  @override
  String get messagesGroupFallback => 'Trò chuyện nhóm';

  @override
  String get messagesGroupAvatarFallback => 'G';

  @override
  String get messagesNewMessageDigest => '[Tin nhắn mới]';

  @override
  String get messagesConversationPin => 'Ghim';

  @override
  String get messagesConversationUnpin => 'Bỏ ghim';

  @override
  String get messagesConversationMute => 'Tắt tiếng';

  @override
  String get messagesConversationUnmute => 'Bật tiếng';

  @override
  String get messagesConnectionNoNetwork =>
      'Mạng không có sẵn. Kiểm tra kết nối của bạn.';

  @override
  String get messagesConnectionDisconnected => 'Đã ngắt kết nối';

  @override
  String get messagesConnectionConnecting => 'Đang kết nối';

  @override
  String get messagesConnectionSyncing => 'Đang đồng bộ hóa';

  @override
  String get globalSearchTitle => 'Tìm kiếm';

  @override
  String get globalSearchTabChats => 'Trò chuyện';

  @override
  String get globalSearchTabContacts => 'Liên hệ';

  @override
  String get globalSearchTabGroups => 'Nhóm';

  @override
  String get globalSearchTabFiles => 'Tệp';

  @override
  String get globalSearchContactsSection => 'Liên hệ';

  @override
  String get globalSearchGroupsSection => 'Trò chuyện nhóm';

  @override
  String get globalSearchMessagesSection => 'Lịch sử trò chuyện';

  @override
  String get globalSearchFilesSection => 'Tệp';

  @override
  String get globalSearchNoMatches => 'Không có kết quả phù hợp';

  @override
  String get globalSearchNoMore => 'Không có kết quả nào nữa';

  @override
  String get locationLocating => 'Đang định vị...';

  @override
  String locationPermissionOff(Object appName) {
    return 'Quyền vị trí bị tắt. Cho phép $appName sử dụng vị trí trong cài đặt hệ thống.';
  }

  @override
  String get locationPermissionDenied =>
      'Quyền truy cập vị trí đã bị từ chối. Không thể tải các địa điểm lân cận.';

  @override
  String get locationMapUnsupported =>
      'AMap không được hỗ trợ trên nền tảng này';

  @override
  String locationFailed(String error) {
    return 'Vị trí không thành công: $error';
  }

  @override
  String get locationSearchPrompt =>
      'Nhập từ khóa để tìm kiếm địa điểm lân cận';

  @override
  String get locationNoNearbyPoi => 'Không có POI ở gần';

  @override
  String get locationSearchHint => 'Tìm kiếm địa điểm lân cận';

  @override
  String get locationPickerTitle => 'Vị trí';

  @override
  String get locationSending => 'Đang gửi';

  @override
  String get locationUnnamed => 'Địa điểm chưa đặt tên';

  @override
  String get locationCopiedAddress => 'Đã sao chép địa chỉ';

  @override
  String get locationNoMapApp => 'Không có ứng dụng bản đồ';

  @override
  String get locationFallbackTitle => 'Vị trí';

  @override
  String get locationAmap => 'AMap';

  @override
  String get locationBaiduMap => 'Bản đồ Baidu';

  @override
  String get locationTencentMap => 'Bản đồ Tencent';

  @override
  String get locationAppleMap => 'Bản đồ Apple';

  @override
  String get locationOtherMap => 'Bản đồ khác';

  @override
  String get locationMyLocation => 'Vị trí của tôi';

  @override
  String locationOpenMapFailed(String name) {
    return 'Không thể mở $name';
  }

  @override
  String get locationCopyAddress => 'Sao chép địa chỉ';

  @override
  String get locationNavigate => 'Điều hướng';

  @override
  String get locationViewTitle => 'Bản đồ';

  @override
  String get momentPeerCommentDeleted => 'Đã xóa bình luận';

  @override
  String get momentDigest => '[Khoảnh khắc]';

  @override
  String get actionClose => 'Đóng';

  @override
  String get saveToAlbum => 'Lưu vào Album';

  @override
  String get savedToAlbum => 'Đã lưu vào album';

  @override
  String get saveFailed => 'Lưu không thành công';

  @override
  String dateMonth(Object month) {
    return '$month';
  }

  @override
  String dateMonthYear(Object month, Object year) {
    return '$month\n$year';
  }

  @override
  String momentExtraImages(Object count) {
    return '$count ảnh';
  }

  @override
  String get momentReplyConnector => 'đã trả lời';

  @override
  String get groupRemarkTitle => 'Nhận xét của nhóm';

  @override
  String get groupRemarkHint => 'Đặt nhận xét nhóm chỉ hiển thị với bạn';

  @override
  String get chatNotificationSettingsTitle => 'Thông báo tin nhắn';

  @override
  String get chatScreenshotNotification => 'Thông báo ảnh chụp màn hình';

  @override
  String get chatRevokeNotification => 'Thông báo thu hồi';

  @override
  String get completeProfileTitle => 'Hồ sơ hoàn chỉnh';

  @override
  String get completeProfileUploadAvatar => 'Tải lên hình đại diện';

  @override
  String get completeProfileReuploadAvatar => 'Tải lên Hình đại diện Mới';

  @override
  String get completeProfileChooseAvatar => 'Chọn ảnh hồ sơ';

  @override
  String get completeProfileAvatarUploaded => 'Đã tải lên hình đại diện';

  @override
  String get completeProfileAvatarRequired => 'Cần có hình đại diện.';

  @override
  String get nicknameLabel => 'Biệt hiệu';

  @override
  String get nicknameInputHint => 'Nhập biệt hiệu';

  @override
  String get nicknameRequired => 'Biệt hiệu là bắt buộc.';

  @override
  String get completeProfileSaved => 'Hồ sơ đã hoàn tất';

  @override
  String get chatSettingsTitle => 'Chi tiết trò chuyện';

  @override
  String chatSettingsGroupTitle(Object count) {
    return 'Thông tin trò chuyện ($count)';
  }

  @override
  String get chatSettingsGroupName => 'Tên trò chuyện nhóm';

  @override
  String get chatSettingsGroupQrCode => 'Mã QR nhóm';

  @override
  String get chatSearchContentTitle => 'Tìm kiếm Trò chuyện';

  @override
  String get chatSettingsBackground => 'Đặt nền trò chuyện';

  @override
  String get chatSettingsBackgroundSelected => 'Đã đặt nền trò chuyện hiện tại';

  @override
  String get chatSettingsMute => 'Ẩn thông báo';

  @override
  String get chatSettingsPin => 'Ghim trò chuyện';

  @override
  String get chatSettingsSaveToContacts => 'Lưu vào Danh bạ';

  @override
  String get chatSettingsReadReceipt => 'Biên nhận đã đọc';

  @override
  String get chatSettingsReadReceiptSubtitle =>
      'Khi được bật, tin nhắn đã gửi sẽ hiển thị trạng thái đã đọc/chưa đọc';

  @override
  String get chatSettingsFlame => 'Ghi sau khi đọc';

  @override
  String get chatFlameTipExit =>
      'Tin nhắn đã đọc sẽ bị hủy sau khi rời khỏi cuộc trò chuyện';

  @override
  String chatFlameTipMinutes(Object minutes) {
    return 'Tin nhắn bị hủy $minutes phút sau khi được đọc';
  }

  @override
  String chatFlameTipSeconds(Object seconds) {
    return 'Tin nhắn bị hủy $seconds giây sau khi được đọc';
  }

  @override
  String chatFlameLabelMinutes(Object minutes) {
    return '$minutes phút';
  }

  @override
  String chatFlameLabelSeconds(Object seconds) {
    return '${seconds}s';
  }

  @override
  String get chatSettingsGroupNickname => 'Biệt danh nhóm của tôi';

  @override
  String get chatSettingsBlacklisted => 'Bị liệt vào danh sách đen';

  @override
  String get chatSettingsPeerBlacklisted =>
      'Địa chỉ liên hệ này đã bị đưa vào danh sách cấm';

  @override
  String get chatSettingsComplaint => 'Báo cáo';

  @override
  String get chatSettingsDeleteAndExit => 'Xóa và thoát';

  @override
  String groupRemarkSyncFailed(Object error) {
    return 'Không đồng bộ hóa được nhận xét của nhóm: $error';
  }

  @override
  String get chatSocialDisconnected => 'Dịch vụ xã hội chưa được kết nối';

  @override
  String get chatNoRemovableMembers =>
      'Không có thành viên nào có thể tháo rời';

  @override
  String get chatSelectMembersToRemove => 'Chọn thành viên cần xóa';

  @override
  String chatMemberNameQuoted(Object name) {
    return '\"$name\"';
  }

  @override
  String chatMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thành viên',
      one: '1 thành viên',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersConfirm(Object names) {
    return 'Xóa $names khỏi nhóm';
  }

  @override
  String chatMembersRemoved(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã xóa $count thành viên',
      one: 'Đã xóa 1 thành viên',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersFailed(Object error) {
    return 'Không xóa được thành viên: $error';
  }

  @override
  String get chatNoInviteCandidates => 'Không có địa chỉ liên hệ nào để mời';

  @override
  String get chatInviteMembers => 'Mời thành viên';

  @override
  String get chatSelectContacts => 'Chọn Danh bạ';

  @override
  String chatMembersInvited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã mời $count thành viên',
      one: 'Đã mời 1 thành viên',
    );
    return '$_temp0';
  }

  @override
  String chatInviteMembersFailed(Object error) {
    return 'Không mời được thành viên: $error';
  }

  @override
  String get chatGroupCreated =>
      'Đã tạo cuộc trò chuyện nhóm. Kiểm tra danh sách trò chuyện.';

  @override
  String get chatGroupCreateFailed => 'Không tạo được cuộc trò chuyện nhóm';

  @override
  String chatGroupCreateFailedWithError(Object error) {
    return 'Không tạo được cuộc trò chuyện nhóm: $error';
  }

  @override
  String get chatClearCurrentConfirm => 'Xóa lịch sử trò chuyện hiện tại?';

  @override
  String get chatDeleteAndExitConfirm =>
      'Sau khi xóa và thoát, bạn sẽ không nhận được tin nhắn từ nhóm này nữa.';

  @override
  String get chatBlockConfirm =>
      'Sau khi thêm liên hệ này vào danh sách đen, bạn sẽ không nhận được tin nhắn của họ nữa.';

  @override
  String get chatSearchTabAll => 'Trò chuyện';

  @override
  String get chatSearchTabMedia => 'Ảnh/Video';

  @override
  String get chatSearchTabFile => 'Tệp';

  @override
  String get chatSearchNoMatches => 'Không có lịch sử trò chuyện trùng khớp';

  @override
  String get chatSearchNoMore => 'Không có thêm kết quả nào';

  @override
  String get chatDetailsTooltip => 'Chi tiết trò chuyện';

  @override
  String get chatVoiceInputTooltip => 'Nhập bằng giọng nói';

  @override
  String get chatInputHint => 'Tin nhắn...';

  @override
  String get chatFlameEnabledTooltip => 'Ghi sau khi bật đọc';

  @override
  String get chatFlameDestroyOnExit => 'Hủy sau khi rời khỏi cuộc trò chuyện';

  @override
  String chatFlameDestroyAfterMinutes(Object minutes) {
    return 'Hủy sau $minutes phút';
  }

  @override
  String chatFlameDestroyAfterSeconds(Object seconds) {
    return 'Phá hủy sau $seconds giây';
  }

  @override
  String chatFlameEnabledNotice(Object label) {
    return 'Ghi sau khi bật tính năng đọc. Tin nhắn sẽ bị hủy $label sau khi đọc. Sử dụng cài đặt trên cùng bên phải để tắt nó.';
  }

  @override
  String get chatEmojiTooltip => 'Biểu tượng cảm xúc';

  @override
  String get chatActionReply => 'Trả lời';

  @override
  String get chatActionCopy => 'Sao chép';

  @override
  String get chatActionTranslate => 'Dịch';

  @override
  String get chatActionTranscribe => 'Chép lời';

  @override
  String get chatActionForward => 'Chuyển tiếp';

  @override
  String get chatActionFavorite => 'Yêu thích';

  @override
  String get chatActionPin => 'Ghim';

  @override
  String get chatActionUnpin => 'Bỏ ghim';

  @override
  String get chatActionAddFriend => 'Thêm bạn bè';

  @override
  String get chatActionMultiSelect => 'Chọn';

  @override
  String get chatActionEdit => 'Chỉnh sửa';

  @override
  String get chatActionEditImage => 'Chỉnh sửa hình ảnh';

  @override
  String get chatActionRevoke => 'Thu hồi';

  @override
  String get chatActionDelete => 'Xóa';

  @override
  String get chatGroupCallActive => 'Cuộc gọi nhóm đang diễn ra';

  @override
  String chatMessageRevokedBy(Object name) {
    return '$name đã gọi lại một tin nhắn';
  }

  @override
  String get chatReedit => 'Chỉnh sửa lại';

  @override
  String get chatEditedSuffix => '(đã chỉnh sửa)';

  @override
  String chatActionReadBy(Object count) {
    return 'Đọc bởi $count';
  }

  @override
  String chatActionReactedBy(Object count) {
    return '$count phản ứng';
  }

  @override
  String chatSelectedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã chọn $count mục',
      one: 'Đã chọn 1 mục',
    );
    return '$_temp0';
  }

  @override
  String get chatNoReactions => 'Chưa có phản hồi nào';

  @override
  String chatReadStatusReadCount(Object count) {
    return 'Đọc ($count)';
  }

  @override
  String get chatNoReadReceipts => 'Chưa có';

  @override
  String get chatHistoryAbove => 'Tin nhắn trước đó ở trên';

  @override
  String chatUnreadNewMessages(Object count) {
    return '$count tin nhắn mới';
  }

  @override
  String get chatUnreadDivider => 'Tin nhắn mới bên dưới';

  @override
  String get chatUnknownContentFallback =>
      'Phiên bản này không thể hiển thị thông báo này. Cập nhật lên phiên bản mới nhất.';

  @override
  String get chatMentionSomeone => 'Ai đó đã nhắc đến bạn';

  @override
  String get chatToolAlbum => 'Album';

  @override
  String get chatToolCamera => 'Máy ảnh';

  @override
  String get chatToolFile => 'Tệp';

  @override
  String get chatToolLocation => 'Vị trí';

  @override
  String get chatToolContactCard => 'Thẻ liên hệ';

  @override
  String get chatToolAudioCall => 'Cuộc gọi thoại';

  @override
  String get chatToolVideoCall => 'Cuộc gọi điện video';

  @override
  String get chatDraftLabel => '[Bản nháp]';

  @override
  String get visitorBadge => 'Đã ghé thăm';

  @override
  String get chatNoticeDeleted => 'Đã xóa';

  @override
  String get chatNoticeCopied => 'Đã sao chép';

  @override
  String get chatMentionLoadedOrInvisible =>
      'Tin nhắn @ đã được tải hoặc không hiển thị. Cuộn lên để tìm thấy nó.';

  @override
  String get chatLocationDefaultTitle => 'Vị trí';

  @override
  String get chatLocationCopied => 'Đã sao chép vị trí';

  @override
  String get chatReadStatusTitle => 'Trạng thái đọc';

  @override
  String get chatReadStatusRead => 'Đọc';

  @override
  String get chatReadStatusUnread => 'Chưa đọc';

  @override
  String get chatReadStatusUnavailable =>
      'Danh sách đã đọc/chưa đọc đầy đủ chưa có sẵn';

  @override
  String get chatComposerLeft => 'Bạn đã rời khỏi cuộc trò chuyện này';

  @override
  String get chatComposerMuted => 'Cuộc trò chuyện này bị tắt tiếng';

  @override
  String chatComposerMutedUntil(Object time) {
    return 'Bạn bị tắt tiếng cho đến $time';
  }

  @override
  String chatFavoriteCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tin nhắn yêu thích',
      one: '1 tin nhắn yêu thích',
    );
    return '$_temp0';
  }

  @override
  String chatFavoritePartial(Object failed, Object success) {
    return 'Đã hoàn thành mục yêu thích: $success đã thành công, $failed không thành công';
  }

  @override
  String get chatForwardUnavailable => 'Không thể chuyển tiếp ngay bây giờ';

  @override
  String chatMergedForwardedTo(Object count, Object name) {
    return 'Đã hợp nhất $count tin nhắn thành $name';
  }

  @override
  String chatForwardedIndividuallyTo(Object count, Object name) {
    return 'Đã chuyển tiếp $count từng tin nhắn tới $name';
  }

  @override
  String chatForwardedPartialTo(Object name, Object sent, Object total) {
    return 'Đã chuyển tiếp tin nhắn $sent/$total tới $name';
  }

  @override
  String get chatForwardModeIndividual => 'Chuyển tiếp từng cái một';

  @override
  String get chatForwardModeMerge => 'Hợp nhất và chuyển tiếp';

  @override
  String get chatPresenceOnline => 'Trực tuyến';

  @override
  String get chatPresenceOffline => 'Ngoại tuyến';

  @override
  String get chatPresenceJustActive => 'Vừa mới hoạt động';

  @override
  String chatPresenceMinutesAgo(Object minutes) {
    return 'Đang hoạt động $minutes phút trước';
  }

  @override
  String chatPresenceHoursAgo(Object hours) {
    return 'Đang hoạt động $hours giờ trước';
  }

  @override
  String chatPresenceDaysAgo(Object days) {
    return 'Hoạt động $days ngày trước';
  }

  @override
  String get chatSensitiveDefaultTip =>
      'Tin nhắn này có thể chứa thông tin nhạy cảm';

  @override
  String get chatMessageDigestFallback => '[Tin nhắn]';

  @override
  String get chatMediaServiceUnavailable =>
      'Dịch vụ đa phương tiện chưa sẵn sàng';

  @override
  String get chatImDisconnected => 'IM chưa được kết nối';

  @override
  String get chatPinFailedNotSent => 'Không thể ghim trước khi thư đến máy chủ';

  @override
  String get chatPinFailed => 'Không ghim được. Hãy thử lại.';

  @override
  String get chatPinned => 'Đã ghim';

  @override
  String get chatUnpinFailed => 'Không bỏ ghim được. Hãy thử lại.';

  @override
  String get chatUnpinned => 'Đã bỏ ghim';

  @override
  String get chatClearPinnedConfirm => 'Bỏ ghim tất cả tin nhắn đã ghim?';

  @override
  String get chatClearPinnedAction => 'Bỏ ghim';

  @override
  String get chatAllUnpinned => 'Tất cả tin nhắn đã ghim đều được bỏ ghim';

  @override
  String get chatPinnedMessageNotVisible =>
      'Tin nhắn này không nằm trong phạm vi hiển thị. Xem nó từ danh sách.';

  @override
  String get chatImageMissing => 'Thiếu thông tin hình ảnh';

  @override
  String get chatImageDownloadFailedEdit =>
      'Không tải được hình ảnh xuống. Không thể chỉnh sửa.';

  @override
  String get chatReactionFailed => 'Phản hồi không thành công. Hãy thử lại.';

  @override
  String get chatEditNotSynced =>
      'Chỉnh sửa không thành công: tin nhắn chưa được đồng bộ hóa';

  @override
  String get chatEditFailed => 'Chỉnh sửa không thành công. Hãy thử lại.';

  @override
  String get chatFavoriteUnsupportedType => 'Loại này chưa thể được yêu thích';

  @override
  String get chatFavoriteNotSent =>
      'Tin nhắn chưa đến được máy chủ nên không thể yêu thích';

  @override
  String get chatFavoriteSuccess => 'Đã thêm vào mục yêu thích';

  @override
  String get chatFavoriteFailed => 'Không thể yêu thích được. Hãy thử lại.';

  @override
  String chatToolSelected(Object title) {
    return 'Đã chọn $title';
  }

  @override
  String chatCardDigest(Object name) {
    return '[Thẻ] $name';
  }

  @override
  String get chatFriendAvatarFallback => 'F';

  @override
  String get chatUnknownMessageDigest => '[Không xác định]';

  @override
  String chatOpenFromContacts(Object name) {
    return 'Mở cuộc trò chuyện của @$name từ Danh bạ';
  }

  @override
  String get chatLoadingCard => 'Đang tải thẻ liên hệ...';

  @override
  String get chatFileMissing => 'Thiếu thông tin tệp';

  @override
  String get chatVideoUnavailable => 'Không thể phát video';

  @override
  String get chatVideoSourceEmpty => 'Nguồn video trống';

  @override
  String get chatLivePhotoUnavailable => 'Không thể phát ảnh trực tiếp';

  @override
  String get messageAiTranslating => 'Đang dịch...';

  @override
  String get messageAiTranscribedShort => 'Xong';

  @override
  String get messageAiVoiceSendingWait =>
      'Giọng nói vẫn đang gửi. Hãy thử lại sau.';

  @override
  String get messageAiNoTranscript => 'Không nhận dạng được giọng nói';

  @override
  String get messageAiMessageSendingWait =>
      'Tin nhắn vẫn đang được gửi. Hãy thử lại sau.';

  @override
  String get messageAiNoTranslation => 'Không có kết quả dịch';

  @override
  String get messageAiTemporarilyUnavailable => 'Tạm thời không có';

  @override
  String get chatVoiceFileUnavailable => 'Không có tệp giọng nói';

  @override
  String get chatVoicePlayFailed => 'Phát lại không thành công. Hãy thử lại.';

  @override
  String get chatVoiceHoldToRecord => 'Giữ để ghi · Trượt lên để hủy';

  @override
  String chatVoiceReleaseToCancel(Object duration) {
    return 'Nhả để hủy ($duration)';
  }

  @override
  String chatVoiceRecordingSlideCancel(Object duration) {
    return '$duration · Trượt lên để hủy';
  }

  @override
  String get chatQrcodeNotFound => 'Không nhận dạng được mã QR';

  @override
  String chatWebLoginQrcodeDetected(Object payload) {
    return 'Web mã QR đăng nhập được nhận dạng\n$payload';
  }

  @override
  String get chatWebLoginConfirmTitle => 'Xác nhận đăng nhập trên web?';

  @override
  String get chatWebLoginConfirmAction => 'Xác nhận Web Đăng nhập';

  @override
  String get chatWebLoginConfirmed => 'Web xác nhận đăng nhập';

  @override
  String chatQrcodeDetected(Object payload) {
    return 'Mã QR được nhận dạng\n$payload';
  }

  @override
  String get chatStickerPlaceholder => '[Nhãn dán]';

  @override
  String get chatStickerAdded => 'Đã thêm vào hình dán';

  @override
  String get chatStickerAddFailed => 'Không thêm được hình dán. Hãy thử lại.';

  @override
  String get mentionAllMembers => 'Tất cả thành viên';

  @override
  String get mentionAllMembersSubtitle =>
      'Thông báo cho mọi người trong nhóm này';

  @override
  String get chatQuoteOriginalRevoked => 'Tin nhắn gốc đã bị thu hồi';

  @override
  String get chatRecognizeImageQrcode => 'Quét mã QR trong hình ảnh';

  @override
  String get chatAddToStickers => 'Thêm vào Hình dán';

  @override
  String get chatGroupInviteApprovalUrlEmpty =>
      'URL phê duyệt lời mời nhóm trống';

  @override
  String get chatGroupInviteApprovalTitle => 'Phê duyệt lời mời nhóm';

  @override
  String get chatGroupInviteApprovalBody =>
      'Hoàn tất xác nhận lời mời nhóm trên trang web.';

  @override
  String get chatGroupInviteGoConfirm => 'Xác nhận';

  @override
  String get chatGroupInviteApprovalOpenFailed =>
      'Không mở được phê duyệt lời mời nhóm. Hãy thử lại.';

  @override
  String get chatSendFailed => 'Không gửi được. Hãy thử lại.';

  @override
  String get chatCallActiveHangupFirst =>
      'Cuộc gọi đang diễn ra. Trước tiên hãy cúp máy.';

  @override
  String get chatCallActiveCannotJoinAgain =>
      'Cuộc gọi đang diễn ra. Không thể tham gia lại.';

  @override
  String get chatCallUnsupported =>
      'Cuộc gọi không được hỗ trợ trong phiên bản này';

  @override
  String get chatCallServiceUnavailable => 'Dịch vụ cuộc gọi chưa sẵn sàng';

  @override
  String get chatCallJoinFailedEnded =>
      'Không tham gia được. Cuộc gọi có thể đã kết thúc.';

  @override
  String get callWaitingAnswer => 'Đang chờ câu trả lời';

  @override
  String get callMessage => 'Tin nhắn cuộc gọi';

  @override
  String get callEnded => 'Cuộc gọi đã kết thúc';

  @override
  String get callPeerRefused => 'Ngang hàng bị từ chối';

  @override
  String get callPeerHungUp => 'Đồng nghiệp cúp máy';

  @override
  String get callPeerDeclinedVideoSwitch =>
      'Thiết bị ngang hàng đã từ chối yêu cầu chuyển đổi video';

  @override
  String get callSwitchVideoRequestTitle =>
      'Yêu cầu ngang hàng chuyển sang video';

  @override
  String get callAgree => 'Đồng ý';

  @override
  String get callReconnecting => 'Đang kết nối lại…';

  @override
  String get callWaitingPeerCamera => 'Đang chờ máy ảnh ngang hàng';

  @override
  String get callSelfFallbackName => 'Tôi';

  @override
  String get callUnknownUser => 'Người dùng không xác định';

  @override
  String callJoinedCount(int joined, int total) {
    return '$joined/$total đã tham gia';
  }

  @override
  String get callMute => 'Tắt tiếng';

  @override
  String get callSpeaker => 'Diễn giả';

  @override
  String get callSwitchToVideo => 'Video';

  @override
  String get callHangup => 'Cúp máy';

  @override
  String get callFlipCamera => 'Lật';

  @override
  String get callSwitchToVoice => 'Âm thanh';

  @override
  String get callCamera => 'Máy ảnh';

  @override
  String get callBack => 'Quay lại';

  @override
  String get callPermissionMicrophone => 'micrô';

  @override
  String get callPermissionMicrophoneCamera => 'micrô và máy ảnh';

  @override
  String callPermissionOpenSettings(String what) {
    return 'Bật quyền $what trong cài đặt hệ thống';
  }

  @override
  String callPermissionRequired(String what) {
    return 'Cuộc gọi cần có quyền $what';
  }

  @override
  String get callWaitingPeerConsent => 'Đang chờ phê duyệt ngang hàng';

  @override
  String get callSwitchRequestFailed => 'Không gửi được yêu cầu chuyển đổi';

  @override
  String get callCameraPermissionRequired => 'Cần có sự cho phép của máy ảnh';

  @override
  String get callCameraEnableFailed => 'Không bật được máy ảnh';

  @override
  String get incomingCallAccepting => 'Đang trả lời...';

  @override
  String get incomingVideoCall => 'mời bạn tham gia cuộc gọi điện video';

  @override
  String get incomingAudioCall => 'mời bạn tham gia cuộc gọi thoại';

  @override
  String incomingAcceptFailed(String error) {
    return 'Trả lời không thành công: $error';
  }

  @override
  String get incomingCallDecline => 'Từ chối';

  @override
  String get incomingCallAccept => 'Trả lời';

  @override
  String get chatGroupNoInviteCandidates => 'Không có thành viên nào để mời';

  @override
  String get chatInviteGroupMembersVideo =>
      'Mời thành viên nhóm (Cuộc gọi điện video)';

  @override
  String get chatInviteGroupMembersAudio =>
      'Mời thành viên nhóm (Cuộc gọi thoại)';

  @override
  String get chatSelfName => 'Tôi';

  @override
  String get chatPeerPlaceholder => 'Khác';

  @override
  String get chatSomeonePlaceholder => 'Ai đó';

  @override
  String chatScreenshotNotice(Object name) {
    return '$name đã chụp ảnh màn hình trong cuộc trò chuyện';
  }

  @override
  String chatDuplicateGroupMention(Object name) {
    return 'Nhiều thành viên nhóm phù hợp @$name';
  }

  @override
  String chatDuplicateContactMention(Object name) {
    return 'Nhiều địa chỉ liên hệ trùng khớp @$name';
  }

  @override
  String chatMentionNotFound(Object name) {
    return '@$name không tìm thấy';
  }

  @override
  String get chatForwardPickerTitle => 'Chuyển tiếp tới';

  @override
  String get chatRecentContactsSection => 'Liên hệ gần đây';

  @override
  String chatForwardedTo(Object name) {
    return 'Đã chuyển tiếp tới $name';
  }

  @override
  String get favoriteTitle => 'Mục yêu thích';

  @override
  String get favoriteEmptyTitle => 'Không có mục yêu thích';

  @override
  String get favoriteEmptySubtitle =>
      'Nhấn và giữ một tin nhắn trong cuộc trò chuyện và chọn Yêu thích để lưu tin nhắn đó tại đây.';

  @override
  String get favoriteDeleted => 'Đã xóa';

  @override
  String favoriteDeleteFailed(Object error) {
    return 'Xóa không thành công: $error';
  }

  @override
  String get favoriteDeleteFailedPlain => 'Xóa không thành công';

  @override
  String get favoriteUnsupportedSend => 'Loại này chưa thể gửi được';

  @override
  String favoriteSentTo(String name) {
    return 'Đã gửi tới $name';
  }

  @override
  String favoriteSendFailed(Object error) {
    return 'Gửi không thành công: $error';
  }

  @override
  String get favoriteSendFailedPlain => 'Gửi không thành công';

  @override
  String get favoriteSendToFriend => 'Gửi cho bạn bè';

  @override
  String get favoriteCopied => 'Đã sao chép';

  @override
  String get favoriteUnknownUser => 'Người dùng không xác định';

  @override
  String favoriteDateMonthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String get groupSavedTitle => 'Nhóm đã lưu';

  @override
  String get groupSaveTooltip => 'Lưu nhóm';

  @override
  String get groupSearchHint => 'Tìm kiếm nhóm';

  @override
  String get groupNoMatched => 'Không có nhóm phù hợp';

  @override
  String get groupNoSaveCandidatesToast => 'Không có nhóm nào để lưu';

  @override
  String get groupSavedToContacts => 'Đã lưu vào danh bạ';

  @override
  String groupSaveFailed(Object error) {
    return 'Không lưu được: $error';
  }

  @override
  String get groupSelectTitle => 'Chọn nhóm';

  @override
  String get groupNoSaveCandidates => 'Không có nhóm nào để lưu';

  @override
  String get groupCreateTitle => 'Bắt đầu trò chuyện nhóm';

  @override
  String get groupSearchContactsHint => 'Tìm kiếm liên hệ';

  @override
  String get groupNoMatchedContacts =>
      'Không có địa chỉ liên hệ nào trùng khớp';

  @override
  String groupMemberSummary(num count, Object subtitle) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thành viên',
      one: '1 thành viên',
    );
    return '$_temp0· $subtitle';
  }

  @override
  String get groupMuted => 'Đã tắt tiếng';

  @override
  String get groupDetailsTitle => 'Chi tiết nhóm';

  @override
  String groupMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thành viên',
      one: '1 thành viên',
    );
    return '$_temp0';
  }

  @override
  String get groupMembersSection => 'Thành viên nhóm';

  @override
  String get chatMergeForwardTitleGroup => 'Group Chat History';

  @override
  String get chatMergeForwardTitleDefault => 'Chat History';

  @override
  String chatMergeForwardTitleOne(String name) {
    return '$name\'s Chat History';
  }

  @override
  String chatMergeForwardTitleTwo(String name1, String name2) {
    return 'Chat History of $name1 and $name2';
  }

  @override
  String get groupNoMembers => 'Không có thành viên nhóm';

  @override
  String get groupInviteMembers => 'Mời thành viên';

  @override
  String get groupInviteMembersSubtitle => 'Chọn từ danh bạ';

  @override
  String get groupRemoveMembers => 'Xóa thành viên';

  @override
  String get groupRemoveMembersEmptySubtitle =>
      'Không có thành viên nào để xóa';

  @override
  String get groupRemoveMembersSubtitle => 'Chọn thành viên cần xóa';

  @override
  String get groupQrCodeTitle => 'Mã QR nhóm';

  @override
  String get groupQrCodeSubtitle => 'Quét để tham gia nhóm này';

  @override
  String get groupNameTitle => 'Tên nhóm';

  @override
  String get groupNoticeTitle => 'Thông báo của nhóm';

  @override
  String get groupNoticeUnset => 'Chưa được đặt';

  @override
  String get groupManageTitle => 'Quản lý nhóm';

  @override
  String get groupManageSubtitle => 'Quản trị viên, tắt tiếng và quyền nhóm';

  @override
  String get groupInviteConfirm => 'Xác nhận lời mời';

  @override
  String get groupBlacklistTitle => 'Danh sách đen nhóm';

  @override
  String get groupBlacklistSubtitle =>
      'Quản lý thành viên bị chặn phát biểu hoặc tham gia';

  @override
  String get groupSaveToContacts => 'Lưu vào Danh bạ';

  @override
  String get groupMuteMessages => 'Ẩn thông báo';

  @override
  String get groupExited => 'Đã rời khỏi cuộc trò chuyện nhóm';

  @override
  String get groupExitAction => 'Rời khỏi nhóm';

  @override
  String groupMembersSyncFailed(Object error) {
    return 'Không đồng bộ được thành viên nhóm: $error';
  }

  @override
  String get groupInvitePickerTitle => 'Chọn thành viên để mời';

  @override
  String groupInviteSentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã gửi $count lời mời thành viên',
      one: 'Đã gửi 1 lời mời thành viên',
    );
    return '$_temp0';
  }

  @override
  String groupInvitedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã mời $count thành viên',
      one: 'Đã mời 1 thành viên',
    );
    return '$_temp0';
  }

  @override
  String groupInviteMembersFailed(Object error) {
    return 'Không mời được thành viên: $error';
  }

  @override
  String get groupRemovePickerTitle => 'Chọn thành viên để xóa';

  @override
  String groupQuotedMemberName(Object name) {
    return '\"$name\"';
  }

  @override
  String groupSelectedMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thành viên',
      one: '1 thành viên',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersConfirm(Object target) {
    return 'Xóa $target khỏi nhóm này?';
  }

  @override
  String get groupRemoveAction => 'Xóa';

  @override
  String groupRemovedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã xóa $count thành viên',
      one: 'Đã xóa 1 thành viên',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersFailed(Object error) {
    return 'Không xóa được thành viên: $error';
  }

  @override
  String get groupSettingsUpdated => 'Đã cập nhật cài đặt nhóm';

  @override
  String groupSettingsUpdateFailed(Object error) {
    return 'Không cập nhật được cài đặt nhóm: $error';
  }

  @override
  String get groupExitConfirm =>
      'Bạn sẽ không còn nhận được tin nhắn từ nhóm này sau khi rời khỏi nhóm.';

  @override
  String get groupExitSuccess => 'Đã rời khỏi cuộc trò chuyện nhóm';

  @override
  String groupExitFailed(Object error) {
    return 'Không rời được: $error';
  }

  @override
  String get groupOwnerAdminSection => 'Chủ sở hữu và quản trị viên';

  @override
  String get groupOwnerRole => 'Chủ sở hữu';

  @override
  String get groupAdminRole => 'Quản trị viên';

  @override
  String get groupRemove => 'Xóa';

  @override
  String get groupAddAdmin => 'Thêm quản trị viên nhóm';

  @override
  String get groupNoAdmins => 'Không có quản trị viên';

  @override
  String get groupInviteConfirmRemark =>
      'Khi được bật, các thành viên cần có sự chấp thuận của chủ sở hữu hoặc quản trị viên trước khi mời bạn bè. Việc tham gia bằng mã QR cũng sẽ bị vô hiệu hóa.';

  @override
  String get groupOwnerTransfer => 'Chuyển quyền sở hữu';

  @override
  String get groupMemberSettingsSection => 'Cài đặt thành viên';

  @override
  String get groupAllMutedRemark =>
      'Khi tính năng tắt tiếng tất cả thành viên được bật, chỉ chủ sở hữu và quản trị viên mới có thể phát biểu.';

  @override
  String get groupAllMuted => 'Tắt tiếng tất cả thành viên';

  @override
  String get groupForbiddenAddFriendRemark =>
      'Khi được bật, các thành viên không thể thêm bạn bè thông qua nhóm này.';

  @override
  String get groupForbiddenAddFriend => 'Chặn thành viên thêm bạn bè';

  @override
  String get groupAllowHistoryRemark =>
      'Khi được bật, thành viên mới có thể xem lịch sử trò chuyện trước đó.';

  @override
  String get groupAllowHistory => 'Cho phép thành viên mới xem lịch sử';

  @override
  String get groupAddAdminPickerTitle => 'Thêm quản trị viên nhóm';

  @override
  String groupAdminAddedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã thêm $count quản trị viên',
      one: 'Đã thêm 1 quản trị viên',
    );
    return '$_temp0';
  }

  @override
  String groupAddAdminFailed(Object error) {
    return 'Không thêm được quản trị viên: $error';
  }

  @override
  String groupRemoveAdminConfirm(Object name) {
    return 'Xóa vai trò quản trị viên khỏi \"$name\"?';
  }

  @override
  String get groupRemoveAdminAction => 'Xóa quản trị viên';

  @override
  String get groupRemoveAdminSuccess => 'Quản trị viên đã xóa';

  @override
  String groupRemoveAdminFailed(Object error) {
    return 'Không xóa được quản trị viên: $error';
  }

  @override
  String get groupSelectNewOwner => 'Chọn chủ sở hữu mới';

  @override
  String groupTransferOwnerConfirm(Object name) {
    return 'Chuyển quyền sở hữu cho \"$name\"? Bạn sẽ trở thành thành viên thường xuyên.';
  }

  @override
  String get groupTransferOwnerAction => 'Xác nhận chuyển khoản';

  @override
  String get groupOwnerTransferred => 'Đã chuyển quyền sở hữu';

  @override
  String groupOwnerTransferFailed(Object error) {
    return 'Chuyển quyền sở hữu không thành công: $error';
  }

  @override
  String get groupNoticePublisherDefault => 'Thông báo của nhóm';

  @override
  String get groupNoticePublishTitle => 'Đăng thông báo của nhóm';

  @override
  String get groupNoticeEditTitle => 'Chỉnh sửa thông báo của nhóm';

  @override
  String get groupNoticePublishAction => 'Bài đăng';

  @override
  String get groupNoticeEmpty => 'Không có thông báo nhóm';

  @override
  String get groupNoticePublishedAtUnknown => 'Không rõ thời gian xuất bản';

  @override
  String get groupMemberRemarkTitle => 'Biệt hiệu của tôi trong nhóm này';

  @override
  String get groupMemberRemarkHint => 'Đặt biệt hiệu của bạn trong nhóm này';

  @override
  String get groupQrCodeEmpty => 'Không có mã QR nhóm';

  @override
  String groupQrCodeValid(Object day, Object expire) {
    return 'Mã QR này có hiệu lực trong $day ngày ($expire)';
  }

  @override
  String get groupQrCodeScanToJoin => 'Quét mã QR để tham gia nhóm này';

  @override
  String get groupBlacklistLoadFailed =>
      'Không tải được danh sách đen. Hãy thử lại.';

  @override
  String get groupBlacklistEmpty =>
      'Không có thành viên nào bị liệt vào danh sách đen';

  @override
  String get groupBlacklistAddMember => 'Thêm thành viên vào danh sách đen';

  @override
  String get groupBlacklistNoCandidates =>
      'Không thể thêm thành viên nào vào danh sách đen';

  @override
  String get groupSelectMember => 'Chọn thành viên';

  @override
  String get groupBlacklistAdded => 'Đã thêm vào danh sách đen';

  @override
  String get groupBlacklistAddFailed =>
      'Không thêm được vào danh sách đen. Hãy thử lại.';

  @override
  String groupBlacklistRemoveConfirm(Object name) {
    return 'Xóa \"$name\" khỏi danh sách đen của nhóm?';
  }

  @override
  String get groupBlacklistRemoveAction => 'Xóa khỏi danh sách đen';

  @override
  String get groupBlacklistRemoveFailed =>
      'Không xóa được khỏi danh sách đen. Hãy thử lại.';

  @override
  String get groupAvatarTitle => 'Hình đại diện nhóm';

  @override
  String get groupAvatarTakePhoto => 'Chụp ảnh';

  @override
  String get groupAvatarChooseFromAlbum => 'Chọn từ Album';

  @override
  String get groupAvatarSaveImage => 'Lưu hình ảnh';

  @override
  String get groupAvatarUnsupported =>
      'Cuộc trò chuyện này không hỗ trợ thay đổi hình đại diện của nhóm';

  @override
  String get groupAvatarUpdated => 'Đã cập nhật hình đại diện của nhóm';

  @override
  String get groupAvatarUpdateFailed =>
      'Không cập nhật được hình đại diện của nhóm. Hãy thử lại.';

  @override
  String get groupAvatarNoImageToSave => 'Không có hình đại diện để lưu';

  @override
  String groupPhotoPermissionRequired(Object appName) {
    return 'Cho phép $appName truy cập ảnh của bạn';
  }

  @override
  String get groupImageSavedToAlbum => 'Đã lưu vào album';

  @override
  String get groupImageSaveFailed => 'Không lưu được. Hãy thử lại.';

  @override
  String get imageEditorProcessing => 'Đang xử lý...';

  @override
  String get imageEditorDiscardTitle => 'Hủy chỉnh sửa?';

  @override
  String get imageEditorDiscardMessage => 'Các chỉnh sửa chưa lưu sẽ bị mất.';

  @override
  String get imageEditorDiscardConfirm => 'Bỏ đi';

  @override
  String get imageEditorPaint => 'Vẽ';

  @override
  String get imageEditorFreestyle => 'Tự do';

  @override
  String get imageEditorArrow => 'Mũi tên';

  @override
  String get imageEditorLine => 'Dòng';

  @override
  String get imageEditorRectangle => 'Hình chữ nhật';

  @override
  String get imageEditorCircle => 'Vòng tròn';

  @override
  String get imageEditorDashLine => 'Đường đứt nét';

  @override
  String get imageEditorMoveAndZoom => 'Di chuyển/Thu phóng';

  @override
  String get imageEditorEraser => 'Cục tẩy';

  @override
  String get imageEditorLineWidth => 'Chiều rộng';

  @override
  String get imageEditorToggleFill => 'Điền vào';

  @override
  String get imageEditorOpacity => 'Độ mờ';

  @override
  String get imageEditorUndo => 'Hoàn tác';

  @override
  String get imageEditorRedo => 'Làm lại';

  @override
  String get imageEditorInputHint => 'Nhập văn bản';

  @override
  String get imageEditorText => 'Văn bản';

  @override
  String get imageEditorTextAlign => 'Căn chỉnh';

  @override
  String get imageEditorBackground => 'Bối cảnh';

  @override
  String get imageEditorFontScale => 'Cỡ chữ';

  @override
  String get imageEditorCrop => 'Cắt';

  @override
  String get imageEditorRotate => 'Xoay';

  @override
  String get imageEditorRatio => 'Tỷ lệ';

  @override
  String get imageEditorReset => 'Đặt lại';

  @override
  String get imageEditorFlip => 'Lật';

  @override
  String get imageEditorFilter => 'Bộ lọc';

  @override
  String get imageEditorFilterNone => 'Bản gốc';

  @override
  String get imageEditorFilterAddictiveBlue => 'Màu xanh gây nghiện';

  @override
  String get imageEditorFilterAddictiveRed => 'Đỏ gây nghiện';

  @override
  String get imageEditorFilterAden => 'Aden';

  @override
  String get imageEditorFilterAmaro => 'Amaro';

  @override
  String get imageEditorFilterAshby => 'Ashby';

  @override
  String get imageEditorFilterBrannan => 'Brannan';

  @override
  String get imageEditorFilterBrooklyn => 'Brooklyn';

  @override
  String get imageEditorFilterCharmes => 'Bùa chú';

  @override
  String get imageEditorFilterClarendon => 'Clarendon';

  @override
  String get imageEditorFilterCrema => 'Kem';

  @override
  String get imageEditorFilterDogpatch => 'Bản vá chó';

  @override
  String get imageEditorFilterEarlybird => 'Earlybird';

  @override
  String get imageEditorFilterGingham => 'Kẻ sọc';

  @override
  String get imageEditorFilterGinza => 'Ginza';

  @override
  String get imageEditorFilterHefe => 'Hefe';

  @override
  String get imageEditorFilterHelena => 'Helena';

  @override
  String get imageEditorFilterHudson => 'Hudson';

  @override
  String get imageEditorFilterInkwell => 'Lọ mực';

  @override
  String get imageEditorFilterJuno => 'Juno';

  @override
  String get imageEditorFilterKelvin => 'Kelvin';

  @override
  String get imageEditorFilterLark => 'Chim sơn ca';

  @override
  String get imageEditorFilterLoFi => 'Lo-Fi';

  @override
  String get imageEditorFilterLudwig => 'Ludwig';

  @override
  String get imageEditorFilterMaven => 'Maven';

  @override
  String get imageEditorFilterMayfair => 'Mayfair';

  @override
  String get imageEditorFilterMoon => 'Mặt trăng';

  @override
  String get imageEditorFilterNashville => 'Nashville';

  @override
  String get imageEditorFilterPerpetua => 'Perpetua';

  @override
  String get imageEditorFilterReyes => 'Reyes';

  @override
  String get imageEditorFilterRise => 'Tăng lên';

  @override
  String get imageEditorFilterSierra => 'Sierra';

  @override
  String get imageEditorFilterSkyline => 'Đường chân trời';

  @override
  String get imageEditorFilterSlumber => 'Giấc ngủ';

  @override
  String get imageEditorFilterStinson => 'Stinson';

  @override
  String get imageEditorFilterSutro => 'Kinh';

  @override
  String get imageEditorFilterToaster => 'Máy nướng bánh mì';

  @override
  String get imageEditorFilterValencia => 'Valencia';

  @override
  String get imageEditorFilterVesper => 'Kinh chiều';

  @override
  String get imageEditorFilterWalden => 'Walden';

  @override
  String get imageEditorFilterWillow => 'Cây liễu';

  @override
  String get imageEditorBlur => 'Mờ';

  @override
  String get imageEditorTune => 'Điều chỉnh';

  @override
  String get imageEditorBrightness => 'Độ sáng';

  @override
  String get imageEditorContrast => 'Tương phản';

  @override
  String get imageEditorSaturation => 'Độ bão hòa';

  @override
  String get imageEditorExposure => 'Tiếp xúc';

  @override
  String get imageEditorHue => 'Huế';

  @override
  String get imageEditorTemperature => 'Nhiệt độ';

  @override
  String get imageEditorSharpness => 'Độ sắc nét';

  @override
  String get imageEditorFade => 'Phai dần';

  @override
  String get imageEditorLuminance => 'Độ chói';

  @override
  String get imageEditorEmoji => 'Biểu tượng cảm xúc';

  @override
  String get imageEditorEmojiRecent => 'Gần đây';

  @override
  String get imageEditorEmojiSmileys => 'Mặt cười';

  @override
  String get imageEditorEmojiAnimals => 'Động vật';

  @override
  String get imageEditorEmojiFood => 'Thực phẩm';

  @override
  String get imageEditorEmojiActivities => 'Hoạt động';

  @override
  String get imageEditorEmojiTravel => 'Du lịch';

  @override
  String get imageEditorEmojiObjects => 'Đối tượng';

  @override
  String get imageEditorEmojiSymbols => 'Ký hiệu';

  @override
  String get imageEditorEmojiFlags => 'Cờ';

  @override
  String get imageEditorSticker => 'Nhãn dán';

  @override
  String get imageEditorRemove => 'Xóa';

  @override
  String get imageEditorSaving => 'Đang lưu...';

  @override
  String get imageEditorImporting => 'Đang nhập';

  @override
  String get imagePreviewTitle => 'Xem trước hình ảnh';

  @override
  String get imagePreviewSavingToAlbum => 'Đang lưu...';

  @override
  String get imagePreviewAddToSticker => 'Thêm vào Hình dán';

  @override
  String get imagePreviewAddingToSticker => 'Đang thêm...';

  @override
  String get imagePreviewRecognizeQr => 'Nhận dạng mã QR';

  @override
  String get imagePreviewRecognizingQr => 'Đang nhận dạng...';

  @override
  String get imagePreviewConfirmWebLogin => 'Xác nhận Web Đăng nhập';

  @override
  String get imagePreviewConfirmingWebLogin => 'Đang xác nhận...';

  @override
  String get imagePreviewOpenLink => 'Mở liên kết';

  @override
  String get imagePreviewImageNotDownloadedSave =>
      'Hình ảnh chưa được tải xuống';

  @override
  String get imagePreviewMediaUnavailable =>
      'Dịch vụ truyền thông không khả dụng';

  @override
  String get imagePreviewImageNotUploadedSticker =>
      'Hình ảnh chưa được tải lên';

  @override
  String get imagePreviewStickerUnavailable =>
      'Dịch vụ nhãn dán không khả dụng';

  @override
  String get imagePreviewAddedToSticker => 'Đã thêm vào hình dán';

  @override
  String get imagePreviewImageNotDownloadedRecognize =>
      'Hình ảnh chưa được tải xuống';

  @override
  String get imagePreviewQrNotFound => 'Không tìm thấy mã QR';

  @override
  String get imagePreviewWebLoginQrRecognized =>
      'Web mã QR đăng nhập được nhận dạng';

  @override
  String get imagePreviewWebLinkRecognized => 'Web liên kết được nhận dạng';

  @override
  String get imagePreviewQrRecognized => 'Đã nhận dạng được mã QR';

  @override
  String get imagePreviewWebLoginConfirmed => 'Web xác nhận đăng nhập';

  @override
  String get pickerFileTitle => 'Chọn tệp';

  @override
  String get pickerRecentFiles => 'Tệp gần đây';

  @override
  String get pickerSampleProjectFile => 'Ghi chú dự án.pdf';

  @override
  String get pickerSampleProjectFileSubtitle => '128 KB · Hôm nay';

  @override
  String get pickerSampleScreenshotFile => 'Ảnh chụp màn hình trò chuyện.png';

  @override
  String get pickerSampleScreenshotFileSubtitle => '2,4 MB · Hôm qua';

  @override
  String get pickerContactTitle => 'Chọn liên hệ';

  @override
  String get pickerContactCardSection => 'Gửi thẻ liên hệ';

  @override
  String get pickerSearchContacts => 'Tìm kiếm Danh bạ';

  @override
  String get pickerNoMatchingContacts => 'Không có địa chỉ liên hệ nào phù hợp';

  @override
  String get chatSendFailedShort => 'Gửi không thành công';

  @override
  String get chatResend => 'Gửi lại';

  @override
  String get chatStatusRead => 'Đọc';

  @override
  String get pinnedMessageTitle => 'Tin nhắn được ghim';

  @override
  String pinnedMessageTitleWithIndex(int index, int total) {
    return 'Tin nhắn được ghim $index/$total';
  }

  @override
  String get pinnedMessageOpen => 'Nhấn để xem';

  @override
  String get pinnedMessageViewAllTooltip => 'Xem tất cả đã ghim';

  @override
  String get pinnedMessageUnpinTooltip => 'Bỏ ghim';

  @override
  String pinnedMessageListCount(int count) {
    return '$count Tin nhắn được ghim';
  }

  @override
  String get pinnedMessageClearAll => 'Bỏ ghim tất cả';

  @override
  String get pinnedMessageFallback => 'Tin nhắn được ghim';

  @override
  String get fileUnnamed => 'Tệp không có tiêu đề';

  @override
  String get fileNoDownloadUrl => 'Không có liên kết tải xuống';

  @override
  String get fileTitle => 'Tệp';

  @override
  String fileSizeLabel(String size) {
    return 'Kích thước tệp: $size';
  }

  @override
  String get fileDownloadFailed => 'Tải xuống không thành công';

  @override
  String get filePreview => 'Xem trước';

  @override
  String get fileOpenWithOtherApp => 'Mở trong ứng dụng khác';

  @override
  String get actionEnable => 'Bật';

  @override
  String get actionDisable => 'Tắt';

  @override
  String get profileInviteLoading => 'Đang tải mã mời';

  @override
  String get profileInviteEnabled => 'Đã bật mã mời';

  @override
  String get profileInviteDisabled => 'Mã mời bị vô hiệu hóa';

  @override
  String profileInviteLoadFailed(String error) {
    return 'Không tải được mã mời: $error';
  }

  @override
  String get profileInviteCopied => 'Đã sao chép';

  @override
  String profileInviteUpdateFailed(String error) {
    return 'Không cập nhật được mã mời: $error';
  }

  @override
  String get stickerStoreTitle => 'Cửa hàng nhãn dán';

  @override
  String get stickerNoPacks => 'Không có gói hình dán';

  @override
  String get stickerDetailTitle => 'Chi tiết nhãn dán';

  @override
  String get stickerProcessing => 'Đang xử lý...';

  @override
  String get stickerAddCustomTitle => 'Thêm nhãn dán tùy chỉnh';

  @override
  String get stickerSortTitle => 'Sắp xếp nhãn dán';

  @override
  String get stickerMyStickersTitle => 'Nhãn dán của tôi';

  @override
  String get stickerSaving => 'Đang lưu';

  @override
  String get stickerSortAction => 'Sắp xếp';

  @override
  String get stickerOrganize => 'Sắp xếp';

  @override
  String get stickerCustomTitle => 'Hình dán tùy chỉnh';

  @override
  String get stickerCustomSubtitle => 'Quản lý hình dán tùy chỉnh đã lưu';

  @override
  String get stickerNoSortablePacks => 'Không có gói hình dán nào để sắp xếp';

  @override
  String get stickerNoCategories => 'Không có danh mục hình dán';

  @override
  String get stickerMoveUp => 'Tiến lên';

  @override
  String get stickerMoveDown => 'Di chuyển xuống';

  @override
  String get stickerNoCustomStickers => 'Không có hình dán tùy chỉnh';

  @override
  String get stickerMoveToFront => 'Di chuyển lên phía trước';

  @override
  String get stickerDeleteConfirmTitle => 'Không thể khôi phục hình dán đã xóa';

  @override
  String get complaintTitle => 'Báo cáo';

  @override
  String get complaintHint => 'Mô tả sự cố';

  @override
  String get complaintType => 'Loại báo cáo';

  @override
  String get complaintSubmitted => 'Đã gửi báo cáo';

  @override
  String get complaintSubmit => 'Gửi báo cáo';

  @override
  String get complaintSubmitting => 'Đang gửi…';

  @override
  String get complaintFallbackOtherViolation => 'Vi phạm chính sách khác';

  @override
  String get complaintFallbackFraud => 'Gian lận hoặc lừa đảo khác';

  @override
  String get complaintFallbackAccountCompromised =>
      'Tài khoản có thể bị xâm phạm';

  @override
  String get chatBackgroundTitle => 'Nền trò chuyện';

  @override
  String get chatBackgroundLoading => 'Đang tải hình nền trò chuyện';

  @override
  String get chatBackgroundEmpty => 'Không có hình nền trò chuyện';

  @override
  String get chatBackgroundDefault => 'Nền mặc định';

  @override
  String chatBackgroundItem(int index) {
    return 'Nền $index';
  }

  @override
  String get chatBackgroundPreviewTitle => 'Xem trước nền';

  @override
  String get chatBackgroundSet => 'Đặt nền';

  @override
  String get chatBackgroundSelectedStatus => 'Bộ nền trò chuyện';

  @override
  String get chatBackgroundInUse => 'Đang sử dụng';

  @override
  String get chatContactFallback => 'Liên hệ';

  @override
  String get chatPersonalCard => 'Thẻ liên hệ';

  @override
  String get chatSystemMessageDigest => '[Thông báo hệ thống]';

  @override
  String get chatMessageDigestMessage => '[Tin nhắn]';

  @override
  String get chatMessageDigestImage => '[Hình ảnh]';

  @override
  String get chatMessageDigestVoice => '[Giọng nói]';

  @override
  String get chatMessageDigestVideo => '[Video]';

  @override
  String get chatMessageDigestLocation => '[Vị trí]';

  @override
  String get chatMessageDigestCard => '[Thẻ liên hệ]';

  @override
  String get chatMessageDigestFile => '[Tệp]';

  @override
  String get chatMessageDigestHistory => '[Lịch sử trò chuyện]';

  @override
  String get chatMessageDigestSticker => '[Nhãn dán]';

  @override
  String get dateWeekdayShortMonday => 'Thứ Hai';

  @override
  String get dateWeekdayShortTuesday => 'Thứ ba';

  @override
  String get dateWeekdayShortWednesday => 'Thứ Tư';

  @override
  String get dateWeekdayShortThursday => 'Thứ năm';

  @override
  String get dateWeekdayShortFriday => 'Thứ sáu';

  @override
  String get dateWeekdayShortSaturday => 'Thứ bảy';

  @override
  String get dateWeekdayShortSunday => 'Mặt trời';

  @override
  String get appIconClassic => 'Cổ điển';

  @override
  String get appIconSimple => 'Đơn giản';

  @override
  String get appIconDark => 'Tối';

  @override
  String get appIconFestive => 'Lễ hội';

  @override
  String get appIconGradient => 'Độ dốc';

  @override
  String get appIconUpdated => 'Đã cập nhật biểu tượng';

  @override
  String get appIconUpdateFailed =>
      'Chuyển đổi không thành công. Hãy thử lại sau.';

  @override
  String get appearanceBubbleColorPurple => 'Tím';

  @override
  String get appearanceBubbleColorGreen => 'Xanh';

  @override
  String get appearanceBubbleColorBlue => 'Xanh lam';

  @override
  String get appearanceBubbleColorOrange => 'Cam';

  @override
  String get appearanceBubbleColorPink => 'Hồng';

  @override
  String replyPreviewTitle(String name) {
    return 'Trả lời $name';
  }

  @override
  String get replyPreviewCancel => 'Hủy trả lời';

  @override
  String get chatPasswordTitle => 'Mật khẩu trò chuyện';

  @override
  String get chatPasswordHint => 'Nhập mật khẩu gồm 6 chữ số';

  @override
  String chatPasswordErrorRemain(int remain) {
    return 'Mật khẩu sai. Lịch sử trò chuyện sẽ bị xóa sau $remain lần thử không thành công nữa.';
  }

  @override
  String get emojiPackEmpty => 'Không có nhãn dán trong gói này';

  @override
  String get emojiRecentSection => 'Gần đây';

  @override
  String get emojiAllSection => 'Tất cả biểu tượng cảm xúc';

  @override
  String get stickerSearching => 'Đang tìm kiếm...';

  @override
  String get stickerNoSearchResults => 'Không có kết quả';

  @override
  String get stickerSearchResultsTitle => 'Kết quả:';

  @override
  String get homeChatPasswordWiped =>
      'Đã thử sai quá nhiều lần. Lịch sử trò chuyện đã bị xóa.';

  @override
  String get homeGroupNotFound => 'Không tìm thấy trò chuyện nhóm';

  @override
  String get homeConversationNoHistory => 'Không có lịch sử trò chuyện';

  @override
  String get homeConversationStartChat => 'Bắt đầu trò chuyện';

  @override
  String get homeEnterGroupChat => 'Tham gia trò chuyện nhóm';

  @override
  String get homeNewGroup => 'Trò chuyện nhóm mới';

  @override
  String homeFriendRequestAcceptFailed(String error) {
    return 'Không chấp nhận được: $error';
  }

  @override
  String get homeFriendRequestAccepted => 'Yêu cầu kết bạn được chấp nhận';

  @override
  String homeFriendRequestRefuseFailed(String error) {
    return 'Không từ chối được: $error';
  }

  @override
  String homeFriendRequestDeleteFailed(String error) {
    return 'Không xóa được: $error';
  }

  @override
  String contactPresenceOnlineWithDevice(String device) {
    return 'Trực tuyến trên $device';
  }

  @override
  String contactPresenceJustOnlineWithDevice(String device) {
    return 'Trực tuyến trên $device ngay bây giờ';
  }

  @override
  String contactPresenceMinutesOnlineWithDevice(int minutes, String device) {
    return 'Trực tuyến trên $device $minutes phút trước';
  }

  @override
  String contactPresenceLastOnline(String time) {
    return 'Trực tuyến lần cuối $time';
  }

  @override
  String get contactPresenceDeviceWeb => 'web';

  @override
  String get contactPresenceDeviceDesktop => 'máy tính để bàn';

  @override
  String get contactPresenceDeviceMobile => 'di động';

  @override
  String get botCommandsEmpty => 'Chưa có lệnh nào';
}
