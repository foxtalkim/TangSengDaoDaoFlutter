import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
/// ```dart
/// import 'l10n/app_localizations.dart';
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
/// ## Update pubspec.yaml
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///   # Rest of dependencies
/// ```
/// ## iOS Applications
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'TW'),
    Locale('ja'),
    Locale('ko'),
    Locale('es'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('fr'),
    Locale('de'),
    Locale('it'),
    Locale('nl'),
    Locale('ru'),
    Locale('ar'),
    Locale('tr'),
    Locale('id'),
    Locale('ms'),
    Locale('th'),
    Locale('vi'),
    Locale('hi'),
  ];

  /// No description provided for @tabMessages.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get tabMessages;

  /// No description provided for @tabContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get tabContacts;

  /// No description provided for @tabDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get tabDiscover;

  /// No description provided for @tabMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get tabMe;

  /// No description provided for @pageMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get pageMessagesTitle;

  /// No description provided for @pageContactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get pageContactsTitle;

  /// No description provided for @pageDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get pageDiscoverTitle;

  /// No description provided for @pageMeTitle.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get pageMeTitle;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @actionInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get actionInvite;

  /// No description provided for @actionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

  /// No description provided for @actionSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get actionSend;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get actionMore;

  /// No description provided for @actionJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get actionJoin;

  /// No description provided for @actionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get actionGetStarted;

  /// No description provided for @actionSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get actionSaving;

  /// No description provided for @moduleUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This feature is not available in this version'**
  String get moduleUnsupported;

  /// No description provided for @moduleLoading.
  ///
  /// In en, this message translates to:
  /// **'Checking feature access. Try again later.'**
  String get moduleLoading;

  /// No description provided for @moduleOfflineStale.
  ///
  /// In en, this message translates to:
  /// **'Connect to the network to confirm feature access'**
  String get moduleOfflineStale;

  /// No description provided for @onboardingMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Guide'**
  String get onboardingMenuTitle;

  /// No description provided for @onboardingChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appName}'**
  String onboardingChatTitle(Object appName);

  /// No description provided for @onboardingChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A clean, light place for more comfortable conversations.'**
  String get onboardingChatSubtitle;

  /// No description provided for @onboardingFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Make staying in touch simple'**
  String get onboardingFriendsTitle;

  /// No description provided for @onboardingFriendsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Friends, groups, and sharing are easier to find.'**
  String get onboardingFriendsSubtitle;

  /// No description provided for @onboardingSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Speak freely. Use it with confidence.'**
  String get onboardingSecurityTitle;

  /// No description provided for @onboardingSecuritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Account security and privacy protection help guard your boundaries.'**
  String get onboardingSecuritySubtitle;

  /// No description provided for @onboardingChatSemantic.
  ///
  /// In en, this message translates to:
  /// **'Message sync onboarding illustration'**
  String get onboardingChatSemantic;

  /// No description provided for @onboardingFriendsSemantic.
  ///
  /// In en, this message translates to:
  /// **'Friends and groups onboarding illustration'**
  String get onboardingFriendsSemantic;

  /// No description provided for @onboardingSecuritySemantic.
  ///
  /// In en, this message translates to:
  /// **'Security and privacy onboarding illustration'**
  String get onboardingSecuritySemantic;

  /// No description provided for @settingsLanguageRow.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageRow;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageZh.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get settingsLanguageZh;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @profileRowFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get profileRowFavorites;

  /// No description provided for @profileRowSecurityPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get profileRowSecurityPrivacy;

  /// No description provided for @profileRowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileRowNotifications;

  /// No description provided for @profileRowInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get profileRowInviteCode;

  /// No description provided for @profileRowGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get profileRowGeneral;

  /// No description provided for @profileRowAbout.
  ///
  /// In en, this message translates to:
  /// **'About {appName}'**
  String profileRowAbout(Object appName);

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Logging out won\'t delete any history. You can sign back in with this account anytime.'**
  String get profileLogoutConfirm;

  /// No description provided for @profileMoyuIdLabel.
  ///
  /// In en, this message translates to:
  /// **'{appName} ID: {value}'**
  String profileMoyuIdLabel(Object appName, Object value);

  /// No description provided for @profileDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get profileDefaultName;

  /// No description provided for @profileDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileDetailTitle;

  /// No description provided for @profileAvatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get profileAvatar;

  /// No description provided for @profileNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get profileNickname;

  /// No description provided for @profileEditNickname.
  ///
  /// In en, this message translates to:
  /// **'Edit Nickname'**
  String get profileEditNickname;

  /// No description provided for @profileEditFoxId.
  ///
  /// In en, this message translates to:
  /// **'Edit {appName} ID'**
  String profileEditFoxId(Object appName);

  /// No description provided for @profileGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileGender;

  /// No description provided for @profileGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get profileGenderMale;

  /// No description provided for @profileGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get profileGenderFemale;

  /// No description provided for @profileGenderSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get profileGenderSelected;

  /// No description provided for @profileGenderUnset.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get profileGenderUnset;

  /// No description provided for @profilePhoneUnbound.
  ///
  /// In en, this message translates to:
  /// **'Not linked'**
  String get profilePhoneUnbound;

  /// No description provided for @profileAvatarUpdated.
  ///
  /// In en, this message translates to:
  /// **'Avatar updated'**
  String get profileAvatarUpdated;

  /// No description provided for @profileAvatarUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload avatar. Try again.'**
  String get profileAvatarUpdateFailed;

  /// No description provided for @generalPageTitle.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalPageTitle;

  /// No description provided for @generalFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get generalFontSize;

  /// No description provided for @generalChatBackground.
  ///
  /// In en, this message translates to:
  /// **'Chat Background'**
  String get generalChatBackground;

  /// No description provided for @generalDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get generalDarkMode;

  /// No description provided for @generalClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get generalClearCache;

  /// No description provided for @generalClearMessages.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat History'**
  String get generalClearMessages;

  /// No description provided for @generalAppModules.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get generalAppModules;

  /// No description provided for @generalErrorLogs.
  ///
  /// In en, this message translates to:
  /// **'Error Logs'**
  String get generalErrorLogs;

  /// No description provided for @generalThirdShare.
  ///
  /// In en, this message translates to:
  /// **'Third-party SDKs'**
  String get generalThirdShare;

  /// No description provided for @fontSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get fontSizeSmall;

  /// No description provided for @fontSizeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get fontSizeStandard;

  /// No description provided for @fontSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get fontSizeLarge;

  /// No description provided for @fontSizeExtraLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get fontSizeExtraLarge;

  /// No description provided for @darkModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get darkModeSystem;

  /// No description provided for @darkModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get darkModeLight;

  /// No description provided for @darkModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkModeDark;

  /// No description provided for @valueConfigure.
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get valueConfigure;

  /// No description provided for @valueManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get valueManage;

  /// No description provided for @valueClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get valueClear;

  /// No description provided for @valueUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get valueUpload;

  /// No description provided for @valueDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get valueDownload;

  /// No description provided for @valueView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get valueView;

  /// No description provided for @valueEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get valueEnabled;

  /// No description provided for @valueDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get valueDisabled;

  /// No description provided for @valueOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get valueOn;

  /// No description provided for @valueOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get valueOff;

  /// No description provided for @valueConfigured.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get valueConfigured;

  /// No description provided for @valueNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Not enabled'**
  String get valueNotEnabled;

  /// No description provided for @valueSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get valueSelected;

  /// No description provided for @valueCurrentDevice.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get valueCurrentDevice;

  /// No description provided for @valueSdkInfo.
  ///
  /// In en, this message translates to:
  /// **'SDK Info'**
  String get valueSdkInfo;

  /// No description provided for @statusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get statusProcessing;

  /// No description provided for @statusLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get statusLoading;

  /// No description provided for @statusSending.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get statusSending;

  /// No description provided for @statusSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get statusSaving;

  /// No description provided for @statusSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get statusSaved;

  /// No description provided for @statusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get statusSent;

  /// No description provided for @statusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get statusSubmitted;

  /// No description provided for @dateJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get dateJustNow;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// No description provided for @dateDayBeforeYesterday.
  ///
  /// In en, this message translates to:
  /// **'The Day Before Yesterday'**
  String get dateDayBeforeYesterday;

  /// No description provided for @dateTodayTime.
  ///
  /// In en, this message translates to:
  /// **'Today {time}'**
  String dateTodayTime(Object time);

  /// No description provided for @dateYesterdayTime.
  ///
  /// In en, this message translates to:
  /// **'Yesterday {time}'**
  String dateYesterdayTime(Object time);

  /// No description provided for @dateDayBeforeYesterdayTime.
  ///
  /// In en, this message translates to:
  /// **'Two days ago {time}'**
  String dateDayBeforeYesterdayTime(Object time);

  /// No description provided for @dateWeekdayTime.
  ///
  /// In en, this message translates to:
  /// **'{weekday} {time}'**
  String dateWeekdayTime(Object time, Object weekday);

  /// No description provided for @dateMonthDayTime.
  ///
  /// In en, this message translates to:
  /// **'{month}/{day} {time}'**
  String dateMonthDayTime(Object day, Object month, Object time);

  /// No description provided for @dateYearMonthDayTime.
  ///
  /// In en, this message translates to:
  /// **'{year}/{month}/{day} {time}'**
  String dateYearMonthDayTime(
    Object day,
    Object month,
    Object time,
    Object year,
  );

  /// No description provided for @dateMonthDay.
  ///
  /// In en, this message translates to:
  /// **'{month}/{day}'**
  String dateMonthDay(Object day, Object month);

  /// No description provided for @dateYearMonthDay.
  ///
  /// In en, this message translates to:
  /// **'{year}/{month}/{day}'**
  String dateYearMonthDay(Object day, Object month, Object year);

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @dialogClearAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all chat history?'**
  String get dialogClearAllTitle;

  /// No description provided for @dialogClearAllBody.
  ///
  /// In en, this message translates to:
  /// **'All local chat history and conversation entries will be removed.'**
  String get dialogClearAllBody;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in with your phone number and keep chatting with friends'**
  String get authLoginSubtitle;

  /// No description provided for @authLoginIllustration.
  ///
  /// In en, this message translates to:
  /// **'Login illustration'**
  String get authLoginIllustration;

  /// No description provided for @authRegisterIllustration.
  ///
  /// In en, this message translates to:
  /// **'Register illustration'**
  String get authRegisterIllustration;

  /// No description provided for @authSecurityIllustration.
  ///
  /// In en, this message translates to:
  /// **'Verification illustration'**
  String get authSecurityIllustration;

  /// No description provided for @authResetIllustration.
  ///
  /// In en, this message translates to:
  /// **'Password reset illustration'**
  String get authResetIllustration;

  /// No description provided for @authServerLabel.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get authServerLabel;

  /// No description provided for @authServerCustomLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom server'**
  String get authServerCustomLabel;

  /// No description provided for @authServerCustomHint.
  ///
  /// In en, this message translates to:
  /// **'Enter server address'**
  String get authServerCustomHint;

  /// No description provided for @authPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get authPhoneLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLoginButton;

  /// No description provided for @authLoginLoading.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get authLoginLoading;

  /// No description provided for @authRegisterButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegisterButton;

  /// No description provided for @authLoginWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get authLoginWithApple;

  /// No description provided for @authLoginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get authLoginWithGoogle;

  /// No description provided for @authLoginWithGithub.
  ///
  /// In en, this message translates to:
  /// **'Sign in with GitHub'**
  String get authLoginWithGithub;

  /// No description provided for @authLoginAgreementPrefix.
  ///
  /// In en, this message translates to:
  /// **'By logging in, you agree to '**
  String get authLoginAgreementPrefix;

  /// No description provided for @authTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get authTermsTitle;

  /// No description provided for @authAgreementConnector.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get authAgreementConnector;

  /// No description provided for @authPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get authPrivacyTitle;

  /// No description provided for @authVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Login'**
  String get authVerifyTitle;

  /// No description provided for @authVerifySubtitleWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to {phone}'**
  String authVerifySubtitleWithPhone(Object phone);

  /// No description provided for @authVerifySubtitlePasswordFirst.
  ///
  /// In en, this message translates to:
  /// **'Log in with your password first to start security verification'**
  String get authVerifySubtitlePasswordFirst;

  /// No description provided for @authVerifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authVerifyButton;

  /// No description provided for @authVerifyLoading.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get authVerifyLoading;

  /// No description provided for @authResendCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get a code? Resend'**
  String get authResendCode;

  /// No description provided for @authVerificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent'**
  String get authVerificationCodeSent;

  /// No description provided for @authVerificationCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code'**
  String get authVerificationCodeRequired;

  /// No description provided for @authVerificationCodeSixDigits.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get authVerificationCodeSixDigits;

  /// No description provided for @authPasswordResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Login Password'**
  String get authPasswordResetTitle;

  /// No description provided for @authPasswordResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your phone number, then set a new login password'**
  String get authPasswordResetSubtitle;

  /// No description provided for @authPasswordResetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authPasswordResetButton;

  /// No description provided for @authKickedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account was logged in on another device.'**
  String get authKickedTitle;

  /// No description provided for @authSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get authSubmitting;

  /// No description provided for @authVerificationCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get authVerificationCodeLabel;

  /// No description provided for @authGetVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Get code'**
  String get authGetVerificationCode;

  /// No description provided for @authNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authNewPasswordLabel;

  /// No description provided for @authPasswordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset'**
  String get authPasswordResetSuccess;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a {appName} Account'**
  String authRegisterTitle(Object appName);

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register with your phone number and start chatting right away'**
  String get authRegisterSubtitle;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authNicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get authNicknameLabel;

  /// No description provided for @authInviteCodeRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code (required)'**
  String get authInviteCodeRequiredLabel;

  /// No description provided for @authCodeRetryAfter.
  ///
  /// In en, this message translates to:
  /// **'Retry in {seconds}s'**
  String authCodeRetryAfter(Object seconds);

  /// No description provided for @authRegisterAgreement.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the Terms of Service and Privacy Policy'**
  String get authRegisterAgreement;

  /// No description provided for @authInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get authInvalidPhone;

  /// No description provided for @authAcceptAgreementFirst.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms of Service and Privacy Policy first'**
  String get authAcceptAgreementFirst;

  /// No description provided for @authCodeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Verification code is required'**
  String get authCodeEmpty;

  /// No description provided for @authPasswordLengthInvalid.
  ///
  /// In en, this message translates to:
  /// **'Password must be 6-16 characters'**
  String get authPasswordLengthInvalid;

  /// No description provided for @authInviteCodeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Invite code is required'**
  String get authInviteCodeEmpty;

  /// No description provided for @authRegisterSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registered successfully'**
  String get authRegisterSuccess;

  /// No description provided for @settingsCheckNewVersion.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get settingsCheckNewVersion;

  /// No description provided for @settingsChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get settingsChecking;

  /// No description provided for @settingsVersionFound.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get settingsVersionFound;

  /// No description provided for @settingsUserAgreement.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsUserAgreement;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get settingsView;

  /// No description provided for @settingsSwitchAccount.
  ///
  /// In en, this message translates to:
  /// **'Switch Account'**
  String get settingsSwitchAccount;

  /// No description provided for @settingsCacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared'**
  String get settingsCacheCleared;

  /// No description provided for @settingsClearCacheSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear image/video cache?\nChat images, video covers, and avatars will be downloaded again.'**
  String get settingsClearCacheSheetTitle;

  /// No description provided for @settingsClearCacheAction.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get settingsClearCacheAction;

  /// No description provided for @settingsMessagesCleared.
  ///
  /// In en, this message translates to:
  /// **'Chat history cleared'**
  String get settingsMessagesCleared;

  /// No description provided for @settingsClearMessagesFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear chat history: {error}'**
  String settingsClearMessagesFailed(Object error);

  /// No description provided for @settingsAlreadyLatestVersion.
  ///
  /// In en, this message translates to:
  /// **'You\'re already on the latest version'**
  String get settingsAlreadyLatestVersion;

  /// No description provided for @settingsCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Check failed'**
  String get settingsCheckFailed;

  /// No description provided for @settingsUpdateDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Update available\nLatest version: {version}'**
  String settingsUpdateDialogTitle(Object version);

  /// No description provided for @settingsUpdateDialogTitleWithDescription.
  ///
  /// In en, this message translates to:
  /// **'Update available\nLatest version: {version}\n{description}'**
  String settingsUpdateDialogTitleWithDescription(
    Object description,
    Object version,
  );

  /// No description provided for @settingsLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get settingsLater;

  /// No description provided for @settingsUpdateNow.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get settingsUpdateNow;

  /// No description provided for @settingsSaveFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'Failed to save. Try again.'**
  String get settingsSaveFailedRetry;

  /// No description provided for @securityAllowPhoneSearch.
  ///
  /// In en, this message translates to:
  /// **'Allow others to find me by phone number'**
  String get securityAllowPhoneSearch;

  /// No description provided for @securityAllowFoxIdSearch.
  ///
  /// In en, this message translates to:
  /// **'Allow others to find me by {appName} ID'**
  String securityAllowFoxIdSearch(Object appName);

  /// No description provided for @securitySearchRemark.
  ///
  /// In en, this message translates to:
  /// **'When off, other users cannot find you through the information above.'**
  String get securitySearchRemark;

  /// No description provided for @securityJoinGroupNeedConfirm.
  ///
  /// In en, this message translates to:
  /// **'Require confirmation to join groups'**
  String get securityJoinGroupNeedConfirm;

  /// No description provided for @securityJoinGroupNeedConfirmRemark.
  ///
  /// In en, this message translates to:
  /// **'When on, invitations to add you to a group must be confirmed by you first.'**
  String get securityJoinGroupNeedConfirmRemark;

  /// No description provided for @securityLoginPassword.
  ///
  /// In en, this message translates to:
  /// **'Login Password'**
  String get securityLoginPassword;

  /// No description provided for @securityChatPassword.
  ///
  /// In en, this message translates to:
  /// **'Chat Password'**
  String get securityChatPassword;

  /// No description provided for @securityScreenProtection.
  ///
  /// In en, this message translates to:
  /// **'Screen Protection'**
  String get securityScreenProtection;

  /// No description provided for @securityLockPassword.
  ///
  /// In en, this message translates to:
  /// **'Lock Password'**
  String get securityLockPassword;

  /// No description provided for @securityOfflineProtection.
  ///
  /// In en, this message translates to:
  /// **'Offline Screen Lock'**
  String get securityOfflineProtection;

  /// No description provided for @securityDeviceManagement.
  ///
  /// In en, this message translates to:
  /// **'Login Device Management'**
  String get securityDeviceManagement;

  /// No description provided for @securityDeviceRemark.
  ///
  /// In en, this message translates to:
  /// **'View and manage devices, enable login protection, and keep your account secure.'**
  String get securityDeviceRemark;

  /// No description provided for @securityBlacklist.
  ///
  /// In en, this message translates to:
  /// **'Blacklist'**
  String get securityBlacklist;

  /// No description provided for @securityAccountDeletion.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get securityAccountDeletion;

  /// No description provided for @accountDeletionBody.
  ///
  /// In en, this message translates to:
  /// **'Account deletion cannot be undone. After confirmation, a verification code will be sent by SMS to complete deletion.'**
  String get accountDeletionBody;

  /// No description provided for @accountDeletionSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Deletion request submitted'**
  String get accountDeletionSubmitted;

  /// No description provided for @accountDeletionGetCode.
  ///
  /// In en, this message translates to:
  /// **'Get code'**
  String get accountDeletionGetCode;

  /// No description provided for @passwordResetInstruction.
  ///
  /// In en, this message translates to:
  /// **'Changing your login password requires an SMS code. The new password must be at least 6 characters.'**
  String get passwordResetInstruction;

  /// No description provided for @accountPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get accountPhoneLabel;

  /// No description provided for @passwordRuleLabel.
  ///
  /// In en, this message translates to:
  /// **'Password rule'**
  String get passwordRuleLabel;

  /// No description provided for @passwordAtLeastSix.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get passwordAtLeastSix;

  /// No description provided for @passwordConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get passwordConfirmLabel;

  /// No description provided for @passwordConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the login password again'**
  String get passwordConfirmHint;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Login password changed'**
  String get passwordChanged;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @chatPasswordInstruction.
  ///
  /// In en, this message translates to:
  /// **'When enabled, this 6-digit password is required before opening protected chats.'**
  String get chatPasswordInstruction;

  /// No description provided for @currentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get currentStatusLabel;

  /// No description provided for @passwordSixDigits.
  ///
  /// In en, this message translates to:
  /// **'6 digits'**
  String get passwordSixDigits;

  /// No description provided for @chatPasswordEnableAction.
  ///
  /// In en, this message translates to:
  /// **'Enable Chat Password'**
  String get chatPasswordEnableAction;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Login password is required'**
  String get loginPasswordRequired;

  /// No description provided for @chatPasswordSixDigitsRequired.
  ///
  /// In en, this message translates to:
  /// **'Chat password must be 6 digits'**
  String get chatPasswordSixDigitsRequired;

  /// No description provided for @lockSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a 6-digit lock password'**
  String get lockSetTitle;

  /// No description provided for @lockSetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Required to unlock {appName}'**
  String lockSetSubtitle(Object appName);

  /// No description provided for @lockCurrentPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter current lock password'**
  String get lockCurrentPromptTitle;

  /// No description provided for @lockCurrentPromptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Verify before changing or turning it off'**
  String get lockCurrentPromptSubtitle;

  /// No description provided for @lockAutoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto Lock'**
  String get lockAutoLock;

  /// No description provided for @lockChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Unlock Password'**
  String get lockChangePassword;

  /// No description provided for @lockClosePassword.
  ///
  /// In en, this message translates to:
  /// **'Turn Off Unlock Password'**
  String get lockClosePassword;

  /// No description provided for @lockWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password. Try again.'**
  String get lockWrongPassword;

  /// No description provided for @lockSixDigitsRequired.
  ///
  /// In en, this message translates to:
  /// **'Lock password must be 6 digits'**
  String get lockSixDigitsRequired;

  /// No description provided for @lockInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter lock password'**
  String get lockInputTitle;

  /// No description provided for @lockInputSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock to continue using {appName}'**
  String lockInputSubtitle(Object appName);

  /// No description provided for @lockSetFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to set. Try again.'**
  String get lockSetFailed;

  /// No description provided for @lockImmediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get lockImmediately;

  /// No description provided for @lockAfter5Minutes.
  ///
  /// In en, this message translates to:
  /// **'After 5 minutes away'**
  String get lockAfter5Minutes;

  /// No description provided for @lockAfter30Minutes.
  ///
  /// In en, this message translates to:
  /// **'After 30 minutes away'**
  String get lockAfter30Minutes;

  /// No description provided for @lockAfter1Hour.
  ///
  /// In en, this message translates to:
  /// **'After 1 hour away'**
  String get lockAfter1Hour;

  /// No description provided for @deviceLoginProtection.
  ///
  /// In en, this message translates to:
  /// **'Login Protection'**
  String get deviceLoginProtection;

  /// No description provided for @deviceProtectionRemark.
  ///
  /// In en, this message translates to:
  /// **'When login protection is enabled, security verification is required on unfamiliar devices. Recommended for account safety.'**
  String get deviceProtectionRemark;

  /// No description provided for @deviceNone.
  ///
  /// In en, this message translates to:
  /// **'No logged-in devices'**
  String get deviceNone;

  /// No description provided for @deviceDebugName.
  ///
  /// In en, this message translates to:
  /// **'Current Device'**
  String get deviceDebugName;

  /// No description provided for @deviceDebugPlatform.
  ///
  /// In en, this message translates to:
  /// **'iPhone / Android debug device'**
  String get deviceDebugPlatform;

  /// No description provided for @deviceProtectionEnabled.
  ///
  /// In en, this message translates to:
  /// **'Login protection enabled'**
  String get deviceProtectionEnabled;

  /// No description provided for @deviceProtectionDisabled.
  ///
  /// In en, this message translates to:
  /// **'Login protection disabled'**
  String get deviceProtectionDisabled;

  /// No description provided for @deviceProtectionUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update login protection. Try again.'**
  String get deviceProtectionUpdateFailed;

  /// No description provided for @blacklistEmpty.
  ///
  /// In en, this message translates to:
  /// **'No blacklisted contacts'**
  String get blacklistEmpty;

  /// No description provided for @switchAccountRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent Accounts'**
  String get switchAccountRecent;

  /// No description provided for @switchAccountLoading.
  ///
  /// In en, this message translates to:
  /// **'Reading recent accounts'**
  String get switchAccountLoading;

  /// No description provided for @switchAccountAddOther.
  ///
  /// In en, this message translates to:
  /// **'Add or log in to another account'**
  String get switchAccountAddOther;

  /// No description provided for @switchAccountCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get switchAccountCurrent;

  /// No description provided for @appModulesLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading feature modules'**
  String get appModulesLoading;

  /// No description provided for @appModulesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No feature modules'**
  String get appModulesEmpty;

  /// No description provided for @appModulesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Module unavailable'**
  String get appModulesUnavailable;

  /// No description provided for @errorLogsLoading.
  ///
  /// In en, this message translates to:
  /// **'Reading error logs'**
  String get errorLogsLoading;

  /// No description provided for @errorLogsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No error logs'**
  String get errorLogsEmpty;

  /// No description provided for @errorLogFileName.
  ///
  /// In en, this message translates to:
  /// **'File Name'**
  String get errorLogFileName;

  /// No description provided for @errorLogFileSize.
  ///
  /// In en, this message translates to:
  /// **'File Size'**
  String get errorLogFileSize;

  /// No description provided for @errorLogGeneratedAt.
  ///
  /// In en, this message translates to:
  /// **'Generated At'**
  String get errorLogGeneratedAt;

  /// No description provided for @errorLogFilePath.
  ///
  /// In en, this message translates to:
  /// **'File Path'**
  String get errorLogFilePath;

  /// No description provided for @notificationReceiveNew.
  ///
  /// In en, this message translates to:
  /// **'Receive New Message Notifications'**
  String get notificationReceiveNew;

  /// No description provided for @notificationSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get notificationSound;

  /// No description provided for @notificationVibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get notificationVibration;

  /// No description provided for @notificationShowDetails.
  ///
  /// In en, this message translates to:
  /// **'Show Notification Details'**
  String get notificationShowDetails;

  /// No description provided for @notificationSystem.
  ///
  /// In en, this message translates to:
  /// **'System Message Notifications'**
  String get notificationSystem;

  /// No description provided for @notificationCalls.
  ///
  /// In en, this message translates to:
  /// **'Audio/Video Call Notifications'**
  String get notificationCalls;

  /// No description provided for @settingsGoToSystem.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsGoToSystem;

  /// No description provided for @aboutAppIconSemantic.
  ///
  /// In en, this message translates to:
  /// **'{appName} icon'**
  String aboutAppIconSemantic(Object appName);

  /// No description provided for @aboutCopyright.
  ///
  /// In en, this message translates to:
  /// **'Copyright © 2026\n{appName}. All rights reserved.'**
  String aboutCopyright(Object appName);

  /// No description provided for @policyWebUrl.
  ///
  /// In en, this message translates to:
  /// **'Web URL'**
  String get policyWebUrl;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @appearanceAppIcon.
  ///
  /// In en, this message translates to:
  /// **'App Icon'**
  String get appearanceAppIcon;

  /// No description provided for @appearanceTabBarStyle.
  ///
  /// In en, this message translates to:
  /// **'Bottom Navigation'**
  String get appearanceTabBarStyle;

  /// No description provided for @appearanceTabBarStyleMode.
  ///
  /// In en, this message translates to:
  /// **'Display Style'**
  String get appearanceTabBarStyleMode;

  /// No description provided for @appearanceTabBarStyleGlassDock.
  ///
  /// In en, this message translates to:
  /// **'Glass Dock'**
  String get appearanceTabBarStyleGlassDock;

  /// No description provided for @appearanceTabBarStyleClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get appearanceTabBarStyleClassic;

  /// No description provided for @appearanceDockFollowsChatColor.
  ///
  /// In en, this message translates to:
  /// **'Dock Follows Chat Color'**
  String get appearanceDockFollowsChatColor;

  /// No description provided for @appearanceChatColor.
  ///
  /// In en, this message translates to:
  /// **'Chat Color'**
  String get appearanceChatColor;

  /// No description provided for @appearanceBubbleRadius.
  ///
  /// In en, this message translates to:
  /// **'Bubble Corner Radius'**
  String get appearanceBubbleRadius;

  /// No description provided for @appearanceBubbleColorInk.
  ///
  /// In en, this message translates to:
  /// **'Ink Black'**
  String get appearanceBubbleColorInk;

  /// No description provided for @appearanceSquare.
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get appearanceSquare;

  /// No description provided for @appearanceRound.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get appearanceRound;

  /// No description provided for @appearancePreviewOne.
  ///
  /// In en, this message translates to:
  /// **'Does he want me to turn right or left? 🤔'**
  String get appearancePreviewOne;

  /// No description provided for @appearancePreviewTwo.
  ///
  /// In en, this message translates to:
  /// **'Right. And, well, make it strong.'**
  String get appearancePreviewTwo;

  /// No description provided for @appearancePreviewThree.
  ///
  /// In en, this message translates to:
  /// **'Is that all? I feel like he said more than that. 😯'**
  String get appearancePreviewThree;

  /// No description provided for @appearancePreviewFour.
  ///
  /// In en, this message translates to:
  /// **'That\'s about it. I\'ll send a voice message with more details later.'**
  String get appearancePreviewFour;

  /// No description provided for @contactsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No contacts yet'**
  String get contactsEmptyTitle;

  /// No description provided for @contactsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add friends from the top right or scan a profile card'**
  String get contactsEmptySubtitle;

  /// No description provided for @contactsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 contact} other{{count} contacts}}'**
  String contactsCount(num count);

  /// No description provided for @contactAddTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get contactAddTooltip;

  /// No description provided for @contactSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search contacts and groups'**
  String get contactSearchHint;

  /// No description provided for @contactSetRemark.
  ///
  /// In en, this message translates to:
  /// **'Set Remark'**
  String get contactSetRemark;

  /// No description provided for @contactAddToBlacklist.
  ///
  /// In en, this message translates to:
  /// **'Add to Blacklist'**
  String get contactAddToBlacklist;

  /// No description provided for @contactDeleteFriend.
  ///
  /// In en, this message translates to:
  /// **'Delete Friend'**
  String get contactDeleteFriend;

  /// No description provided for @contactAddedToBlacklist.
  ///
  /// In en, this message translates to:
  /// **'Added to blacklist'**
  String get contactAddedToBlacklist;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed. Try again.'**
  String get operationFailed;

  /// No description provided for @operationFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'Operation failed: {error}'**
  String operationFailedWithError(String error);

  /// No description provided for @contactDeleteFriendConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete friend \"{name}\"?\nChat history will also be cleared.'**
  String contactDeleteFriendConfirm(Object name);

  /// No description provided for @contactConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get contactConfirmDelete;

  /// No description provided for @contactDeleted.
  ///
  /// In en, this message translates to:
  /// **'Friend deleted'**
  String get contactDeleted;

  /// No description provided for @contactUnknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown user'**
  String get contactUnknownUser;

  /// No description provided for @contactActionNewFriends.
  ///
  /// In en, this message translates to:
  /// **'New Friends'**
  String get contactActionNewFriends;

  /// No description provided for @contactActionSavedGroups.
  ///
  /// In en, this message translates to:
  /// **'Saved Groups'**
  String get contactActionSavedGroups;

  /// No description provided for @contactSearchNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matching contacts'**
  String get contactSearchNoMatches;

  /// No description provided for @addFriendTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriendTitle;

  /// No description provided for @addFriendSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Phone / {appName} ID'**
  String addFriendSearchHint(Object appName);

  /// No description provided for @addFriendNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found'**
  String get addFriendNotFound;

  /// No description provided for @myQrCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'My QR Code'**
  String get myQrCodeTitle;

  /// No description provided for @myQrCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code to add me on {appName}'**
  String myQrCodeSubtitle(Object appName);

  /// No description provided for @myQrCodeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No QR code'**
  String get myQrCodeEmpty;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanTitle;

  /// No description provided for @scanQrNotFound.
  ///
  /// In en, this message translates to:
  /// **'No QR code recognized'**
  String get scanQrNotFound;

  /// No description provided for @scanResolveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to parse QR code: {error}'**
  String scanResolveFailed(String error);

  /// No description provided for @scanUnrecognized.
  ///
  /// In en, this message translates to:
  /// **'This QR code cannot be recognized'**
  String get scanUnrecognized;

  /// No description provided for @scanInfoIncomplete.
  ///
  /// In en, this message translates to:
  /// **'QR code information is incomplete'**
  String get scanInfoIncomplete;

  /// No description provided for @scanSocialUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Social service is not initialized'**
  String get scanSocialUnavailable;

  /// No description provided for @scanJoinedGroup.
  ///
  /// In en, this message translates to:
  /// **'Joined group chat'**
  String get scanJoinedGroup;

  /// No description provided for @scanCannotOpenGroup.
  ///
  /// In en, this message translates to:
  /// **'This page cannot open group chats'**
  String get scanCannotOpenGroup;

  /// No description provided for @scanGroupNotFound.
  ///
  /// In en, this message translates to:
  /// **'Group chat not found'**
  String get scanGroupNotFound;

  /// No description provided for @scanOpenGroupFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to open group chat'**
  String get scanOpenGroupFailed;

  /// No description provided for @scanSelfQr.
  ///
  /// In en, this message translates to:
  /// **'This is your own QR code'**
  String get scanSelfQr;

  /// No description provided for @scanUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get scanUserNotFound;

  /// No description provided for @scanCameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get scanCameraPermissionRequired;

  /// No description provided for @scanOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get scanOpenSettings;

  /// No description provided for @scanCameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable'**
  String get scanCameraUnavailable;

  /// No description provided for @scanAlbum.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get scanAlbum;

  /// No description provided for @scanLightOn.
  ///
  /// In en, this message translates to:
  /// **'Light On'**
  String get scanLightOn;

  /// No description provided for @scanLightOff.
  ///
  /// In en, this message translates to:
  /// **'Light Off'**
  String get scanLightOff;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get scanQrCode;

  /// No description provided for @scanGroupFallback.
  ///
  /// In en, this message translates to:
  /// **'Group Chat'**
  String get scanGroupFallback;

  /// No description provided for @scanGroupLoadingInfo.
  ///
  /// In en, this message translates to:
  /// **'Loading group info'**
  String get scanGroupLoadingInfo;

  /// No description provided for @scanGroupMemberCount.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String scanGroupMemberCount(int count);

  /// No description provided for @scanJoinGroupConfirm.
  ///
  /// In en, this message translates to:
  /// **'Join Group Chat'**
  String get scanJoinGroupConfirm;

  /// No description provided for @scanJoining.
  ///
  /// In en, this message translates to:
  /// **'Joining'**
  String get scanJoining;

  /// No description provided for @scanJoinGroup.
  ///
  /// In en, this message translates to:
  /// **'Join Group Chat'**
  String get scanJoinGroup;

  /// No description provided for @scanJoinFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to join: {error}'**
  String scanJoinFailed(String error);

  /// No description provided for @tagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagsTitle;

  /// No description provided for @tagsCreateTooltip.
  ///
  /// In en, this message translates to:
  /// **'New Tag'**
  String get tagsCreateTooltip;

  /// No description provided for @tagsContactSection.
  ///
  /// In en, this message translates to:
  /// **'Contact Tags'**
  String get tagsContactSection;

  /// No description provided for @tagsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No tags'**
  String get tagsEmptyTitle;

  /// No description provided for @tagsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + in the top right to group contacts or chats.'**
  String get tagsEmptySubtitle;

  /// No description provided for @tagsCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create tag: {error}'**
  String tagsCreateFailed(Object error);

  /// No description provided for @tagsUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update tag: {error}'**
  String tagsUpdateFailed(Object error);

  /// No description provided for @tagsDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete tag: {error}'**
  String tagsDeleteFailed(Object error);

  /// No description provided for @tagsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tags: {error}'**
  String tagsLoadFailed(Object error);

  /// No description provided for @tagsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete tag \"{name}\"?\nContacts and groups in this tag will not be deleted.'**
  String tagsDeleteConfirm(String name);

  /// No description provided for @tagsEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Tag'**
  String get tagsEditTitle;

  /// No description provided for @tagsCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New Tag'**
  String get tagsCreateTitle;

  /// No description provided for @tagsNameSection.
  ///
  /// In en, this message translates to:
  /// **'Tag Name'**
  String get tagsNameSection;

  /// No description provided for @tagsNameHint.
  ///
  /// In en, this message translates to:
  /// **'Family, friends'**
  String get tagsNameHint;

  /// No description provided for @tagsMembersSection.
  ///
  /// In en, this message translates to:
  /// **'Tag Members ({count})'**
  String tagsMembersSection(int count);

  /// No description provided for @tagsAddMember.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get tagsAddMember;

  /// No description provided for @tagsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Tag'**
  String get tagsDelete;

  /// No description provided for @tagsGroupInitial.
  ///
  /// In en, this message translates to:
  /// **'G'**
  String get tagsGroupInitial;

  /// No description provided for @tagsUnknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown user'**
  String get tagsUnknownUser;

  /// No description provided for @tagsSelectMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Members'**
  String get tagsSelectMembersTitle;

  /// No description provided for @tagsDoneCount.
  ///
  /// In en, this message translates to:
  /// **'Done ({count})'**
  String tagsDoneCount(int count);

  /// No description provided for @tagsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search contacts or groups'**
  String get tagsSearchHint;

  /// No description provided for @tagsGroupsSection.
  ///
  /// In en, this message translates to:
  /// **'Group Chats'**
  String get tagsGroupsSection;

  /// No description provided for @tagsContactsSection.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get tagsContactsSection;

  /// No description provided for @tagsNoMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get tagsNoMatchesTitle;

  /// No description provided for @tagsNoMatchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try another keyword'**
  String get tagsNoMatchesSubtitle;

  /// No description provided for @tagsRowTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} ({count})'**
  String tagsRowTitle(String name, int count);

  /// No description provided for @phoneContactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Contacts'**
  String get phoneContactsTitle;

  /// No description provided for @phoneContactsSection.
  ///
  /// In en, this message translates to:
  /// **'Add from phone contacts'**
  String get phoneContactsSection;

  /// No description provided for @phoneContactsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No phone contacts'**
  String get phoneContactsEmpty;

  /// No description provided for @phoneContactsNoAddable.
  ///
  /// In en, this message translates to:
  /// **'No phone contacts to add'**
  String get phoneContactsNoAddable;

  /// No description provided for @phoneContactsServerSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Server sync failed. Showing existing contacts.'**
  String get phoneContactsServerSyncFailed;

  /// No description provided for @friendAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get friendAlreadyAdded;

  /// No description provided for @friendRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent'**
  String get friendRequestSent;

  /// No description provided for @phoneContactsInviteSmsBody.
  ///
  /// In en, this message translates to:
  /// **'I\'m using {appName}. The chat experience is pretty nice. Come try it too.'**
  String phoneContactsInviteSmsBody(Object appName);

  /// No description provided for @phoneContactsInviteOpened.
  ///
  /// In en, this message translates to:
  /// **'SMS invite opened'**
  String get phoneContactsInviteOpened;

  /// No description provided for @phoneContactsInviteFailed.
  ///
  /// In en, this message translates to:
  /// **'Cannot open SMS. Please invite manually.'**
  String get phoneContactsInviteFailed;

  /// No description provided for @friendRequestsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No new friends'**
  String get friendRequestsEmptyTitle;

  /// No description provided for @friendRequestsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invite friends to scan your QR code'**
  String get friendRequestsEmptySubtitle;

  /// No description provided for @friendRequestsPendingSection.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get friendRequestsPendingSection;

  /// No description provided for @friendRequestRefused.
  ///
  /// In en, this message translates to:
  /// **'Refused'**
  String get friendRequestRefused;

  /// No description provided for @contactOpenFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Open @{name}\'s chat from Contacts'**
  String contactOpenFromContacts(Object name);

  /// No description provided for @fileHelperIntro.
  ///
  /// In en, this message translates to:
  /// **'Log in to the web version and send me messages to transfer text, photos, audio, videos, and files between phone and computer.'**
  String get fileHelperIntro;

  /// No description provided for @fileHelperName.
  ///
  /// In en, this message translates to:
  /// **'File Transfer'**
  String get fileHelperName;

  /// No description provided for @systemAccountName.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemAccountName;

  /// No description provided for @systemAccountIntro.
  ///
  /// In en, this message translates to:
  /// **'Official {appName} account for sending notifications.'**
  String systemAccountIntro(Object appName);

  /// No description provided for @contactIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get contactIntroTitle;

  /// No description provided for @contactSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get contactSource;

  /// No description provided for @contactRemoveFriendRelation.
  ///
  /// In en, this message translates to:
  /// **'Remove Friend'**
  String get contactRemoveFriendRelation;

  /// No description provided for @contactRemoveFromBlacklist.
  ///
  /// In en, this message translates to:
  /// **'Remove from Blacklist'**
  String get contactRemoveFromBlacklist;

  /// No description provided for @contactSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get contactSendMessage;

  /// No description provided for @contactAddToContacts.
  ///
  /// In en, this message translates to:
  /// **'Add to Contacts'**
  String get contactAddToContacts;

  /// No description provided for @contactRemoveFriendConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this friend?'**
  String get contactRemoveFriendConfirm;

  /// No description provided for @contactNicknameLine.
  ///
  /// In en, this message translates to:
  /// **'Nickname: {name}'**
  String contactNicknameLine(Object name);

  /// No description provided for @contactRemoveFromBlacklistConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this contact from the blacklist?'**
  String get contactRemoveFromBlacklistConfirm;

  /// No description provided for @webLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Web Login'**
  String get webLoginTitle;

  /// No description provided for @webLoginConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm web login?'**
  String get webLoginConfirmTitle;

  /// No description provided for @webLoginConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will allow your account to log in to the current browser or desktop client. If this wasn\'t you, tap Cancel.'**
  String get webLoginConfirmBody;

  /// No description provided for @webLoginConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm Login'**
  String get webLoginConfirmAction;

  /// No description provided for @webLoginConfirming.
  ///
  /// In en, this message translates to:
  /// **'Confirming...'**
  String get webLoginConfirming;

  /// No description provided for @webLoginConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Web login confirmed'**
  String get webLoginConfirmed;

  /// No description provided for @webLoginConfirmFailed.
  ///
  /// In en, this message translates to:
  /// **'Confirmation failed: {error}'**
  String webLoginConfirmFailed(Object error);

  /// No description provided for @applyFriendTitle.
  ///
  /// In en, this message translates to:
  /// **'Friend Request'**
  String get applyFriendTitle;

  /// No description provided for @applyFriendSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Send Friend Request'**
  String get applyFriendSectionTitle;

  /// No description provided for @applyFriendRemarkHint.
  ///
  /// In en, this message translates to:
  /// **'Hi, I\'m...'**
  String get applyFriendRemarkHint;

  /// No description provided for @friendRequestSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send: {error}'**
  String friendRequestSendFailed(Object error);

  /// No description provided for @contactRemarkHint.
  ///
  /// In en, this message translates to:
  /// **'Remark'**
  String get contactRemarkHint;

  /// No description provided for @momentPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Moments Privacy'**
  String get momentPermissionsTitle;

  /// No description provided for @momentHideMineFromContact.
  ///
  /// In en, this message translates to:
  /// **'Hide my Moments from them'**
  String get momentHideMineFromContact;

  /// No description provided for @momentHideContactFromMe.
  ///
  /// In en, this message translates to:
  /// **'Hide their Moments from me'**
  String get momentHideContactFromMe;

  /// No description provided for @momentTitle.
  ///
  /// In en, this message translates to:
  /// **'Moments'**
  String get momentTitle;

  /// No description provided for @momentPersonalEmpty.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get momentPersonalEmpty;

  /// No description provided for @momentEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Moments yet'**
  String get momentEmpty;

  /// No description provided for @momentCoverUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload cover'**
  String get momentCoverUploadFailed;

  /// No description provided for @momentCoverUploadFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload cover: {error}'**
  String momentCoverUploadFailedWithError(Object error);

  /// No description provided for @momentDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this Moment?'**
  String get momentDeleteConfirm;

  /// No description provided for @momentJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get momentJustNow;

  /// No description provided for @momentPublishing.
  ///
  /// In en, this message translates to:
  /// **'Posting…'**
  String get momentPublishing;

  /// No description provided for @momentPublishFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to post. Tap to dismiss.'**
  String get momentPublishFailed;

  /// No description provided for @momentRemindedYou.
  ///
  /// In en, this message translates to:
  /// **'Reminded you to view this Moment'**
  String get momentRemindedYou;

  /// No description provided for @momentRemindedNames.
  ///
  /// In en, this message translates to:
  /// **'Reminded {names}'**
  String momentRemindedNames(Object names);

  /// No description provided for @momentKeepEditingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Keep this edit?'**
  String get momentKeepEditingConfirm;

  /// No description provided for @momentContinueEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep Editing'**
  String get momentContinueEditing;

  /// No description provided for @momentSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get momentSaveDraft;

  /// No description provided for @momentDiscardDraft.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get momentDiscardDraft;

  /// No description provided for @momentPublishTitle.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get momentPublishTitle;

  /// No description provided for @momentPublishHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind...'**
  String get momentPublishHint;

  /// No description provided for @momentLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get momentLocationTitle;

  /// No description provided for @momentRemindWho.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get momentRemindWho;

  /// No description provided for @locationUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Location is not available in this version'**
  String get locationUnsupported;

  /// No description provided for @momentPrivacyContactCount.
  ///
  /// In en, this message translates to:
  /// **'{label} · {count}'**
  String momentPrivacyContactCount(Object count, Object label);

  /// No description provided for @momentSelectVisibleContacts.
  ///
  /// In en, this message translates to:
  /// **'Select Visible Contacts'**
  String get momentSelectVisibleContacts;

  /// No description provided for @momentSelectHiddenContacts.
  ///
  /// In en, this message translates to:
  /// **'Select Hidden Contacts'**
  String get momentSelectHiddenContacts;

  /// No description provided for @momentPrivacyPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get momentPrivacyPublic;

  /// No description provided for @momentPrivacyPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get momentPrivacyPrivate;

  /// No description provided for @momentPrivacyInternal.
  ///
  /// In en, this message translates to:
  /// **'Visible to Some'**
  String get momentPrivacyInternal;

  /// No description provided for @momentPrivacyProhibit.
  ///
  /// In en, this message translates to:
  /// **'Hide From'**
  String get momentPrivacyProhibit;

  /// No description provided for @momentPrivacyWhoCanSee.
  ///
  /// In en, this message translates to:
  /// **'Who Can See'**
  String get momentPrivacyWhoCanSee;

  /// No description provided for @momentCommentFailed.
  ///
  /// In en, this message translates to:
  /// **'Comment failed: {error}'**
  String momentCommentFailed(Object error);

  /// No description provided for @momentDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get momentDetailTitle;

  /// No description provided for @momentDeleted.
  ///
  /// In en, this message translates to:
  /// **'This Moment was deleted'**
  String get momentDeleted;

  /// No description provided for @momentCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get momentCollapse;

  /// No description provided for @momentFullText.
  ///
  /// In en, this message translates to:
  /// **'Full Text'**
  String get momentFullText;

  /// No description provided for @momentDeleteCommentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this comment?'**
  String get momentDeleteCommentConfirm;

  /// No description provided for @momentCommentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get momentCommentPlaceholder;

  /// No description provided for @momentReplyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Reply {name}'**
  String momentReplyPlaceholder(Object name);

  /// No description provided for @momentLikeAction.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get momentLikeAction;

  /// No description provided for @momentCommentAction.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get momentCommentAction;

  /// No description provided for @momentNewMessages.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 new message} other{{count} new messages}}'**
  String momentNewMessages(num count);

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @messagesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get messagesEmpty;

  /// No description provided for @messagesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get messagesEmptyTitle;

  /// No description provided for @messagesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start a new chat from the top right'**
  String get messagesEmptySubtitle;

  /// No description provided for @messagesNewConversation.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get messagesNewConversation;

  /// No description provided for @messagesStartGroupChat.
  ///
  /// In en, this message translates to:
  /// **'Start Group Chat'**
  String get messagesStartGroupChat;

  /// No description provided for @messagesImDisconnected.
  ///
  /// In en, this message translates to:
  /// **'IM is not connected'**
  String get messagesImDisconnected;

  /// No description provided for @messagesPinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get messagesPinned;

  /// No description provided for @messagesUnpinned.
  ///
  /// In en, this message translates to:
  /// **'Unpinned'**
  String get messagesUnpinned;

  /// No description provided for @messagesMuted.
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get messagesMuted;

  /// No description provided for @messagesNotificationsOn.
  ///
  /// In en, this message translates to:
  /// **'Notifications on'**
  String get messagesNotificationsOn;

  /// No description provided for @messagesDeleteConversationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String messagesDeleteConversationTitle(String name);

  /// No description provided for @messagesConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get messagesConfirmDelete;

  /// No description provided for @messagesCleared.
  ///
  /// In en, this message translates to:
  /// **'Chat history cleared'**
  String get messagesCleared;

  /// No description provided for @messagesConversationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Conversation deleted'**
  String get messagesConversationDeleted;

  /// No description provided for @messagesUnknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown user'**
  String get messagesUnknownUser;

  /// No description provided for @messagesFriendAvatarFallback.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get messagesFriendAvatarFallback;

  /// No description provided for @messagesGroupFallback.
  ///
  /// In en, this message translates to:
  /// **'Group Chat'**
  String get messagesGroupFallback;

  /// No description provided for @messagesGroupAvatarFallback.
  ///
  /// In en, this message translates to:
  /// **'G'**
  String get messagesGroupAvatarFallback;

  /// No description provided for @messagesNewMessageDigest.
  ///
  /// In en, this message translates to:
  /// **'[New message]'**
  String get messagesNewMessageDigest;

  /// No description provided for @messagesConversationPin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get messagesConversationPin;

  /// No description provided for @messagesConversationUnpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get messagesConversationUnpin;

  /// No description provided for @messagesConversationMute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get messagesConversationMute;

  /// No description provided for @messagesConversationUnmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get messagesConversationUnmute;

  /// No description provided for @messagesConnectionNoNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Check your connection.'**
  String get messagesConnectionNoNetwork;

  /// No description provided for @messagesConnectionDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get messagesConnectionDisconnected;

  /// No description provided for @messagesConnectionConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get messagesConnectionConnecting;

  /// No description provided for @messagesConnectionSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get messagesConnectionSyncing;

  /// No description provided for @globalSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get globalSearchTitle;

  /// No description provided for @globalSearchTabChats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get globalSearchTabChats;

  /// No description provided for @globalSearchTabContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get globalSearchTabContacts;

  /// No description provided for @globalSearchTabGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get globalSearchTabGroups;

  /// No description provided for @globalSearchTabFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get globalSearchTabFiles;

  /// No description provided for @globalSearchContactsSection.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get globalSearchContactsSection;

  /// No description provided for @globalSearchGroupsSection.
  ///
  /// In en, this message translates to:
  /// **'Group Chats'**
  String get globalSearchGroupsSection;

  /// No description provided for @globalSearchMessagesSection.
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get globalSearchMessagesSection;

  /// No description provided for @globalSearchFilesSection.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get globalSearchFilesSection;

  /// No description provided for @globalSearchNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get globalSearchNoMatches;

  /// No description provided for @globalSearchNoMore.
  ///
  /// In en, this message translates to:
  /// **'No more results'**
  String get globalSearchNoMore;

  /// No description provided for @locationLocating.
  ///
  /// In en, this message translates to:
  /// **'Locating...'**
  String get locationLocating;

  /// No description provided for @locationPermissionOff.
  ///
  /// In en, this message translates to:
  /// **'Location permission is off. Allow {appName} to use location in system settings.'**
  String locationPermissionOff(Object appName);

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission was denied. Nearby places cannot be loaded.'**
  String get locationPermissionDenied;

  /// No description provided for @locationMapUnsupported.
  ///
  /// In en, this message translates to:
  /// **'AMap is not supported on this platform'**
  String get locationMapUnsupported;

  /// No description provided for @locationFailed.
  ///
  /// In en, this message translates to:
  /// **'Location failed: {error}'**
  String locationFailed(String error);

  /// No description provided for @locationSearchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter keywords to search nearby places'**
  String get locationSearchPrompt;

  /// No description provided for @locationNoNearbyPoi.
  ///
  /// In en, this message translates to:
  /// **'No nearby POI'**
  String get locationNoNearbyPoi;

  /// No description provided for @locationSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search nearby places'**
  String get locationSearchHint;

  /// No description provided for @locationPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationPickerTitle;

  /// No description provided for @locationSending.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get locationSending;

  /// No description provided for @locationUnnamed.
  ///
  /// In en, this message translates to:
  /// **'Unnamed place'**
  String get locationUnnamed;

  /// No description provided for @locationCopiedAddress.
  ///
  /// In en, this message translates to:
  /// **'Address copied'**
  String get locationCopiedAddress;

  /// No description provided for @locationNoMapApp.
  ///
  /// In en, this message translates to:
  /// **'No map app available'**
  String get locationNoMapApp;

  /// No description provided for @locationFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationFallbackTitle;

  /// No description provided for @locationAmap.
  ///
  /// In en, this message translates to:
  /// **'AMap'**
  String get locationAmap;

  /// No description provided for @locationBaiduMap.
  ///
  /// In en, this message translates to:
  /// **'Baidu Maps'**
  String get locationBaiduMap;

  /// No description provided for @locationTencentMap.
  ///
  /// In en, this message translates to:
  /// **'Tencent Maps'**
  String get locationTencentMap;

  /// No description provided for @locationAppleMap.
  ///
  /// In en, this message translates to:
  /// **'Apple Maps'**
  String get locationAppleMap;

  /// No description provided for @locationOtherMap.
  ///
  /// In en, this message translates to:
  /// **'Other Maps'**
  String get locationOtherMap;

  /// No description provided for @locationMyLocation.
  ///
  /// In en, this message translates to:
  /// **'My Location'**
  String get locationMyLocation;

  /// No description provided for @locationOpenMapFailed.
  ///
  /// In en, this message translates to:
  /// **'Cannot open {name}'**
  String locationOpenMapFailed(String name);

  /// No description provided for @locationCopyAddress.
  ///
  /// In en, this message translates to:
  /// **'Copy Address'**
  String get locationCopyAddress;

  /// No description provided for @locationNavigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get locationNavigate;

  /// No description provided for @locationViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get locationViewTitle;

  /// No description provided for @momentPeerCommentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Comment deleted'**
  String get momentPeerCommentDeleted;

  /// No description provided for @momentDigest.
  ///
  /// In en, this message translates to:
  /// **'[Moment]'**
  String get momentDigest;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @saveToAlbum.
  ///
  /// In en, this message translates to:
  /// **'Save to Album'**
  String get saveToAlbum;

  /// No description provided for @savedToAlbum.
  ///
  /// In en, this message translates to:
  /// **'Saved to album'**
  String get savedToAlbum;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get saveFailed;

  /// No description provided for @dateMonth.
  ///
  /// In en, this message translates to:
  /// **'{month}'**
  String dateMonth(Object month);

  /// No description provided for @dateMonthYear.
  ///
  /// In en, this message translates to:
  /// **'{month}\n{year}'**
  String dateMonthYear(Object month, Object year);

  /// No description provided for @momentExtraImages.
  ///
  /// In en, this message translates to:
  /// **'{count} photos'**
  String momentExtraImages(Object count);

  /// No description provided for @momentReplyConnector.
  ///
  /// In en, this message translates to:
  /// **' replied to '**
  String get momentReplyConnector;

  /// No description provided for @groupRemarkTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Remark'**
  String get groupRemarkTitle;

  /// No description provided for @groupRemarkHint.
  ///
  /// In en, this message translates to:
  /// **'Set a group remark visible only to you'**
  String get groupRemarkHint;

  /// No description provided for @chatNotificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Message Notifications'**
  String get chatNotificationSettingsTitle;

  /// No description provided for @chatScreenshotNotification.
  ///
  /// In en, this message translates to:
  /// **'Screenshot Notifications'**
  String get chatScreenshotNotification;

  /// No description provided for @chatRevokeNotification.
  ///
  /// In en, this message translates to:
  /// **'Recall Notifications'**
  String get chatRevokeNotification;

  /// No description provided for @completeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get completeProfileTitle;

  /// No description provided for @completeProfileUploadAvatar.
  ///
  /// In en, this message translates to:
  /// **'Upload Avatar'**
  String get completeProfileUploadAvatar;

  /// No description provided for @completeProfileReuploadAvatar.
  ///
  /// In en, this message translates to:
  /// **'Upload New Avatar'**
  String get completeProfileReuploadAvatar;

  /// No description provided for @completeProfileChooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose a profile photo'**
  String get completeProfileChooseAvatar;

  /// No description provided for @completeProfileAvatarUploaded.
  ///
  /// In en, this message translates to:
  /// **'Avatar uploaded'**
  String get completeProfileAvatarUploaded;

  /// No description provided for @completeProfileAvatarRequired.
  ///
  /// In en, this message translates to:
  /// **'Avatar is required.'**
  String get completeProfileAvatarRequired;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @nicknameInputHint.
  ///
  /// In en, this message translates to:
  /// **'Enter nickname'**
  String get nicknameInputHint;

  /// No description provided for @nicknameRequired.
  ///
  /// In en, this message translates to:
  /// **'Nickname is required.'**
  String get nicknameRequired;

  /// No description provided for @completeProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile completed'**
  String get completeProfileSaved;

  /// No description provided for @chatSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat Details'**
  String get chatSettingsTitle;

  /// No description provided for @chatSettingsGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat Info ({count})'**
  String chatSettingsGroupTitle(Object count);

  /// No description provided for @chatSettingsGroupName.
  ///
  /// In en, this message translates to:
  /// **'Group Chat Name'**
  String get chatSettingsGroupName;

  /// No description provided for @chatSettingsGroupQrCode.
  ///
  /// In en, this message translates to:
  /// **'Group QR Code'**
  String get chatSettingsGroupQrCode;

  /// No description provided for @chatSearchContentTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Chat'**
  String get chatSearchContentTitle;

  /// No description provided for @chatSettingsBackground.
  ///
  /// In en, this message translates to:
  /// **'Set Chat Background'**
  String get chatSettingsBackground;

  /// No description provided for @chatSettingsBackgroundSelected.
  ///
  /// In en, this message translates to:
  /// **'Current chat background set'**
  String get chatSettingsBackgroundSelected;

  /// No description provided for @chatSettingsMute.
  ///
  /// In en, this message translates to:
  /// **'Mute Notifications'**
  String get chatSettingsMute;

  /// No description provided for @chatSettingsPin.
  ///
  /// In en, this message translates to:
  /// **'Pin Chat'**
  String get chatSettingsPin;

  /// No description provided for @chatSettingsSaveToContacts.
  ///
  /// In en, this message translates to:
  /// **'Save to Contacts'**
  String get chatSettingsSaveToContacts;

  /// No description provided for @chatSettingsReadReceipt.
  ///
  /// In en, this message translates to:
  /// **'Read Receipts'**
  String get chatSettingsReadReceipt;

  /// No description provided for @chatSettingsReadReceiptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When enabled, sent messages show read/unread status'**
  String get chatSettingsReadReceiptSubtitle;

  /// No description provided for @chatSettingsFlame.
  ///
  /// In en, this message translates to:
  /// **'Burn After Reading'**
  String get chatSettingsFlame;

  /// No description provided for @chatFlameTipExit.
  ///
  /// In en, this message translates to:
  /// **'Read messages are destroyed after leaving chat'**
  String get chatFlameTipExit;

  /// No description provided for @chatFlameTipMinutes.
  ///
  /// In en, this message translates to:
  /// **'Messages are destroyed {minutes} min after being read'**
  String chatFlameTipMinutes(Object minutes);

  /// No description provided for @chatFlameTipSeconds.
  ///
  /// In en, this message translates to:
  /// **'Messages are destroyed {seconds}s after being read'**
  String chatFlameTipSeconds(Object seconds);

  /// No description provided for @chatFlameLabelMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String chatFlameLabelMinutes(Object minutes);

  /// No description provided for @chatFlameLabelSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String chatFlameLabelSeconds(Object seconds);

  /// No description provided for @chatSettingsGroupNickname.
  ///
  /// In en, this message translates to:
  /// **'My Group Nickname'**
  String get chatSettingsGroupNickname;

  /// No description provided for @chatSettingsBlacklisted.
  ///
  /// In en, this message translates to:
  /// **'Blacklisted'**
  String get chatSettingsBlacklisted;

  /// No description provided for @chatSettingsPeerBlacklisted.
  ///
  /// In en, this message translates to:
  /// **'This contact is already blacklisted'**
  String get chatSettingsPeerBlacklisted;

  /// No description provided for @chatSettingsComplaint.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get chatSettingsComplaint;

  /// No description provided for @chatSettingsDeleteAndExit.
  ///
  /// In en, this message translates to:
  /// **'Delete and Exit'**
  String get chatSettingsDeleteAndExit;

  /// No description provided for @groupRemarkSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sync group remark: {error}'**
  String groupRemarkSyncFailed(Object error);

  /// No description provided for @chatSocialDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Social service is not connected'**
  String get chatSocialDisconnected;

  /// No description provided for @chatNoRemovableMembers.
  ///
  /// In en, this message translates to:
  /// **'No removable members'**
  String get chatNoRemovableMembers;

  /// No description provided for @chatSelectMembersToRemove.
  ///
  /// In en, this message translates to:
  /// **'Select Members to Remove'**
  String get chatSelectMembersToRemove;

  /// No description provided for @chatMemberNameQuoted.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\"'**
  String chatMemberNameQuoted(Object name);

  /// No description provided for @chatMemberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 member} other{{count} members}}'**
  String chatMemberCount(num count);

  /// No description provided for @chatRemoveMembersConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {names} from the group'**
  String chatRemoveMembersConfirm(Object names);

  /// No description provided for @chatMembersRemoved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Removed 1 member} other{Removed {count} members}}'**
  String chatMembersRemoved(num count);

  /// No description provided for @chatRemoveMembersFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove members: {error}'**
  String chatRemoveMembersFailed(Object error);

  /// No description provided for @chatNoInviteCandidates.
  ///
  /// In en, this message translates to:
  /// **'No contacts available to invite'**
  String get chatNoInviteCandidates;

  /// No description provided for @chatInviteMembers.
  ///
  /// In en, this message translates to:
  /// **'Invite Members'**
  String get chatInviteMembers;

  /// No description provided for @chatSelectContacts.
  ///
  /// In en, this message translates to:
  /// **'Select Contacts'**
  String get chatSelectContacts;

  /// No description provided for @chatMembersInvited.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Invited 1 member} other{Invited {count} members}}'**
  String chatMembersInvited(num count);

  /// No description provided for @chatInviteMembersFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to invite members: {error}'**
  String chatInviteMembersFailed(Object error);

  /// No description provided for @chatGroupCreated.
  ///
  /// In en, this message translates to:
  /// **'Group chat created. Check the chat list.'**
  String get chatGroupCreated;

  /// No description provided for @chatGroupCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create group chat'**
  String get chatGroupCreateFailed;

  /// No description provided for @chatGroupCreateFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'Failed to create group chat: {error}'**
  String chatGroupCreateFailedWithError(Object error);

  /// No description provided for @chatClearCurrentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear the current chat history?'**
  String get chatClearCurrentConfirm;

  /// No description provided for @chatDeleteAndExitConfirm.
  ///
  /// In en, this message translates to:
  /// **'After deleting and exiting, you will no longer receive messages from this group.'**
  String get chatDeleteAndExitConfirm;

  /// No description provided for @chatBlockConfirm.
  ///
  /// In en, this message translates to:
  /// **'After adding this contact to the blacklist, you will no longer receive their messages.'**
  String get chatBlockConfirm;

  /// No description provided for @chatSearchTabAll.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chatSearchTabAll;

  /// No description provided for @chatSearchTabMedia.
  ///
  /// In en, this message translates to:
  /// **'Photos/Videos'**
  String get chatSearchTabMedia;

  /// No description provided for @chatSearchTabFile.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get chatSearchTabFile;

  /// No description provided for @chatSearchNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matching chat history'**
  String get chatSearchNoMatches;

  /// No description provided for @chatSearchNoMore.
  ///
  /// In en, this message translates to:
  /// **'No more results'**
  String get chatSearchNoMore;

  /// No description provided for @chatDetailsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Chat Details'**
  String get chatDetailsTooltip;

  /// No description provided for @chatVoiceInputTooltip.
  ///
  /// In en, this message translates to:
  /// **'Voice Input'**
  String get chatVoiceInputTooltip;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Message...'**
  String get chatInputHint;

  /// No description provided for @chatFlameEnabledTooltip.
  ///
  /// In en, this message translates to:
  /// **'Burn after reading is on'**
  String get chatFlameEnabledTooltip;

  /// No description provided for @chatFlameDestroyOnExit.
  ///
  /// In en, this message translates to:
  /// **'Destroy after leaving chat'**
  String get chatFlameDestroyOnExit;

  /// No description provided for @chatFlameDestroyAfterMinutes.
  ///
  /// In en, this message translates to:
  /// **'Destroy after {minutes} min'**
  String chatFlameDestroyAfterMinutes(Object minutes);

  /// No description provided for @chatFlameDestroyAfterSeconds.
  ///
  /// In en, this message translates to:
  /// **'Destroy after {seconds}s'**
  String chatFlameDestroyAfterSeconds(Object seconds);

  /// No description provided for @chatFlameEnabledNotice.
  ///
  /// In en, this message translates to:
  /// **'Burn after reading is on. Messages will be destroyed {label} after reading. Use the top-right settings to turn it off.'**
  String chatFlameEnabledNotice(Object label);

  /// No description provided for @chatEmojiTooltip.
  ///
  /// In en, this message translates to:
  /// **'Emoji'**
  String get chatEmojiTooltip;

  /// No description provided for @chatActionReply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get chatActionReply;

  /// No description provided for @chatActionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get chatActionCopy;

  /// No description provided for @chatActionTranslate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get chatActionTranslate;

  /// No description provided for @chatActionTranscribe.
  ///
  /// In en, this message translates to:
  /// **'Transcribe'**
  String get chatActionTranscribe;

  /// No description provided for @chatActionForward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get chatActionForward;

  /// No description provided for @chatActionFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get chatActionFavorite;

  /// No description provided for @chatActionPin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get chatActionPin;

  /// No description provided for @chatActionUnpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get chatActionUnpin;

  /// No description provided for @chatActionAddFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get chatActionAddFriend;

  /// No description provided for @chatActionMultiSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get chatActionMultiSelect;

  /// No description provided for @chatActionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get chatActionEdit;

  /// No description provided for @chatActionEditImage.
  ///
  /// In en, this message translates to:
  /// **'Edit Image'**
  String get chatActionEditImage;

  /// No description provided for @chatActionRevoke.
  ///
  /// In en, this message translates to:
  /// **'Recall'**
  String get chatActionRevoke;

  /// No description provided for @chatActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get chatActionDelete;

  /// No description provided for @chatGroupCallActive.
  ///
  /// In en, this message translates to:
  /// **'Group call in progress'**
  String get chatGroupCallActive;

  /// No description provided for @chatMessageRevokedBy.
  ///
  /// In en, this message translates to:
  /// **'{name} recalled a message'**
  String chatMessageRevokedBy(Object name);

  /// No description provided for @chatReedit.
  ///
  /// In en, this message translates to:
  /// **'Re-edit'**
  String get chatReedit;

  /// No description provided for @chatEditedSuffix.
  ///
  /// In en, this message translates to:
  /// **' (edited)'**
  String get chatEditedSuffix;

  /// No description provided for @chatActionReadBy.
  ///
  /// In en, this message translates to:
  /// **'Read by {count}'**
  String chatActionReadBy(Object count);

  /// No description provided for @chatActionReactedBy.
  ///
  /// In en, this message translates to:
  /// **'{count} reactions'**
  String chatActionReactedBy(Object count);

  /// No description provided for @chatSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Selected 1 item} other{Selected {count} items}}'**
  String chatSelectedCount(num count);

  /// No description provided for @chatNoReactions.
  ///
  /// In en, this message translates to:
  /// **'No reactions yet'**
  String get chatNoReactions;

  /// No description provided for @chatReadStatusReadCount.
  ///
  /// In en, this message translates to:
  /// **'Read ({count})'**
  String chatReadStatusReadCount(Object count);

  /// No description provided for @chatNoReadReceipts.
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get chatNoReadReceipts;

  /// No description provided for @chatHistoryAbove.
  ///
  /// In en, this message translates to:
  /// **'Earlier messages above'**
  String get chatHistoryAbove;

  /// No description provided for @chatUnreadNewMessages.
  ///
  /// In en, this message translates to:
  /// **'{count} new messages'**
  String chatUnreadNewMessages(Object count);

  /// No description provided for @chatUnreadDivider.
  ///
  /// In en, this message translates to:
  /// **'New messages below'**
  String get chatUnreadDivider;

  /// No description provided for @chatUnknownContentFallback.
  ///
  /// In en, this message translates to:
  /// **'This version cannot display this message. Update to the latest version.'**
  String get chatUnknownContentFallback;

  /// No description provided for @chatMentionSomeone.
  ///
  /// In en, this message translates to:
  /// **'Someone mentioned you'**
  String get chatMentionSomeone;

  /// No description provided for @chatToolAlbum.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get chatToolAlbum;

  /// No description provided for @chatToolCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get chatToolCamera;

  /// No description provided for @chatToolFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get chatToolFile;

  /// No description provided for @chatToolLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get chatToolLocation;

  /// No description provided for @chatToolContactCard.
  ///
  /// In en, this message translates to:
  /// **'Contact Card'**
  String get chatToolContactCard;

  /// No description provided for @chatToolAudioCall.
  ///
  /// In en, this message translates to:
  /// **'Voice Call'**
  String get chatToolAudioCall;

  /// No description provided for @chatToolVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Video Call'**
  String get chatToolVideoCall;

  /// No description provided for @chatDraftLabel.
  ///
  /// In en, this message translates to:
  /// **'[Draft]'**
  String get chatDraftLabel;

  /// No description provided for @visitorBadge.
  ///
  /// In en, this message translates to:
  /// **'Visitor'**
  String get visitorBadge;

  /// No description provided for @chatNoticeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get chatNoticeDeleted;

  /// No description provided for @chatNoticeCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get chatNoticeCopied;

  /// No description provided for @chatMentionLoadedOrInvisible.
  ///
  /// In en, this message translates to:
  /// **'The @ message is loaded or not visible. Scroll up to find it.'**
  String get chatMentionLoadedOrInvisible;

  /// No description provided for @chatLocationDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get chatLocationDefaultTitle;

  /// No description provided for @chatLocationCopied.
  ///
  /// In en, this message translates to:
  /// **'Location copied'**
  String get chatLocationCopied;

  /// No description provided for @chatReadStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Read Status'**
  String get chatReadStatusTitle;

  /// No description provided for @chatReadStatusRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get chatReadStatusRead;

  /// No description provided for @chatReadStatusUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get chatReadStatusUnread;

  /// No description provided for @chatReadStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Full read/unread lists are not available yet'**
  String get chatReadStatusUnavailable;

  /// No description provided for @chatComposerLeft.
  ///
  /// In en, this message translates to:
  /// **'You left this chat'**
  String get chatComposerLeft;

  /// No description provided for @chatComposerMuted.
  ///
  /// In en, this message translates to:
  /// **'This chat is muted'**
  String get chatComposerMuted;

  /// No description provided for @chatComposerMutedUntil.
  ///
  /// In en, this message translates to:
  /// **'You are muted until {time}'**
  String chatComposerMutedUntil(Object time);

  /// No description provided for @chatFavoriteCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Favorited 1 message} other{Favorited {count} messages}}'**
  String chatFavoriteCount(num count);

  /// No description provided for @chatFavoritePartial.
  ///
  /// In en, this message translates to:
  /// **'Favorites complete: {success} succeeded, {failed} failed'**
  String chatFavoritePartial(Object failed, Object success);

  /// No description provided for @chatForwardUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Cannot forward right now'**
  String get chatForwardUnavailable;

  /// No description provided for @chatMergedForwardedTo.
  ///
  /// In en, this message translates to:
  /// **'Merged {count} messages to {name}'**
  String chatMergedForwardedTo(Object count, Object name);

  /// No description provided for @chatForwardedIndividuallyTo.
  ///
  /// In en, this message translates to:
  /// **'Forwarded {count} messages one by one to {name}'**
  String chatForwardedIndividuallyTo(Object count, Object name);

  /// No description provided for @chatForwardedPartialTo.
  ///
  /// In en, this message translates to:
  /// **'Forwarded {sent}/{total} messages to {name}'**
  String chatForwardedPartialTo(Object name, Object sent, Object total);

  /// No description provided for @chatForwardModeIndividual.
  ///
  /// In en, this message translates to:
  /// **'Forward One by One'**
  String get chatForwardModeIndividual;

  /// No description provided for @chatForwardModeMerge.
  ///
  /// In en, this message translates to:
  /// **'Merge and Forward'**
  String get chatForwardModeMerge;

  /// No description provided for @chatPresenceOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get chatPresenceOnline;

  /// No description provided for @chatPresenceOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get chatPresenceOffline;

  /// No description provided for @chatPresenceJustActive.
  ///
  /// In en, this message translates to:
  /// **'Active just now'**
  String get chatPresenceJustActive;

  /// No description provided for @chatPresenceMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'Active {minutes} min ago'**
  String chatPresenceMinutesAgo(Object minutes);

  /// No description provided for @chatPresenceHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'Active {hours} hr ago'**
  String chatPresenceHoursAgo(Object hours);

  /// No description provided for @chatPresenceDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Active {days} days ago'**
  String chatPresenceDaysAgo(Object days);

  /// No description provided for @chatSensitiveDefaultTip.
  ///
  /// In en, this message translates to:
  /// **'This message may contain sensitive information'**
  String get chatSensitiveDefaultTip;

  /// No description provided for @chatMessageDigestFallback.
  ///
  /// In en, this message translates to:
  /// **'[Message]'**
  String get chatMessageDigestFallback;

  /// No description provided for @chatMediaServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Media service is not ready'**
  String get chatMediaServiceUnavailable;

  /// No description provided for @chatImDisconnected.
  ///
  /// In en, this message translates to:
  /// **'IM is not connected'**
  String get chatImDisconnected;

  /// No description provided for @chatPinFailedNotSent.
  ///
  /// In en, this message translates to:
  /// **'Cannot pin before the message reaches the server'**
  String get chatPinFailedNotSent;

  /// No description provided for @chatPinFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to pin. Try again.'**
  String get chatPinFailed;

  /// No description provided for @chatPinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get chatPinned;

  /// No description provided for @chatUnpinFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to unpin. Try again.'**
  String get chatUnpinFailed;

  /// No description provided for @chatUnpinned.
  ///
  /// In en, this message translates to:
  /// **'Unpinned'**
  String get chatUnpinned;

  /// No description provided for @chatClearPinnedConfirm.
  ///
  /// In en, this message translates to:
  /// **'Unpin all pinned messages?'**
  String get chatClearPinnedConfirm;

  /// No description provided for @chatClearPinnedAction.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get chatClearPinnedAction;

  /// No description provided for @chatAllUnpinned.
  ///
  /// In en, this message translates to:
  /// **'All pinned messages unpinned'**
  String get chatAllUnpinned;

  /// No description provided for @chatPinnedMessageNotVisible.
  ///
  /// In en, this message translates to:
  /// **'This message is not in the visible range. View it from the list.'**
  String get chatPinnedMessageNotVisible;

  /// No description provided for @chatImageMissing.
  ///
  /// In en, this message translates to:
  /// **'Image information is missing'**
  String get chatImageMissing;

  /// No description provided for @chatImageDownloadFailedEdit.
  ///
  /// In en, this message translates to:
  /// **'Failed to download image. Cannot edit.'**
  String get chatImageDownloadFailedEdit;

  /// No description provided for @chatReactionFailed.
  ///
  /// In en, this message translates to:
  /// **'Reaction failed. Try again.'**
  String get chatReactionFailed;

  /// No description provided for @chatEditNotSynced.
  ///
  /// In en, this message translates to:
  /// **'Edit failed: message is not synced'**
  String get chatEditNotSynced;

  /// No description provided for @chatEditFailed.
  ///
  /// In en, this message translates to:
  /// **'Edit failed. Try again.'**
  String get chatEditFailed;

  /// No description provided for @chatFavoriteUnsupportedType.
  ///
  /// In en, this message translates to:
  /// **'This type cannot be favorited yet'**
  String get chatFavoriteUnsupportedType;

  /// No description provided for @chatFavoriteNotSent.
  ///
  /// In en, this message translates to:
  /// **'Message has not reached the server, so it cannot be favorited'**
  String get chatFavoriteNotSent;

  /// No description provided for @chatFavoriteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get chatFavoriteSuccess;

  /// No description provided for @chatFavoriteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to favorite. Try again.'**
  String get chatFavoriteFailed;

  /// No description provided for @chatToolSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected {title}'**
  String chatToolSelected(Object title);

  /// No description provided for @chatCardDigest.
  ///
  /// In en, this message translates to:
  /// **'[Card] {name}'**
  String chatCardDigest(Object name);

  /// No description provided for @chatFriendAvatarFallback.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get chatFriendAvatarFallback;

  /// No description provided for @chatUnknownMessageDigest.
  ///
  /// In en, this message translates to:
  /// **'[Unknown]'**
  String get chatUnknownMessageDigest;

  /// No description provided for @chatOpenFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Open @{name}\'s chat from Contacts'**
  String chatOpenFromContacts(Object name);

  /// No description provided for @chatLoadingCard.
  ///
  /// In en, this message translates to:
  /// **'Loading contact card...'**
  String get chatLoadingCard;

  /// No description provided for @chatFileMissing.
  ///
  /// In en, this message translates to:
  /// **'File information is missing'**
  String get chatFileMissing;

  /// No description provided for @chatVideoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Video cannot be played'**
  String get chatVideoUnavailable;

  /// No description provided for @chatVideoSourceEmpty.
  ///
  /// In en, this message translates to:
  /// **'Video source is empty'**
  String get chatVideoSourceEmpty;

  /// No description provided for @chatLivePhotoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Live Photo cannot be played'**
  String get chatLivePhotoUnavailable;

  /// No description provided for @messageAiTranslating.
  ///
  /// In en, this message translates to:
  /// **'Translating...'**
  String get messageAiTranslating;

  /// No description provided for @messageAiTranscribedShort.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get messageAiTranscribedShort;

  /// No description provided for @messageAiVoiceSendingWait.
  ///
  /// In en, this message translates to:
  /// **'Voice is still sending. Try again later.'**
  String get messageAiVoiceSendingWait;

  /// No description provided for @messageAiNoTranscript.
  ///
  /// In en, this message translates to:
  /// **'No speech recognized'**
  String get messageAiNoTranscript;

  /// No description provided for @messageAiMessageSendingWait.
  ///
  /// In en, this message translates to:
  /// **'Message is still sending. Try again later.'**
  String get messageAiMessageSendingWait;

  /// No description provided for @messageAiNoTranslation.
  ///
  /// In en, this message translates to:
  /// **'No translation result'**
  String get messageAiNoTranslation;

  /// No description provided for @messageAiTemporarilyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Temporarily unavailable'**
  String get messageAiTemporarilyUnavailable;

  /// No description provided for @chatVoiceFileUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice file is unavailable'**
  String get chatVoiceFileUnavailable;

  /// No description provided for @chatVoicePlayFailed.
  ///
  /// In en, this message translates to:
  /// **'Playback failed. Try again.'**
  String get chatVoicePlayFailed;

  /// No description provided for @chatVoiceHoldToRecord.
  ///
  /// In en, this message translates to:
  /// **'Hold to record · Slide up to cancel'**
  String get chatVoiceHoldToRecord;

  /// No description provided for @chatVoiceReleaseToCancel.
  ///
  /// In en, this message translates to:
  /// **'Release to cancel ({duration})'**
  String chatVoiceReleaseToCancel(Object duration);

  /// No description provided for @chatVoiceRecordingSlideCancel.
  ///
  /// In en, this message translates to:
  /// **'{duration} · Slide up to cancel'**
  String chatVoiceRecordingSlideCancel(Object duration);

  /// No description provided for @chatQrcodeNotFound.
  ///
  /// In en, this message translates to:
  /// **'No QR code recognized'**
  String get chatQrcodeNotFound;

  /// No description provided for @chatWebLoginQrcodeDetected.
  ///
  /// In en, this message translates to:
  /// **'Web login QR code recognized\n{payload}'**
  String chatWebLoginQrcodeDetected(Object payload);

  /// No description provided for @chatWebLoginConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm login on web?'**
  String get chatWebLoginConfirmTitle;

  /// No description provided for @chatWebLoginConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm Web Login'**
  String get chatWebLoginConfirmAction;

  /// No description provided for @chatWebLoginConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Web login confirmed'**
  String get chatWebLoginConfirmed;

  /// No description provided for @chatQrcodeDetected.
  ///
  /// In en, this message translates to:
  /// **'QR code recognized\n{payload}'**
  String chatQrcodeDetected(Object payload);

  /// No description provided for @chatStickerPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'[Sticker]'**
  String get chatStickerPlaceholder;

  /// No description provided for @chatStickerAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to stickers'**
  String get chatStickerAdded;

  /// No description provided for @chatStickerAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add sticker. Try again.'**
  String get chatStickerAddFailed;

  /// No description provided for @mentionAllMembers.
  ///
  /// In en, this message translates to:
  /// **'All Members'**
  String get mentionAllMembers;

  /// No description provided for @mentionAllMembersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notify everyone in this group'**
  String get mentionAllMembersSubtitle;

  /// No description provided for @chatQuoteOriginalRevoked.
  ///
  /// In en, this message translates to:
  /// **'Original message was recalled'**
  String get chatQuoteOriginalRevoked;

  /// No description provided for @chatRecognizeImageQrcode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code in Image'**
  String get chatRecognizeImageQrcode;

  /// No description provided for @chatAddToStickers.
  ///
  /// In en, this message translates to:
  /// **'Add to Stickers'**
  String get chatAddToStickers;

  /// No description provided for @chatGroupInviteApprovalUrlEmpty.
  ///
  /// In en, this message translates to:
  /// **'Group invite approval URL is empty'**
  String get chatGroupInviteApprovalUrlEmpty;

  /// No description provided for @chatGroupInviteApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Invite Approval'**
  String get chatGroupInviteApprovalTitle;

  /// No description provided for @chatGroupInviteApprovalBody.
  ///
  /// In en, this message translates to:
  /// **'Complete the group invite confirmation on the web page.'**
  String get chatGroupInviteApprovalBody;

  /// No description provided for @chatGroupInviteGoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get chatGroupInviteGoConfirm;

  /// No description provided for @chatGroupInviteApprovalOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to open group invite approval. Try again.'**
  String get chatGroupInviteApprovalOpenFailed;

  /// No description provided for @chatSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send. Try again.'**
  String get chatSendFailed;

  /// No description provided for @chatCallActiveHangupFirst.
  ///
  /// In en, this message translates to:
  /// **'A call is active. Hang up first.'**
  String get chatCallActiveHangupFirst;

  /// No description provided for @chatCallActiveCannotJoinAgain.
  ///
  /// In en, this message translates to:
  /// **'A call is active. Cannot join again.'**
  String get chatCallActiveCannotJoinAgain;

  /// No description provided for @chatCallUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Calls are not supported in this version'**
  String get chatCallUnsupported;

  /// No description provided for @chatCallServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Call service is not ready'**
  String get chatCallServiceUnavailable;

  /// No description provided for @chatCallJoinFailedEnded.
  ///
  /// In en, this message translates to:
  /// **'Failed to join. The call may have ended.'**
  String get chatCallJoinFailedEnded;

  /// No description provided for @callWaitingAnswer.
  ///
  /// In en, this message translates to:
  /// **'Waiting for answer'**
  String get callWaitingAnswer;

  /// No description provided for @callMessage.
  ///
  /// In en, this message translates to:
  /// **'Call message'**
  String get callMessage;

  /// No description provided for @callEnded.
  ///
  /// In en, this message translates to:
  /// **'Call ended'**
  String get callEnded;

  /// No description provided for @callPeerRefused.
  ///
  /// In en, this message translates to:
  /// **'Peer declined'**
  String get callPeerRefused;

  /// No description provided for @callPeerHungUp.
  ///
  /// In en, this message translates to:
  /// **'Peer hung up'**
  String get callPeerHungUp;

  /// No description provided for @callPeerDeclinedVideoSwitch.
  ///
  /// In en, this message translates to:
  /// **'Peer declined the video switch request'**
  String get callPeerDeclinedVideoSwitch;

  /// No description provided for @callSwitchVideoRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Peer requests switching to video'**
  String get callSwitchVideoRequestTitle;

  /// No description provided for @callAgree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get callAgree;

  /// No description provided for @callReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting…'**
  String get callReconnecting;

  /// No description provided for @callWaitingPeerCamera.
  ///
  /// In en, this message translates to:
  /// **'Waiting for peer camera'**
  String get callWaitingPeerCamera;

  /// No description provided for @callSelfFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get callSelfFallbackName;

  /// No description provided for @callUnknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown user'**
  String get callUnknownUser;

  /// No description provided for @callJoinedCount.
  ///
  /// In en, this message translates to:
  /// **'{joined}/{total} joined'**
  String callJoinedCount(int joined, int total);

  /// No description provided for @callMute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get callMute;

  /// No description provided for @callSpeaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get callSpeaker;

  /// No description provided for @callSwitchToVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get callSwitchToVideo;

  /// No description provided for @callHangup.
  ///
  /// In en, this message translates to:
  /// **'Hang Up'**
  String get callHangup;

  /// No description provided for @callFlipCamera.
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get callFlipCamera;

  /// No description provided for @callSwitchToVoice.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get callSwitchToVoice;

  /// No description provided for @callCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get callCamera;

  /// No description provided for @callBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get callBack;

  /// No description provided for @callPermissionMicrophone.
  ///
  /// In en, this message translates to:
  /// **'microphone'**
  String get callPermissionMicrophone;

  /// No description provided for @callPermissionMicrophoneCamera.
  ///
  /// In en, this message translates to:
  /// **'microphone and camera'**
  String get callPermissionMicrophoneCamera;

  /// No description provided for @callPermissionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Enable {what} permission in system settings'**
  String callPermissionOpenSettings(String what);

  /// No description provided for @callPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Calls need {what} permission'**
  String callPermissionRequired(String what);

  /// No description provided for @callWaitingPeerConsent.
  ///
  /// In en, this message translates to:
  /// **'Waiting for peer approval'**
  String get callWaitingPeerConsent;

  /// No description provided for @callSwitchRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send switch request'**
  String get callSwitchRequestFailed;

  /// No description provided for @callCameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get callCameraPermissionRequired;

  /// No description provided for @callCameraEnableFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to turn on camera'**
  String get callCameraEnableFailed;

  /// No description provided for @incomingCallAccepting.
  ///
  /// In en, this message translates to:
  /// **'Answering...'**
  String get incomingCallAccepting;

  /// No description provided for @incomingVideoCall.
  ///
  /// In en, this message translates to:
  /// **'invites you to a video call'**
  String get incomingVideoCall;

  /// No description provided for @incomingAudioCall.
  ///
  /// In en, this message translates to:
  /// **'invites you to a voice call'**
  String get incomingAudioCall;

  /// No description provided for @incomingAcceptFailed.
  ///
  /// In en, this message translates to:
  /// **'Answer failed: {error}'**
  String incomingAcceptFailed(String error);

  /// No description provided for @incomingCallDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get incomingCallDecline;

  /// No description provided for @incomingCallAccept.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get incomingCallAccept;

  /// No description provided for @chatGroupNoInviteCandidates.
  ///
  /// In en, this message translates to:
  /// **'No members available to invite'**
  String get chatGroupNoInviteCandidates;

  /// No description provided for @chatInviteGroupMembersVideo.
  ///
  /// In en, this message translates to:
  /// **'Invite Group Members (Video Call)'**
  String get chatInviteGroupMembersVideo;

  /// No description provided for @chatInviteGroupMembersAudio.
  ///
  /// In en, this message translates to:
  /// **'Invite Group Members (Voice Call)'**
  String get chatInviteGroupMembersAudio;

  /// No description provided for @chatSelfName.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get chatSelfName;

  /// No description provided for @chatPeerPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get chatPeerPlaceholder;

  /// No description provided for @chatSomeonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Someone'**
  String get chatSomeonePlaceholder;

  /// No description provided for @chatScreenshotNotice.
  ///
  /// In en, this message translates to:
  /// **'{name} took a screenshot in chat'**
  String chatScreenshotNotice(Object name);

  /// No description provided for @chatDuplicateGroupMention.
  ///
  /// In en, this message translates to:
  /// **'Multiple group members match @{name}'**
  String chatDuplicateGroupMention(Object name);

  /// No description provided for @chatDuplicateContactMention.
  ///
  /// In en, this message translates to:
  /// **'Multiple contacts match @{name}'**
  String chatDuplicateContactMention(Object name);

  /// No description provided for @chatMentionNotFound.
  ///
  /// In en, this message translates to:
  /// **'@{name} not found'**
  String chatMentionNotFound(Object name);

  /// No description provided for @chatForwardPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Forward To'**
  String get chatForwardPickerTitle;

  /// No description provided for @chatRecentContactsSection.
  ///
  /// In en, this message translates to:
  /// **'Recent Contacts'**
  String get chatRecentContactsSection;

  /// No description provided for @chatForwardedTo.
  ///
  /// In en, this message translates to:
  /// **'Forwarded to {name}'**
  String chatForwardedTo(Object name);

  /// No description provided for @favoriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoriteTitle;

  /// No description provided for @favoriteEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites'**
  String get favoriteEmptyTitle;

  /// No description provided for @favoriteEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Long-press a message in chat and choose Favorite to save it here.'**
  String get favoriteEmptySubtitle;

  /// No description provided for @favoriteDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get favoriteDeleted;

  /// No description provided for @favoriteDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {error}'**
  String favoriteDeleteFailed(Object error);

  /// No description provided for @favoriteDeleteFailedPlain.
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get favoriteDeleteFailedPlain;

  /// No description provided for @favoriteUnsupportedSend.
  ///
  /// In en, this message translates to:
  /// **'This type cannot be sent yet'**
  String get favoriteUnsupportedSend;

  /// No description provided for @favoriteSentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent to {name}'**
  String favoriteSentTo(String name);

  /// No description provided for @favoriteSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Send failed: {error}'**
  String favoriteSendFailed(Object error);

  /// No description provided for @favoriteSendFailedPlain.
  ///
  /// In en, this message translates to:
  /// **'Send failed'**
  String get favoriteSendFailedPlain;

  /// No description provided for @favoriteSendToFriend.
  ///
  /// In en, this message translates to:
  /// **'Send to Friend'**
  String get favoriteSendToFriend;

  /// No description provided for @favoriteCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get favoriteCopied;

  /// No description provided for @favoriteUnknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown user'**
  String get favoriteUnknownUser;

  /// No description provided for @favoriteDateMonthDay.
  ///
  /// In en, this message translates to:
  /// **'{month}/{day}'**
  String favoriteDateMonthDay(int month, int day);

  /// No description provided for @groupSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Groups'**
  String get groupSavedTitle;

  /// No description provided for @groupSaveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save Group'**
  String get groupSaveTooltip;

  /// No description provided for @groupSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search groups'**
  String get groupSearchHint;

  /// No description provided for @groupNoMatched.
  ///
  /// In en, this message translates to:
  /// **'No matching groups'**
  String get groupNoMatched;

  /// No description provided for @groupNoSaveCandidatesToast.
  ///
  /// In en, this message translates to:
  /// **'No groups available to save'**
  String get groupNoSaveCandidatesToast;

  /// No description provided for @groupSavedToContacts.
  ///
  /// In en, this message translates to:
  /// **'Saved to contacts'**
  String get groupSavedToContacts;

  /// No description provided for @groupSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String groupSaveFailed(Object error);

  /// No description provided for @groupSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Group'**
  String get groupSelectTitle;

  /// No description provided for @groupNoSaveCandidates.
  ///
  /// In en, this message translates to:
  /// **'No groups available to save'**
  String get groupNoSaveCandidates;

  /// No description provided for @groupCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Start Group Chat'**
  String get groupCreateTitle;

  /// No description provided for @groupSearchContactsHint.
  ///
  /// In en, this message translates to:
  /// **'Search contacts'**
  String get groupSearchContactsHint;

  /// No description provided for @groupNoMatchedContacts.
  ///
  /// In en, this message translates to:
  /// **'No matching contacts'**
  String get groupNoMatchedContacts;

  /// No description provided for @groupMemberSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 member} other{{count} members}} · {subtitle}'**
  String groupMemberSummary(num count, Object subtitle);

  /// No description provided for @groupMuted.
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get groupMuted;

  /// No description provided for @groupDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Details'**
  String get groupDetailsTitle;

  /// No description provided for @groupMemberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 member} other{{count} members}}'**
  String groupMemberCount(num count);

  /// No description provided for @groupMembersSection.
  ///
  /// In en, this message translates to:
  /// **'Group Members'**
  String get groupMembersSection;

  /// No description provided for @chatMergeForwardTitleGroup.
  ///
  /// In en, this message translates to:
  /// **'Group Chat History'**
  String get chatMergeForwardTitleGroup;

  /// No description provided for @chatMergeForwardTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatMergeForwardTitleDefault;

  /// No description provided for @chatMergeForwardTitleOne.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s Chat History'**
  String chatMergeForwardTitleOne(String name);

  /// No description provided for @chatMergeForwardTitleTwo.
  ///
  /// In en, this message translates to:
  /// **'Chat History of {name1} and {name2}'**
  String chatMergeForwardTitleTwo(String name1, String name2);

  /// No description provided for @groupNoMembers.
  ///
  /// In en, this message translates to:
  /// **'No group members'**
  String get groupNoMembers;

  /// No description provided for @groupInviteMembers.
  ///
  /// In en, this message translates to:
  /// **'Invite Members'**
  String get groupInviteMembers;

  /// No description provided for @groupInviteMembersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose from contacts'**
  String get groupInviteMembersSubtitle;

  /// No description provided for @groupRemoveMembers.
  ///
  /// In en, this message translates to:
  /// **'Remove Members'**
  String get groupRemoveMembers;

  /// No description provided for @groupRemoveMembersEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'No members to remove'**
  String get groupRemoveMembersEmptySubtitle;

  /// No description provided for @groupRemoveMembersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose members to remove'**
  String get groupRemoveMembersSubtitle;

  /// No description provided for @groupQrCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Group QR Code'**
  String get groupQrCodeTitle;

  /// No description provided for @groupQrCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan to join this group'**
  String get groupQrCodeSubtitle;

  /// No description provided for @groupNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupNameTitle;

  /// No description provided for @groupNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Announcement'**
  String get groupNoticeTitle;

  /// No description provided for @groupNoticeUnset.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get groupNoticeUnset;

  /// No description provided for @groupManageTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Management'**
  String get groupManageTitle;

  /// No description provided for @groupManageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Admins, mute, and group permissions'**
  String get groupManageSubtitle;

  /// No description provided for @groupInviteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Invite Confirmation'**
  String get groupInviteConfirm;

  /// No description provided for @groupBlacklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Blacklist'**
  String get groupBlacklistTitle;

  /// No description provided for @groupBlacklistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage members blocked from speaking or joining'**
  String get groupBlacklistSubtitle;

  /// No description provided for @groupSaveToContacts.
  ///
  /// In en, this message translates to:
  /// **'Save to Contacts'**
  String get groupSaveToContacts;

  /// No description provided for @groupMuteMessages.
  ///
  /// In en, this message translates to:
  /// **'Mute Notifications'**
  String get groupMuteMessages;

  /// No description provided for @groupExited.
  ///
  /// In en, this message translates to:
  /// **'Left group chat'**
  String get groupExited;

  /// No description provided for @groupExitAction.
  ///
  /// In en, this message translates to:
  /// **'Leave Group'**
  String get groupExitAction;

  /// No description provided for @groupMembersSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sync group members: {error}'**
  String groupMembersSyncFailed(Object error);

  /// No description provided for @groupInvitePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Members to Invite'**
  String get groupInvitePickerTitle;

  /// No description provided for @groupInviteSentCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Sent 1 member invitation} other{Sent {count} member invitations}}'**
  String groupInviteSentCount(num count);

  /// No description provided for @groupInvitedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Invited 1 member} other{Invited {count} members}}'**
  String groupInvitedCount(num count);

  /// No description provided for @groupInviteMembersFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to invite members: {error}'**
  String groupInviteMembersFailed(Object error);

  /// No description provided for @groupRemovePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Members to Remove'**
  String get groupRemovePickerTitle;

  /// No description provided for @groupQuotedMemberName.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\"'**
  String groupQuotedMemberName(Object name);

  /// No description provided for @groupSelectedMemberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 member} other{{count} members}}'**
  String groupSelectedMemberCount(num count);

  /// No description provided for @groupRemoveMembersConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {target} from this group?'**
  String groupRemoveMembersConfirm(Object target);

  /// No description provided for @groupRemoveAction.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get groupRemoveAction;

  /// No description provided for @groupRemovedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Removed 1 member} other{Removed {count} members}}'**
  String groupRemovedCount(num count);

  /// No description provided for @groupRemoveMembersFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove members: {error}'**
  String groupRemoveMembersFailed(Object error);

  /// No description provided for @groupSettingsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Group settings updated'**
  String get groupSettingsUpdated;

  /// No description provided for @groupSettingsUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update group settings: {error}'**
  String groupSettingsUpdateFailed(Object error);

  /// No description provided for @groupExitConfirm.
  ///
  /// In en, this message translates to:
  /// **'You will no longer receive messages from this group after leaving.'**
  String get groupExitConfirm;

  /// No description provided for @groupExitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Left group chat'**
  String get groupExitSuccess;

  /// No description provided for @groupExitFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to leave: {error}'**
  String groupExitFailed(Object error);

  /// No description provided for @groupOwnerAdminSection.
  ///
  /// In en, this message translates to:
  /// **'Owner & Admins'**
  String get groupOwnerAdminSection;

  /// No description provided for @groupOwnerRole.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get groupOwnerRole;

  /// No description provided for @groupAdminRole.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get groupAdminRole;

  /// No description provided for @groupRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get groupRemove;

  /// No description provided for @groupAddAdmin.
  ///
  /// In en, this message translates to:
  /// **'Add Group Admin'**
  String get groupAddAdmin;

  /// No description provided for @groupNoAdmins.
  ///
  /// In en, this message translates to:
  /// **'No admins'**
  String get groupNoAdmins;

  /// No description provided for @groupInviteConfirmRemark.
  ///
  /// In en, this message translates to:
  /// **'When enabled, members need owner or admin approval before inviting friends. Joining by QR code will also be disabled.'**
  String get groupInviteConfirmRemark;

  /// No description provided for @groupOwnerTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer Ownership'**
  String get groupOwnerTransfer;

  /// No description provided for @groupMemberSettingsSection.
  ///
  /// In en, this message translates to:
  /// **'Member Settings'**
  String get groupMemberSettingsSection;

  /// No description provided for @groupAllMutedRemark.
  ///
  /// In en, this message translates to:
  /// **'When all-member mute is enabled, only the owner and admins can speak.'**
  String get groupAllMutedRemark;

  /// No description provided for @groupAllMuted.
  ///
  /// In en, this message translates to:
  /// **'Mute All Members'**
  String get groupAllMuted;

  /// No description provided for @groupForbiddenAddFriendRemark.
  ///
  /// In en, this message translates to:
  /// **'When enabled, members cannot add friends through this group.'**
  String get groupForbiddenAddFriendRemark;

  /// No description provided for @groupForbiddenAddFriend.
  ///
  /// In en, this message translates to:
  /// **'Block Members from Adding Friends'**
  String get groupForbiddenAddFriend;

  /// No description provided for @groupAllowHistoryRemark.
  ///
  /// In en, this message translates to:
  /// **'When enabled, new members can see previous chat history.'**
  String get groupAllowHistoryRemark;

  /// No description provided for @groupAllowHistory.
  ///
  /// In en, this message translates to:
  /// **'Allow New Members to View History'**
  String get groupAllowHistory;

  /// No description provided for @groupAddAdminPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Group Admin'**
  String get groupAddAdminPickerTitle;

  /// No description provided for @groupAdminAddedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Added 1 admin} other{Added {count} admins}}'**
  String groupAdminAddedCount(num count);

  /// No description provided for @groupAddAdminFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add admin: {error}'**
  String groupAddAdminFailed(Object error);

  /// No description provided for @groupRemoveAdminConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove admin role from \"{name}\"?'**
  String groupRemoveAdminConfirm(Object name);

  /// No description provided for @groupRemoveAdminAction.
  ///
  /// In en, this message translates to:
  /// **'Remove Admin'**
  String get groupRemoveAdminAction;

  /// No description provided for @groupRemoveAdminSuccess.
  ///
  /// In en, this message translates to:
  /// **'Admin removed'**
  String get groupRemoveAdminSuccess;

  /// No description provided for @groupRemoveAdminFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove admin: {error}'**
  String groupRemoveAdminFailed(Object error);

  /// No description provided for @groupSelectNewOwner.
  ///
  /// In en, this message translates to:
  /// **'Select New Owner'**
  String get groupSelectNewOwner;

  /// No description provided for @groupTransferOwnerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Transfer ownership to \"{name}\"? You will become a regular member.'**
  String groupTransferOwnerConfirm(Object name);

  /// No description provided for @groupTransferOwnerAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm Transfer'**
  String get groupTransferOwnerAction;

  /// No description provided for @groupOwnerTransferred.
  ///
  /// In en, this message translates to:
  /// **'Ownership transferred'**
  String get groupOwnerTransferred;

  /// No description provided for @groupOwnerTransferFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to transfer ownership: {error}'**
  String groupOwnerTransferFailed(Object error);

  /// No description provided for @groupNoticePublisherDefault.
  ///
  /// In en, this message translates to:
  /// **'Group Announcement'**
  String get groupNoticePublisherDefault;

  /// No description provided for @groupNoticePublishTitle.
  ///
  /// In en, this message translates to:
  /// **'Post Group Announcement'**
  String get groupNoticePublishTitle;

  /// No description provided for @groupNoticeEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Group Announcement'**
  String get groupNoticeEditTitle;

  /// No description provided for @groupNoticePublishAction.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get groupNoticePublishAction;

  /// No description provided for @groupNoticeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No group announcement'**
  String get groupNoticeEmpty;

  /// No description provided for @groupNoticePublishedAtUnknown.
  ///
  /// In en, this message translates to:
  /// **'Publish time unknown'**
  String get groupNoticePublishedAtUnknown;

  /// No description provided for @groupMemberRemarkTitle.
  ///
  /// In en, this message translates to:
  /// **'My Nickname in This Group'**
  String get groupMemberRemarkTitle;

  /// No description provided for @groupMemberRemarkHint.
  ///
  /// In en, this message translates to:
  /// **'Set your nickname in this group'**
  String get groupMemberRemarkHint;

  /// No description provided for @groupQrCodeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No group QR code'**
  String get groupQrCodeEmpty;

  /// No description provided for @groupQrCodeValid.
  ///
  /// In en, this message translates to:
  /// **'This QR code is valid for {day} days ({expire})'**
  String groupQrCodeValid(Object day, Object expire);

  /// No description provided for @groupQrCodeScanToJoin.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code to join this group'**
  String get groupQrCodeScanToJoin;

  /// No description provided for @groupBlacklistLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load blacklist. Try again.'**
  String get groupBlacklistLoadFailed;

  /// No description provided for @groupBlacklistEmpty.
  ///
  /// In en, this message translates to:
  /// **'No blacklisted members'**
  String get groupBlacklistEmpty;

  /// No description provided for @groupBlacklistAddMember.
  ///
  /// In en, this message translates to:
  /// **'Add Blacklist Member'**
  String get groupBlacklistAddMember;

  /// No description provided for @groupBlacklistNoCandidates.
  ///
  /// In en, this message translates to:
  /// **'No members can be added to the blacklist'**
  String get groupBlacklistNoCandidates;

  /// No description provided for @groupSelectMember.
  ///
  /// In en, this message translates to:
  /// **'Select Member'**
  String get groupSelectMember;

  /// No description provided for @groupBlacklistAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to blacklist'**
  String get groupBlacklistAdded;

  /// No description provided for @groupBlacklistAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add to blacklist. Try again.'**
  String get groupBlacklistAddFailed;

  /// No description provided for @groupBlacklistRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from the group blacklist?'**
  String groupBlacklistRemoveConfirm(Object name);

  /// No description provided for @groupBlacklistRemoveAction.
  ///
  /// In en, this message translates to:
  /// **'Remove from Blacklist'**
  String get groupBlacklistRemoveAction;

  /// No description provided for @groupBlacklistRemoveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove from blacklist. Try again.'**
  String get groupBlacklistRemoveFailed;

  /// No description provided for @groupAvatarTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Avatar'**
  String get groupAvatarTitle;

  /// No description provided for @groupAvatarTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get groupAvatarTakePhoto;

  /// No description provided for @groupAvatarChooseFromAlbum.
  ///
  /// In en, this message translates to:
  /// **'Choose from Album'**
  String get groupAvatarChooseFromAlbum;

  /// No description provided for @groupAvatarSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Save Image'**
  String get groupAvatarSaveImage;

  /// No description provided for @groupAvatarUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This chat does not support changing the group avatar'**
  String get groupAvatarUnsupported;

  /// No description provided for @groupAvatarUpdated.
  ///
  /// In en, this message translates to:
  /// **'Group avatar updated'**
  String get groupAvatarUpdated;

  /// No description provided for @groupAvatarUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update group avatar. Try again.'**
  String get groupAvatarUpdateFailed;

  /// No description provided for @groupAvatarNoImageToSave.
  ///
  /// In en, this message translates to:
  /// **'No avatar to save'**
  String get groupAvatarNoImageToSave;

  /// No description provided for @groupPhotoPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Allow {appName} to access your photos'**
  String groupPhotoPermissionRequired(Object appName);

  /// No description provided for @groupImageSavedToAlbum.
  ///
  /// In en, this message translates to:
  /// **'Saved to album'**
  String get groupImageSavedToAlbum;

  /// No description provided for @groupImageSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save. Try again.'**
  String get groupImageSaveFailed;

  /// No description provided for @imageEditorProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get imageEditorProcessing;

  /// No description provided for @imageEditorDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard edits?'**
  String get imageEditorDiscardTitle;

  /// No description provided for @imageEditorDiscardMessage.
  ///
  /// In en, this message translates to:
  /// **'Unsaved edits will be lost.'**
  String get imageEditorDiscardMessage;

  /// No description provided for @imageEditorDiscardConfirm.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get imageEditorDiscardConfirm;

  /// No description provided for @imageEditorPaint.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get imageEditorPaint;

  /// No description provided for @imageEditorFreestyle.
  ///
  /// In en, this message translates to:
  /// **'Freehand'**
  String get imageEditorFreestyle;

  /// No description provided for @imageEditorArrow.
  ///
  /// In en, this message translates to:
  /// **'Arrow'**
  String get imageEditorArrow;

  /// No description provided for @imageEditorLine.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get imageEditorLine;

  /// No description provided for @imageEditorRectangle.
  ///
  /// In en, this message translates to:
  /// **'Rectangle'**
  String get imageEditorRectangle;

  /// No description provided for @imageEditorCircle.
  ///
  /// In en, this message translates to:
  /// **'Circle'**
  String get imageEditorCircle;

  /// No description provided for @imageEditorDashLine.
  ///
  /// In en, this message translates to:
  /// **'Dashed line'**
  String get imageEditorDashLine;

  /// No description provided for @imageEditorMoveAndZoom.
  ///
  /// In en, this message translates to:
  /// **'Move / Zoom'**
  String get imageEditorMoveAndZoom;

  /// No description provided for @imageEditorEraser.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get imageEditorEraser;

  /// No description provided for @imageEditorLineWidth.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get imageEditorLineWidth;

  /// No description provided for @imageEditorToggleFill.
  ///
  /// In en, this message translates to:
  /// **'Fill'**
  String get imageEditorToggleFill;

  /// No description provided for @imageEditorOpacity.
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get imageEditorOpacity;

  /// No description provided for @imageEditorUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get imageEditorUndo;

  /// No description provided for @imageEditorRedo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get imageEditorRedo;

  /// No description provided for @imageEditorInputHint.
  ///
  /// In en, this message translates to:
  /// **'Enter text'**
  String get imageEditorInputHint;

  /// No description provided for @imageEditorText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get imageEditorText;

  /// No description provided for @imageEditorTextAlign.
  ///
  /// In en, this message translates to:
  /// **'Align'**
  String get imageEditorTextAlign;

  /// No description provided for @imageEditorBackground.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get imageEditorBackground;

  /// No description provided for @imageEditorFontScale.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get imageEditorFontScale;

  /// No description provided for @imageEditorCrop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get imageEditorCrop;

  /// No description provided for @imageEditorRotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get imageEditorRotate;

  /// No description provided for @imageEditorRatio.
  ///
  /// In en, this message translates to:
  /// **'Ratio'**
  String get imageEditorRatio;

  /// No description provided for @imageEditorReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get imageEditorReset;

  /// No description provided for @imageEditorFlip.
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get imageEditorFlip;

  /// No description provided for @imageEditorFilter.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get imageEditorFilter;

  /// No description provided for @imageEditorFilterNone.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get imageEditorFilterNone;

  /// No description provided for @imageEditorFilterAddictiveBlue.
  ///
  /// In en, this message translates to:
  /// **'Addictive Blue'**
  String get imageEditorFilterAddictiveBlue;

  /// No description provided for @imageEditorFilterAddictiveRed.
  ///
  /// In en, this message translates to:
  /// **'Addictive Red'**
  String get imageEditorFilterAddictiveRed;

  /// No description provided for @imageEditorFilterAden.
  ///
  /// In en, this message translates to:
  /// **'Aden'**
  String get imageEditorFilterAden;

  /// No description provided for @imageEditorFilterAmaro.
  ///
  /// In en, this message translates to:
  /// **'Amaro'**
  String get imageEditorFilterAmaro;

  /// No description provided for @imageEditorFilterAshby.
  ///
  /// In en, this message translates to:
  /// **'Ashby'**
  String get imageEditorFilterAshby;

  /// No description provided for @imageEditorFilterBrannan.
  ///
  /// In en, this message translates to:
  /// **'Brannan'**
  String get imageEditorFilterBrannan;

  /// No description provided for @imageEditorFilterBrooklyn.
  ///
  /// In en, this message translates to:
  /// **'Brooklyn'**
  String get imageEditorFilterBrooklyn;

  /// No description provided for @imageEditorFilterCharmes.
  ///
  /// In en, this message translates to:
  /// **'Charmes'**
  String get imageEditorFilterCharmes;

  /// No description provided for @imageEditorFilterClarendon.
  ///
  /// In en, this message translates to:
  /// **'Clarendon'**
  String get imageEditorFilterClarendon;

  /// No description provided for @imageEditorFilterCrema.
  ///
  /// In en, this message translates to:
  /// **'Crema'**
  String get imageEditorFilterCrema;

  /// No description provided for @imageEditorFilterDogpatch.
  ///
  /// In en, this message translates to:
  /// **'Dogpatch'**
  String get imageEditorFilterDogpatch;

  /// No description provided for @imageEditorFilterEarlybird.
  ///
  /// In en, this message translates to:
  /// **'Earlybird'**
  String get imageEditorFilterEarlybird;

  /// No description provided for @imageEditorFilterGingham.
  ///
  /// In en, this message translates to:
  /// **'Gingham'**
  String get imageEditorFilterGingham;

  /// No description provided for @imageEditorFilterGinza.
  ///
  /// In en, this message translates to:
  /// **'Ginza'**
  String get imageEditorFilterGinza;

  /// No description provided for @imageEditorFilterHefe.
  ///
  /// In en, this message translates to:
  /// **'Hefe'**
  String get imageEditorFilterHefe;

  /// No description provided for @imageEditorFilterHelena.
  ///
  /// In en, this message translates to:
  /// **'Helena'**
  String get imageEditorFilterHelena;

  /// No description provided for @imageEditorFilterHudson.
  ///
  /// In en, this message translates to:
  /// **'Hudson'**
  String get imageEditorFilterHudson;

  /// No description provided for @imageEditorFilterInkwell.
  ///
  /// In en, this message translates to:
  /// **'Inkwell'**
  String get imageEditorFilterInkwell;

  /// No description provided for @imageEditorFilterJuno.
  ///
  /// In en, this message translates to:
  /// **'Juno'**
  String get imageEditorFilterJuno;

  /// No description provided for @imageEditorFilterKelvin.
  ///
  /// In en, this message translates to:
  /// **'Kelvin'**
  String get imageEditorFilterKelvin;

  /// No description provided for @imageEditorFilterLark.
  ///
  /// In en, this message translates to:
  /// **'Lark'**
  String get imageEditorFilterLark;

  /// No description provided for @imageEditorFilterLoFi.
  ///
  /// In en, this message translates to:
  /// **'Lo-Fi'**
  String get imageEditorFilterLoFi;

  /// No description provided for @imageEditorFilterLudwig.
  ///
  /// In en, this message translates to:
  /// **'Ludwig'**
  String get imageEditorFilterLudwig;

  /// No description provided for @imageEditorFilterMaven.
  ///
  /// In en, this message translates to:
  /// **'Maven'**
  String get imageEditorFilterMaven;

  /// No description provided for @imageEditorFilterMayfair.
  ///
  /// In en, this message translates to:
  /// **'Mayfair'**
  String get imageEditorFilterMayfair;

  /// No description provided for @imageEditorFilterMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get imageEditorFilterMoon;

  /// No description provided for @imageEditorFilterNashville.
  ///
  /// In en, this message translates to:
  /// **'Nashville'**
  String get imageEditorFilterNashville;

  /// No description provided for @imageEditorFilterPerpetua.
  ///
  /// In en, this message translates to:
  /// **'Perpetua'**
  String get imageEditorFilterPerpetua;

  /// No description provided for @imageEditorFilterReyes.
  ///
  /// In en, this message translates to:
  /// **'Reyes'**
  String get imageEditorFilterReyes;

  /// No description provided for @imageEditorFilterRise.
  ///
  /// In en, this message translates to:
  /// **'Rise'**
  String get imageEditorFilterRise;

  /// No description provided for @imageEditorFilterSierra.
  ///
  /// In en, this message translates to:
  /// **'Sierra'**
  String get imageEditorFilterSierra;

  /// No description provided for @imageEditorFilterSkyline.
  ///
  /// In en, this message translates to:
  /// **'Skyline'**
  String get imageEditorFilterSkyline;

  /// No description provided for @imageEditorFilterSlumber.
  ///
  /// In en, this message translates to:
  /// **'Slumber'**
  String get imageEditorFilterSlumber;

  /// No description provided for @imageEditorFilterStinson.
  ///
  /// In en, this message translates to:
  /// **'Stinson'**
  String get imageEditorFilterStinson;

  /// No description provided for @imageEditorFilterSutro.
  ///
  /// In en, this message translates to:
  /// **'Sutro'**
  String get imageEditorFilterSutro;

  /// No description provided for @imageEditorFilterToaster.
  ///
  /// In en, this message translates to:
  /// **'Toaster'**
  String get imageEditorFilterToaster;

  /// No description provided for @imageEditorFilterValencia.
  ///
  /// In en, this message translates to:
  /// **'Valencia'**
  String get imageEditorFilterValencia;

  /// No description provided for @imageEditorFilterVesper.
  ///
  /// In en, this message translates to:
  /// **'Vesper'**
  String get imageEditorFilterVesper;

  /// No description provided for @imageEditorFilterWalden.
  ///
  /// In en, this message translates to:
  /// **'Walden'**
  String get imageEditorFilterWalden;

  /// No description provided for @imageEditorFilterWillow.
  ///
  /// In en, this message translates to:
  /// **'Willow'**
  String get imageEditorFilterWillow;

  /// No description provided for @imageEditorBlur.
  ///
  /// In en, this message translates to:
  /// **'Blur'**
  String get imageEditorBlur;

  /// No description provided for @imageEditorTune.
  ///
  /// In en, this message translates to:
  /// **'Adjust'**
  String get imageEditorTune;

  /// No description provided for @imageEditorBrightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get imageEditorBrightness;

  /// No description provided for @imageEditorContrast.
  ///
  /// In en, this message translates to:
  /// **'Contrast'**
  String get imageEditorContrast;

  /// No description provided for @imageEditorSaturation.
  ///
  /// In en, this message translates to:
  /// **'Saturation'**
  String get imageEditorSaturation;

  /// No description provided for @imageEditorExposure.
  ///
  /// In en, this message translates to:
  /// **'Exposure'**
  String get imageEditorExposure;

  /// No description provided for @imageEditorHue.
  ///
  /// In en, this message translates to:
  /// **'Hue'**
  String get imageEditorHue;

  /// No description provided for @imageEditorTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get imageEditorTemperature;

  /// No description provided for @imageEditorSharpness.
  ///
  /// In en, this message translates to:
  /// **'Sharpness'**
  String get imageEditorSharpness;

  /// No description provided for @imageEditorFade.
  ///
  /// In en, this message translates to:
  /// **'Fade'**
  String get imageEditorFade;

  /// No description provided for @imageEditorLuminance.
  ///
  /// In en, this message translates to:
  /// **'Luminance'**
  String get imageEditorLuminance;

  /// No description provided for @imageEditorEmoji.
  ///
  /// In en, this message translates to:
  /// **'Emoji'**
  String get imageEditorEmoji;

  /// No description provided for @imageEditorEmojiRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get imageEditorEmojiRecent;

  /// No description provided for @imageEditorEmojiSmileys.
  ///
  /// In en, this message translates to:
  /// **'Smileys'**
  String get imageEditorEmojiSmileys;

  /// No description provided for @imageEditorEmojiAnimals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get imageEditorEmojiAnimals;

  /// No description provided for @imageEditorEmojiFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get imageEditorEmojiFood;

  /// No description provided for @imageEditorEmojiActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get imageEditorEmojiActivities;

  /// No description provided for @imageEditorEmojiTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get imageEditorEmojiTravel;

  /// No description provided for @imageEditorEmojiObjects.
  ///
  /// In en, this message translates to:
  /// **'Objects'**
  String get imageEditorEmojiObjects;

  /// No description provided for @imageEditorEmojiSymbols.
  ///
  /// In en, this message translates to:
  /// **'Symbols'**
  String get imageEditorEmojiSymbols;

  /// No description provided for @imageEditorEmojiFlags.
  ///
  /// In en, this message translates to:
  /// **'Flags'**
  String get imageEditorEmojiFlags;

  /// No description provided for @imageEditorSticker.
  ///
  /// In en, this message translates to:
  /// **'Stickers'**
  String get imageEditorSticker;

  /// No description provided for @imageEditorRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get imageEditorRemove;

  /// No description provided for @imageEditorSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get imageEditorSaving;

  /// No description provided for @imageEditorImporting.
  ///
  /// In en, this message translates to:
  /// **'Importing'**
  String get imageEditorImporting;

  /// No description provided for @imagePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Image Preview'**
  String get imagePreviewTitle;

  /// No description provided for @imagePreviewSavingToAlbum.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get imagePreviewSavingToAlbum;

  /// No description provided for @imagePreviewAddToSticker.
  ///
  /// In en, this message translates to:
  /// **'Add to Stickers'**
  String get imagePreviewAddToSticker;

  /// No description provided for @imagePreviewAddingToSticker.
  ///
  /// In en, this message translates to:
  /// **'Adding...'**
  String get imagePreviewAddingToSticker;

  /// No description provided for @imagePreviewRecognizeQr.
  ///
  /// In en, this message translates to:
  /// **'Recognize QR Code'**
  String get imagePreviewRecognizeQr;

  /// No description provided for @imagePreviewRecognizingQr.
  ///
  /// In en, this message translates to:
  /// **'Recognizing...'**
  String get imagePreviewRecognizingQr;

  /// No description provided for @imagePreviewConfirmWebLogin.
  ///
  /// In en, this message translates to:
  /// **'Confirm Web Login'**
  String get imagePreviewConfirmWebLogin;

  /// No description provided for @imagePreviewConfirmingWebLogin.
  ///
  /// In en, this message translates to:
  /// **'Confirming...'**
  String get imagePreviewConfirmingWebLogin;

  /// No description provided for @imagePreviewOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Open Link'**
  String get imagePreviewOpenLink;

  /// No description provided for @imagePreviewImageNotDownloadedSave.
  ///
  /// In en, this message translates to:
  /// **'Image is not downloaded yet'**
  String get imagePreviewImageNotDownloadedSave;

  /// No description provided for @imagePreviewMediaUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Media service is unavailable'**
  String get imagePreviewMediaUnavailable;

  /// No description provided for @imagePreviewImageNotUploadedSticker.
  ///
  /// In en, this message translates to:
  /// **'Image is not uploaded yet'**
  String get imagePreviewImageNotUploadedSticker;

  /// No description provided for @imagePreviewStickerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sticker service is unavailable'**
  String get imagePreviewStickerUnavailable;

  /// No description provided for @imagePreviewAddedToSticker.
  ///
  /// In en, this message translates to:
  /// **'Added to stickers'**
  String get imagePreviewAddedToSticker;

  /// No description provided for @imagePreviewImageNotDownloadedRecognize.
  ///
  /// In en, this message translates to:
  /// **'Image is not downloaded yet'**
  String get imagePreviewImageNotDownloadedRecognize;

  /// No description provided for @imagePreviewQrNotFound.
  ///
  /// In en, this message translates to:
  /// **'No QR code found'**
  String get imagePreviewQrNotFound;

  /// No description provided for @imagePreviewWebLoginQrRecognized.
  ///
  /// In en, this message translates to:
  /// **'Web login QR code recognized'**
  String get imagePreviewWebLoginQrRecognized;

  /// No description provided for @imagePreviewWebLinkRecognized.
  ///
  /// In en, this message translates to:
  /// **'Web link recognized'**
  String get imagePreviewWebLinkRecognized;

  /// No description provided for @imagePreviewQrRecognized.
  ///
  /// In en, this message translates to:
  /// **'QR code recognized'**
  String get imagePreviewQrRecognized;

  /// No description provided for @imagePreviewWebLoginConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Web login confirmed'**
  String get imagePreviewWebLoginConfirmed;

  /// No description provided for @pickerFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get pickerFileTitle;

  /// No description provided for @pickerRecentFiles.
  ///
  /// In en, this message translates to:
  /// **'Recent Files'**
  String get pickerRecentFiles;

  /// No description provided for @pickerSampleProjectFile.
  ///
  /// In en, this message translates to:
  /// **'Project Notes.pdf'**
  String get pickerSampleProjectFile;

  /// No description provided for @pickerSampleProjectFileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'128 KB · Today'**
  String get pickerSampleProjectFileSubtitle;

  /// No description provided for @pickerSampleScreenshotFile.
  ///
  /// In en, this message translates to:
  /// **'Chat Screenshot.png'**
  String get pickerSampleScreenshotFile;

  /// No description provided for @pickerSampleScreenshotFileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'2.4 MB · Yesterday'**
  String get pickerSampleScreenshotFileSubtitle;

  /// No description provided for @pickerContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Contact'**
  String get pickerContactTitle;

  /// No description provided for @pickerContactCardSection.
  ///
  /// In en, this message translates to:
  /// **'Send Contact Card'**
  String get pickerContactCardSection;

  /// No description provided for @pickerSearchContacts.
  ///
  /// In en, this message translates to:
  /// **'Search Contacts'**
  String get pickerSearchContacts;

  /// No description provided for @pickerNoMatchingContacts.
  ///
  /// In en, this message translates to:
  /// **'No matching contacts'**
  String get pickerNoMatchingContacts;

  /// No description provided for @chatSendFailedShort.
  ///
  /// In en, this message translates to:
  /// **'Send Failed'**
  String get chatSendFailedShort;

  /// No description provided for @chatResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get chatResend;

  /// No description provided for @chatStatusRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get chatStatusRead;

  /// No description provided for @pinnedMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Pinned Message'**
  String get pinnedMessageTitle;

  /// No description provided for @pinnedMessageTitleWithIndex.
  ///
  /// In en, this message translates to:
  /// **'Pinned Message {index}/{total}'**
  String pinnedMessageTitleWithIndex(int index, int total);

  /// No description provided for @pinnedMessageOpen.
  ///
  /// In en, this message translates to:
  /// **'Tap to View'**
  String get pinnedMessageOpen;

  /// No description provided for @pinnedMessageViewAllTooltip.
  ///
  /// In en, this message translates to:
  /// **'View All Pinned'**
  String get pinnedMessageViewAllTooltip;

  /// No description provided for @pinnedMessageUnpinTooltip.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get pinnedMessageUnpinTooltip;

  /// No description provided for @pinnedMessageListCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Pinned Messages'**
  String pinnedMessageListCount(int count);

  /// No description provided for @pinnedMessageClearAll.
  ///
  /// In en, this message translates to:
  /// **'Unpin All'**
  String get pinnedMessageClearAll;

  /// No description provided for @pinnedMessageFallback.
  ///
  /// In en, this message translates to:
  /// **'Pinned Message'**
  String get pinnedMessageFallback;

  /// No description provided for @fileUnnamed.
  ///
  /// In en, this message translates to:
  /// **'Untitled File'**
  String get fileUnnamed;

  /// No description provided for @fileNoDownloadUrl.
  ///
  /// In en, this message translates to:
  /// **'No download link available'**
  String get fileNoDownloadUrl;

  /// No description provided for @fileTitle.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get fileTitle;

  /// No description provided for @fileSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'File size: {size}'**
  String fileSizeLabel(String size);

  /// No description provided for @fileDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download Failed'**
  String get fileDownloadFailed;

  /// No description provided for @filePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get filePreview;

  /// No description provided for @fileOpenWithOtherApp.
  ///
  /// In en, this message translates to:
  /// **'Open in Other App'**
  String get fileOpenWithOtherApp;

  /// No description provided for @actionEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get actionEnable;

  /// No description provided for @actionDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get actionDisable;

  /// No description provided for @profileInviteLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading invite code'**
  String get profileInviteLoading;

  /// No description provided for @profileInviteEnabled.
  ///
  /// In en, this message translates to:
  /// **'Invite code enabled'**
  String get profileInviteEnabled;

  /// No description provided for @profileInviteDisabled.
  ///
  /// In en, this message translates to:
  /// **'Invite code disabled'**
  String get profileInviteDisabled;

  /// No description provided for @profileInviteLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load invite code: {error}'**
  String profileInviteLoadFailed(String error);

  /// No description provided for @profileInviteCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get profileInviteCopied;

  /// No description provided for @profileInviteUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update invite code: {error}'**
  String profileInviteUpdateFailed(String error);

  /// No description provided for @stickerStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Sticker Store'**
  String get stickerStoreTitle;

  /// No description provided for @stickerNoPacks.
  ///
  /// In en, this message translates to:
  /// **'No sticker packs'**
  String get stickerNoPacks;

  /// No description provided for @stickerDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Sticker Details'**
  String get stickerDetailTitle;

  /// No description provided for @stickerProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get stickerProcessing;

  /// No description provided for @stickerAddCustomTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Sticker'**
  String get stickerAddCustomTitle;

  /// No description provided for @stickerSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort Stickers'**
  String get stickerSortTitle;

  /// No description provided for @stickerMyStickersTitle.
  ///
  /// In en, this message translates to:
  /// **'My Stickers'**
  String get stickerMyStickersTitle;

  /// No description provided for @stickerSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get stickerSaving;

  /// No description provided for @stickerSortAction.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get stickerSortAction;

  /// No description provided for @stickerOrganize.
  ///
  /// In en, this message translates to:
  /// **'Organize'**
  String get stickerOrganize;

  /// No description provided for @stickerCustomTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Stickers'**
  String get stickerCustomTitle;

  /// No description provided for @stickerCustomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage saved custom stickers'**
  String get stickerCustomSubtitle;

  /// No description provided for @stickerNoSortablePacks.
  ///
  /// In en, this message translates to:
  /// **'No sticker packs to sort'**
  String get stickerNoSortablePacks;

  /// No description provided for @stickerNoCategories.
  ///
  /// In en, this message translates to:
  /// **'No sticker categories'**
  String get stickerNoCategories;

  /// No description provided for @stickerMoveUp.
  ///
  /// In en, this message translates to:
  /// **'Move Up'**
  String get stickerMoveUp;

  /// No description provided for @stickerMoveDown.
  ///
  /// In en, this message translates to:
  /// **'Move Down'**
  String get stickerMoveDown;

  /// No description provided for @stickerNoCustomStickers.
  ///
  /// In en, this message translates to:
  /// **'No custom stickers'**
  String get stickerNoCustomStickers;

  /// No description provided for @stickerMoveToFront.
  ///
  /// In en, this message translates to:
  /// **'Move to Front'**
  String get stickerMoveToFront;

  /// No description provided for @stickerDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Deleted stickers cannot be recovered'**
  String get stickerDeleteConfirmTitle;

  /// No description provided for @complaintTitle.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get complaintTitle;

  /// No description provided for @complaintHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue'**
  String get complaintHint;

  /// No description provided for @complaintType.
  ///
  /// In en, this message translates to:
  /// **'Report Type'**
  String get complaintType;

  /// No description provided for @complaintSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report submitted'**
  String get complaintSubmitted;

  /// No description provided for @complaintSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get complaintSubmit;

  /// No description provided for @complaintSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get complaintSubmitting;

  /// No description provided for @complaintFallbackOtherViolation.
  ///
  /// In en, this message translates to:
  /// **'Other policy violation'**
  String get complaintFallbackOtherViolation;

  /// No description provided for @complaintFallbackFraud.
  ///
  /// In en, this message translates to:
  /// **'Other fraud or scam'**
  String get complaintFallbackFraud;

  /// No description provided for @complaintFallbackAccountCompromised.
  ///
  /// In en, this message translates to:
  /// **'Account may be compromised'**
  String get complaintFallbackAccountCompromised;

  /// No description provided for @chatBackgroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat Background'**
  String get chatBackgroundTitle;

  /// No description provided for @chatBackgroundLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading chat backgrounds'**
  String get chatBackgroundLoading;

  /// No description provided for @chatBackgroundEmpty.
  ///
  /// In en, this message translates to:
  /// **'No chat backgrounds'**
  String get chatBackgroundEmpty;

  /// No description provided for @chatBackgroundDefault.
  ///
  /// In en, this message translates to:
  /// **'Default Background'**
  String get chatBackgroundDefault;

  /// No description provided for @chatBackgroundItem.
  ///
  /// In en, this message translates to:
  /// **'Background {index}'**
  String chatBackgroundItem(int index);

  /// No description provided for @chatBackgroundPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview Background'**
  String get chatBackgroundPreviewTitle;

  /// No description provided for @chatBackgroundSet.
  ///
  /// In en, this message translates to:
  /// **'Set Background'**
  String get chatBackgroundSet;

  /// No description provided for @chatBackgroundSelectedStatus.
  ///
  /// In en, this message translates to:
  /// **'Chat background set'**
  String get chatBackgroundSelectedStatus;

  /// No description provided for @chatBackgroundInUse.
  ///
  /// In en, this message translates to:
  /// **'In Use'**
  String get chatBackgroundInUse;

  /// No description provided for @chatContactFallback.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get chatContactFallback;

  /// No description provided for @chatPersonalCard.
  ///
  /// In en, this message translates to:
  /// **'Contact Card'**
  String get chatPersonalCard;

  /// No description provided for @chatSystemMessageDigest.
  ///
  /// In en, this message translates to:
  /// **'[System Message]'**
  String get chatSystemMessageDigest;

  /// No description provided for @chatMessageDigestMessage.
  ///
  /// In en, this message translates to:
  /// **'[Message]'**
  String get chatMessageDigestMessage;

  /// No description provided for @chatMessageDigestImage.
  ///
  /// In en, this message translates to:
  /// **'[Image]'**
  String get chatMessageDigestImage;

  /// No description provided for @chatMessageDigestVoice.
  ///
  /// In en, this message translates to:
  /// **'[Voice]'**
  String get chatMessageDigestVoice;

  /// No description provided for @chatMessageDigestVideo.
  ///
  /// In en, this message translates to:
  /// **'[Video]'**
  String get chatMessageDigestVideo;

  /// No description provided for @chatMessageDigestLocation.
  ///
  /// In en, this message translates to:
  /// **'[Location]'**
  String get chatMessageDigestLocation;

  /// No description provided for @chatMessageDigestCard.
  ///
  /// In en, this message translates to:
  /// **'[Contact Card]'**
  String get chatMessageDigestCard;

  /// No description provided for @chatMessageDigestFile.
  ///
  /// In en, this message translates to:
  /// **'[File]'**
  String get chatMessageDigestFile;

  /// No description provided for @chatMessageDigestHistory.
  ///
  /// In en, this message translates to:
  /// **'[Chat History]'**
  String get chatMessageDigestHistory;

  /// No description provided for @chatMessageDigestSticker.
  ///
  /// In en, this message translates to:
  /// **'[Sticker]'**
  String get chatMessageDigestSticker;

  /// No description provided for @dateWeekdayShortMonday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dateWeekdayShortMonday;

  /// No description provided for @dateWeekdayShortTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dateWeekdayShortTuesday;

  /// No description provided for @dateWeekdayShortWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dateWeekdayShortWednesday;

  /// No description provided for @dateWeekdayShortThursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dateWeekdayShortThursday;

  /// No description provided for @dateWeekdayShortFriday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dateWeekdayShortFriday;

  /// No description provided for @dateWeekdayShortSaturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get dateWeekdayShortSaturday;

  /// No description provided for @dateWeekdayShortSunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get dateWeekdayShortSunday;

  /// No description provided for @appIconClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get appIconClassic;

  /// No description provided for @appIconSimple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get appIconSimple;

  /// No description provided for @appIconDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appIconDark;

  /// No description provided for @appIconFestive.
  ///
  /// In en, this message translates to:
  /// **'Festive'**
  String get appIconFestive;

  /// No description provided for @appIconGradient.
  ///
  /// In en, this message translates to:
  /// **'Gradient'**
  String get appIconGradient;

  /// No description provided for @appIconUpdated.
  ///
  /// In en, this message translates to:
  /// **'Icon updated'**
  String get appIconUpdated;

  /// No description provided for @appIconUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Switch failed. Try again later.'**
  String get appIconUpdateFailed;

  /// No description provided for @appearanceBubbleColorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get appearanceBubbleColorPurple;

  /// No description provided for @appearanceBubbleColorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get appearanceBubbleColorGreen;

  /// No description provided for @appearanceBubbleColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get appearanceBubbleColorBlue;

  /// No description provided for @appearanceBubbleColorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get appearanceBubbleColorOrange;

  /// No description provided for @appearanceBubbleColorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get appearanceBubbleColorPink;

  /// No description provided for @replyPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Reply to {name}'**
  String replyPreviewTitle(String name);

  /// No description provided for @replyPreviewCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Reply'**
  String get replyPreviewCancel;

  /// No description provided for @chatPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat Password'**
  String get chatPasswordTitle;

  /// No description provided for @chatPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a 6-digit password'**
  String get chatPasswordHint;

  /// No description provided for @chatPasswordErrorRemain.
  ///
  /// In en, this message translates to:
  /// **'Wrong password. Chat history will be cleared after {remain} more failed attempts.'**
  String chatPasswordErrorRemain(int remain);

  /// No description provided for @emojiPackEmpty.
  ///
  /// In en, this message translates to:
  /// **'No stickers in this pack'**
  String get emojiPackEmpty;

  /// No description provided for @emojiRecentSection.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get emojiRecentSection;

  /// No description provided for @emojiAllSection.
  ///
  /// In en, this message translates to:
  /// **'All Emoji'**
  String get emojiAllSection;

  /// No description provided for @stickerSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get stickerSearching;

  /// No description provided for @stickerNoSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get stickerNoSearchResults;

  /// No description provided for @stickerSearchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Results:'**
  String get stickerSearchResultsTitle;

  /// No description provided for @homeChatPasswordWiped.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong attempts. Chat history was deleted.'**
  String get homeChatPasswordWiped;

  /// No description provided for @homeGroupNotFound.
  ///
  /// In en, this message translates to:
  /// **'Group chat not found'**
  String get homeGroupNotFound;

  /// No description provided for @homeConversationNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No chat history'**
  String get homeConversationNoHistory;

  /// No description provided for @homeConversationStartChat.
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get homeConversationStartChat;

  /// No description provided for @homeEnterGroupChat.
  ///
  /// In en, this message translates to:
  /// **'Enter Group Chat'**
  String get homeEnterGroupChat;

  /// No description provided for @homeNewGroup.
  ///
  /// In en, this message translates to:
  /// **'New Group Chat'**
  String get homeNewGroup;

  /// No description provided for @homeFriendRequestAcceptFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to accept: {error}'**
  String homeFriendRequestAcceptFailed(String error);

  /// No description provided for @homeFriendRequestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Friend request accepted'**
  String get homeFriendRequestAccepted;

  /// No description provided for @homeFriendRequestRefuseFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to refuse: {error}'**
  String homeFriendRequestRefuseFailed(String error);

  /// No description provided for @homeFriendRequestDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete: {error}'**
  String homeFriendRequestDeleteFailed(String error);

  /// No description provided for @contactPresenceOnlineWithDevice.
  ///
  /// In en, this message translates to:
  /// **'Online on {device}'**
  String contactPresenceOnlineWithDevice(String device);

  /// No description provided for @contactPresenceJustOnlineWithDevice.
  ///
  /// In en, this message translates to:
  /// **'Online on {device} just now'**
  String contactPresenceJustOnlineWithDevice(String device);

  /// No description provided for @contactPresenceMinutesOnlineWithDevice.
  ///
  /// In en, this message translates to:
  /// **'Online on {device} {minutes} min ago'**
  String contactPresenceMinutesOnlineWithDevice(int minutes, String device);

  /// No description provided for @contactPresenceLastOnline.
  ///
  /// In en, this message translates to:
  /// **'Last online {time}'**
  String contactPresenceLastOnline(String time);

  /// No description provided for @contactPresenceDeviceWeb.
  ///
  /// In en, this message translates to:
  /// **'web'**
  String get contactPresenceDeviceWeb;

  /// No description provided for @contactPresenceDeviceDesktop.
  ///
  /// In en, this message translates to:
  /// **'desktop'**
  String get contactPresenceDeviceDesktop;

  /// No description provided for @contactPresenceDeviceMobile.
  ///
  /// In en, this message translates to:
  /// **'mobile'**
  String get contactPresenceDeviceMobile;

  /// No description provided for @botCommandsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No commands yet'**
  String get botCommandsEmpty;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'ms',
    'nl',
    'pt',
    'ru',
    'th',
    'tr',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
