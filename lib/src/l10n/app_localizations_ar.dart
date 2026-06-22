// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get tabMessages => 'الدردشات';

  @override
  String get tabContacts => 'جهات الاتصال';

  @override
  String get tabDiscover => 'اكتشف';

  @override
  String get tabMe => 'أنا';

  @override
  String get pageMessagesTitle => 'الدردشات';

  @override
  String get pageContactsTitle => 'جهات الاتصال';

  @override
  String get pageDiscoverTitle => 'اكتشف';

  @override
  String get pageMeTitle => 'أنا';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionConfirm => 'تأكيد';

  @override
  String get actionDone => 'تم';

  @override
  String get actionSave => 'حفظ';

  @override
  String get actionDelete => 'حذف';

  @override
  String get actionEdit => 'تحرير';

  @override
  String get actionAdd => 'إضافة';

  @override
  String get actionRemove => 'إزالة';

  @override
  String get actionInvite => 'دعوة';

  @override
  String get actionSearch => 'بحث';

  @override
  String get actionSend => 'إرسال';

  @override
  String get actionRetry => 'أعد المحاولة';

  @override
  String get actionBack => 'العودة';

  @override
  String get actionMore => 'المزيد';

  @override
  String get actionJoin => 'انضم';

  @override
  String get actionSkip => 'تخطي';

  @override
  String get actionContinue => 'متابعة';

  @override
  String get actionGetStarted => 'ابدأ';

  @override
  String get actionSaving => 'جاري الحفظ...';

  @override
  String get moduleUnsupported => 'هذه الميزة غير متوفرة في هذا الإصدار';

  @override
  String get moduleLoading =>
      'التحقق من الوصول إلى الميزة. حاول مرة أخرى لاحقًا.';

  @override
  String get moduleOfflineStale => 'اتصل بالشبكة لتأكيد الوصول إلى الميزة';

  @override
  String get onboardingMenuTitle => 'الدليل السريع';

  @override
  String onboardingChatTitle(Object appName) {
    return 'مرحبًا بك في $appName';
  }

  @override
  String get onboardingChatSubtitle =>
      'مكان نظيف وخفيف لإجراء محادثات أكثر راحة.';

  @override
  String get onboardingFriendsTitle => 'اجعل البقاء على اتصال أمرًا بسيطًا';

  @override
  String get onboardingFriendsSubtitle =>
      'يسهل العثور على الأصدقاء والمجموعات والمشاركة.';

  @override
  String get onboardingSecurityTitle => 'تحدث بحرية. استخدامه بثقة.';

  @override
  String get onboardingSecuritySubtitle =>
      'يساعد أمان الحساب وحماية الخصوصية في حماية حدودك.';

  @override
  String get onboardingChatSemantic => 'رسم توضيحي لإعداد مزامنة الرسائل';

  @override
  String get onboardingFriendsSemantic =>
      'رسم توضيحي لإعداد الأصدقاء والمجموعات';

  @override
  String get onboardingSecuritySemantic =>
      'رسم توضيحي للإعداد للأمان والخصوصية';

  @override
  String get settingsLanguageRow => 'اللغة';

  @override
  String get settingsLanguageSystem => 'النظام الافتراضي';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => 'الإنجليزية';

  @override
  String get profileRowFavorites => 'المفضلة';

  @override
  String get profileRowSecurityPrivacy => 'الأمان والخصوصية';

  @override
  String get profileRowNotifications => 'الإخطارات';

  @override
  String get profileRowInviteCode => 'رمز الدعوة';

  @override
  String get profileRowGeneral => 'عام';

  @override
  String profileRowAbout(Object appName) {
    return 'حول $appName';
  }

  @override
  String get profileLogout => 'تسجيل الخروج';

  @override
  String get profileLogoutConfirm =>
      'لن يؤدي تسجيل الخروج إلى حذف أي سجل. يمكنك تسجيل الدخول مرة أخرى باستخدام هذا الحساب في أي وقت.';

  @override
  String profileMoyuIdLabel(Object appName, Object value) {
    return '$appName المعرف: $value';
  }

  @override
  String get profileDefaultName => 'أنا';

  @override
  String get profileDetailTitle => 'الملف الشخصي';

  @override
  String get profileAvatar => 'الصورة الرمزية';

  @override
  String get profileNickname => 'اللقب';

  @override
  String get profileEditNickname => 'تعديل اللقب';

  @override
  String profileEditFoxId(Object appName) {
    return 'تحرير $appName المعرف';
  }

  @override
  String get profileGender => 'الجنس';

  @override
  String get profileGenderMale => 'ذكر';

  @override
  String get profileGenderFemale => 'أنثى';

  @override
  String get profileGenderSelected => 'تم التحديد';

  @override
  String get profileGenderUnset => 'لم يتم التعيين';

  @override
  String get profilePhoneUnbound => 'غير مرتبط';

  @override
  String get profileAvatarUpdated => 'تم تحديث الصورة الرمزية';

  @override
  String get profileAvatarUpdateFailed =>
      'فشل تحميل الصورة الرمزية. حاول ثانية.';

  @override
  String get generalPageTitle => 'عام';

  @override
  String get generalFontSize => 'حجم الخط';

  @override
  String get generalChatBackground => 'خلفية الدردشة';

  @override
  String get generalDarkMode => 'الوضع المظلم';

  @override
  String get generalClearCache => 'مسح ذاكرة التخزين المؤقت';

  @override
  String get generalClearMessages => 'مسح سجل الدردشة';

  @override
  String get generalAppModules => 'الميزات';

  @override
  String get generalErrorLogs => 'سجلات الأخطاء';

  @override
  String get generalThirdShare => 'الجهات الخارجية SDKs';

  @override
  String get fontSizeSmall => 'صغير';

  @override
  String get fontSizeStandard => 'قياسي';

  @override
  String get fontSizeLarge => 'كبير';

  @override
  String get fontSizeExtraLarge => 'كبير جدًا';

  @override
  String get darkModeSystem => 'النظام الافتراضي';

  @override
  String get darkModeLight => 'ضوء';

  @override
  String get darkModeDark => 'داكن';

  @override
  String get valueConfigure => 'تكوين';

  @override
  String get valueManage => 'إدارة';

  @override
  String get valueClear => 'واضح';

  @override
  String get valueUpload => 'تحميل';

  @override
  String get valueDownload => 'تحميل';

  @override
  String get valueView => 'عرض';

  @override
  String get valueEnabled => 'ممكّن';

  @override
  String get valueDisabled => 'معطل';

  @override
  String get valueOn => 'تشغيل';

  @override
  String get valueOff => 'معطل';

  @override
  String get valueConfigured => 'مجموعة';

  @override
  String get valueNotEnabled => 'غير ممكّن';

  @override
  String get valueSelected => 'تم التحديد';

  @override
  String get valueCurrentDevice => 'هذا الجهاز';

  @override
  String get valueSdkInfo => 'SDK معلومات';

  @override
  String get statusProcessing => 'المعالجة';

  @override
  String get statusLoading => 'جاري التحميل';

  @override
  String get statusSending => 'جارٍ الإرسال';

  @override
  String get statusSaving => 'الحفظ';

  @override
  String get statusSaved => 'تم الحفظ';

  @override
  String get statusSent => 'تم الإرسال';

  @override
  String get statusSubmitted => 'تم الإرسال';

  @override
  String get dateJustNow => 'الآن';

  @override
  String get dateToday => 'اليوم';

  @override
  String get dateYesterday => 'أمس';

  @override
  String get dateDayBeforeYesterday => 'أول أمس';

  @override
  String dateTodayTime(Object time) {
    return 'اليوم $time';
  }

  @override
  String dateYesterdayTime(Object time) {
    return 'أمس $time';
  }

  @override
  String dateDayBeforeYesterdayTime(Object time) {
    return 'قبل يومين $time';
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
  String get weekdayMonday => 'الاثنين';

  @override
  String get weekdayTuesday => 'الثلاثاء';

  @override
  String get weekdayWednesday => 'الأربعاء';

  @override
  String get weekdayThursday => 'الخميس';

  @override
  String get weekdayFriday => 'الجمعة';

  @override
  String get weekdaySaturday => 'السبت';

  @override
  String get weekdaySunday => 'الأحد';

  @override
  String get dialogClearAllTitle => 'هل تريد مسح سجل الدردشة بالكامل؟';

  @override
  String get dialogClearAllBody =>
      'ستتم إزالة كافة محفوظات الدردشة المحلية وإدخالات المحادثة.';

  @override
  String get authLoginSubtitle =>
      'قم بتسجيل الدخول باستخدام رقم هاتفك واستمر في الدردشة مع الأصدقاء';

  @override
  String get authLoginIllustration => 'الرسم التوضيحي لتسجيل الدخول';

  @override
  String get authRegisterIllustration => 'تسجيل الرسم التوضيحي';

  @override
  String get authSecurityIllustration => 'رسم توضيحي للتحقق';

  @override
  String get authResetIllustration => 'رسم توضيحي لإعادة تعيين كلمة المرور';

  @override
  String get authServerLabel => 'الخادم';

  @override
  String get authServerCustomLabel => 'Custom server';

  @override
  String get authServerCustomHint => 'Enter server address';

  @override
  String get authPhoneLabel => 'رقم الهاتف';

  @override
  String get authPasswordLabel => 'كلمة المرور';

  @override
  String get authForgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get authLoginButton => 'تسجيل الدخول';

  @override
  String get authLoginLoading => 'تسجيل الدخول...';

  @override
  String get authRegisterButton => 'سجل';

  @override
  String get authLoginWithApple => 'Sign in with Apple';

  @override
  String get authLoginWithGoogle => 'Sign in with Google';

  @override
  String get authLoginWithGithub => 'Sign in with GitHub';

  @override
  String get authLoginAgreementPrefix => 'بتسجيل الدخول، فإنك توافق على';

  @override
  String get authTermsTitle => 'شروط الخدمة';

  @override
  String get authAgreementConnector => 'و';

  @override
  String get authPrivacyTitle => 'سياسة الخصوصية';

  @override
  String get authVerifyTitle => 'تسجيل الدخول للتحقق';

  @override
  String authVerifySubtitleWithPhone(Object phone) {
    return 'أدخل الرمز المرسل إلى $phone';
  }

  @override
  String get authVerifySubtitlePasswordFirst =>
      'قم بتسجيل الدخول باستخدام كلمة المرور الخاصة بك أولاً لبدء التحقق الأمني';

  @override
  String get authVerifyButton => 'تحقق';

  @override
  String get authVerifyLoading => 'جاري التحقق...';

  @override
  String get authResendCode => 'لم تحصل على الرمز؟ إعادة الإرسال';

  @override
  String get authVerificationCodeSent => 'تم إرسال رمز التحقق';

  @override
  String get authVerificationCodeRequired => 'أدخل رمز التحقق';

  @override
  String get authVerificationCodeSixDigits => 'أدخل الرمز المكون من 6 أرقام';

  @override
  String get authPasswordResetTitle => 'إعادة تعيين كلمة المرور لتسجيل الدخول';

  @override
  String get authPasswordResetSubtitle =>
      'قم بالتحقق من رقم هاتفك، ثم قم بتعيين كلمة مرور جديدة لتسجيل الدخول';

  @override
  String get authPasswordResetButton => 'إعادة تعيين كلمة المرور';

  @override
  String get authKickedTitle => 'تم تسجيل الدخول إلى حسابك على جهاز آخر.';

  @override
  String get authSubmitting => 'جاري الإرسال...';

  @override
  String get authVerificationCodeLabel => 'رمز التحقق';

  @override
  String get authGetVerificationCode => 'احصل على الكود';

  @override
  String get authNewPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get authPasswordResetSuccess => 'إعادة تعيين كلمة المرور';

  @override
  String authRegisterTitle(Object appName) {
    return 'قم بإنشاء حساب $appName';
  }

  @override
  String get authRegisterSubtitle =>
      'سجل باستخدام رقم هاتفك وابدأ الدردشة على الفور';

  @override
  String get authCreateAccount => 'إنشاء حساب';

  @override
  String get authNicknameLabel => 'اللقب';

  @override
  String get authInviteCodeRequiredLabel => 'رمز الدعوة (مطلوب)';

  @override
  String authCodeRetryAfter(Object seconds) {
    return 'أعد المحاولة خلال $secondsث';
  }

  @override
  String get authRegisterAgreement =>
      'لقد قرأت شروط الخدمة وسياسة الخصوصية ووافقت عليهما';

  @override
  String get authInvalidPhone => 'رقم الهاتف غير صالح';

  @override
  String get authAcceptAgreementFirst =>
      'يرجى الموافقة على شروط الخدمة وسياسة الخصوصية أولاً';

  @override
  String get authCodeEmpty => 'مطلوب رمز التحقق';

  @override
  String get authPasswordLengthInvalid =>
      'يجب أن تتكون كلمة المرور من 6 إلى 16 حرفًا';

  @override
  String get authInviteCodeEmpty => 'رمز الدعوة مطلوب';

  @override
  String get authRegisterSuccess => 'تم التسجيل بنجاح';

  @override
  String get settingsCheckNewVersion => 'التحقق من وجود تحديثات';

  @override
  String get settingsChecking => 'التحقق';

  @override
  String get settingsVersionFound => 'التحديث متاح';

  @override
  String get settingsUserAgreement => 'شروط الخدمة';

  @override
  String get settingsPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get settingsView => 'عرض';

  @override
  String get settingsSwitchAccount => 'تبديل الحساب';

  @override
  String get settingsCacheCleared => 'تم مسح ذاكرة التخزين المؤقت';

  @override
  String get settingsClearCacheSheetTitle =>
      'مسح ذاكرة التخزين المؤقت للصور/الفيديو؟\nسيتم تنزيل صور الدردشة وأغلفة الفيديو والصور الرمزية مرة أخرى.';

  @override
  String get settingsClearCacheAction => 'مسح ذاكرة التخزين المؤقت';

  @override
  String get settingsMessagesCleared => 'تم مسح سجل الدردشة';

  @override
  String settingsClearMessagesFailed(Object error) {
    return 'فشل في مسح سجل الدردشة: $error';
  }

  @override
  String get settingsAlreadyLatestVersion => 'أنت تستخدم الإصدار الأحدث بالفعل';

  @override
  String get settingsCheckFailed => 'فشل التحقق';

  @override
  String settingsUpdateDialogTitle(Object version) {
    return 'التحديث متاح\nأحدث إصدار: $version';
  }

  @override
  String settingsUpdateDialogTitleWithDescription(
    Object description,
    Object version,
  ) {
    return 'التحديث متاح\nأحدث إصدار: $version\n$description';
  }

  @override
  String get settingsLater => 'لاحقًا';

  @override
  String get settingsUpdateNow => 'قم بالتحديث الآن';

  @override
  String get settingsSaveFailedRetry => 'فشل الحفظ. حاول ثانية.';

  @override
  String get securityAllowPhoneSearch =>
      'السماح للآخرين بالعثور علي عن طريق رقم الهاتف';

  @override
  String securityAllowFoxIdSearch(Object appName) {
    return 'السماح للآخرين بالعثور علي عن طريق معرف $appName';
  }

  @override
  String get securitySearchRemark =>
      'عند إيقاف التشغيل، لن يتمكن المستخدمون الآخرون من العثور عليك من خلال المعلومات المذكورة أعلاه.';

  @override
  String get securityJoinGroupNeedConfirm =>
      'Require confirmation to join groups';

  @override
  String get securityJoinGroupNeedConfirmRemark =>
      'When on, invitations to add you to a group must be confirmed by you first.';

  @override
  String get securityLoginPassword => 'كلمة مرور تسجيل الدخول';

  @override
  String get securityChatPassword => 'كلمة مرور الدردشة';

  @override
  String get securityScreenProtection => 'حماية الشاشة';

  @override
  String get securityLockPassword => 'قفل كلمة المرور';

  @override
  String get securityOfflineProtection => 'قفل الشاشة غير متصل';

  @override
  String get securityDeviceManagement => 'إدارة جهاز تسجيل الدخول';

  @override
  String get securityDeviceRemark =>
      'عرض الأجهزة وإدارتها، وتمكين حماية تسجيل الدخول، والحفاظ على أمان حسابك.';

  @override
  String get securityBlacklist => 'القائمة السوداء';

  @override
  String get securityAccountDeletion => 'حذف الحساب';

  @override
  String get accountDeletionBody =>
      'لا يمكن التراجع عن حذف الحساب. بعد التأكيد، سيتم إرسال رمز التحقق عبر رسالة نصية قصيرة لإكمال عملية الحذف.';

  @override
  String get accountDeletionSubmitted => 'تم إرسال طلب الحذف';

  @override
  String get accountDeletionGetCode => 'احصل على الكود';

  @override
  String get passwordResetInstruction =>
      'يتطلب تغيير كلمة مرور تسجيل الدخول رمز SMS. يجب أن تتكون كلمة المرور الجديدة من 6 أحرف على الأقل.';

  @override
  String get accountPhoneLabel => 'رقم الهاتف';

  @override
  String get passwordRuleLabel => 'قاعدة كلمة المرور';

  @override
  String get passwordAtLeastSix => '6 أحرف على الأقل';

  @override
  String get passwordConfirmLabel => 'تأكيد كلمة المرور';

  @override
  String get passwordConfirmHint => 'أدخل كلمة المرور لتسجيل الدخول مرة أخرى';

  @override
  String get passwordChanged => 'تم تغيير كلمة مرور تسجيل الدخول';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get passwordMismatch => 'كلمات المرور غير متطابقة';

  @override
  String get chatPasswordInstruction =>
      'عند التمكين، تكون كلمة المرور المكونة من 6 أرقام مطلوبة قبل فتح الدردشات المحمية.';

  @override
  String get currentStatusLabel => 'الوضع الحالي';

  @override
  String get passwordSixDigits => '6 أرقام';

  @override
  String get chatPasswordEnableAction => 'تمكين كلمة مرور الدردشة';

  @override
  String get loginPasswordRequired => 'كلمة المرور مطلوبة لتسجيل الدخول';

  @override
  String get chatPasswordSixDigitsRequired =>
      'يجب أن تتكون كلمة مرور الدردشة من 6 أرقام';

  @override
  String get lockSetTitle => 'قم بتعيين كلمة مرور قفل مكونة من 6 أرقام';

  @override
  String lockSetSubtitle(Object appName) {
    return 'مطلوب لفتح $appName';
  }

  @override
  String get lockCurrentPromptTitle => 'أدخل كلمة مرور القفل الحالية';

  @override
  String get lockCurrentPromptSubtitle => 'تحقق قبل تغييره أو إيقاف تشغيله';

  @override
  String get lockAutoLock => 'القفل التلقائي';

  @override
  String get lockChangePassword => 'تغيير كلمة المرور لفتح القفل';

  @override
  String get lockClosePassword => 'قم بإيقاف تشغيل فتح كلمة المرور';

  @override
  String get lockWrongPassword => 'كلمة مرور خاطئة. حاول ثانية.';

  @override
  String get lockSixDigitsRequired => 'يجب أن تتكون كلمة مرور القفل من 6 أرقام';

  @override
  String get lockInputTitle => 'أدخل كلمة مرور القفل';

  @override
  String lockInputSubtitle(Object appName) {
    return 'افتح القفل لمواصلة استخدام $appName';
  }

  @override
  String get lockSetFailed => 'فشل الضبط. حاول ثانية.';

  @override
  String get lockImmediately => 'فورًا';

  @override
  String get lockAfter5Minutes => 'بعد 5 دقائق';

  @override
  String get lockAfter30Minutes => 'بعد 30 دقيقة';

  @override
  String get lockAfter1Hour => 'بعد ساعة واحدة';

  @override
  String get deviceLoginProtection => 'حماية تسجيل الدخول';

  @override
  String get deviceProtectionRemark =>
      'عند تمكين حماية تسجيل الدخول، يلزم التحقق الأمني على الأجهزة غير المألوفة. يوصى به لسلامة الحساب.';

  @override
  String get deviceNone => 'لا توجد أجهزة مسجلة الدخول';

  @override
  String get deviceDebugName => 'الجهاز الحالي';

  @override
  String get deviceDebugPlatform => 'جهاز تصحيح أخطاء iPhone / Android';

  @override
  String get deviceProtectionEnabled => 'تم تمكين حماية تسجيل الدخول';

  @override
  String get deviceProtectionDisabled => 'تم تعطيل حماية تسجيل الدخول';

  @override
  String get deviceProtectionUpdateFailed =>
      'فشل تحديث حماية تسجيل الدخول. حاول ثانية.';

  @override
  String get blacklistEmpty => 'لا توجد جهات اتصال مدرجة في القائمة السوداء';

  @override
  String get switchAccountRecent => 'الحسابات الحديثة';

  @override
  String get switchAccountLoading => 'قراءة الحسابات الأخيرة';

  @override
  String get switchAccountAddOther => 'إضافة أو تسجيل الدخول إلى حساب آخر';

  @override
  String get switchAccountCurrent => 'الحالي';

  @override
  String get appModulesLoading => 'جارٍ تحميل وحدات الميزات';

  @override
  String get appModulesEmpty => 'لا توجد وحدات مميزة';

  @override
  String get appModulesUnavailable => 'الوحدة غير متاحة';

  @override
  String get errorLogsLoading => 'قراءة سجلات الأخطاء';

  @override
  String get errorLogsEmpty => 'لا توجد سجلات أخطاء';

  @override
  String get errorLogFileName => 'اسم الملف';

  @override
  String get errorLogFileSize => 'حجم الملف';

  @override
  String get errorLogGeneratedAt => 'تم الإنشاء في';

  @override
  String get errorLogFilePath => 'مسار الملف';

  @override
  String get notificationReceiveNew => 'تلقي إشعارات الرسائل الجديدة';

  @override
  String get notificationSound => 'الصوت';

  @override
  String get notificationVibration => 'الاهتزاز';

  @override
  String get notificationShowDetails => 'إظهار تفاصيل الإشعارات';

  @override
  String get notificationSystem => 'إشعارات رسائل النظام';

  @override
  String get notificationCalls => 'إشعارات مكالمات الصوت/الفيديو';

  @override
  String get settingsGoToSystem => 'الإعدادات';

  @override
  String aboutAppIconSemantic(Object appName) {
    return '$appName أيقونة';
  }

  @override
  String aboutCopyright(Object appName) {
    return 'حقوق الطبع والنشر © 2026\n$appName. جميع الحقوق محفوظة.';
  }

  @override
  String get policyWebUrl => 'Web URL';

  @override
  String get appearanceTitle => 'المظهر';

  @override
  String get appearanceAppIcon => 'أيقونة التطبيق';

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
  String get appearanceChatColor => 'لون الدردشة';

  @override
  String get appearanceBubbleRadius => 'نصف قطر زاوية الفقاعة';

  @override
  String get appearanceBubbleColorInk => 'حبر أسود';

  @override
  String get appearanceSquare => 'مربع';

  @override
  String get appearanceRound => 'مستديرة';

  @override
  String get appearancePreviewOne => 'هل يريدني أن أنعطف يمينًا أم يسارًا؟ 🤔';

  @override
  String get appearancePreviewTwo => 'صحيح. حسنًا، اجعلها قوية.';

  @override
  String get appearancePreviewThree =>
      'هل هذا كل شيء؟ أحس أنه قال أكثر من ذلك. 😯';

  @override
  String get appearancePreviewFour =>
      'هذا كل ما في الأمر. سأرسل رسالة صوتية تتضمن المزيد من التفاصيل لاحقًا.';

  @override
  String get contactsEmptyTitle => 'لا توجد اتصالات حتى الآن';

  @override
  String get contactsEmptySubtitle =>
      'أضف أصدقاء من أعلى اليمين أو قم بمسح بطاقة الملف الشخصي ضوئيًا';

  @override
  String contactsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جهات الاتصال',
      one: 'جهة اتصال واحدة',
    );
    return '$_temp0';
  }

  @override
  String get contactAddTooltip => 'إضافة صديق';

  @override
  String get contactSearchHint => 'البحث في جهات الاتصال والمجموعات';

  @override
  String get contactSetRemark => 'ضبط الملاحظة';

  @override
  String get contactAddToBlacklist => 'أضف إلى القائمة السوداء';

  @override
  String get contactDeleteFriend => 'حذف صديق';

  @override
  String get contactAddedToBlacklist => 'تمت إضافته إلى القائمة السوداء';

  @override
  String get operationFailed => 'فشلت العملية. حاول ثانية.';

  @override
  String operationFailedWithError(String error) {
    return 'فشلت العملية: $error';
  }

  @override
  String contactDeleteFriendConfirm(Object name) {
    return 'هل تريد حذف الصديق \"$name\"؟\nسيتم أيضًا مسح سجل الدردشة.';
  }

  @override
  String get contactConfirmDelete => 'تأكيد الحذف';

  @override
  String get contactDeleted => 'تم حذف الصديق';

  @override
  String get contactUnknownUser => 'مستخدم غير معروف';

  @override
  String get contactActionNewFriends => 'أصدقاء جدد';

  @override
  String get contactActionSavedGroups => 'المجموعات المحفوظة';

  @override
  String get contactSearchNoMatches => 'لا توجد جهات اتصال مطابقة';

  @override
  String get addFriendTitle => 'إضافة صديق';

  @override
  String addFriendSearchHint(Object appName) {
    return 'رقم الهاتف / $appName';
  }

  @override
  String get addFriendNotFound => 'لم يتم العثور على الحساب';

  @override
  String get myQrCodeTitle => 'رمز الاستجابة السريعة الخاص بي';

  @override
  String myQrCodeSubtitle(Object appName) {
    return 'امسح رمز الاستجابة السريعة ضوئيًا لإضافتي على $appName';
  }

  @override
  String get myQrCodeEmpty => 'لا يوجد رمز QR';

  @override
  String get scanTitle => 'مسح ضوئي';

  @override
  String get scanQrNotFound => 'لم يتم التعرف على رمز QR';

  @override
  String scanResolveFailed(String error) {
    return 'فشل في تحليل رمز الاستجابة السريعة: $error';
  }

  @override
  String get scanUnrecognized => 'لا يمكن التعرف على رمز الاستجابة السريعة هذا';

  @override
  String get scanInfoIncomplete => 'معلومات رمز الاستجابة السريعة غير كاملة';

  @override
  String get scanSocialUnavailable => 'لم تتم تهيئة الخدمة الاجتماعية';

  @override
  String get scanJoinedGroup => 'تم الانضمام إلى الدردشة الجماعية';

  @override
  String get scanCannotOpenGroup => 'لا يمكن لهذه الصفحة فتح الدردشات الجماعية';

  @override
  String get scanGroupNotFound => 'لم يتم العثور على الدردشة الجماعية';

  @override
  String get scanOpenGroupFailed => 'فشل في فتح الدردشة الجماعية';

  @override
  String get scanSelfQr => 'هذا هو رمز الاستجابة السريعة الخاص بك';

  @override
  String get scanUserNotFound => 'لم يتم العثور على المستخدم';

  @override
  String get scanCameraPermissionRequired => 'مطلوب إذن الكاميرا';

  @override
  String get scanOpenSettings => 'افتح الإعدادات';

  @override
  String get scanCameraUnavailable => 'الكاميرا غير متاحة';

  @override
  String get scanAlbum => 'الألبوم';

  @override
  String get scanLightOn => 'ضوء مضاء';

  @override
  String get scanLightOff => 'الضوء مطفأ';

  @override
  String get scanQrCode => 'رمز الاستجابة السريعة';

  @override
  String get scanGroupFallback => 'دردشة جماعية';

  @override
  String get scanGroupLoadingInfo => 'جارٍ تحميل معلومات المجموعة';

  @override
  String scanGroupMemberCount(int count) {
    return '$count أعضاء';
  }

  @override
  String get scanJoinGroupConfirm => 'انضم إلى الدردشة الجماعية';

  @override
  String get scanJoining => 'الانضمام';

  @override
  String get scanJoinGroup => 'انضم إلى الدردشة الجماعية';

  @override
  String scanJoinFailed(String error) {
    return 'فشل الانضمام: $error';
  }

  @override
  String get tagsTitle => 'العلامات';

  @override
  String get tagsCreateTooltip => 'علامة جديدة';

  @override
  String get tagsContactSection => 'علامات الاتصال';

  @override
  String get tagsEmptyTitle => 'لا توجد علامات';

  @override
  String get tagsEmptySubtitle =>
      'اضغط على + في الجزء العلوي الأيسر لتجميع جهات الاتصال أو الدردشات.';

  @override
  String tagsCreateFailed(Object error) {
    return 'فشل في إنشاء العلامة: $error';
  }

  @override
  String tagsUpdateFailed(Object error) {
    return 'فشل تحديث العلامة: $error';
  }

  @override
  String tagsDeleteFailed(Object error) {
    return 'فشل في حذف العلامة: $error';
  }

  @override
  String tagsLoadFailed(Object error) {
    return 'فشل تحميل العلامات: $error';
  }

  @override
  String tagsDeleteConfirm(String name) {
    return 'حذف العلامة \"$name\"؟\n لن يتم حذف جهات الاتصال والمجموعات الموجودة في هذه العلامة.';
  }

  @override
  String get tagsEditTitle => 'تعديل العلامة';

  @override
  String get tagsCreateTitle => 'علامة جديدة';

  @override
  String get tagsNameSection => 'اسم العلامة';

  @override
  String get tagsNameHint => 'العائلة والأصدقاء';

  @override
  String tagsMembersSection(int count) {
    return 'أعضاء العلامة ($count)';
  }

  @override
  String get tagsAddMember => 'إضافة عضو';

  @override
  String get tagsDelete => 'حذف العلامة';

  @override
  String get tagsGroupInitial => 'ز';

  @override
  String get tagsUnknownUser => 'مستخدم غير معروف';

  @override
  String get tagsSelectMembersTitle => 'حدد الأعضاء';

  @override
  String tagsDoneCount(int count) {
    return 'تم ($count)';
  }

  @override
  String get tagsSearchHint => 'البحث في جهات الاتصال أو المجموعات';

  @override
  String get tagsGroupsSection => 'الدردشات الجماعية';

  @override
  String get tagsContactsSection => 'جهات الاتصال';

  @override
  String get tagsNoMatchesTitle => 'لا توجد تطابقات';

  @override
  String get tagsNoMatchesSubtitle => 'حاول استخدام كلمة رئيسية أخرى';

  @override
  String tagsRowTitle(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get phoneContactsTitle => 'اتصالات الهاتف';

  @override
  String get phoneContactsSection => 'إضافة من جهات اتصال الهاتف';

  @override
  String get phoneContactsEmpty => 'لا توجد اتصالات هاتفية';

  @override
  String get phoneContactsNoAddable => 'لا توجد جهات اتصال هاتفية لإضافتها';

  @override
  String get phoneContactsServerSyncFailed =>
      'فشلت مزامنة الخادم. إظهار جهات الاتصال الموجودة.';

  @override
  String get friendAlreadyAdded => 'تمت الإضافة';

  @override
  String get friendRequestSent => 'تم إرسال طلب الصداقة';

  @override
  String phoneContactsInviteSmsBody(Object appName) {
    return 'أنا أستخدم $appName. تجربة الدردشة جميلة جدًا. تعال وجربه أيضًا.';
  }

  @override
  String get phoneContactsInviteOpened =>
      'تم فتح الدعوة عبر الرسائل النصية القصيرة';

  @override
  String get phoneContactsInviteFailed =>
      'لا يمكن فتح الرسائل القصيرة. يرجى الدعوة يدويا.';

  @override
  String get friendRequestsEmptyTitle => 'لا يوجد أصدقاء جدد';

  @override
  String get friendRequestsEmptySubtitle =>
      'قم بدعوة الأصدقاء لمسح رمز الاستجابة السريعة الخاص بك';

  @override
  String get friendRequestsPendingSection => 'معلق';

  @override
  String get friendRequestRefused => 'مرفوض';

  @override
  String contactOpenFromContacts(Object name) {
    return 'افتح دردشة @$name من جهات الاتصال';
  }

  @override
  String get fileHelperIntro =>
      'قم بتسجيل الدخول إلى إصدار الويب وأرسل لي رسائل لنقل النصوص والصور والصوت والفيديو والملفات بين الهاتف والكمبيوتر.';

  @override
  String get fileHelperName => 'File Transfer';

  @override
  String get systemAccountName => 'System';

  @override
  String systemAccountIntro(Object appName) {
    return 'الحساب الرسمي $appName لإرسال الإشعارات.';
  }

  @override
  String get contactIntroTitle => 'مقدمة';

  @override
  String get contactSource => 'المصدر';

  @override
  String get contactRemoveFriendRelation => 'إزالة صديق';

  @override
  String get contactRemoveFromBlacklist => 'إزالة من القائمة السوداء';

  @override
  String get contactSendMessage => 'الرسالة';

  @override
  String get contactAddToContacts => 'إضافة إلى جهات الاتصال';

  @override
  String get contactRemoveFriendConfirm => 'هل تريد إزالة هذا الصديق؟';

  @override
  String contactNicknameLine(Object name) {
    return 'اللقب: $name';
  }

  @override
  String get contactRemoveFromBlacklistConfirm =>
      'هل تريد إزالة جهة الاتصال هذه من القائمة السوداء؟';

  @override
  String get webLoginTitle => 'Web تسجيل الدخول';

  @override
  String get webLoginConfirmTitle => 'تأكيد تسجيل الدخول إلى الويب؟';

  @override
  String get webLoginConfirmBody =>
      'سيسمح هذا لحسابك بتسجيل الدخول إلى المتصفح الحالي أو عميل سطح المكتب. إذا لم تكن أنت، فانقر فوق \"إلغاء الأمر\".';

  @override
  String get webLoginConfirmAction => 'تأكيد تسجيل الدخول';

  @override
  String get webLoginConfirming => 'جارٍ التأكيد...';

  @override
  String get webLoginConfirmed => 'Web تم تأكيد تسجيل الدخول';

  @override
  String webLoginConfirmFailed(Object error) {
    return 'فشل التأكيد: $error';
  }

  @override
  String get applyFriendTitle => 'طلب صداقة';

  @override
  String get applyFriendSectionTitle => 'أرسل طلب صداقة';

  @override
  String get applyFriendRemarkHint => 'مرحبًا، أنا...';

  @override
  String friendRequestSendFailed(Object error) {
    return 'فشل الإرسال: $error';
  }

  @override
  String get contactRemarkHint => 'ملاحظة';

  @override
  String get momentPermissionsTitle => 'لحظات الخصوصية';

  @override
  String get momentHideMineFromContact => 'إخفاء لحظاتي عنهم';

  @override
  String get momentHideContactFromMe => 'إخفاء لحظاتهم عني';

  @override
  String get momentTitle => 'لحظات';

  @override
  String get momentPersonalEmpty => 'لا توجد مشاركات بعد';

  @override
  String get momentEmpty => 'لا توجد لحظات بعد';

  @override
  String get momentCoverUploadFailed => 'فشل تحميل الغلاف';

  @override
  String momentCoverUploadFailedWithError(Object error) {
    return 'فشل تحميل الغلاف: $error';
  }

  @override
  String get momentDeleteConfirm => 'هل تريد حذف هذه اللحظة؟';

  @override
  String get momentJustNow => 'الآن';

  @override
  String get momentPublishing => 'Posting…';

  @override
  String get momentPublishFailed => 'Failed to post. Tap to dismiss.';

  @override
  String get momentRemindedYou => 'ذكرك بمشاهدة هذه اللحظة';

  @override
  String momentRemindedNames(Object names) {
    return 'تم التذكير $names';
  }

  @override
  String get momentKeepEditingConfirm => 'هل تريد الاحتفاظ بهذا التعديل؟';

  @override
  String get momentContinueEditing => 'استمر في التحرير';

  @override
  String get momentSaveDraft => 'حفظ المسودة';

  @override
  String get momentDiscardDraft => 'تجاهل';

  @override
  String get momentPublishTitle => 'مشاركة';

  @override
  String get momentPublishHint => 'ماذا يدور في ذهنك...';

  @override
  String get momentLocationTitle => 'الموقع';

  @override
  String get momentRemindWho => 'تذكير';

  @override
  String get locationUnsupported => 'الموقع غير متوفر في هذا الإصدار';

  @override
  String momentPrivacyContactCount(Object count, Object label) {
    return '$label · $count';
  }

  @override
  String get momentSelectVisibleContacts => 'حدد جهات الاتصال المرئية';

  @override
  String get momentSelectHiddenContacts => 'حدد جهات الاتصال المخفية';

  @override
  String get momentPrivacyPublic => 'عام';

  @override
  String get momentPrivacyPrivate => 'خاص';

  @override
  String get momentPrivacyInternal => 'مرئي للبعض';

  @override
  String get momentPrivacyProhibit => 'إخفاء من';

  @override
  String get momentPrivacyWhoCanSee => 'من يستطيع الرؤية';

  @override
  String momentCommentFailed(Object error) {
    return 'فشل التعليق: $error';
  }

  @override
  String get momentDetailTitle => 'التفاصيل';

  @override
  String get momentDeleted => 'تم حذف هذه اللحظة';

  @override
  String get momentCollapse => 'طي';

  @override
  String get momentFullText => 'النص الكامل';

  @override
  String get momentDeleteCommentConfirm => 'هل تريد حذف هذا التعليق؟';

  @override
  String get momentCommentPlaceholder => 'تعليق';

  @override
  String momentReplyPlaceholder(Object name) {
    return 'الرد $name';
  }

  @override
  String get momentLikeAction => 'إعجاب';

  @override
  String get momentCommentAction => 'تعليق';

  @override
  String momentNewMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count رسائل جديدة',
      one: 'رسالة واحدة جديدة',
    );
    return '$_temp0';
  }

  @override
  String get messagesTitle => 'الرسائل';

  @override
  String get messagesEmpty => 'لا توجد رسائل';

  @override
  String get messagesEmptyTitle => 'لا توجد رسائل بعد';

  @override
  String get messagesEmptySubtitle => 'ابدأ محادثة جديدة من أعلى اليمين';

  @override
  String get messagesNewConversation => 'جديد';

  @override
  String get messagesStartGroupChat => 'ابدأ الدردشة الجماعية';

  @override
  String get messagesImDisconnected => 'المراسلة الفورية غير متصلة';

  @override
  String get messagesPinned => 'تم التثبيت';

  @override
  String get messagesUnpinned => 'غير مثبت';

  @override
  String get messagesMuted => 'تم كتم الصوت';

  @override
  String get messagesNotificationsOn => 'تم تفعيل الإشعارات';

  @override
  String messagesDeleteConversationTitle(String name) {
    return 'هل تريد حذف \"$name\"؟';
  }

  @override
  String get messagesConfirmDelete => 'حذف';

  @override
  String get messagesCleared => 'تم مسح سجل الدردشة';

  @override
  String get messagesConversationDeleted => 'تم حذف المحادثة';

  @override
  String get messagesUnknownUser => 'مستخدم غير معروف';

  @override
  String get messagesFriendAvatarFallback => 'ف';

  @override
  String get messagesGroupFallback => 'دردشة جماعية';

  @override
  String get messagesGroupAvatarFallback => 'ز';

  @override
  String get messagesNewMessageDigest => '[رسالة جديدة]';

  @override
  String get messagesConversationPin => 'دبوس';

  @override
  String get messagesConversationUnpin => 'إزالة التثبيت';

  @override
  String get messagesConversationMute => 'كتم الصوت';

  @override
  String get messagesConversationUnmute => 'إلغاء كتم الصوت';

  @override
  String get messagesConnectionNoNetwork => 'الشبكة غير متاحة. تحقق من اتصالك.';

  @override
  String get messagesConnectionDisconnected => 'غير متصل';

  @override
  String get messagesConnectionConnecting => 'جارٍ الاتصال';

  @override
  String get messagesConnectionSyncing => 'المزامنة';

  @override
  String get globalSearchTitle => 'بحث';

  @override
  String get globalSearchTabChats => 'الدردشات';

  @override
  String get globalSearchTabContacts => 'جهات الاتصال';

  @override
  String get globalSearchTabGroups => 'المجموعات';

  @override
  String get globalSearchTabFiles => 'الملفات';

  @override
  String get globalSearchContactsSection => 'جهات الاتصال';

  @override
  String get globalSearchGroupsSection => 'الدردشات الجماعية';

  @override
  String get globalSearchMessagesSection => 'سجل الدردشة';

  @override
  String get globalSearchFilesSection => 'الملفات';

  @override
  String get globalSearchNoMatches => 'لا توجد تطابقات';

  @override
  String get globalSearchNoMore => 'لا مزيد من النتائج';

  @override
  String get locationLocating => 'تحديد الموقع...';

  @override
  String locationPermissionOff(Object appName) {
    return 'إذن الموقع معطل. السماح لـ $appName باستخدام الموقع في إعدادات النظام.';
  }

  @override
  String get locationPermissionDenied =>
      'تم رفض إذن الموقع. لا يمكن تحميل الأماكن القريبة.';

  @override
  String get locationMapUnsupported => 'AMap غير مدعوم على هذا النظام الأساسي';

  @override
  String locationFailed(String error) {
    return 'فشل الموقع: $error';
  }

  @override
  String get locationSearchPrompt =>
      'أدخل الكلمات الرئيسية للبحث في الأماكن القريبة';

  @override
  String get locationNoNearbyPoi => 'لا توجد نقطة اهتمام قريبة';

  @override
  String get locationSearchHint => 'البحث في الأماكن القريبة';

  @override
  String get locationPickerTitle => 'الموقع';

  @override
  String get locationSending => 'جارٍ الإرسال';

  @override
  String get locationUnnamed => 'مكان بدون اسم';

  @override
  String get locationCopiedAddress => 'تم نسخ العنوان';

  @override
  String get locationNoMapApp => 'لا يتوفر تطبيق خرائط';

  @override
  String get locationFallbackTitle => 'الموقع';

  @override
  String get locationAmap => 'AMap';

  @override
  String get locationBaiduMap => 'خرائط بايدو';

  @override
  String get locationTencentMap => 'خرائط تينسنت';

  @override
  String get locationAppleMap => 'خرائط أبل';

  @override
  String get locationOtherMap => 'خرائط أخرى';

  @override
  String get locationMyLocation => 'موقعي';

  @override
  String locationOpenMapFailed(String name) {
    return 'لا يمكن فتح $name';
  }

  @override
  String get locationCopyAddress => 'نسخ العنوان';

  @override
  String get locationNavigate => 'التنقل';

  @override
  String get locationViewTitle => 'الخريطة';

  @override
  String get momentPeerCommentDeleted => 'تم حذف التعليق';

  @override
  String get momentDigest => '[لحظة]';

  @override
  String get actionClose => 'إغلاق';

  @override
  String get saveToAlbum => 'حفظ في الألبوم';

  @override
  String get savedToAlbum => 'تم الحفظ في الألبوم';

  @override
  String get saveFailed => 'فشل الحفظ';

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
    return '$count صور\nتم الرد على';
  }

  @override
  String get momentReplyConnector => '';

  @override
  String get groupRemarkTitle => 'ملاحظة المجموعة';

  @override
  String get groupRemarkHint =>
      'قم بتعيين ملاحظة المجموعة بحيث تكون مرئية لك فقط';

  @override
  String get chatNotificationSettingsTitle => 'إشعارات الرسائل';

  @override
  String get chatScreenshotNotification => 'إشعارات لقطة الشاشة';

  @override
  String get chatRevokeNotification => 'إشعارات الاستدعاء';

  @override
  String get completeProfileTitle => 'الملف الشخصي الكامل';

  @override
  String get completeProfileUploadAvatar => 'تحميل الصورة الرمزية';

  @override
  String get completeProfileReuploadAvatar => 'تحميل الصورة الرمزية الجديدة';

  @override
  String get completeProfileChooseAvatar => 'اختر صورة الملف الشخصي';

  @override
  String get completeProfileAvatarUploaded => 'تم تحميل الصورة الرمزية';

  @override
  String get completeProfileAvatarRequired => 'الصورة الرمزية مطلوبة.';

  @override
  String get nicknameLabel => 'اللقب';

  @override
  String get nicknameInputHint => 'أدخل اللقب';

  @override
  String get nicknameRequired => 'الاسم المستعار مطلوب.';

  @override
  String get completeProfileSaved => 'اكتمل الملف الشخصي';

  @override
  String get chatSettingsTitle => 'تفاصيل الدردشة';

  @override
  String chatSettingsGroupTitle(Object count) {
    return 'معلومات الدردشة ($count)';
  }

  @override
  String get chatSettingsGroupName => 'اسم الدردشة الجماعية';

  @override
  String get chatSettingsGroupQrCode => 'رمز الاستجابة السريعة للمجموعة';

  @override
  String get chatSearchContentTitle => 'بحث في الدردشة';

  @override
  String get chatSettingsBackground => 'تعيين خلفية الدردشة';

  @override
  String get chatSettingsBackgroundSelected => 'مجموعة خلفية الدردشة الحالية';

  @override
  String get chatSettingsMute => 'تجاهل الإشعارات';

  @override
  String get chatSettingsPin => 'تثبيت الدردشة';

  @override
  String get chatSettingsSaveToContacts => 'حفظ في جهات الاتصال';

  @override
  String get chatSettingsReadReceipt => 'إيصالات القراءة';

  @override
  String get chatSettingsReadReceiptSubtitle =>
      'عند التمكين، تعرض الرسائل المرسلة الحالة مقروءة/غير مقروءة';

  @override
  String get chatSettingsFlame => 'حرق بعد القراءة';

  @override
  String get chatFlameTipExit =>
      'يتم تدمير الرسائل المقروءة بعد مغادرة الدردشة';

  @override
  String chatFlameTipMinutes(Object minutes) {
    return 'يتم تدمير الرسائل بعد $minutes دقيقة من قراءتها';
  }

  @override
  String chatFlameTipSeconds(Object seconds) {
    return 'يتم تدمير الرسائل ${seconds}s بعد قراءتها';
  }

  @override
  String chatFlameLabelMinutes(Object minutes) {
    return '$minutes دقيقة';
  }

  @override
  String chatFlameLabelSeconds(Object seconds) {
    return '${seconds}s';
  }

  @override
  String get chatSettingsGroupNickname => 'اسم مجموعتي';

  @override
  String get chatSettingsBlacklisted => 'مدرج في القائمة السوداء';

  @override
  String get chatSettingsPeerBlacklisted =>
      'جهة الاتصال هذه مدرجة بالفعل في القائمة السوداء';

  @override
  String get chatSettingsComplaint => 'تقرير';

  @override
  String get chatSettingsDeleteAndExit => 'حذف وخروج';

  @override
  String groupRemarkSyncFailed(Object error) {
    return 'فشل في مزامنة ملاحظة المجموعة: $error';
  }

  @override
  String get chatSocialDisconnected => 'الخدمة الاجتماعية غير متصلة';

  @override
  String get chatNoRemovableMembers => 'لا يوجد أعضاء قابلين للإزالة';

  @override
  String get chatSelectMembersToRemove => 'حدد الأعضاء المطلوب إزالتهم';

  @override
  String chatMemberNameQuoted(Object name) {
    return '\"$name\"';
  }

  @override
  String chatMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أعضاء',
      one: 'عضو واحد',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersConfirm(Object names) {
    return 'قم بإزالة $names من المجموعة';
  }

  @override
  String chatMembersRemoved(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمت إزالة $count من الأعضاء',
      one: 'تمت إزالة عضو واحد',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersFailed(Object error) {
    return 'فشل في إزالة الأعضاء: $error';
  }

  @override
  String get chatNoInviteCandidates => 'لا توجد جهات اتصال متاحة للدعوة';

  @override
  String get chatInviteMembers => 'دعوة الأعضاء';

  @override
  String get chatSelectContacts => 'حدد جهات الاتصال';

  @override
  String chatMembersInvited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمت دعوة $count من الأعضاء',
      one: 'تمت دعوة عضو واحد',
    );
    return '$_temp0';
  }

  @override
  String chatInviteMembersFailed(Object error) {
    return 'فشلت دعوة الأعضاء: $error';
  }

  @override
  String get chatGroupCreated =>
      'تم إنشاء دردشة جماعية. تحقق من قائمة الدردشة.';

  @override
  String get chatGroupCreateFailed => 'فشل في إنشاء دردشة جماعية';

  @override
  String chatGroupCreateFailedWithError(Object error) {
    return 'فشل إنشاء دردشة جماعية: $error';
  }

  @override
  String get chatClearCurrentConfirm => 'هل تريد مسح سجل الدردشة الحالي؟';

  @override
  String get chatDeleteAndExitConfirm =>
      'بعد الحذف والخروج، لن تتلقى رسائل من هذه المجموعة بعد الآن.';

  @override
  String get chatBlockConfirm =>
      'بعد إضافة جهة الاتصال هذه إلى القائمة السوداء، لن تتلقى رسائلها بعد الآن.';

  @override
  String get chatSearchTabAll => 'الدردشات';

  @override
  String get chatSearchTabMedia => 'صور/فيديو';

  @override
  String get chatSearchTabFile => 'الملفات';

  @override
  String get chatSearchNoMatches => 'لا يوجد سجل دردشة مطابق';

  @override
  String get chatSearchNoMore => 'لا مزيد من النتائج';

  @override
  String get chatDetailsTooltip => 'تفاصيل الدردشة';

  @override
  String get chatVoiceInputTooltip => 'الإدخال الصوتي';

  @override
  String get chatInputHint => 'الرسالة...';

  @override
  String get chatFlameEnabledTooltip => 'الحرق بعد تشغيل القراءة';

  @override
  String get chatFlameDestroyOnExit => 'التدمير بعد مغادرة الدردشة';

  @override
  String chatFlameDestroyAfterMinutes(Object minutes) {
    return 'تدمير بعد $minutes دقيقة';
  }

  @override
  String chatFlameDestroyAfterSeconds(Object seconds) {
    return 'قم بالتدمير بعد ${seconds}s';
  }

  @override
  String chatFlameEnabledNotice(Object label) {
    return 'الحرق بعد تشغيل القراءة. سيتم تدمير الرسائل $label بعد القراءة. استخدم الإعدادات العلوية اليمنى لإيقاف تشغيلها.';
  }

  @override
  String get chatEmojiTooltip => 'رمز تعبيري';

  @override
  String get chatActionReply => 'الرد';

  @override
  String get chatActionCopy => 'نسخة';

  @override
  String get chatActionTranslate => 'ترجمة';

  @override
  String get chatActionTranscribe => 'نسخ';

  @override
  String get chatActionForward => 'للأمام';

  @override
  String get chatActionFavorite => 'المفضل';

  @override
  String get chatActionPin => 'دبوس';

  @override
  String get chatActionUnpin => 'إزالة التثبيت';

  @override
  String get chatActionAddFriend => 'إضافة صديق';

  @override
  String get chatActionMultiSelect => 'اختر';

  @override
  String get chatActionEdit => 'تحرير';

  @override
  String get chatActionEditImage => 'تحرير الصورة';

  @override
  String get chatActionRevoke => 'أذكر';

  @override
  String get chatActionDelete => 'حذف';

  @override
  String get chatGroupCallActive => 'مكالمة جماعية قيد التقدم';

  @override
  String chatMessageRevokedBy(Object name) {
    return '$name تم استدعاء رسالة';
  }

  @override
  String get chatReedit => 'إعادة التحرير';

  @override
  String get chatEditedSuffix => '(محرر)';

  @override
  String chatActionReadBy(Object count) {
    return 'تمت قراءته بواسطة $count';
  }

  @override
  String chatActionReactedBy(Object count) {
    return '$count ردود الفعل';
  }

  @override
  String chatSelectedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'العناصر $count المحددة',
      one: 'تم تحديد عنصر واحد',
    );
    return '$_temp0';
  }

  @override
  String get chatNoReactions => 'لا توجد ردود فعل حتى الآن';

  @override
  String chatReadStatusReadCount(Object count) {
    return 'قراءة ($count)';
  }

  @override
  String get chatNoReadReceipts => 'لا يوجد حتى الآن';

  @override
  String get chatHistoryAbove => 'الرسائل السابقة أعلاه';

  @override
  String chatUnreadNewMessages(Object count) {
    return '$count رسائل جديدة';
  }

  @override
  String get chatUnreadDivider => 'الرسائل الجديدة أدناه';

  @override
  String get chatUnknownContentFallback =>
      'لا يمكن لهذا الإصدار عرض هذه الرسالة. التحديث إلى الإصدار الأحدث.';

  @override
  String get chatMentionSomeone => 'أشار أحد الأشخاص إليك';

  @override
  String get chatToolAlbum => 'الألبوم';

  @override
  String get chatToolCamera => 'الكاميرا';

  @override
  String get chatToolFile => 'الملف';

  @override
  String get chatToolLocation => 'الموقع';

  @override
  String get chatToolContactCard => 'بطاقة جهة الاتصال';

  @override
  String get chatToolAudioCall => 'مكالمة صوتية';

  @override
  String get chatToolVideoCall => 'مكالمة فيديو';

  @override
  String get chatDraftLabel => '[مسودة]';

  @override
  String get visitorBadge => 'زائر';

  @override
  String get chatNoticeDeleted => 'محذوف';

  @override
  String get chatNoticeCopied => 'منقول';

  @override
  String get chatMentionLoadedOrInvisible =>
      'تم تحميل الرسالة @ أو أنها غير مرئية. قم بالتمرير لأعلى للعثور عليه.';

  @override
  String get chatLocationDefaultTitle => 'الموقع';

  @override
  String get chatLocationCopied => 'تم نسخ الموقع';

  @override
  String get chatReadStatusTitle => 'قراءة الحالة';

  @override
  String get chatReadStatusRead => 'اقرأ';

  @override
  String get chatReadStatusUnread => 'غير مقروءة';

  @override
  String get chatReadStatusUnavailable =>
      'القوائم الكاملة للقراءة/غير المقروءة ليست متاحة بعد';

  @override
  String get chatComposerLeft => 'لقد غادرت هذه الدردشة';

  @override
  String get chatComposerMuted => 'تم كتم صوت هذه الدردشة';

  @override
  String chatComposerMutedUntil(Object time) {
    return 'تم كتم صوتك حتى $time';
  }

  @override
  String chatFavoriteCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'رسائل $count المفضلة',
      one: 'رسالة واحدة مفضلة',
    );
    return '$_temp0';
  }

  @override
  String chatFavoritePartial(Object failed, Object success) {
    return 'اكتملت المفضلة: $success نجحت، $failed فشلت';
  }

  @override
  String get chatForwardUnavailable => 'لا يمكن إعادة التوجيه الآن';

  @override
  String chatMergedForwardedTo(Object count, Object name) {
    return 'رسائل $count المدمجة إلى $name';
  }

  @override
  String chatForwardedIndividuallyTo(Object count, Object name) {
    return 'تمت إعادة توجيه $count الرسائل واحدة تلو الأخرى إلى $name';
  }

  @override
  String chatForwardedPartialTo(Object name, Object sent, Object total) {
    return 'تمت إعادة توجيه رسائل $sent/$total إلى $name';
  }

  @override
  String get chatForwardModeIndividual => 'للأمام واحدًا تلو الآخر';

  @override
  String get chatForwardModeMerge => 'دمج وإعادة توجيه';

  @override
  String get chatPresenceOnline => 'عبر الإنترنت';

  @override
  String get chatPresenceOffline => 'غير متصل';

  @override
  String get chatPresenceJustActive => 'نشط الآن';

  @override
  String chatPresenceMinutesAgo(Object minutes) {
    return 'نشط منذ $minutes دقيقة';
  }

  @override
  String chatPresenceHoursAgo(Object hours) {
    return 'نشط منذ $hours قبل ساعة';
  }

  @override
  String chatPresenceDaysAgo(Object days) {
    return 'نشط منذ $days من الأيام';
  }

  @override
  String get chatSensitiveDefaultTip =>
      'قد تحتوي هذه الرسالة على معلومات حساسة';

  @override
  String get chatMessageDigestFallback => '[رسالة]';

  @override
  String get chatMediaServiceUnavailable => 'خدمة الوسائط غير جاهزة';

  @override
  String get chatImDisconnected => 'المراسلة الفورية غير متصلة';

  @override
  String get chatPinFailedNotSent =>
      'لا يمكن التثبيت قبل وصول الرسالة إلى الخادم';

  @override
  String get chatPinFailed => 'فشل التثبيت. حاول ثانية.';

  @override
  String get chatPinned => 'تم التثبيت';

  @override
  String get chatUnpinFailed => 'فشل في إزالة التثبيت. حاول ثانية.';

  @override
  String get chatUnpinned => 'غير مثبت';

  @override
  String get chatClearPinnedConfirm =>
      'هل ترغب في إزالة تثبيت جميع الرسائل المثبتة؟';

  @override
  String get chatClearPinnedAction => 'إزالة التثبيت';

  @override
  String get chatAllUnpinned => 'تمت إزالة تثبيت جميع الرسائل المثبتة';

  @override
  String get chatPinnedMessageNotVisible =>
      'هذه الرسالة ليست في النطاق المرئي. مشاهدته من القائمة.';

  @override
  String get chatImageMissing => 'معلومات الصورة مفقودة';

  @override
  String get chatImageDownloadFailedEdit =>
      'فشل تنزيل الصورة. لا يمكن التعديل.';

  @override
  String get chatReactionFailed => 'فشل التفاعل. حاول ثانية.';

  @override
  String get chatEditNotSynced => 'فشل التحرير: لم تتم مزامنة الرسالة';

  @override
  String get chatEditFailed => 'فشل التحرير. حاول ثانية.';

  @override
  String get chatFavoriteUnsupportedType =>
      'لا يمكن إضافة هذا النوع إلى المفضلة بعد';

  @override
  String get chatFavoriteNotSent =>
      'الرسالة لم تصل إلى الخادم، لذلك لا يمكن وضعها في المفضلة';

  @override
  String get chatFavoriteSuccess => 'تمت الإضافة إلى المفضلة';

  @override
  String get chatFavoriteFailed => 'فشل في المفضلة. حاول ثانية.';

  @override
  String chatToolSelected(Object title) {
    return 'تم التحديد $title';
  }

  @override
  String chatCardDigest(Object name) {
    return '[البطاقة] $name';
  }

  @override
  String get chatFriendAvatarFallback => 'ف';

  @override
  String get chatUnknownMessageDigest => '[غير معروف]';

  @override
  String chatOpenFromContacts(Object name) {
    return 'افتح دردشة @$name من جهات الاتصال';
  }

  @override
  String get chatLoadingCard => 'جارٍ تحميل بطاقة جهة الاتصال...';

  @override
  String get chatFileMissing => 'معلومات الملف مفقودة';

  @override
  String get chatVideoUnavailable => 'لا يمكن تشغيل الفيديو';

  @override
  String get chatVideoSourceEmpty => 'مصدر الفيديو فارغ';

  @override
  String get chatLivePhotoUnavailable => 'لا يمكن تشغيل Live Photo';

  @override
  String get messageAiTranslating => 'جاري الترجمة...';

  @override
  String get messageAiTranscribedShort => 'تم';

  @override
  String get messageAiVoiceSendingWait =>
      'لا يزال الصوت قيد الإرسال. حاول مرة أخرى لاحقًا.';

  @override
  String get messageAiNoTranscript => 'لم يتم التعرف على الكلام';

  @override
  String get messageAiMessageSendingWait =>
      'لا تزال الرسالة قيد الإرسال. حاول مرة أخرى لاحقًا.';

  @override
  String get messageAiNoTranslation => 'لا توجد نتيجة ترجمة';

  @override
  String get messageAiTemporarilyUnavailable => 'غير متاح مؤقتًا';

  @override
  String get chatVoiceFileUnavailable => 'الملف الصوتي غير متاح';

  @override
  String get chatVoicePlayFailed => 'فشل التشغيل. حاول ثانية.';

  @override
  String get chatVoiceHoldToRecord =>
      'استمر في التسجيل · قم بالتمرير لأعلى للإلغاء';

  @override
  String chatVoiceReleaseToCancel(Object duration) {
    return 'تحرير للإلغاء ($duration)';
  }

  @override
  String chatVoiceRecordingSlideCancel(Object duration) {
    return '$duration · قم بالتمرير لأعلى للإلغاء';
  }

  @override
  String get chatQrcodeNotFound => 'لم يتم التعرف على رمز QR';

  @override
  String chatWebLoginQrcodeDetected(Object payload) {
    return 'Web تم التعرف على رمز الاستجابة السريعة لتسجيل الدخول\n$payload';
  }

  @override
  String get chatWebLoginConfirmTitle => 'تأكيد تسجيل الدخول على الويب؟';

  @override
  String get chatWebLoginConfirmAction => 'تأكيد Web تسجيل الدخول';

  @override
  String get chatWebLoginConfirmed => 'Web تم تأكيد تسجيل الدخول';

  @override
  String chatQrcodeDetected(Object payload) {
    return 'تم التعرف على رمز الاستجابة السريعة\n$payload';
  }

  @override
  String get chatStickerPlaceholder => '[ملصق]';

  @override
  String get chatStickerAdded => 'تمت إضافته إلى الملصقات';

  @override
  String get chatStickerAddFailed => 'فشل في إضافة الملصق. حاول ثانية.';

  @override
  String get mentionAllMembers => 'كافة الأعضاء';

  @override
  String get mentionAllMembersSubtitle => 'أبلغ الجميع في هذه المجموعة';

  @override
  String get chatQuoteOriginalRevoked => 'تم استدعاء الرسالة الأصلية';

  @override
  String get chatRecognizeImageQrcode =>
      'قم بمسح رمز الاستجابة السريعة الموجود في الصورة';

  @override
  String get chatAddToStickers => 'إضافة إلى الملصقات';

  @override
  String get chatGroupInviteApprovalUrlEmpty =>
      'عنوان URL للموافقة على دعوة المجموعة فارغ';

  @override
  String get chatGroupInviteApprovalTitle => 'الموافقة على دعوة المجموعة';

  @override
  String get chatGroupInviteApprovalBody =>
      'أكمل تأكيد دعوة المجموعة على صفحة الويب.';

  @override
  String get chatGroupInviteGoConfirm => 'تأكيد';

  @override
  String get chatGroupInviteApprovalOpenFailed =>
      'فشل في فتح الموافقة على دعوة المجموعة. حاول ثانية.';

  @override
  String get chatSendFailed => 'فشل الإرسال. حاول ثانية.';

  @override
  String get chatCallActiveHangupFirst => 'المكالمة نشطة. شنق أولا.';

  @override
  String get chatCallActiveCannotJoinAgain =>
      'المكالمة نشطة. لا يمكن الانضمام مرة أخرى.';

  @override
  String get chatCallUnsupported => 'المكالمات غير مدعومة في هذا الإصدار';

  @override
  String get chatCallServiceUnavailable => 'خدمة الاتصال غير جاهزة';

  @override
  String get chatCallJoinFailedEnded => 'فشل الانضمام. ربما انتهت المكالمة.';

  @override
  String get callWaitingAnswer => 'في انتظار الإجابة';

  @override
  String get callMessage => 'رسالة الاتصال';

  @override
  String get callEnded => 'انتهت المكالمة';

  @override
  String get callPeerRefused => 'رفض النظير';

  @override
  String get callPeerHungUp => 'قام النظير بإغلاق الخط';

  @override
  String get callPeerDeclinedVideoSwitch => 'رفض النظير طلب تبديل الفيديو';

  @override
  String get callSwitchVideoRequestTitle => 'يطلب الزملاء التبديل إلى الفيديو';

  @override
  String get callAgree => 'أوافق';

  @override
  String get callReconnecting => 'جارٍ إعادة الاتصال...';

  @override
  String get callWaitingPeerCamera => 'في انتظار الكاميرا النظيرة';

  @override
  String get callSelfFallbackName => 'أنا';

  @override
  String get callUnknownUser => 'مستخدم غير معروف';

  @override
  String callJoinedCount(int joined, int total) {
    return '$joined/$total انضم';
  }

  @override
  String get callMute => 'كتم الصوت';

  @override
  String get callSpeaker => 'المتحدث';

  @override
  String get callSwitchToVideo => 'فيديو';

  @override
  String get callHangup => 'أغلق الخط';

  @override
  String get callFlipCamera => 'الوجه';

  @override
  String get callSwitchToVoice => 'الصوت';

  @override
  String get callCamera => 'الكاميرا';

  @override
  String get callBack => 'العودة';

  @override
  String get callPermissionMicrophone => 'ميكروفون';

  @override
  String get callPermissionMicrophoneCamera => 'الميكروفون والكاميرا';

  @override
  String callPermissionOpenSettings(String what) {
    return 'تمكين إذن $what في إعدادات النظام';
  }

  @override
  String callPermissionRequired(String what) {
    return 'تحتاج المكالمات إلى إذن $what';
  }

  @override
  String get callWaitingPeerConsent => 'في انتظار موافقة الزملاء';

  @override
  String get callSwitchRequestFailed => 'فشل إرسال طلب التبديل';

  @override
  String get callCameraPermissionRequired => 'مطلوب إذن الكاميرا';

  @override
  String get callCameraEnableFailed => 'فشل تشغيل الكاميرا';

  @override
  String get incomingCallAccepting => 'الإجابة...';

  @override
  String get incomingVideoCall => 'يدعوك إلى مكالمة فيديو';

  @override
  String get incomingAudioCall => 'يدعوك لإجراء مكالمة صوتية';

  @override
  String incomingAcceptFailed(String error) {
    return 'فشلت الإجابة: $error';
  }

  @override
  String get incomingCallDecline => 'رفض';

  @override
  String get incomingCallAccept => 'الإجابة';

  @override
  String get chatGroupNoInviteCandidates => 'لا يوجد أعضاء متاحون لدعوتهم';

  @override
  String get chatInviteGroupMembersVideo =>
      'دعوة أعضاء المجموعة (مكالمة فيديو)';

  @override
  String get chatInviteGroupMembersAudio =>
      'دعوة أعضاء المجموعة (مكالمة صوتية)';

  @override
  String get chatSelfName => 'أنا';

  @override
  String get chatPeerPlaceholder => 'أخرى';

  @override
  String get chatSomeonePlaceholder => 'شخص ما';

  @override
  String chatScreenshotNotice(Object name) {
    return '$name التقط لقطة شاشة في الدردشة';
  }

  @override
  String chatDuplicateGroupMention(Object name) {
    return 'يتطابق أعضاء المجموعة المتعددون مع @$name';
  }

  @override
  String chatDuplicateContactMention(Object name) {
    return 'جهات اتصال متعددة تطابق @$name';
  }

  @override
  String chatMentionNotFound(Object name) {
    return '@$name غير موجود';
  }

  @override
  String get chatForwardPickerTitle => 'إعادة التوجيه إلى';

  @override
  String get chatRecentContactsSection => 'جهات الاتصال الأخيرة';

  @override
  String chatForwardedTo(Object name) {
    return 'تمت إعادة التوجيه إلى $name';
  }

  @override
  String get favoriteTitle => 'المفضلة';

  @override
  String get favoriteEmptyTitle => 'لا توجد مفضلة';

  @override
  String get favoriteEmptySubtitle =>
      'اضغط لفترة طويلة على الرسالة في الدردشة واختر \"المفضلة\" لحفظها هنا.';

  @override
  String get favoriteDeleted => 'محذوف';

  @override
  String favoriteDeleteFailed(Object error) {
    return 'فشل الحذف: $error';
  }

  @override
  String get favoriteDeleteFailedPlain => 'فشل الحذف';

  @override
  String get favoriteUnsupportedSend => 'لا يمكن إرسال هذا النوع بعد';

  @override
  String favoriteSentTo(String name) {
    return 'تم الإرسال إلى $name';
  }

  @override
  String favoriteSendFailed(Object error) {
    return 'فشل الإرسال: $error';
  }

  @override
  String get favoriteSendFailedPlain => 'فشل الإرسال';

  @override
  String get favoriteSendToFriend => 'أرسل إلى صديق';

  @override
  String get favoriteCopied => 'منقول';

  @override
  String get favoriteUnknownUser => 'مستخدم غير معروف';

  @override
  String favoriteDateMonthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String get groupSavedTitle => 'المجموعات المحفوظة';

  @override
  String get groupSaveTooltip => 'حفظ المجموعة';

  @override
  String get groupSearchHint => 'مجموعات البحث';

  @override
  String get groupNoMatched => 'لا توجد مجموعات متطابقة';

  @override
  String get groupNoSaveCandidatesToast => 'لا توجد مجموعات متاحة للحفظ';

  @override
  String get groupSavedToContacts => 'تم الحفظ في جهات الاتصال';

  @override
  String groupSaveFailed(Object error) {
    return 'فشل في الحفظ: $error';
  }

  @override
  String get groupSelectTitle => 'حدد المجموعة';

  @override
  String get groupNoSaveCandidates => 'لا توجد مجموعات متاحة للحفظ';

  @override
  String get groupCreateTitle => 'ابدأ الدردشة الجماعية';

  @override
  String get groupSearchContactsHint => 'البحث في جهات الاتصال';

  @override
  String get groupNoMatchedContacts => 'لا توجد جهات اتصال مطابقة';

  @override
  String groupMemberSummary(num count, Object subtitle) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أعضاء',
      one: 'عضو واحد',
    );
    return '$_temp0· $subtitle';
  }

  @override
  String get groupMuted => 'تم كتم الصوت';

  @override
  String get groupDetailsTitle => 'تفاصيل المجموعة';

  @override
  String groupMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أعضاء',
      one: 'عضو واحد',
    );
    return '$_temp0';
  }

  @override
  String get groupMembersSection => 'أعضاء المجموعة';

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
  String get groupNoMembers => 'لا يوجد أعضاء في المجموعة';

  @override
  String get groupInviteMembers => 'دعوة الأعضاء';

  @override
  String get groupInviteMembersSubtitle => 'اختر من جهات الاتصال';

  @override
  String get groupRemoveMembers => 'إزالة الأعضاء';

  @override
  String get groupRemoveMembersEmptySubtitle => 'لا يوجد أعضاء لإزالتهم';

  @override
  String get groupRemoveMembersSubtitle => 'اختر الأعضاء المطلوب إزالتهم';

  @override
  String get groupQrCodeTitle => 'رمز الاستجابة السريعة للمجموعة';

  @override
  String get groupQrCodeSubtitle => 'قم بالمسح للانضمام إلى هذه المجموعة';

  @override
  String get groupNameTitle => 'اسم المجموعة';

  @override
  String get groupNoticeTitle => 'إعلان المجموعة';

  @override
  String get groupNoticeUnset => 'لم يتم التعيين';

  @override
  String get groupManageTitle => 'إدارة المجموعة';

  @override
  String get groupManageSubtitle => 'المسؤولون، كتم الصوت، وأذونات المجموعة';

  @override
  String get groupInviteConfirm => 'تأكيد الدعوة';

  @override
  String get groupBlacklistTitle => 'القائمة السوداء للمجموعة';

  @override
  String get groupBlacklistSubtitle =>
      'إدارة الأعضاء المحظورين من التحدث أو الانضمام';

  @override
  String get groupSaveToContacts => 'حفظ في جهات الاتصال';

  @override
  String get groupMuteMessages => 'تجاهل الإشعارات';

  @override
  String get groupExited => 'الدردشة الجماعية اليسرى';

  @override
  String get groupExitAction => 'مغادرة المجموعة';

  @override
  String groupMembersSyncFailed(Object error) {
    return 'فشل في مزامنة أعضاء المجموعة: $error';
  }

  @override
  String get groupInvitePickerTitle => 'اختر الأعضاء المطلوب دعوتهم';

  @override
  String groupInviteSentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم إرسال $count دعوات الأعضاء',
      one: 'تم إرسال دعوة لعضو واحد',
    );
    return '$_temp0';
  }

  @override
  String groupInvitedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمت دعوة $count من الأعضاء',
      one: 'تمت دعوة عضو واحد',
    );
    return '$_temp0';
  }

  @override
  String groupInviteMembersFailed(Object error) {
    return 'فشلت دعوة الأعضاء: $error';
  }

  @override
  String get groupRemovePickerTitle => 'اختر الأعضاء المطلوب إزالتهم';

  @override
  String groupQuotedMemberName(Object name) {
    return '\"$name\"';
  }

  @override
  String groupSelectedMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أعضاء',
      one: 'عضو واحد',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersConfirm(Object target) {
    return 'هل تريد إزالة $target من هذه المجموعة؟';
  }

  @override
  String get groupRemoveAction => 'إزالة';

  @override
  String groupRemovedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمت إزالة $count من الأعضاء',
      one: 'تمت إزالة عضو واحد',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersFailed(Object error) {
    return 'فشل في إزالة الأعضاء: $error';
  }

  @override
  String get groupSettingsUpdated => 'تم تحديث إعدادات المجموعة';

  @override
  String groupSettingsUpdateFailed(Object error) {
    return 'فشل في تحديث إعدادات المجموعة: $error';
  }

  @override
  String get groupExitConfirm => 'لن تتلقى رسائل من هذه المجموعة بعد مغادرتها.';

  @override
  String get groupExitSuccess => 'الدردشة الجماعية اليسرى';

  @override
  String groupExitFailed(Object error) {
    return 'فشل في المغادرة: $error';
  }

  @override
  String get groupOwnerAdminSection => 'المالك والمسؤولون';

  @override
  String get groupOwnerRole => 'مالك';

  @override
  String get groupAdminRole => 'المشرف';

  @override
  String get groupRemove => 'إزالة';

  @override
  String get groupAddAdmin => 'إضافة مسؤول المجموعة';

  @override
  String get groupNoAdmins => 'لا يوجد مشرفين';

  @override
  String get groupInviteConfirmRemark =>
      'عند التمكين، يحتاج الأعضاء إلى موافقة المالك أو المسؤول قبل دعوة الأصدقاء. سيتم أيضًا تعطيل الانضمام عن طريق رمز الاستجابة السريعة.';

  @override
  String get groupOwnerTransfer => 'نقل الملكية';

  @override
  String get groupMemberSettingsSection => 'إعدادات الأعضاء';

  @override
  String get groupAllMutedRemark =>
      'عند تمكين كتم صوت جميع الأعضاء، يمكن للمالك والمسؤولين فقط التحدث.';

  @override
  String get groupAllMuted => 'كتم صوت جميع الأعضاء';

  @override
  String get groupForbiddenAddFriendRemark =>
      'عند التمكين، لا يمكن للأعضاء إضافة أصدقاء من خلال هذه المجموعة.';

  @override
  String get groupForbiddenAddFriend => 'منع الأعضاء من إضافة الأصدقاء';

  @override
  String get groupAllowHistoryRemark =>
      'عند التمكين، يمكن للأعضاء الجدد رؤية سجل الدردشة السابق.';

  @override
  String get groupAllowHistory => 'السماح للأعضاء الجدد بعرض السجل';

  @override
  String get groupAddAdminPickerTitle => 'إضافة مسؤول المجموعة';

  @override
  String groupAdminAddedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمت إضافة $count المشرفين',
      one: 'تمت إضافة مشرف واحد',
    );
    return '$_temp0';
  }

  @override
  String groupAddAdminFailed(Object error) {
    return 'فشل في إضافة المسؤول: $error';
  }

  @override
  String groupRemoveAdminConfirm(Object name) {
    return 'هل تريد إزالة دور المسؤول من \"$name\"؟';
  }

  @override
  String get groupRemoveAdminAction => 'إزالة المسؤول';

  @override
  String get groupRemoveAdminSuccess => 'تمت إزالة المشرف';

  @override
  String groupRemoveAdminFailed(Object error) {
    return 'فشل في إزالة المشرف: $error';
  }

  @override
  String get groupSelectNewOwner => 'حدد مالكًا جديدًا';

  @override
  String groupTransferOwnerConfirm(Object name) {
    return 'هل تريد نقل الملكية إلى \"$name\"؟ سوف تصبح عضوا منتظما.';
  }

  @override
  String get groupTransferOwnerAction => 'تأكيد النقل';

  @override
  String get groupOwnerTransferred => 'تم نقل الملكية';

  @override
  String groupOwnerTransferFailed(Object error) {
    return 'فشل نقل الملكية: $error';
  }

  @override
  String get groupNoticePublisherDefault => 'إعلان المجموعة';

  @override
  String get groupNoticePublishTitle => 'إعلان مجموعة النشر';

  @override
  String get groupNoticeEditTitle => 'تعديل إعلان المجموعة';

  @override
  String get groupNoticePublishAction => 'مشاركة';

  @override
  String get groupNoticeEmpty => 'لا يوجد إعلان للمجموعة';

  @override
  String get groupNoticePublishedAtUnknown => 'وقت النشر غير معروف';

  @override
  String get groupMemberRemarkTitle => 'اسمي المستعار في هذه المجموعة';

  @override
  String get groupMemberRemarkHint => 'قم بتعيين لقبك في هذه المجموعة';

  @override
  String get groupQrCodeEmpty => 'لا يوجد رمز الاستجابة السريعة للمجموعة';

  @override
  String groupQrCodeValid(Object day, Object expire) {
    return 'رمز الاستجابة السريعة هذا صالح لمدة $day يوم ($expire)';
  }

  @override
  String get groupQrCodeScanToJoin =>
      'امسح رمز الاستجابة السريعة للانضمام إلى هذه المجموعة';

  @override
  String get groupBlacklistLoadFailed =>
      'فشل تحميل القائمة السوداء. حاول ثانية.';

  @override
  String get groupBlacklistEmpty => 'لا يوجد أعضاء مدرجين في القائمة السوداء';

  @override
  String get groupBlacklistAddMember => 'إضافة عضو إلى القائمة السوداء';

  @override
  String get groupBlacklistNoCandidates =>
      'لا يمكن إضافة أي أعضاء إلى القائمة السوداء';

  @override
  String get groupSelectMember => 'اختر العضو';

  @override
  String get groupBlacklistAdded => 'تمت إضافته إلى القائمة السوداء';

  @override
  String get groupBlacklistAddFailed =>
      'فشلت الإضافة إلى القائمة السوداء. حاول ثانية.';

  @override
  String groupBlacklistRemoveConfirm(Object name) {
    return 'هل تريد إزالة \"$name\" من القائمة السوداء للمجموعة؟';
  }

  @override
  String get groupBlacklistRemoveAction => 'إزالة من القائمة السوداء';

  @override
  String get groupBlacklistRemoveFailed =>
      'فشلت الإزالة من القائمة السوداء. حاول ثانية.';

  @override
  String get groupAvatarTitle => 'الصورة الرمزية للمجموعة';

  @override
  String get groupAvatarTakePhoto => 'التقط صورة';

  @override
  String get groupAvatarChooseFromAlbum => 'اختر من الألبوم';

  @override
  String get groupAvatarSaveImage => 'حفظ الصورة';

  @override
  String get groupAvatarUnsupported =>
      'هذه الدردشة لا تدعم تغيير الصورة الرمزية للمجموعة';

  @override
  String get groupAvatarUpdated => 'تم تحديث الصورة الرمزية للمجموعة';

  @override
  String get groupAvatarUpdateFailed =>
      'فشل تحديث الصورة الرمزية للمجموعة. حاول ثانية.';

  @override
  String get groupAvatarNoImageToSave => 'لا توجد صورة رمزية لحفظها';

  @override
  String groupPhotoPermissionRequired(Object appName) {
    return 'اسمح لـ $appName بالوصول إلى صورك';
  }

  @override
  String get groupImageSavedToAlbum => 'تم الحفظ في الألبوم';

  @override
  String get groupImageSaveFailed => 'فشل الحفظ. حاول ثانية.';

  @override
  String get imageEditorProcessing => 'جارٍ المعالجة...';

  @override
  String get imageEditorDiscardTitle => 'هل تريد تجاهل التعديلات؟';

  @override
  String get imageEditorDiscardMessage => 'سيتم فقدان التعديلات غير المحفوظة.';

  @override
  String get imageEditorDiscardConfirm => 'تجاهل';

  @override
  String get imageEditorPaint => 'رسم';

  @override
  String get imageEditorFreestyle => 'يدوي';

  @override
  String get imageEditorArrow => 'سهم';

  @override
  String get imageEditorLine => 'السطر';

  @override
  String get imageEditorRectangle => 'مستطيل';

  @override
  String get imageEditorCircle => 'الدائرة';

  @override
  String get imageEditorDashLine => 'خط متقطع';

  @override
  String get imageEditorMoveAndZoom => 'نقل / تكبير';

  @override
  String get imageEditorEraser => 'ممحاة';

  @override
  String get imageEditorLineWidth => 'العرض';

  @override
  String get imageEditorToggleFill => 'املأ';

  @override
  String get imageEditorOpacity => 'العتامة';

  @override
  String get imageEditorUndo => 'تراجع';

  @override
  String get imageEditorRedo => 'إعادة';

  @override
  String get imageEditorInputHint => 'أدخل النص';

  @override
  String get imageEditorText => 'نص';

  @override
  String get imageEditorTextAlign => 'محاذاة';

  @override
  String get imageEditorBackground => 'الخلفية';

  @override
  String get imageEditorFontScale => 'حجم الخط';

  @override
  String get imageEditorCrop => 'اقتصاص';

  @override
  String get imageEditorRotate => 'تدوير';

  @override
  String get imageEditorRatio => 'النسبة';

  @override
  String get imageEditorReset => 'إعادة تعيين';

  @override
  String get imageEditorFlip => 'الوجه';

  @override
  String get imageEditorFilter => 'المرشحات';

  @override
  String get imageEditorFilterNone => 'أصلي';

  @override
  String get imageEditorFilterAddictiveBlue => 'اللون الأزرق الإدماني';

  @override
  String get imageEditorFilterAddictiveRed => 'أحمر مدمن';

  @override
  String get imageEditorFilterAden => 'عدن';

  @override
  String get imageEditorFilterAmaro => 'أمارو';

  @override
  String get imageEditorFilterAshby => 'أشبي';

  @override
  String get imageEditorFilterBrannan => 'برانان';

  @override
  String get imageEditorFilterBrooklyn => 'بروكلين';

  @override
  String get imageEditorFilterCharmes => 'التعويذة';

  @override
  String get imageEditorFilterClarendon => 'كلارندون';

  @override
  String get imageEditorFilterCrema => 'كريما';

  @override
  String get imageEditorFilterDogpatch => 'دوغباتش';

  @override
  String get imageEditorFilterEarlybird => 'إيرلي بيرد';

  @override
  String get imageEditorFilterGingham => 'القماش القطني';

  @override
  String get imageEditorFilterGinza => 'جينزا';

  @override
  String get imageEditorFilterHefe => 'هيفي';

  @override
  String get imageEditorFilterHelena => 'هيلينا';

  @override
  String get imageEditorFilterHudson => 'هدسون';

  @override
  String get imageEditorFilterInkwell => 'محبرة';

  @override
  String get imageEditorFilterJuno => 'جونو';

  @override
  String get imageEditorFilterKelvin => 'كلفن';

  @override
  String get imageEditorFilterLark => 'لارك';

  @override
  String get imageEditorFilterLoFi => 'لو فاي';

  @override
  String get imageEditorFilterLudwig => 'لودفيج';

  @override
  String get imageEditorFilterMaven => 'مخضرم';

  @override
  String get imageEditorFilterMayfair => 'مايفير';

  @override
  String get imageEditorFilterMoon => 'القمر';

  @override
  String get imageEditorFilterNashville => 'ناشفيل';

  @override
  String get imageEditorFilterPerpetua => 'بيربيتوا';

  @override
  String get imageEditorFilterReyes => 'رييس';

  @override
  String get imageEditorFilterRise => 'صعود';

  @override
  String get imageEditorFilterSierra => 'سييرا';

  @override
  String get imageEditorFilterSkyline => 'الأفق';

  @override
  String get imageEditorFilterSlumber => 'سبات';

  @override
  String get imageEditorFilterStinson => 'ستينسون';

  @override
  String get imageEditorFilterSutro => 'سوترو';

  @override
  String get imageEditorFilterToaster => 'محمصة';

  @override
  String get imageEditorFilterValencia => 'فالنسيا';

  @override
  String get imageEditorFilterVesper => 'صلاة الغروب';

  @override
  String get imageEditorFilterWalden => 'والدن';

  @override
  String get imageEditorFilterWillow => 'الصفصاف';

  @override
  String get imageEditorBlur => 'طمس';

  @override
  String get imageEditorTune => 'ضبط';

  @override
  String get imageEditorBrightness => 'السطوع';

  @override
  String get imageEditorContrast => 'التباين';

  @override
  String get imageEditorSaturation => 'التشبع';

  @override
  String get imageEditorExposure => 'التعرض';

  @override
  String get imageEditorHue => 'هوى';

  @override
  String get imageEditorTemperature => 'درجة الحرارة';

  @override
  String get imageEditorSharpness => 'الحدة';

  @override
  String get imageEditorFade => 'يتلاشى';

  @override
  String get imageEditorLuminance => 'النصوع';

  @override
  String get imageEditorEmoji => 'رمز تعبيري';

  @override
  String get imageEditorEmojiRecent => 'الأخيرة';

  @override
  String get imageEditorEmojiSmileys => 'الوجوه الضاحكة';

  @override
  String get imageEditorEmojiAnimals => 'الحيوانات';

  @override
  String get imageEditorEmojiFood => 'الطعام';

  @override
  String get imageEditorEmojiActivities => 'الأنشطة';

  @override
  String get imageEditorEmojiTravel => 'السفر';

  @override
  String get imageEditorEmojiObjects => 'الكائنات';

  @override
  String get imageEditorEmojiSymbols => 'الرموز';

  @override
  String get imageEditorEmojiFlags => 'أعلام';

  @override
  String get imageEditorSticker => 'ملصقات';

  @override
  String get imageEditorRemove => 'إزالة';

  @override
  String get imageEditorSaving => 'جاري الحفظ...';

  @override
  String get imageEditorImporting => 'جارٍ الاستيراد';

  @override
  String get imagePreviewTitle => 'معاينة الصورة';

  @override
  String get imagePreviewSavingToAlbum => 'جاري الحفظ...';

  @override
  String get imagePreviewAddToSticker => 'إضافة إلى الملصقات';

  @override
  String get imagePreviewAddingToSticker => 'جارٍ الإضافة...';

  @override
  String get imagePreviewRecognizeQr => 'التعرف على رمز QR';

  @override
  String get imagePreviewRecognizingQr => 'جارٍ التعرف على...';

  @override
  String get imagePreviewConfirmWebLogin => 'تأكيد Web تسجيل الدخول';

  @override
  String get imagePreviewConfirmingWebLogin => 'جارٍ التأكيد...';

  @override
  String get imagePreviewOpenLink => 'افتح الرابط';

  @override
  String get imagePreviewImageNotDownloadedSave => 'لم يتم تنزيل الصورة بعد';

  @override
  String get imagePreviewMediaUnavailable => 'خدمة الوسائط غير متاحة';

  @override
  String get imagePreviewImageNotUploadedSticker => 'لم يتم تحميل الصورة بعد';

  @override
  String get imagePreviewStickerUnavailable => 'خدمة الملصقات غير متاحة';

  @override
  String get imagePreviewAddedToSticker => 'تمت الإضافة إلى الملصقات';

  @override
  String get imagePreviewImageNotDownloadedRecognize =>
      'لم يتم تنزيل الصورة بعد';

  @override
  String get imagePreviewQrNotFound => 'لم يتم العثور على رمز QR';

  @override
  String get imagePreviewWebLoginQrRecognized =>
      'Web تم التعرف على رمز الاستجابة السريعة لتسجيل الدخول';

  @override
  String get imagePreviewWebLinkRecognized => 'Web تم التعرف على الرابط';

  @override
  String get imagePreviewQrRecognized => 'تم التعرف على رمز الاستجابة السريعة';

  @override
  String get imagePreviewWebLoginConfirmed => 'Web تم تأكيد تسجيل الدخول';

  @override
  String get pickerFileTitle => 'اختر ملف';

  @override
  String get pickerRecentFiles => 'الملفات الأخيرة';

  @override
  String get pickerSampleProjectFile => 'ملاحظات المشروع.pdf';

  @override
  String get pickerSampleProjectFileSubtitle => '128 كيلو بايت · اليوم';

  @override
  String get pickerSampleScreenshotFile => 'لقطة شاشة للدردشة.png';

  @override
  String get pickerSampleScreenshotFileSubtitle => '2.4 ميغابايت · أمس';

  @override
  String get pickerContactTitle => 'اختر جهة اتصال';

  @override
  String get pickerContactCardSection => 'إرسال بطاقة جهة الاتصال';

  @override
  String get pickerSearchContacts => 'البحث في جهات الاتصال';

  @override
  String get pickerNoMatchingContacts => 'لا توجد جهات اتصال مطابقة';

  @override
  String get chatSendFailedShort => 'فشل الإرسال';

  @override
  String get chatResend => 'إعادة الإرسال';

  @override
  String get chatStatusRead => 'اقرأ';

  @override
  String get pinnedMessageTitle => 'الرسالة المثبتة';

  @override
  String pinnedMessageTitleWithIndex(int index, int total) {
    return 'الرسالة المثبتة $index/$total';
  }

  @override
  String get pinnedMessageOpen => 'انقر للعرض';

  @override
  String get pinnedMessageViewAllTooltip => 'عرض الكل المثبت';

  @override
  String get pinnedMessageUnpinTooltip => 'إزالة التثبيت';

  @override
  String pinnedMessageListCount(int count) {
    return '$count الرسائل المثبتة';
  }

  @override
  String get pinnedMessageClearAll => 'قم بإزالة تثبيت الكل';

  @override
  String get pinnedMessageFallback => 'الرسالة المثبتة';

  @override
  String get fileUnnamed => 'ملف بدون عنوان';

  @override
  String get fileNoDownloadUrl => 'لا يوجد رابط للتحميل متاح';

  @override
  String get fileTitle => 'ملف';

  @override
  String fileSizeLabel(String size) {
    return 'حجم الملف: $size';
  }

  @override
  String get fileDownloadFailed => 'فشل التنزيل';

  @override
  String get filePreview => 'معاينة';

  @override
  String get fileOpenWithOtherApp => 'مفتوح في تطبيق آخر';

  @override
  String get actionEnable => 'تمكين';

  @override
  String get actionDisable => 'تعطيل';

  @override
  String get profileInviteLoading => 'جارٍ تحميل رمز الدعوة';

  @override
  String get profileInviteEnabled => 'تم تمكين رمز الدعوة';

  @override
  String get profileInviteDisabled => 'تم تعطيل رمز الدعوة';

  @override
  String profileInviteLoadFailed(String error) {
    return 'فشل تحميل رمز الدعوة: $error';
  }

  @override
  String get profileInviteCopied => 'منقول';

  @override
  String profileInviteUpdateFailed(String error) {
    return 'فشل تحديث رمز الدعوة: $error';
  }

  @override
  String get stickerStoreTitle => 'متجر الملصقات';

  @override
  String get stickerNoPacks => 'لا توجد حزم ملصقات';

  @override
  String get stickerDetailTitle => 'تفاصيل الملصق';

  @override
  String get stickerProcessing => 'جارٍ المعالجة...';

  @override
  String get stickerAddCustomTitle => 'إضافة ملصق مخصص';

  @override
  String get stickerSortTitle => 'فرز الملصقات';

  @override
  String get stickerMyStickersTitle => 'ملصقاتي';

  @override
  String get stickerSaving => 'الحفظ';

  @override
  String get stickerSortAction => 'فرز';

  @override
  String get stickerOrganize => 'تنظيم';

  @override
  String get stickerCustomTitle => 'ملصقات مخصصة';

  @override
  String get stickerCustomSubtitle => 'إدارة الملصقات المخصصة المحفوظة';

  @override
  String get stickerNoSortablePacks => 'لا توجد حزم ملصقات لفرزها';

  @override
  String get stickerNoCategories => 'لا توجد فئات ملصقات';

  @override
  String get stickerMoveUp => 'تحرك للأعلى';

  @override
  String get stickerMoveDown => 'تحرك للأسفل';

  @override
  String get stickerNoCustomStickers => 'لا توجد ملصقات مخصصة';

  @override
  String get stickerMoveToFront => 'الانتقال إلى الأمام';

  @override
  String get stickerDeleteConfirmTitle => 'لا يمكن استعادة الملصقات المحذوفة';

  @override
  String get complaintTitle => 'تقرير';

  @override
  String get complaintHint => 'قم بوصف المشكلة';

  @override
  String get complaintType => 'نوع التقرير';

  @override
  String get complaintSubmitted => 'تم إرسال التقرير';

  @override
  String get complaintSubmit => 'إرسال التقرير';

  @override
  String get complaintSubmitting => 'جارٍ الإرسال...';

  @override
  String get complaintFallbackOtherViolation => 'انتهاك آخر للسياسة';

  @override
  String get complaintFallbackFraud => 'عمليات احتيال أو احتيال أخرى';

  @override
  String get complaintFallbackAccountCompromised => 'قد يتم اختراق الحساب';

  @override
  String get chatBackgroundTitle => 'خلفية الدردشة';

  @override
  String get chatBackgroundLoading => 'تحميل خلفيات الدردشة';

  @override
  String get chatBackgroundEmpty => 'لا توجد خلفيات دردشة';

  @override
  String get chatBackgroundDefault => 'الخلفية الافتراضية';

  @override
  String chatBackgroundItem(int index) {
    return 'الخلفية $index';
  }

  @override
  String get chatBackgroundPreviewTitle => 'معاينة الخلفية';

  @override
  String get chatBackgroundSet => 'تعيين الخلفية';

  @override
  String get chatBackgroundSelectedStatus => 'مجموعة خلفية الدردشة';

  @override
  String get chatBackgroundInUse => 'قيد الاستخدام';

  @override
  String get chatContactFallback => 'جهة الاتصال';

  @override
  String get chatPersonalCard => 'بطاقة الاتصال';

  @override
  String get chatSystemMessageDigest => '[رسالة النظام]';

  @override
  String get chatMessageDigestMessage => '[رسالة]';

  @override
  String get chatMessageDigestImage => '[صورة]';

  @override
  String get chatMessageDigestVoice => '[صوت]';

  @override
  String get chatMessageDigestVideo => '[فيديو]';

  @override
  String get chatMessageDigestLocation => '[الموقع]';

  @override
  String get chatMessageDigestCard => '[بطاقة جهة الاتصال]';

  @override
  String get chatMessageDigestFile => '[ملف]';

  @override
  String get chatMessageDigestHistory => '[سجل الدردشة]';

  @override
  String get chatMessageDigestSticker => '[ملصق]';

  @override
  String get dateWeekdayShortMonday => 'الإثنين';

  @override
  String get dateWeekdayShortTuesday => 'الثلاثاء';

  @override
  String get dateWeekdayShortWednesday => 'الأربعاء';

  @override
  String get dateWeekdayShortThursday => 'الخميس';

  @override
  String get dateWeekdayShortFriday => 'الجمعة';

  @override
  String get dateWeekdayShortSaturday => 'السبت';

  @override
  String get dateWeekdayShortSunday => 'الشمس';

  @override
  String get appIconClassic => 'كلاسيكي';

  @override
  String get appIconSimple => 'بسيط';

  @override
  String get appIconDark => 'داكن';

  @override
  String get appIconFestive => 'احتفالي';

  @override
  String get appIconGradient => 'التدرج';

  @override
  String get appIconUpdated => 'تم تحديث الأيقونة';

  @override
  String get appIconUpdateFailed => 'فشل التبديل. حاول مرة أخرى لاحقًا.';

  @override
  String get appearanceBubbleColorPurple => 'أرجواني';

  @override
  String get appearanceBubbleColorGreen => 'أخضر';

  @override
  String get appearanceBubbleColorBlue => 'أزرق';

  @override
  String get appearanceBubbleColorOrange => 'برتقالي';

  @override
  String get appearanceBubbleColorPink => 'وردي';

  @override
  String replyPreviewTitle(String name) {
    return 'الرد على $name';
  }

  @override
  String get replyPreviewCancel => 'إلغاء الرد';

  @override
  String get chatPasswordTitle => 'كلمة مرور الدردشة';

  @override
  String get chatPasswordHint => 'أدخل كلمة المرور المكونة من 6 أرقام';

  @override
  String chatPasswordErrorRemain(int remain) {
    return 'كلمة مرور خاطئة. سيتم مسح سجل الدردشة بعد $remain من المحاولات الفاشلة الأخرى.';
  }

  @override
  String get emojiPackEmpty => 'لا توجد ملصقات في هذه الحزمة';

  @override
  String get emojiRecentSection => 'الأخيرة';

  @override
  String get emojiAllSection => 'جميع الرموز التعبيرية';

  @override
  String get stickerSearching => 'جاري البحث...';

  @override
  String get stickerNoSearchResults => 'لا توجد نتائج';

  @override
  String get stickerSearchResultsTitle => 'النتائج:';

  @override
  String get homeChatPasswordWiped =>
      'عدد كبير جدًا من المحاولات الخاطئة. تم حذف سجل الدردشة.';

  @override
  String get homeGroupNotFound => 'لم يتم العثور على الدردشة الجماعية';

  @override
  String get homeConversationNoHistory => 'لا يوجد سجل للدردشة';

  @override
  String get homeConversationStartChat => 'ابدأ الدردشة';

  @override
  String get homeEnterGroupChat => 'أدخل الدردشة الجماعية';

  @override
  String get homeNewGroup => 'دردشة جماعية جديدة';

  @override
  String homeFriendRequestAcceptFailed(String error) {
    return 'فشل القبول: $error';
  }

  @override
  String get homeFriendRequestAccepted => 'تم قبول طلب الصداقة';

  @override
  String homeFriendRequestRefuseFailed(String error) {
    return 'فشل الرفض: $error';
  }

  @override
  String homeFriendRequestDeleteFailed(String error) {
    return 'فشل الحذف: $error';
  }

  @override
  String contactPresenceOnlineWithDevice(String device) {
    return 'متاح على الإنترنت على $device';
  }

  @override
  String contactPresenceJustOnlineWithDevice(String device) {
    return 'متاح على $device الآن';
  }

  @override
  String contactPresenceMinutesOnlineWithDevice(int minutes, String device) {
    return 'Online on $device $minutes min ago';
  }

  @override
  String contactPresenceLastOnline(String time) {
    return 'آخر اتصال $time';
  }

  @override
  String get contactPresenceDeviceWeb => 'الويب';

  @override
  String get contactPresenceDeviceDesktop => 'سطح المكتب';

  @override
  String get contactPresenceDeviceMobile => 'جوال';

  @override
  String get botCommandsEmpty => 'لا توجد أوامر بعد';
}
