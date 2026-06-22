// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get tabMessages => 'Chats';

  @override
  String get tabContacts => 'Kontakte';

  @override
  String get tabDiscover => 'Entdecken';

  @override
  String get tabMe => 'Ich';

  @override
  String get pageMessagesTitle => 'Chats';

  @override
  String get pageContactsTitle => 'Kontakte';

  @override
  String get pageDiscoverTitle => 'Entdecken';

  @override
  String get pageMeTitle => 'Ich';

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionConfirm => 'Bestätigen';

  @override
  String get actionDone => 'Fertig';

  @override
  String get actionSave => 'Speichern';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get actionEdit => 'Bearbeiten';

  @override
  String get actionAdd => 'Hinzugefügt';

  @override
  String get actionRemove => 'Entfernen';

  @override
  String get actionInvite => 'Einladen';

  @override
  String get actionSearch => 'Suchen';

  @override
  String get actionSend => 'Senden';

  @override
  String get actionRetry => 'Wiederholen';

  @override
  String get actionBack => 'Zurück';

  @override
  String get actionMore => 'Mehr';

  @override
  String get actionJoin => 'Beitreten';

  @override
  String get actionSkip => 'Überspringen';

  @override
  String get actionContinue => 'Weiter';

  @override
  String get actionGetStarted => 'Erste Schritte';

  @override
  String get actionSaving => 'Speichern...';

  @override
  String get moduleUnsupported =>
      'Diese Funktion ist in dieser Version nicht verfügbar';

  @override
  String get moduleLoading =>
      'Funktionszugriff wird überprüft. Versuchen Sie es später noch einmal.';

  @override
  String get moduleOfflineStale =>
      'Stellen Sie eine Verbindung zum Netzwerk her, um den Funktionszugriff zu bestätigen';

  @override
  String get onboardingMenuTitle => 'Kurzanleitung';

  @override
  String onboardingChatTitle(Object appName) {
    return 'Willkommen bei $appName';
  }

  @override
  String get onboardingChatSubtitle =>
      'Ein sauberer, heller Ort für angenehmere Gespräche.';

  @override
  String get onboardingFriendsTitle =>
      'Machen Sie es einfach, in Kontakt zu bleiben';

  @override
  String get onboardingFriendsSubtitle =>
      'Freunde, Gruppen und Freigaben sind einfacher zu finden.';

  @override
  String get onboardingSecurityTitle =>
      'Sprechen Sie frei. Verwenden Sie es mit Zuversicht.';

  @override
  String get onboardingSecuritySubtitle =>
      'Kontosicherheit und Datenschutz schützen Ihre Grenzen.';

  @override
  String get onboardingChatSemantic =>
      'Abbildung zum Onboarding der Nachrichtensynchronisierung';

  @override
  String get onboardingFriendsSemantic =>
      'Illustration zum Onboarding von Freunden und Gruppen';

  @override
  String get onboardingSecuritySemantic =>
      'Illustration zum Onboarding von Sicherheit und Datenschutz';

  @override
  String get settingsLanguageRow => 'Sprache';

  @override
  String get settingsLanguageSystem => 'Systemstandard';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => 'Englisch';

  @override
  String get profileRowFavorites => 'Favoriten';

  @override
  String get profileRowSecurityPrivacy => 'Sicherheit und Datenschutz';

  @override
  String get profileRowNotifications => 'Benachrichtigungen';

  @override
  String get profileRowInviteCode => 'Einladungscode';

  @override
  String get profileRowGeneral => 'Allgemein';

  @override
  String profileRowAbout(Object appName) {
    return 'Über $appName';
  }

  @override
  String get profileLogout => 'Abmelden';

  @override
  String get profileLogoutConfirm =>
      'Durch das Abmelden wird kein Verlauf gelöscht. Sie können sich jederzeit wieder mit diesem Konto anmelden.';

  @override
  String profileMoyuIdLabel(Object appName, Object value) {
    return '$appName ID: $value';
  }

  @override
  String get profileDefaultName => 'Ich';

  @override
  String get profileDetailTitle => 'Profil';

  @override
  String get profileAvatar => 'Avatar';

  @override
  String get profileNickname => 'Spitzname';

  @override
  String get profileEditNickname => 'Spitzname bearbeiten';

  @override
  String profileEditFoxId(Object appName) {
    return '$appName ID bearbeiten';
  }

  @override
  String get profileGender => 'Geschlecht';

  @override
  String get profileGenderMale => 'Männlich';

  @override
  String get profileGenderFemale => 'Weiblich';

  @override
  String get profileGenderSelected => 'Ausgewählt';

  @override
  String get profileGenderUnset => 'Nicht festgelegt';

  @override
  String get profilePhoneUnbound => 'Nicht verknüpft';

  @override
  String get profileAvatarUpdated => 'Avatar aktualisiert';

  @override
  String get profileAvatarUpdateFailed =>
      'Avatar konnte nicht hochgeladen werden. Versuchen Sie es erneut.';

  @override
  String get generalPageTitle => 'Allgemein';

  @override
  String get generalFontSize => 'Schriftgröße';

  @override
  String get generalChatBackground => 'Chat-Hintergrund';

  @override
  String get generalDarkMode => 'Dunkler Modus';

  @override
  String get generalClearCache => 'Cache leeren';

  @override
  String get generalClearMessages => 'Chatverlauf löschen';

  @override
  String get generalAppModules => 'Funktionen';

  @override
  String get generalErrorLogs => 'Fehlerprotokolle';

  @override
  String get generalThirdShare => 'SDKs von Drittanbietern';

  @override
  String get fontSizeSmall => 'Klein';

  @override
  String get fontSizeStandard => 'Standard';

  @override
  String get fontSizeLarge => 'Groß';

  @override
  String get fontSizeExtraLarge => 'Extra groß';

  @override
  String get darkModeSystem => 'Systemstandard';

  @override
  String get darkModeLight => 'Licht';

  @override
  String get darkModeDark => 'Dunkel';

  @override
  String get valueConfigure => 'Konfigurieren';

  @override
  String get valueManage => 'Verwalten';

  @override
  String get valueClear => 'Klar';

  @override
  String get valueUpload => 'Hochladen';

  @override
  String get valueDownload => 'Herunterladen';

  @override
  String get valueView => 'Anzeigen';

  @override
  String get valueEnabled => 'Aktiviert';

  @override
  String get valueDisabled => 'Deaktiviert';

  @override
  String get valueOn => 'Ein';

  @override
  String get valueOff => 'Aus';

  @override
  String get valueConfigured => 'Festgelegt';

  @override
  String get valueNotEnabled => 'Nicht aktiviert';

  @override
  String get valueSelected => 'Ausgewählt';

  @override
  String get valueCurrentDevice => 'Dieses Gerät';

  @override
  String get valueSdkInfo => 'SDK Info';

  @override
  String get statusProcessing => 'Verarbeitung';

  @override
  String get statusLoading => 'Wird geladen';

  @override
  String get statusSending => 'Senden';

  @override
  String get statusSaving => 'Speichern';

  @override
  String get statusSaved => 'Gespeichert';

  @override
  String get statusSent => 'Gesendet';

  @override
  String get statusSubmitted => 'Eingereicht';

  @override
  String get dateJustNow => 'Gerade eben';

  @override
  String get dateToday => 'Heute';

  @override
  String get dateYesterday => 'Gestern';

  @override
  String get dateDayBeforeYesterday => 'Vorgestern';

  @override
  String dateTodayTime(Object time) {
    return 'Heute $time';
  }

  @override
  String dateYesterdayTime(Object time) {
    return 'Gestern $time';
  }

  @override
  String dateDayBeforeYesterdayTime(Object time) {
    return 'Vor zwei Tagen $time';
  }

  @override
  String dateWeekdayTime(Object time, Object weekday) {
    return '$weekday $time';
  }

  @override
  String dateMonthDayTime(Object day, Object month, Object time) {
    return '$day.$month. $time';
  }

  @override
  String dateYearMonthDayTime(
    Object day,
    Object month,
    Object time,
    Object year,
  ) {
    return '$day.$month.$year $time';
  }

  @override
  String dateMonthDay(Object day, Object month) {
    return '$day.$month.';
  }

  @override
  String dateYearMonthDay(Object day, Object month, Object year) {
    return '$day.$month.$year';
  }

  @override
  String get weekdayMonday => 'Montag';

  @override
  String get weekdayTuesday => 'Dienstag';

  @override
  String get weekdayWednesday => 'Mittwoch';

  @override
  String get weekdayThursday => 'Donnerstag';

  @override
  String get weekdayFriday => 'Freitag';

  @override
  String get weekdaySaturday => 'Samstag';

  @override
  String get weekdaySunday => 'Sonntag';

  @override
  String get dialogClearAllTitle => 'Gesamten Chatverlauf löschen?';

  @override
  String get dialogClearAllBody =>
      'Alle lokalen Chat-Verläufe und Konversationseinträge werden entfernt.';

  @override
  String get authLoginSubtitle =>
      'Melden Sie sich mit Ihrer Telefonnummer an und chatten Sie weiter mit Freunden';

  @override
  String get authLoginIllustration => 'Anmeldeillustration';

  @override
  String get authRegisterIllustration => 'Registerabbildung';

  @override
  String get authSecurityIllustration => 'Verifizierungsillustration';

  @override
  String get authResetIllustration =>
      'Abbildung zum Zurücksetzen des Passworts';

  @override
  String get authServerLabel => 'Server';

  @override
  String get authServerCustomLabel => 'Custom server';

  @override
  String get authServerCustomHint => 'Enter server address';

  @override
  String get authPhoneLabel => 'Telefonnummer';

  @override
  String get authPasswordLabel => 'Passwort';

  @override
  String get authForgotPassword => 'Passwort vergessen?';

  @override
  String get authLoginButton => 'Anmelden';

  @override
  String get authLoginLoading => 'Anmelden...';

  @override
  String get authRegisterButton => 'Registrieren';

  @override
  String get authLoginWithApple => 'Sign in with Apple';

  @override
  String get authLoginWithGoogle => 'Sign in with Google';

  @override
  String get authLoginWithGithub => 'Sign in with GitHub';

  @override
  String get authLoginAgreementPrefix =>
      'Mit der Anmeldung erklären Sie sich damit einverstanden';

  @override
  String get authTermsTitle => 'Nutzungsbedingungen';

  @override
  String get authAgreementConnector => 'und';

  @override
  String get authPrivacyTitle => 'Datenschutzrichtlinie';

  @override
  String get authVerifyTitle => 'Verifizierungsanmeldung';

  @override
  String authVerifySubtitleWithPhone(Object phone) {
    return 'Geben Sie den an $phone gesendeten Code ein.';
  }

  @override
  String get authVerifySubtitlePasswordFirst =>
      'Melden Sie sich zunächst mit Ihrem Passwort an, um mit der Sicherheitsüberprüfung zu beginnen';

  @override
  String get authVerifyButton => 'Überprüfen';

  @override
  String get authVerifyLoading => 'Überprüfen...';

  @override
  String get authResendCode => 'Sie haben keinen Code erhalten? Erneut senden';

  @override
  String get authVerificationCodeSent => 'Bestätigungscode gesendet';

  @override
  String get authVerificationCodeRequired =>
      'Geben Sie den Bestätigungscode ein';

  @override
  String get authVerificationCodeSixDigits =>
      'Geben Sie den 6-stelligen Code ein';

  @override
  String get authPasswordResetTitle => 'Login-Passwort zurücksetzen';

  @override
  String get authPasswordResetSubtitle =>
      'Überprüfen Sie Ihre Telefonnummer und legen Sie dann ein neues Login-Passwort fest';

  @override
  String get authPasswordResetButton => 'Passwort zurücksetzen';

  @override
  String get authKickedTitle =>
      'Ihr Konto wurde auf einem anderen Gerät angemeldet.';

  @override
  String get authSubmitting => 'Einreichen...';

  @override
  String get authVerificationCodeLabel => 'Bestätigungscode';

  @override
  String get authGetVerificationCode => 'Code abrufen';

  @override
  String get authNewPasswordLabel => 'Neues Passwort';

  @override
  String get authPasswordResetSuccess => 'Passwort zurückgesetzt';

  @override
  String authRegisterTitle(Object appName) {
    return 'Erstellen Sie ein $appName-Konto';
  }

  @override
  String get authRegisterSubtitle =>
      'Registrieren Sie sich mit Ihrer Telefonnummer und beginnen Sie sofort mit dem Chatten';

  @override
  String get authCreateAccount => 'Konto erstellen';

  @override
  String get authNicknameLabel => 'Spitzname';

  @override
  String get authInviteCodeRequiredLabel => 'Einladungscode (erforderlich)';

  @override
  String authCodeRetryAfter(Object seconds) {
    return 'Wiederholen Sie den Vorgang in ${seconds}s';
  }

  @override
  String get authRegisterAgreement =>
      'Ich habe die Nutzungsbedingungen und Datenschutzbestimmungen gelesen und stimme ihnen zu';

  @override
  String get authInvalidPhone => 'Ungültige Telefonnummer';

  @override
  String get authAcceptAgreementFirst =>
      'Bitte stimmen Sie zunächst den Nutzungsbedingungen und der Datenschutzrichtlinie zu';

  @override
  String get authCodeEmpty => 'Verifizierungscode ist erforderlich';

  @override
  String get authPasswordLengthInvalid =>
      'Das Passwort muss zwischen 6 und 16 Zeichen lang sein';

  @override
  String get authInviteCodeEmpty => 'Einladungscode ist erforderlich';

  @override
  String get authRegisterSuccess => 'Erfolgreich registriert';

  @override
  String get settingsCheckNewVersion => 'Nach Updates suchen';

  @override
  String get settingsChecking => 'Überprüfung';

  @override
  String get settingsVersionFound => 'Update verfügbar';

  @override
  String get settingsUserAgreement => 'Nutzungsbedingungen';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get settingsView => 'Anzeigen';

  @override
  String get settingsSwitchAccount => 'Konto wechseln';

  @override
  String get settingsCacheCleared => 'Cache geleert';

  @override
  String get settingsClearCacheSheetTitle =>
      'Bild-/Video-Cache löschen?\nChat-Bilder, Video-Cover und Avatare werden erneut heruntergeladen.';

  @override
  String get settingsClearCacheAction => 'Cache leeren';

  @override
  String get settingsMessagesCleared => 'Chat-Verlauf gelöscht';

  @override
  String settingsClearMessagesFailed(Object error) {
    return 'Chat-Verlauf konnte nicht gelöscht werden: $error';
  }

  @override
  String get settingsAlreadyLatestVersion =>
      'Sie verwenden bereits die neueste Version';

  @override
  String get settingsCheckFailed => 'Überprüfung fehlgeschlagen';

  @override
  String settingsUpdateDialogTitle(Object version) {
    return 'Update verfügbar\nNeueste Version: $version';
  }

  @override
  String settingsUpdateDialogTitleWithDescription(
    Object description,
    Object version,
  ) {
    return 'Update verfügbar\nNeueste Version: $version\n$description';
  }

  @override
  String get settingsLater => 'Später';

  @override
  String get settingsUpdateNow => 'Jetzt aktualisieren';

  @override
  String get settingsSaveFailedRetry =>
      'Speichern fehlgeschlagen. Versuchen Sie es erneut.';

  @override
  String get securityAllowPhoneSearch =>
      'Erlauben Sie anderen, mich über die Telefonnummer zu finden';

  @override
  String securityAllowFoxIdSearch(Object appName) {
    return 'Anderen erlauben, mich anhand der ID $appName zu finden';
  }

  @override
  String get securitySearchRemark =>
      'Wenn diese Option deaktiviert ist, können andere Benutzer Sie über die oben genannten Informationen nicht finden.';

  @override
  String get securityJoinGroupNeedConfirm =>
      'Require confirmation to join groups';

  @override
  String get securityJoinGroupNeedConfirmRemark =>
      'When on, invitations to add you to a group must be confirmed by you first.';

  @override
  String get securityLoginPassword => 'Login-Passwort';

  @override
  String get securityChatPassword => 'Chat-Passwort';

  @override
  String get securityScreenProtection => 'Bildschirmschutz';

  @override
  String get securityLockPassword => 'Passwort sperren';

  @override
  String get securityOfflineProtection => 'Offline-Bildschirmsperre';

  @override
  String get securityDeviceManagement => 'Anmeldegeräteverwaltung';

  @override
  String get securityDeviceRemark =>
      'Geräte anzeigen und verwalten, Anmeldeschutz aktivieren und Ihr Konto schützen.';

  @override
  String get securityBlacklist => 'Schwarze Liste';

  @override
  String get securityAccountDeletion => 'Konto löschen';

  @override
  String get accountDeletionBody =>
      'Die Kontolöschung kann nicht rückgängig gemacht werden. Nach der Bestätigung wird ein Bestätigungscode per SMS gesendet, um den Löschvorgang abzuschließen.';

  @override
  String get accountDeletionSubmitted => 'Löschantrag eingereicht';

  @override
  String get accountDeletionGetCode => 'Code abrufen';

  @override
  String get passwordResetInstruction =>
      'Zum Ändern Ihres Anmeldekennworts ist ein SMS-Code erforderlich. Das neue Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get accountPhoneLabel => 'Telefonnummer';

  @override
  String get passwordRuleLabel => 'Passwortregel';

  @override
  String get passwordAtLeastSix => 'Mindestens 6 Zeichen';

  @override
  String get passwordConfirmLabel => 'Passwort bestätigen';

  @override
  String get passwordConfirmHint => 'Geben Sie das Login-Passwort erneut ein';

  @override
  String get passwordChanged => 'Login-Passwort geändert';

  @override
  String get phoneRequired => 'Telefonnummer ist erforderlich';

  @override
  String get passwordMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get chatPasswordInstruction =>
      'Wenn aktiviert, ist dieses 6-stellige Passwort vor dem Öffnen geschützter Chats erforderlich.';

  @override
  String get currentStatusLabel => 'Aktueller Status';

  @override
  String get passwordSixDigits => '6 Ziffern';

  @override
  String get chatPasswordEnableAction => 'Chat-Passwort aktivieren';

  @override
  String get loginPasswordRequired => 'Login-Passwort ist erforderlich';

  @override
  String get chatPasswordSixDigitsRequired =>
      'Das Chat-Passwort muss 6-stellig sein';

  @override
  String get lockSetTitle => 'Legen Sie ein 6-stelliges Sperrkennwort fest';

  @override
  String lockSetSubtitle(Object appName) {
    return 'Erforderlich zum Entsperren von $appName';
  }

  @override
  String get lockCurrentPromptTitle =>
      'Geben Sie das aktuelle Sperrpasswort ein';

  @override
  String get lockCurrentPromptSubtitle =>
      'Überprüfen Sie dies, bevor Sie es ändern oder deaktivieren';

  @override
  String get lockAutoLock => 'Automatische Sperre';

  @override
  String get lockChangePassword => 'Entsperrkennwort ändern';

  @override
  String get lockClosePassword => 'Deaktivieren Sie das Entsperrkennwort';

  @override
  String get lockWrongPassword => 'Falsches Passwort. Versuchen Sie es erneut.';

  @override
  String get lockSixDigitsRequired => 'Sperrkennwort muss 6-stellig sein';

  @override
  String get lockInputTitle => 'Sperrpasswort eingeben';

  @override
  String lockInputSubtitle(Object appName) {
    return 'Entsperren, um $appName weiterhin zu verwenden';
  }

  @override
  String get lockSetFailed =>
      'Festlegen fehlgeschlagen. Versuchen Sie es erneut.';

  @override
  String get lockImmediately => 'Sofort';

  @override
  String get lockAfter5Minutes => 'Nach 5 Minuten entfernt';

  @override
  String get lockAfter30Minutes => 'Nach 30 Minuten entfernt';

  @override
  String get lockAfter1Hour => 'Nach 1 Stunde Entfernung';

  @override
  String get deviceLoginProtection => 'Anmeldeschutz';

  @override
  String get deviceProtectionRemark =>
      'Wenn der Anmeldeschutz aktiviert ist, ist eine Sicherheitsüberprüfung auf unbekannten Geräten erforderlich. Empfohlen für die Kontosicherheit.';

  @override
  String get deviceNone => 'Keine angemeldeten Geräte';

  @override
  String get deviceDebugName => 'Aktuelles Gerät';

  @override
  String get deviceDebugPlatform => 'iPhone/Android-Debug-Gerät';

  @override
  String get deviceProtectionEnabled => 'Anmeldeschutz aktiviert';

  @override
  String get deviceProtectionDisabled => 'Anmeldeschutz deaktiviert';

  @override
  String get deviceProtectionUpdateFailed =>
      'Der Anmeldeschutz konnte nicht aktualisiert werden. Versuchen Sie es erneut.';

  @override
  String get blacklistEmpty => 'Keine Kontakte auf der schwarzen Liste';

  @override
  String get switchAccountRecent => 'Aktuelle Konten';

  @override
  String get switchAccountLoading => 'Aktuelle Konten lesen';

  @override
  String get switchAccountAddOther =>
      'Fügen Sie ein anderes Konto hinzu oder melden Sie sich an';

  @override
  String get switchAccountCurrent => 'Aktuell';

  @override
  String get appModulesLoading => 'Funktionsmodule werden geladen';

  @override
  String get appModulesEmpty => 'Keine Funktionsmodule';

  @override
  String get appModulesUnavailable => 'Modul nicht verfügbar';

  @override
  String get errorLogsLoading => 'Fehlerprotokolle werden gelesen';

  @override
  String get errorLogsEmpty => 'Keine Fehlerprotokolle';

  @override
  String get errorLogFileName => 'Dateiname';

  @override
  String get errorLogFileSize => 'Dateigröße';

  @override
  String get errorLogGeneratedAt => 'Erstellt am';

  @override
  String get errorLogFilePath => 'Dateipfad';

  @override
  String get notificationReceiveNew =>
      'Erhalten Sie Benachrichtigungen über neue Nachrichten';

  @override
  String get notificationSound => 'Ton';

  @override
  String get notificationVibration => 'Vibration';

  @override
  String get notificationShowDetails => 'Benachrichtigungsdetails anzeigen';

  @override
  String get notificationSystem => 'Systemnachrichtenbenachrichtigungen';

  @override
  String get notificationCalls => 'Audio-/Videoanrufbenachrichtigungen';

  @override
  String get settingsGoToSystem => 'Einstellungen';

  @override
  String aboutAppIconSemantic(Object appName) {
    return '$appName Symbol';
  }

  @override
  String aboutCopyright(Object appName) {
    return 'Copyright © 2026\n$appName. Alle Rechte vorbehalten.';
  }

  @override
  String get policyWebUrl => 'Web URL';

  @override
  String get appearanceTitle => 'Aussehen';

  @override
  String get appearanceAppIcon => 'App-Symbol';

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
  String get appearanceChatColor => 'Chat-Farbe';

  @override
  String get appearanceBubbleRadius => 'Blaseneckenradius';

  @override
  String get appearanceBubbleColorInk => 'Tinte Schwarz';

  @override
  String get appearanceSquare => 'Quadratisch';

  @override
  String get appearanceRound => 'Rund';

  @override
  String get appearancePreviewOne =>
      'Möchte er, dass ich nach rechts oder links abbiege? 🤔';

  @override
  String get appearancePreviewTwo =>
      'Richtig. Und, nun ja, machen Sie es stark.';

  @override
  String get appearancePreviewThree =>
      'Ist das alles? Ich habe das Gefühl, dass er mehr als das gesagt hat. 😯';

  @override
  String get appearancePreviewFour =>
      'Das war’s auch schon. Ich werde später eine Sprachnachricht mit weiteren Details senden.';

  @override
  String get contactsEmptyTitle => 'Noch keine Kontakte';

  @override
  String get contactsEmptySubtitle =>
      'Fügen Sie oben rechts Freunde hinzu oder scannen Sie eine Profilkarte';

  @override
  String contactsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kontakte',
      one: '1 Kontakt',
    );
    return '$_temp0';
  }

  @override
  String get contactAddTooltip => 'Freund hinzufügen';

  @override
  String get contactSearchHint => 'Kontakte und Gruppen durchsuchen';

  @override
  String get contactSetRemark => 'Bemerkung festlegen';

  @override
  String get contactAddToBlacklist => 'Zur Blacklist hinzufügen';

  @override
  String get contactDeleteFriend => 'Freund löschen';

  @override
  String get contactAddedToBlacklist => 'Zur Blacklist hinzugefügt';

  @override
  String get operationFailed =>
      'Vorgang fehlgeschlagen. Versuchen Sie es erneut.';

  @override
  String operationFailedWithError(String error) {
    return 'Vorgang fehlgeschlagen: $error';
  }

  @override
  String contactDeleteFriendConfirm(Object name) {
    return 'Freund „$name“ löschen?\nDer Chat-Verlauf wird ebenfalls gelöscht.';
  }

  @override
  String get contactConfirmDelete => 'Löschen bestätigen';

  @override
  String get contactDeleted => 'Freund gelöscht';

  @override
  String get contactUnknownUser => 'Unbekannter Benutzer';

  @override
  String get contactActionNewFriends => 'Neue Freunde';

  @override
  String get contactActionSavedGroups => 'Gespeicherte Gruppen';

  @override
  String get contactSearchNoMatches => 'Keine passenden Kontakte';

  @override
  String get addFriendTitle => 'Freund hinzufügen';

  @override
  String addFriendSearchHint(Object appName) {
    return 'Telefon / $appName ID';
  }

  @override
  String get addFriendNotFound => 'Konto nicht gefunden';

  @override
  String get myQrCodeTitle => 'Mein QR-Code';

  @override
  String myQrCodeSubtitle(Object appName) {
    return 'Scannen Sie diesen QR-Code, um mich auf $appName hinzuzufügen.';
  }

  @override
  String get myQrCodeEmpty => 'Kein QR-Code';

  @override
  String get scanTitle => 'Scannen';

  @override
  String get scanQrNotFound => 'Kein QR-Code erkannt';

  @override
  String scanResolveFailed(String error) {
    return 'QR-Code konnte nicht analysiert werden: $error';
  }

  @override
  String get scanUnrecognized => 'Dieser QR-Code kann nicht erkannt werden';

  @override
  String get scanInfoIncomplete => 'QR-Code-Informationen sind unvollständig';

  @override
  String get scanSocialUnavailable =>
      'Der Sozialdienst ist nicht initialisiert';

  @override
  String get scanJoinedGroup => 'Dem Gruppenchat beigetreten';

  @override
  String get scanCannotOpenGroup =>
      'Auf dieser Seite können keine Gruppenchats geöffnet werden';

  @override
  String get scanGroupNotFound => 'Gruppenchat nicht gefunden';

  @override
  String get scanOpenGroupFailed =>
      'Der Gruppenchat konnte nicht geöffnet werden';

  @override
  String get scanSelfQr => 'Dies ist Ihr eigener QR-Code';

  @override
  String get scanUserNotFound => 'Benutzer nicht gefunden';

  @override
  String get scanCameraPermissionRequired => 'Kameragenehmigung erforderlich';

  @override
  String get scanOpenSettings => 'Öffnen Sie die Einstellungen';

  @override
  String get scanCameraUnavailable => 'Kamera nicht verfügbar';

  @override
  String get scanAlbum => 'Album';

  @override
  String get scanLightOn => 'Licht an';

  @override
  String get scanLightOff => 'Licht aus';

  @override
  String get scanQrCode => 'QR-Code';

  @override
  String get scanGroupFallback => 'Gruppenchat';

  @override
  String get scanGroupLoadingInfo => 'Gruppeninformationen werden geladen';

  @override
  String scanGroupMemberCount(int count) {
    return '$count Mitglieder';
  }

  @override
  String get scanJoinGroupConfirm => 'Treten Sie dem Gruppenchat bei';

  @override
  String get scanJoining => 'Beitritt';

  @override
  String get scanJoinGroup => 'Treten Sie dem Gruppenchat bei';

  @override
  String scanJoinFailed(String error) {
    return 'Beitritt fehlgeschlagen: $error';
  }

  @override
  String get tagsTitle => 'Tags';

  @override
  String get tagsCreateTooltip => 'Neues Tag';

  @override
  String get tagsContactSection => 'Kontakt-Tags';

  @override
  String get tagsEmptyTitle => 'Keine Tags';

  @override
  String get tagsEmptySubtitle =>
      'Tippen Sie oben rechts auf +, um Kontakte oder Chats zu gruppieren.';

  @override
  String tagsCreateFailed(Object error) {
    return 'Tag konnte nicht erstellt werden: $error';
  }

  @override
  String tagsUpdateFailed(Object error) {
    return 'Tag konnte nicht aktualisiert werden: $error';
  }

  @override
  String tagsDeleteFailed(Object error) {
    return 'Tag konnte nicht gelöscht werden: $error';
  }

  @override
  String tagsLoadFailed(Object error) {
    return 'Tags konnten nicht geladen werden: $error';
  }

  @override
  String tagsDeleteConfirm(String name) {
    return 'Tag „$name“ löschen?\nKontakte und Gruppen in diesem Tag werden nicht gelöscht.';
  }

  @override
  String get tagsEditTitle => 'Tag bearbeiten';

  @override
  String get tagsCreateTitle => 'Neues Tag';

  @override
  String get tagsNameSection => 'Tag-Name';

  @override
  String get tagsNameHint => 'Familie, Freunde';

  @override
  String tagsMembersSection(int count) {
    return 'Tag-Mitglieder ($count)';
  }

  @override
  String get tagsAddMember => 'Mitglied hinzufügen';

  @override
  String get tagsDelete => 'Tag löschen';

  @override
  String get tagsGroupInitial => 'G';

  @override
  String get tagsUnknownUser => 'Unbekannter Benutzer';

  @override
  String get tagsSelectMembersTitle => 'Wählen Sie Mitglieder aus';

  @override
  String tagsDoneCount(int count) {
    return 'Fertig ($count)';
  }

  @override
  String get tagsSearchHint => 'Kontakte oder Gruppen suchen';

  @override
  String get tagsGroupsSection => 'Gruppenchats';

  @override
  String get tagsContactsSection => 'Kontakte';

  @override
  String get tagsNoMatchesTitle => 'Keine Übereinstimmungen';

  @override
  String get tagsNoMatchesSubtitle =>
      'Versuchen Sie es mit einem anderen Schlüsselwort';

  @override
  String tagsRowTitle(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get phoneContactsTitle => 'Telefonkontakte';

  @override
  String get phoneContactsSection => 'Aus Telefonkontakten hinzufügen';

  @override
  String get phoneContactsEmpty => 'Keine Telefonkontakte';

  @override
  String get phoneContactsNoAddable => 'Keine Telefonkontakte zum Hinzufügen';

  @override
  String get phoneContactsServerSyncFailed =>
      'Serversynchronisierung fehlgeschlagen. Vorhandene Kontakte anzeigen.';

  @override
  String get friendAlreadyAdded => 'Hinzugefügt';

  @override
  String get friendRequestSent => 'Freundschaftsanfrage gesendet';

  @override
  String phoneContactsInviteSmsBody(Object appName) {
    return 'Ich verwende $appName. Das Chat-Erlebnis ist ziemlich nett. Kommen Sie und probieren Sie es auch aus.';
  }

  @override
  String get phoneContactsInviteOpened => 'SMS-Einladung geöffnet';

  @override
  String get phoneContactsInviteFailed =>
      'SMS kann nicht geöffnet werden. Bitte laden Sie manuell ein.';

  @override
  String get friendRequestsEmptyTitle => 'Keine neuen Freunde';

  @override
  String get friendRequestsEmptySubtitle =>
      'Laden Sie Freunde ein, Ihren QR-Code zu scannen';

  @override
  String get friendRequestsPendingSection => 'Ausstehend';

  @override
  String get friendRequestRefused => 'Abgelehnt';

  @override
  String contactOpenFromContacts(Object name) {
    return 'Öffnen Sie den Chat von @$name über Kontakte';
  }

  @override
  String get fileHelperIntro =>
      'Melden Sie sich bei der Webversion an und senden Sie mir Nachrichten, um Text, Fotos, Audio, Videos und Dateien zwischen Telefon und Computer zu übertragen.';

  @override
  String get fileHelperName => 'File Transfer';

  @override
  String get systemAccountName => 'System';

  @override
  String systemAccountIntro(Object appName) {
    return 'Offizielles $appName-Konto zum Versenden von Benachrichtigungen.';
  }

  @override
  String get contactIntroTitle => 'Einführung';

  @override
  String get contactSource => 'Quelle';

  @override
  String get contactRemoveFriendRelation => 'Freund entfernen';

  @override
  String get contactRemoveFromBlacklist => 'Von der Blacklist entfernen';

  @override
  String get contactSendMessage => 'Nachricht';

  @override
  String get contactAddToContacts => 'Zu Kontakten hinzufügen';

  @override
  String get contactRemoveFriendConfirm => 'Diesen Freund entfernen?';

  @override
  String contactNicknameLine(Object name) {
    return 'Spitzname: $name';
  }

  @override
  String get contactRemoveFromBlacklistConfirm =>
      'Diesen Kontakt von der Blacklist entfernen?';

  @override
  String get webLoginTitle => 'Web Anmelden';

  @override
  String get webLoginConfirmTitle => 'Webanmeldung bestätigen?';

  @override
  String get webLoginConfirmBody =>
      'Dadurch kann sich Ihr Konto beim aktuellen Browser oder Desktop-Client anmelden. Wenn Sie das nicht waren, tippen Sie auf Abbrechen.';

  @override
  String get webLoginConfirmAction => 'Anmeldung bestätigen';

  @override
  String get webLoginConfirming => 'Bestätigt...';

  @override
  String get webLoginConfirmed => 'Web Anmeldung bestätigt';

  @override
  String webLoginConfirmFailed(Object error) {
    return 'Bestätigung fehlgeschlagen: $error';
  }

  @override
  String get applyFriendTitle => 'Freundschaftsanfrage';

  @override
  String get applyFriendSectionTitle => 'Freundschaftsanfrage senden';

  @override
  String get applyFriendRemarkHint => 'Hallo, ich bin...';

  @override
  String friendRequestSendFailed(Object error) {
    return 'Fehler beim Senden: $error';
  }

  @override
  String get contactRemarkHint => 'Bemerkung';

  @override
  String get momentPermissionsTitle => 'Moments-Datenschutz';

  @override
  String get momentHideMineFromContact => 'Verstecke meine Momente vor ihnen';

  @override
  String get momentHideContactFromMe => 'Verstecke ihre Momente vor mir';

  @override
  String get momentTitle => 'Momente';

  @override
  String get momentPersonalEmpty => 'Noch keine Beiträge';

  @override
  String get momentEmpty => 'Noch keine Momente';

  @override
  String get momentCoverUploadFailed =>
      'Das Hochladen des Covers ist fehlgeschlagen';

  @override
  String momentCoverUploadFailedWithError(Object error) {
    return 'Cover konnte nicht hochgeladen werden: $error';
  }

  @override
  String get momentDeleteConfirm => 'Diesen Moment löschen?';

  @override
  String get momentJustNow => 'Gerade eben';

  @override
  String get momentPublishing => 'Posting…';

  @override
  String get momentPublishFailed => 'Failed to post. Tap to dismiss.';

  @override
  String get momentRemindedYou =>
      'Hat Sie daran erinnert, diesen Moment anzusehen';

  @override
  String momentRemindedNames(Object names) {
    return 'Erinnert $names';
  }

  @override
  String get momentKeepEditingConfirm => 'Diese Änderung beibehalten?';

  @override
  String get momentContinueEditing => 'Weiter bearbeiten';

  @override
  String get momentSaveDraft => 'Entwurf speichern';

  @override
  String get momentDiscardDraft => 'Verwerfen';

  @override
  String get momentPublishTitle => 'Beitrag';

  @override
  String get momentPublishHint => 'Was geht Ihnen durch den Kopf...';

  @override
  String get momentLocationTitle => 'Standort';

  @override
  String get momentRemindWho => 'Erinnerung';

  @override
  String get locationUnsupported =>
      'Der Standort ist in dieser Version nicht verfügbar';

  @override
  String momentPrivacyContactCount(Object count, Object label) {
    return '$label · $count';
  }

  @override
  String get momentSelectVisibleContacts =>
      'Wählen Sie „Sichtbare Kontakte“ aus';

  @override
  String get momentSelectHiddenContacts =>
      'Wählen Sie „Versteckte Kontakte“ aus';

  @override
  String get momentPrivacyPublic => 'Öffentlich';

  @override
  String get momentPrivacyPrivate => 'Privat';

  @override
  String get momentPrivacyInternal => 'Für einige sichtbar';

  @override
  String get momentPrivacyProhibit => 'Verstecken vor';

  @override
  String get momentPrivacyWhoCanSee => 'Wer kann sehen';

  @override
  String momentCommentFailed(Object error) {
    return 'Kommentar fehlgeschlagen: $error';
  }

  @override
  String get momentDetailTitle => 'Details';

  @override
  String get momentDeleted => 'Dieser Moment wurde gelöscht';

  @override
  String get momentCollapse => 'Zusammenbruch';

  @override
  String get momentFullText => 'Volltext';

  @override
  String get momentDeleteCommentConfirm => 'Diesen Kommentar löschen?';

  @override
  String get momentCommentPlaceholder => 'Kommentar';

  @override
  String momentReplyPlaceholder(Object name) {
    return 'Antwort $name';
  }

  @override
  String get momentLikeAction => 'Gefällt mir';

  @override
  String get momentCommentAction => 'Kommentar';

  @override
  String momentNewMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count neue Nachrichten',
      one: '1 neue Nachricht',
    );
    return '$_temp0';
  }

  @override
  String get messagesTitle => 'Nachrichten';

  @override
  String get messagesEmpty => 'Keine Nachrichten';

  @override
  String get messagesEmptyTitle => 'Noch keine Nachrichten';

  @override
  String get messagesEmptySubtitle =>
      'Starten Sie oben rechts einen neuen Chat';

  @override
  String get messagesNewConversation => 'Neu';

  @override
  String get messagesStartGroupChat => 'Gruppenchat starten';

  @override
  String get messagesImDisconnected => 'IM ist nicht verbunden';

  @override
  String get messagesPinned => 'Angepinnt';

  @override
  String get messagesUnpinned => 'Nicht angepinnt';

  @override
  String get messagesMuted => 'Stummgeschaltet';

  @override
  String get messagesNotificationsOn => 'Benachrichtigungen am';

  @override
  String messagesDeleteConversationTitle(String name) {
    return '„$name“ löschen?';
  }

  @override
  String get messagesConfirmDelete => 'Löschen';

  @override
  String get messagesCleared => 'Chat-Verlauf gelöscht';

  @override
  String get messagesConversationDeleted => 'Konversation gelöscht';

  @override
  String get messagesUnknownUser => 'Unbekannter Benutzer';

  @override
  String get messagesFriendAvatarFallback => 'F';

  @override
  String get messagesGroupFallback => 'Gruppenchat';

  @override
  String get messagesGroupAvatarFallback => 'G';

  @override
  String get messagesNewMessageDigest => '[Neue Nachricht]';

  @override
  String get messagesConversationPin => 'Pin';

  @override
  String get messagesConversationUnpin => 'Loslösen';

  @override
  String get messagesConversationMute => 'Stumm';

  @override
  String get messagesConversationUnmute => 'Stummschaltung aufheben';

  @override
  String get messagesConnectionNoNetwork =>
      'Netzwerk nicht verfügbar. Überprüfen Sie Ihre Verbindung.';

  @override
  String get messagesConnectionDisconnected => 'Nicht verbunden';

  @override
  String get messagesConnectionConnecting => 'Verbinden';

  @override
  String get messagesConnectionSyncing => 'Synchronisierung';

  @override
  String get globalSearchTitle => 'Suchen';

  @override
  String get globalSearchTabChats => 'Chats';

  @override
  String get globalSearchTabContacts => 'Kontakte';

  @override
  String get globalSearchTabGroups => 'Gruppen';

  @override
  String get globalSearchTabFiles => 'Dateien';

  @override
  String get globalSearchContactsSection => 'Kontakte';

  @override
  String get globalSearchGroupsSection => 'Gruppenchats';

  @override
  String get globalSearchMessagesSection => 'Chat-Verlauf';

  @override
  String get globalSearchFilesSection => 'Dateien';

  @override
  String get globalSearchNoMatches => 'Keine Übereinstimmungen';

  @override
  String get globalSearchNoMore => 'Keine weiteren Ergebnisse';

  @override
  String get locationLocating => 'Lokalisierung...';

  @override
  String locationPermissionOff(Object appName) {
    return 'Die Standortberechtigung ist deaktiviert. Erlauben Sie $appName, den Standort in den Systemeinstellungen zu verwenden.';
  }

  @override
  String get locationPermissionDenied =>
      'Die Standortberechtigung wurde verweigert. Orte in der Nähe können nicht geladen werden.';

  @override
  String get locationMapUnsupported =>
      'AMap wird auf dieser Plattform nicht unterstützt';

  @override
  String locationFailed(String error) {
    return 'Standort fehlgeschlagen: $error';
  }

  @override
  String get locationSearchPrompt =>
      'Geben Sie Schlüsselwörter ein, um nach Orten in der Nähe zu suchen';

  @override
  String get locationNoNearbyPoi => 'Kein POI in der Nähe';

  @override
  String get locationSearchHint => 'Suchen Sie nach Orten in der Nähe';

  @override
  String get locationPickerTitle => 'Standort';

  @override
  String get locationSending => 'Wird gesendet';

  @override
  String get locationUnnamed => 'Unbenannter Ort';

  @override
  String get locationCopiedAddress => 'Adresse kopiert';

  @override
  String get locationNoMapApp => 'Keine Karten-App verfügbar';

  @override
  String get locationFallbackTitle => 'Standort';

  @override
  String get locationAmap => 'AMap';

  @override
  String get locationBaiduMap => 'Baidu-Karten';

  @override
  String get locationTencentMap => 'Tencent-Karten';

  @override
  String get locationAppleMap => 'Apple Maps';

  @override
  String get locationOtherMap => 'Andere Karten';

  @override
  String get locationMyLocation => 'Mein Standort';

  @override
  String locationOpenMapFailed(String name) {
    return '$name kann nicht geöffnet werden';
  }

  @override
  String get locationCopyAddress => 'Adresse kopieren';

  @override
  String get locationNavigate => 'Navigieren';

  @override
  String get locationViewTitle => 'Karte';

  @override
  String get momentPeerCommentDeleted => 'Kommentar gelöscht';

  @override
  String get momentDigest => '[Moment]';

  @override
  String get actionClose => 'Schließen';

  @override
  String get saveToAlbum => 'Im Album speichern';

  @override
  String get savedToAlbum => 'Im Album gespeichert';

  @override
  String get saveFailed => 'Speichern fehlgeschlagen';

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
    return '$count Fotos';
  }

  @override
  String get momentReplyConnector => 'hat darauf geantwortet';

  @override
  String get groupRemarkTitle => 'Gruppenbemerkung';

  @override
  String get groupRemarkHint =>
      'Legen Sie eine Gruppenbemerkung fest, die nur für Sie sichtbar ist';

  @override
  String get chatNotificationSettingsTitle => 'Nachrichtenbenachrichtigungen';

  @override
  String get chatScreenshotNotification => 'Screenshot-Benachrichtigungen';

  @override
  String get chatRevokeNotification => 'Rückrufbenachrichtigungen';

  @override
  String get completeProfileTitle => 'Vollständiges Profil';

  @override
  String get completeProfileUploadAvatar => 'Avatar hochladen';

  @override
  String get completeProfileReuploadAvatar => 'Neuen Avatar hochladen';

  @override
  String get completeProfileChooseAvatar => 'Wählen Sie ein Profilfoto';

  @override
  String get completeProfileAvatarUploaded => 'Avatar hochgeladen';

  @override
  String get completeProfileAvatarRequired => 'Avatar ist erforderlich.';

  @override
  String get nicknameLabel => 'Spitzname';

  @override
  String get nicknameInputHint => 'Nickname eingeben';

  @override
  String get nicknameRequired => 'Spitzname ist erforderlich.';

  @override
  String get completeProfileSaved => 'Profil abgeschlossen';

  @override
  String get chatSettingsTitle => 'Chat-Details';

  @override
  String chatSettingsGroupTitle(Object count) {
    return 'Chat-Info ($count)';
  }

  @override
  String get chatSettingsGroupName => 'Gruppenchat-Name';

  @override
  String get chatSettingsGroupQrCode => 'Gruppen-QR-Code';

  @override
  String get chatSearchContentTitle => 'Chat durchsuchen';

  @override
  String get chatSettingsBackground => 'Chat-Hintergrund festlegen';

  @override
  String get chatSettingsBackgroundSelected => 'Aktueller Chat-Hintergrundsatz';

  @override
  String get chatSettingsMute => 'Benachrichtigungen stummschalten';

  @override
  String get chatSettingsPin => 'Pin-Chat';

  @override
  String get chatSettingsSaveToContacts => 'In den Kontakten speichern';

  @override
  String get chatSettingsReadReceipt => 'Lesebestätigungen';

  @override
  String get chatSettingsReadReceiptSubtitle =>
      'Wenn diese Option aktiviert ist, zeigen gesendete Nachrichten den Status „gelesen/ungelesen“ an';

  @override
  String get chatSettingsFlame => 'Brennen nach dem Lesen';

  @override
  String get chatFlameTipExit =>
      'Gelesene Nachrichten werden nach dem Verlassen des Chats gelöscht';

  @override
  String chatFlameTipMinutes(Object minutes) {
    return 'Nachrichten werden $minutes Minuten nach dem Lesen zerstört';
  }

  @override
  String chatFlameTipSeconds(Object seconds) {
    return 'Nachrichten werden ${seconds}s nach dem Lesen zerstört';
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
  String get chatSettingsGroupNickname => 'Mein Gruppenname';

  @override
  String get chatSettingsBlacklisted => 'Auf der schwarzen Liste';

  @override
  String get chatSettingsPeerBlacklisted =>
      'Dieser Kontakt ist bereits auf der schwarzen Liste';

  @override
  String get chatSettingsComplaint => 'Bericht';

  @override
  String get chatSettingsDeleteAndExit => 'Löschen und beenden';

  @override
  String groupRemarkSyncFailed(Object error) {
    return 'Gruppenbemerkung konnte nicht synchronisiert werden: $error';
  }

  @override
  String get chatSocialDisconnected => 'Sozialdienst ist nicht verbunden';

  @override
  String get chatNoRemovableMembers => 'Keine entfernbaren Mitglieder';

  @override
  String get chatSelectMembersToRemove =>
      'Wählen Sie die zu entfernenden Mitglieder aus';

  @override
  String chatMemberNameQuoted(Object name) {
    return '„$name“';
  }

  @override
  String chatMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder',
      one: '1 Mitglied',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersConfirm(Object names) {
    return 'Entfernen Sie $names aus der Gruppe';
  }

  @override
  String chatMembersRemoved(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder entfernt',
      one: '1 Mitglied entfernt',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersFailed(Object error) {
    return 'Mitglieder konnten nicht entfernt werden: $error';
  }

  @override
  String get chatNoInviteCandidates => 'Keine Kontakte zum Einladen verfügbar';

  @override
  String get chatInviteMembers => 'Mitglieder einladen';

  @override
  String get chatSelectContacts => 'Wählen Sie Kontakte aus';

  @override
  String chatMembersInvited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eingeladene $count Mitglieder',
      one: '1 Mitglied eingeladen',
    );
    return '$_temp0';
  }

  @override
  String chatInviteMembersFailed(Object error) {
    return 'Mitglieder konnten nicht eingeladen werden: $error';
  }

  @override
  String get chatGroupCreated =>
      'Gruppenchat erstellt. Überprüfen Sie die Chat-Liste.';

  @override
  String get chatGroupCreateFailed =>
      'Gruppenchat konnte nicht erstellt werden';

  @override
  String chatGroupCreateFailedWithError(Object error) {
    return 'Gruppenchat konnte nicht erstellt werden: $error';
  }

  @override
  String get chatClearCurrentConfirm => 'Den aktuellen Chatverlauf löschen?';

  @override
  String get chatDeleteAndExitConfirm =>
      'Nach dem Löschen und Beenden erhalten Sie keine Nachrichten mehr von dieser Gruppe.';

  @override
  String get chatBlockConfirm =>
      'Nachdem Sie diesen Kontakt zur Blacklist hinzugefügt haben, erhalten Sie seine Nachrichten nicht mehr.';

  @override
  String get chatSearchTabAll => 'Chats';

  @override
  String get chatSearchTabMedia => 'Fotos/Videos';

  @override
  String get chatSearchTabFile => 'Dateien';

  @override
  String get chatSearchNoMatches => 'Kein passender Chatverlauf';

  @override
  String get chatSearchNoMore => 'Keine weiteren Ergebnisse';

  @override
  String get chatDetailsTooltip => 'Chat-Details';

  @override
  String get chatVoiceInputTooltip => 'Spracheingabe';

  @override
  String get chatInputHint => 'Nachricht...';

  @override
  String get chatFlameEnabledTooltip => 'Brennen nach dem Lesen ist aktiviert';

  @override
  String get chatFlameDestroyOnExit => 'Nach dem Verlassen des Chats zerstören';

  @override
  String chatFlameDestroyAfterMinutes(Object minutes) {
    return 'Zerstören nach $minutes Min';
  }

  @override
  String chatFlameDestroyAfterSeconds(Object seconds) {
    return 'Nach ${seconds}s zerstören';
  }

  @override
  String chatFlameEnabledNotice(Object label) {
    return 'Brennen nach dem Lesen ist aktiviert. Nachrichten werden $label nach dem Lesen vernichtet. Verwenden Sie die Einstellungen oben rechts, um es auszuschalten.';
  }

  @override
  String get chatEmojiTooltip => 'Emoji';

  @override
  String get chatActionReply => 'Antwort';

  @override
  String get chatActionCopy => 'Kopie';

  @override
  String get chatActionTranslate => 'Übersetzen';

  @override
  String get chatActionTranscribe => 'Transkribieren';

  @override
  String get chatActionForward => 'Weiterleiten';

  @override
  String get chatActionFavorite => 'Favorit';

  @override
  String get chatActionPin => 'Pin';

  @override
  String get chatActionUnpin => 'Loslösen';

  @override
  String get chatActionAddFriend => 'Freund hinzufügen';

  @override
  String get chatActionMultiSelect => 'Auswählen';

  @override
  String get chatActionEdit => 'Bearbeiten';

  @override
  String get chatActionEditImage => 'Bild bearbeiten';

  @override
  String get chatActionRevoke => 'Rückruf';

  @override
  String get chatActionDelete => 'Löschen';

  @override
  String get chatGroupCallActive => 'Gruppenanruf läuft';

  @override
  String chatMessageRevokedBy(Object name) {
    return '$name hat eine Nachricht zurückgerufen';
  }

  @override
  String get chatReedit => 'Neu bearbeiten';

  @override
  String get chatEditedSuffix => '(bearbeitet)';

  @override
  String chatActionReadBy(Object count) {
    return 'Gelesen von $count';
  }

  @override
  String chatActionReactedBy(Object count) {
    return '$count Reaktionen';
  }

  @override
  String chatSelectedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ausgewählte $count Artikel',
      one: '1 Artikel ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get chatNoReactions => 'Noch keine Reaktionen';

  @override
  String chatReadStatusReadCount(Object count) {
    return 'Lesen ($count)';
  }

  @override
  String get chatNoReadReceipts => 'Noch keine';

  @override
  String get chatHistoryAbove => 'Frühere Nachrichten oben';

  @override
  String chatUnreadNewMessages(Object count) {
    return '$count neue Nachrichten';
  }

  @override
  String get chatUnreadDivider => 'Neue Nachrichten unten';

  @override
  String get chatUnknownContentFallback =>
      'Diese Version kann diese Meldung nicht anzeigen. Aktualisieren Sie auf die neueste Version.';

  @override
  String get chatMentionSomeone => 'Jemand hat Sie erwähnt';

  @override
  String get chatToolAlbum => 'Album';

  @override
  String get chatToolCamera => 'Kamera';

  @override
  String get chatToolFile => 'Datei';

  @override
  String get chatToolLocation => 'Standort';

  @override
  String get chatToolContactCard => 'Kontaktkarte';

  @override
  String get chatToolAudioCall => 'Sprachanruf';

  @override
  String get chatToolVideoCall => 'Videoanruf';

  @override
  String get chatDraftLabel => '[Entwurf]';

  @override
  String get visitorBadge => 'Besucher';

  @override
  String get chatNoticeDeleted => 'Gelöscht';

  @override
  String get chatNoticeCopied => 'Kopiert';

  @override
  String get chatMentionLoadedOrInvisible =>
      'Die @-Nachricht ist geladen oder nicht sichtbar. Scrollen Sie nach oben, um es zu finden.';

  @override
  String get chatLocationDefaultTitle => 'Standort';

  @override
  String get chatLocationCopied => 'Standort kopiert';

  @override
  String get chatReadStatusTitle => 'Status lesen';

  @override
  String get chatReadStatusRead => 'Gelesen';

  @override
  String get chatReadStatusUnread => 'Ungelesen';

  @override
  String get chatReadStatusUnavailable =>
      'Vollständige gelesene/ungelesene Listen sind noch nicht verfügbar';

  @override
  String get chatComposerLeft => 'Sie haben diesen Chat verlassen';

  @override
  String get chatComposerMuted => 'Dieser Chat ist stummgeschaltet';

  @override
  String chatComposerMutedUntil(Object time) {
    return 'Du bist stummgeschaltet bis $time';
  }

  @override
  String chatFavoriteCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Favorit $count Nachrichten',
      one: '1 Nachricht als Favorit markiert',
    );
    return '$_temp0';
  }

  @override
  String chatFavoritePartial(Object failed, Object success) {
    return 'Favoriten abgeschlossen: $success erfolgreich, $failed fehlgeschlagen';
  }

  @override
  String get chatForwardUnavailable =>
      'Kann momentan nicht weitergeleitet werden';

  @override
  String chatMergedForwardedTo(Object count, Object name) {
    return '$count Nachrichten mit $name zusammengeführt';
  }

  @override
  String chatForwardedIndividuallyTo(Object count, Object name) {
    return '$count Nachrichten einzeln an $name weitergeleitet';
  }

  @override
  String chatForwardedPartialTo(Object name, Object sent, Object total) {
    return '$sent/$total Nachrichten an $name weitergeleitet';
  }

  @override
  String get chatForwardModeIndividual => 'Eins nach dem anderen weiterleiten';

  @override
  String get chatForwardModeMerge => 'Zusammenführen und weiterleiten';

  @override
  String get chatPresenceOnline => 'Online';

  @override
  String get chatPresenceOffline => 'Offline';

  @override
  String get chatPresenceJustActive => 'Gerade gerade aktiv';

  @override
  String chatPresenceMinutesAgo(Object minutes) {
    return 'Aktiv vor $minutes Minuten';
  }

  @override
  String chatPresenceHoursAgo(Object hours) {
    return 'Aktiv vor $hours Stunden';
  }

  @override
  String chatPresenceDaysAgo(Object days) {
    return 'Aktiv vor $days Tagen';
  }

  @override
  String get chatSensitiveDefaultTip =>
      'Diese Nachricht enthält möglicherweise vertrauliche Informationen';

  @override
  String get chatMessageDigestFallback => '[Nachricht]';

  @override
  String get chatMediaServiceUnavailable => 'Mediendienst ist nicht bereit';

  @override
  String get chatImDisconnected => 'IM ist nicht verbunden';

  @override
  String get chatPinFailedNotSent =>
      'Das Anheften ist nicht möglich, bevor die Nachricht den Server erreicht';

  @override
  String get chatPinFailed => 'Fehler beim Anheften. Versuchen Sie es erneut.';

  @override
  String get chatPinned => 'Angepinnt';

  @override
  String get chatUnpinFailed =>
      'Das Lösen der Fixierung ist fehlgeschlagen. Versuchen Sie es erneut.';

  @override
  String get chatUnpinned => 'Nicht angepinnt';

  @override
  String get chatClearPinnedConfirm =>
      'Alle angehefteten Nachrichten entfernen?';

  @override
  String get chatClearPinnedAction => 'Loslösen';

  @override
  String get chatAllUnpinned => 'Alle angehefteten Nachrichten wurden entfernt';

  @override
  String get chatPinnedMessageNotVisible =>
      'Diese Nachricht ist nicht im sichtbaren Bereich. Sehen Sie es sich in der Liste an.';

  @override
  String get chatImageMissing => 'Bildinformationen fehlen';

  @override
  String get chatImageDownloadFailedEdit =>
      'Bild konnte nicht heruntergeladen werden. Kann nicht bearbeitet werden.';

  @override
  String get chatReactionFailed =>
      'Reaktion fehlgeschlagen. Versuchen Sie es erneut.';

  @override
  String get chatEditNotSynced =>
      'Bearbeitung fehlgeschlagen: Nachricht ist nicht synchronisiert';

  @override
  String get chatEditFailed =>
      'Bearbeiten fehlgeschlagen. Versuchen Sie es erneut.';

  @override
  String get chatFavoriteUnsupportedType =>
      'Dieser Typ kann noch nicht zu den Favoriten hinzugefügt werden';

  @override
  String get chatFavoriteNotSent =>
      'Die Nachricht hat den Server nicht erreicht und kann daher nicht zu den Favoriten hinzugefügt werden';

  @override
  String get chatFavoriteSuccess => 'Zu den Favoriten hinzugefügt';

  @override
  String get chatFavoriteFailed =>
      'Favorit konnte nicht hinzugefügt werden. Versuchen Sie es erneut.';

  @override
  String chatToolSelected(Object title) {
    return 'Ausgewählt $title';
  }

  @override
  String chatCardDigest(Object name) {
    return '[Karte] $name';
  }

  @override
  String get chatFriendAvatarFallback => 'F';

  @override
  String get chatUnknownMessageDigest => '[Unbekannt]';

  @override
  String chatOpenFromContacts(Object name) {
    return 'Öffnen Sie den Chat von @$name über Kontakte';
  }

  @override
  String get chatLoadingCard => 'Kontaktkarte wird geladen...';

  @override
  String get chatFileMissing => 'Dateiinformationen fehlen';

  @override
  String get chatVideoUnavailable => 'Video kann nicht abgespielt werden';

  @override
  String get chatVideoSourceEmpty => 'Die Videoquelle ist leer';

  @override
  String get chatLivePhotoUnavailable =>
      'Live Photo kann nicht abgespielt werden';

  @override
  String get messageAiTranslating => 'Übersetzen...';

  @override
  String get messageAiTranscribedShort => 'Fertig';

  @override
  String get messageAiVoiceSendingWait =>
      'Voice sendet immer noch. Versuchen Sie es später noch einmal.';

  @override
  String get messageAiNoTranscript => 'Keine Sprache erkannt';

  @override
  String get messageAiMessageSendingWait =>
      'Nachricht wird immer noch gesendet. Versuchen Sie es später noch einmal.';

  @override
  String get messageAiNoTranslation => 'Kein Übersetzungsergebnis';

  @override
  String get messageAiTemporarilyUnavailable => 'Vorübergehend nicht verfügbar';

  @override
  String get chatVoiceFileUnavailable => 'Sprachdatei ist nicht verfügbar';

  @override
  String get chatVoicePlayFailed =>
      'Wiedergabe fehlgeschlagen. Versuchen Sie es erneut.';

  @override
  String get chatVoiceHoldToRecord =>
      'Zum Aufnehmen gedrückt halten · Zum Abbrechen nach oben schieben';

  @override
  String chatVoiceReleaseToCancel(Object duration) {
    return 'Freigabe zum Stornieren ($duration)';
  }

  @override
  String chatVoiceRecordingSlideCancel(Object duration) {
    return '$duration · Zum Abbrechen nach oben schieben';
  }

  @override
  String get chatQrcodeNotFound => 'Kein QR-Code erkannt';

  @override
  String chatWebLoginQrcodeDetected(Object payload) {
    return 'Web Login-QR-Code erkannt\n$payload';
  }

  @override
  String get chatWebLoginConfirmTitle => 'Anmeldung im Web bestätigen?';

  @override
  String get chatWebLoginConfirmAction => 'Bestätigen Sie die Web Anmeldung';

  @override
  String get chatWebLoginConfirmed => 'Web Anmeldung bestätigt';

  @override
  String chatQrcodeDetected(Object payload) {
    return 'QR-Code erkannt\n$payload';
  }

  @override
  String get chatStickerPlaceholder => '[Aufkleber]';

  @override
  String get chatStickerAdded => 'Zu Aufklebern hinzugefügt';

  @override
  String get chatStickerAddFailed =>
      'Aufkleber konnte nicht hinzugefügt werden. Versuchen Sie es erneut.';

  @override
  String get mentionAllMembers => 'Alle Mitglieder';

  @override
  String get mentionAllMembersSubtitle =>
      'Alle in dieser Gruppe benachrichtigen';

  @override
  String get chatQuoteOriginalRevoked =>
      'Ursprüngliche Nachricht wurde zurückgerufen';

  @override
  String get chatRecognizeImageQrcode => 'QR-Code im Bild scannen';

  @override
  String get chatAddToStickers => 'Zu Aufklebern hinzufügen';

  @override
  String get chatGroupInviteApprovalUrlEmpty =>
      'Die Genehmigungs-URL für Gruppeneinladungen ist leer';

  @override
  String get chatGroupInviteApprovalTitle => 'Gruppeneinladungsgenehmigung';

  @override
  String get chatGroupInviteApprovalBody =>
      'Vervollständigen Sie die Gruppeneinladungsbestätigung auf der Webseite.';

  @override
  String get chatGroupInviteGoConfirm => 'Bestätigen';

  @override
  String get chatGroupInviteApprovalOpenFailed =>
      'Die Genehmigung der Gruppeneinladung konnte nicht geöffnet werden. Versuchen Sie es erneut.';

  @override
  String get chatSendFailed =>
      'Senden fehlgeschlagen. Versuchen Sie es erneut.';

  @override
  String get chatCallActiveHangupFirst =>
      'Ein Anruf ist aktiv. Legen Sie zuerst auf.';

  @override
  String get chatCallActiveCannotJoinAgain =>
      'Ein Anruf ist aktiv. Kann nicht erneut beitreten.';

  @override
  String get chatCallUnsupported =>
      'Aufrufe werden in dieser Version nicht unterstützt';

  @override
  String get chatCallServiceUnavailable => 'Der Anrufdienst ist nicht bereit';

  @override
  String get chatCallJoinFailedEnded =>
      'Beitritt fehlgeschlagen. Der Anruf wurde möglicherweise beendet.';

  @override
  String get callWaitingAnswer => 'Warten auf Antwort';

  @override
  String get callMessage => 'Anrufnachricht';

  @override
  String get callEnded => 'Anruf beendet';

  @override
  String get callPeerRefused => 'Peer lehnte ab';

  @override
  String get callPeerHungUp => 'Peer hat aufgelegt';

  @override
  String get callPeerDeclinedVideoSwitch =>
      'Peer lehnte die Videowechselanfrage ab';

  @override
  String get callSwitchVideoRequestTitle =>
      'Peer bittet um Umstellung auf Video';

  @override
  String get callAgree => 'Einverstanden';

  @override
  String get callReconnecting => 'Verbindung wird wiederhergestellt…';

  @override
  String get callWaitingPeerCamera => 'Warten auf Peer-Kamera';

  @override
  String get callSelfFallbackName => 'Ich';

  @override
  String get callUnknownUser => 'Unbekannter Benutzer';

  @override
  String callJoinedCount(int joined, int total) {
    return '$joined/$total beigetreten';
  }

  @override
  String get callMute => 'Stumm';

  @override
  String get callSpeaker => 'Sprecher';

  @override
  String get callSwitchToVideo => 'Video';

  @override
  String get callHangup => 'Auflegen';

  @override
  String get callFlipCamera => 'Umdrehen';

  @override
  String get callSwitchToVoice => 'Audio';

  @override
  String get callCamera => 'Kamera';

  @override
  String get callBack => 'Zurück';

  @override
  String get callPermissionMicrophone => 'Mikrofon';

  @override
  String get callPermissionMicrophoneCamera => 'Mikrofon und Kamera';

  @override
  String callPermissionOpenSettings(String what) {
    return 'Aktivieren Sie die Berechtigung $what in den Systemeinstellungen';
  }

  @override
  String callPermissionRequired(String what) {
    return 'Anrufe benötigen die Erlaubnis $what';
  }

  @override
  String get callWaitingPeerConsent => 'Warten auf Peer-Genehmigung';

  @override
  String get callSwitchRequestFailed =>
      'Fehler beim Senden der Wechselanforderung';

  @override
  String get callCameraPermissionRequired => 'Kameragenehmigung erforderlich';

  @override
  String get callCameraEnableFailed =>
      'Kamera konnte nicht eingeschaltet werden';

  @override
  String get incomingCallAccepting => 'Antworten...';

  @override
  String get incomingVideoCall => 'lädt Sie zu einem Videoanruf ein';

  @override
  String get incomingAudioCall => 'lädt Sie zu einem Sprachanruf ein';

  @override
  String incomingAcceptFailed(String error) {
    return 'Antwort fehlgeschlagen: $error';
  }

  @override
  String get incomingCallDecline => 'Ablehnen';

  @override
  String get incomingCallAccept => 'Antwort';

  @override
  String get chatGroupNoInviteCandidates =>
      'Es sind keine Mitglieder zum Einladen verfügbar';

  @override
  String get chatInviteGroupMembersVideo =>
      'Gruppenmitglieder einladen (Videoanruf)';

  @override
  String get chatInviteGroupMembersAudio =>
      'Gruppenmitglieder einladen (Sprachanruf)';

  @override
  String get chatSelfName => 'Ich';

  @override
  String get chatPeerPlaceholder => 'Sonstiges';

  @override
  String get chatSomeonePlaceholder => 'Jemand';

  @override
  String chatScreenshotNotice(Object name) {
    return '$name hat im Chat einen Screenshot gemacht';
  }

  @override
  String chatDuplicateGroupMention(Object name) {
    return 'Mehrere Gruppenmitglieder stimmen mit @$name überein';
  }

  @override
  String chatDuplicateContactMention(Object name) {
    return 'Mehrere Kontakte stimmen mit @$name überein';
  }

  @override
  String chatMentionNotFound(Object name) {
    return '@$name nicht gefunden';
  }

  @override
  String get chatForwardPickerTitle => 'Weiterleiten an';

  @override
  String get chatRecentContactsSection => 'Letzte Kontakte';

  @override
  String chatForwardedTo(Object name) {
    return 'Weitergeleitet an $name';
  }

  @override
  String get favoriteTitle => 'Favoriten';

  @override
  String get favoriteEmptyTitle => 'Keine Favoriten';

  @override
  String get favoriteEmptySubtitle =>
      'Drücken Sie lange auf eine Nachricht im Chat und wählen Sie „Favorit“, um sie hier zu speichern.';

  @override
  String get favoriteDeleted => 'Gelöscht';

  @override
  String favoriteDeleteFailed(Object error) {
    return 'Löschen fehlgeschlagen: $error';
  }

  @override
  String get favoriteDeleteFailedPlain => 'Löschen fehlgeschlagen';

  @override
  String get favoriteUnsupportedSend =>
      'Dieser Typ kann noch nicht gesendet werden';

  @override
  String favoriteSentTo(String name) {
    return 'Gesendet an $name';
  }

  @override
  String favoriteSendFailed(Object error) {
    return 'Senden fehlgeschlagen: $error';
  }

  @override
  String get favoriteSendFailedPlain => 'Senden fehlgeschlagen';

  @override
  String get favoriteSendToFriend => 'An einen Freund senden';

  @override
  String get favoriteCopied => 'Kopiert';

  @override
  String get favoriteUnknownUser => 'Unbekannter Benutzer';

  @override
  String favoriteDateMonthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String get groupSavedTitle => 'Gespeicherte Gruppen';

  @override
  String get groupSaveTooltip => 'Gruppe speichern';

  @override
  String get groupSearchHint => 'Suchgruppen';

  @override
  String get groupNoMatched => 'Keine passenden Gruppen';

  @override
  String get groupNoSaveCandidatesToast =>
      'Keine Gruppen zum Speichern verfügbar';

  @override
  String get groupSavedToContacts => 'In den Kontakten gespeichert';

  @override
  String groupSaveFailed(Object error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String get groupSelectTitle => 'Gruppe auswählen';

  @override
  String get groupNoSaveCandidates => 'Keine Gruppen zum Speichern verfügbar';

  @override
  String get groupCreateTitle => 'Gruppenchat starten';

  @override
  String get groupSearchContactsHint => 'Kontakte suchen';

  @override
  String get groupNoMatchedContacts => 'Keine passenden Kontakte';

  @override
  String groupMemberSummary(num count, Object subtitle) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder',
      one: '1 Mitglied',
    );
    return '$_temp0· $subtitle';
  }

  @override
  String get groupMuted => 'Stummgeschaltet';

  @override
  String get groupDetailsTitle => 'Gruppendetails';

  @override
  String groupMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder',
      one: '1 Mitglied',
    );
    return '$_temp0';
  }

  @override
  String get groupMembersSection => 'Gruppenmitglieder';

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
  String get groupNoMembers => 'Keine Gruppenmitglieder';

  @override
  String get groupInviteMembers => 'Mitglieder einladen';

  @override
  String get groupInviteMembersSubtitle => 'Wählen Sie aus Kontakten';

  @override
  String get groupRemoveMembers => 'Mitglieder entfernen';

  @override
  String get groupRemoveMembersEmptySubtitle =>
      'Keine Mitglieder zum Entfernen';

  @override
  String get groupRemoveMembersSubtitle =>
      'Wählen Sie die zu entfernenden Mitglieder aus';

  @override
  String get groupQrCodeTitle => 'Gruppen-QR-Code';

  @override
  String get groupQrCodeSubtitle => 'Scannen, um dieser Gruppe beizutreten';

  @override
  String get groupNameTitle => 'Gruppenname';

  @override
  String get groupNoticeTitle => 'Gruppenankündigung';

  @override
  String get groupNoticeUnset => 'Nicht festgelegt';

  @override
  String get groupManageTitle => 'Gruppenleitung';

  @override
  String get groupManageSubtitle =>
      'Administratoren, Stummschaltung und Gruppenberechtigungen';

  @override
  String get groupInviteConfirm => 'Einladungsbestätigung';

  @override
  String get groupBlacklistTitle => 'Gruppen-Blacklist';

  @override
  String get groupBlacklistSubtitle =>
      'Mitglieder verwalten, denen das Sprechen oder Beitreten verweigert wurde';

  @override
  String get groupSaveToContacts => 'In den Kontakten speichern';

  @override
  String get groupMuteMessages => 'Benachrichtigungen stummschalten';

  @override
  String get groupExited => 'Gruppenchat verlassen';

  @override
  String get groupExitAction => 'Gruppe verlassen';

  @override
  String groupMembersSyncFailed(Object error) {
    return 'Gruppenmitglieder konnten nicht synchronisiert werden: $error';
  }

  @override
  String get groupInvitePickerTitle =>
      'Wählen Sie die einzuladenden Mitglieder aus';

  @override
  String groupInviteSentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitgliedereinladungen gesendet',
      one: '1 Mitgliedereinladung gesendet',
    );
    return '$_temp0';
  }

  @override
  String groupInvitedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eingeladene $count Mitglieder',
      one: '1 Mitglied eingeladen',
    );
    return '$_temp0';
  }

  @override
  String groupInviteMembersFailed(Object error) {
    return 'Mitglieder konnten nicht eingeladen werden: $error';
  }

  @override
  String get groupRemovePickerTitle =>
      'Wählen Sie die zu entfernenden Mitglieder aus';

  @override
  String groupQuotedMemberName(Object name) {
    return '„$name“';
  }

  @override
  String groupSelectedMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder',
      one: '1 Mitglied',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersConfirm(Object target) {
    return '$target aus dieser Gruppe entfernen?';
  }

  @override
  String get groupRemoveAction => 'Entfernen';

  @override
  String groupRemovedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder entfernt',
      one: '1 Mitglied entfernt',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersFailed(Object error) {
    return 'Mitglieder konnten nicht entfernt werden: $error';
  }

  @override
  String get groupSettingsUpdated => 'Gruppeneinstellungen aktualisiert';

  @override
  String groupSettingsUpdateFailed(Object error) {
    return 'Gruppeneinstellungen konnten nicht aktualisiert werden: $error';
  }

  @override
  String get groupExitConfirm =>
      'Nach dem Verlassen erhalten Sie keine Nachrichten mehr von dieser Gruppe.';

  @override
  String get groupExitSuccess => 'Gruppenchat verlassen';

  @override
  String groupExitFailed(Object error) {
    return 'Verlassen fehlgeschlagen: $error';
  }

  @override
  String get groupOwnerAdminSection => 'Eigentümer und Administratoren';

  @override
  String get groupOwnerRole => 'Eigentümer';

  @override
  String get groupAdminRole => 'Admin';

  @override
  String get groupRemove => 'Entfernen';

  @override
  String get groupAddAdmin => 'Gruppenadministrator hinzufügen';

  @override
  String get groupNoAdmins => 'Keine Administratoren';

  @override
  String get groupInviteConfirmRemark =>
      'Wenn diese Option aktiviert ist, benötigen Mitglieder die Genehmigung des Eigentümers oder Administrators, bevor sie Freunde einladen können. Auch die Teilnahme per QR-Code wird deaktiviert.';

  @override
  String get groupOwnerTransfer => 'Eigentum übertragen';

  @override
  String get groupMemberSettingsSection => 'Mitgliedereinstellungen';

  @override
  String get groupAllMutedRemark =>
      'Wenn die Stummschaltung für alle Mitglieder aktiviert ist, können nur der Eigentümer und die Administratoren sprechen.';

  @override
  String get groupAllMuted => 'Alle Mitglieder stumm schalten';

  @override
  String get groupForbiddenAddFriendRemark =>
      'Wenn diese Option aktiviert ist, können Mitglieder über diese Gruppe keine Freunde hinzufügen.';

  @override
  String get groupForbiddenAddFriend =>
      'Mitglieder daran hindern, Freunde hinzuzufügen';

  @override
  String get groupAllowHistoryRemark =>
      'Wenn diese Option aktiviert ist, können neue Mitglieder den vorherigen Chat-Verlauf sehen.';

  @override
  String get groupAllowHistory =>
      'Erlauben Sie neuen Mitgliedern, den Verlauf anzuzeigen';

  @override
  String get groupAddAdminPickerTitle => 'Gruppenadministrator hinzufügen';

  @override
  String groupAdminAddedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Administratoren hinzugefügt',
      one: '1 Administrator hinzugefügt',
    );
    return '$_temp0';
  }

  @override
  String groupAddAdminFailed(Object error) {
    return 'Administrator konnte nicht hinzugefügt werden: $error';
  }

  @override
  String groupRemoveAdminConfirm(Object name) {
    return 'Administratorrolle von „$name“ entfernen?';
  }

  @override
  String get groupRemoveAdminAction => 'Admin entfernen';

  @override
  String get groupRemoveAdminSuccess => 'Administrator entfernt';

  @override
  String groupRemoveAdminFailed(Object error) {
    return 'Administrator konnte nicht entfernt werden: $error';
  }

  @override
  String get groupSelectNewOwner => 'Wählen Sie „Neuer Besitzer“.';

  @override
  String groupTransferOwnerConfirm(Object name) {
    return 'Eigentum an „$name“ übertragen? Sie werden ordentliches Mitglied.';
  }

  @override
  String get groupTransferOwnerAction => 'Übertragung bestätigen';

  @override
  String get groupOwnerTransferred => 'Eigentum übertragen';

  @override
  String groupOwnerTransferFailed(Object error) {
    return 'Eigentumsübertragung fehlgeschlagen: $error';
  }

  @override
  String get groupNoticePublisherDefault => 'Gruppenankündigung';

  @override
  String get groupNoticePublishTitle => 'Gruppenankündigung posten';

  @override
  String get groupNoticeEditTitle => 'Gruppenankündigung bearbeiten';

  @override
  String get groupNoticePublishAction => 'Beitrag';

  @override
  String get groupNoticeEmpty => 'Keine Gruppenankündigung';

  @override
  String get groupNoticePublishedAtUnknown => 'Veröffentlichungszeit unbekannt';

  @override
  String get groupMemberRemarkTitle => 'Mein Spitzname in dieser Gruppe';

  @override
  String get groupMemberRemarkHint =>
      'Legen Sie Ihren Spitznamen in dieser Gruppe fest';

  @override
  String get groupQrCodeEmpty => 'Kein Gruppen-QR-Code';

  @override
  String groupQrCodeValid(Object day, Object expire) {
    return 'Dieser QR-Code ist $day Tage ($expire) gültig.';
  }

  @override
  String get groupQrCodeScanToJoin =>
      'Scannen Sie den QR-Code, um dieser Gruppe beizutreten';

  @override
  String get groupBlacklistLoadFailed =>
      'Die Blacklist konnte nicht geladen werden. Versuchen Sie es erneut.';

  @override
  String get groupBlacklistEmpty => 'Keine Mitglieder auf der schwarzen Liste';

  @override
  String get groupBlacklistAddMember => 'Blacklist-Mitglied hinzufügen';

  @override
  String get groupBlacklistNoCandidates =>
      'Der Blacklist können keine Mitglieder hinzugefügt werden';

  @override
  String get groupSelectMember => 'Mitglied auswählen';

  @override
  String get groupBlacklistAdded => 'Zur schwarzen Liste hinzugefügt';

  @override
  String get groupBlacklistAddFailed =>
      'Das Hinzufügen zur Blacklist ist fehlgeschlagen. Versuchen Sie es erneut.';

  @override
  String groupBlacklistRemoveConfirm(Object name) {
    return '„$name“ aus der Gruppen-Blacklist entfernen?';
  }

  @override
  String get groupBlacklistRemoveAction => 'Von der Blacklist entfernen';

  @override
  String get groupBlacklistRemoveFailed =>
      'Das Entfernen aus der Blacklist ist fehlgeschlagen. Versuchen Sie es erneut.';

  @override
  String get groupAvatarTitle => 'Gruppen-Avatar';

  @override
  String get groupAvatarTakePhoto => 'Machen Sie ein Foto';

  @override
  String get groupAvatarChooseFromAlbum => 'Aus Album auswählen';

  @override
  String get groupAvatarSaveImage => 'Bild speichern';

  @override
  String get groupAvatarUnsupported =>
      'Dieser Chat unterstützt das Ändern des Gruppenavatars nicht';

  @override
  String get groupAvatarUpdated => 'Gruppenavatar aktualisiert';

  @override
  String get groupAvatarUpdateFailed =>
      'Gruppen-Avatar konnte nicht aktualisiert werden. Versuchen Sie es erneut.';

  @override
  String get groupAvatarNoImageToSave => 'Kein Avatar zum Speichern';

  @override
  String groupPhotoPermissionRequired(Object appName) {
    return 'Erlaube $appName den Zugriff auf deine Fotos';
  }

  @override
  String get groupImageSavedToAlbum => 'Im Album gespeichert';

  @override
  String get groupImageSaveFailed =>
      'Speichern fehlgeschlagen. Versuchen Sie es erneut.';

  @override
  String get imageEditorProcessing => 'Wird bearbeitet...';

  @override
  String get imageEditorDiscardTitle => 'Änderungen verwerfen?';

  @override
  String get imageEditorDiscardMessage =>
      'Nicht gespeicherte Änderungen gehen verloren.';

  @override
  String get imageEditorDiscardConfirm => 'Verwerfen';

  @override
  String get imageEditorPaint => 'Zeichnen';

  @override
  String get imageEditorFreestyle => 'Freihand';

  @override
  String get imageEditorArrow => 'Pfeil';

  @override
  String get imageEditorLine => 'Zeile';

  @override
  String get imageEditorRectangle => 'Rechteck';

  @override
  String get imageEditorCircle => 'Kreis';

  @override
  String get imageEditorDashLine => 'Gestrichelte Linie';

  @override
  String get imageEditorMoveAndZoom => 'Verschieben / Zoomen';

  @override
  String get imageEditorEraser => 'Radiergummi';

  @override
  String get imageEditorLineWidth => 'Breite';

  @override
  String get imageEditorToggleFill => 'Füllen';

  @override
  String get imageEditorOpacity => 'Deckkraft';

  @override
  String get imageEditorUndo => 'Rückgängig machen';

  @override
  String get imageEditorRedo => 'Wiederholen';

  @override
  String get imageEditorInputHint => 'Geben Sie Text ein';

  @override
  String get imageEditorText => 'Text';

  @override
  String get imageEditorTextAlign => 'Ausrichten';

  @override
  String get imageEditorBackground => 'Hintergrund';

  @override
  String get imageEditorFontScale => 'Schriftgröße';

  @override
  String get imageEditorCrop => 'Zuschneiden';

  @override
  String get imageEditorRotate => 'Drehen';

  @override
  String get imageEditorRatio => 'Verhältnis';

  @override
  String get imageEditorReset => 'Zurücksetzen';

  @override
  String get imageEditorFlip => 'Umdrehen';

  @override
  String get imageEditorFilter => 'Filter';

  @override
  String get imageEditorFilterNone => 'Original';

  @override
  String get imageEditorFilterAddictiveBlue => 'Süchtig machendes Blau';

  @override
  String get imageEditorFilterAddictiveRed => 'Süchtig machendes Rot';

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
  String get imageEditorFilterCharmes => 'Charme';

  @override
  String get imageEditorFilterClarendon => 'Clarendon';

  @override
  String get imageEditorFilterCrema => 'Crema';

  @override
  String get imageEditorFilterDogpatch => 'Hundepatch';

  @override
  String get imageEditorFilterEarlybird => 'Frühbucher';

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
  String get imageEditorFilterInkwell => 'Tintenfass';

  @override
  String get imageEditorFilterJuno => 'Juno';

  @override
  String get imageEditorFilterKelvin => 'Kelvin';

  @override
  String get imageEditorFilterLark => 'Lerche';

  @override
  String get imageEditorFilterLoFi => 'Lo-Fi';

  @override
  String get imageEditorFilterLudwig => 'Ludwig';

  @override
  String get imageEditorFilterMaven => 'Maven';

  @override
  String get imageEditorFilterMayfair => 'Mayfair';

  @override
  String get imageEditorFilterMoon => 'Mond';

  @override
  String get imageEditorFilterNashville => 'Nashville';

  @override
  String get imageEditorFilterPerpetua => 'Perpetua';

  @override
  String get imageEditorFilterReyes => 'Reyes';

  @override
  String get imageEditorFilterRise => 'Aufstieg';

  @override
  String get imageEditorFilterSierra => 'Sierra';

  @override
  String get imageEditorFilterSkyline => 'Skyline';

  @override
  String get imageEditorFilterSlumber => 'Schlummer';

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
  String get imageEditorFilterWillow => 'Weide';

  @override
  String get imageEditorBlur => 'Unschärfe';

  @override
  String get imageEditorTune => 'Anpassen';

  @override
  String get imageEditorBrightness => 'Helligkeit';

  @override
  String get imageEditorContrast => 'Kontrast';

  @override
  String get imageEditorSaturation => 'Sättigung';

  @override
  String get imageEditorExposure => 'Belichtung';

  @override
  String get imageEditorHue => 'Farbton';

  @override
  String get imageEditorTemperature => 'Temperatur';

  @override
  String get imageEditorSharpness => 'Schärfe';

  @override
  String get imageEditorFade => 'Verblassen';

  @override
  String get imageEditorLuminance => 'Leuchtdichte';

  @override
  String get imageEditorEmoji => 'Emoji';

  @override
  String get imageEditorEmojiRecent => 'Neu';

  @override
  String get imageEditorEmojiSmileys => 'Smileys';

  @override
  String get imageEditorEmojiAnimals => 'Tiere';

  @override
  String get imageEditorEmojiFood => 'Essen';

  @override
  String get imageEditorEmojiActivities => 'Aktivitäten';

  @override
  String get imageEditorEmojiTravel => 'Reisen';

  @override
  String get imageEditorEmojiObjects => 'Objekte';

  @override
  String get imageEditorEmojiSymbols => 'Symbole';

  @override
  String get imageEditorEmojiFlags => 'Flaggen';

  @override
  String get imageEditorSticker => 'Aufkleber';

  @override
  String get imageEditorRemove => 'Entfernen';

  @override
  String get imageEditorSaving => 'Speichern...';

  @override
  String get imageEditorImporting => 'Importieren';

  @override
  String get imagePreviewTitle => 'Bildvorschau';

  @override
  String get imagePreviewSavingToAlbum => 'Speichern...';

  @override
  String get imagePreviewAddToSticker => 'Zu Aufklebern hinzufügen';

  @override
  String get imagePreviewAddingToSticker => 'Wird hinzugefügt...';

  @override
  String get imagePreviewRecognizeQr => 'QR-Code erkennen';

  @override
  String get imagePreviewRecognizingQr => 'Erkennen...';

  @override
  String get imagePreviewConfirmWebLogin => 'Bestätigen Sie die Web Anmeldung';

  @override
  String get imagePreviewConfirmingWebLogin => 'Bestätigt...';

  @override
  String get imagePreviewOpenLink => 'Link öffnen';

  @override
  String get imagePreviewImageNotDownloadedSave =>
      'Bild wurde noch nicht heruntergeladen';

  @override
  String get imagePreviewMediaUnavailable =>
      'Der Mediendienst ist nicht verfügbar';

  @override
  String get imagePreviewImageNotUploadedSticker =>
      'Bild wurde noch nicht hochgeladen';

  @override
  String get imagePreviewStickerUnavailable =>
      'Der Aufkleberdienst ist nicht verfügbar';

  @override
  String get imagePreviewAddedToSticker => 'Zu Aufklebern hinzugefügt';

  @override
  String get imagePreviewImageNotDownloadedRecognize =>
      'Bild wurde noch nicht heruntergeladen';

  @override
  String get imagePreviewQrNotFound => 'Kein QR-Code gefunden';

  @override
  String get imagePreviewWebLoginQrRecognized => 'Web Login-QR-Code erkannt';

  @override
  String get imagePreviewWebLinkRecognized => 'Web Link erkannt';

  @override
  String get imagePreviewQrRecognized => 'QR-Code erkannt';

  @override
  String get imagePreviewWebLoginConfirmed => 'Web Anmeldung bestätigt';

  @override
  String get pickerFileTitle => 'Wählen Sie Datei';

  @override
  String get pickerRecentFiles => 'Aktuelle Dateien';

  @override
  String get pickerSampleProjectFile => 'Projektnotizen.pdf';

  @override
  String get pickerSampleProjectFileSubtitle => '128 KB · Heute';

  @override
  String get pickerSampleScreenshotFile => 'Chat Screenshot.png';

  @override
  String get pickerSampleScreenshotFileSubtitle => '2,4 MB · Gestern';

  @override
  String get pickerContactTitle => 'Wählen Sie „Kontakt“.';

  @override
  String get pickerContactCardSection => 'Kontaktkarte senden';

  @override
  String get pickerSearchContacts => 'Kontakte suchen';

  @override
  String get pickerNoMatchingContacts => 'Keine passenden Kontakte';

  @override
  String get chatSendFailedShort => 'Senden fehlgeschlagen';

  @override
  String get chatResend => 'Erneut senden';

  @override
  String get chatStatusRead => 'Gelesen';

  @override
  String get pinnedMessageTitle => 'Angeheftete Nachricht';

  @override
  String pinnedMessageTitleWithIndex(int index, int total) {
    return 'Angeheftete Nachricht $index/$total';
  }

  @override
  String get pinnedMessageOpen => 'Zum Anzeigen tippen';

  @override
  String get pinnedMessageViewAllTooltip => 'Alle angepinnt anzeigen';

  @override
  String get pinnedMessageUnpinTooltip => 'Loslösen';

  @override
  String pinnedMessageListCount(int count) {
    return '$count Angepinnte Nachrichten';
  }

  @override
  String get pinnedMessageClearAll => 'Alle lösen';

  @override
  String get pinnedMessageFallback => 'Angeheftete Nachricht';

  @override
  String get fileUnnamed => 'Datei ohne Titel';

  @override
  String get fileNoDownloadUrl => 'Kein Download-Link verfügbar';

  @override
  String get fileTitle => 'Datei';

  @override
  String fileSizeLabel(String size) {
    return 'Dateigröße: $size';
  }

  @override
  String get fileDownloadFailed => 'Download fehlgeschlagen';

  @override
  String get filePreview => 'Vorschau';

  @override
  String get fileOpenWithOtherApp => 'In anderer App öffnen';

  @override
  String get actionEnable => 'Aktivieren';

  @override
  String get actionDisable => 'Deaktivieren';

  @override
  String get profileInviteLoading => 'Einladungscode wird geladen';

  @override
  String get profileInviteEnabled => 'Einladungscode aktiviert';

  @override
  String get profileInviteDisabled => 'Einladungscode deaktiviert';

  @override
  String profileInviteLoadFailed(String error) {
    return 'Einladungscode konnte nicht geladen werden: $error';
  }

  @override
  String get profileInviteCopied => 'Kopiert';

  @override
  String profileInviteUpdateFailed(String error) {
    return 'Einladungscode konnte nicht aktualisiert werden: $error';
  }

  @override
  String get stickerStoreTitle => 'Aufkleberladen';

  @override
  String get stickerNoPacks => 'Keine Aufkleberpakete';

  @override
  String get stickerDetailTitle => 'Aufkleberdetails';

  @override
  String get stickerProcessing => 'Wird verarbeitet...';

  @override
  String get stickerAddCustomTitle =>
      'Benutzerdefinierten Aufkleber hinzufügen';

  @override
  String get stickerSortTitle => 'Aufkleber sortieren';

  @override
  String get stickerMyStickersTitle => 'Meine Aufkleber';

  @override
  String get stickerSaving => 'Speichern';

  @override
  String get stickerSortAction => 'Sortieren';

  @override
  String get stickerOrganize => 'Organisieren';

  @override
  String get stickerCustomTitle => 'Individuelle Aufkleber';

  @override
  String get stickerCustomSubtitle =>
      'Gespeicherte benutzerdefinierte Aufkleber verwalten';

  @override
  String get stickerNoSortablePacks => 'Keine Aufkleberpakete zum Sortieren';

  @override
  String get stickerNoCategories => 'Keine Aufkleberkategorien';

  @override
  String get stickerMoveUp => 'Nach oben verschieben';

  @override
  String get stickerMoveDown => 'Nach unten verschieben';

  @override
  String get stickerNoCustomStickers => 'Keine benutzerdefinierten Aufkleber';

  @override
  String get stickerMoveToFront => 'Nach vorne verschieben';

  @override
  String get stickerDeleteConfirmTitle =>
      'Gelöschte Aufkleber können nicht wiederhergestellt werden';

  @override
  String get complaintTitle => 'Bericht';

  @override
  String get complaintHint => 'Beschreiben Sie das Problem';

  @override
  String get complaintType => 'Berichtstyp';

  @override
  String get complaintSubmitted => 'Bericht eingereicht';

  @override
  String get complaintSubmit => 'Bericht senden';

  @override
  String get complaintSubmitting => 'Einreichen…';

  @override
  String get complaintFallbackOtherViolation => 'Anderer Richtlinienverstoß';

  @override
  String get complaintFallbackFraud => 'Sonstiger Betrug oder Betrug';

  @override
  String get complaintFallbackAccountCompromised =>
      'Das Konto ist möglicherweise kompromittiert';

  @override
  String get chatBackgroundTitle => 'Chat-Hintergrund';

  @override
  String get chatBackgroundLoading => 'Chat-Hintergründe werden geladen';

  @override
  String get chatBackgroundEmpty => 'Keine Chat-Hintergründe';

  @override
  String get chatBackgroundDefault => 'Standardhintergrund';

  @override
  String chatBackgroundItem(int index) {
    return 'Hintergrund $index';
  }

  @override
  String get chatBackgroundPreviewTitle => 'Vorschau des Hintergrunds';

  @override
  String get chatBackgroundSet => 'Hintergrund festlegen';

  @override
  String get chatBackgroundSelectedStatus => 'Chat-Hintergrund eingestellt';

  @override
  String get chatBackgroundInUse => 'In Verwendung';

  @override
  String get chatContactFallback => 'Kontakt';

  @override
  String get chatPersonalCard => 'Kontaktkarte';

  @override
  String get chatSystemMessageDigest => '[Systemmeldung]';

  @override
  String get chatMessageDigestMessage => '[Nachricht]';

  @override
  String get chatMessageDigestImage => '[Bild]';

  @override
  String get chatMessageDigestVoice => '[Stimme]';

  @override
  String get chatMessageDigestVideo => '[Video]';

  @override
  String get chatMessageDigestLocation => '[Standort]';

  @override
  String get chatMessageDigestCard => '[Kontaktkarte]';

  @override
  String get chatMessageDigestFile => '[Datei]';

  @override
  String get chatMessageDigestHistory => '[Chat-Verlauf]';

  @override
  String get chatMessageDigestSticker => '[Aufkleber]';

  @override
  String get dateWeekdayShortMonday => 'Mo';

  @override
  String get dateWeekdayShortTuesday => 'Di';

  @override
  String get dateWeekdayShortWednesday => 'Mi';

  @override
  String get dateWeekdayShortThursday => 'Do';

  @override
  String get dateWeekdayShortFriday => 'Fr';

  @override
  String get dateWeekdayShortSaturday => 'Sa';

  @override
  String get dateWeekdayShortSunday => 'So';

  @override
  String get appIconClassic => 'Klassisch';

  @override
  String get appIconSimple => 'Einfach';

  @override
  String get appIconDark => 'Dunkel';

  @override
  String get appIconFestive => 'Festlich';

  @override
  String get appIconGradient => 'Farbverlauf';

  @override
  String get appIconUpdated => 'Symbol aktualisiert';

  @override
  String get appIconUpdateFailed =>
      'Switch fehlgeschlagen. Versuchen Sie es später noch einmal.';

  @override
  String get appearanceBubbleColorPurple => 'Lila';

  @override
  String get appearanceBubbleColorGreen => 'Grün';

  @override
  String get appearanceBubbleColorBlue => 'Blau';

  @override
  String get appearanceBubbleColorOrange => 'Orange';

  @override
  String get appearanceBubbleColorPink => 'Rosa';

  @override
  String replyPreviewTitle(String name) {
    return 'Antwort auf $name';
  }

  @override
  String get replyPreviewCancel => 'Antwort abbrechen';

  @override
  String get chatPasswordTitle => 'Chat-Passwort';

  @override
  String get chatPasswordHint => 'Geben Sie ein 6-stelliges Passwort ein';

  @override
  String chatPasswordErrorRemain(int remain) {
    return 'Falsches Passwort. Der Chatverlauf wird nach $remain weiteren fehlgeschlagenen Versuchen gelöscht.';
  }

  @override
  String get emojiPackEmpty => 'In diesem Paket sind keine Aufkleber enthalten';

  @override
  String get emojiRecentSection => 'Neu';

  @override
  String get emojiAllSection => 'Alle Emoji';

  @override
  String get stickerSearching => 'Suche...';

  @override
  String get stickerNoSearchResults => 'Keine Ergebnisse';

  @override
  String get stickerSearchResultsTitle => 'Ergebnisse:';

  @override
  String get homeChatPasswordWiped =>
      'Zu viele falsche Versuche. Der Chatverlauf wurde gelöscht.';

  @override
  String get homeGroupNotFound => 'Gruppenchat nicht gefunden';

  @override
  String get homeConversationNoHistory => 'Kein Chatverlauf';

  @override
  String get homeConversationStartChat => 'Chat starten';

  @override
  String get homeEnterGroupChat => 'Betreten Sie den Gruppenchat';

  @override
  String get homeNewGroup => 'Neuer Gruppenchat';

  @override
  String homeFriendRequestAcceptFailed(String error) {
    return 'Annahme fehlgeschlagen: $error';
  }

  @override
  String get homeFriendRequestAccepted => 'Freundschaftsanfrage angenommen';

  @override
  String homeFriendRequestRefuseFailed(String error) {
    return 'Ablehnung fehlgeschlagen: $error';
  }

  @override
  String homeFriendRequestDeleteFailed(String error) {
    return 'Fehler beim Löschen: $error';
  }

  @override
  String contactPresenceOnlineWithDevice(String device) {
    return 'Online am $device';
  }

  @override
  String contactPresenceJustOnlineWithDevice(String device) {
    return 'gerade online am $device';
  }

  @override
  String contactPresenceMinutesOnlineWithDevice(int minutes, String device) {
    return 'Online am $device vor $minutes Minuten';
  }

  @override
  String contactPresenceLastOnline(String time) {
    return 'Zuletzt online $time';
  }

  @override
  String get contactPresenceDeviceWeb => 'web';

  @override
  String get contactPresenceDeviceDesktop => 'Desktop';

  @override
  String get contactPresenceDeviceMobile => 'Mobil';

  @override
  String get botCommandsEmpty => 'Noch keine Befehle';
}
