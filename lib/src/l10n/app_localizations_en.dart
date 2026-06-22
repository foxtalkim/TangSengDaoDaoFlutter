// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
  String get actionGetStarted => 'Get Started';

  @override
  String get actionSaving => 'Saving...';

  @override
  String get moduleUnsupported =>
      'This feature is not available in this version';

  @override
  String get moduleLoading => 'Checking feature access. Try again later.';

  @override
  String get moduleOfflineStale =>
      'Connect to the network to confirm feature access';

  @override
  String get onboardingMenuTitle => 'Quick Guide';

  @override
  String onboardingChatTitle(Object appName) {
    return 'Welcome to $appName';
  }

  @override
  String get onboardingChatSubtitle =>
      'A clean, light place for more comfortable conversations.';

  @override
  String get onboardingFriendsTitle => 'Make staying in touch simple';

  @override
  String get onboardingFriendsSubtitle =>
      'Friends, groups, and sharing are easier to find.';

  @override
  String get onboardingSecurityTitle => 'Speak freely. Use it with confidence.';

  @override
  String get onboardingSecuritySubtitle =>
      'Account security and privacy protection help guard your boundaries.';

  @override
  String get onboardingChatSemantic => 'Message sync onboarding illustration';

  @override
  String get onboardingFriendsSemantic =>
      'Friends and groups onboarding illustration';

  @override
  String get onboardingSecuritySemantic =>
      'Security and privacy onboarding illustration';

  @override
  String get settingsLanguageRow => 'Language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get profileRowFavorites => 'Favorites';

  @override
  String get profileRowSecurityPrivacy => 'Security & Privacy';

  @override
  String get profileRowNotifications => 'Notifications';

  @override
  String get profileRowInviteCode => 'Invite Code';

  @override
  String get profileRowGeneral => 'General';

  @override
  String profileRowAbout(Object appName) {
    return 'About $appName';
  }

  @override
  String get profileLogout => 'Log Out';

  @override
  String get profileLogoutConfirm =>
      'Logging out won\'t delete any history. You can sign back in with this account anytime.';

  @override
  String profileMoyuIdLabel(Object appName, Object value) {
    return '$appName ID: $value';
  }

  @override
  String get profileDefaultName => 'Me';

  @override
  String get profileDetailTitle => 'Profile';

  @override
  String get profileAvatar => 'Avatar';

  @override
  String get profileNickname => 'Nickname';

  @override
  String get profileEditNickname => 'Edit Nickname';

  @override
  String profileEditFoxId(Object appName) {
    return 'Edit $appName ID';
  }

  @override
  String get profileGender => 'Gender';

  @override
  String get profileGenderMale => 'Male';

  @override
  String get profileGenderFemale => 'Female';

  @override
  String get profileGenderSelected => 'Selected';

  @override
  String get profileGenderUnset => 'Not set';

  @override
  String get profilePhoneUnbound => 'Not linked';

  @override
  String get profileAvatarUpdated => 'Avatar updated';

  @override
  String get profileAvatarUpdateFailed => 'Failed to upload avatar. Try again.';

  @override
  String get generalPageTitle => 'General';

  @override
  String get generalFontSize => 'Font Size';

  @override
  String get generalChatBackground => 'Chat Background';

  @override
  String get generalDarkMode => 'Dark Mode';

  @override
  String get generalClearCache => 'Clear Cache';

  @override
  String get generalClearMessages => 'Clear Chat History';

  @override
  String get generalAppModules => 'Features';

  @override
  String get generalErrorLogs => 'Error Logs';

  @override
  String get generalThirdShare => 'Third-party SDKs';

  @override
  String get fontSizeSmall => 'Small';

  @override
  String get fontSizeStandard => 'Standard';

  @override
  String get fontSizeLarge => 'Large';

  @override
  String get fontSizeExtraLarge => 'Extra Large';

  @override
  String get darkModeSystem => 'System default';

  @override
  String get darkModeLight => 'Light';

  @override
  String get darkModeDark => 'Dark';

  @override
  String get valueConfigure => 'Configure';

  @override
  String get valueManage => 'Manage';

  @override
  String get valueClear => 'Clear';

  @override
  String get valueUpload => 'Upload';

  @override
  String get valueDownload => 'Download';

  @override
  String get valueView => 'View';

  @override
  String get valueEnabled => 'Enabled';

  @override
  String get valueDisabled => 'Disabled';

  @override
  String get valueOn => 'On';

  @override
  String get valueOff => 'Off';

  @override
  String get valueConfigured => 'Set';

  @override
  String get valueNotEnabled => 'Not enabled';

  @override
  String get valueSelected => 'Selected';

  @override
  String get valueCurrentDevice => 'This device';

  @override
  String get valueSdkInfo => 'SDK Info';

  @override
  String get statusProcessing => 'Processing';

  @override
  String get statusLoading => 'Loading';

  @override
  String get statusSending => 'Sending';

  @override
  String get statusSaving => 'Saving';

  @override
  String get statusSaved => 'Saved';

  @override
  String get statusSent => 'Sent';

  @override
  String get statusSubmitted => 'Submitted';

  @override
  String get dateJustNow => 'Just now';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get dateDayBeforeYesterday => 'The Day Before Yesterday';

  @override
  String dateTodayTime(Object time) {
    return 'Today $time';
  }

  @override
  String dateYesterdayTime(Object time) {
    return 'Yesterday $time';
  }

  @override
  String dateDayBeforeYesterdayTime(Object time) {
    return 'Two days ago $time';
  }

  @override
  String dateWeekdayTime(Object time, Object weekday) {
    return '$weekday $time';
  }

  @override
  String dateMonthDayTime(Object day, Object month, Object time) {
    return '$month/$day $time';
  }

  @override
  String dateYearMonthDayTime(
    Object day,
    Object month,
    Object time,
    Object year,
  ) {
    return '$year/$month/$day $time';
  }

  @override
  String dateMonthDay(Object day, Object month) {
    return '$month/$day';
  }

  @override
  String dateYearMonthDay(Object day, Object month, Object year) {
    return '$year/$month/$day';
  }

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get dialogClearAllTitle => 'Clear all chat history?';

  @override
  String get dialogClearAllBody =>
      'All local chat history and conversation entries will be removed.';

  @override
  String get authLoginSubtitle =>
      'Log in with your phone number and keep chatting with friends';

  @override
  String get authLoginIllustration => 'Login illustration';

  @override
  String get authRegisterIllustration => 'Register illustration';

  @override
  String get authSecurityIllustration => 'Verification illustration';

  @override
  String get authResetIllustration => 'Password reset illustration';

  @override
  String get authServerLabel => 'Server';

  @override
  String get authServerCustomLabel => 'Custom server';

  @override
  String get authServerCustomHint => 'Enter server address';

  @override
  String get authPhoneLabel => 'Phone number';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authLoginButton => 'Log In';

  @override
  String get authLoginLoading => 'Logging in...';

  @override
  String get authRegisterButton => 'Register';

  @override
  String get authLoginWithApple => 'Sign in with Apple';

  @override
  String get authLoginWithGoogle => 'Sign in with Google';

  @override
  String get authLoginWithGithub => 'Sign in with GitHub';

  @override
  String get authLoginAgreementPrefix => 'By logging in, you agree to ';

  @override
  String get authTermsTitle => 'Terms of Service';

  @override
  String get authAgreementConnector => ' and ';

  @override
  String get authPrivacyTitle => 'Privacy Policy';

  @override
  String get authVerifyTitle => 'Verification Login';

  @override
  String authVerifySubtitleWithPhone(Object phone) {
    return 'Enter the code sent to $phone';
  }

  @override
  String get authVerifySubtitlePasswordFirst =>
      'Log in with your password first to start security verification';

  @override
  String get authVerifyButton => 'Verify';

  @override
  String get authVerifyLoading => 'Verifying...';

  @override
  String get authResendCode => 'Didn\'t get a code? Resend';

  @override
  String get authVerificationCodeSent => 'Verification code sent';

  @override
  String get authVerificationCodeRequired => 'Enter the verification code';

  @override
  String get authVerificationCodeSixDigits => 'Enter the 6-digit code';

  @override
  String get authPasswordResetTitle => 'Reset Login Password';

  @override
  String get authPasswordResetSubtitle =>
      'Verify your phone number, then set a new login password';

  @override
  String get authPasswordResetButton => 'Reset Password';

  @override
  String get authKickedTitle => 'Your account was logged in on another device.';

  @override
  String get authSubmitting => 'Submitting...';

  @override
  String get authVerificationCodeLabel => 'Verification code';

  @override
  String get authGetVerificationCode => 'Get code';

  @override
  String get authNewPasswordLabel => 'New password';

  @override
  String get authPasswordResetSuccess => 'Password reset';

  @override
  String authRegisterTitle(Object appName) {
    return 'Create a $appName Account';
  }

  @override
  String get authRegisterSubtitle =>
      'Register with your phone number and start chatting right away';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authNicknameLabel => 'Nickname';

  @override
  String get authInviteCodeRequiredLabel => 'Invite code (required)';

  @override
  String authCodeRetryAfter(Object seconds) {
    return 'Retry in ${seconds}s';
  }

  @override
  String get authRegisterAgreement =>
      'I have read and agree to the Terms of Service and Privacy Policy';

  @override
  String get authInvalidPhone => 'Invalid phone number';

  @override
  String get authAcceptAgreementFirst =>
      'Please agree to the Terms of Service and Privacy Policy first';

  @override
  String get authCodeEmpty => 'Verification code is required';

  @override
  String get authPasswordLengthInvalid => 'Password must be 6-16 characters';

  @override
  String get authInviteCodeEmpty => 'Invite code is required';

  @override
  String get authRegisterSuccess => 'Registered successfully';

  @override
  String get settingsCheckNewVersion => 'Check for Updates';

  @override
  String get settingsChecking => 'Checking';

  @override
  String get settingsVersionFound => 'Update Available';

  @override
  String get settingsUserAgreement => 'Terms of Service';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsView => 'View';

  @override
  String get settingsSwitchAccount => 'Switch Account';

  @override
  String get settingsCacheCleared => 'Cache cleared';

  @override
  String get settingsClearCacheSheetTitle =>
      'Clear image/video cache?\nChat images, video covers, and avatars will be downloaded again.';

  @override
  String get settingsClearCacheAction => 'Clear Cache';

  @override
  String get settingsMessagesCleared => 'Chat history cleared';

  @override
  String settingsClearMessagesFailed(Object error) {
    return 'Failed to clear chat history: $error';
  }

  @override
  String get settingsAlreadyLatestVersion =>
      'You\'re already on the latest version';

  @override
  String get settingsCheckFailed => 'Check failed';

  @override
  String settingsUpdateDialogTitle(Object version) {
    return 'Update available\nLatest version: $version';
  }

  @override
  String settingsUpdateDialogTitleWithDescription(
    Object description,
    Object version,
  ) {
    return 'Update available\nLatest version: $version\n$description';
  }

  @override
  String get settingsLater => 'Later';

  @override
  String get settingsUpdateNow => 'Update Now';

  @override
  String get settingsSaveFailedRetry => 'Failed to save. Try again.';

  @override
  String get securityAllowPhoneSearch =>
      'Allow others to find me by phone number';

  @override
  String securityAllowFoxIdSearch(Object appName) {
    return 'Allow others to find me by $appName ID';
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
  String get securityLoginPassword => 'Login Password';

  @override
  String get securityChatPassword => 'Chat Password';

  @override
  String get securityScreenProtection => 'Screen Protection';

  @override
  String get securityLockPassword => 'Lock Password';

  @override
  String get securityOfflineProtection => 'Offline Screen Lock';

  @override
  String get securityDeviceManagement => 'Login Device Management';

  @override
  String get securityDeviceRemark =>
      'View and manage devices, enable login protection, and keep your account secure.';

  @override
  String get securityBlacklist => 'Blacklist';

  @override
  String get securityAccountDeletion => 'Delete Account';

  @override
  String get accountDeletionBody =>
      'Account deletion cannot be undone. After confirmation, a verification code will be sent by SMS to complete deletion.';

  @override
  String get accountDeletionSubmitted => 'Deletion request submitted';

  @override
  String get accountDeletionGetCode => 'Get code';

  @override
  String get passwordResetInstruction =>
      'Changing your login password requires an SMS code. The new password must be at least 6 characters.';

  @override
  String get accountPhoneLabel => 'Phone number';

  @override
  String get passwordRuleLabel => 'Password rule';

  @override
  String get passwordAtLeastSix => 'At least 6 characters';

  @override
  String get passwordConfirmLabel => 'Confirm Password';

  @override
  String get passwordConfirmHint => 'Enter the login password again';

  @override
  String get passwordChanged => 'Login password changed';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get chatPasswordInstruction =>
      'When enabled, this 6-digit password is required before opening protected chats.';

  @override
  String get currentStatusLabel => 'Current Status';

  @override
  String get passwordSixDigits => '6 digits';

  @override
  String get chatPasswordEnableAction => 'Enable Chat Password';

  @override
  String get loginPasswordRequired => 'Login password is required';

  @override
  String get chatPasswordSixDigitsRequired => 'Chat password must be 6 digits';

  @override
  String get lockSetTitle => 'Set a 6-digit lock password';

  @override
  String lockSetSubtitle(Object appName) {
    return 'Required to unlock $appName';
  }

  @override
  String get lockCurrentPromptTitle => 'Enter current lock password';

  @override
  String get lockCurrentPromptSubtitle =>
      'Verify before changing or turning it off';

  @override
  String get lockAutoLock => 'Auto Lock';

  @override
  String get lockChangePassword => 'Change Unlock Password';

  @override
  String get lockClosePassword => 'Turn Off Unlock Password';

  @override
  String get lockWrongPassword => 'Wrong password. Try again.';

  @override
  String get lockSixDigitsRequired => 'Lock password must be 6 digits';

  @override
  String get lockInputTitle => 'Enter lock password';

  @override
  String lockInputSubtitle(Object appName) {
    return 'Unlock to continue using $appName';
  }

  @override
  String get lockSetFailed => 'Failed to set. Try again.';

  @override
  String get lockImmediately => 'Immediately';

  @override
  String get lockAfter5Minutes => 'After 5 minutes away';

  @override
  String get lockAfter30Minutes => 'After 30 minutes away';

  @override
  String get lockAfter1Hour => 'After 1 hour away';

  @override
  String get deviceLoginProtection => 'Login Protection';

  @override
  String get deviceProtectionRemark =>
      'When login protection is enabled, security verification is required on unfamiliar devices. Recommended for account safety.';

  @override
  String get deviceNone => 'No logged-in devices';

  @override
  String get deviceDebugName => 'Current Device';

  @override
  String get deviceDebugPlatform => 'iPhone / Android debug device';

  @override
  String get deviceProtectionEnabled => 'Login protection enabled';

  @override
  String get deviceProtectionDisabled => 'Login protection disabled';

  @override
  String get deviceProtectionUpdateFailed =>
      'Failed to update login protection. Try again.';

  @override
  String get blacklistEmpty => 'No blacklisted contacts';

  @override
  String get switchAccountRecent => 'Recent Accounts';

  @override
  String get switchAccountLoading => 'Reading recent accounts';

  @override
  String get switchAccountAddOther => 'Add or log in to another account';

  @override
  String get switchAccountCurrent => 'Current';

  @override
  String get appModulesLoading => 'Loading feature modules';

  @override
  String get appModulesEmpty => 'No feature modules';

  @override
  String get appModulesUnavailable => 'Module unavailable';

  @override
  String get errorLogsLoading => 'Reading error logs';

  @override
  String get errorLogsEmpty => 'No error logs';

  @override
  String get errorLogFileName => 'File Name';

  @override
  String get errorLogFileSize => 'File Size';

  @override
  String get errorLogGeneratedAt => 'Generated At';

  @override
  String get errorLogFilePath => 'File Path';

  @override
  String get notificationReceiveNew => 'Receive New Message Notifications';

  @override
  String get notificationSound => 'Sound';

  @override
  String get notificationVibration => 'Vibration';

  @override
  String get notificationShowDetails => 'Show Notification Details';

  @override
  String get notificationSystem => 'System Message Notifications';

  @override
  String get notificationCalls => 'Audio/Video Call Notifications';

  @override
  String get settingsGoToSystem => 'Settings';

  @override
  String aboutAppIconSemantic(Object appName) {
    return '$appName icon';
  }

  @override
  String aboutCopyright(Object appName) {
    return 'Copyright © 2026\n$appName. All rights reserved.';
  }

  @override
  String get policyWebUrl => 'Web URL';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get appearanceAppIcon => 'App Icon';

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
  String get appearanceChatColor => 'Chat Color';

  @override
  String get appearanceBubbleRadius => 'Bubble Corner Radius';

  @override
  String get appearanceBubbleColorInk => 'Ink Black';

  @override
  String get appearanceSquare => 'Square';

  @override
  String get appearanceRound => 'Round';

  @override
  String get appearancePreviewOne =>
      'Does he want me to turn right or left? 🤔';

  @override
  String get appearancePreviewTwo => 'Right. And, well, make it strong.';

  @override
  String get appearancePreviewThree =>
      'Is that all? I feel like he said more than that. 😯';

  @override
  String get appearancePreviewFour =>
      'That\'s about it. I\'ll send a voice message with more details later.';

  @override
  String get contactsEmptyTitle => 'No contacts yet';

  @override
  String get contactsEmptySubtitle =>
      'Add friends from the top right or scan a profile card';

  @override
  String contactsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contacts',
      one: '1 contact',
    );
    return '$_temp0';
  }

  @override
  String get contactAddTooltip => 'Add Friend';

  @override
  String get contactSearchHint => 'Search contacts and groups';

  @override
  String get contactSetRemark => 'Set Remark';

  @override
  String get contactAddToBlacklist => 'Add to Blacklist';

  @override
  String get contactDeleteFriend => 'Delete Friend';

  @override
  String get contactAddedToBlacklist => 'Added to blacklist';

  @override
  String get operationFailed => 'Operation failed. Try again.';

  @override
  String operationFailedWithError(String error) {
    return 'Operation failed: $error';
  }

  @override
  String contactDeleteFriendConfirm(Object name) {
    return 'Delete friend \"$name\"?\nChat history will also be cleared.';
  }

  @override
  String get contactConfirmDelete => 'Confirm Delete';

  @override
  String get contactDeleted => 'Friend deleted';

  @override
  String get contactUnknownUser => 'Unknown user';

  @override
  String get contactActionNewFriends => 'New Friends';

  @override
  String get contactActionSavedGroups => 'Saved Groups';

  @override
  String get contactSearchNoMatches => 'No matching contacts';

  @override
  String get addFriendTitle => 'Add Friend';

  @override
  String addFriendSearchHint(Object appName) {
    return 'Phone / $appName ID';
  }

  @override
  String get addFriendNotFound => 'Account not found';

  @override
  String get myQrCodeTitle => 'My QR Code';

  @override
  String myQrCodeSubtitle(Object appName) {
    return 'Scan this QR code to add me on $appName';
  }

  @override
  String get myQrCodeEmpty => 'No QR code';

  @override
  String get scanTitle => 'Scan';

  @override
  String get scanQrNotFound => 'No QR code recognized';

  @override
  String scanResolveFailed(String error) {
    return 'Failed to parse QR code: $error';
  }

  @override
  String get scanUnrecognized => 'This QR code cannot be recognized';

  @override
  String get scanInfoIncomplete => 'QR code information is incomplete';

  @override
  String get scanSocialUnavailable => 'Social service is not initialized';

  @override
  String get scanJoinedGroup => 'Joined group chat';

  @override
  String get scanCannotOpenGroup => 'This page cannot open group chats';

  @override
  String get scanGroupNotFound => 'Group chat not found';

  @override
  String get scanOpenGroupFailed => 'Failed to open group chat';

  @override
  String get scanSelfQr => 'This is your own QR code';

  @override
  String get scanUserNotFound => 'User not found';

  @override
  String get scanCameraPermissionRequired => 'Camera permission required';

  @override
  String get scanOpenSettings => 'Open Settings';

  @override
  String get scanCameraUnavailable => 'Camera unavailable';

  @override
  String get scanAlbum => 'Album';

  @override
  String get scanLightOn => 'Light On';

  @override
  String get scanLightOff => 'Light Off';

  @override
  String get scanQrCode => 'QR Code';

  @override
  String get scanGroupFallback => 'Group Chat';

  @override
  String get scanGroupLoadingInfo => 'Loading group info';

  @override
  String scanGroupMemberCount(int count) {
    return '$count members';
  }

  @override
  String get scanJoinGroupConfirm => 'Join Group Chat';

  @override
  String get scanJoining => 'Joining';

  @override
  String get scanJoinGroup => 'Join Group Chat';

  @override
  String scanJoinFailed(String error) {
    return 'Failed to join: $error';
  }

  @override
  String get tagsTitle => 'Tags';

  @override
  String get tagsCreateTooltip => 'New Tag';

  @override
  String get tagsContactSection => 'Contact Tags';

  @override
  String get tagsEmptyTitle => 'No tags';

  @override
  String get tagsEmptySubtitle =>
      'Tap + in the top right to group contacts or chats.';

  @override
  String tagsCreateFailed(Object error) {
    return 'Failed to create tag: $error';
  }

  @override
  String tagsUpdateFailed(Object error) {
    return 'Failed to update tag: $error';
  }

  @override
  String tagsDeleteFailed(Object error) {
    return 'Failed to delete tag: $error';
  }

  @override
  String tagsLoadFailed(Object error) {
    return 'Failed to load tags: $error';
  }

  @override
  String tagsDeleteConfirm(String name) {
    return 'Delete tag \"$name\"?\nContacts and groups in this tag will not be deleted.';
  }

  @override
  String get tagsEditTitle => 'Edit Tag';

  @override
  String get tagsCreateTitle => 'New Tag';

  @override
  String get tagsNameSection => 'Tag Name';

  @override
  String get tagsNameHint => 'Family, friends';

  @override
  String tagsMembersSection(int count) {
    return 'Tag Members ($count)';
  }

  @override
  String get tagsAddMember => 'Add Member';

  @override
  String get tagsDelete => 'Delete Tag';

  @override
  String get tagsGroupInitial => 'G';

  @override
  String get tagsUnknownUser => 'Unknown user';

  @override
  String get tagsSelectMembersTitle => 'Select Members';

  @override
  String tagsDoneCount(int count) {
    return 'Done ($count)';
  }

  @override
  String get tagsSearchHint => 'Search contacts or groups';

  @override
  String get tagsGroupsSection => 'Group Chats';

  @override
  String get tagsContactsSection => 'Contacts';

  @override
  String get tagsNoMatchesTitle => 'No matches';

  @override
  String get tagsNoMatchesSubtitle => 'Try another keyword';

  @override
  String tagsRowTitle(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get phoneContactsTitle => 'Phone Contacts';

  @override
  String get phoneContactsSection => 'Add from phone contacts';

  @override
  String get phoneContactsEmpty => 'No phone contacts';

  @override
  String get phoneContactsNoAddable => 'No phone contacts to add';

  @override
  String get phoneContactsServerSyncFailed =>
      'Server sync failed. Showing existing contacts.';

  @override
  String get friendAlreadyAdded => 'Added';

  @override
  String get friendRequestSent => 'Friend request sent';

  @override
  String phoneContactsInviteSmsBody(Object appName) {
    return 'I\'m using $appName. The chat experience is pretty nice. Come try it too.';
  }

  @override
  String get phoneContactsInviteOpened => 'SMS invite opened';

  @override
  String get phoneContactsInviteFailed =>
      'Cannot open SMS. Please invite manually.';

  @override
  String get friendRequestsEmptyTitle => 'No new friends';

  @override
  String get friendRequestsEmptySubtitle =>
      'Invite friends to scan your QR code';

  @override
  String get friendRequestsPendingSection => 'Pending';

  @override
  String get friendRequestRefused => 'Refused';

  @override
  String contactOpenFromContacts(Object name) {
    return 'Open @$name\'s chat from Contacts';
  }

  @override
  String get fileHelperIntro =>
      'Log in to the web version and send me messages to transfer text, photos, audio, videos, and files between phone and computer.';

  @override
  String get fileHelperName => 'File Transfer';

  @override
  String get systemAccountName => 'System';

  @override
  String systemAccountIntro(Object appName) {
    return 'Official $appName account for sending notifications.';
  }

  @override
  String get contactIntroTitle => 'Introduction';

  @override
  String get contactSource => 'Source';

  @override
  String get contactRemoveFriendRelation => 'Remove Friend';

  @override
  String get contactRemoveFromBlacklist => 'Remove from Blacklist';

  @override
  String get contactSendMessage => 'Message';

  @override
  String get contactAddToContacts => 'Add to Contacts';

  @override
  String get contactRemoveFriendConfirm => 'Remove this friend?';

  @override
  String contactNicknameLine(Object name) {
    return 'Nickname: $name';
  }

  @override
  String get contactRemoveFromBlacklistConfirm =>
      'Remove this contact from the blacklist?';

  @override
  String get webLoginTitle => 'Web Login';

  @override
  String get webLoginConfirmTitle => 'Confirm web login?';

  @override
  String get webLoginConfirmBody =>
      'This will allow your account to log in to the current browser or desktop client. If this wasn\'t you, tap Cancel.';

  @override
  String get webLoginConfirmAction => 'Confirm Login';

  @override
  String get webLoginConfirming => 'Confirming...';

  @override
  String get webLoginConfirmed => 'Web login confirmed';

  @override
  String webLoginConfirmFailed(Object error) {
    return 'Confirmation failed: $error';
  }

  @override
  String get applyFriendTitle => 'Friend Request';

  @override
  String get applyFriendSectionTitle => 'Send Friend Request';

  @override
  String get applyFriendRemarkHint => 'Hi, I\'m...';

  @override
  String friendRequestSendFailed(Object error) {
    return 'Failed to send: $error';
  }

  @override
  String get contactRemarkHint => 'Remark';

  @override
  String get momentPermissionsTitle => 'Moments Privacy';

  @override
  String get momentHideMineFromContact => 'Hide my Moments from them';

  @override
  String get momentHideContactFromMe => 'Hide their Moments from me';

  @override
  String get momentTitle => 'Moments';

  @override
  String get momentPersonalEmpty => 'No posts yet';

  @override
  String get momentEmpty => 'No Moments yet';

  @override
  String get momentCoverUploadFailed => 'Failed to upload cover';

  @override
  String momentCoverUploadFailedWithError(Object error) {
    return 'Failed to upload cover: $error';
  }

  @override
  String get momentDeleteConfirm => 'Delete this Moment?';

  @override
  String get momentJustNow => 'Just now';

  @override
  String get momentPublishing => 'Posting…';

  @override
  String get momentPublishFailed => 'Failed to post. Tap to dismiss.';

  @override
  String get momentRemindedYou => 'Reminded you to view this Moment';

  @override
  String momentRemindedNames(Object names) {
    return 'Reminded $names';
  }

  @override
  String get momentKeepEditingConfirm => 'Keep this edit?';

  @override
  String get momentContinueEditing => 'Keep Editing';

  @override
  String get momentSaveDraft => 'Save Draft';

  @override
  String get momentDiscardDraft => 'Discard';

  @override
  String get momentPublishTitle => 'Post';

  @override
  String get momentPublishHint => 'What\'s on your mind...';

  @override
  String get momentLocationTitle => 'Location';

  @override
  String get momentRemindWho => 'Remind';

  @override
  String get locationUnsupported => 'Location is not available in this version';

  @override
  String momentPrivacyContactCount(Object count, Object label) {
    return '$label · $count';
  }

  @override
  String get momentSelectVisibleContacts => 'Select Visible Contacts';

  @override
  String get momentSelectHiddenContacts => 'Select Hidden Contacts';

  @override
  String get momentPrivacyPublic => 'Public';

  @override
  String get momentPrivacyPrivate => 'Private';

  @override
  String get momentPrivacyInternal => 'Visible to Some';

  @override
  String get momentPrivacyProhibit => 'Hide From';

  @override
  String get momentPrivacyWhoCanSee => 'Who Can See';

  @override
  String momentCommentFailed(Object error) {
    return 'Comment failed: $error';
  }

  @override
  String get momentDetailTitle => 'Details';

  @override
  String get momentDeleted => 'This Moment was deleted';

  @override
  String get momentCollapse => 'Collapse';

  @override
  String get momentFullText => 'Full Text';

  @override
  String get momentDeleteCommentConfirm => 'Delete this comment?';

  @override
  String get momentCommentPlaceholder => 'Comment';

  @override
  String momentReplyPlaceholder(Object name) {
    return 'Reply $name';
  }

  @override
  String get momentLikeAction => 'Like';

  @override
  String get momentCommentAction => 'Comment';

  @override
  String momentNewMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new messages',
      one: '1 new message',
    );
    return '$_temp0';
  }

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesEmpty => 'No messages';

  @override
  String get messagesEmptyTitle => 'No messages yet';

  @override
  String get messagesEmptySubtitle => 'Start a new chat from the top right';

  @override
  String get messagesNewConversation => 'New';

  @override
  String get messagesStartGroupChat => 'Start Group Chat';

  @override
  String get messagesImDisconnected => 'IM is not connected';

  @override
  String get messagesPinned => 'Pinned';

  @override
  String get messagesUnpinned => 'Unpinned';

  @override
  String get messagesMuted => 'Muted';

  @override
  String get messagesNotificationsOn => 'Notifications on';

  @override
  String messagesDeleteConversationTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get messagesConfirmDelete => 'Delete';

  @override
  String get messagesCleared => 'Chat history cleared';

  @override
  String get messagesConversationDeleted => 'Conversation deleted';

  @override
  String get messagesUnknownUser => 'Unknown user';

  @override
  String get messagesFriendAvatarFallback => 'F';

  @override
  String get messagesGroupFallback => 'Group Chat';

  @override
  String get messagesGroupAvatarFallback => 'G';

  @override
  String get messagesNewMessageDigest => '[New message]';

  @override
  String get messagesConversationPin => 'Pin';

  @override
  String get messagesConversationUnpin => 'Unpin';

  @override
  String get messagesConversationMute => 'Mute';

  @override
  String get messagesConversationUnmute => 'Unmute';

  @override
  String get messagesConnectionNoNetwork =>
      'Network unavailable. Check your connection.';

  @override
  String get messagesConnectionDisconnected => 'Disconnected';

  @override
  String get messagesConnectionConnecting => 'Connecting';

  @override
  String get messagesConnectionSyncing => 'Syncing';

  @override
  String get globalSearchTitle => 'Search';

  @override
  String get globalSearchTabChats => 'Chats';

  @override
  String get globalSearchTabContacts => 'Contacts';

  @override
  String get globalSearchTabGroups => 'Groups';

  @override
  String get globalSearchTabFiles => 'Files';

  @override
  String get globalSearchContactsSection => 'Contacts';

  @override
  String get globalSearchGroupsSection => 'Group Chats';

  @override
  String get globalSearchMessagesSection => 'Chat History';

  @override
  String get globalSearchFilesSection => 'Files';

  @override
  String get globalSearchNoMatches => 'No matches';

  @override
  String get globalSearchNoMore => 'No more results';

  @override
  String get locationLocating => 'Locating...';

  @override
  String locationPermissionOff(Object appName) {
    return 'Location permission is off. Allow $appName to use location in system settings.';
  }

  @override
  String get locationPermissionDenied =>
      'Location permission was denied. Nearby places cannot be loaded.';

  @override
  String get locationMapUnsupported => 'AMap is not supported on this platform';

  @override
  String locationFailed(String error) {
    return 'Location failed: $error';
  }

  @override
  String get locationSearchPrompt => 'Enter keywords to search nearby places';

  @override
  String get locationNoNearbyPoi => 'No nearby POI';

  @override
  String get locationSearchHint => 'Search nearby places';

  @override
  String get locationPickerTitle => 'Location';

  @override
  String get locationSending => 'Sending';

  @override
  String get locationUnnamed => 'Unnamed place';

  @override
  String get locationCopiedAddress => 'Address copied';

  @override
  String get locationNoMapApp => 'No map app available';

  @override
  String get locationFallbackTitle => 'Location';

  @override
  String get locationAmap => 'AMap';

  @override
  String get locationBaiduMap => 'Baidu Maps';

  @override
  String get locationTencentMap => 'Tencent Maps';

  @override
  String get locationAppleMap => 'Apple Maps';

  @override
  String get locationOtherMap => 'Other Maps';

  @override
  String get locationMyLocation => 'My Location';

  @override
  String locationOpenMapFailed(String name) {
    return 'Cannot open $name';
  }

  @override
  String get locationCopyAddress => 'Copy Address';

  @override
  String get locationNavigate => 'Navigate';

  @override
  String get locationViewTitle => 'Map';

  @override
  String get momentPeerCommentDeleted => 'Comment deleted';

  @override
  String get momentDigest => '[Moment]';

  @override
  String get actionClose => 'Close';

  @override
  String get saveToAlbum => 'Save to Album';

  @override
  String get savedToAlbum => 'Saved to album';

  @override
  String get saveFailed => 'Save failed';

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
    return '$count photos';
  }

  @override
  String get momentReplyConnector => ' replied to ';

  @override
  String get groupRemarkTitle => 'Group Remark';

  @override
  String get groupRemarkHint => 'Set a group remark visible only to you';

  @override
  String get chatNotificationSettingsTitle => 'Message Notifications';

  @override
  String get chatScreenshotNotification => 'Screenshot Notifications';

  @override
  String get chatRevokeNotification => 'Recall Notifications';

  @override
  String get completeProfileTitle => 'Complete Profile';

  @override
  String get completeProfileUploadAvatar => 'Upload Avatar';

  @override
  String get completeProfileReuploadAvatar => 'Upload New Avatar';

  @override
  String get completeProfileChooseAvatar => 'Choose a profile photo';

  @override
  String get completeProfileAvatarUploaded => 'Avatar uploaded';

  @override
  String get completeProfileAvatarRequired => 'Avatar is required.';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get nicknameInputHint => 'Enter nickname';

  @override
  String get nicknameRequired => 'Nickname is required.';

  @override
  String get completeProfileSaved => 'Profile completed';

  @override
  String get chatSettingsTitle => 'Chat Details';

  @override
  String chatSettingsGroupTitle(Object count) {
    return 'Chat Info ($count)';
  }

  @override
  String get chatSettingsGroupName => 'Group Chat Name';

  @override
  String get chatSettingsGroupQrCode => 'Group QR Code';

  @override
  String get chatSearchContentTitle => 'Search Chat';

  @override
  String get chatSettingsBackground => 'Set Chat Background';

  @override
  String get chatSettingsBackgroundSelected => 'Current chat background set';

  @override
  String get chatSettingsMute => 'Mute Notifications';

  @override
  String get chatSettingsPin => 'Pin Chat';

  @override
  String get chatSettingsSaveToContacts => 'Save to Contacts';

  @override
  String get chatSettingsReadReceipt => 'Read Receipts';

  @override
  String get chatSettingsReadReceiptSubtitle =>
      'When enabled, sent messages show read/unread status';

  @override
  String get chatSettingsFlame => 'Burn After Reading';

  @override
  String get chatFlameTipExit =>
      'Read messages are destroyed after leaving chat';

  @override
  String chatFlameTipMinutes(Object minutes) {
    return 'Messages are destroyed $minutes min after being read';
  }

  @override
  String chatFlameTipSeconds(Object seconds) {
    return 'Messages are destroyed ${seconds}s after being read';
  }

  @override
  String chatFlameLabelMinutes(Object minutes) {
    return '$minutes min';
  }

  @override
  String chatFlameLabelSeconds(Object seconds) {
    return '${seconds}s';
  }

  @override
  String get chatSettingsGroupNickname => 'My Group Nickname';

  @override
  String get chatSettingsBlacklisted => 'Blacklisted';

  @override
  String get chatSettingsPeerBlacklisted =>
      'This contact is already blacklisted';

  @override
  String get chatSettingsComplaint => 'Report';

  @override
  String get chatSettingsDeleteAndExit => 'Delete and Exit';

  @override
  String groupRemarkSyncFailed(Object error) {
    return 'Failed to sync group remark: $error';
  }

  @override
  String get chatSocialDisconnected => 'Social service is not connected';

  @override
  String get chatNoRemovableMembers => 'No removable members';

  @override
  String get chatSelectMembersToRemove => 'Select Members to Remove';

  @override
  String chatMemberNameQuoted(Object name) {
    return '\"$name\"';
  }

  @override
  String chatMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersConfirm(Object names) {
    return 'Remove $names from the group';
  }

  @override
  String chatMembersRemoved(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Removed $count members',
      one: 'Removed 1 member',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersFailed(Object error) {
    return 'Failed to remove members: $error';
  }

  @override
  String get chatNoInviteCandidates => 'No contacts available to invite';

  @override
  String get chatInviteMembers => 'Invite Members';

  @override
  String get chatSelectContacts => 'Select Contacts';

  @override
  String chatMembersInvited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Invited $count members',
      one: 'Invited 1 member',
    );
    return '$_temp0';
  }

  @override
  String chatInviteMembersFailed(Object error) {
    return 'Failed to invite members: $error';
  }

  @override
  String get chatGroupCreated => 'Group chat created. Check the chat list.';

  @override
  String get chatGroupCreateFailed => 'Failed to create group chat';

  @override
  String chatGroupCreateFailedWithError(Object error) {
    return 'Failed to create group chat: $error';
  }

  @override
  String get chatClearCurrentConfirm => 'Clear the current chat history?';

  @override
  String get chatDeleteAndExitConfirm =>
      'After deleting and exiting, you will no longer receive messages from this group.';

  @override
  String get chatBlockConfirm =>
      'After adding this contact to the blacklist, you will no longer receive their messages.';

  @override
  String get chatSearchTabAll => 'Chats';

  @override
  String get chatSearchTabMedia => 'Photos/Videos';

  @override
  String get chatSearchTabFile => 'Files';

  @override
  String get chatSearchNoMatches => 'No matching chat history';

  @override
  String get chatSearchNoMore => 'No more results';

  @override
  String get chatDetailsTooltip => 'Chat Details';

  @override
  String get chatVoiceInputTooltip => 'Voice Input';

  @override
  String get chatInputHint => 'Message...';

  @override
  String get chatFlameEnabledTooltip => 'Burn after reading is on';

  @override
  String get chatFlameDestroyOnExit => 'Destroy after leaving chat';

  @override
  String chatFlameDestroyAfterMinutes(Object minutes) {
    return 'Destroy after $minutes min';
  }

  @override
  String chatFlameDestroyAfterSeconds(Object seconds) {
    return 'Destroy after ${seconds}s';
  }

  @override
  String chatFlameEnabledNotice(Object label) {
    return 'Burn after reading is on. Messages will be destroyed $label after reading. Use the top-right settings to turn it off.';
  }

  @override
  String get chatEmojiTooltip => 'Emoji';

  @override
  String get chatActionReply => 'Reply';

  @override
  String get chatActionCopy => 'Copy';

  @override
  String get chatActionTranslate => 'Translate';

  @override
  String get chatActionTranscribe => 'Transcribe';

  @override
  String get chatActionForward => 'Forward';

  @override
  String get chatActionFavorite => 'Favorite';

  @override
  String get chatActionPin => 'Pin';

  @override
  String get chatActionUnpin => 'Unpin';

  @override
  String get chatActionAddFriend => 'Add Friend';

  @override
  String get chatActionMultiSelect => 'Select';

  @override
  String get chatActionEdit => 'Edit';

  @override
  String get chatActionEditImage => 'Edit Image';

  @override
  String get chatActionRevoke => 'Recall';

  @override
  String get chatActionDelete => 'Delete';

  @override
  String get chatGroupCallActive => 'Group call in progress';

  @override
  String chatMessageRevokedBy(Object name) {
    return '$name recalled a message';
  }

  @override
  String get chatReedit => 'Re-edit';

  @override
  String get chatEditedSuffix => ' (edited)';

  @override
  String chatActionReadBy(Object count) {
    return 'Read by $count';
  }

  @override
  String chatActionReactedBy(Object count) {
    return '$count reactions';
  }

  @override
  String chatSelectedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Selected $count items',
      one: 'Selected 1 item',
    );
    return '$_temp0';
  }

  @override
  String get chatNoReactions => 'No reactions yet';

  @override
  String chatReadStatusReadCount(Object count) {
    return 'Read ($count)';
  }

  @override
  String get chatNoReadReceipts => 'None yet';

  @override
  String get chatHistoryAbove => 'Earlier messages above';

  @override
  String chatUnreadNewMessages(Object count) {
    return '$count new messages';
  }

  @override
  String get chatUnreadDivider => 'New messages below';

  @override
  String get chatUnknownContentFallback =>
      'This version cannot display this message. Update to the latest version.';

  @override
  String get chatMentionSomeone => 'Someone mentioned you';

  @override
  String get chatToolAlbum => 'Album';

  @override
  String get chatToolCamera => 'Camera';

  @override
  String get chatToolFile => 'File';

  @override
  String get chatToolLocation => 'Location';

  @override
  String get chatToolContactCard => 'Contact Card';

  @override
  String get chatToolAudioCall => 'Voice Call';

  @override
  String get chatToolVideoCall => 'Video Call';

  @override
  String get chatDraftLabel => '[Draft]';

  @override
  String get visitorBadge => 'Visitor';

  @override
  String get chatNoticeDeleted => 'Deleted';

  @override
  String get chatNoticeCopied => 'Copied';

  @override
  String get chatMentionLoadedOrInvisible =>
      'The @ message is loaded or not visible. Scroll up to find it.';

  @override
  String get chatLocationDefaultTitle => 'Location';

  @override
  String get chatLocationCopied => 'Location copied';

  @override
  String get chatReadStatusTitle => 'Read Status';

  @override
  String get chatReadStatusRead => 'Read';

  @override
  String get chatReadStatusUnread => 'Unread';

  @override
  String get chatReadStatusUnavailable =>
      'Full read/unread lists are not available yet';

  @override
  String get chatComposerLeft => 'You left this chat';

  @override
  String get chatComposerMuted => 'This chat is muted';

  @override
  String chatComposerMutedUntil(Object time) {
    return 'You are muted until $time';
  }

  @override
  String chatFavoriteCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Favorited $count messages',
      one: 'Favorited 1 message',
    );
    return '$_temp0';
  }

  @override
  String chatFavoritePartial(Object failed, Object success) {
    return 'Favorites complete: $success succeeded, $failed failed';
  }

  @override
  String get chatForwardUnavailable => 'Cannot forward right now';

  @override
  String chatMergedForwardedTo(Object count, Object name) {
    return 'Merged $count messages to $name';
  }

  @override
  String chatForwardedIndividuallyTo(Object count, Object name) {
    return 'Forwarded $count messages one by one to $name';
  }

  @override
  String chatForwardedPartialTo(Object name, Object sent, Object total) {
    return 'Forwarded $sent/$total messages to $name';
  }

  @override
  String get chatForwardModeIndividual => 'Forward One by One';

  @override
  String get chatForwardModeMerge => 'Merge and Forward';

  @override
  String get chatPresenceOnline => 'Online';

  @override
  String get chatPresenceOffline => 'Offline';

  @override
  String get chatPresenceJustActive => 'Active just now';

  @override
  String chatPresenceMinutesAgo(Object minutes) {
    return 'Active $minutes min ago';
  }

  @override
  String chatPresenceHoursAgo(Object hours) {
    return 'Active $hours hr ago';
  }

  @override
  String chatPresenceDaysAgo(Object days) {
    return 'Active $days days ago';
  }

  @override
  String get chatSensitiveDefaultTip =>
      'This message may contain sensitive information';

  @override
  String get chatMessageDigestFallback => '[Message]';

  @override
  String get chatMediaServiceUnavailable => 'Media service is not ready';

  @override
  String get chatImDisconnected => 'IM is not connected';

  @override
  String get chatPinFailedNotSent =>
      'Cannot pin before the message reaches the server';

  @override
  String get chatPinFailed => 'Failed to pin. Try again.';

  @override
  String get chatPinned => 'Pinned';

  @override
  String get chatUnpinFailed => 'Failed to unpin. Try again.';

  @override
  String get chatUnpinned => 'Unpinned';

  @override
  String get chatClearPinnedConfirm => 'Unpin all pinned messages?';

  @override
  String get chatClearPinnedAction => 'Unpin';

  @override
  String get chatAllUnpinned => 'All pinned messages unpinned';

  @override
  String get chatPinnedMessageNotVisible =>
      'This message is not in the visible range. View it from the list.';

  @override
  String get chatImageMissing => 'Image information is missing';

  @override
  String get chatImageDownloadFailedEdit =>
      'Failed to download image. Cannot edit.';

  @override
  String get chatReactionFailed => 'Reaction failed. Try again.';

  @override
  String get chatEditNotSynced => 'Edit failed: message is not synced';

  @override
  String get chatEditFailed => 'Edit failed. Try again.';

  @override
  String get chatFavoriteUnsupportedType => 'This type cannot be favorited yet';

  @override
  String get chatFavoriteNotSent =>
      'Message has not reached the server, so it cannot be favorited';

  @override
  String get chatFavoriteSuccess => 'Added to favorites';

  @override
  String get chatFavoriteFailed => 'Failed to favorite. Try again.';

  @override
  String chatToolSelected(Object title) {
    return 'Selected $title';
  }

  @override
  String chatCardDigest(Object name) {
    return '[Card] $name';
  }

  @override
  String get chatFriendAvatarFallback => 'F';

  @override
  String get chatUnknownMessageDigest => '[Unknown]';

  @override
  String chatOpenFromContacts(Object name) {
    return 'Open @$name\'s chat from Contacts';
  }

  @override
  String get chatLoadingCard => 'Loading contact card...';

  @override
  String get chatFileMissing => 'File information is missing';

  @override
  String get chatVideoUnavailable => 'Video cannot be played';

  @override
  String get chatVideoSourceEmpty => 'Video source is empty';

  @override
  String get chatLivePhotoUnavailable => 'Live Photo cannot be played';

  @override
  String get messageAiTranslating => 'Translating...';

  @override
  String get messageAiTranscribedShort => 'Done';

  @override
  String get messageAiVoiceSendingWait =>
      'Voice is still sending. Try again later.';

  @override
  String get messageAiNoTranscript => 'No speech recognized';

  @override
  String get messageAiMessageSendingWait =>
      'Message is still sending. Try again later.';

  @override
  String get messageAiNoTranslation => 'No translation result';

  @override
  String get messageAiTemporarilyUnavailable => 'Temporarily unavailable';

  @override
  String get chatVoiceFileUnavailable => 'Voice file is unavailable';

  @override
  String get chatVoicePlayFailed => 'Playback failed. Try again.';

  @override
  String get chatVoiceHoldToRecord => 'Hold to record · Slide up to cancel';

  @override
  String chatVoiceReleaseToCancel(Object duration) {
    return 'Release to cancel ($duration)';
  }

  @override
  String chatVoiceRecordingSlideCancel(Object duration) {
    return '$duration · Slide up to cancel';
  }

  @override
  String get chatQrcodeNotFound => 'No QR code recognized';

  @override
  String chatWebLoginQrcodeDetected(Object payload) {
    return 'Web login QR code recognized\n$payload';
  }

  @override
  String get chatWebLoginConfirmTitle => 'Confirm login on web?';

  @override
  String get chatWebLoginConfirmAction => 'Confirm Web Login';

  @override
  String get chatWebLoginConfirmed => 'Web login confirmed';

  @override
  String chatQrcodeDetected(Object payload) {
    return 'QR code recognized\n$payload';
  }

  @override
  String get chatStickerPlaceholder => '[Sticker]';

  @override
  String get chatStickerAdded => 'Added to stickers';

  @override
  String get chatStickerAddFailed => 'Failed to add sticker. Try again.';

  @override
  String get mentionAllMembers => 'All Members';

  @override
  String get mentionAllMembersSubtitle => 'Notify everyone in this group';

  @override
  String get chatQuoteOriginalRevoked => 'Original message was recalled';

  @override
  String get chatRecognizeImageQrcode => 'Scan QR Code in Image';

  @override
  String get chatAddToStickers => 'Add to Stickers';

  @override
  String get chatGroupInviteApprovalUrlEmpty =>
      'Group invite approval URL is empty';

  @override
  String get chatGroupInviteApprovalTitle => 'Group Invite Approval';

  @override
  String get chatGroupInviteApprovalBody =>
      'Complete the group invite confirmation on the web page.';

  @override
  String get chatGroupInviteGoConfirm => 'Confirm';

  @override
  String get chatGroupInviteApprovalOpenFailed =>
      'Failed to open group invite approval. Try again.';

  @override
  String get chatSendFailed => 'Failed to send. Try again.';

  @override
  String get chatCallActiveHangupFirst => 'A call is active. Hang up first.';

  @override
  String get chatCallActiveCannotJoinAgain =>
      'A call is active. Cannot join again.';

  @override
  String get chatCallUnsupported => 'Calls are not supported in this version';

  @override
  String get chatCallServiceUnavailable => 'Call service is not ready';

  @override
  String get chatCallJoinFailedEnded =>
      'Failed to join. The call may have ended.';

  @override
  String get callWaitingAnswer => 'Waiting for answer';

  @override
  String get callMessage => 'Call message';

  @override
  String get callEnded => 'Call ended';

  @override
  String get callPeerRefused => 'Peer declined';

  @override
  String get callPeerHungUp => 'Peer hung up';

  @override
  String get callPeerDeclinedVideoSwitch =>
      'Peer declined the video switch request';

  @override
  String get callSwitchVideoRequestTitle => 'Peer requests switching to video';

  @override
  String get callAgree => 'Agree';

  @override
  String get callReconnecting => 'Reconnecting…';

  @override
  String get callWaitingPeerCamera => 'Waiting for peer camera';

  @override
  String get callSelfFallbackName => 'Me';

  @override
  String get callUnknownUser => 'Unknown user';

  @override
  String callJoinedCount(int joined, int total) {
    return '$joined/$total joined';
  }

  @override
  String get callMute => 'Mute';

  @override
  String get callSpeaker => 'Speaker';

  @override
  String get callSwitchToVideo => 'Video';

  @override
  String get callHangup => 'Hang Up';

  @override
  String get callFlipCamera => 'Flip';

  @override
  String get callSwitchToVoice => 'Audio';

  @override
  String get callCamera => 'Camera';

  @override
  String get callBack => 'Back';

  @override
  String get callPermissionMicrophone => 'microphone';

  @override
  String get callPermissionMicrophoneCamera => 'microphone and camera';

  @override
  String callPermissionOpenSettings(String what) {
    return 'Enable $what permission in system settings';
  }

  @override
  String callPermissionRequired(String what) {
    return 'Calls need $what permission';
  }

  @override
  String get callWaitingPeerConsent => 'Waiting for peer approval';

  @override
  String get callSwitchRequestFailed => 'Failed to send switch request';

  @override
  String get callCameraPermissionRequired => 'Camera permission required';

  @override
  String get callCameraEnableFailed => 'Failed to turn on camera';

  @override
  String get incomingCallAccepting => 'Answering...';

  @override
  String get incomingVideoCall => 'invites you to a video call';

  @override
  String get incomingAudioCall => 'invites you to a voice call';

  @override
  String incomingAcceptFailed(String error) {
    return 'Answer failed: $error';
  }

  @override
  String get incomingCallDecline => 'Decline';

  @override
  String get incomingCallAccept => 'Answer';

  @override
  String get chatGroupNoInviteCandidates => 'No members available to invite';

  @override
  String get chatInviteGroupMembersVideo => 'Invite Group Members (Video Call)';

  @override
  String get chatInviteGroupMembersAudio => 'Invite Group Members (Voice Call)';

  @override
  String get chatSelfName => 'Me';

  @override
  String get chatPeerPlaceholder => 'Other';

  @override
  String get chatSomeonePlaceholder => 'Someone';

  @override
  String chatScreenshotNotice(Object name) {
    return '$name took a screenshot in chat';
  }

  @override
  String chatDuplicateGroupMention(Object name) {
    return 'Multiple group members match @$name';
  }

  @override
  String chatDuplicateContactMention(Object name) {
    return 'Multiple contacts match @$name';
  }

  @override
  String chatMentionNotFound(Object name) {
    return '@$name not found';
  }

  @override
  String get chatForwardPickerTitle => 'Forward To';

  @override
  String get chatRecentContactsSection => 'Recent Contacts';

  @override
  String chatForwardedTo(Object name) {
    return 'Forwarded to $name';
  }

  @override
  String get favoriteTitle => 'Favorites';

  @override
  String get favoriteEmptyTitle => 'No favorites';

  @override
  String get favoriteEmptySubtitle =>
      'Long-press a message in chat and choose Favorite to save it here.';

  @override
  String get favoriteDeleted => 'Deleted';

  @override
  String favoriteDeleteFailed(Object error) {
    return 'Delete failed: $error';
  }

  @override
  String get favoriteDeleteFailedPlain => 'Delete failed';

  @override
  String get favoriteUnsupportedSend => 'This type cannot be sent yet';

  @override
  String favoriteSentTo(String name) {
    return 'Sent to $name';
  }

  @override
  String favoriteSendFailed(Object error) {
    return 'Send failed: $error';
  }

  @override
  String get favoriteSendFailedPlain => 'Send failed';

  @override
  String get favoriteSendToFriend => 'Send to Friend';

  @override
  String get favoriteCopied => 'Copied';

  @override
  String get favoriteUnknownUser => 'Unknown user';

  @override
  String favoriteDateMonthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String get groupSavedTitle => 'Saved Groups';

  @override
  String get groupSaveTooltip => 'Save Group';

  @override
  String get groupSearchHint => 'Search groups';

  @override
  String get groupNoMatched => 'No matching groups';

  @override
  String get groupNoSaveCandidatesToast => 'No groups available to save';

  @override
  String get groupSavedToContacts => 'Saved to contacts';

  @override
  String groupSaveFailed(Object error) {
    return 'Failed to save: $error';
  }

  @override
  String get groupSelectTitle => 'Select Group';

  @override
  String get groupNoSaveCandidates => 'No groups available to save';

  @override
  String get groupCreateTitle => 'Start Group Chat';

  @override
  String get groupSearchContactsHint => 'Search contacts';

  @override
  String get groupNoMatchedContacts => 'No matching contacts';

  @override
  String groupMemberSummary(num count, Object subtitle) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0 · $subtitle';
  }

  @override
  String get groupMuted => 'Muted';

  @override
  String get groupDetailsTitle => 'Group Details';

  @override
  String groupMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get groupMembersSection => 'Group Members';

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
  String get groupNoMembers => 'No group members';

  @override
  String get groupInviteMembers => 'Invite Members';

  @override
  String get groupInviteMembersSubtitle => 'Choose from contacts';

  @override
  String get groupRemoveMembers => 'Remove Members';

  @override
  String get groupRemoveMembersEmptySubtitle => 'No members to remove';

  @override
  String get groupRemoveMembersSubtitle => 'Choose members to remove';

  @override
  String get groupQrCodeTitle => 'Group QR Code';

  @override
  String get groupQrCodeSubtitle => 'Scan to join this group';

  @override
  String get groupNameTitle => 'Group Name';

  @override
  String get groupNoticeTitle => 'Group Announcement';

  @override
  String get groupNoticeUnset => 'Not set';

  @override
  String get groupManageTitle => 'Group Management';

  @override
  String get groupManageSubtitle => 'Admins, mute, and group permissions';

  @override
  String get groupInviteConfirm => 'Invite Confirmation';

  @override
  String get groupBlacklistTitle => 'Group Blacklist';

  @override
  String get groupBlacklistSubtitle =>
      'Manage members blocked from speaking or joining';

  @override
  String get groupSaveToContacts => 'Save to Contacts';

  @override
  String get groupMuteMessages => 'Mute Notifications';

  @override
  String get groupExited => 'Left group chat';

  @override
  String get groupExitAction => 'Leave Group';

  @override
  String groupMembersSyncFailed(Object error) {
    return 'Failed to sync group members: $error';
  }

  @override
  String get groupInvitePickerTitle => 'Choose Members to Invite';

  @override
  String groupInviteSentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sent $count member invitations',
      one: 'Sent 1 member invitation',
    );
    return '$_temp0';
  }

  @override
  String groupInvitedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Invited $count members',
      one: 'Invited 1 member',
    );
    return '$_temp0';
  }

  @override
  String groupInviteMembersFailed(Object error) {
    return 'Failed to invite members: $error';
  }

  @override
  String get groupRemovePickerTitle => 'Choose Members to Remove';

  @override
  String groupQuotedMemberName(Object name) {
    return '\"$name\"';
  }

  @override
  String groupSelectedMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersConfirm(Object target) {
    return 'Remove $target from this group?';
  }

  @override
  String get groupRemoveAction => 'Remove';

  @override
  String groupRemovedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Removed $count members',
      one: 'Removed 1 member',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersFailed(Object error) {
    return 'Failed to remove members: $error';
  }

  @override
  String get groupSettingsUpdated => 'Group settings updated';

  @override
  String groupSettingsUpdateFailed(Object error) {
    return 'Failed to update group settings: $error';
  }

  @override
  String get groupExitConfirm =>
      'You will no longer receive messages from this group after leaving.';

  @override
  String get groupExitSuccess => 'Left group chat';

  @override
  String groupExitFailed(Object error) {
    return 'Failed to leave: $error';
  }

  @override
  String get groupOwnerAdminSection => 'Owner & Admins';

  @override
  String get groupOwnerRole => 'Owner';

  @override
  String get groupAdminRole => 'Admin';

  @override
  String get groupRemove => 'Remove';

  @override
  String get groupAddAdmin => 'Add Group Admin';

  @override
  String get groupNoAdmins => 'No admins';

  @override
  String get groupInviteConfirmRemark =>
      'When enabled, members need owner or admin approval before inviting friends. Joining by QR code will also be disabled.';

  @override
  String get groupOwnerTransfer => 'Transfer Ownership';

  @override
  String get groupMemberSettingsSection => 'Member Settings';

  @override
  String get groupAllMutedRemark =>
      'When all-member mute is enabled, only the owner and admins can speak.';

  @override
  String get groupAllMuted => 'Mute All Members';

  @override
  String get groupForbiddenAddFriendRemark =>
      'When enabled, members cannot add friends through this group.';

  @override
  String get groupForbiddenAddFriend => 'Block Members from Adding Friends';

  @override
  String get groupAllowHistoryRemark =>
      'When enabled, new members can see previous chat history.';

  @override
  String get groupAllowHistory => 'Allow New Members to View History';

  @override
  String get groupAddAdminPickerTitle => 'Add Group Admin';

  @override
  String groupAdminAddedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Added $count admins',
      one: 'Added 1 admin',
    );
    return '$_temp0';
  }

  @override
  String groupAddAdminFailed(Object error) {
    return 'Failed to add admin: $error';
  }

  @override
  String groupRemoveAdminConfirm(Object name) {
    return 'Remove admin role from \"$name\"?';
  }

  @override
  String get groupRemoveAdminAction => 'Remove Admin';

  @override
  String get groupRemoveAdminSuccess => 'Admin removed';

  @override
  String groupRemoveAdminFailed(Object error) {
    return 'Failed to remove admin: $error';
  }

  @override
  String get groupSelectNewOwner => 'Select New Owner';

  @override
  String groupTransferOwnerConfirm(Object name) {
    return 'Transfer ownership to \"$name\"? You will become a regular member.';
  }

  @override
  String get groupTransferOwnerAction => 'Confirm Transfer';

  @override
  String get groupOwnerTransferred => 'Ownership transferred';

  @override
  String groupOwnerTransferFailed(Object error) {
    return 'Failed to transfer ownership: $error';
  }

  @override
  String get groupNoticePublisherDefault => 'Group Announcement';

  @override
  String get groupNoticePublishTitle => 'Post Group Announcement';

  @override
  String get groupNoticeEditTitle => 'Edit Group Announcement';

  @override
  String get groupNoticePublishAction => 'Post';

  @override
  String get groupNoticeEmpty => 'No group announcement';

  @override
  String get groupNoticePublishedAtUnknown => 'Publish time unknown';

  @override
  String get groupMemberRemarkTitle => 'My Nickname in This Group';

  @override
  String get groupMemberRemarkHint => 'Set your nickname in this group';

  @override
  String get groupQrCodeEmpty => 'No group QR code';

  @override
  String groupQrCodeValid(Object day, Object expire) {
    return 'This QR code is valid for $day days ($expire)';
  }

  @override
  String get groupQrCodeScanToJoin => 'Scan the QR code to join this group';

  @override
  String get groupBlacklistLoadFailed => 'Failed to load blacklist. Try again.';

  @override
  String get groupBlacklistEmpty => 'No blacklisted members';

  @override
  String get groupBlacklistAddMember => 'Add Blacklist Member';

  @override
  String get groupBlacklistNoCandidates =>
      'No members can be added to the blacklist';

  @override
  String get groupSelectMember => 'Select Member';

  @override
  String get groupBlacklistAdded => 'Added to blacklist';

  @override
  String get groupBlacklistAddFailed =>
      'Failed to add to blacklist. Try again.';

  @override
  String groupBlacklistRemoveConfirm(Object name) {
    return 'Remove \"$name\" from the group blacklist?';
  }

  @override
  String get groupBlacklistRemoveAction => 'Remove from Blacklist';

  @override
  String get groupBlacklistRemoveFailed =>
      'Failed to remove from blacklist. Try again.';

  @override
  String get groupAvatarTitle => 'Group Avatar';

  @override
  String get groupAvatarTakePhoto => 'Take Photo';

  @override
  String get groupAvatarChooseFromAlbum => 'Choose from Album';

  @override
  String get groupAvatarSaveImage => 'Save Image';

  @override
  String get groupAvatarUnsupported =>
      'This chat does not support changing the group avatar';

  @override
  String get groupAvatarUpdated => 'Group avatar updated';

  @override
  String get groupAvatarUpdateFailed =>
      'Failed to update group avatar. Try again.';

  @override
  String get groupAvatarNoImageToSave => 'No avatar to save';

  @override
  String groupPhotoPermissionRequired(Object appName) {
    return 'Allow $appName to access your photos';
  }

  @override
  String get groupImageSavedToAlbum => 'Saved to album';

  @override
  String get groupImageSaveFailed => 'Failed to save. Try again.';

  @override
  String get imageEditorProcessing => 'Processing...';

  @override
  String get imageEditorDiscardTitle => 'Discard edits?';

  @override
  String get imageEditorDiscardMessage => 'Unsaved edits will be lost.';

  @override
  String get imageEditorDiscardConfirm => 'Discard';

  @override
  String get imageEditorPaint => 'Draw';

  @override
  String get imageEditorFreestyle => 'Freehand';

  @override
  String get imageEditorArrow => 'Arrow';

  @override
  String get imageEditorLine => 'Line';

  @override
  String get imageEditorRectangle => 'Rectangle';

  @override
  String get imageEditorCircle => 'Circle';

  @override
  String get imageEditorDashLine => 'Dashed line';

  @override
  String get imageEditorMoveAndZoom => 'Move / Zoom';

  @override
  String get imageEditorEraser => 'Eraser';

  @override
  String get imageEditorLineWidth => 'Width';

  @override
  String get imageEditorToggleFill => 'Fill';

  @override
  String get imageEditorOpacity => 'Opacity';

  @override
  String get imageEditorUndo => 'Undo';

  @override
  String get imageEditorRedo => 'Redo';

  @override
  String get imageEditorInputHint => 'Enter text';

  @override
  String get imageEditorText => 'Text';

  @override
  String get imageEditorTextAlign => 'Align';

  @override
  String get imageEditorBackground => 'Background';

  @override
  String get imageEditorFontScale => 'Font size';

  @override
  String get imageEditorCrop => 'Crop';

  @override
  String get imageEditorRotate => 'Rotate';

  @override
  String get imageEditorRatio => 'Ratio';

  @override
  String get imageEditorReset => 'Reset';

  @override
  String get imageEditorFlip => 'Flip';

  @override
  String get imageEditorFilter => 'Filters';

  @override
  String get imageEditorFilterNone => 'Original';

  @override
  String get imageEditorFilterAddictiveBlue => 'Addictive Blue';

  @override
  String get imageEditorFilterAddictiveRed => 'Addictive Red';

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
  String get imageEditorFilterCharmes => 'Charmes';

  @override
  String get imageEditorFilterClarendon => 'Clarendon';

  @override
  String get imageEditorFilterCrema => 'Crema';

  @override
  String get imageEditorFilterDogpatch => 'Dogpatch';

  @override
  String get imageEditorFilterEarlybird => 'Earlybird';

  @override
  String get imageEditorFilterGingham => 'Gingham';

  @override
  String get imageEditorFilterGinza => 'Ginza';

  @override
  String get imageEditorFilterHefe => 'Hefe';

  @override
  String get imageEditorFilterHelena => 'Helena';

  @override
  String get imageEditorFilterHudson => 'Hudson';

  @override
  String get imageEditorFilterInkwell => 'Inkwell';

  @override
  String get imageEditorFilterJuno => 'Juno';

  @override
  String get imageEditorFilterKelvin => 'Kelvin';

  @override
  String get imageEditorFilterLark => 'Lark';

  @override
  String get imageEditorFilterLoFi => 'Lo-Fi';

  @override
  String get imageEditorFilterLudwig => 'Ludwig';

  @override
  String get imageEditorFilterMaven => 'Maven';

  @override
  String get imageEditorFilterMayfair => 'Mayfair';

  @override
  String get imageEditorFilterMoon => 'Moon';

  @override
  String get imageEditorFilterNashville => 'Nashville';

  @override
  String get imageEditorFilterPerpetua => 'Perpetua';

  @override
  String get imageEditorFilterReyes => 'Reyes';

  @override
  String get imageEditorFilterRise => 'Rise';

  @override
  String get imageEditorFilterSierra => 'Sierra';

  @override
  String get imageEditorFilterSkyline => 'Skyline';

  @override
  String get imageEditorFilterSlumber => 'Slumber';

  @override
  String get imageEditorFilterStinson => 'Stinson';

  @override
  String get imageEditorFilterSutro => 'Sutro';

  @override
  String get imageEditorFilterToaster => 'Toaster';

  @override
  String get imageEditorFilterValencia => 'Valencia';

  @override
  String get imageEditorFilterVesper => 'Vesper';

  @override
  String get imageEditorFilterWalden => 'Walden';

  @override
  String get imageEditorFilterWillow => 'Willow';

  @override
  String get imageEditorBlur => 'Blur';

  @override
  String get imageEditorTune => 'Adjust';

  @override
  String get imageEditorBrightness => 'Brightness';

  @override
  String get imageEditorContrast => 'Contrast';

  @override
  String get imageEditorSaturation => 'Saturation';

  @override
  String get imageEditorExposure => 'Exposure';

  @override
  String get imageEditorHue => 'Hue';

  @override
  String get imageEditorTemperature => 'Temperature';

  @override
  String get imageEditorSharpness => 'Sharpness';

  @override
  String get imageEditorFade => 'Fade';

  @override
  String get imageEditorLuminance => 'Luminance';

  @override
  String get imageEditorEmoji => 'Emoji';

  @override
  String get imageEditorEmojiRecent => 'Recent';

  @override
  String get imageEditorEmojiSmileys => 'Smileys';

  @override
  String get imageEditorEmojiAnimals => 'Animals';

  @override
  String get imageEditorEmojiFood => 'Food';

  @override
  String get imageEditorEmojiActivities => 'Activities';

  @override
  String get imageEditorEmojiTravel => 'Travel';

  @override
  String get imageEditorEmojiObjects => 'Objects';

  @override
  String get imageEditorEmojiSymbols => 'Symbols';

  @override
  String get imageEditorEmojiFlags => 'Flags';

  @override
  String get imageEditorSticker => 'Stickers';

  @override
  String get imageEditorRemove => 'Remove';

  @override
  String get imageEditorSaving => 'Saving...';

  @override
  String get imageEditorImporting => 'Importing';

  @override
  String get imagePreviewTitle => 'Image Preview';

  @override
  String get imagePreviewSavingToAlbum => 'Saving...';

  @override
  String get imagePreviewAddToSticker => 'Add to Stickers';

  @override
  String get imagePreviewAddingToSticker => 'Adding...';

  @override
  String get imagePreviewRecognizeQr => 'Recognize QR Code';

  @override
  String get imagePreviewRecognizingQr => 'Recognizing...';

  @override
  String get imagePreviewConfirmWebLogin => 'Confirm Web Login';

  @override
  String get imagePreviewConfirmingWebLogin => 'Confirming...';

  @override
  String get imagePreviewOpenLink => 'Open Link';

  @override
  String get imagePreviewImageNotDownloadedSave =>
      'Image is not downloaded yet';

  @override
  String get imagePreviewMediaUnavailable => 'Media service is unavailable';

  @override
  String get imagePreviewImageNotUploadedSticker => 'Image is not uploaded yet';

  @override
  String get imagePreviewStickerUnavailable => 'Sticker service is unavailable';

  @override
  String get imagePreviewAddedToSticker => 'Added to stickers';

  @override
  String get imagePreviewImageNotDownloadedRecognize =>
      'Image is not downloaded yet';

  @override
  String get imagePreviewQrNotFound => 'No QR code found';

  @override
  String get imagePreviewWebLoginQrRecognized => 'Web login QR code recognized';

  @override
  String get imagePreviewWebLinkRecognized => 'Web link recognized';

  @override
  String get imagePreviewQrRecognized => 'QR code recognized';

  @override
  String get imagePreviewWebLoginConfirmed => 'Web login confirmed';

  @override
  String get pickerFileTitle => 'Choose File';

  @override
  String get pickerRecentFiles => 'Recent Files';

  @override
  String get pickerSampleProjectFile => 'Project Notes.pdf';

  @override
  String get pickerSampleProjectFileSubtitle => '128 KB · Today';

  @override
  String get pickerSampleScreenshotFile => 'Chat Screenshot.png';

  @override
  String get pickerSampleScreenshotFileSubtitle => '2.4 MB · Yesterday';

  @override
  String get pickerContactTitle => 'Choose Contact';

  @override
  String get pickerContactCardSection => 'Send Contact Card';

  @override
  String get pickerSearchContacts => 'Search Contacts';

  @override
  String get pickerNoMatchingContacts => 'No matching contacts';

  @override
  String get chatSendFailedShort => 'Send Failed';

  @override
  String get chatResend => 'Resend';

  @override
  String get chatStatusRead => 'Read';

  @override
  String get pinnedMessageTitle => 'Pinned Message';

  @override
  String pinnedMessageTitleWithIndex(int index, int total) {
    return 'Pinned Message $index/$total';
  }

  @override
  String get pinnedMessageOpen => 'Tap to View';

  @override
  String get pinnedMessageViewAllTooltip => 'View All Pinned';

  @override
  String get pinnedMessageUnpinTooltip => 'Unpin';

  @override
  String pinnedMessageListCount(int count) {
    return '$count Pinned Messages';
  }

  @override
  String get pinnedMessageClearAll => 'Unpin All';

  @override
  String get pinnedMessageFallback => 'Pinned Message';

  @override
  String get fileUnnamed => 'Untitled File';

  @override
  String get fileNoDownloadUrl => 'No download link available';

  @override
  String get fileTitle => 'File';

  @override
  String fileSizeLabel(String size) {
    return 'File size: $size';
  }

  @override
  String get fileDownloadFailed => 'Download Failed';

  @override
  String get filePreview => 'Preview';

  @override
  String get fileOpenWithOtherApp => 'Open in Other App';

  @override
  String get actionEnable => 'Enable';

  @override
  String get actionDisable => 'Disable';

  @override
  String get profileInviteLoading => 'Loading invite code';

  @override
  String get profileInviteEnabled => 'Invite code enabled';

  @override
  String get profileInviteDisabled => 'Invite code disabled';

  @override
  String profileInviteLoadFailed(String error) {
    return 'Failed to load invite code: $error';
  }

  @override
  String get profileInviteCopied => 'Copied';

  @override
  String profileInviteUpdateFailed(String error) {
    return 'Failed to update invite code: $error';
  }

  @override
  String get stickerStoreTitle => 'Sticker Store';

  @override
  String get stickerNoPacks => 'No sticker packs';

  @override
  String get stickerDetailTitle => 'Sticker Details';

  @override
  String get stickerProcessing => 'Processing...';

  @override
  String get stickerAddCustomTitle => 'Add Custom Sticker';

  @override
  String get stickerSortTitle => 'Sort Stickers';

  @override
  String get stickerMyStickersTitle => 'My Stickers';

  @override
  String get stickerSaving => 'Saving';

  @override
  String get stickerSortAction => 'Sort';

  @override
  String get stickerOrganize => 'Organize';

  @override
  String get stickerCustomTitle => 'Custom Stickers';

  @override
  String get stickerCustomSubtitle => 'Manage saved custom stickers';

  @override
  String get stickerNoSortablePacks => 'No sticker packs to sort';

  @override
  String get stickerNoCategories => 'No sticker categories';

  @override
  String get stickerMoveUp => 'Move Up';

  @override
  String get stickerMoveDown => 'Move Down';

  @override
  String get stickerNoCustomStickers => 'No custom stickers';

  @override
  String get stickerMoveToFront => 'Move to Front';

  @override
  String get stickerDeleteConfirmTitle =>
      'Deleted stickers cannot be recovered';

  @override
  String get complaintTitle => 'Report';

  @override
  String get complaintHint => 'Describe the issue';

  @override
  String get complaintType => 'Report Type';

  @override
  String get complaintSubmitted => 'Report submitted';

  @override
  String get complaintSubmit => 'Submit Report';

  @override
  String get complaintSubmitting => 'Submitting…';

  @override
  String get complaintFallbackOtherViolation => 'Other policy violation';

  @override
  String get complaintFallbackFraud => 'Other fraud or scam';

  @override
  String get complaintFallbackAccountCompromised =>
      'Account may be compromised';

  @override
  String get chatBackgroundTitle => 'Chat Background';

  @override
  String get chatBackgroundLoading => 'Loading chat backgrounds';

  @override
  String get chatBackgroundEmpty => 'No chat backgrounds';

  @override
  String get chatBackgroundDefault => 'Default Background';

  @override
  String chatBackgroundItem(int index) {
    return 'Background $index';
  }

  @override
  String get chatBackgroundPreviewTitle => 'Preview Background';

  @override
  String get chatBackgroundSet => 'Set Background';

  @override
  String get chatBackgroundSelectedStatus => 'Chat background set';

  @override
  String get chatBackgroundInUse => 'In Use';

  @override
  String get chatContactFallback => 'Contact';

  @override
  String get chatPersonalCard => 'Contact Card';

  @override
  String get chatSystemMessageDigest => '[System Message]';

  @override
  String get chatMessageDigestMessage => '[Message]';

  @override
  String get chatMessageDigestImage => '[Image]';

  @override
  String get chatMessageDigestVoice => '[Voice]';

  @override
  String get chatMessageDigestVideo => '[Video]';

  @override
  String get chatMessageDigestLocation => '[Location]';

  @override
  String get chatMessageDigestCard => '[Contact Card]';

  @override
  String get chatMessageDigestFile => '[File]';

  @override
  String get chatMessageDigestHistory => '[Chat History]';

  @override
  String get chatMessageDigestSticker => '[Sticker]';

  @override
  String get dateWeekdayShortMonday => 'Mon';

  @override
  String get dateWeekdayShortTuesday => 'Tue';

  @override
  String get dateWeekdayShortWednesday => 'Wed';

  @override
  String get dateWeekdayShortThursday => 'Thu';

  @override
  String get dateWeekdayShortFriday => 'Fri';

  @override
  String get dateWeekdayShortSaturday => 'Sat';

  @override
  String get dateWeekdayShortSunday => 'Sun';

  @override
  String get appIconClassic => 'Classic';

  @override
  String get appIconSimple => 'Simple';

  @override
  String get appIconDark => 'Dark';

  @override
  String get appIconFestive => 'Festive';

  @override
  String get appIconGradient => 'Gradient';

  @override
  String get appIconUpdated => 'Icon updated';

  @override
  String get appIconUpdateFailed => 'Switch failed. Try again later.';

  @override
  String get appearanceBubbleColorPurple => 'Purple';

  @override
  String get appearanceBubbleColorGreen => 'Green';

  @override
  String get appearanceBubbleColorBlue => 'Blue';

  @override
  String get appearanceBubbleColorOrange => 'Orange';

  @override
  String get appearanceBubbleColorPink => 'Pink';

  @override
  String replyPreviewTitle(String name) {
    return 'Reply to $name';
  }

  @override
  String get replyPreviewCancel => 'Cancel Reply';

  @override
  String get chatPasswordTitle => 'Chat Password';

  @override
  String get chatPasswordHint => 'Enter a 6-digit password';

  @override
  String chatPasswordErrorRemain(int remain) {
    return 'Wrong password. Chat history will be cleared after $remain more failed attempts.';
  }

  @override
  String get emojiPackEmpty => 'No stickers in this pack';

  @override
  String get emojiRecentSection => 'Recent';

  @override
  String get emojiAllSection => 'All Emoji';

  @override
  String get stickerSearching => 'Searching...';

  @override
  String get stickerNoSearchResults => 'No results';

  @override
  String get stickerSearchResultsTitle => 'Results:';

  @override
  String get homeChatPasswordWiped =>
      'Too many wrong attempts. Chat history was deleted.';

  @override
  String get homeGroupNotFound => 'Group chat not found';

  @override
  String get homeConversationNoHistory => 'No chat history';

  @override
  String get homeConversationStartChat => 'Start Chat';

  @override
  String get homeEnterGroupChat => 'Enter Group Chat';

  @override
  String get homeNewGroup => 'New Group Chat';

  @override
  String homeFriendRequestAcceptFailed(String error) {
    return 'Failed to accept: $error';
  }

  @override
  String get homeFriendRequestAccepted => 'Friend request accepted';

  @override
  String homeFriendRequestRefuseFailed(String error) {
    return 'Failed to refuse: $error';
  }

  @override
  String homeFriendRequestDeleteFailed(String error) {
    return 'Failed to delete: $error';
  }

  @override
  String contactPresenceOnlineWithDevice(String device) {
    return 'Online on $device';
  }

  @override
  String contactPresenceJustOnlineWithDevice(String device) {
    return 'Online on $device just now';
  }

  @override
  String contactPresenceMinutesOnlineWithDevice(int minutes, String device) {
    return 'Online on $device $minutes min ago';
  }

  @override
  String contactPresenceLastOnline(String time) {
    return 'Last online $time';
  }

  @override
  String get contactPresenceDeviceWeb => 'web';

  @override
  String get contactPresenceDeviceDesktop => 'desktop';

  @override
  String get contactPresenceDeviceMobile => 'mobile';

  @override
  String get botCommandsEmpty => 'No commands yet';
}
