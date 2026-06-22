// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get tabMessages => 'Chats';

  @override
  String get tabContacts => 'Contacts';

  @override
  String get tabDiscover => 'Discover';

  @override
  String get tabMe => 'Me';

  @override
  String get pageMessagesTitle => 'Chats';

  @override
  String get pageContactsTitle => 'Contacts';

  @override
  String get pageDiscoverTitle => 'Discover';

  @override
  String get pageMeTitle => 'Me';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionDone => 'Done';

  @override
  String get actionSave => 'Save';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionInvite => 'Invite';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionSend => 'Send';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionBack => 'Back';

  @override
  String get actionMore => 'More';

  @override
  String get actionJoin => 'Join';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionGetStarted => 'เริ่มต้นเลย';

  @override
  String get actionSaving => 'Saving...';

  @override
  String get moduleUnsupported => 'คุณลักษณะนี้ไม่มีในเวอร์ชันนี้';

  @override
  String get moduleLoading =>
      'กำลังตรวจสอบการเข้าถึงคุณลักษณะ ลองอีกครั้งในภายหลัง';

  @override
  String get moduleOfflineStale =>
      'เชื่อมต่อกับเครือข่ายเพื่อยืนยันการเข้าถึงคุณลักษณะ';

  @override
  String get onboardingMenuTitle => 'คู่มือฉบับย่อ';

  @override
  String onboardingChatTitle(Object appName) {
    return 'ยินดีต้อนรับสู่ $appName';
  }

  @override
  String get onboardingChatSubtitle =>
      'สถานที่สะอาดและสว่างเพื่อการสนทนาที่สะดวกสบายยิ่งขึ้น';

  @override
  String get onboardingFriendsTitle => 'ทำให้การติดต่อเป็นเรื่องง่าย';

  @override
  String get onboardingFriendsSubtitle =>
      'Friends, groups, and sharing are easier to find.';

  @override
  String get onboardingSecurityTitle =>
      'พูดได้อย่างอิสระ Use it with confidence.';

  @override
  String get onboardingSecuritySubtitle =>
      'Account security and privacy protection help guard your boundaries.';

  @override
  String get onboardingChatSemantic => 'ภาพประกอบการเริ่มต้นการซิงค์ข้อความ';

  @override
  String get onboardingFriendsSemantic =>
      'ภาพประกอบการเริ่มต้นใช้งานเพื่อนและกลุ่ม';

  @override
  String get onboardingSecuritySemantic =>
      'ภาพประกอบการเริ่มต้นใช้งานด้านความปลอดภัยและความเป็นส่วนตัว';

  @override
  String get settingsLanguageRow => 'Language';

  @override
  String get settingsLanguageSystem => 'ค่าเริ่มต้นของระบบ';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get profileRowFavorites => 'Favorites';

  @override
  String get profileRowSecurityPrivacy => 'ความปลอดภัยและความเป็นส่วนตัว';

  @override
  String get profileRowNotifications => 'การแจ้งเตือน';

  @override
  String get profileRowInviteCode => 'รหัสเชิญ';

  @override
  String get profileRowGeneral => 'General';

  @override
  String profileRowAbout(Object appName) {
    return 'เกี่ยวกับ $appName';
  }

  @override
  String get profileLogout => 'Log Out';

  @override
  String get profileLogoutConfirm =>
      'การออกจากระบบจะไม่ลบประวัติใดๆ คุณสามารถลงชื่อเข้าใช้อีกครั้งด้วยบัญชีนี้ได้ตลอดเวลา';

  @override
  String profileMoyuIdLabel(Object appName, Object value) {
    return '$appName รหัส: $value';
  }

  @override
  String get profileDefaultName => 'ฉัน';

  @override
  String get profileDetailTitle => 'โปรไฟล์';

  @override
  String get profileAvatar => 'อวตาร';

  @override
  String get profileNickname => 'ชื่อเล่น';

  @override
  String get profileEditNickname => 'แก้ไขชื่อเล่น';

  @override
  String profileEditFoxId(Object appName) {
    return 'แก้ไข $appName ID';
  }

  @override
  String get profileGender => 'เพศ';

  @override
  String get profileGenderMale => 'ชาย';

  @override
  String get profileGenderFemale => 'หญิง';

  @override
  String get profileGenderSelected => 'เลือกแล้ว';

  @override
  String get profileGenderUnset => 'ไม่ได้ตั้งค่า';

  @override
  String get profilePhoneUnbound => 'ไม่ได้เชื่อมโยง';

  @override
  String get profileAvatarUpdated => 'อัปเดตอวาตาร์แล้ว';

  @override
  String get profileAvatarUpdateFailed =>
      'ไม่สามารถอัปโหลดอวตารได้ ลองอีกครั้ง';

  @override
  String get generalPageTitle => 'ทั่วไป';

  @override
  String get generalFontSize => 'ขนาดตัวอักษร';

  @override
  String get generalChatBackground => 'พื้นหลังแชท';

  @override
  String get generalDarkMode => 'โหมดมืด';

  @override
  String get generalClearCache => 'ล้างแคช';

  @override
  String get generalClearMessages => 'ล้างประวัติการแชท';

  @override
  String get generalAppModules => 'คุณสมบัติ';

  @override
  String get generalErrorLogs => 'บันทึกข้อผิดพลาด';

  @override
  String get generalThirdShare => 'บุคคลที่สาม SDKs';

  @override
  String get fontSizeSmall => 'ขนาดเล็ก';

  @override
  String get fontSizeStandard => 'มาตรฐาน';

  @override
  String get fontSizeLarge => 'ใหญ่';

  @override
  String get fontSizeExtraLarge => 'ใหญ่พิเศษ';

  @override
  String get darkModeSystem => 'ค่าเริ่มต้นของระบบ';

  @override
  String get darkModeLight => 'แสง';

  @override
  String get darkModeDark => 'มืด';

  @override
  String get valueConfigure => 'กำหนดค่า';

  @override
  String get valueManage => 'จัดการ';

  @override
  String get valueClear => 'ชัดเจน';

  @override
  String get valueUpload => 'อัปโหลด';

  @override
  String get valueDownload => 'ดาวน์โหลด';

  @override
  String get valueView => 'ดู';

  @override
  String get valueEnabled => 'เปิดใช้งานแล้ว';

  @override
  String get valueDisabled => 'ปิดการใช้งาน';

  @override
  String get valueOn => 'เปิด';

  @override
  String get valueOff => 'ปิด';

  @override
  String get valueConfigured => 'ชุด';

  @override
  String get valueNotEnabled => 'ไม่ได้เปิดใช้งาน';

  @override
  String get valueSelected => 'เลือกแล้ว';

  @override
  String get valueCurrentDevice => 'อุปกรณ์นี้';

  @override
  String get valueSdkInfo => 'SDK ข้อมูล';

  @override
  String get statusProcessing => 'กำลังประมวลผล';

  @override
  String get statusLoading => 'กำลังโหลด';

  @override
  String get statusSending => 'กำลังส่ง';

  @override
  String get statusSaving => 'กำลังบันทึก';

  @override
  String get statusSaved => 'บันทึกแล้ว';

  @override
  String get statusSent => 'ส่งแล้ว';

  @override
  String get statusSubmitted => 'ส่งแล้ว';

  @override
  String get dateJustNow => 'เมื่อสักครู่นี้';

  @override
  String get dateToday => 'วันนี้';

  @override
  String get dateYesterday => 'เมื่อวาน';

  @override
  String get dateDayBeforeYesterday => 'วันก่อนเมื่อวาน';

  @override
  String dateTodayTime(Object time) {
    return 'วันนี้ $time';
  }

  @override
  String dateYesterdayTime(Object time) {
    return 'เมื่อวาน $time';
  }

  @override
  String dateDayBeforeYesterdayTime(Object time) {
    return 'สองวันที่แล้ว $time';
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
  String get weekdayMonday => 'วันจันทร์';

  @override
  String get weekdayTuesday => 'วันอังคาร';

  @override
  String get weekdayWednesday => 'วันพุธ';

  @override
  String get weekdayThursday => 'วันพฤหัสบดี';

  @override
  String get weekdayFriday => 'วันศุกร์';

  @override
  String get weekdaySaturday => 'วันเสาร์';

  @override
  String get weekdaySunday => 'วันอาทิตย์';

  @override
  String get dialogClearAllTitle => 'ล้างประวัติการแชททั้งหมดใช่ไหม';

  @override
  String get dialogClearAllBody =>
      'ประวัติการแชทและรายการสนทนาในเครื่องทั้งหมดจะถูกลบออก';

  @override
  String get authLoginSubtitle =>
      'เข้าสู่ระบบด้วยหมายเลขโทรศัพท์ของคุณและสนทนากับเพื่อน ๆ ต่อไป';

  @override
  String get authLoginIllustration => 'ภาพประกอบการเข้าสู่ระบบ';

  @override
  String get authRegisterIllustration => 'ลงทะเบียนภาพประกอบ';

  @override
  String get authSecurityIllustration => 'ภาพประกอบการยืนยัน';

  @override
  String get authResetIllustration => 'ภาพประกอบการรีเซ็ตรหัสผ่าน';

  @override
  String get authServerLabel => 'เซิร์ฟเวอร์';

  @override
  String get authServerCustomLabel => 'Custom server';

  @override
  String get authServerCustomHint => 'Enter server address';

  @override
  String get authPhoneLabel => 'หมายเลขโทรศัพท์';

  @override
  String get authPasswordLabel => 'รหัสผ่าน';

  @override
  String get authForgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get authLoginButton => 'เข้าสู่ระบบ';

  @override
  String get authLoginLoading => 'กำลังเข้าสู่ระบบ...';

  @override
  String get authRegisterButton => 'ลงทะเบียน';

  @override
  String get authLoginWithApple => 'Sign in with Apple';

  @override
  String get authLoginWithGoogle => 'Sign in with Google';

  @override
  String get authLoginWithGithub => 'Sign in with GitHub';

  @override
  String get authLoginAgreementPrefix => 'การเข้าสู่ระบบแสดงว่าคุณยอมรับ';

  @override
  String get authTermsTitle => 'ข้อกำหนดในการให้บริการ';

  @override
  String get authAgreementConnector => 'และ';

  @override
  String get authPrivacyTitle => 'นโยบายความเป็นส่วนตัว';

  @override
  String get authVerifyTitle => 'เข้าสู่ระบบการยืนยัน';

  @override
  String authVerifySubtitleWithPhone(Object phone) {
    return 'ใส่รหัสที่ส่งไปที่ $phone';
  }

  @override
  String get authVerifySubtitlePasswordFirst =>
      'เข้าสู่ระบบด้วยรหัสผ่านของคุณก่อนเพื่อเริ่มการตรวจสอบความปลอดภัย';

  @override
  String get authVerifyButton => 'ยืนยัน';

  @override
  String get authVerifyLoading => 'กำลังยืนยัน...';

  @override
  String get authResendCode => 'ไม่ได้รับรหัสใช่ไหม ส่งอีกครั้ง';

  @override
  String get authVerificationCodeSent => 'ส่งรหัสยืนยันแล้ว';

  @override
  String get authVerificationCodeRequired => 'ป้อนรหัสยืนยัน';

  @override
  String get authVerificationCodeSixDigits => 'ใส่รหัส 6 หลัก';

  @override
  String get authPasswordResetTitle => 'รีเซ็ตรหัสผ่านเข้าสู่ระบบ';

  @override
  String get authPasswordResetSubtitle =>
      'ยืนยันหมายเลขโทรศัพท์ของคุณ จากนั้นตั้งรหัสผ่านเข้าสู่ระบบใหม่';

  @override
  String get authPasswordResetButton => 'รีเซ็ตรหัสผ่าน';

  @override
  String get authKickedTitle => 'บัญชีของคุณเข้าสู่ระบบบนอุปกรณ์อื่น';

  @override
  String get authSubmitting => 'กำลังส่ง...';

  @override
  String get authVerificationCodeLabel => 'รหัสยืนยัน';

  @override
  String get authGetVerificationCode => 'รับโค้ด';

  @override
  String get authNewPasswordLabel => 'รหัสผ่านใหม่';

  @override
  String get authPasswordResetSuccess => 'รีเซ็ตรหัสผ่าน';

  @override
  String authRegisterTitle(Object appName) {
    return 'สร้างบัญชี $appName';
  }

  @override
  String get authRegisterSubtitle =>
      'ลงทะเบียนด้วยหมายเลขโทรศัพท์ของคุณและเริ่มแชทได้ทันที';

  @override
  String get authCreateAccount => 'สร้างบัญชี';

  @override
  String get authNicknameLabel => 'ชื่อเล่น';

  @override
  String get authInviteCodeRequiredLabel => 'รหัสเชิญ (จำเป็น)';

  @override
  String authCodeRetryAfter(Object seconds) {
    return 'ลองอีกครั้งใน ${seconds}s';
  }

  @override
  String get authRegisterAgreement =>
      'ฉันได้อ่านและยอมรับข้อกำหนดในการให้บริการและนโยบายความเป็นส่วนตัวแล้ว';

  @override
  String get authInvalidPhone => 'หมายเลขโทรศัพท์ไม่ถูกต้อง';

  @override
  String get authAcceptAgreementFirst =>
      'โปรดยอมรับข้อกำหนดในการให้บริการและนโยบายความเป็นส่วนตัวก่อน';

  @override
  String get authCodeEmpty => 'ต้องมีรหัสยืนยัน';

  @override
  String get authPasswordLengthInvalid => 'รหัสผ่านต้องมีความยาว 6-16 ตัวอักษร';

  @override
  String get authInviteCodeEmpty => 'ต้องมีรหัสเชิญ';

  @override
  String get authRegisterSuccess => 'ลงทะเบียนเรียบร้อยแล้ว';

  @override
  String get settingsCheckNewVersion => 'ตรวจสอบการอัปเดต';

  @override
  String get settingsChecking => 'กำลังตรวจสอบ';

  @override
  String get settingsVersionFound => 'มีการอัปเดตแล้ว';

  @override
  String get settingsUserAgreement => 'ข้อกำหนดในการให้บริการ';

  @override
  String get settingsPrivacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get settingsView => 'ดู';

  @override
  String get settingsSwitchAccount => 'สลับบัญชี';

  @override
  String get settingsCacheCleared => 'ล้างแคชแล้ว';

  @override
  String get settingsClearCacheSheetTitle =>
      'ล้างแคชรูปภาพ/วิดีโอ?\nภาพแชท หน้าปกวิดีโอ และอวาตาร์จะถูกดาวน์โหลดอีกครั้ง';

  @override
  String get settingsClearCacheAction => 'ล้างแคช';

  @override
  String get settingsMessagesCleared => 'Chat history cleared';

  @override
  String settingsClearMessagesFailed(Object error) {
    return 'ไม่สามารถล้างประวัติการแชท: $error';
  }

  @override
  String get settingsAlreadyLatestVersion => 'คุณใช้เวอร์ชันล่าสุดแล้ว';

  @override
  String get settingsCheckFailed => 'การตรวจสอบล้มเหลว';

  @override
  String settingsUpdateDialogTitle(Object version) {
    return 'มีการอัปเดต\nเวอร์ชันล่าสุด: $version';
  }

  @override
  String settingsUpdateDialogTitleWithDescription(
    Object description,
    Object version,
  ) {
    return 'มีการอัปเดต\nเวอร์ชันล่าสุด: $version\n$description';
  }

  @override
  String get settingsLater => 'ต่อมา';

  @override
  String get settingsUpdateNow => 'อัปเดตทันที';

  @override
  String get settingsSaveFailedRetry => 'ไม่สามารถบันทึกได้ ลองอีกครั้ง';

  @override
  String get securityAllowPhoneSearch =>
      'อนุญาตให้ผู้อื่นค้นหาฉันด้วยหมายเลขโทรศัพท์';

  @override
  String securityAllowFoxIdSearch(Object appName) {
    return 'อนุญาตให้ผู้อื่นค้นหาฉันทาง $appName ID';
  }

  @override
  String get securitySearchRemark =>
      'When off, other users cannot find you through the information above.';

  @override
  String get securityJoinGroupNeedConfirm =>
      'Require confirmation to join groups';

  @override
  String get securityJoinGroupNeedConfirmRemark =>
      'When on, invitations to add you to a group must be confirmed by you first.';

  @override
  String get securityLoginPassword => 'รหัสผ่านเข้าสู่ระบบ';

  @override
  String get securityChatPassword => 'รหัสผ่านแชท';

  @override
  String get securityScreenProtection => 'อุปกรณ์ป้องกันหน้าจอ';

  @override
  String get securityLockPassword => 'ล็อครหัสผ่าน';

  @override
  String get securityOfflineProtection => 'ล็อคหน้าจอออฟไลน์';

  @override
  String get securityDeviceManagement => 'การจัดการอุปกรณ์เข้าสู่ระบบ';

  @override
  String get securityDeviceRemark =>
      'ดูและจัดการอุปกรณ์ เปิดใช้งานการป้องกันการเข้าสู่ระบบ และรักษาบัญชีของคุณให้ปลอดภัย';

  @override
  String get securityBlacklist => 'บัญชีดำ';

  @override
  String get securityAccountDeletion => 'ลบบัญชี';

  @override
  String get accountDeletionBody =>
      'การลบบัญชีไม่สามารถยกเลิกได้ หลังจากการยืนยัน รหัสยืนยันจะถูกส่งทาง SMS เพื่อทำการลบให้เสร็จสิ้น';

  @override
  String get accountDeletionSubmitted => 'ส่งคำขอลบแล้ว';

  @override
  String get accountDeletionGetCode => 'รับโค้ด';

  @override
  String get passwordResetInstruction =>
      'การเปลี่ยนรหัสผ่านเข้าสู่ระบบต้องใช้รหัส SMS รหัสผ่านใหม่ต้องมีอย่างน้อย 6 ตัวอักษร';

  @override
  String get accountPhoneLabel => 'หมายเลขโทรศัพท์';

  @override
  String get passwordRuleLabel => 'กฎรหัสผ่าน';

  @override
  String get passwordAtLeastSix => 'อย่างน้อย 6 ตัวอักษร';

  @override
  String get passwordConfirmLabel => 'ยืนยันรหัสผ่าน';

  @override
  String get passwordConfirmHint => 'ป้อนรหัสผ่านเข้าสู่ระบบอีกครั้ง';

  @override
  String get passwordChanged => 'เปลี่ยนรหัสผ่านเข้าสู่ระบบแล้ว';

  @override
  String get phoneRequired => 'ต้องระบุหมายเลขโทรศัพท์';

  @override
  String get passwordMismatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get chatPasswordInstruction =>
      'เมื่อเปิดใช้งาน ต้องใช้รหัสผ่าน 6 หลักนี้ก่อนเปิดแชทที่ได้รับการป้องกัน';

  @override
  String get currentStatusLabel => 'สถานะปัจจุบัน';

  @override
  String get passwordSixDigits => '6 หลัก';

  @override
  String get chatPasswordEnableAction => 'เปิดใช้งานรหัสผ่านการแชท';

  @override
  String get loginPasswordRequired => 'ต้องมีรหัสผ่านเข้าสู่ระบบ';

  @override
  String get chatPasswordSixDigitsRequired =>
      'รหัสผ่านแชทต้องเป็นตัวเลข 6 หลัก';

  @override
  String get lockSetTitle => 'ตั้งรหัสผ่านล็อค 6 หลัก';

  @override
  String lockSetSubtitle(Object appName) {
    return 'จำเป็นเพื่อปลดล็อค $appName';
  }

  @override
  String get lockCurrentPromptTitle => 'ป้อนรหัสผ่านล็อคปัจจุบัน';

  @override
  String get lockCurrentPromptSubtitle => 'ตรวจสอบก่อนที่จะเปลี่ยนหรือปิด';

  @override
  String get lockAutoLock => 'ล็อคอัตโนมัติ';

  @override
  String get lockChangePassword => 'เปลี่ยนรหัสผ่านปลดล็อค';

  @override
  String get lockClosePassword => 'ปิดการปลดล็อกรหัสผ่าน';

  @override
  String get lockWrongPassword => 'รหัสผ่านผิด ลองอีกครั้ง';

  @override
  String get lockSixDigitsRequired => 'รหัสผ่านล็อคต้องเป็นตัวเลข 6 หลัก';

  @override
  String get lockInputTitle => 'ป้อนรหัสผ่านล็อค';

  @override
  String lockInputSubtitle(Object appName) {
    return 'ปลดล็อกเพื่อใช้ $appName ต่อไป';
  }

  @override
  String get lockSetFailed => 'ไม่สามารถตั้งค่าได้ ลองอีกครั้ง';

  @override
  String get lockImmediately => 'ทันที';

  @override
  String get lockAfter5Minutes => 'หลังจากผ่านไป 5 นาที';

  @override
  String get lockAfter30Minutes => 'หลังจากผ่านไป 30 นาที';

  @override
  String get lockAfter1Hour => 'หลังจากผ่านไป 1 ชั่วโมง';

  @override
  String get deviceLoginProtection => 'การป้องกันการเข้าสู่ระบบ';

  @override
  String get deviceProtectionRemark =>
      'เมื่อเปิดใช้งานการป้องกันการเข้าสู่ระบบ ต้องมีการตรวจสอบความปลอดภัยบนอุปกรณ์ที่ไม่คุ้นเคย แนะนำเพื่อความปลอดภัยของบัญชี';

  @override
  String get deviceNone => 'ไม่มีอุปกรณ์ที่เข้าสู่ระบบ';

  @override
  String get deviceDebugName => 'อุปกรณ์ปัจจุบัน';

  @override
  String get deviceDebugPlatform => 'อุปกรณ์ดีบัก iPhone / Android';

  @override
  String get deviceProtectionEnabled =>
      'เปิดใช้งานการป้องกันการเข้าสู่ระบบแล้ว';

  @override
  String get deviceProtectionDisabled => 'การป้องกันการเข้าสู่ระบบถูกปิดใช้งาน';

  @override
  String get deviceProtectionUpdateFailed =>
      'ไม่สามารถอัปเดตการป้องกันการเข้าสู่ระบบ ลองอีกครั้ง';

  @override
  String get blacklistEmpty => 'ไม่มีผู้ติดต่อที่อยู่ในบัญชีดำ';

  @override
  String get switchAccountRecent => 'บัญชีล่าสุด';

  @override
  String get switchAccountLoading => 'กำลังอ่านบัญชีล่าสุด';

  @override
  String get switchAccountAddOther => 'เพิ่มหรือเข้าสู่ระบบบัญชีอื่น';

  @override
  String get switchAccountCurrent => 'ปัจจุบัน';

  @override
  String get appModulesLoading => 'กำลังโหลดโมดูลคุณลักษณะ';

  @override
  String get appModulesEmpty => 'ไม่มีโมดูลคุณลักษณะ';

  @override
  String get appModulesUnavailable => 'โมดูลไม่พร้อมใช้งาน';

  @override
  String get errorLogsLoading => 'กำลังอ่านบันทึกข้อผิดพลาด';

  @override
  String get errorLogsEmpty => 'ไม่มีบันทึกข้อผิดพลาด';

  @override
  String get errorLogFileName => 'ชื่อไฟล์';

  @override
  String get errorLogFileSize => 'ขนาดไฟล์';

  @override
  String get errorLogGeneratedAt => 'สร้างเมื่อ';

  @override
  String get errorLogFilePath => 'เส้นทางของไฟล์';

  @override
  String get notificationReceiveNew => 'รับการแจ้งเตือนข้อความใหม่';

  @override
  String get notificationSound => 'เสียง';

  @override
  String get notificationVibration => 'การสั่นสะเทือน';

  @override
  String get notificationShowDetails => 'แสดงรายละเอียดการแจ้งเตือน';

  @override
  String get notificationSystem => 'การแจ้งเตือนข้อความของระบบ';

  @override
  String get notificationCalls => 'การแจ้งเตือนการโทรด้วยเสียง/วิดีโอ';

  @override
  String get settingsGoToSystem => 'การตั้งค่า';

  @override
  String aboutAppIconSemantic(Object appName) {
    return '$appName ไอคอน';
  }

  @override
  String aboutCopyright(Object appName) {
    return 'ลิขสิทธิ์ © 2026\n$appName. สงวนลิขสิทธิ์.';
  }

  @override
  String get policyWebUrl => 'Web URL';

  @override
  String get appearanceTitle => 'ลักษณะภายนอก';

  @override
  String get appearanceAppIcon => 'ไอคอนแอป';

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
  String get appearanceChatColor => 'สีแชท';

  @override
  String get appearanceBubbleRadius => 'รัศมีมุมฟอง';

  @override
  String get appearanceBubbleColorInk => 'หมึกดำ';

  @override
  String get appearanceSquare => 'สี่เหลี่ยมจัตุรัส';

  @override
  String get appearanceRound => 'รอบ';

  @override
  String get appearancePreviewOne => 'เขาอยากให้ฉันเลี้ยวขวาหรือซ้าย? 🤔';

  @override
  String get appearancePreviewTwo => 'ถูกต้อง และทำให้มันแข็งแกร่ง';

  @override
  String get appearancePreviewThree =>
      'แค่นี้เหรอ? ฉันรู้สึกว่าเขาพูดมากกว่านั้น 😯';

  @override
  String get appearancePreviewFour =>
      'แค่นั้นแหละ. ฉันจะส่งข้อความเสียงพร้อมรายละเอียดเพิ่มเติมในภายหลัง';

  @override
  String get contactsEmptyTitle => 'ยังไม่มีการติดต่อ';

  @override
  String get contactsEmptySubtitle =>
      'เพิ่มเพื่อนจากด้านบนขวาหรือสแกนการ์ดโปรไฟล์';

  @override
  String contactsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ผู้ติดต่อ',
      one: '1 ผู้ติดต่อ',
    );
    return '$_temp0';
  }

  @override
  String get contactAddTooltip => 'เพิ่มเพื่อน';

  @override
  String get contactSearchHint => 'ค้นหาผู้ติดต่อและกลุ่ม';

  @override
  String get contactSetRemark => 'ตั้งหมายเหตุ';

  @override
  String get contactAddToBlacklist => 'เพิ่มไปยังบัญชีดำ';

  @override
  String get contactDeleteFriend => 'ลบเพื่อน';

  @override
  String get contactAddedToBlacklist => 'เพิ่มไปยังบัญชีดำแล้ว';

  @override
  String get operationFailed => 'การดำเนินการล้มเหลว ลองอีกครั้ง';

  @override
  String operationFailedWithError(String error) {
    return 'การดำเนินการล้มเหลว: $error';
  }

  @override
  String contactDeleteFriendConfirm(Object name) {
    return 'ลบเพื่อน \"$name\"?\nประวัติการแชทจะถูกล้างด้วย';
  }

  @override
  String get contactConfirmDelete => 'ยืนยันการลบ';

  @override
  String get contactDeleted => 'ลบเพื่อนแล้ว';

  @override
  String get contactUnknownUser => 'ผู้ใช้ที่ไม่รู้จัก';

  @override
  String get contactActionNewFriends => 'เพื่อนใหม่';

  @override
  String get contactActionSavedGroups => 'กลุ่มที่บันทึกไว้';

  @override
  String get contactSearchNoMatches => 'ไม่มีผู้ติดต่อที่ตรงกัน';

  @override
  String get addFriendTitle => 'เพิ่มเพื่อน';

  @override
  String addFriendSearchHint(Object appName) {
    return 'โทรศัพท์ / $appName ID';
  }

  @override
  String get addFriendNotFound => 'ไม่พบบัญชี';

  @override
  String get myQrCodeTitle => 'รหัส QR ของฉัน';

  @override
  String myQrCodeSubtitle(Object appName) {
    return 'สแกนโค้ด QR นี้เพื่อเพิ่มฉันใน $appName';
  }

  @override
  String get myQrCodeEmpty => 'ไม่มีโค้ด QR';

  @override
  String get scanTitle => 'สแกน';

  @override
  String get scanQrNotFound => 'ไม่รู้จักรหัส QR';

  @override
  String scanResolveFailed(String error) {
    return 'ไม่สามารถแยกวิเคราะห์โค้ด QR: $error';
  }

  @override
  String get scanUnrecognized => 'รหัส QR นี้ไม่รู้จัก';

  @override
  String get scanInfoIncomplete => 'ข้อมูลรหัส QR ไม่สมบูรณ์';

  @override
  String get scanSocialUnavailable => 'การบริการสังคมไม่ได้เริ่มต้น';

  @override
  String get scanJoinedGroup => 'เข้าร่วมแชทกลุ่ม';

  @override
  String get scanCannotOpenGroup => 'หน้านี้ไม่สามารถเปิดแชทกลุ่มได้';

  @override
  String get scanGroupNotFound => 'ไม่พบแชทกลุ่ม';

  @override
  String get scanOpenGroupFailed => 'ไม่สามารถเปิดการแชทเป็นกลุ่ม';

  @override
  String get scanSelfQr => 'นี่คือโค้ด QR ของคุณเอง';

  @override
  String get scanUserNotFound => 'ไม่พบผู้ใช้';

  @override
  String get scanCameraPermissionRequired => 'ต้องได้รับอนุญาตจากกล้อง';

  @override
  String get scanOpenSettings => 'เปิดการตั้งค่า';

  @override
  String get scanCameraUnavailable => 'กล้องใช้งานไม่ได้';

  @override
  String get scanAlbum => 'อัลบั้ม';

  @override
  String get scanLightOn => 'เปิดไฟ';

  @override
  String get scanLightOff => 'ไฟดับ';

  @override
  String get scanQrCode => 'รหัส QR';

  @override
  String get scanGroupFallback => 'แชทเป็นกลุ่ม';

  @override
  String get scanGroupLoadingInfo => 'กำลังโหลดข้อมูลกลุ่ม';

  @override
  String scanGroupMemberCount(int count) {
    return '$count สมาชิก';
  }

  @override
  String get scanJoinGroupConfirm => 'เข้าร่วมแชทกลุ่ม';

  @override
  String get scanJoining => 'กำลังเข้าร่วม';

  @override
  String get scanJoinGroup => 'เข้าร่วมแชทกลุ่ม';

  @override
  String scanJoinFailed(String error) {
    return 'ไม่สามารถเข้าร่วม: $error';
  }

  @override
  String get tagsTitle => 'แท็ก';

  @override
  String get tagsCreateTooltip => 'แท็กใหม่';

  @override
  String get tagsContactSection => 'แท็กติดต่อ';

  @override
  String get tagsEmptyTitle => 'ไม่มีแท็ก';

  @override
  String get tagsEmptySubtitle =>
      'แตะ + ที่ด้านบนขวาเพื่อจัดกลุ่มผู้ติดต่อหรือแชท';

  @override
  String tagsCreateFailed(Object error) {
    return 'ไม่สามารถสร้างแท็ก: $error';
  }

  @override
  String tagsUpdateFailed(Object error) {
    return 'ไม่สามารถอัปเดตแท็ก: $error';
  }

  @override
  String tagsDeleteFailed(Object error) {
    return 'ไม่สามารถลบแท็ก: $error';
  }

  @override
  String tagsLoadFailed(Object error) {
    return 'ไม่สามารถโหลดแท็ก: $error';
  }

  @override
  String tagsDeleteConfirm(String name) {
    return 'ลบแท็ก \"$name\"?\nผู้ติดต่อและกลุ่มในแท็กนี้จะไม่ถูกลบ';
  }

  @override
  String get tagsEditTitle => 'แก้ไขแท็ก';

  @override
  String get tagsCreateTitle => 'แท็กใหม่';

  @override
  String get tagsNameSection => 'ชื่อแท็ก';

  @override
  String get tagsNameHint => 'ครอบครัว เพื่อน';

  @override
  String tagsMembersSection(int count) {
    return 'แท็กสมาชิก ($count)';
  }

  @override
  String get tagsAddMember => 'เพิ่มสมาชิก';

  @override
  String get tagsDelete => 'ลบแท็ก';

  @override
  String get tagsGroupInitial => 'ก';

  @override
  String get tagsUnknownUser => 'ผู้ใช้ที่ไม่รู้จัก';

  @override
  String get tagsSelectMembersTitle => 'เลือกสมาชิก';

  @override
  String tagsDoneCount(int count) {
    return 'เสร็จแล้ว ($count)';
  }

  @override
  String get tagsSearchHint => 'ค้นหาผู้ติดต่อหรือกลุ่ม';

  @override
  String get tagsGroupsSection => 'แชทกลุ่ม';

  @override
  String get tagsContactsSection => 'ที่อยู่ติดต่อ';

  @override
  String get tagsNoMatchesTitle => 'ไม่มีการแข่งขัน';

  @override
  String get tagsNoMatchesSubtitle => 'ลองใช้คำหลักอื่น';

  @override
  String tagsRowTitle(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get phoneContactsTitle => 'รายชื่อติดต่อทางโทรศัพท์';

  @override
  String get phoneContactsSection => 'เพิ่มจากรายชื่อติดต่อในโทรศัพท์';

  @override
  String get phoneContactsEmpty => 'ไม่มีการติดต่อทางโทรศัพท์';

  @override
  String get phoneContactsNoAddable =>
      'ไม่มีรายชื่อติดต่อทางโทรศัพท์ที่จะเพิ่ม';

  @override
  String get phoneContactsServerSyncFailed =>
      'การซิงค์เซิร์ฟเวอร์ล้มเหลว กำลังแสดงผู้ติดต่อที่มีอยู่';

  @override
  String get friendAlreadyAdded => 'เพิ่มแล้ว';

  @override
  String get friendRequestSent => 'ส่งคำขอเป็นเพื่อนแล้ว';

  @override
  String phoneContactsInviteSmsBody(Object appName) {
    return 'ฉันใช้ $appName ประสบการณ์การแชทค่อนข้างดี มาลองกันด้วย';
  }

  @override
  String get phoneContactsInviteOpened => 'เปิดคำเชิญทาง SMS แล้ว';

  @override
  String get phoneContactsInviteFailed => 'ไม่สามารถเปิด SMS โปรดเชิญด้วยตนเอง';

  @override
  String get friendRequestsEmptyTitle => 'ไม่มีเพื่อนใหม่';

  @override
  String get friendRequestsEmptySubtitle => 'เชิญเพื่อนมาสแกนโค้ด QR ของคุณ';

  @override
  String get friendRequestsPendingSection => 'รอดำเนินการ';

  @override
  String get friendRequestRefused => 'ถูกปฏิเสธ';

  @override
  String contactOpenFromContacts(Object name) {
    return 'เปิดแชทของ @$name จากรายชื่อติดต่อ';
  }

  @override
  String get fileHelperIntro =>
      'ลงชื่อเข้าใช้เวอร์ชันเว็บและส่งข้อความถึงฉันเพื่อถ่ายโอนข้อความ รูปภาพ เสียง วิดีโอ และไฟล์ระหว่างโทรศัพท์และคอมพิวเตอร์';

  @override
  String get fileHelperName => 'File Transfer';

  @override
  String get systemAccountName => 'System';

  @override
  String systemAccountIntro(Object appName) {
    return 'บัญชีอย่างเป็นทางการ $appName สำหรับการส่งการแจ้งเตือน';
  }

  @override
  String get contactIntroTitle => 'บทนำ';

  @override
  String get contactSource => 'ที่มา';

  @override
  String get contactRemoveFriendRelation => 'ลบเพื่อน';

  @override
  String get contactRemoveFromBlacklist => 'ลบออกจากบัญชีดำ';

  @override
  String get contactSendMessage => 'ข้อความ';

  @override
  String get contactAddToContacts => 'เพิ่มในรายชื่อติดต่อ';

  @override
  String get contactRemoveFriendConfirm => 'ลบเพื่อนคนนี้ใช่ไหม';

  @override
  String contactNicknameLine(Object name) {
    return 'ชื่อเล่น: $name';
  }

  @override
  String get contactRemoveFromBlacklistConfirm =>
      'ลบผู้ติดต่อนี้ออกจากบัญชีดำหรือไม่';

  @override
  String get webLoginTitle => 'Web เข้าสู่ระบบ';

  @override
  String get webLoginConfirmTitle => 'ยืนยันการเข้าสู่ระบบเว็บใช่ไหม';

  @override
  String get webLoginConfirmBody =>
      'ซึ่งจะทำให้บัญชีของคุณสามารถเข้าสู่เบราว์เซอร์หรือไคลเอ็นต์เดสก์ท็อปปัจจุบันได้ หากไม่ใช่คุณ ให้แตะยกเลิก';

  @override
  String get webLoginConfirmAction => 'ยืนยันการเข้าสู่ระบบ';

  @override
  String get webLoginConfirming => 'กำลังยืนยัน...';

  @override
  String get webLoginConfirmed => 'Web ยืนยันการเข้าสู่ระบบแล้ว';

  @override
  String webLoginConfirmFailed(Object error) {
    return 'การยืนยันล้มเหลว: $error';
  }

  @override
  String get applyFriendTitle => 'คำขอเป็นเพื่อน';

  @override
  String get applyFriendSectionTitle => 'ส่งคำขอเป็นเพื่อน';

  @override
  String get applyFriendRemarkHint => 'สวัสดี ฉัน...';

  @override
  String friendRequestSendFailed(Object error) {
    return 'ไม่สามารถส่ง: $error';
  }

  @override
  String get contactRemarkHint => 'หมายเหตุ';

  @override
  String get momentPermissionsTitle => 'ความเป็นส่วนตัวของช่วงเวลา';

  @override
  String get momentHideMineFromContact => 'ซ่อนช่วงเวลาของฉันจากพวกเขา';

  @override
  String get momentHideContactFromMe => 'ซ่อนช่วงเวลาของพวกเขาจากฉัน';

  @override
  String get momentTitle => 'ช่วงเวลา';

  @override
  String get momentPersonalEmpty => 'ยังไม่มีการโพสต์';

  @override
  String get momentEmpty => 'ยังไม่มีช่วงเวลาใดๆ';

  @override
  String get momentCoverUploadFailed => 'ไม่สามารถอัปโหลดหน้าปกได้';

  @override
  String momentCoverUploadFailedWithError(Object error) {
    return 'ไม่สามารถอัปโหลดหน้าปก: $error';
  }

  @override
  String get momentDeleteConfirm => 'ลบช่วงเวลานี้ใช่ไหม';

  @override
  String get momentJustNow => 'เมื่อกี้';

  @override
  String get momentPublishing => 'Posting…';

  @override
  String get momentPublishFailed => 'Failed to post. Tap to dismiss.';

  @override
  String get momentRemindedYou => 'เตือนให้คุณดูช่วงเวลานี้';

  @override
  String momentRemindedNames(Object names) {
    return 'เตือนแล้ว $names';
  }

  @override
  String get momentKeepEditingConfirm => 'เก็บการแก้ไขนี้ไว้ไหม';

  @override
  String get momentContinueEditing => 'แก้ไขต่อไป';

  @override
  String get momentSaveDraft => 'บันทึกฉบับร่าง';

  @override
  String get momentDiscardDraft => 'ยกเลิก';

  @override
  String get momentPublishTitle => 'โพสต์';

  @override
  String get momentPublishHint => 'คุณคิดอะไรอยู่...';

  @override
  String get momentLocationTitle => 'ที่ตั้ง';

  @override
  String get momentRemindWho => 'เตือนความจำ';

  @override
  String get locationUnsupported => 'ตำแหน่งไม่พร้อมใช้งานในเวอร์ชันนี้';

  @override
  String momentPrivacyContactCount(Object count, Object label) {
    return '$label · $count';
  }

  @override
  String get momentSelectVisibleContacts => 'เลือกผู้ติดต่อที่มองเห็นได้';

  @override
  String get momentSelectHiddenContacts => 'เลือกผู้ติดต่อที่ซ่อนอยู่';

  @override
  String get momentPrivacyPublic => 'Public';

  @override
  String get momentPrivacyPrivate => 'ส่วนตัว';

  @override
  String get momentPrivacyInternal => 'ปรากฏแก่บางคน';

  @override
  String get momentPrivacyProhibit => 'ซ่อนจาก';

  @override
  String get momentPrivacyWhoCanSee => 'ใครสามารถดูได้บ้าง';

  @override
  String momentCommentFailed(Object error) {
    return 'ความคิดเห็นล้มเหลว: $error';
  }

  @override
  String get momentDetailTitle => 'รายละเอียด';

  @override
  String get momentDeleted => 'ช่วงเวลานี้ถูกลบแล้ว';

  @override
  String get momentCollapse => 'ยุบ';

  @override
  String get momentFullText => 'ข้อความเต็ม';

  @override
  String get momentDeleteCommentConfirm => 'ลบความคิดเห็นนี้ใช่ไหม';

  @override
  String get momentCommentPlaceholder => 'ความคิดเห็น';

  @override
  String momentReplyPlaceholder(Object name) {
    return 'ตอบ $name';
  }

  @override
  String get momentLikeAction => 'ชอบ';

  @override
  String get momentCommentAction => 'ความคิดเห็น';

  @override
  String momentNewMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ข้อความใหม่',
      one: '1 ข้อความใหม่',
    );
    return '$_temp0';
  }

  @override
  String get messagesTitle => 'ข้อความ';

  @override
  String get messagesEmpty => 'ไม่มีข้อความ';

  @override
  String get messagesEmptyTitle => 'ยังไม่มีข้อความ';

  @override
  String get messagesEmptySubtitle => 'เริ่มแชทใหม่จากมุมขวาบน';

  @override
  String get messagesNewConversation => 'ใหม่';

  @override
  String get messagesStartGroupChat => 'เริ่มแชทเป็นกลุ่ม';

  @override
  String get messagesImDisconnected => 'IM ไม่ได้เชื่อมต่อ';

  @override
  String get messagesPinned => 'ปักหมุดแล้ว';

  @override
  String get messagesUnpinned => 'เลิกปักหมุดแล้ว';

  @override
  String get messagesMuted => 'ปิดเสียง';

  @override
  String get messagesNotificationsOn => 'เปิดการแจ้งเตือน';

  @override
  String messagesDeleteConversationTitle(String name) {
    return 'ลบ \"$name\" หรือไม่';
  }

  @override
  String get messagesConfirmDelete => 'ลบ';

  @override
  String get messagesCleared => 'ล้างประวัติการแชทแล้ว';

  @override
  String get messagesConversationDeleted => 'ลบการสนทนาแล้ว';

  @override
  String get messagesUnknownUser => 'ผู้ใช้ที่ไม่รู้จัก';

  @override
  String get messagesFriendAvatarFallback => 'ฟ';

  @override
  String get messagesGroupFallback => 'แชทเป็นกลุ่ม';

  @override
  String get messagesGroupAvatarFallback => 'ก';

  @override
  String get messagesNewMessageDigest => '[ข้อความใหม่]';

  @override
  String get messagesConversationPin => 'ปักหมุด';

  @override
  String get messagesConversationUnpin => 'เลิกปักหมุด';

  @override
  String get messagesConversationMute => 'ปิดเสียง';

  @override
  String get messagesConversationUnmute => 'เปิดเสียง';

  @override
  String get messagesConnectionNoNetwork =>
      'เครือข่ายไม่พร้อมใช้งาน ตรวจสอบการเชื่อมต่อของคุณ';

  @override
  String get messagesConnectionDisconnected => 'ตัดการเชื่อมต่อแล้ว';

  @override
  String get messagesConnectionConnecting => 'กำลังเชื่อมต่อ';

  @override
  String get messagesConnectionSyncing => 'กำลังซิงค์';

  @override
  String get globalSearchTitle => 'ค้นหา';

  @override
  String get globalSearchTabChats => 'แชท';

  @override
  String get globalSearchTabContacts => 'รายชื่อผู้ติดต่อ';

  @override
  String get globalSearchTabGroups => 'กลุ่ม';

  @override
  String get globalSearchTabFiles => 'ไฟล์';

  @override
  String get globalSearchContactsSection => 'ที่อยู่ติดต่อ';

  @override
  String get globalSearchGroupsSection => 'แชทกลุ่ม';

  @override
  String get globalSearchMessagesSection => 'ประวัติการแชท';

  @override
  String get globalSearchFilesSection => 'ไฟล์';

  @override
  String get globalSearchNoMatches => 'No matches';

  @override
  String get globalSearchNoMore => 'ไม่มีผลลัพธ์อีกต่อไป';

  @override
  String get locationLocating => 'กำลังค้นหา...';

  @override
  String locationPermissionOff(Object appName) {
    return 'การอนุญาตตำแหน่งปิดอยู่ อนุญาตให้ $appName ใช้ตำแหน่งในการตั้งค่าระบบ';
  }

  @override
  String get locationPermissionDenied =>
      'การอนุญาตตำแหน่งถูกปฏิเสธ ไม่สามารถโหลดสถานที่ใกล้เคียงได้';

  @override
  String get locationMapUnsupported => 'AMap ไม่รองรับแพลตฟอร์มนี้';

  @override
  String locationFailed(String error) {
    return 'ตำแหน่งล้มเหลว: $error';
  }

  @override
  String get locationSearchPrompt => 'ป้อนคำหลักเพื่อค้นหาสถานที่ใกล้เคียง';

  @override
  String get locationNoNearbyPoi => 'ไม่มี POI ใกล้เคียง';

  @override
  String get locationSearchHint => 'ค้นหาสถานที่ใกล้เคียง';

  @override
  String get locationPickerTitle => 'ที่ตั้ง';

  @override
  String get locationSending => 'กำลังส่ง';

  @override
  String get locationUnnamed => 'สถานที่ที่ไม่มีชื่อ';

  @override
  String get locationCopiedAddress => 'คัดลอกที่อยู่แล้ว';

  @override
  String get locationNoMapApp => 'ไม่มีแอปแผนที่';

  @override
  String get locationFallbackTitle => 'ที่ตั้ง';

  @override
  String get locationAmap => 'AMap';

  @override
  String get locationBaiduMap => 'แผนที่ไป่ตู้';

  @override
  String get locationTencentMap => 'แผนที่เทนเซ็นต์';

  @override
  String get locationAppleMap => 'แอปเปิ้ลแผนที่';

  @override
  String get locationOtherMap => 'แผนที่อื่นๆ';

  @override
  String get locationMyLocation => 'ตำแหน่งของฉัน';

  @override
  String locationOpenMapFailed(String name) {
    return 'ไม่สามารถเปิด $name';
  }

  @override
  String get locationCopyAddress => 'คัดลอกที่อยู่';

  @override
  String get locationNavigate => 'นำทาง';

  @override
  String get locationViewTitle => 'แผนที่';

  @override
  String get momentPeerCommentDeleted => 'ลบความคิดเห็นแล้ว';

  @override
  String get momentDigest => '[ช่วงเวลา]';

  @override
  String get actionClose => 'ปิด';

  @override
  String get saveToAlbum => 'บันทึกลงในอัลบั้ม';

  @override
  String get savedToAlbum => 'บันทึกไปยังอัลบั้มแล้ว';

  @override
  String get saveFailed => 'บันทึกล้มเหลว';

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
    return '$count รูปภาพ';
  }

  @override
  String get momentReplyConnector => 'ตอบกลับ';

  @override
  String get groupRemarkTitle => 'หมายเหตุของกลุ่ม';

  @override
  String get groupRemarkHint =>
      'ตั้งข้อสังเกตของกลุ่มที่มองเห็นได้เฉพาะคุณเท่านั้น';

  @override
  String get chatNotificationSettingsTitle => 'การแจ้งเตือนข้อความ';

  @override
  String get chatScreenshotNotification => 'การแจ้งเตือนภาพหน้าจอ';

  @override
  String get chatRevokeNotification => 'เรียกคืนการแจ้งเตือน';

  @override
  String get completeProfileTitle => 'กรอกโปรไฟล์ให้สมบูรณ์';

  @override
  String get completeProfileUploadAvatar => 'อัปโหลดอวาตาร์';

  @override
  String get completeProfileReuploadAvatar => 'อัปโหลดอวาตาร์ใหม่';

  @override
  String get completeProfileChooseAvatar => 'เลือกรูปโปรไฟล์';

  @override
  String get completeProfileAvatarUploaded => 'อัปโหลดอวาตาร์แล้ว';

  @override
  String get completeProfileAvatarRequired => 'ต้องมีอวาตาร์';

  @override
  String get nicknameLabel => 'ชื่อเล่น';

  @override
  String get nicknameInputHint => 'ป้อนชื่อเล่น';

  @override
  String get nicknameRequired => 'ต้องระบุชื่อเล่น';

  @override
  String get completeProfileSaved => 'โปรไฟล์เสร็จสมบูรณ์';

  @override
  String get chatSettingsTitle => 'รายละเอียดแชท';

  @override
  String chatSettingsGroupTitle(Object count) {
    return 'ข้อมูลแชท ($count)';
  }

  @override
  String get chatSettingsGroupName => 'ชื่อแชทกลุ่ม';

  @override
  String get chatSettingsGroupQrCode => 'รหัส QR กลุ่ม';

  @override
  String get chatSearchContentTitle => 'ค้นหาแชท';

  @override
  String get chatSettingsBackground => 'Set Chat Background';

  @override
  String get chatSettingsBackgroundSelected => 'ชุดพื้นหลังแชทปัจจุบัน';

  @override
  String get chatSettingsMute => 'ปิดเสียงการแจ้งเตือน';

  @override
  String get chatSettingsPin => 'ปักหมุดแชท';

  @override
  String get chatSettingsSaveToContacts => 'บันทึกลงในรายชื่อติดต่อ';

  @override
  String get chatSettingsReadReceipt => 'อ่านใบเสร็จรับเงิน';

  @override
  String get chatSettingsReadReceiptSubtitle =>
      'เมื่อเปิดใช้งาน ข้อความที่ส่งจะแสดงสถานะอ่านแล้ว/ยังไม่ได้อ่าน';

  @override
  String get chatSettingsFlame => 'เผาหลังอ่าน';

  @override
  String get chatFlameTipExit => 'ข้อความที่อ่านแล้วถูกทำลายหลังจากออกจากแชท';

  @override
  String chatFlameTipMinutes(Object minutes) {
    return 'ข้อความถูกทำลาย $minutes นาทีหลังจากอ่าน';
  }

  @override
  String chatFlameTipSeconds(Object seconds) {
    return 'ข้อความถูกทำลาย ${seconds}s หลังจากถูกอ่าน';
  }

  @override
  String chatFlameLabelMinutes(Object minutes) {
    return '$minutes นาที';
  }

  @override
  String chatFlameLabelSeconds(Object seconds) {
    return '$secondsส';
  }

  @override
  String get chatSettingsGroupNickname => 'ชื่อเล่นกลุ่มของฉัน';

  @override
  String get chatSettingsBlacklisted => 'ติดแบล็คลิสต์';

  @override
  String get chatSettingsPeerBlacklisted => 'ผู้ติดต่อนี้อยู่ในบัญชีดำแล้ว';

  @override
  String get chatSettingsComplaint => 'รายงาน';

  @override
  String get chatSettingsDeleteAndExit => 'ลบและออก';

  @override
  String groupRemarkSyncFailed(Object error) {
    return 'ไม่สามารถซิงค์หมายเหตุของกลุ่ม: $error';
  }

  @override
  String get chatSocialDisconnected => 'ไม่ได้เชื่อมต่อบริการโซเชียล';

  @override
  String get chatNoRemovableMembers => 'ไม่มีสมาชิกที่ถอดออกได้';

  @override
  String get chatSelectMembersToRemove => 'เลือกสมาชิกที่จะลบ';

  @override
  String chatMemberNameQuoted(Object name) {
    return '\"$name\"';
  }

  @override
  String chatMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count สมาชิก',
      one: 'สมาชิก 1 คน',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersConfirm(Object names) {
    return 'ลบ $names ออกจากกลุ่ม';
  }

  @override
  String chatMembersRemoved(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ลบสมาชิก $count รายแล้ว',
      one: 'ลบสมาชิก 1 ราย',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersFailed(Object error) {
    return 'ไม่สามารถลบสมาชิก: $error';
  }

  @override
  String get chatNoInviteCandidates => 'ไม่มีผู้ติดต่อที่จะเชิญได้';

  @override
  String get chatInviteMembers => 'เชิญสมาชิก';

  @override
  String get chatSelectContacts => 'เลือกผู้ติดต่อ';

  @override
  String chatMembersInvited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เชิญสมาชิก $count',
      one: 'เชิญสมาชิก 1 คน',
    );
    return '$_temp0';
  }

  @override
  String chatInviteMembersFailed(Object error) {
    return 'ไม่สามารถเชิญสมาชิก: $error';
  }

  @override
  String get chatGroupCreated => 'สร้างแชทกลุ่มแล้ว ตรวจสอบรายการแชท';

  @override
  String get chatGroupCreateFailed => 'ไม่สามารถสร้างการแชทเป็นกลุ่ม';

  @override
  String chatGroupCreateFailedWithError(Object error) {
    return 'ไม่สามารถสร้างการแชทเป็นกลุ่ม: $error';
  }

  @override
  String get chatClearCurrentConfirm => 'ล้างประวัติการแชทปัจจุบันหรือไม่';

  @override
  String get chatDeleteAndExitConfirm =>
      'หลังจากลบและออก คุณจะไม่ได้รับข้อความจากกลุ่มนี้อีกต่อไป';

  @override
  String get chatBlockConfirm =>
      'หลังจากเพิ่มผู้ติดต่อนี้ในบัญชีดำ คุณจะไม่ได้รับข้อความของพวกเขาอีกต่อไป';

  @override
  String get chatSearchTabAll => 'แชท';

  @override
  String get chatSearchTabMedia => 'รูปภาพ/วิดีโอ';

  @override
  String get chatSearchTabFile => 'ไฟล์';

  @override
  String get chatSearchNoMatches => 'ไม่มีประวัติการแชทที่ตรงกัน';

  @override
  String get chatSearchNoMore => 'ไม่มีผลลัพธ์อีกต่อไป';

  @override
  String get chatDetailsTooltip => 'รายละเอียดแชท';

  @override
  String get chatVoiceInputTooltip => 'อินพุตเสียง';

  @override
  String get chatInputHint => 'ข้อความ...';

  @override
  String get chatFlameEnabledTooltip => 'เบิร์นหลังจากเปิดการอ่าน';

  @override
  String get chatFlameDestroyOnExit => 'ทำลายหลังจากออกจากแชท';

  @override
  String chatFlameDestroyAfterMinutes(Object minutes) {
    return 'ทำลายหลังจาก $minutes นาที';
  }

  @override
  String chatFlameDestroyAfterSeconds(Object seconds) {
    return 'ทำลายหลังจาก ${seconds}s';
  }

  @override
  String chatFlameEnabledNotice(Object label) {
    return 'เบิร์นหลังจากเปิดการอ่าน ข้อความจะถูกทำลาย $label หลังจากอ่าน ใช้การตั้งค่าด้านขวาบนเพื่อปิด';
  }

  @override
  String get chatEmojiTooltip => 'อิโมจิ';

  @override
  String get chatActionReply => 'ตอบ';

  @override
  String get chatActionCopy => 'คัดลอก';

  @override
  String get chatActionTranslate => 'แปล';

  @override
  String get chatActionTranscribe => 'ถอดเสียง';

  @override
  String get chatActionForward => 'ส่งต่อ';

  @override
  String get chatActionFavorite => 'ของโปรด';

  @override
  String get chatActionPin => 'ปักหมุด';

  @override
  String get chatActionUnpin => 'เลิกปักหมุด';

  @override
  String get chatActionAddFriend => 'เพิ่มเพื่อน';

  @override
  String get chatActionMultiSelect => 'เลือก';

  @override
  String get chatActionEdit => 'แก้ไข';

  @override
  String get chatActionEditImage => 'แก้ไขรูปภาพ';

  @override
  String get chatActionRevoke => 'เรียกคืน';

  @override
  String get chatActionDelete => 'ลบ';

  @override
  String get chatGroupCallActive => 'อยู่ระหว่างการโทรแบบกลุ่ม';

  @override
  String chatMessageRevokedBy(Object name) {
    return '$name เรียกคืนข้อความ';
  }

  @override
  String get chatReedit => 'แก้ไขใหม่';

  @override
  String get chatEditedSuffix => '(แก้ไข)';

  @override
  String chatActionReadBy(Object count) {
    return 'อ่านโดย $count';
  }

  @override
  String chatActionReactedBy(Object count) {
    return '$count ปฏิกิริยา';
  }

  @override
  String chatSelectedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เลือก $count รายการ',
      one: 'เลือกแล้ว 1 รายการ',
    );
    return '$_temp0';
  }

  @override
  String get chatNoReactions => 'ยังไม่มีการตอบกลับ';

  @override
  String chatReadStatusReadCount(Object count) {
    return 'อ่าน ($count)';
  }

  @override
  String get chatNoReadReceipts => 'ยังไม่มี';

  @override
  String get chatHistoryAbove => 'ข้อความก่อนหน้านี้ด้านบน';

  @override
  String chatUnreadNewMessages(Object count) {
    return '$count ข้อความใหม่';
  }

  @override
  String get chatUnreadDivider => 'ข้อความใหม่ด้านล่าง';

  @override
  String get chatUnknownContentFallback =>
      'เวอร์ชันนี้ไม่สามารถแสดงข้อความนี้ได้ อัปเดตเป็นเวอร์ชันล่าสุด';

  @override
  String get chatMentionSomeone => 'มีคนพูดถึงคุณ';

  @override
  String get chatToolAlbum => 'อัลบั้ม';

  @override
  String get chatToolCamera => 'กล้อง';

  @override
  String get chatToolFile => 'ไฟล์';

  @override
  String get chatToolLocation => 'ที่ตั้ง';

  @override
  String get chatToolContactCard => 'บัตรติดต่อ';

  @override
  String get chatToolAudioCall => 'โทรด้วยเสียง';

  @override
  String get chatToolVideoCall => 'แฮงเอาท์วิดีโอ';

  @override
  String get chatDraftLabel => '[ฉบับร่าง]';

  @override
  String get visitorBadge => 'ผู้เยี่ยมชม';

  @override
  String get chatNoticeDeleted => 'ลบแล้ว';

  @override
  String get chatNoticeCopied => 'คัดลอกแล้ว';

  @override
  String get chatMentionLoadedOrInvisible =>
      'โหลดข้อความ @ แล้วหรือมองไม่เห็น เลื่อนขึ้นไปเพื่อค้นหามัน';

  @override
  String get chatLocationDefaultTitle => 'ที่ตั้ง';

  @override
  String get chatLocationCopied => 'คัดลอกตำแหน่งแล้ว';

  @override
  String get chatReadStatusTitle => 'อ่านสถานะ';

  @override
  String get chatReadStatusRead => 'อ่าน';

  @override
  String get chatReadStatusUnread => 'ยังไม่ได้อ่าน';

  @override
  String get chatReadStatusUnavailable =>
      'รายการที่อ่านแล้ว/ยังไม่ได้อ่านทั้งหมดยังไม่มีให้บริการ';

  @override
  String get chatComposerLeft => 'คุณออกจากแชทนี้แล้ว';

  @override
  String get chatComposerMuted => 'แชทนี้ถูกปิดเสียง';

  @override
  String chatComposerMutedUntil(Object time) {
    return 'คุณถูกปิดเสียงจนถึง $time';
  }

  @override
  String chatFavoriteCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'รายการโปรด $count ข้อความ',
      one: 'รายการโปรด 1 ข้อความ',
    );
    return '$_temp0';
  }

  @override
  String chatFavoritePartial(Object failed, Object success) {
    return 'รายการโปรดเสร็จสมบูรณ์: $success สำเร็จ $failed ล้มเหลว';
  }

  @override
  String get chatForwardUnavailable => 'ไม่สามารถส่งต่อได้ในขณะนี้';

  @override
  String chatMergedForwardedTo(Object count, Object name) {
    return 'รวม $count ข้อความไปที่ $name';
  }

  @override
  String chatForwardedIndividuallyTo(Object count, Object name) {
    return 'ส่งต่อ $count ข้อความทีละข้อความถึง $name';
  }

  @override
  String chatForwardedPartialTo(Object name, Object sent, Object total) {
    return 'ส่งต่อข้อความ $sent/$total ไปยัง $name';
  }

  @override
  String get chatForwardModeIndividual => 'ส่งต่อทีละคน';

  @override
  String get chatForwardModeMerge => 'ผสานและส่งต่อ';

  @override
  String get chatPresenceOnline => 'ออนไลน์';

  @override
  String get chatPresenceOffline => 'ออฟไลน์';

  @override
  String get chatPresenceJustActive => 'ใช้งานอยู่ในขณะนี้';

  @override
  String chatPresenceMinutesAgo(Object minutes) {
    return 'ใช้งานเมื่อ $minutes นาทีที่แล้ว';
  }

  @override
  String chatPresenceHoursAgo(Object hours) {
    return 'ใช้งานเมื่อ $hours ชม. ที่แล้ว';
  }

  @override
  String chatPresenceDaysAgo(Object days) {
    return 'ใช้งานเมื่อ $days วันที่ผ่านมา';
  }

  @override
  String get chatSensitiveDefaultTip => 'ข้อความนี้อาจมีข้อมูลที่ละเอียดอ่อน';

  @override
  String get chatMessageDigestFallback => '[ข้อความ]';

  @override
  String get chatMediaServiceUnavailable => 'บริการสื่อไม่พร้อม';

  @override
  String get chatImDisconnected => 'IM ไม่ได้เชื่อมต่อ';

  @override
  String get chatPinFailedNotSent =>
      'ไม่สามารถปักหมุดก่อนที่ข้อความจะไปถึงเซิร์ฟเวอร์';

  @override
  String get chatPinFailed => 'ปักหมุดไม่สำเร็จ ลองอีกครั้ง';

  @override
  String get chatPinned => 'ปักหมุดแล้ว';

  @override
  String get chatUnpinFailed => 'ไม่สามารถเลิกปักหมุดได้ ลองอีกครั้ง';

  @override
  String get chatUnpinned => 'เลิกปักหมุดแล้ว';

  @override
  String get chatClearPinnedConfirm =>
      'เลิกปักหมุดข้อความที่ปักหมุดทั้งหมดใช่ไหม';

  @override
  String get chatClearPinnedAction => 'เลิกปักหมุด';

  @override
  String get chatAllUnpinned => 'เลิกปักหมุดข้อความที่ปักหมุดไว้ทั้งหมดแล้ว';

  @override
  String get chatPinnedMessageNotVisible =>
      'ข้อความนี้ไม่อยู่ในช่วงที่มองเห็นได้ ดูได้จากรายการ.';

  @override
  String get chatImageMissing => 'ข้อมูลรูปภาพหายไป';

  @override
  String get chatImageDownloadFailedEdit =>
      'ดาวน์โหลดรูปภาพไม่สำเร็จ ไม่สามารถแก้ไขได้';

  @override
  String get chatReactionFailed => 'ปฏิกิริยาล้มเหลว ลองอีกครั้ง';

  @override
  String get chatEditNotSynced => 'แก้ไขล้มเหลว: ข้อความไม่ได้รับการซิงค์';

  @override
  String get chatEditFailed => 'แก้ไขล้มเหลว ลองอีกครั้ง';

  @override
  String get chatFavoriteUnsupportedType =>
      'ประเภทนี้ยังไม่สามารถตั้งเป็นรายการโปรดได้';

  @override
  String get chatFavoriteNotSent =>
      'ข้อความยังไม่ถึงเซิร์ฟเวอร์ ดังนั้นจึงไม่สามารถเก็บเป็นรายการโปรดได้';

  @override
  String get chatFavoriteSuccess => 'เพิ่มในรายการโปรดแล้ว';

  @override
  String get chatFavoriteFailed => 'ไม่สามารถตั้งรายการโปรดได้ ลองอีกครั้ง';

  @override
  String chatToolSelected(Object title) {
    return 'เลือกแล้ว $title';
  }

  @override
  String chatCardDigest(Object name) {
    return '[การ์ด] $name';
  }

  @override
  String get chatFriendAvatarFallback => 'ฟ';

  @override
  String get chatUnknownMessageDigest => '[ไม่ทราบ]';

  @override
  String chatOpenFromContacts(Object name) {
    return 'เปิดแชทของ @$name จากรายชื่อติดต่อ';
  }

  @override
  String get chatLoadingCard => 'กำลังโหลดบัตรข้อมูลที่ติดต่อ...';

  @override
  String get chatFileMissing => 'ข้อมูลไฟล์หายไป';

  @override
  String get chatVideoUnavailable => 'ไม่สามารถเล่นวิดีโอได้';

  @override
  String get chatVideoSourceEmpty => 'แหล่งที่มาของวิดีโอว่างเปล่า';

  @override
  String get chatLivePhotoUnavailable => 'ไม่สามารถเล่น Live Photo ได้';

  @override
  String get messageAiTranslating => 'กำลังแปล...';

  @override
  String get messageAiTranscribedShort => 'เสร็จแล้ว';

  @override
  String get messageAiVoiceSendingWait =>
      'เสียงยังคงส่งอยู่ ลองอีกครั้งในภายหลัง';

  @override
  String get messageAiNoTranscript => 'ไม่มีการจดจำคำพูด';

  @override
  String get messageAiMessageSendingWait =>
      'ยังคงส่งข้อความอยู่ ลองอีกครั้งในภายหลัง';

  @override
  String get messageAiNoTranslation => 'ไม่มีผลการแปล';

  @override
  String get messageAiTemporarilyUnavailable => 'ไม่สามารถใช้งานได้ชั่วคราว';

  @override
  String get chatVoiceFileUnavailable => 'ไฟล์เสียงไม่พร้อมใช้งาน';

  @override
  String get chatVoicePlayFailed => 'การเล่นล้มเหลว ลองอีกครั้ง';

  @override
  String get chatVoiceHoldToRecord =>
      'กดค้างไว้เพื่อบันทึก · เลื่อนขึ้นเพื่อยกเลิก';

  @override
  String chatVoiceReleaseToCancel(Object duration) {
    return 'ปล่อยเพื่อยกเลิก ($duration)';
  }

  @override
  String chatVoiceRecordingSlideCancel(Object duration) {
    return '$duration · เลื่อนขึ้นเพื่อยกเลิก';
  }

  @override
  String get chatQrcodeNotFound => 'ไม่รู้จักรหัส QR';

  @override
  String chatWebLoginQrcodeDetected(Object payload) {
    return 'Web รหัส QR สำหรับการเข้าสู่ระบบได้รับการยอมรับ\n$payload';
  }

  @override
  String get chatWebLoginConfirmTitle => 'ยืนยันการเข้าสู่ระบบบนเว็บหรือไม่';

  @override
  String get chatWebLoginConfirmAction => 'ยืนยัน Web เข้าสู่ระบบ';

  @override
  String get chatWebLoginConfirmed => 'Web ยืนยันการเข้าสู่ระบบแล้ว';

  @override
  String chatQrcodeDetected(Object payload) {
    return 'รหัส QR ได้รับการยอมรับ\n$payload';
  }

  @override
  String get chatStickerPlaceholder => '[สติ๊กเกอร์]';

  @override
  String get chatStickerAdded => 'เพิ่มไปยังสติกเกอร์แล้ว';

  @override
  String get chatStickerAddFailed => 'ไม่สามารถเพิ่มสติกเกอร์ ลองอีกครั้ง';

  @override
  String get mentionAllMembers => 'สมาชิกทุกท่าน';

  @override
  String get mentionAllMembersSubtitle => 'แจ้งเตือนทุกคนในกลุ่มนี้';

  @override
  String get chatQuoteOriginalRevoked => 'ข้อความต้นฉบับถูกเรียกคืนแล้ว';

  @override
  String get chatRecognizeImageQrcode => 'สแกนรหัส QR ในภาพ';

  @override
  String get chatAddToStickers => 'เพิ่มในสติ๊กเกอร์';

  @override
  String get chatGroupInviteApprovalUrlEmpty =>
      'URL การอนุมัติคำเชิญเข้าร่วมกลุ่มว่างเปล่า';

  @override
  String get chatGroupInviteApprovalTitle => 'การอนุมัติการเชิญกลุ่ม';

  @override
  String get chatGroupInviteApprovalBody =>
      'กรอกการยืนยันการเชิญกลุ่มบนหน้าเว็บ';

  @override
  String get chatGroupInviteGoConfirm => 'ยืนยัน';

  @override
  String get chatGroupInviteApprovalOpenFailed =>
      'ไม่สามารถเปิดการอนุมัติคำเชิญเข้าร่วมกลุ่มได้ ลองอีกครั้ง';

  @override
  String get chatSendFailed => 'ไม่สามารถส่งได้ ลองอีกครั้ง';

  @override
  String get chatCallActiveHangupFirst => 'มีการโทรอยู่ วางสายก่อน';

  @override
  String get chatCallActiveCannotJoinAgain =>
      'มีการโทรอยู่ ไม่สามารถเข้าร่วมอีกครั้งได้';

  @override
  String get chatCallUnsupported => 'เวอร์ชันนี้ไม่รองรับการโทร';

  @override
  String get chatCallServiceUnavailable => 'บริการโทรไม่พร้อม';

  @override
  String get chatCallJoinFailedEnded =>
      'ไม่สามารถเข้าร่วมได้ การโทรอาจจะสิ้นสุดแล้ว';

  @override
  String get callWaitingAnswer => 'รอคำตอบ';

  @override
  String get callMessage => 'โทรข้อความ';

  @override
  String get callEnded => 'วางสายแล้ว';

  @override
  String get callPeerRefused => 'เพียร์ปฏิเสธ';

  @override
  String get callPeerHungUp => 'เพื่อนวางสาย';

  @override
  String get callPeerDeclinedVideoSwitch => 'เพียร์ปฏิเสธคำขอเปลี่ยนวิดีโอ';

  @override
  String get callSwitchVideoRequestTitle => 'คำขอของเพื่อนเปลี่ยนไปใช้วิดีโอ';

  @override
  String get callAgree => 'เห็นด้วย';

  @override
  String get callReconnecting => 'กำลังเชื่อมต่อใหม่...';

  @override
  String get callWaitingPeerCamera => 'กำลังรอกล้องเพียร์';

  @override
  String get callSelfFallbackName => 'ฉัน';

  @override
  String get callUnknownUser => 'ผู้ใช้ที่ไม่รู้จัก';

  @override
  String callJoinedCount(int joined, int total) {
    return '$joined/$total เข้าร่วม';
  }

  @override
  String get callMute => 'ปิดเสียง';

  @override
  String get callSpeaker => 'ลำโพง';

  @override
  String get callSwitchToVideo => 'วิดีโอ';

  @override
  String get callHangup => 'วางสาย';

  @override
  String get callFlipCamera => 'พลิก';

  @override
  String get callSwitchToVoice => 'เสียง';

  @override
  String get callCamera => 'กล้อง';

  @override
  String get callBack => 'กลับ';

  @override
  String get callPermissionMicrophone => 'ไมโครโฟน';

  @override
  String get callPermissionMicrophoneCamera => 'ไมโครโฟนและกล้อง';

  @override
  String callPermissionOpenSettings(String what) {
    return 'เปิดใช้งานการอนุญาต $what ในการตั้งค่าระบบ';
  }

  @override
  String callPermissionRequired(String what) {
    return 'การโทรต้องได้รับอนุญาต $what';
  }

  @override
  String get callWaitingPeerConsent => 'กำลังรอการอนุมัติจากเพื่อน';

  @override
  String get callSwitchRequestFailed => 'ไม่สามารถส่งคำขอเปลี่ยนได้';

  @override
  String get callCameraPermissionRequired => 'ต้องได้รับอนุญาตจากกล้อง';

  @override
  String get callCameraEnableFailed => 'ไม่สามารถเปิดกล้องได้';

  @override
  String get incomingCallAccepting => 'กำลังตอบ...';

  @override
  String get incomingVideoCall => 'เชิญคุณเข้าร่วมแฮงเอาท์วิดีโอ';

  @override
  String get incomingAudioCall => 'เชิญคุณเข้าร่วมการโทรด้วยเสียง';

  @override
  String incomingAcceptFailed(String error) {
    return 'คำตอบล้มเหลว: $error';
  }

  @override
  String get incomingCallDecline => 'ปฏิเสธ';

  @override
  String get incomingCallAccept => 'ตอบ';

  @override
  String get chatGroupNoInviteCandidates => 'ไม่มีสมาชิกว่างให้เชิญ';

  @override
  String get chatInviteGroupMembersVideo => 'เชิญสมาชิกกลุ่ม (แฮงเอาท์วิดีโอ)';

  @override
  String get chatInviteGroupMembersAudio => 'เชิญสมาชิกกลุ่ม (โทร)';

  @override
  String get chatSelfName => 'ฉัน';

  @override
  String get chatPeerPlaceholder => 'อื่นๆ';

  @override
  String get chatSomeonePlaceholder => 'บางคน';

  @override
  String chatScreenshotNotice(Object name) {
    return '$name จับภาพหน้าจอในแชท';
  }

  @override
  String chatDuplicateGroupMention(Object name) {
    return 'สมาชิกกลุ่มหลายคนตรงกัน @$name';
  }

  @override
  String chatDuplicateContactMention(Object name) {
    return 'ผู้ติดต่อหลายรายการตรงกัน @$name';
  }

  @override
  String chatMentionNotFound(Object name) {
    return '@$name ไม่พบ';
  }

  @override
  String get chatForwardPickerTitle => 'ส่งต่อไปยัง';

  @override
  String get chatRecentContactsSection => 'ผู้ติดต่อล่าสุด';

  @override
  String chatForwardedTo(Object name) {
    return 'ส่งต่อไปยัง $name';
  }

  @override
  String get favoriteTitle => 'รายการโปรด';

  @override
  String get favoriteEmptyTitle => 'ไม่มีรายการโปรด';

  @override
  String get favoriteEmptySubtitle =>
      'กดข้อความในแชทค้างไว้แล้วเลือกรายการโปรดเพื่อบันทึกที่นี่';

  @override
  String get favoriteDeleted => 'ลบแล้ว';

  @override
  String favoriteDeleteFailed(Object error) {
    return 'ลบล้มเหลว: $error';
  }

  @override
  String get favoriteDeleteFailedPlain => 'ลบล้มเหลว';

  @override
  String get favoriteUnsupportedSend => 'ประเภทนี้ยังไม่สามารถส่งได้';

  @override
  String favoriteSentTo(String name) {
    return 'ส่งไปที่ $name';
  }

  @override
  String favoriteSendFailed(Object error) {
    return 'ส่งล้มเหลว: $error';
  }

  @override
  String get favoriteSendFailedPlain => 'การส่งล้มเหลว';

  @override
  String get favoriteSendToFriend => 'ส่งให้เพื่อน';

  @override
  String get favoriteCopied => 'คัดลอกแล้ว';

  @override
  String get favoriteUnknownUser => 'ผู้ใช้ที่ไม่รู้จัก';

  @override
  String favoriteDateMonthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String get groupSavedTitle => 'กลุ่มที่บันทึกไว้';

  @override
  String get groupSaveTooltip => 'บันทึกกลุ่ม';

  @override
  String get groupSearchHint => 'ค้นหากลุ่ม';

  @override
  String get groupNoMatched => 'ไม่มีกลุ่มที่ตรงกัน';

  @override
  String get groupNoSaveCandidatesToast => 'ไม่มีกลุ่มให้บันทึก';

  @override
  String get groupSavedToContacts => 'บันทึกไปยังผู้ติดต่อ';

  @override
  String groupSaveFailed(Object error) {
    return 'ไม่สามารถบันทึก: $error';
  }

  @override
  String get groupSelectTitle => 'เลือกกลุ่ม';

  @override
  String get groupNoSaveCandidates => 'ไม่มีกลุ่มให้บันทึก';

  @override
  String get groupCreateTitle => 'เริ่มแชทเป็นกลุ่ม';

  @override
  String get groupSearchContactsHint => 'ค้นหาผู้ติดต่อ';

  @override
  String get groupNoMatchedContacts => 'ไม่มีผู้ติดต่อที่ตรงกัน';

  @override
  String groupMemberSummary(num count, Object subtitle) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count สมาชิก',
      one: 'สมาชิก 1 คน',
    );
    return '$_temp0· $subtitle';
  }

  @override
  String get groupMuted => 'ปิดเสียง';

  @override
  String get groupDetailsTitle => 'รายละเอียดกลุ่ม';

  @override
  String groupMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count สมาชิก',
      one: 'สมาชิก 1 คน',
    );
    return '$_temp0';
  }

  @override
  String get groupMembersSection => 'สมาชิกกลุ่ม';

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
  String get groupNoMembers => 'ไม่มีสมาชิกกลุ่ม';

  @override
  String get groupInviteMembers => 'เชิญสมาชิก';

  @override
  String get groupInviteMembersSubtitle => 'เลือกจากผู้ติดต่อ';

  @override
  String get groupRemoveMembers => 'ลบสมาชิก';

  @override
  String get groupRemoveMembersEmptySubtitle => 'ไม่มีสมาชิกที่จะลบ';

  @override
  String get groupRemoveMembersSubtitle => 'เลือกสมาชิกที่จะลบ';

  @override
  String get groupQrCodeTitle => 'รหัส QR กลุ่ม';

  @override
  String get groupQrCodeSubtitle => 'สแกนเพื่อเข้าร่วมกลุ่มนี้';

  @override
  String get groupNameTitle => 'ชื่อกลุ่ม';

  @override
  String get groupNoticeTitle => 'ประกาศกลุ่ม';

  @override
  String get groupNoticeUnset => 'ไม่ได้ตั้งค่า';

  @override
  String get groupManageTitle => 'การจัดการกลุ่ม';

  @override
  String get groupManageSubtitle => 'ผู้ดูแลระบบ ปิดเสียง และสิทธิ์ของกลุ่ม';

  @override
  String get groupInviteConfirm => 'เชิญยืนยัน';

  @override
  String get groupBlacklistTitle => 'บัญชีดำของกลุ่ม';

  @override
  String get groupBlacklistSubtitle =>
      'จัดการสมาชิกที่ถูกบล็อกไม่ให้พูดหรือเข้าร่วม';

  @override
  String get groupSaveToContacts => 'บันทึกลงในรายชื่อติดต่อ';

  @override
  String get groupMuteMessages => 'ปิดเสียงการแจ้งเตือน';

  @override
  String get groupExited => 'ออกจากแชทกลุ่มแล้ว';

  @override
  String get groupExitAction => 'ออกจากกลุ่ม';

  @override
  String groupMembersSyncFailed(Object error) {
    return 'ไม่สามารถซิงค์สมาชิกกลุ่ม: $error';
  }

  @override
  String get groupInvitePickerTitle => 'เลือกสมาชิกที่จะเชิญ';

  @override
  String groupInviteSentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ส่งคำเชิญสมาชิก $count',
      one: 'ส่งคำเชิญสมาชิก 1 รายการ',
    );
    return '$_temp0';
  }

  @override
  String groupInvitedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เชิญสมาชิก $count',
      one: 'เชิญสมาชิก 1 คน',
    );
    return '$_temp0';
  }

  @override
  String groupInviteMembersFailed(Object error) {
    return 'ไม่สามารถเชิญสมาชิก: $error';
  }

  @override
  String get groupRemovePickerTitle => 'เลือกสมาชิกที่จะลบ';

  @override
  String groupQuotedMemberName(Object name) {
    return '\"$name\"';
  }

  @override
  String groupSelectedMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count สมาชิก',
      one: 'สมาชิก 1 คน',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersConfirm(Object target) {
    return 'ลบ $target ออกจากกลุ่มนี้หรือไม่';
  }

  @override
  String get groupRemoveAction => 'ลบ';

  @override
  String groupRemovedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ลบสมาชิก $count รายแล้ว',
      one: 'ลบสมาชิก 1 ราย',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersFailed(Object error) {
    return 'ไม่สามารถลบสมาชิก: $error';
  }

  @override
  String get groupSettingsUpdated => 'อัปเดตการตั้งค่ากลุ่มแล้ว';

  @override
  String groupSettingsUpdateFailed(Object error) {
    return 'ไม่สามารถอัปเดตการตั้งค่ากลุ่ม: $error';
  }

  @override
  String get groupExitConfirm =>
      'คุณจะไม่ได้รับข้อความจากกลุ่มนี้อีกต่อไปหลังจากออกไป';

  @override
  String get groupExitSuccess => 'ออกจากแชทกลุ่มแล้ว';

  @override
  String groupExitFailed(Object error) {
    return 'ไม่สามารถออก: $error';
  }

  @override
  String get groupOwnerAdminSection => 'เจ้าของและผู้ดูแลระบบ';

  @override
  String get groupOwnerRole => 'เจ้าของ';

  @override
  String get groupAdminRole => 'แอดมิน';

  @override
  String get groupRemove => 'ลบ';

  @override
  String get groupAddAdmin => 'เพิ่มผู้ดูแลกลุ่ม';

  @override
  String get groupNoAdmins => 'ไม่มีผู้ดูแลระบบ';

  @override
  String get groupInviteConfirmRemark =>
      'เมื่อเปิดใช้งาน สมาชิกต้องได้รับการอนุมัติจากเจ้าของหรือผู้ดูแลระบบก่อนที่จะเชิญเพื่อน การเข้าร่วมด้วยรหัส QR จะถูกปิดใช้งานเช่นกัน';

  @override
  String get groupOwnerTransfer => 'โอนกรรมสิทธิ์';

  @override
  String get groupMemberSettingsSection => 'การตั้งค่าสมาชิก';

  @override
  String get groupAllMutedRemark =>
      'เมื่อเปิดใช้งานการปิดเสียงสมาชิกทั้งหมด เฉพาะเจ้าของและผู้ดูแลระบบเท่านั้นที่สามารถพูดได้';

  @override
  String get groupAllMuted => 'ปิดเสียงสมาชิกทั้งหมด';

  @override
  String get groupForbiddenAddFriendRemark =>
      'เมื่อเปิดใช้งาน สมาชิกจะไม่สามารถเพิ่มเพื่อนผ่านกลุ่มนี้ได้';

  @override
  String get groupForbiddenAddFriend => 'บล็อกสมาชิกจากการเพิ่มเพื่อน';

  @override
  String get groupAllowHistoryRemark =>
      'เมื่อเปิดใช้งาน สมาชิกใหม่จะสามารถดูประวัติการแชทก่อนหน้าได้';

  @override
  String get groupAllowHistory => 'อนุญาตให้สมาชิกใหม่ดูประวัติได้';

  @override
  String get groupAddAdminPickerTitle => 'เพิ่มผู้ดูแลกลุ่ม';

  @override
  String groupAdminAddedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เพิ่มผู้ดูแลระบบ $count ราย',
      one: 'เพิ่มผู้ดูแลระบบ 1 คน',
    );
    return '$_temp0';
  }

  @override
  String groupAddAdminFailed(Object error) {
    return 'ไม่สามารถเพิ่มผู้ดูแลระบบ: $error';
  }

  @override
  String groupRemoveAdminConfirm(Object name) {
    return 'ลบบทบาทผู้ดูแลระบบออกจาก \"$name\" หรือไม่';
  }

  @override
  String get groupRemoveAdminAction => 'ลบผู้ดูแลระบบ';

  @override
  String get groupRemoveAdminSuccess => 'ลบผู้ดูแลระบบแล้ว';

  @override
  String groupRemoveAdminFailed(Object error) {
    return 'ไม่สามารถลบผู้ดูแลระบบ: $error';
  }

  @override
  String get groupSelectNewOwner => 'เลือกเจ้าของใหม่';

  @override
  String groupTransferOwnerConfirm(Object name) {
    return 'โอนความเป็นเจ้าของไปที่ \"$name\" หรือไม่ คุณจะกลายเป็นสมาชิกประจำ';
  }

  @override
  String get groupTransferOwnerAction => 'ยืนยันการโอน';

  @override
  String get groupOwnerTransferred => 'โอนกรรมสิทธิ์แล้ว';

  @override
  String groupOwnerTransferFailed(Object error) {
    return 'ไม่สามารถโอนความเป็นเจ้าของ: $error';
  }

  @override
  String get groupNoticePublisherDefault => 'ประกาศกลุ่ม';

  @override
  String get groupNoticePublishTitle => 'โพสต์ประกาศกลุ่ม';

  @override
  String get groupNoticeEditTitle => 'แก้ไขประกาศของกลุ่ม';

  @override
  String get groupNoticePublishAction => 'โพสต์';

  @override
  String get groupNoticeEmpty => 'งดประกาศกลุ่ม';

  @override
  String get groupNoticePublishedAtUnknown => 'ไม่ทราบเวลาเผยแพร่';

  @override
  String get groupMemberRemarkTitle => 'ชื่อเล่นของฉันในกลุ่มนี้';

  @override
  String get groupMemberRemarkHint => 'ตั้งชื่อเล่นของคุณในกลุ่มนี้';

  @override
  String get groupQrCodeEmpty => 'ไม่มีรหัส QR ของกลุ่ม';

  @override
  String groupQrCodeValid(Object day, Object expire) {
    return 'รหัส QR นี้ใช้ได้เป็นเวลา $day วัน ($expire)';
  }

  @override
  String get groupQrCodeScanToJoin => 'สแกนรหัส QR เพื่อเข้าร่วมกลุ่มนี้';

  @override
  String get groupBlacklistLoadFailed => 'ไม่สามารถโหลดบัญชีดำ ลองอีกครั้ง';

  @override
  String get groupBlacklistEmpty => 'ไม่มีสมาชิกติดแบล็คลิสต์';

  @override
  String get groupBlacklistAddMember => 'เพิ่มสมาชิกบัญชีดำ';

  @override
  String get groupBlacklistNoCandidates => 'ไม่สามารถเพิ่มสมาชิกเข้าบัญชีดำได้';

  @override
  String get groupSelectMember => 'เลือกสมาชิก';

  @override
  String get groupBlacklistAdded => 'เพิ่มไปยังบัญชีดำแล้ว';

  @override
  String get groupBlacklistAddFailed => 'ไม่สามารถเพิ่มลงในบัญชีดำ ลองอีกครั้ง';

  @override
  String groupBlacklistRemoveConfirm(Object name) {
    return 'ลบ \"$name\" ออกจากบัญชีดำของกลุ่มหรือไม่';
  }

  @override
  String get groupBlacklistRemoveAction => 'ลบออกจากบัญชีดำ';

  @override
  String get groupBlacklistRemoveFailed =>
      'ไม่สามารถลบออกจากบัญชีดำ ลองอีกครั้ง';

  @override
  String get groupAvatarTitle => 'อวตารของกลุ่ม';

  @override
  String get groupAvatarTakePhoto => 'ถ่ายรูป';

  @override
  String get groupAvatarChooseFromAlbum => 'เลือกจากอัลบั้ม';

  @override
  String get groupAvatarSaveImage => 'บันทึกรูปภาพ';

  @override
  String get groupAvatarUnsupported => 'แชทนี้ไม่รองรับการเปลี่ยนอวตารของกลุ่ม';

  @override
  String get groupAvatarUpdated => 'อัปเดตอวตารของกลุ่มแล้ว';

  @override
  String get groupAvatarUpdateFailed =>
      'ไม่สามารถอัปเดตอวตารของกลุ่ม ลองอีกครั้ง';

  @override
  String get groupAvatarNoImageToSave => 'ไม่มีอวาตาร์ให้บันทึก';

  @override
  String groupPhotoPermissionRequired(Object appName) {
    return 'อนุญาตให้ $appName เข้าถึงรูปภาพของคุณ';
  }

  @override
  String get groupImageSavedToAlbum => 'บันทึกไว้ในอัลบั้ม';

  @override
  String get groupImageSaveFailed => 'ไม่สามารถบันทึก ลองอีกครั้ง';

  @override
  String get imageEditorProcessing => 'กำลังประมวลผล...';

  @override
  String get imageEditorDiscardTitle => 'ยกเลิกการแก้ไขใช่ไหม';

  @override
  String get imageEditorDiscardMessage => 'การแก้ไขที่ไม่ได้บันทึกจะสูญหาย';

  @override
  String get imageEditorDiscardConfirm => 'ยกเลิก';

  @override
  String get imageEditorPaint => 'วาด';

  @override
  String get imageEditorFreestyle => 'มือเปล่า';

  @override
  String get imageEditorArrow => 'ลูกศร';

  @override
  String get imageEditorLine => 'ไลน์';

  @override
  String get imageEditorRectangle => 'สี่เหลี่ยมผืนผ้า';

  @override
  String get imageEditorCircle => 'วงกลม';

  @override
  String get imageEditorDashLine => 'เส้นประ';

  @override
  String get imageEditorMoveAndZoom => 'ย้าย / ซูม';

  @override
  String get imageEditorEraser => 'ยางลบ';

  @override
  String get imageEditorLineWidth => 'ความกว้าง';

  @override
  String get imageEditorToggleFill => 'เติม';

  @override
  String get imageEditorOpacity => 'ความทึบ';

  @override
  String get imageEditorUndo => 'เลิกทำ';

  @override
  String get imageEditorRedo => 'ทำซ้ำ';

  @override
  String get imageEditorInputHint => 'ป้อนข้อความ';

  @override
  String get imageEditorText => 'ข้อความ';

  @override
  String get imageEditorTextAlign => 'จัดตำแหน่ง';

  @override
  String get imageEditorBackground => 'พื้นหลัง';

  @override
  String get imageEditorFontScale => 'ขนาดตัวอักษร';

  @override
  String get imageEditorCrop => 'ครอบตัด';

  @override
  String get imageEditorRotate => 'หมุน';

  @override
  String get imageEditorRatio => 'อัตราส่วน';

  @override
  String get imageEditorReset => 'รีเซ็ต';

  @override
  String get imageEditorFlip => 'พลิก';

  @override
  String get imageEditorFilter => 'ตัวกรอง';

  @override
  String get imageEditorFilterNone => 'ของแท้';

  @override
  String get imageEditorFilterAddictiveBlue => 'สีน้ำเงินเสพติด';

  @override
  String get imageEditorFilterAddictiveRed => 'สีแดงชวนติดตาม';

  @override
  String get imageEditorFilterAden => 'เอเดน';

  @override
  String get imageEditorFilterAmaro => 'อามาโร';

  @override
  String get imageEditorFilterAshby => 'แอชบี้';

  @override
  String get imageEditorFilterBrannan => 'แบรนแนน';

  @override
  String get imageEditorFilterBrooklyn => 'บรูคลิน';

  @override
  String get imageEditorFilterCharmes => 'เสน่ห์';

  @override
  String get imageEditorFilterClarendon => 'คลาเรนดอน';

  @override
  String get imageEditorFilterCrema => 'ครีมมา';

  @override
  String get imageEditorFilterDogpatch => 'แผ่นแปะสุนัข';

  @override
  String get imageEditorFilterEarlybird => 'เออร์ลี่เบิร์ด';

  @override
  String get imageEditorFilterGingham => 'ลายตาราง';

  @override
  String get imageEditorFilterGinza => 'กินซ่า';

  @override
  String get imageEditorFilterHefe => 'เฮเฟ';

  @override
  String get imageEditorFilterHelena => 'เฮเลนา';

  @override
  String get imageEditorFilterHudson => 'ฮัดสัน';

  @override
  String get imageEditorFilterInkwell => 'อิงค์เวลล์';

  @override
  String get imageEditorFilterJuno => 'จูโน';

  @override
  String get imageEditorFilterKelvin => 'เคลวิน';

  @override
  String get imageEditorFilterLark => 'สนุกสนาน';

  @override
  String get imageEditorFilterLoFi => 'โล-ไฟ';

  @override
  String get imageEditorFilterLudwig => 'ลุดวิก';

  @override
  String get imageEditorFilterMaven => 'มาเวน';

  @override
  String get imageEditorFilterMayfair => 'เมย์แฟร์';

  @override
  String get imageEditorFilterMoon => 'พระจันทร์';

  @override
  String get imageEditorFilterNashville => 'แนชวิลล์';

  @override
  String get imageEditorFilterPerpetua => 'เพอร์เพทัว';

  @override
  String get imageEditorFilterReyes => 'เรเยส';

  @override
  String get imageEditorFilterRise => 'เพิ่มขึ้น';

  @override
  String get imageEditorFilterSierra => 'เซียร่า';

  @override
  String get imageEditorFilterSkyline => 'สกายไลน์';

  @override
  String get imageEditorFilterSlumber => 'หลับใหล';

  @override
  String get imageEditorFilterStinson => 'สตินสัน';

  @override
  String get imageEditorFilterSutro => 'ซูโตร';

  @override
  String get imageEditorFilterToaster => 'เครื่องปิ้งขนมปัง';

  @override
  String get imageEditorFilterValencia => 'บาเลนเซีย';

  @override
  String get imageEditorFilterVesper => 'เวสเปอร์';

  @override
  String get imageEditorFilterWalden => 'วอลเดน';

  @override
  String get imageEditorFilterWillow => 'วิลโลว์';

  @override
  String get imageEditorBlur => 'เบลอ';

  @override
  String get imageEditorTune => 'ปรับ';

  @override
  String get imageEditorBrightness => 'ความสดใส';

  @override
  String get imageEditorContrast => 'คอนทราสต์';

  @override
  String get imageEditorSaturation => 'ความอิ่มตัว';

  @override
  String get imageEditorExposure => 'การเปิดเผย';

  @override
  String get imageEditorHue => 'เว้';

  @override
  String get imageEditorTemperature => 'อุณหภูมิ';

  @override
  String get imageEditorSharpness => 'ความคม';

  @override
  String get imageEditorFade => 'จางลง';

  @override
  String get imageEditorLuminance => 'ความสว่าง';

  @override
  String get imageEditorEmoji => 'อิโมจิ';

  @override
  String get imageEditorEmojiRecent => 'ล่าสุด';

  @override
  String get imageEditorEmojiSmileys => 'หน้ายิ้ม';

  @override
  String get imageEditorEmojiAnimals => 'สัตว์';

  @override
  String get imageEditorEmojiFood => 'อาหาร';

  @override
  String get imageEditorEmojiActivities => 'กิจกรรม';

  @override
  String get imageEditorEmojiTravel => 'ท่องเที่ยว';

  @override
  String get imageEditorEmojiObjects => 'วัตถุ';

  @override
  String get imageEditorEmojiSymbols => 'สัญลักษณ์';

  @override
  String get imageEditorEmojiFlags => 'ธง';

  @override
  String get imageEditorSticker => 'สติ๊กเกอร์';

  @override
  String get imageEditorRemove => 'ลบ';

  @override
  String get imageEditorSaving => 'กำลังบันทึก...';

  @override
  String get imageEditorImporting => 'กำลังนำเข้า';

  @override
  String get imagePreviewTitle => 'ดูตัวอย่างรูปภาพ';

  @override
  String get imagePreviewSavingToAlbum => 'กำลังบันทึก...';

  @override
  String get imagePreviewAddToSticker => 'เพิ่มในสติ๊กเกอร์';

  @override
  String get imagePreviewAddingToSticker => 'กำลังเพิ่ม...';

  @override
  String get imagePreviewRecognizeQr => 'จดจำรหัส QR';

  @override
  String get imagePreviewRecognizingQr => 'กำลังรับรู้...';

  @override
  String get imagePreviewConfirmWebLogin => 'ยืนยัน Web เข้าสู่ระบบ';

  @override
  String get imagePreviewConfirmingWebLogin => 'กำลังยืนยัน...';

  @override
  String get imagePreviewOpenLink => 'เปิดลิงก์';

  @override
  String get imagePreviewImageNotDownloadedSave => 'ยังไม่ได้ดาวน์โหลดรูปภาพ';

  @override
  String get imagePreviewMediaUnavailable => 'บริการสื่อไม่พร้อมใช้งาน';

  @override
  String get imagePreviewImageNotUploadedSticker => 'ยังไม่ได้อัปโหลดรูปภาพ';

  @override
  String get imagePreviewStickerUnavailable => 'บริการสติกเกอร์ไม่พร้อมใช้งาน';

  @override
  String get imagePreviewAddedToSticker => 'เพิ่มไปยังสติกเกอร์แล้ว';

  @override
  String get imagePreviewImageNotDownloadedRecognize =>
      'ยังไม่ได้ดาวน์โหลดรูปภาพ';

  @override
  String get imagePreviewQrNotFound => 'ไม่พบโค้ด QR';

  @override
  String get imagePreviewWebLoginQrRecognized =>
      'Web รู้จักรหัส QR สำหรับเข้าสู่ระบบแล้ว';

  @override
  String get imagePreviewWebLinkRecognized => 'Web รู้จักลิงก์แล้ว';

  @override
  String get imagePreviewQrRecognized => 'รู้จักรหัส QR แล้ว';

  @override
  String get imagePreviewWebLoginConfirmed => 'Web ยืนยันการเข้าสู่ระบบแล้ว';

  @override
  String get pickerFileTitle => 'เลือกไฟล์';

  @override
  String get pickerRecentFiles => 'ไฟล์ล่าสุด';

  @override
  String get pickerSampleProjectFile => 'หมายเหตุโครงการ.pdf';

  @override
  String get pickerSampleProjectFileSubtitle => '128 KB · วันนี้';

  @override
  String get pickerSampleScreenshotFile => 'ภาพหน้าจอแชท.png';

  @override
  String get pickerSampleScreenshotFileSubtitle => '2.4 MB · เมื่อวาน';

  @override
  String get pickerContactTitle => 'เลือกติดต่อ';

  @override
  String get pickerContactCardSection => 'ส่งบัตรข้อมูลที่ติดต่อ';

  @override
  String get pickerSearchContacts => 'ค้นหาผู้ติดต่อ';

  @override
  String get pickerNoMatchingContacts => 'ไม่มีผู้ติดต่อที่ตรงกัน';

  @override
  String get chatSendFailedShort => 'ส่งล้มเหลว';

  @override
  String get chatResend => 'ส่งอีกครั้ง';

  @override
  String get chatStatusRead => 'อ่าน';

  @override
  String get pinnedMessageTitle => 'ข้อความที่ปักหมุด';

  @override
  String pinnedMessageTitleWithIndex(int index, int total) {
    return 'ข้อความที่ปักหมุด $index/$total';
  }

  @override
  String get pinnedMessageOpen => 'แตะเพื่อดู';

  @override
  String get pinnedMessageViewAllTooltip => 'ดูปักหมุดทั้งหมด';

  @override
  String get pinnedMessageUnpinTooltip => 'เลิกปักหมุด';

  @override
  String pinnedMessageListCount(int count) {
    return '$count ข้อความที่ปักหมุด';
  }

  @override
  String get pinnedMessageClearAll => 'เลิกปักหมุดทั้งหมด';

  @override
  String get pinnedMessageFallback => 'ข้อความที่ปักหมุด';

  @override
  String get fileUnnamed => 'ไฟล์ไม่มีชื่อ';

  @override
  String get fileNoDownloadUrl => 'ไม่มีลิงก์ดาวน์โหลด';

  @override
  String get fileTitle => 'ไฟล์';

  @override
  String fileSizeLabel(String size) {
    return 'ขนาดไฟล์: $size';
  }

  @override
  String get fileDownloadFailed => 'ดาวน์โหลดล้มเหลว';

  @override
  String get filePreview => 'ดูตัวอย่าง';

  @override
  String get fileOpenWithOtherApp => 'เปิดในแอปอื่น';

  @override
  String get actionEnable => 'เปิดใช้งาน';

  @override
  String get actionDisable => 'ปิดการใช้งาน';

  @override
  String get profileInviteLoading => 'กำลังโหลดรหัสเชิญ';

  @override
  String get profileInviteEnabled => 'เปิดใช้รหัสเชิญแล้ว';

  @override
  String get profileInviteDisabled => 'รหัสเชิญถูกปิดใช้งาน';

  @override
  String profileInviteLoadFailed(String error) {
    return 'ไม่สามารถโหลดรหัสเชิญ: $error';
  }

  @override
  String get profileInviteCopied => 'คัดลอกแล้ว';

  @override
  String profileInviteUpdateFailed(String error) {
    return 'ไม่สามารถอัปเดตรหัสเชิญ: $error';
  }

  @override
  String get stickerStoreTitle => 'ร้านสติ๊กเกอร์';

  @override
  String get stickerNoPacks => 'ไม่มีชุดสติ๊กเกอร์';

  @override
  String get stickerDetailTitle => 'รายละเอียดสติ๊กเกอร์';

  @override
  String get stickerProcessing => 'กำลังประมวลผล...';

  @override
  String get stickerAddCustomTitle => 'เพิ่มสติกเกอร์แบบกำหนดเอง';

  @override
  String get stickerSortTitle => 'จัดเรียงสติ๊กเกอร์';

  @override
  String get stickerMyStickersTitle => 'สติกเกอร์ของฉัน';

  @override
  String get stickerSaving => 'กำลังบันทึก';

  @override
  String get stickerSortAction => 'เรียงลำดับ';

  @override
  String get stickerOrganize => 'จัดระเบียบ';

  @override
  String get stickerCustomTitle => 'สติกเกอร์แบบกำหนดเอง';

  @override
  String get stickerCustomSubtitle => 'จัดการสติกเกอร์แบบกำหนดเองที่บันทึกไว้';

  @override
  String get stickerNoSortablePacks => 'ไม่มีชุดสติ๊กเกอร์ให้จัดเรียง';

  @override
  String get stickerNoCategories => 'ไม่มีหมวดหมู่สติ๊กเกอร์';

  @override
  String get stickerMoveUp => 'เลื่อนขึ้น';

  @override
  String get stickerMoveDown => 'เลื่อนลง';

  @override
  String get stickerNoCustomStickers => 'ไม่มีสติกเกอร์ที่กำหนดเอง';

  @override
  String get stickerMoveToFront => 'ย้ายไปด้านหน้า';

  @override
  String get stickerDeleteConfirmTitle => 'สติกเกอร์ที่ถูกลบไม่สามารถกู้คืนได้';

  @override
  String get complaintTitle => 'รายงาน';

  @override
  String get complaintHint => 'อธิบายปัญหา';

  @override
  String get complaintType => 'ประเภทรายงาน';

  @override
  String get complaintSubmitted => 'ส่งรายงานแล้ว';

  @override
  String get complaintSubmit => 'ส่งรายงาน';

  @override
  String get complaintSubmitting => 'กำลังส่ง...';

  @override
  String get complaintFallbackOtherViolation => 'การละเมิดนโยบายอื่นๆ';

  @override
  String get complaintFallbackFraud => 'การฉ้อโกงหรือการหลอกลวงอื่นๆ';

  @override
  String get complaintFallbackAccountCompromised => 'บัญชีอาจถูกบุกรุก';

  @override
  String get chatBackgroundTitle => 'พื้นหลังแชท';

  @override
  String get chatBackgroundLoading => 'กำลังโหลดพื้นหลังแชท';

  @override
  String get chatBackgroundEmpty => 'ไม่มีพื้นหลังการแชท';

  @override
  String get chatBackgroundDefault => 'พื้นหลังเริ่มต้น';

  @override
  String chatBackgroundItem(int index) {
    return 'พื้นหลัง $index';
  }

  @override
  String get chatBackgroundPreviewTitle => 'ดูตัวอย่างพื้นหลัง';

  @override
  String get chatBackgroundSet => 'ตั้งค่าพื้นหลัง';

  @override
  String get chatBackgroundSelectedStatus => 'ชุดพื้นหลังแชท';

  @override
  String get chatBackgroundInUse => 'ใช้งานอยู่';

  @override
  String get chatContactFallback => 'ติดต่อ';

  @override
  String get chatPersonalCard => 'บัตรติดต่อ';

  @override
  String get chatSystemMessageDigest => '[ข้อความระบบ]';

  @override
  String get chatMessageDigestMessage => '[ข้อความ]';

  @override
  String get chatMessageDigestImage => '[รูปภาพ]';

  @override
  String get chatMessageDigestVoice => '[เสียง]';

  @override
  String get chatMessageDigestVideo => '[วิดีโอ]';

  @override
  String get chatMessageDigestLocation => '[สถานที่]';

  @override
  String get chatMessageDigestCard => '[บัตรติดต่อ]';

  @override
  String get chatMessageDigestFile => '[ไฟล์]';

  @override
  String get chatMessageDigestHistory => '[ประวัติการแชท]';

  @override
  String get chatMessageDigestSticker => '[สติ๊กเกอร์]';

  @override
  String get dateWeekdayShortMonday => 'จ';

  @override
  String get dateWeekdayShortTuesday => 'อ';

  @override
  String get dateWeekdayShortWednesday => 'พ';

  @override
  String get dateWeekdayShortThursday => 'พฤ';

  @override
  String get dateWeekdayShortFriday => 'ศ';

  @override
  String get dateWeekdayShortSaturday => 'เสาร์';

  @override
  String get dateWeekdayShortSunday => 'อา';

  @override
  String get appIconClassic => 'คลาสสิค';

  @override
  String get appIconSimple => 'เรียบง่าย';

  @override
  String get appIconDark => 'มืด';

  @override
  String get appIconFestive => 'เทศกาล';

  @override
  String get appIconGradient => 'ไล่ระดับสี';

  @override
  String get appIconUpdated => 'อัปเดตไอคอนแล้ว';

  @override
  String get appIconUpdateFailed => 'สวิตช์ล้มเหลว ลองอีกครั้งในภายหลัง';

  @override
  String get appearanceBubbleColorPurple => 'สีม่วง';

  @override
  String get appearanceBubbleColorGreen => 'สีเขียว';

  @override
  String get appearanceBubbleColorBlue => 'สีฟ้า';

  @override
  String get appearanceBubbleColorOrange => 'ส้ม';

  @override
  String get appearanceBubbleColorPink => 'สีชมพู';

  @override
  String replyPreviewTitle(String name) {
    return 'ตอบกลับ $name';
  }

  @override
  String get replyPreviewCancel => 'ยกเลิกการตอบ';

  @override
  String get chatPasswordTitle => 'รหัสผ่านแชท';

  @override
  String get chatPasswordHint => 'ใส่รหัสผ่าน 6 หลัก';

  @override
  String chatPasswordErrorRemain(int remain) {
    return 'รหัสผ่านผิด ประวัติการแชทจะถูกล้างหลังจากพยายามล้มเหลวอีก $remain ครั้ง';
  }

  @override
  String get emojiPackEmpty => 'ไม่มีสติกเกอร์ในชุดนี้';

  @override
  String get emojiRecentSection => 'ล่าสุด';

  @override
  String get emojiAllSection => 'อิโมจิทั้งหมด';

  @override
  String get stickerSearching => 'กำลังค้นหา...';

  @override
  String get stickerNoSearchResults => 'ไม่มีผลลัพธ์';

  @override
  String get stickerSearchResultsTitle => 'ผลลัพธ์:';

  @override
  String get homeChatPasswordWiped =>
      'พยายามผิดหลายครั้งเกินไป ประวัติการแชทถูกลบแล้ว';

  @override
  String get homeGroupNotFound => 'ไม่พบแชทกลุ่ม';

  @override
  String get homeConversationNoHistory => 'ไม่มีประวัติการแชท';

  @override
  String get homeConversationStartChat => 'เริ่มแชท';

  @override
  String get homeEnterGroupChat => 'เข้าสู่การแชทเป็นกลุ่ม';

  @override
  String get homeNewGroup => 'แชทกลุ่มใหม่';

  @override
  String homeFriendRequestAcceptFailed(String error) {
    return 'ไม่สามารถยอมรับ: $error';
  }

  @override
  String get homeFriendRequestAccepted => 'ยอมรับคำขอเป็นเพื่อนแล้ว';

  @override
  String homeFriendRequestRefuseFailed(String error) {
    return 'ไม่สามารถปฏิเสธ: $error';
  }

  @override
  String homeFriendRequestDeleteFailed(String error) {
    return 'ไม่สามารถลบ: $error';
  }

  @override
  String contactPresenceOnlineWithDevice(String device) {
    return 'ออนไลน์เมื่อ $device';
  }

  @override
  String contactPresenceJustOnlineWithDevice(String device) {
    return 'ออนไลน์บน $device เมื่อสักครู่นี้';
  }

  @override
  String contactPresenceMinutesOnlineWithDevice(int minutes, String device) {
    return 'ออนไลน์เมื่อ $device $minutes นาทีที่แล้ว';
  }

  @override
  String contactPresenceLastOnline(String time) {
    return 'ออนไลน์ครั้งล่าสุด $time';
  }

  @override
  String get contactPresenceDeviceWeb => 'เว็บ';

  @override
  String get contactPresenceDeviceDesktop => 'เดสก์ท็อป';

  @override
  String get contactPresenceDeviceMobile => 'มือถือ';

  @override
  String get botCommandsEmpty => 'ยังไม่มีคำสั่ง';
}
