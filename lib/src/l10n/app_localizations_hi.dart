// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get tabMessages => 'चैट';

  @override
  String get tabContacts => 'संपर्क';

  @override
  String get tabDiscover => 'खोजें';

  @override
  String get tabMe => 'मैं';

  @override
  String get pageMessagesTitle => 'चैट';

  @override
  String get pageContactsTitle => 'संपर्क';

  @override
  String get pageDiscoverTitle => 'खोजें';

  @override
  String get pageMeTitle => 'मैं';

  @override
  String get actionCancel => 'रद्द करें';

  @override
  String get actionConfirm => 'पुष्टि करें';

  @override
  String get actionDone => 'हो गया';

  @override
  String get actionSave => 'सहेजें';

  @override
  String get actionDelete => 'हटाएं';

  @override
  String get actionEdit => 'संपादित करें';

  @override
  String get actionAdd => 'जोड़ें';

  @override
  String get actionRemove => 'हटाएं';

  @override
  String get actionInvite => 'आमंत्रित करें';

  @override
  String get actionSearch => 'खोजें';

  @override
  String get actionSend => 'भेजें';

  @override
  String get actionRetry => 'पुनः प्रयास करें';

  @override
  String get actionBack => 'वापस';

  @override
  String get actionMore => 'अधिक';

  @override
  String get actionJoin => 'शामिल हों';

  @override
  String get actionSkip => 'छोड़ें';

  @override
  String get actionContinue => 'जारी रखें';

  @override
  String get actionGetStarted => 'प्रारंभ करें';

  @override
  String get actionSaving => 'सहेजा जा रहा है...';

  @override
  String get moduleUnsupported => 'यह सुविधा इस संस्करण में उपलब्ध नहीं है';

  @override
  String get moduleLoading =>
      'सुविधा पहुंच की जाँच की जा रही है। बाद में पुन: प्रयास।';

  @override
  String get moduleOfflineStale =>
      'सुविधा पहुंच की पुष्टि करने के लिए नेटवर्क से कनेक्ट करें';

  @override
  String get onboardingMenuTitle => 'त्वरित मार्गदर्शिका';

  @override
  String onboardingChatTitle(Object appName) {
    return '$appName में आपका स्वागत है';
  }

  @override
  String get onboardingChatSubtitle =>
      'अधिक आरामदायक बातचीत के लिए एक साफ, रोशनी वाली जगह।';

  @override
  String get onboardingFriendsTitle => 'संपर्क में रहना आसान बनाएं';

  @override
  String get onboardingFriendsSubtitle =>
      'मित्रों, समूहों और साझाकरण को ढूंढना आसान है।';

  @override
  String get onboardingSecurityTitle =>
      'खुलकर बोलें। इसे आत्मविश्वास के साथ प्रयोग करें.';

  @override
  String get onboardingSecuritySubtitle =>
      'खाता सुरक्षा और गोपनीयता सुरक्षा आपकी सीमाओं की रक्षा करने में मदद करती है।';

  @override
  String get onboardingChatSemantic => 'संदेश सिंक ऑनबोर्डिंग चित्रण';

  @override
  String get onboardingFriendsSemantic => 'चित्रण में शामिल मित्र और समूह';

  @override
  String get onboardingSecuritySemantic =>
      'सुरक्षा और गोपनीयता ऑनबोर्डिंग चित्रण';

  @override
  String get settingsLanguageRow => 'भाषा';

  @override
  String get settingsLanguageSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get settingsLanguageZh => 'ठीक है';

  @override
  String get settingsLanguageEn => 'अंग्रेजी';

  @override
  String get profileRowFavorites => 'पसंदीदा';

  @override
  String get profileRowSecurityPrivacy => 'सुरक्षा एवं गोपनीयता';

  @override
  String get profileRowNotifications => 'सूचनाएं';

  @override
  String get profileRowInviteCode => 'आमंत्रण कोड';

  @override
  String get profileRowGeneral => 'सामान्य';

  @override
  String profileRowAbout(Object appName) {
    return '$appName के बारे में';
  }

  @override
  String get profileLogout => 'लॉग आउट करें';

  @override
  String get profileLogoutConfirm =>
      'लॉग आउट करने से कोई इतिहास नहीं हटेगा। आप किसी भी समय इस खाते से वापस साइन इन कर सकते हैं।';

  @override
  String profileMoyuIdLabel(Object appName, Object value) {
    return '$appName आईडी: $value';
  }

  @override
  String get profileDefaultName => 'मैं';

  @override
  String get profileDetailTitle => 'प्रोफ़ाइल';

  @override
  String get profileAvatar => 'अवतार';

  @override
  String get profileNickname => 'उपनाम';

  @override
  String get profileEditNickname => 'उपनाम संपादित करें';

  @override
  String profileEditFoxId(Object appName) {
    return '$appName आईडी संपादित करें';
  }

  @override
  String get profileGender => 'लिंग';

  @override
  String get profileGenderMale => 'पुरुष';

  @override
  String get profileGenderFemale => 'महिला';

  @override
  String get profileGenderSelected => 'चयनित';

  @override
  String get profileGenderUnset => 'सेट नहीं है';

  @override
  String get profilePhoneUnbound => 'लिंक नहीं किया गया';

  @override
  String get profileAvatarUpdated => 'अवतार अपडेट किया गया';

  @override
  String get profileAvatarUpdateFailed =>
      'अवतार अपलोड करने में विफल. पुनः प्रयास करें।';

  @override
  String get generalPageTitle => 'सामान्य';

  @override
  String get generalFontSize => 'फ़ॉन्ट आकार';

  @override
  String get generalChatBackground => 'चैट पृष्ठभूमि';

  @override
  String get generalDarkMode => 'डार्क मोड';

  @override
  String get generalClearCache => 'कैश साफ़ करें';

  @override
  String get generalClearMessages => 'चैट इतिहास साफ़ करें';

  @override
  String get generalAppModules => 'विशेषताएँ';

  @override
  String get generalErrorLogs => 'त्रुटि लॉग';

  @override
  String get generalThirdShare => 'तृतीय-पक्ष SDKs';

  @override
  String get fontSizeSmall => 'छोटा';

  @override
  String get fontSizeStandard => 'मानक';

  @override
  String get fontSizeLarge => 'बड़ा';

  @override
  String get fontSizeExtraLarge => 'अतिरिक्त बड़ा';

  @override
  String get darkModeSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get darkModeLight => 'प्रकाश';

  @override
  String get darkModeDark => 'अंधेरा';

  @override
  String get valueConfigure => 'कॉन्फ़िगर करें';

  @override
  String get valueManage => 'प्रबंधित करें';

  @override
  String get valueClear => 'साफ़ करें';

  @override
  String get valueUpload => 'अपलोड करें';

  @override
  String get valueDownload => 'डाउनलोड करें';

  @override
  String get valueView => 'देखें';

  @override
  String get valueEnabled => 'सक्षम';

  @override
  String get valueDisabled => 'अक्षम';

  @override
  String get valueOn => 'चालू';

  @override
  String get valueOff => 'बंद';

  @override
  String get valueConfigured => 'सेट';

  @override
  String get valueNotEnabled => 'सक्षम नहीं';

  @override
  String get valueSelected => 'चयनित';

  @override
  String get valueCurrentDevice => 'यह उपकरण';

  @override
  String get valueSdkInfo => 'SDK जानकारी';

  @override
  String get statusProcessing => 'प्रसंस्करण';

  @override
  String get statusLoading => 'लोड हो रहा है';

  @override
  String get statusSending => 'भेजा जा रहा है';

  @override
  String get statusSaving => 'सहेजा जा रहा है';

  @override
  String get statusSaved => 'सहेजा गया';

  @override
  String get statusSent => 'भेजा गया';

  @override
  String get statusSubmitted => 'सबमिट किया गया';

  @override
  String get dateJustNow => 'अभी';

  @override
  String get dateToday => 'आज';

  @override
  String get dateYesterday => 'कल';

  @override
  String get dateDayBeforeYesterday => 'परसों';

  @override
  String dateTodayTime(Object time) {
    return 'आज $time';
  }

  @override
  String dateYesterdayTime(Object time) {
    return 'कल $time';
  }

  @override
  String dateDayBeforeYesterdayTime(Object time) {
    return 'दो दिन पहले $time';
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
  String get weekdayMonday => 'सोमवार';

  @override
  String get weekdayTuesday => 'मंगलवार';

  @override
  String get weekdayWednesday => 'बुधवार';

  @override
  String get weekdayThursday => 'गुरुवार';

  @override
  String get weekdayFriday => 'शुक्रवार';

  @override
  String get weekdaySaturday => 'शनिवार';

  @override
  String get weekdaySunday => 'रविवार';

  @override
  String get dialogClearAllTitle => 'सभी चैट इतिहास साफ़ करें?';

  @override
  String get dialogClearAllBody =>
      'सभी स्थानीय चैट इतिहास और वार्तालाप प्रविष्टियाँ हटा दी जाएंगी।';

  @override
  String get authLoginSubtitle =>
      'अपने फ़ोन नंबर से लॉग इन करें और दोस्तों के साथ चैट करते रहें';

  @override
  String get authLoginIllustration => 'लॉगिन चित्रण';

  @override
  String get authRegisterIllustration => 'चित्रण पंजीकृत करें';

  @override
  String get authSecurityIllustration => 'सत्यापन चित्रण';

  @override
  String get authResetIllustration => 'पासवर्ड रीसेट चित्रण';

  @override
  String get authServerLabel => 'सर्वर';

  @override
  String get authServerCustomLabel => 'Custom server';

  @override
  String get authServerCustomHint => 'Enter server address';

  @override
  String get authPhoneLabel => 'फ़ोन नंबर';

  @override
  String get authPasswordLabel => 'पासवर्ड';

  @override
  String get authForgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get authLoginButton => 'लॉग इन करें';

  @override
  String get authLoginLoading => 'लॉग इन हो रहा है...';

  @override
  String get authRegisterButton => 'रजिस्टर करें';

  @override
  String get authLoginWithApple => 'Sign in with Apple';

  @override
  String get authLoginWithGoogle => 'Sign in with Google';

  @override
  String get authLoginWithGithub => 'Sign in with GitHub';

  @override
  String get authLoginAgreementPrefix => 'लॉग इन करके, आप सहमत हैं';

  @override
  String get authTermsTitle => 'सेवा की शर्तें';

  @override
  String get authAgreementConnector => 'और';

  @override
  String get authPrivacyTitle => 'गोपनीयता नीति';

  @override
  String get authVerifyTitle => 'सत्यापन लॉगिन';

  @override
  String authVerifySubtitleWithPhone(Object phone) {
    return '$phone पर भेजा गया कोड दर्ज करें';
  }

  @override
  String get authVerifySubtitlePasswordFirst =>
      'सुरक्षा सत्यापन शुरू करने के लिए सबसे पहले अपने पासवर्ड से लॉग इन करें';

  @override
  String get authVerifyButton => 'सत्यापित करें';

  @override
  String get authVerifyLoading => 'सत्यापित किया जा रहा है...';

  @override
  String get authResendCode => 'कोड नहीं मिला? पुनः भेजें';

  @override
  String get authVerificationCodeSent => 'सत्यापन कोड भेजा गया';

  @override
  String get authVerificationCodeRequired => 'सत्यापन कोड दर्ज करें';

  @override
  String get authVerificationCodeSixDigits => '6 अंकों का कोड दर्ज करें';

  @override
  String get authPasswordResetTitle => 'लॉगिन पासवर्ड रीसेट करें';

  @override
  String get authPasswordResetSubtitle =>
      'अपना फ़ोन नंबर सत्यापित करें, फिर एक नया लॉगिन पासवर्ड सेट करें';

  @override
  String get authPasswordResetButton => 'पासवर्ड रीसेट करें';

  @override
  String get authKickedTitle =>
      'आपका खाता किसी अन्य डिवाइस पर लॉग इन किया गया था।';

  @override
  String get authSubmitting => 'सबमिट किया जा रहा है...';

  @override
  String get authVerificationCodeLabel => 'सत्यापन कोड';

  @override
  String get authGetVerificationCode => 'कोड प्राप्त करें';

  @override
  String get authNewPasswordLabel => 'नया पासवर्ड';

  @override
  String get authPasswordResetSuccess => 'पासवर्ड रीसेट';

  @override
  String authRegisterTitle(Object appName) {
    return 'एक $appName खाता बनाएं';
  }

  @override
  String get authRegisterSubtitle =>
      'अपने फोन नंबर के साथ रजिस्टर करें और तुरंत चैट करना शुरू करें';

  @override
  String get authCreateAccount => 'खाता बनाएं';

  @override
  String get authNicknameLabel => 'उपनाम';

  @override
  String get authInviteCodeRequiredLabel => 'आमंत्रण कोड (आवश्यक)';

  @override
  String authCodeRetryAfter(Object seconds) {
    return '${seconds}s में पुनः प्रयास करें';
  }

  @override
  String get authRegisterAgreement =>
      'मैंने सेवा की शर्तों और गोपनीयता नीति को पढ़ लिया है और उनसे सहमत हूं';

  @override
  String get authInvalidPhone => 'अमान्य फ़ोन नंबर';

  @override
  String get authAcceptAgreementFirst =>
      'कृपया पहले सेवा की शर्तों और गोपनीयता नीति से सहमत हों';

  @override
  String get authCodeEmpty => 'सत्यापन कोड आवश्यक है';

  @override
  String get authPasswordLengthInvalid => 'पासवर्ड 6-16 अक्षर का होना चाहिए';

  @override
  String get authInviteCodeEmpty => 'आमंत्रण कोड आवश्यक है';

  @override
  String get authRegisterSuccess => 'सफलतापूर्वक पंजीकृत';

  @override
  String get settingsCheckNewVersion => 'अपडेट के लिए जाँच करें';

  @override
  String get settingsChecking => 'जाँच हो रही है';

  @override
  String get settingsVersionFound => 'अद्यतन उपलब्ध है';

  @override
  String get settingsUserAgreement => 'सेवा की शर्तें';

  @override
  String get settingsPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get settingsView => 'देखें';

  @override
  String get settingsSwitchAccount => 'खाता स्विच करें';

  @override
  String get settingsCacheCleared => 'कैश साफ़ किया गया';

  @override
  String get settingsClearCacheSheetTitle =>
      'छवि/वीडियो कैश साफ़ करें?\nचैट छवियां, वीडियो कवर और अवतार फिर से डाउनलोड किए जाएंगे।';

  @override
  String get settingsClearCacheAction => 'कैश साफ़ करें';

  @override
  String get settingsMessagesCleared => 'चैट इतिहास साफ़ किया गया';

  @override
  String settingsClearMessagesFailed(Object error) {
    return 'चैट इतिहास साफ़ करने में विफल: $error';
  }

  @override
  String get settingsAlreadyLatestVersion =>
      'आप पहले से ही नवीनतम संस्करण पर हैं';

  @override
  String get settingsCheckFailed => 'जाँच विफल रही';

  @override
  String settingsUpdateDialogTitle(Object version) {
    return 'अपडेट उपलब्ध है\nनवीनतम संस्करण: $version';
  }

  @override
  String settingsUpdateDialogTitleWithDescription(
    Object description,
    Object version,
  ) {
    return 'अपडेट उपलब्ध है\nनवीनतम संस्करण: $version\n$description';
  }

  @override
  String get settingsLater => 'बाद में';

  @override
  String get settingsUpdateNow => 'अभी अपडेट करें';

  @override
  String get settingsSaveFailedRetry => 'सहेजने में विफल. पुनः प्रयास करें।';

  @override
  String get securityAllowPhoneSearch =>
      'दूसरों को फ़ोन नंबर द्वारा मुझे ढूंढने की अनुमति दें';

  @override
  String securityAllowFoxIdSearch(Object appName) {
    return 'दूसरों को $appName आईडी द्वारा मुझे ढूंढने की अनुमति दें';
  }

  @override
  String get securitySearchRemark =>
      'बंद होने पर, अन्य उपयोगकर्ता उपरोक्त जानकारी के माध्यम से आपको नहीं ढूंढ सकते।';

  @override
  String get securityJoinGroupNeedConfirm =>
      'Require confirmation to join groups';

  @override
  String get securityJoinGroupNeedConfirmRemark =>
      'When on, invitations to add you to a group must be confirmed by you first.';

  @override
  String get securityLoginPassword => 'लॉगिन पासवर्ड';

  @override
  String get securityChatPassword => 'चैट पासवर्ड';

  @override
  String get securityScreenProtection => 'स्क्रीन सुरक्षा';

  @override
  String get securityLockPassword => 'पासवर्ड लॉक करें';

  @override
  String get securityOfflineProtection => 'ऑफ़लाइन स्क्रीन लॉक';

  @override
  String get securityDeviceManagement => 'लॉगिन डिवाइस प्रबंधन';

  @override
  String get securityDeviceRemark =>
      'डिवाइस देखें और प्रबंधित करें, लॉगिन सुरक्षा सक्षम करें और अपना खाता सुरक्षित रखें।';

  @override
  String get securityBlacklist => 'ब्लैकलिस्ट';

  @override
  String get securityAccountDeletion => 'खाता हटाएं';

  @override
  String get accountDeletionBody =>
      'खाता विलोपन पूर्ववत नहीं किया जा सकता. पुष्टि के बाद, पूर्ण विलोपन के लिए एक सत्यापन कोड एसएमएस द्वारा भेजा जाएगा।';

  @override
  String get accountDeletionSubmitted => 'हटाने का अनुरोध सबमिट किया गया';

  @override
  String get accountDeletionGetCode => 'कोड प्राप्त करें';

  @override
  String get passwordResetInstruction =>
      'अपना लॉगिन पासवर्ड बदलने के लिए एक एसएमएस कोड की आवश्यकता होती है। नया पासवर्ड कम से कम 6 अक्षर का होना चाहिए।';

  @override
  String get accountPhoneLabel => 'फ़ोन नंबर';

  @override
  String get passwordRuleLabel => 'पासवर्ड नियम';

  @override
  String get passwordAtLeastSix => 'कम से कम 6 अक्षर';

  @override
  String get passwordConfirmLabel => 'पासवर्ड की पुष्टि करें';

  @override
  String get passwordConfirmHint => 'लॉगिन पासवर्ड दोबारा दर्ज करें';

  @override
  String get passwordChanged => 'लॉगिन पासवर्ड बदल गया';

  @override
  String get phoneRequired => 'फ़ोन नंबर आवश्यक है';

  @override
  String get passwordMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get chatPasswordInstruction =>
      'सक्षम होने पर, संरक्षित चैट खोलने से पहले इस 6 अंकों के पासवर्ड की आवश्यकता होती है।';

  @override
  String get currentStatusLabel => 'वर्तमान स्थिति';

  @override
  String get passwordSixDigits => '6 अंक';

  @override
  String get chatPasswordEnableAction => 'चैट पासवर्ड सक्षम करें';

  @override
  String get loginPasswordRequired => 'लॉगिन पासवर्ड आवश्यक है';

  @override
  String get chatPasswordSixDigitsRequired =>
      'चैट पासवर्ड 6 अंकों का होना चाहिए';

  @override
  String get lockSetTitle => '6 अंकों का लॉक पासवर्ड सेट करें';

  @override
  String lockSetSubtitle(Object appName) {
    return 'अनलॉक करने के लिए आवश्यक $appName';
  }

  @override
  String get lockCurrentPromptTitle => 'वर्तमान लॉक पासवर्ड दर्ज करें';

  @override
  String get lockCurrentPromptSubtitle =>
      'इसे बदलने या बंद करने से पहले सत्यापित करें';

  @override
  String get lockAutoLock => 'ऑटो लॉक';

  @override
  String get lockChangePassword => 'अनलॉक पासवर्ड बदलें';

  @override
  String get lockClosePassword => 'अनलॉक पासवर्ड बंद करें';

  @override
  String get lockWrongPassword => 'ग़लत पासवर्ड. पुनः प्रयास करें।';

  @override
  String get lockSixDigitsRequired => 'लॉक पासवर्ड 6 अंकों का होना चाहिए';

  @override
  String get lockInputTitle => 'लॉक पासवर्ड दर्ज करें';

  @override
  String lockInputSubtitle(Object appName) {
    return '$appName का उपयोग जारी रखने के लिए अनलॉक करें';
  }

  @override
  String get lockSetFailed => 'सेट करने में विफल. पुनः प्रयास करें।';

  @override
  String get lockImmediately => 'तुरंत';

  @override
  String get lockAfter5Minutes => '5 मिनट की दूरी के बाद';

  @override
  String get lockAfter30Minutes => '30 मिनट की दूरी के बाद';

  @override
  String get lockAfter1Hour => '1 घंटे की दूरी के बाद';

  @override
  String get deviceLoginProtection => 'लॉगिन सुरक्षा';

  @override
  String get deviceProtectionRemark =>
      'जब लॉगिन सुरक्षा सक्षम होती है, तो अपरिचित उपकरणों पर सुरक्षा सत्यापन आवश्यक होता है। खाता सुरक्षा के लिए अनुशंसित.';

  @override
  String get deviceNone => 'कोई लॉग-इन डिवाइस नहीं';

  @override
  String get deviceDebugName => 'वर्तमान डिवाइस';

  @override
  String get deviceDebugPlatform => 'iPhone/Android डिबग डिवाइस';

  @override
  String get deviceProtectionEnabled => 'लॉगिन सुरक्षा सक्षम';

  @override
  String get deviceProtectionDisabled => 'लॉगिन सुरक्षा अक्षम';

  @override
  String get deviceProtectionUpdateFailed =>
      'लॉगिन सुरक्षा अद्यतन करने में विफल। पुनः प्रयास करें।';

  @override
  String get blacklistEmpty => 'कोई ब्लैकलिस्टेड संपर्क नहीं';

  @override
  String get switchAccountRecent => 'हाल के खाते';

  @override
  String get switchAccountLoading => 'हाल के लेखे पढ़ना';

  @override
  String get switchAccountAddOther => 'अन्य खाता जोड़ें या लॉग इन करें';

  @override
  String get switchAccountCurrent => 'वर्तमान';

  @override
  String get appModulesLoading => 'फीचर मॉड्यूल लोड हो रहा है';

  @override
  String get appModulesEmpty => 'कोई फीचर मॉड्यूल नहीं';

  @override
  String get appModulesUnavailable => 'मॉड्यूल अनुपलब्ध है';

  @override
  String get errorLogsLoading => 'त्रुटि लॉग पढ़ना';

  @override
  String get errorLogsEmpty => 'कोई त्रुटि लॉग नहीं';

  @override
  String get errorLogFileName => 'फ़ाइल नाम';

  @override
  String get errorLogFileSize => 'फ़ाइल का आकार';

  @override
  String get errorLogGeneratedAt => 'पर जेनरेट किया गया';

  @override
  String get errorLogFilePath => 'फ़ाइल पथ';

  @override
  String get notificationReceiveNew => 'नई संदेश सूचनाएं प्राप्त करें';

  @override
  String get notificationSound => 'ध्वनि';

  @override
  String get notificationVibration => 'कंपन';

  @override
  String get notificationShowDetails => 'अधिसूचना विवरण दिखाएं';

  @override
  String get notificationSystem => 'सिस्टम संदेश सूचनाएं';

  @override
  String get notificationCalls => 'ऑडियो/वीडियो कॉल सूचनाएं';

  @override
  String get settingsGoToSystem => 'सेटिंग्स';

  @override
  String aboutAppIconSemantic(Object appName) {
    return '$appName आइकन';
  }

  @override
  String aboutCopyright(Object appName) {
    return 'कॉपीराइट © 2026\n$appName। सर्वाधिकार सुरक्षित।';
  }

  @override
  String get policyWebUrl => 'Web यूआरएल';

  @override
  String get appearanceTitle => 'उपस्थिति';

  @override
  String get appearanceAppIcon => 'ऐप आइकन';

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
  String get appearanceChatColor => 'चैट रंग';

  @override
  String get appearanceBubbleRadius => 'बबल कॉर्नर त्रिज्या';

  @override
  String get appearanceBubbleColorInk => 'स्याही काली';

  @override
  String get appearanceSquare => 'वर्ग';

  @override
  String get appearanceRound => 'राउंड';

  @override
  String get appearancePreviewOne =>
      'क्या वह चाहता है कि मैं दाएँ मुड़ूँ या बाएँ? 🤔';

  @override
  String get appearancePreviewTwo => 'सही। और, ठीक है, इसे मजबूत बनाओ।';

  @override
  String get appearancePreviewThree =>
      'क्या बस इतना ही है? मुझे ऐसा लगता है जैसे उसने इससे भी अधिक कुछ कहा हो। 😯';

  @override
  String get appearancePreviewFour =>
      'बस इतना ही। मैं बाद में अधिक विवरण के साथ एक ध्वनि संदेश भेजूंगा।';

  @override
  String get contactsEmptyTitle => 'अभी तक कोई संपर्क नहीं';

  @override
  String get contactsEmptySubtitle =>
      'ऊपर दाईं ओर से मित्र जोड़ें या प्रोफ़ाइल कार्ड स्कैन करें';

  @override
  String contactsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count संपर्क',
      one: '1 संपर्क',
    );
    return '$_temp0';
  }

  @override
  String get contactAddTooltip => 'मित्र जोड़ें';

  @override
  String get contactSearchHint => 'संपर्क और समूह खोजें';

  @override
  String get contactSetRemark => 'टिप्पणी सेट करें';

  @override
  String get contactAddToBlacklist => 'ब्लैकलिस्ट में जोड़ें';

  @override
  String get contactDeleteFriend => 'मित्र हटाएं';

  @override
  String get contactAddedToBlacklist => 'काली सूची में जोड़ा गया';

  @override
  String get operationFailed => 'ऑपरेशन विफल. पुनः प्रयास करें।';

  @override
  String operationFailedWithError(String error) {
    return 'ऑपरेशन विफल: $error';
  }

  @override
  String contactDeleteFriendConfirm(Object name) {
    return 'मित्र \"$name\" हटाएं?\nचैट इतिहास भी साफ़ कर दिया जाएगा।';
  }

  @override
  String get contactConfirmDelete => 'हटाने की पुष्टि करें';

  @override
  String get contactDeleted => 'मित्र हटा दिया गया';

  @override
  String get contactUnknownUser => 'अज्ञात उपयोगकर्ता';

  @override
  String get contactActionNewFriends => 'नए मित्र';

  @override
  String get contactActionSavedGroups => 'सहेजे गए समूह';

  @override
  String get contactSearchNoMatches => 'कोई मेल खाता संपर्क नहीं';

  @override
  String get addFriendTitle => 'मित्र जोड़ें';

  @override
  String addFriendSearchHint(Object appName) {
    return 'फ़ोन / $appName आईडी';
  }

  @override
  String get addFriendNotFound => 'खाता नहीं मिला';

  @override
  String get myQrCodeTitle => 'मेरा क्यूआर कोड';

  @override
  String myQrCodeSubtitle(Object appName) {
    return 'मुझे $appName पर जोड़ने के लिए इस QR कोड को स्कैन करें';
  }

  @override
  String get myQrCodeEmpty => 'कोई QR कोड नहीं';

  @override
  String get scanTitle => 'स्कैन करें';

  @override
  String get scanQrNotFound => 'कोई QR कोड पहचाना नहीं गया';

  @override
  String scanResolveFailed(String error) {
    return 'QR कोड को पार्स करने में विफल: $error';
  }

  @override
  String get scanUnrecognized => 'इस QR कोड को पहचाना नहीं जा सकता';

  @override
  String get scanInfoIncomplete => 'क्यूआर कोड की जानकारी अधूरी है';

  @override
  String get scanSocialUnavailable => 'समाज सेवा प्रारंभ नहीं की गई है';

  @override
  String get scanJoinedGroup => 'समूह चैट में शामिल हुए';

  @override
  String get scanCannotOpenGroup => 'यह पृष्ठ समूह चैट नहीं खोल सकता';

  @override
  String get scanGroupNotFound => 'समूह चैट नहीं मिली';

  @override
  String get scanOpenGroupFailed => 'समूह चैट खोलने में विफल';

  @override
  String get scanSelfQr => 'यह आपका अपना QR कोड है';

  @override
  String get scanUserNotFound => 'उपयोगकर्ता नहीं मिला';

  @override
  String get scanCameraPermissionRequired => 'कैमरा अनुमति आवश्यक है';

  @override
  String get scanOpenSettings => 'सेटिंग्स खोलें';

  @override
  String get scanCameraUnavailable => 'कैमरा अनुपलब्ध है';

  @override
  String get scanAlbum => 'एल्बम';

  @override
  String get scanLightOn => 'लाइट चालू';

  @override
  String get scanLightOff => 'लाइट बंद';

  @override
  String get scanQrCode => 'क्यूआर कोड';

  @override
  String get scanGroupFallback => 'समूह चैट';

  @override
  String get scanGroupLoadingInfo => 'समूह जानकारी लोड हो रही है';

  @override
  String scanGroupMemberCount(int count) {
    return '$count सदस्य';
  }

  @override
  String get scanJoinGroupConfirm => 'समूह चैट में शामिल हों';

  @override
  String get scanJoining => 'शामिल होना';

  @override
  String get scanJoinGroup => 'समूह चैट में शामिल हों';

  @override
  String scanJoinFailed(String error) {
    return 'शामिल होने में विफल: $error';
  }

  @override
  String get tagsTitle => 'टैग';

  @override
  String get tagsCreateTooltip => 'नया टैग';

  @override
  String get tagsContactSection => 'संपर्क टैग';

  @override
  String get tagsEmptyTitle => 'कोई टैग नहीं';

  @override
  String get tagsEmptySubtitle =>
      'संपर्कों या चैट को समूहीकृत करने के लिए ऊपर दाईं ओर + टैप करें।';

  @override
  String tagsCreateFailed(Object error) {
    return 'टैग बनाने में विफल: $error';
  }

  @override
  String tagsUpdateFailed(Object error) {
    return 'टैग अपडेट करने में विफल: $error';
  }

  @override
  String tagsDeleteFailed(Object error) {
    return 'टैग हटाने में विफल: $error';
  }

  @override
  String tagsLoadFailed(Object error) {
    return 'टैग लोड करने में विफल: $error';
  }

  @override
  String tagsDeleteConfirm(String name) {
    return 'टैग \"$name\" हटाएं?\nइस टैग में मौजूद संपर्क और समूह नहीं हटाए जाएंगे।';
  }

  @override
  String get tagsEditTitle => 'टैग संपादित करें';

  @override
  String get tagsCreateTitle => 'नया टैग';

  @override
  String get tagsNameSection => 'टैग नाम';

  @override
  String get tagsNameHint => 'परिवार, दोस्त';

  @override
  String tagsMembersSection(int count) {
    return 'टैग सदस्य ($count)';
  }

  @override
  String get tagsAddMember => 'सदस्य जोड़ें';

  @override
  String get tagsDelete => 'टैग हटाएं';

  @override
  String get tagsGroupInitial => 'जी';

  @override
  String get tagsUnknownUser => 'अज्ञात उपयोगकर्ता';

  @override
  String get tagsSelectMembersTitle => 'सदस्यों का चयन करें';

  @override
  String tagsDoneCount(int count) {
    return 'हो गया ($count)';
  }

  @override
  String get tagsSearchHint => 'संपर्क या समूह खोजें';

  @override
  String get tagsGroupsSection => 'समूह चैट';

  @override
  String get tagsContactsSection => 'संपर्क';

  @override
  String get tagsNoMatchesTitle => 'कोई मिलान नहीं';

  @override
  String get tagsNoMatchesSubtitle => 'कोई अन्य कीवर्ड आज़माएं';

  @override
  String tagsRowTitle(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get phoneContactsTitle => 'फ़ोन संपर्क';

  @override
  String get phoneContactsSection => 'फ़ोन से संपर्क जोड़ें';

  @override
  String get phoneContactsEmpty => 'कोई फ़ोन संपर्क नहीं';

  @override
  String get phoneContactsNoAddable => 'जोड़ने के लिए कोई फ़ोन संपर्क नहीं';

  @override
  String get phoneContactsServerSyncFailed =>
      'सर्वर सिंक विफल रहा। मौजूदा संपर्क दिखा रहा है.';

  @override
  String get friendAlreadyAdded => 'जोड़ा गया';

  @override
  String get friendRequestSent => 'मित्र अनुरोध भेजा गया';

  @override
  String phoneContactsInviteSmsBody(Object appName) {
    return 'मैं $appName का उपयोग कर रहा हूं। चैट का अनुभव काफी अच्छा है. आओ आप भी प्रयास करें.';
  }

  @override
  String get phoneContactsInviteOpened => 'एसएमएस आमंत्रण खोला गया';

  @override
  String get phoneContactsInviteFailed =>
      'एसएमएस नहीं खुल सकता। कृपया मैन्युअल रूप से आमंत्रित करें.';

  @override
  String get friendRequestsEmptyTitle => 'कोई नया मित्र नहीं';

  @override
  String get friendRequestsEmptySubtitle =>
      'अपने QR कोड को स्कैन करने के लिए मित्रों को आमंत्रित करें';

  @override
  String get friendRequestsPendingSection => 'लंबित';

  @override
  String get friendRequestRefused => 'अस्वीकृत';

  @override
  String contactOpenFromContacts(Object name) {
    return 'संपर्कों से @$name की चैट खोलें';
  }

  @override
  String get fileHelperIntro =>
      'वेब संस्करण में लॉग इन करें और फ़ोन और कंप्यूटर के बीच टेक्स्ट, फ़ोटो, ऑडियो, वीडियो और फ़ाइलें स्थानांतरित करने के लिए मुझे संदेश भेजें।\nसूचनाएं भेजने के लिए';

  @override
  String get fileHelperName => 'File Transfer';

  @override
  String get systemAccountName => 'System';

  @override
  String systemAccountIntro(Object appName) {
    return 'आधिकारिक $appName खाता।';
  }

  @override
  String get contactIntroTitle => 'परिचय';

  @override
  String get contactSource => 'स्रोत';

  @override
  String get contactRemoveFriendRelation => 'मित्र को हटाएं';

  @override
  String get contactRemoveFromBlacklist => 'काली सूची से हटाएँ';

  @override
  String get contactSendMessage => 'संदेश';

  @override
  String get contactAddToContacts => 'संपर्कों में जोड़ें';

  @override
  String get contactRemoveFriendConfirm => 'इस मित्र को हटाएं?';

  @override
  String contactNicknameLine(Object name) {
    return 'उपनाम: $name';
  }

  @override
  String get contactRemoveFromBlacklistConfirm =>
      'इस संपर्क को काली सूची से हटाएं?';

  @override
  String get webLoginTitle => 'Web लॉगिन करें';

  @override
  String get webLoginConfirmTitle => 'वेब लॉगिन की पुष्टि करें?';

  @override
  String get webLoginConfirmBody =>
      'यह आपके खाते को वर्तमान ब्राउज़र या डेस्कटॉप क्लाइंट में लॉग इन करने की अनुमति देगा। यदि यह आप नहीं थे, तो रद्द करें पर टैप करें।';

  @override
  String get webLoginConfirmAction => 'लॉगिन की पुष्टि करें';

  @override
  String get webLoginConfirming => 'पुष्टि की जा रही है...';

  @override
  String get webLoginConfirmed => 'Web लॉगिन की पुष्टि की गई';

  @override
  String webLoginConfirmFailed(Object error) {
    return 'पुष्टिकरण विफल: $error';
  }

  @override
  String get applyFriendTitle => 'मित्र अनुरोध';

  @override
  String get applyFriendSectionTitle => 'मित्र अनुरोध भेजें';

  @override
  String get applyFriendRemarkHint => 'नमस्ते, मैं...';

  @override
  String friendRequestSendFailed(Object error) {
    return 'भेजने में विफल: $error';
  }

  @override
  String get contactRemarkHint => 'टिप्पणी';

  @override
  String get momentPermissionsTitle => 'क्षण गोपनीयता';

  @override
  String get momentHideMineFromContact => 'मेरे लम्हों को उनसे छुपाएं';

  @override
  String get momentHideContactFromMe => 'उनके पलों को मुझसे छुपाएं';

  @override
  String get momentTitle => 'क्षण';

  @override
  String get momentPersonalEmpty => 'अभी तक कोई पोस्ट नहीं';

  @override
  String get momentEmpty => 'अभी तक कोई क्षण नहीं';

  @override
  String get momentCoverUploadFailed => 'कवर अपलोड करने में विफल';

  @override
  String momentCoverUploadFailedWithError(Object error) {
    return 'कवर अपलोड करने में विफल: $error';
  }

  @override
  String get momentDeleteConfirm => 'इस क्षण को हटाएं?';

  @override
  String get momentJustNow => 'अभी';

  @override
  String get momentPublishing => 'Posting…';

  @override
  String get momentPublishFailed => 'Failed to post. Tap to dismiss.';

  @override
  String get momentRemindedYou => 'ने आपको यह क्षण देखने की याद दिलाई';

  @override
  String momentRemindedNames(Object names) {
    return 'याद दिलाया गया $names';
  }

  @override
  String get momentKeepEditingConfirm => 'यह संपादन रखें?';

  @override
  String get momentContinueEditing => 'संपादन जारी रखें';

  @override
  String get momentSaveDraft => 'ड्राफ्ट सहेजें';

  @override
  String get momentDiscardDraft => 'त्यागें';

  @override
  String get momentPublishTitle => 'पोस्ट';

  @override
  String get momentPublishHint => 'आपके मन में क्या है...';

  @override
  String get momentLocationTitle => 'स्थान';

  @override
  String get momentRemindWho => 'याद दिलाएं';

  @override
  String get locationUnsupported => 'इस संस्करण में स्थान उपलब्ध नहीं है';

  @override
  String momentPrivacyContactCount(Object count, Object label) {
    return '$label · $count';
  }

  @override
  String get momentSelectVisibleContacts => 'दृश्यमान संपर्क चुनें';

  @override
  String get momentSelectHiddenContacts => 'छिपे हुए संपर्क चुनें';

  @override
  String get momentPrivacyPublic => 'सार्वजनिक';

  @override
  String get momentPrivacyPrivate => 'निजी';

  @override
  String get momentPrivacyInternal => 'कुछ के लिए दृश्यमान';

  @override
  String get momentPrivacyProhibit => 'से छिपाएँ';

  @override
  String get momentPrivacyWhoCanSee => 'कौन देख सकता है';

  @override
  String momentCommentFailed(Object error) {
    return 'टिप्पणी विफल: $error';
  }

  @override
  String get momentDetailTitle => 'विवरण';

  @override
  String get momentDeleted => 'यह क्षण हटा दिया गया था';

  @override
  String get momentCollapse => 'संक्षिप्त करें';

  @override
  String get momentFullText => 'पूर्ण पाठ';

  @override
  String get momentDeleteCommentConfirm => 'यह टिप्पणी हटाएं?';

  @override
  String get momentCommentPlaceholder => 'टिप्पणी';

  @override
  String momentReplyPlaceholder(Object name) {
    return 'उत्तर दें $name';
  }

  @override
  String get momentLikeAction => 'पसंद है';

  @override
  String get momentCommentAction => 'टिप्पणी';

  @override
  String momentNewMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नए संदेश',
      one: '1 नया संदेश',
    );
    return '$_temp0';
  }

  @override
  String get messagesTitle => 'संदेश';

  @override
  String get messagesEmpty => 'कोई संदेश नहीं';

  @override
  String get messagesEmptyTitle => 'अभी तक कोई संदेश नहीं';

  @override
  String get messagesEmptySubtitle => 'ऊपर दाईं ओर से एक नई चैट प्रारंभ करें';

  @override
  String get messagesNewConversation => 'नया';

  @override
  String get messagesStartGroupChat => 'समूह चैट प्रारंभ करें';

  @override
  String get messagesImDisconnected => 'IM कनेक्ट नहीं है';

  @override
  String get messagesPinned => 'पिन किया गया';

  @override
  String get messagesUnpinned => 'अनपिन किया गया';

  @override
  String get messagesMuted => 'म्यूट किया गया';

  @override
  String get messagesNotificationsOn => 'अधिसूचनाएं चालू';

  @override
  String messagesDeleteConversationTitle(String name) {
    return '\"$name\" हटाएं?';
  }

  @override
  String get messagesConfirmDelete => 'हटाएं';

  @override
  String get messagesCleared => 'चैट इतिहास साफ़ किया गया';

  @override
  String get messagesConversationDeleted => 'वार्तालाप हटा दिया गया';

  @override
  String get messagesUnknownUser => 'अज्ञात उपयोगकर्ता';

  @override
  String get messagesFriendAvatarFallback => 'एफ';

  @override
  String get messagesGroupFallback => 'समूह चैट';

  @override
  String get messagesGroupAvatarFallback => 'जी';

  @override
  String get messagesNewMessageDigest => '[नया संदेश]';

  @override
  String get messagesConversationPin => 'पिन';

  @override
  String get messagesConversationUnpin => 'अनपिन करें';

  @override
  String get messagesConversationMute => 'म्यूट करें';

  @override
  String get messagesConversationUnmute => 'अनम्यूट करें';

  @override
  String get messagesConnectionNoNetwork =>
      'नेटवर्क अनुपलब्ध. अपना कनेक्शन जांचें.';

  @override
  String get messagesConnectionDisconnected => 'डिस्कनेक्ट हो गया';

  @override
  String get messagesConnectionConnecting => 'कनेक्ट हो रहा है';

  @override
  String get messagesConnectionSyncing => 'सिंक हो रहा है';

  @override
  String get globalSearchTitle => 'खोजें';

  @override
  String get globalSearchTabChats => 'चैट';

  @override
  String get globalSearchTabContacts => 'संपर्क';

  @override
  String get globalSearchTabGroups => 'समूह';

  @override
  String get globalSearchTabFiles => 'फ़ाइलें';

  @override
  String get globalSearchContactsSection => 'संपर्क';

  @override
  String get globalSearchGroupsSection => 'समूह चैट';

  @override
  String get globalSearchMessagesSection => 'चैट इतिहास';

  @override
  String get globalSearchFilesSection => 'फ़ाइलें';

  @override
  String get globalSearchNoMatches => 'कोई मिलान नहीं';

  @override
  String get globalSearchNoMore => 'अब कोई परिणाम नहीं';

  @override
  String get locationLocating => 'पता लगाया जा रहा है...';

  @override
  String locationPermissionOff(Object appName) {
    return 'स्थान अनुमति बंद है. सिस्टम सेटिंग्स में स्थान का उपयोग करने के लिए $appName को अनुमति दें।';
  }

  @override
  String get locationPermissionDenied =>
      'स्थान की अनुमति अस्वीकार कर दी गई। आस-पास के स्थान लोड नहीं किए जा सकते.';

  @override
  String get locationMapUnsupported => 'AMap इस प्लेटफ़ॉर्म पर समर्थित नहीं है';

  @override
  String locationFailed(String error) {
    return 'स्थान विफल: $error';
  }

  @override
  String get locationSearchPrompt =>
      'आस-पास के स्थानों को खोजने के लिए कीवर्ड दर्ज करें';

  @override
  String get locationNoNearbyPoi => 'कोई नजदीकी POI नहीं';

  @override
  String get locationSearchHint => 'आस-पास के स्थान खोजें';

  @override
  String get locationPickerTitle => 'स्थान';

  @override
  String get locationSending => 'भेजा जा रहा है';

  @override
  String get locationUnnamed => 'अनाम स्थान';

  @override
  String get locationCopiedAddress => 'पता कॉपी किया गया';

  @override
  String get locationNoMapApp => 'कोई मानचित्र ऐप उपलब्ध नहीं है';

  @override
  String get locationFallbackTitle => 'स्थान';

  @override
  String get locationAmap => 'AMap';

  @override
  String get locationBaiduMap => 'Baidu मानचित्र';

  @override
  String get locationTencentMap => 'Tencent मानचित्र';

  @override
  String get locationAppleMap => 'एप्पल मानचित्र';

  @override
  String get locationOtherMap => 'अन्य मानचित्र';

  @override
  String get locationMyLocation => 'मेरा स्थान';

  @override
  String locationOpenMapFailed(String name) {
    return '$name नहीं खुल सकता';
  }

  @override
  String get locationCopyAddress => 'पता कॉपी करें';

  @override
  String get locationNavigate => 'नेविगेट करें';

  @override
  String get locationViewTitle => 'मानचित्र';

  @override
  String get momentPeerCommentDeleted => 'टिप्पणी हटा दी गई';

  @override
  String get momentDigest => '[क्षण]';

  @override
  String get actionClose => 'बंद करें';

  @override
  String get saveToAlbum => 'एल्बम में सहेजें';

  @override
  String get savedToAlbum => 'एल्बम में सहेजा गया';

  @override
  String get saveFailed => 'सहेजना विफल';

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
    return '$count तस्वीरें';
  }

  @override
  String get momentReplyConnector => 'ने उत्तर दिया';

  @override
  String get groupRemarkTitle => 'समूह टिप्पणी';

  @override
  String get groupRemarkHint =>
      'एक समूह टिप्पणी सेट करें जो केवल आपके लिए दृश्यमान हो';

  @override
  String get chatNotificationSettingsTitle => 'संदेश सूचनाएं';

  @override
  String get chatScreenshotNotification => 'स्क्रीनशॉट सूचनाएं';

  @override
  String get chatRevokeNotification => 'अधिसूचनाएँ याद करें';

  @override
  String get completeProfileTitle => 'पूर्ण प्रोफ़ाइल';

  @override
  String get completeProfileUploadAvatar => 'अवतार अपलोड करें';

  @override
  String get completeProfileReuploadAvatar => 'नया अवतार अपलोड करें';

  @override
  String get completeProfileChooseAvatar => 'एक प्रोफ़ाइल फ़ोटो चुनें';

  @override
  String get completeProfileAvatarUploaded => 'अवतार अपलोड किया गया';

  @override
  String get completeProfileAvatarRequired => 'अवतार आवश्यक है.';

  @override
  String get nicknameLabel => 'उपनाम';

  @override
  String get nicknameInputHint => 'उपनाम दर्ज करें';

  @override
  String get nicknameRequired => 'उपनाम आवश्यक है।';

  @override
  String get completeProfileSaved => 'प्रोफ़ाइल पूर्ण हुई';

  @override
  String get chatSettingsTitle => 'चैट विवरण';

  @override
  String chatSettingsGroupTitle(Object count) {
    return 'चैट जानकारी ($count)';
  }

  @override
  String get chatSettingsGroupName => 'समूह चैट नाम';

  @override
  String get chatSettingsGroupQrCode => 'समूह क्यूआर कोड';

  @override
  String get chatSearchContentTitle => 'चैट खोजें';

  @override
  String get chatSettingsBackground => 'चैट पृष्ठभूमि सेट करें';

  @override
  String get chatSettingsBackgroundSelected => 'वर्तमान चैट पृष्ठभूमि सेट';

  @override
  String get chatSettingsMute => 'सूचनाएं म्यूट करें';

  @override
  String get chatSettingsPin => 'पिन चैट';

  @override
  String get chatSettingsSaveToContacts => 'संपर्कों में सहेजें';

  @override
  String get chatSettingsReadReceipt => 'पढ़ें रसीदें';

  @override
  String get chatSettingsReadReceiptSubtitle =>
      'सक्षम होने पर, भेजे गए संदेश पढ़े गए/अपठित स्थिति दिखाते हैं';

  @override
  String get chatSettingsFlame => 'पढ़ने के बाद जलना';

  @override
  String get chatFlameTipExit =>
      'चैट छोड़ने के बाद पढ़े गए संदेश नष्ट हो जाते हैं';

  @override
  String chatFlameTipMinutes(Object minutes) {
    return 'संदेश पढ़ने के $minutes मिनट बाद नष्ट हो जाते हैं';
  }

  @override
  String chatFlameTipSeconds(Object seconds) {
    return 'संदेश पढ़ने के बाद ${seconds}s नष्ट हो जाते हैं';
  }

  @override
  String chatFlameLabelMinutes(Object minutes) {
    return '$minutes मिनट';
  }

  @override
  String chatFlameLabelSeconds(Object seconds) {
    return '${seconds}s';
  }

  @override
  String get chatSettingsGroupNickname => 'मेरा समूह उपनाम';

  @override
  String get chatSettingsBlacklisted => 'काली सूची में डाला गया';

  @override
  String get chatSettingsPeerBlacklisted =>
      'यह संपर्क पहले से ही ब्लैकलिस्टेड है';

  @override
  String get chatSettingsComplaint => 'प्रतिवेदन';

  @override
  String get chatSettingsDeleteAndExit => 'हटाएं और बाहर निकलें';

  @override
  String groupRemarkSyncFailed(Object error) {
    return 'समूह टिप्पणी सिंक करने में विफल: $error';
  }

  @override
  String get chatSocialDisconnected => 'समाज सेवा कनेक्ट नहीं है';

  @override
  String get chatNoRemovableMembers => 'कोई हटाने योग्य सदस्य नहीं';

  @override
  String get chatSelectMembersToRemove => 'हटाने के लिए सदस्यों का चयन करें';

  @override
  String chatMemberNameQuoted(Object name) {
    return '\"$name\"';
  }

  @override
  String chatMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्य',
      one: '1 सदस्य',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersConfirm(Object names) {
    return 'समूह से $names को हटाएं';
  }

  @override
  String chatMembersRemoved(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्यों को हटा दिया गया',
      one: '1 सदस्य को हटाया गया',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersFailed(Object error) {
    return 'सदस्यों को हटाने में विफल: $error';
  }

  @override
  String get chatNoInviteCandidates =>
      'आमंत्रित करने के लिए कोई संपर्क उपलब्ध नहीं है';

  @override
  String get chatInviteMembers => 'सदस्यों को आमंत्रित करें';

  @override
  String get chatSelectContacts => 'संपर्क चुनें';

  @override
  String chatMembersInvited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्यों को आमंत्रित किया गया',
      one: '1 सदस्य को आमंत्रित किया गया',
    );
    return '$_temp0';
  }

  @override
  String chatInviteMembersFailed(Object error) {
    return 'सदस्यों को आमंत्रित करने में विफल: $error';
  }

  @override
  String get chatGroupCreated => 'समूह चैट बनाई गई. चैट सूची जांचें.';

  @override
  String get chatGroupCreateFailed => 'समूह चैट बनाने में विफल';

  @override
  String chatGroupCreateFailedWithError(Object error) {
    return 'समूह चैट बनाने में विफल: $error';
  }

  @override
  String get chatClearCurrentConfirm => 'वर्तमान चैट इतिहास साफ़ करें?';

  @override
  String get chatDeleteAndExitConfirm =>
      'हटाने और बाहर निकलने के बाद, आपको इस समूह से संदेश प्राप्त नहीं होंगे।';

  @override
  String get chatBlockConfirm =>
      'इस संपर्क को ब्लैकलिस्ट में जोड़ने के बाद, आपको उनके संदेश प्राप्त नहीं होंगे।';

  @override
  String get chatSearchTabAll => 'चैट';

  @override
  String get chatSearchTabMedia => 'तस्वीरें/वीडियो';

  @override
  String get chatSearchTabFile => 'फ़ाइलें';

  @override
  String get chatSearchNoMatches => 'कोई मेल खाता चैट इतिहास नहीं';

  @override
  String get chatSearchNoMore => 'अब कोई परिणाम नहीं';

  @override
  String get chatDetailsTooltip => 'चैट विवरण';

  @override
  String get chatVoiceInputTooltip => 'वॉयस इनपुट';

  @override
  String get chatInputHint => 'संदेश...';

  @override
  String get chatFlameEnabledTooltip => 'पढ़ने के बाद जलाना चालू है';

  @override
  String get chatFlameDestroyOnExit => 'चैट छोड़ने के बाद नष्ट कर दें';

  @override
  String chatFlameDestroyAfterMinutes(Object minutes) {
    return '$minutes मिनट के बाद नष्ट करें';
  }

  @override
  String chatFlameDestroyAfterSeconds(Object seconds) {
    return '${seconds}s के बाद नष्ट करें';
  }

  @override
  String chatFlameEnabledNotice(Object label) {
    return 'पढ़ने के बाद जलाना चालू है। पढ़ने के बाद संदेश $label नष्ट हो जाएंगे। इसे बंद करने के लिए शीर्ष-दाईं ओर सेटिंग्स का उपयोग करें।';
  }

  @override
  String get chatEmojiTooltip => 'इमोजी';

  @override
  String get chatActionReply => 'उत्तर दें';

  @override
  String get chatActionCopy => 'कॉपी';

  @override
  String get chatActionTranslate => 'अनुवाद करें';

  @override
  String get chatActionTranscribe => 'प्रतिलेखित करें';

  @override
  String get chatActionForward => 'आगे';

  @override
  String get chatActionFavorite => 'पसंदीदा';

  @override
  String get chatActionPin => 'पिन';

  @override
  String get chatActionUnpin => 'अनपिन करें';

  @override
  String get chatActionAddFriend => 'मित्र जोड़ें';

  @override
  String get chatActionMultiSelect => 'चुनें';

  @override
  String get chatActionEdit => 'संपादित करें';

  @override
  String get chatActionEditImage => 'छवि संपादित करें';

  @override
  String get chatActionRevoke => 'याद करें';

  @override
  String get chatActionDelete => 'हटाएं';

  @override
  String get chatGroupCallActive => 'समूह कॉल प्रगति पर है';

  @override
  String chatMessageRevokedBy(Object name) {
    return '$name ने एक संदेश याद किया';
  }

  @override
  String get chatReedit => 'पुनः संपादित करें';

  @override
  String get chatEditedSuffix => '(संपादित)';

  @override
  String chatActionReadBy(Object count) {
    return '$count द्वारा पढ़ा गया';
  }

  @override
  String chatActionReactedBy(Object count) {
    return '$count प्रतिक्रियाएं';
  }

  @override
  String chatSelectedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'चयनित $count आइटम',
      one: '1 आइटम चयनित',
    );
    return '$_temp0';
  }

  @override
  String get chatNoReactions => 'अभी तक कोई प्रतिक्रिया नहीं';

  @override
  String chatReadStatusReadCount(Object count) {
    return 'पढ़ें ($count)';
  }

  @override
  String get chatNoReadReceipts => 'अभी तक कोई नहीं';

  @override
  String get chatHistoryAbove => 'उपरोक्त पूर्व संदेश';

  @override
  String chatUnreadNewMessages(Object count) {
    return '$count नए संदेश';
  }

  @override
  String get chatUnreadDivider => 'नीचे नये संदेश';

  @override
  String get chatUnknownContentFallback =>
      'यह संस्करण यह संदेश प्रदर्शित नहीं कर सकता. नवीनतम संस्करण में अद्यतन करें.';

  @override
  String get chatMentionSomeone => 'किसी ने आपका उल्लेख किया';

  @override
  String get chatToolAlbum => 'एल्बम';

  @override
  String get chatToolCamera => 'कैमरा';

  @override
  String get chatToolFile => 'फ़ाइल';

  @override
  String get chatToolLocation => 'स्थान';

  @override
  String get chatToolContactCard => 'संपर्क कार्ड';

  @override
  String get chatToolAudioCall => 'वॉयस कॉल';

  @override
  String get chatToolVideoCall => 'वीडियो कॉल';

  @override
  String get chatDraftLabel => '[ड्राफ्ट]';

  @override
  String get visitorBadge => 'आगंतुक';

  @override
  String get chatNoticeDeleted => 'हटाया गया';

  @override
  String get chatNoticeCopied => 'कॉपी किया गया';

  @override
  String get chatMentionLoadedOrInvisible =>
      '@ संदेश लोड हो गया है या दिखाई नहीं दे रहा है। इसे ढूंढने के लिए ऊपर स्क्रॉल करें.';

  @override
  String get chatLocationDefaultTitle => 'स्थान';

  @override
  String get chatLocationCopied => 'स्थान कॉपी किया गया';

  @override
  String get chatReadStatusTitle => 'स्थिति पढ़ें';

  @override
  String get chatReadStatusRead => 'पढ़ें';

  @override
  String get chatReadStatusUnread => 'अपठित';

  @override
  String get chatReadStatusUnavailable =>
      'पूर्ण पढ़ी/अपठित सूचियाँ अभी तक उपलब्ध नहीं हैं';

  @override
  String get chatComposerLeft => 'आपने यह चैट छोड़ दी';

  @override
  String get chatComposerMuted => 'यह चैट म्यूट है';

  @override
  String chatComposerMutedUntil(Object time) {
    return 'आप $time तक म्यूट हैं';
  }

  @override
  String chatFavoriteCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'पसंदीदा $count संदेश',
      one: 'पसंदीदा 1 संदेश',
    );
    return '$_temp0';
  }

  @override
  String chatFavoritePartial(Object failed, Object success) {
    return 'पसंदीदा पूर्ण: $success सफल, $failed विफल';
  }

  @override
  String get chatForwardUnavailable => 'अभी अग्रेषित नहीं किया जा सकता';

  @override
  String chatMergedForwardedTo(Object count, Object name) {
    return '$count संदेशों को $name में मर्ज किया गया';
  }

  @override
  String chatForwardedIndividuallyTo(Object count, Object name) {
    return '$count संदेशों को एक-एक करके $name पर अग्रेषित किया गया';
  }

  @override
  String chatForwardedPartialTo(Object name, Object sent, Object total) {
    return '$sent/$total संदेशों को $name पर अग्रेषित किया गया';
  }

  @override
  String get chatForwardModeIndividual => 'एक-एक करके आगे बढ़ाएं';

  @override
  String get chatForwardModeMerge => 'मर्ज करें और आगे बढ़ाएं';

  @override
  String get chatPresenceOnline => 'ऑनलाइन';

  @override
  String get chatPresenceOffline => 'ऑफ़लाइन';

  @override
  String get chatPresenceJustActive => 'अभी सक्रिय';

  @override
  String chatPresenceMinutesAgo(Object minutes) {
    return 'सक्रिय $minutes मिनट पहले';
  }

  @override
  String chatPresenceHoursAgo(Object hours) {
    return 'सक्रिय $hours घंटा पहले';
  }

  @override
  String chatPresenceDaysAgo(Object days) {
    return '$days दिन पहले सक्रिय';
  }

  @override
  String get chatSensitiveDefaultTip =>
      'इस संदेश में संवेदनशील जानकारी हो सकती है';

  @override
  String get chatMessageDigestFallback => '[संदेश]';

  @override
  String get chatMediaServiceUnavailable => 'मीडिया सेवा तैयार नहीं है';

  @override
  String get chatImDisconnected => 'IM कनेक्ट नहीं है';

  @override
  String get chatPinFailedNotSent =>
      'संदेश सर्वर तक पहुंचने से पहले पिन नहीं किया जा सकता';

  @override
  String get chatPinFailed => 'पिन करने में विफल. पुनः प्रयास करें।';

  @override
  String get chatPinned => 'पिन किया गया';

  @override
  String get chatUnpinFailed => 'अनपिन करने में विफल. पुनः प्रयास करें।';

  @override
  String get chatUnpinned => 'अनपिन किया गया';

  @override
  String get chatClearPinnedConfirm => 'सभी पिन किए गए संदेशों को अनपिन करें?';

  @override
  String get chatClearPinnedAction => 'अनपिन करें';

  @override
  String get chatAllUnpinned => 'सभी पिन किए गए संदेश अनपिन किए गए';

  @override
  String get chatPinnedMessageNotVisible =>
      'यह संदेश दृश्यमान सीमा में नहीं है। इसे सूची से देखें.';

  @override
  String get chatImageMissing => 'छवि जानकारी अनुपलब्ध है';

  @override
  String get chatImageDownloadFailedEdit =>
      'छवि डाउनलोड करने में विफल. संपादित नहीं किया जा सकता.';

  @override
  String get chatReactionFailed => 'प्रतिक्रिया विफल. पुनः प्रयास करें।';

  @override
  String get chatEditNotSynced => 'संपादन विफल: संदेश समन्वयित नहीं है';

  @override
  String get chatEditFailed => 'संपादन विफल. पुनः प्रयास करें।';

  @override
  String get chatFavoriteUnsupportedType =>
      'इस प्रकार को अभी तक पसंदीदा नहीं बनाया जा सकता है';

  @override
  String get chatFavoriteNotSent =>
      'संदेश सर्वर तक नहीं पहुंचा है, इसलिए इसे पसंदीदा नहीं बनाया जा सकता';

  @override
  String get chatFavoriteSuccess => 'पसंदीदा में जोड़ा गया';

  @override
  String get chatFavoriteFailed => 'पसंदीदा बनाने में विफल. पुनः प्रयास करें।';

  @override
  String chatToolSelected(Object title) {
    return 'चयनित $title';
  }

  @override
  String chatCardDigest(Object name) {
    return '[कार्ड] $name';
  }

  @override
  String get chatFriendAvatarFallback => 'एफ';

  @override
  String get chatUnknownMessageDigest => '[अज्ञात]';

  @override
  String chatOpenFromContacts(Object name) {
    return 'संपर्कों से @$name की चैट खोलें';
  }

  @override
  String get chatLoadingCard => 'संपर्क कार्ड लोड हो रहा है...';

  @override
  String get chatFileMissing => 'फ़ाइल जानकारी अनुपलब्ध है';

  @override
  String get chatVideoUnavailable => 'वीडियो नहीं चलाया जा सकता';

  @override
  String get chatVideoSourceEmpty => 'वीडियो स्रोत खाली है';

  @override
  String get chatLivePhotoUnavailable => 'लाइव फ़ोटो नहीं चलाया जा सकता';

  @override
  String get messageAiTranslating => 'अनुवाद हो रहा है...';

  @override
  String get messageAiTranscribedShort => 'हो गया';

  @override
  String get messageAiVoiceSendingWait =>
      'आवाज अभी भी भेजी जा रही है। बाद में पुन: प्रयास।';

  @override
  String get messageAiNoTranscript => 'कोई भाषण पहचाना नहीं गया';

  @override
  String get messageAiMessageSendingWait =>
      'संदेश अभी भी भेजा जा रहा है। बाद में पुन: प्रयास।';

  @override
  String get messageAiNoTranslation => 'कोई अनुवाद परिणाम नहीं';

  @override
  String get messageAiTemporarilyUnavailable => 'अस्थायी रूप से अनुपलब्ध';

  @override
  String get chatVoiceFileUnavailable => 'ध्वनि फ़ाइल अनुपलब्ध है';

  @override
  String get chatVoicePlayFailed => 'प्लेबैक विफल रहा. पुनः प्रयास करें।';

  @override
  String get chatVoiceHoldToRecord =>
      'रिकॉर्ड करने के लिए दबाए रखें · रद्द करने के लिए ऊपर स्लाइड करें';

  @override
  String chatVoiceReleaseToCancel(Object duration) {
    return 'रिलीज़ रद्द करने के लिए ($duration)';
  }

  @override
  String chatVoiceRecordingSlideCancel(Object duration) {
    return '$duration · रद्द करने के लिए ऊपर की ओर स्लाइड करें';
  }

  @override
  String get chatQrcodeNotFound => 'कोई QR कोड पहचाना नहीं गया';

  @override
  String chatWebLoginQrcodeDetected(Object payload) {
    return 'Web लॉगिन QR कोड पहचाना गया\n$payload';
  }

  @override
  String get chatWebLoginConfirmTitle => 'वेब पर लॉगिन की पुष्टि करें?';

  @override
  String get chatWebLoginConfirmAction => 'पुष्टि करें Web लॉगिन';

  @override
  String get chatWebLoginConfirmed => 'Web लॉगिन की पुष्टि की गई';

  @override
  String chatQrcodeDetected(Object payload) {
    return 'QR कोड पहचाना गया\n$payload';
  }

  @override
  String get chatStickerPlaceholder => '[स्टिकर]';

  @override
  String get chatStickerAdded => 'स्टिकर में जोड़ा गया';

  @override
  String get chatStickerAddFailed =>
      'स्टिकर जोड़ने में विफल. पुनः प्रयास करें।';

  @override
  String get mentionAllMembers => 'सभी सदस्य';

  @override
  String get mentionAllMembersSubtitle => 'इस समूह में सभी को सूचित करें';

  @override
  String get chatQuoteOriginalRevoked => 'मूल संदेश वापस ले लिया गया';

  @override
  String get chatRecognizeImageQrcode => 'छवि में QR कोड स्कैन करें';

  @override
  String get chatAddToStickers => 'स्टिकर में जोड़ें';

  @override
  String get chatGroupInviteApprovalUrlEmpty =>
      'समूह आमंत्रण अनुमोदन URL खाली है';

  @override
  String get chatGroupInviteApprovalTitle => 'समूह आमंत्रण अनुमोदन';

  @override
  String get chatGroupInviteApprovalBody =>
      'वेब पेज पर समूह आमंत्रण पुष्टिकरण पूरा करें।';

  @override
  String get chatGroupInviteGoConfirm => 'पुष्टि करें';

  @override
  String get chatGroupInviteApprovalOpenFailed =>
      'समूह आमंत्रण अनुमोदन खोलने में विफल। पुनः प्रयास करें।';

  @override
  String get chatSendFailed => 'भेजने में विफल. पुनः प्रयास करें।';

  @override
  String get chatCallActiveHangupFirst => 'एक कॉल सक्रिय है। पहले फ़ोन रखो.';

  @override
  String get chatCallActiveCannotJoinAgain =>
      'एक कॉल सक्रिय है। दोबारा शामिल नहीं हो सकते.';

  @override
  String get chatCallUnsupported => 'इस संस्करण में कॉल समर्थित नहीं हैं';

  @override
  String get chatCallServiceUnavailable => 'कॉल सेवा तैयार नहीं है';

  @override
  String get chatCallJoinFailedEnded =>
      'शामिल होने में विफल. हो सकता है कि कॉल ख़त्म हो गई हो.';

  @override
  String get callWaitingAnswer => 'उत्तर की प्रतीक्षा में';

  @override
  String get callMessage => 'कॉल संदेश';

  @override
  String get callEnded => 'कॉल समाप्त हुई';

  @override
  String get callPeerRefused => 'सहकर्मी ने मना कर दिया';

  @override
  String get callPeerHungUp => 'सहकर्मी ने फोन रख दिया';

  @override
  String get callPeerDeclinedVideoSwitch =>
      'सहकर्मी ने वीडियो स्विच अनुरोध को अस्वीकार कर दिया';

  @override
  String get callSwitchVideoRequestTitle =>
      'सहकर्मी वीडियो पर स्विच करने का अनुरोध करते हैं';

  @override
  String get callAgree => 'सहमत';

  @override
  String get callReconnecting => 'पुनः कनेक्ट हो रहा है...';

  @override
  String get callWaitingPeerCamera => 'पीयर कैमरे की प्रतीक्षा है';

  @override
  String get callSelfFallbackName => 'मैं';

  @override
  String get callUnknownUser => 'अज्ञात उपयोगकर्ता';

  @override
  String callJoinedCount(int joined, int total) {
    return '$joined/$total शामिल हुए';
  }

  @override
  String get callMute => 'म्यूट करें';

  @override
  String get callSpeaker => 'अध्यक्ष';

  @override
  String get callSwitchToVideo => 'वीडियो';

  @override
  String get callHangup => 'रुको';

  @override
  String get callFlipCamera => 'पलटें';

  @override
  String get callSwitchToVoice => 'ऑडियो';

  @override
  String get callCamera => 'कैमरा';

  @override
  String get callBack => 'वापस';

  @override
  String get callPermissionMicrophone => 'माइक्रोफ़ोन';

  @override
  String get callPermissionMicrophoneCamera => 'माइक्रोफ़ोन और कैमरा';

  @override
  String callPermissionOpenSettings(String what) {
    return 'सिस्टम सेटिंग्स में $what अनुमति सक्षम करें';
  }

  @override
  String callPermissionRequired(String what) {
    return 'कॉल के लिए $what अनुमति की आवश्यकता होती है';
  }

  @override
  String get callWaitingPeerConsent => 'साथियों के अनुमोदन की प्रतीक्षा है';

  @override
  String get callSwitchRequestFailed => 'स्विच अनुरोध भेजने में विफल';

  @override
  String get callCameraPermissionRequired => 'कैमरा अनुमति आवश्यक है';

  @override
  String get callCameraEnableFailed => 'कैमरा चालू करने में विफल';

  @override
  String get incomingCallAccepting => 'उत्तर दे रहा हूं...';

  @override
  String get incomingVideoCall => 'आपको वीडियो कॉल के लिए आमंत्रित करता है';

  @override
  String get incomingAudioCall => 'आपको वॉयस कॉल के लिए आमंत्रित करता है';

  @override
  String incomingAcceptFailed(String error) {
    return 'उत्तर विफल: $error';
  }

  @override
  String get incomingCallDecline => 'अस्वीकार';

  @override
  String get incomingCallAccept => 'उत्तर';

  @override
  String get chatGroupNoInviteCandidates =>
      'आमंत्रित करने के लिए कोई सदस्य उपलब्ध नहीं है';

  @override
  String get chatInviteGroupMembersVideo =>
      'समूह सदस्यों को आमंत्रित करें (वीडियो कॉल)';

  @override
  String get chatInviteGroupMembersAudio =>
      'समूह सदस्यों को आमंत्रित करें (वॉयस कॉल)';

  @override
  String get chatSelfName => 'मैं';

  @override
  String get chatPeerPlaceholder => 'अन्य';

  @override
  String get chatSomeonePlaceholder => 'कोई';

  @override
  String chatScreenshotNotice(Object name) {
    return '$name ने चैट में स्क्रीनशॉट लिया';
  }

  @override
  String chatDuplicateGroupMention(Object name) {
    return 'एकाधिक समूह सदस्य @$name से मेल खाते हैं';
  }

  @override
  String chatDuplicateContactMention(Object name) {
    return 'एकाधिक संपर्क @$name से मेल खाते हैं';
  }

  @override
  String chatMentionNotFound(Object name) {
    return '@$name नहीं मिला';
  }

  @override
  String get chatForwardPickerTitle => 'को अग्रेषित करें';

  @override
  String get chatRecentContactsSection => 'हाल के संपर्क';

  @override
  String chatForwardedTo(Object name) {
    return '$name को अग्रेषित किया गया';
  }

  @override
  String get favoriteTitle => 'पसंदीदा';

  @override
  String get favoriteEmptyTitle => 'कोई पसंदीदा नहीं';

  @override
  String get favoriteEmptySubtitle =>
      'चैट में किसी संदेश को देर तक दबाकर रखें और उसे यहां सहेजने के लिए पसंदीदा चुनें।';

  @override
  String get favoriteDeleted => 'हटाया गया';

  @override
  String favoriteDeleteFailed(Object error) {
    return 'हटाना विफल: $error';
  }

  @override
  String get favoriteDeleteFailedPlain => 'हटाना विफल';

  @override
  String get favoriteUnsupportedSend => 'यह प्रकार अभी नहीं भेजा जा सकता';

  @override
  String favoriteSentTo(String name) {
    return 'को $name पर भेजा गया';
  }

  @override
  String favoriteSendFailed(Object error) {
    return 'भेजना विफल: $error';
  }

  @override
  String get favoriteSendFailedPlain => 'भेजना विफल';

  @override
  String get favoriteSendToFriend => 'मित्र को भेजें';

  @override
  String get favoriteCopied => 'कॉपी किया गया';

  @override
  String get favoriteUnknownUser => 'अज्ञात उपयोगकर्ता';

  @override
  String favoriteDateMonthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String get groupSavedTitle => 'सहेजे गए समूह';

  @override
  String get groupSaveTooltip => 'समूह सहेजें';

  @override
  String get groupSearchHint => 'समूह खोजें';

  @override
  String get groupNoMatched => 'कोई मेल खाने वाला समूह नहीं';

  @override
  String get groupNoSaveCandidatesToast =>
      'सहेजने के लिए कोई समूह उपलब्ध नहीं है';

  @override
  String get groupSavedToContacts => 'संपर्कों में सहेजा गया';

  @override
  String groupSaveFailed(Object error) {
    return 'सहेजने में विफल: $error';
  }

  @override
  String get groupSelectTitle => 'समूह चुनें';

  @override
  String get groupNoSaveCandidates => 'सहेजने के लिए कोई समूह उपलब्ध नहीं है';

  @override
  String get groupCreateTitle => 'समूह चैट प्रारंभ करें';

  @override
  String get groupSearchContactsHint => 'संपर्क खोजें';

  @override
  String get groupNoMatchedContacts => 'कोई मेल खाता संपर्क नहीं';

  @override
  String groupMemberSummary(num count, Object subtitle) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्य',
      one: '1 सदस्य',
    );
    return '$_temp0· $subtitle';
  }

  @override
  String get groupMuted => 'म्यूट किया गया';

  @override
  String get groupDetailsTitle => 'समूह विवरण';

  @override
  String groupMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्य',
      one: '1 सदस्य',
    );
    return '$_temp0';
  }

  @override
  String get groupMembersSection => 'समूह सदस्य';

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
  String get groupNoMembers => 'कोई समूह सदस्य नहीं';

  @override
  String get groupInviteMembers => 'सदस्यों को आमंत्रित करें';

  @override
  String get groupInviteMembersSubtitle => 'संपर्कों में से चुनें';

  @override
  String get groupRemoveMembers => 'सदस्यों को हटाएं';

  @override
  String get groupRemoveMembersEmptySubtitle => 'हटाने के लिए कोई सदस्य नहीं';

  @override
  String get groupRemoveMembersSubtitle => 'हटाने के लिए सदस्यों को चुनें';

  @override
  String get groupQrCodeTitle => 'समूह क्यूआर कोड';

  @override
  String get groupQrCodeSubtitle => 'इस समूह में शामिल होने के लिए स्कैन करें';

  @override
  String get groupNameTitle => 'समूह का नाम';

  @override
  String get groupNoticeTitle => 'समूह घोषणा';

  @override
  String get groupNoticeUnset => 'सेट नहीं है';

  @override
  String get groupManageTitle => 'समूह प्रबंधन';

  @override
  String get groupManageSubtitle => 'व्यवस्थापक, म्यूट और समूह अनुमतियाँ';

  @override
  String get groupInviteConfirm => 'पुष्टिकरण को आमंत्रित करें';

  @override
  String get groupBlacklistTitle => 'ग्रुप ब्लैकलिस्ट';

  @override
  String get groupBlacklistSubtitle =>
      'बोलने या शामिल होने से रोके गए सदस्यों को प्रबंधित करें';

  @override
  String get groupSaveToContacts => 'संपर्कों में सहेजें';

  @override
  String get groupMuteMessages => 'सूचनाएं म्यूट करें';

  @override
  String get groupExited => 'समूह चैट छोड़ें';

  @override
  String get groupExitAction => 'समूह छोड़ें';

  @override
  String groupMembersSyncFailed(Object error) {
    return 'समूह के सदस्यों को सिंक करने में विफल: $error';
  }

  @override
  String get groupInvitePickerTitle => 'आमंत्रित करने के लिए सदस्य चुनें';

  @override
  String groupInviteSentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ने $count सदस्य निमंत्रण भेजा',
      one: '1 सदस्य को निमंत्रण भेजा गया',
    );
    return '$_temp0';
  }

  @override
  String groupInvitedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्यों को आमंत्रित किया गया',
      one: '1 सदस्य को आमंत्रित किया गया',
    );
    return '$_temp0';
  }

  @override
  String groupInviteMembersFailed(Object error) {
    return 'सदस्यों को आमंत्रित करने में विफल: $error';
  }

  @override
  String get groupRemovePickerTitle => 'हटाने के लिए सदस्य चुनें';

  @override
  String groupQuotedMemberName(Object name) {
    return '\"$name\"';
  }

  @override
  String groupSelectedMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्य',
      one: '1 सदस्य',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersConfirm(Object target) {
    return 'इस समूह से $target को हटाएं?';
  }

  @override
  String get groupRemoveAction => 'हटाएं';

  @override
  String groupRemovedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सदस्यों को हटा दिया गया',
      one: '1 सदस्य को हटाया गया',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersFailed(Object error) {
    return 'सदस्यों को हटाने में विफल: $error';
  }

  @override
  String get groupSettingsUpdated => 'समूह सेटिंग्स अपडेट की गईं';

  @override
  String groupSettingsUpdateFailed(Object error) {
    return 'समूह सेटिंग अपडेट करने में विफल: $error';
  }

  @override
  String get groupExitConfirm =>
      'इस समूह को छोड़ने के बाद अब आपको संदेश प्राप्त नहीं होंगे।';

  @override
  String get groupExitSuccess => 'समूह चैट छोड़ें';

  @override
  String groupExitFailed(Object error) {
    return 'छोड़ने में विफल: $error';
  }

  @override
  String get groupOwnerAdminSection => 'स्वामी एवं व्यवस्थापक';

  @override
  String get groupOwnerRole => 'स्वामी';

  @override
  String get groupAdminRole => 'व्यवस्थापक';

  @override
  String get groupRemove => 'हटाएं';

  @override
  String get groupAddAdmin => 'ग्रुप एडमिन जोड़ें';

  @override
  String get groupNoAdmins => 'कोई व्यवस्थापक नहीं';

  @override
  String get groupInviteConfirmRemark =>
      'सक्षम होने पर, सदस्यों को मित्रों को आमंत्रित करने से पहले स्वामी या व्यवस्थापक की मंजूरी की आवश्यकता होती है। QR कोड द्वारा शामिल होना भी अक्षम कर दिया जाएगा.';

  @override
  String get groupOwnerTransfer => 'स्वामित्व स्थानांतरित करें';

  @override
  String get groupMemberSettingsSection => 'सदस्य सेटिंग्स';

  @override
  String get groupAllMutedRemark =>
      'जब सभी-सदस्य म्यूट सक्षम होता है, तो केवल स्वामी और व्यवस्थापक ही बोल सकते हैं।';

  @override
  String get groupAllMuted => 'सभी सदस्यों को म्यूट करें';

  @override
  String get groupForbiddenAddFriendRemark =>
      'सक्षम होने पर, सदस्य इस समूह के माध्यम से मित्रों को नहीं जोड़ सकते।';

  @override
  String get groupForbiddenAddFriend => 'सदस्यों को मित्र जोड़ने से रोकें';

  @override
  String get groupAllowHistoryRemark =>
      'सक्षम होने पर, नए सदस्य पिछला चैट इतिहास देख सकते हैं।';

  @override
  String get groupAllowHistory => 'नए सदस्यों को इतिहास देखने की अनुमति दें';

  @override
  String get groupAddAdminPickerTitle => 'ग्रुप एडमिन जोड़ें';

  @override
  String groupAdminAddedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count व्यवस्थापक जोड़े गए',
      one: '1 व्यवस्थापक जोड़ा गया',
    );
    return '$_temp0';
  }

  @override
  String groupAddAdminFailed(Object error) {
    return 'व्यवस्थापक जोड़ने में विफल: $error';
  }

  @override
  String groupRemoveAdminConfirm(Object name) {
    return '\"$name\" से व्यवस्थापक भूमिका हटाएं?';
  }

  @override
  String get groupRemoveAdminAction => 'व्यवस्थापक हटाएं';

  @override
  String get groupRemoveAdminSuccess => 'व्यवस्थापक हटा दिया गया';

  @override
  String groupRemoveAdminFailed(Object error) {
    return 'व्यवस्थापक को हटाने में विफल: $error';
  }

  @override
  String get groupSelectNewOwner => 'नया स्वामी चुनें';

  @override
  String groupTransferOwnerConfirm(Object name) {
    return 'स्वामित्व को \"$name\" में स्थानांतरित करें? आप नियमित सदस्य बन जायेंगे.';
  }

  @override
  String get groupTransferOwnerAction => 'स्थानांतरण की पुष्टि करें';

  @override
  String get groupOwnerTransferred => 'स्वामित्व हस्तांतरित';

  @override
  String groupOwnerTransferFailed(Object error) {
    return 'स्वामित्व स्थानांतरित करने में विफल: $error';
  }

  @override
  String get groupNoticePublisherDefault => 'समूह घोषणा';

  @override
  String get groupNoticePublishTitle => 'समूह घोषणा पोस्ट करें';

  @override
  String get groupNoticeEditTitle => 'समूह घोषणा संपादित करें';

  @override
  String get groupNoticePublishAction => 'पोस्ट';

  @override
  String get groupNoticeEmpty => 'कोई समूह घोषणा नहीं';

  @override
  String get groupNoticePublishedAtUnknown => 'प्रकाशन का समय अज्ञात';

  @override
  String get groupMemberRemarkTitle => 'इस समूह में मेरा उपनाम';

  @override
  String get groupMemberRemarkHint => 'इस समूह में अपना उपनाम सेट करें';

  @override
  String get groupQrCodeEmpty => 'कोई समूह क्यूआर कोड नहीं';

  @override
  String groupQrCodeValid(Object day, Object expire) {
    return 'यह QR कोड $day दिनों ($expire) के लिए वैध है';
  }

  @override
  String get groupQrCodeScanToJoin =>
      'इस समूह में शामिल होने के लिए QR कोड को स्कैन करें';

  @override
  String get groupBlacklistLoadFailed =>
      'ब्लैकलिस्ट लोड करने में विफल. पुनः प्रयास करें।';

  @override
  String get groupBlacklistEmpty => 'कोई काली सूची में डाला गया सदस्य नहीं';

  @override
  String get groupBlacklistAddMember => 'ब्लैकलिस्ट सदस्य जोड़ें';

  @override
  String get groupBlacklistNoCandidates =>
      'किसी भी सदस्य को काली सूची में नहीं जोड़ा जा सकता';

  @override
  String get groupSelectMember => 'सदस्य चुनें';

  @override
  String get groupBlacklistAdded => 'काली सूची में जोड़ा गया';

  @override
  String get groupBlacklistAddFailed =>
      'काली सूची में जोड़ने में विफल। पुनः प्रयास करें।';

  @override
  String groupBlacklistRemoveConfirm(Object name) {
    return 'समूह ब्लैकलिस्ट से \"$name\" को हटाएं?';
  }

  @override
  String get groupBlacklistRemoveAction => 'काली सूची से हटाएँ';

  @override
  String get groupBlacklistRemoveFailed =>
      'काली सूची से हटाने में विफल. पुनः प्रयास करें।';

  @override
  String get groupAvatarTitle => 'समूह अवतार';

  @override
  String get groupAvatarTakePhoto => 'फ़ोटो लें';

  @override
  String get groupAvatarChooseFromAlbum => 'एल्बम में से चुनें';

  @override
  String get groupAvatarSaveImage => 'छवि सहेजें';

  @override
  String get groupAvatarUnsupported =>
      'यह चैट समूह अवतार बदलने का समर्थन नहीं करती';

  @override
  String get groupAvatarUpdated => 'समूह अवतार अपडेट किया गया';

  @override
  String get groupAvatarUpdateFailed =>
      'समूह अवतार अपडेट करने में विफल. पुनः प्रयास करें।';

  @override
  String get groupAvatarNoImageToSave => 'सहेजने के लिए कोई अवतार नहीं';

  @override
  String groupPhotoPermissionRequired(Object appName) {
    return '$appName को अपनी फ़ोटो तक पहुंचने की अनुमति दें';
  }

  @override
  String get groupImageSavedToAlbum => 'एल्बम में सहेजा गया';

  @override
  String get groupImageSaveFailed => 'सहेजने में विफल. पुनः प्रयास करें।';

  @override
  String get imageEditorProcessing => 'प्रसंस्करण...';

  @override
  String get imageEditorDiscardTitle => 'संपादन त्यागें?';

  @override
  String get imageEditorDiscardMessage => 'सहेजे न गए संपादन खो जाएंगे।';

  @override
  String get imageEditorDiscardConfirm => 'त्यागें';

  @override
  String get imageEditorPaint => 'ड्रा';

  @override
  String get imageEditorFreestyle => 'मुक्तहस्त';

  @override
  String get imageEditorArrow => 'तीर';

  @override
  String get imageEditorLine => 'लाइन';

  @override
  String get imageEditorRectangle => 'आयत';

  @override
  String get imageEditorCircle => 'सर्कल';

  @override
  String get imageEditorDashLine => 'धराशायी लाइन';

  @override
  String get imageEditorMoveAndZoom => 'ले जाएँ/ज़ूम करें';

  @override
  String get imageEditorEraser => 'इरेज़र';

  @override
  String get imageEditorLineWidth => 'चौड़ाई';

  @override
  String get imageEditorToggleFill => 'भरें';

  @override
  String get imageEditorOpacity => 'अपारदर्शिता';

  @override
  String get imageEditorUndo => 'पूर्ववत करें';

  @override
  String get imageEditorRedo => 'पुनः करें';

  @override
  String get imageEditorInputHint => 'टेक्स्ट दर्ज करें';

  @override
  String get imageEditorText => 'पाठ';

  @override
  String get imageEditorTextAlign => 'संरेखित करें';

  @override
  String get imageEditorBackground => 'पृष्ठभूमि';

  @override
  String get imageEditorFontScale => 'फ़ॉन्ट आकार';

  @override
  String get imageEditorCrop => 'फसल';

  @override
  String get imageEditorRotate => 'घुमाएँ';

  @override
  String get imageEditorRatio => 'अनुपात';

  @override
  String get imageEditorReset => 'रीसेट करें';

  @override
  String get imageEditorFlip => 'पलटें';

  @override
  String get imageEditorFilter => 'फ़िल्टर';

  @override
  String get imageEditorFilterNone => 'मूल';

  @override
  String get imageEditorFilterAddictiveBlue => 'व्यसनी नीला';

  @override
  String get imageEditorFilterAddictiveRed => 'व्यसनी लाल';

  @override
  String get imageEditorFilterAden => 'अदन';

  @override
  String get imageEditorFilterAmaro => 'अमारो';

  @override
  String get imageEditorFilterAshby => 'एशबी';

  @override
  String get imageEditorFilterBrannan => 'ब्रैनन';

  @override
  String get imageEditorFilterBrooklyn => 'ब्रुकलिन';

  @override
  String get imageEditorFilterCharmes => 'आकर्षण';

  @override
  String get imageEditorFilterClarendon => 'क्लेरेंडन';

  @override
  String get imageEditorFilterCrema => 'क्रेमा';

  @override
  String get imageEditorFilterDogpatch => 'डॉगपैच';

  @override
  String get imageEditorFilterEarlybird => 'अर्लीबर्ड';

  @override
  String get imageEditorFilterGingham => 'गिंगम';

  @override
  String get imageEditorFilterGinza => 'गिन्ज़ा';

  @override
  String get imageEditorFilterHefe => 'हेफ़े';

  @override
  String get imageEditorFilterHelena => 'हेलेना';

  @override
  String get imageEditorFilterHudson => 'हडसन';

  @override
  String get imageEditorFilterInkwell => 'इंकवेल';

  @override
  String get imageEditorFilterJuno => 'जूनो';

  @override
  String get imageEditorFilterKelvin => 'केल्विन';

  @override
  String get imageEditorFilterLark => 'लार्क';

  @override
  String get imageEditorFilterLoFi => 'लो-फाई';

  @override
  String get imageEditorFilterLudwig => 'लुडविग';

  @override
  String get imageEditorFilterMaven => 'मावेन';

  @override
  String get imageEditorFilterMayfair => 'मेफेयर';

  @override
  String get imageEditorFilterMoon => 'चंद्रमा';

  @override
  String get imageEditorFilterNashville => 'नैशविले';

  @override
  String get imageEditorFilterPerpetua => 'पेरपेटुआ';

  @override
  String get imageEditorFilterReyes => 'रेयेस';

  @override
  String get imageEditorFilterRise => 'उदय';

  @override
  String get imageEditorFilterSierra => 'सिएरा';

  @override
  String get imageEditorFilterSkyline => 'स्काईलाइन';

  @override
  String get imageEditorFilterSlumber => 'नींद';

  @override
  String get imageEditorFilterStinson => 'स्टिन्सन';

  @override
  String get imageEditorFilterSutro => 'सुत्रो';

  @override
  String get imageEditorFilterToaster => 'टोस्टर';

  @override
  String get imageEditorFilterValencia => 'वालेंसिया';

  @override
  String get imageEditorFilterVesper => 'वेस्पर';

  @override
  String get imageEditorFilterWalden => 'वाल्डेन';

  @override
  String get imageEditorFilterWillow => 'विलो';

  @override
  String get imageEditorBlur => 'धुंधला';

  @override
  String get imageEditorTune => 'समायोजित करें';

  @override
  String get imageEditorBrightness => 'चमक';

  @override
  String get imageEditorContrast => 'कंट्रास्ट';

  @override
  String get imageEditorSaturation => 'संतृप्ति';

  @override
  String get imageEditorExposure => 'एक्सपोज़र';

  @override
  String get imageEditorHue => 'रंग';

  @override
  String get imageEditorTemperature => 'तापमान';

  @override
  String get imageEditorSharpness => 'कुशाग्रता';

  @override
  String get imageEditorFade => 'फीका';

  @override
  String get imageEditorLuminance => 'चमक';

  @override
  String get imageEditorEmoji => 'इमोजी';

  @override
  String get imageEditorEmojiRecent => 'हाल का';

  @override
  String get imageEditorEmojiSmileys => 'स्माइलीज़';

  @override
  String get imageEditorEmojiAnimals => 'पशु';

  @override
  String get imageEditorEmojiFood => 'भोजन';

  @override
  String get imageEditorEmojiActivities => 'गतिविधियाँ';

  @override
  String get imageEditorEmojiTravel => 'यात्रा';

  @override
  String get imageEditorEmojiObjects => 'ऑब्जेक्ट';

  @override
  String get imageEditorEmojiSymbols => 'प्रतीक';

  @override
  String get imageEditorEmojiFlags => 'झंडे';

  @override
  String get imageEditorSticker => 'स्टिकर';

  @override
  String get imageEditorRemove => 'हटाएं';

  @override
  String get imageEditorSaving => 'सहेजा जा रहा है...';

  @override
  String get imageEditorImporting => 'आयात किया जा रहा है';

  @override
  String get imagePreviewTitle => 'छवि पूर्वावलोकन';

  @override
  String get imagePreviewSavingToAlbum => 'सहेजा जा रहा है...';

  @override
  String get imagePreviewAddToSticker => 'स्टिकर में जोड़ें';

  @override
  String get imagePreviewAddingToSticker => 'जोड़ा जा रहा है...';

  @override
  String get imagePreviewRecognizeQr => 'QR कोड को पहचानें';

  @override
  String get imagePreviewRecognizingQr => 'पहचान रहा है...';

  @override
  String get imagePreviewConfirmWebLogin => 'पुष्टि करें Web लॉगिन';

  @override
  String get imagePreviewConfirmingWebLogin => 'पुष्टि की जा रही है...';

  @override
  String get imagePreviewOpenLink => 'लिंक खोलें';

  @override
  String get imagePreviewImageNotDownloadedSave =>
      'छवि अभी तक डाउनलोड नहीं हुई है';

  @override
  String get imagePreviewMediaUnavailable => 'मीडिया सेवा उपलब्ध नहीं है';

  @override
  String get imagePreviewImageNotUploadedSticker =>
      'छवि अभी तक अपलोड नहीं की गई है';

  @override
  String get imagePreviewStickerUnavailable => 'स्टिकर सेवा उपलब्ध नहीं है';

  @override
  String get imagePreviewAddedToSticker => 'स्टिकर में जोड़ा गया';

  @override
  String get imagePreviewImageNotDownloadedRecognize =>
      'छवि अभी तक डाउनलोड नहीं हुई है';

  @override
  String get imagePreviewQrNotFound => 'कोई QR कोड नहीं मिला';

  @override
  String get imagePreviewWebLoginQrRecognized => 'Web लॉगिन QR कोड पहचाना गया';

  @override
  String get imagePreviewWebLinkRecognized => 'Web लिंक पहचाना गया';

  @override
  String get imagePreviewQrRecognized => 'क्यूआर कोड पहचाना गया';

  @override
  String get imagePreviewWebLoginConfirmed => 'Web लॉगिन की पुष्टि की गई';

  @override
  String get pickerFileTitle => 'फ़ाइल चुनें';

  @override
  String get pickerRecentFiles => 'हाल की फ़ाइलें';

  @override
  String get pickerSampleProjectFile => 'प्रोजेक्ट नोट्स.pdf';

  @override
  String get pickerSampleProjectFileSubtitle => '128 KB · आज';

  @override
  String get pickerSampleScreenshotFile => 'चैट Screenshot.png';

  @override
  String get pickerSampleScreenshotFileSubtitle => '2.4 एमबी · कल';

  @override
  String get pickerContactTitle => 'संपर्क चुनें';

  @override
  String get pickerContactCardSection => 'संपर्क कार्ड भेजें';

  @override
  String get pickerSearchContacts => 'संपर्क खोजें';

  @override
  String get pickerNoMatchingContacts => 'कोई मेल खाता संपर्क नहीं';

  @override
  String get chatSendFailedShort => 'भेजना विफल';

  @override
  String get chatResend => 'पुनः भेजें';

  @override
  String get chatStatusRead => 'पढ़ें';

  @override
  String get pinnedMessageTitle => 'पिन किया गया संदेश';

  @override
  String pinnedMessageTitleWithIndex(int index, int total) {
    return 'पिन किया गया संदेश $index/$total';
  }

  @override
  String get pinnedMessageOpen => 'देखने के लिए टैप करें';

  @override
  String get pinnedMessageViewAllTooltip => 'पिन किए गए सभी देखें';

  @override
  String get pinnedMessageUnpinTooltip => 'अनपिन करें';

  @override
  String pinnedMessageListCount(int count) {
    return '$count पिन किए गए संदेश';
  }

  @override
  String get pinnedMessageClearAll => 'सभी को अनपिन करें';

  @override
  String get pinnedMessageFallback => 'पिन किया गया संदेश';

  @override
  String get fileUnnamed => 'शीर्षक रहित फ़ाइल';

  @override
  String get fileNoDownloadUrl => 'कोई डाउनलोड लिंक उपलब्ध नहीं है';

  @override
  String get fileTitle => 'फ़ाइल';

  @override
  String fileSizeLabel(String size) {
    return 'फ़ाइल का आकार: $size';
  }

  @override
  String get fileDownloadFailed => 'डाउनलोड विफल';

  @override
  String get filePreview => 'पूर्वावलोकन';

  @override
  String get fileOpenWithOtherApp => 'अन्य ऐप में खोलें';

  @override
  String get actionEnable => 'सक्षम करें';

  @override
  String get actionDisable => 'अक्षम करें';

  @override
  String get profileInviteLoading => 'आमंत्रण कोड लोड हो रहा है';

  @override
  String get profileInviteEnabled => 'आमंत्रण कोड सक्षम किया गया';

  @override
  String get profileInviteDisabled => 'आमंत्रण कोड अक्षम किया गया';

  @override
  String profileInviteLoadFailed(String error) {
    return 'आमंत्रण कोड लोड करने में विफल: $error';
  }

  @override
  String get profileInviteCopied => 'कॉपी किया गया';

  @override
  String profileInviteUpdateFailed(String error) {
    return 'आमंत्रण कोड अपडेट करने में विफल: $error';
  }

  @override
  String get stickerStoreTitle => 'स्टिकर स्टोर';

  @override
  String get stickerNoPacks => 'कोई स्टिकर पैक नहीं';

  @override
  String get stickerDetailTitle => 'स्टिकर विवरण';

  @override
  String get stickerProcessing => 'प्रसंस्करण...';

  @override
  String get stickerAddCustomTitle => 'कस्टम स्टिकर जोड़ें';

  @override
  String get stickerSortTitle => 'स्टिकर सॉर्ट करें';

  @override
  String get stickerMyStickersTitle => 'मेरे स्टिकर';

  @override
  String get stickerSaving => 'सहेजा जा रहा है';

  @override
  String get stickerSortAction => 'क्रमबद्ध करें';

  @override
  String get stickerOrganize => 'व्यवस्थित करें';

  @override
  String get stickerCustomTitle => 'कस्टम स्टिकर';

  @override
  String get stickerCustomSubtitle => 'सहेजे गए कस्टम स्टिकर प्रबंधित करें';

  @override
  String get stickerNoSortablePacks => 'सॉर्ट करने के लिए कोई स्टिकर पैक नहीं';

  @override
  String get stickerNoCategories => 'कोई स्टिकर श्रेणियां नहीं';

  @override
  String get stickerMoveUp => 'ऊपर जाएँ';

  @override
  String get stickerMoveDown => 'नीचे जाएँ';

  @override
  String get stickerNoCustomStickers => 'कोई कस्टम स्टिकर नहीं';

  @override
  String get stickerMoveToFront => 'आगे बढ़ें';

  @override
  String get stickerDeleteConfirmTitle =>
      'हटाए गए स्टिकर पुनर्प्राप्त नहीं किए जा सकते';

  @override
  String get complaintTitle => 'प्रतिवेदन';

  @override
  String get complaintHint => 'मुद्दे का वर्णन करें';

  @override
  String get complaintType => 'रिपोर्ट प्रकार';

  @override
  String get complaintSubmitted => 'रिपोर्ट प्रस्तुत की गई';

  @override
  String get complaintSubmit => 'रिपोर्ट सबमिट करें';

  @override
  String get complaintSubmitting => 'सबमिट किया जा रहा है...';

  @override
  String get complaintFallbackOtherViolation => 'अन्य नीति उल्लंघन';

  @override
  String get complaintFallbackFraud => 'अन्य धोखाधड़ी या घोटाला';

  @override
  String get complaintFallbackAccountCompromised =>
      'खाते से समझौता किया जा सकता है';

  @override
  String get chatBackgroundTitle => 'चैट पृष्ठभूमि';

  @override
  String get chatBackgroundLoading => 'चैट पृष्ठभूमि लोड हो रही है';

  @override
  String get chatBackgroundEmpty => 'कोई चैट पृष्ठभूमि नहीं';

  @override
  String get chatBackgroundDefault => 'डिफ़ॉल्ट पृष्ठभूमि';

  @override
  String chatBackgroundItem(int index) {
    return 'पृष्ठभूमि $index';
  }

  @override
  String get chatBackgroundPreviewTitle => 'पूर्वावलोकन पृष्ठभूमि';

  @override
  String get chatBackgroundSet => 'पृष्ठभूमि सेट करें';

  @override
  String get chatBackgroundSelectedStatus => 'चैट पृष्ठभूमि सेट';

  @override
  String get chatBackgroundInUse => 'उपयोग में';

  @override
  String get chatContactFallback => 'संपर्क करें';

  @override
  String get chatPersonalCard => 'संपर्क कार्ड';

  @override
  String get chatSystemMessageDigest => '[सिस्टम संदेश]';

  @override
  String get chatMessageDigestMessage => '[संदेश]';

  @override
  String get chatMessageDigestImage => '[छवि]';

  @override
  String get chatMessageDigestVoice => '[आवाज]';

  @override
  String get chatMessageDigestVideo => '[वीडियो]';

  @override
  String get chatMessageDigestLocation => '[स्थान]';

  @override
  String get chatMessageDigestCard => '[संपर्क कार्ड]';

  @override
  String get chatMessageDigestFile => '[फ़ाइल]';

  @override
  String get chatMessageDigestHistory => '[चैट इतिहास]';

  @override
  String get chatMessageDigestSticker => '[स्टिकर]';

  @override
  String get dateWeekdayShortMonday => 'सोम';

  @override
  String get dateWeekdayShortTuesday => 'मंगल';

  @override
  String get dateWeekdayShortWednesday => 'बुध';

  @override
  String get dateWeekdayShortThursday => 'गुरु';

  @override
  String get dateWeekdayShortFriday => 'शुक्र';

  @override
  String get dateWeekdayShortSaturday => 'बैठा';

  @override
  String get dateWeekdayShortSunday => 'सूरज';

  @override
  String get appIconClassic => 'क्लासिक';

  @override
  String get appIconSimple => 'सरल';

  @override
  String get appIconDark => 'अंधेरा';

  @override
  String get appIconFestive => 'उत्सव';

  @override
  String get appIconGradient => 'ग्रेडिएंट';

  @override
  String get appIconUpdated => 'आइकन अपडेट किया गया';

  @override
  String get appIconUpdateFailed => 'स्विच विफल रहा। बाद में पुन: प्रयास।';

  @override
  String get appearanceBubbleColorPurple => 'बैंगनी';

  @override
  String get appearanceBubbleColorGreen => 'हरा';

  @override
  String get appearanceBubbleColorBlue => 'नीला';

  @override
  String get appearanceBubbleColorOrange => 'नारंगी';

  @override
  String get appearanceBubbleColorPink => 'गुलाबी';

  @override
  String replyPreviewTitle(String name) {
    return 'उत्तर दें $name';
  }

  @override
  String get replyPreviewCancel => 'उत्तर रद्द करें';

  @override
  String get chatPasswordTitle => 'चैट पासवर्ड';

  @override
  String get chatPasswordHint => '6 अंकों का पासवर्ड दर्ज करें';

  @override
  String chatPasswordErrorRemain(int remain) {
    return 'ग़लत पासवर्ड. $remain और असफल प्रयासों के बाद चैट इतिहास साफ़ कर दिया जाएगा।';
  }

  @override
  String get emojiPackEmpty => 'इस पैक में कोई स्टिकर नहीं';

  @override
  String get emojiRecentSection => 'हाल का';

  @override
  String get emojiAllSection => 'सभी इमोजी';

  @override
  String get stickerSearching => 'खोजा जा रहा है...';

  @override
  String get stickerNoSearchResults => 'कोई परिणाम नहीं';

  @override
  String get stickerSearchResultsTitle => 'परिणाम:';

  @override
  String get homeChatPasswordWiped =>
      'बहुत सारे गलत प्रयास। चैट इतिहास हटा दिया गया.';

  @override
  String get homeGroupNotFound => 'समूह चैट नहीं मिली';

  @override
  String get homeConversationNoHistory => 'कोई चैट इतिहास नहीं';

  @override
  String get homeConversationStartChat => 'चैट प्रारंभ करें';

  @override
  String get homeEnterGroupChat => 'समूह चैट दर्ज करें';

  @override
  String get homeNewGroup => 'नया समूह चैट';

  @override
  String homeFriendRequestAcceptFailed(String error) {
    return 'स्वीकार करने में विफल: $error';
  }

  @override
  String get homeFriendRequestAccepted => 'मित्र अनुरोध स्वीकार किया गया';

  @override
  String homeFriendRequestRefuseFailed(String error) {
    return 'मना करने में विफल: $error';
  }

  @override
  String homeFriendRequestDeleteFailed(String error) {
    return 'हटाने में विफल: $error';
  }

  @override
  String contactPresenceOnlineWithDevice(String device) {
    return '$device पर ऑनलाइन';
  }

  @override
  String contactPresenceJustOnlineWithDevice(String device) {
    return 'अभी $device पर ऑनलाइन';
  }

  @override
  String contactPresenceMinutesOnlineWithDevice(int minutes, String device) {
    return 'ऑनलाइन $device $minutes मिनट पहले';
  }

  @override
  String contactPresenceLastOnline(String time) {
    return 'अंतिम ऑनलाइन $time';
  }

  @override
  String get contactPresenceDeviceWeb => 'वेब';

  @override
  String get contactPresenceDeviceDesktop => 'डेस्कटॉप';

  @override
  String get contactPresenceDeviceMobile => 'मोबाइल';

  @override
  String get botCommandsEmpty => 'अभी तक कोई कमांड नहीं';
}
