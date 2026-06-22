// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get tabMessages => 'Chatgesprekken';

  @override
  String get tabContacts => 'Contacten';

  @override
  String get tabDiscover => 'Ontdek';

  @override
  String get tabMe => 'Ik';

  @override
  String get pageMessagesTitle => 'Chatgesprekken';

  @override
  String get pageContactsTitle => 'Contacten';

  @override
  String get pageDiscoverTitle => 'Ontdek';

  @override
  String get pageMeTitle => 'Ik';

  @override
  String get actionCancel => 'Annuleren';

  @override
  String get actionConfirm => 'Bevestigen';

  @override
  String get actionDone => 'Klaar';

  @override
  String get actionSave => 'Opslaan';

  @override
  String get actionDelete => 'Verwijderen';

  @override
  String get actionEdit => 'Bewerken';

  @override
  String get actionAdd => 'Toevoegen';

  @override
  String get actionRemove => 'Verwijderen';

  @override
  String get actionInvite => 'Uitnodigen';

  @override
  String get actionSearch => 'Zoeken';

  @override
  String get actionSend => 'Verzenden';

  @override
  String get actionRetry => 'Opnieuw proberen';

  @override
  String get actionBack => 'Terug';

  @override
  String get actionMore => 'Meer';

  @override
  String get actionJoin => 'Doe mee';

  @override
  String get actionSkip => 'Overslaan';

  @override
  String get actionContinue => 'Ga verder';

  @override
  String get actionGetStarted => 'Aan de slag';

  @override
  String get actionSaving => 'Opslaan...';

  @override
  String get moduleUnsupported =>
      'Deze functie is niet beschikbaar in deze versie';

  @override
  String get moduleLoading =>
      'Functietoegang controleren. Probeer het later opnieuw.';

  @override
  String get moduleOfflineStale =>
      'Maak verbinding met het netwerk om toegang tot de functies te bevestigen';

  @override
  String get onboardingMenuTitle => 'Korte handleiding';

  @override
  String onboardingChatTitle(Object appName) {
    return 'Welkom bij $appName';
  }

  @override
  String get onboardingChatSubtitle =>
      'Een schone, lichte plek voor comfortabelere gesprekken.';

  @override
  String get onboardingFriendsTitle => 'Maak contact houden eenvoudig';

  @override
  String get onboardingFriendsSubtitle =>
      'Vrienden, groepen en delen zijn gemakkelijker te vinden.';

  @override
  String get onboardingSecurityTitle =>
      'Spreek vrijuit. Gebruik het met vertrouwen.';

  @override
  String get onboardingSecuritySubtitle =>
      'Accountbeveiliging en privacybescherming helpen uw grenzen te bewaken.';

  @override
  String get onboardingChatSemantic =>
      'Illustratie van onboarding van berichtsynchronisatie';

  @override
  String get onboardingFriendsSemantic =>
      'Illustratie van onboarding van vrienden en groepen';

  @override
  String get onboardingSecuritySemantic =>
      'Onboarding-illustratie voor beveiliging en privacy';

  @override
  String get settingsLanguageRow => 'Taal';

  @override
  String get settingsLanguageSystem => 'Systeemstandaard';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => 'Engels';

  @override
  String get profileRowFavorites => 'Favorieten';

  @override
  String get profileRowSecurityPrivacy => 'Beveiliging en privacy';

  @override
  String get profileRowNotifications => 'Meldingen';

  @override
  String get profileRowInviteCode => 'Uitnodigingscode';

  @override
  String get profileRowGeneral => 'Algemeen';

  @override
  String profileRowAbout(Object appName) {
    return 'Over $appName';
  }

  @override
  String get profileLogout => 'Uitloggen';

  @override
  String get profileLogoutConfirm =>
      'Uitloggen verwijdert geen geschiedenis. U kunt op elk gewenst moment weer inloggen met dit account.';

  @override
  String profileMoyuIdLabel(Object appName, Object value) {
    return '$appName ID: $value';
  }

  @override
  String get profileDefaultName => 'Ik';

  @override
  String get profileDetailTitle => 'Profiel';

  @override
  String get profileAvatar => 'Avatar';

  @override
  String get profileNickname => 'Bijnaam';

  @override
  String get profileEditNickname => 'Bijnaam bewerken';

  @override
  String profileEditFoxId(Object appName) {
    return 'Bewerk $appName ID';
  }

  @override
  String get profileGender => 'Geslacht';

  @override
  String get profileGenderMale => 'Man';

  @override
  String get profileGenderFemale => 'Vrouw';

  @override
  String get profileGenderSelected => 'Geselecteerd';

  @override
  String get profileGenderUnset => 'Niet ingesteld';

  @override
  String get profilePhoneUnbound => 'Niet gekoppeld';

  @override
  String get profileAvatarUpdated => 'Avatar bijgewerkt';

  @override
  String get profileAvatarUpdateFailed =>
      'Kan avatar niet uploaden. Probeer het opnieuw.';

  @override
  String get generalPageTitle => 'Algemeen';

  @override
  String get generalFontSize => 'Lettergrootte';

  @override
  String get generalChatBackground => 'Chatachtergrond';

  @override
  String get generalDarkMode => 'Donkere modus';

  @override
  String get generalClearCache => 'Cache wissen';

  @override
  String get generalClearMessages => 'Chatgeschiedenis wissen';

  @override
  String get generalAppModules => 'Kenmerken';

  @override
  String get generalErrorLogs => 'Foutlogboeken';

  @override
  String get generalThirdShare => 'SDKs van derden';

  @override
  String get fontSizeSmall => 'Klein';

  @override
  String get fontSizeStandard => 'Standaard';

  @override
  String get fontSizeLarge => 'Groot';

  @override
  String get fontSizeExtraLarge => 'Extra groot';

  @override
  String get darkModeSystem => 'Systeemstandaard';

  @override
  String get darkModeLight => 'Licht';

  @override
  String get darkModeDark => 'Donker';

  @override
  String get valueConfigure => 'Configureren';

  @override
  String get valueManage => 'Beheer';

  @override
  String get valueClear => 'Duidelijk';

  @override
  String get valueUpload => 'Uploaden';

  @override
  String get valueDownload => 'Downloaden';

  @override
  String get valueView => 'Bekijken';

  @override
  String get valueEnabled => 'Ingeschakeld';

  @override
  String get valueDisabled => 'Uitgeschakeld';

  @override
  String get valueOn => 'Aan';

  @override
  String get valueOff => 'Uit';

  @override
  String get valueConfigured => 'Ingesteld';

  @override
  String get valueNotEnabled => 'Niet ingeschakeld';

  @override
  String get valueSelected => 'Geselecteerd';

  @override
  String get valueCurrentDevice => 'Dit apparaat';

  @override
  String get valueSdkInfo => 'SDK Info';

  @override
  String get statusProcessing => 'Verwerking';

  @override
  String get statusLoading => 'Bezig met laden';

  @override
  String get statusSending => 'Verzenden';

  @override
  String get statusSaving => 'Opslaan';

  @override
  String get statusSaved => 'Opgeslagen';

  @override
  String get statusSent => 'Verzonden';

  @override
  String get statusSubmitted => 'Verzonden';

  @override
  String get dateJustNow => 'Zojuist';

  @override
  String get dateToday => 'Vandaag';

  @override
  String get dateYesterday => 'Gisteren';

  @override
  String get dateDayBeforeYesterday => 'Eergisteren';

  @override
  String dateTodayTime(Object time) {
    return 'Vandaag $time';
  }

  @override
  String dateYesterdayTime(Object time) {
    return 'Gisteren $time';
  }

  @override
  String dateDayBeforeYesterdayTime(Object time) {
    return 'Twee dagen geleden $time';
  }

  @override
  String dateWeekdayTime(Object time, Object weekday) {
    return '$weekday $time';
  }

  @override
  String dateMonthDayTime(Object day, Object month, Object time) {
    return '$day-$month $time';
  }

  @override
  String dateYearMonthDayTime(
    Object day,
    Object month,
    Object time,
    Object year,
  ) {
    return '$day-$month-$year $time';
  }

  @override
  String dateMonthDay(Object day, Object month) {
    return '$day-$month';
  }

  @override
  String dateYearMonthDay(Object day, Object month, Object year) {
    return '$day-$month-$year';
  }

  @override
  String get weekdayMonday => 'maandag';

  @override
  String get weekdayTuesday => 'dinsdag';

  @override
  String get weekdayWednesday => 'woensdag';

  @override
  String get weekdayThursday => 'Donderdag';

  @override
  String get weekdayFriday => 'Vrijdag';

  @override
  String get weekdaySaturday => 'zaterdag';

  @override
  String get weekdaySunday => 'Zondag';

  @override
  String get dialogClearAllTitle => 'Alle chatgeschiedenis wissen?';

  @override
  String get dialogClearAllBody =>
      'Alle lokale chatgeschiedenis en gespreksitems worden verwijderd.';

  @override
  String get authLoginSubtitle =>
      'Log in met je telefoonnummer en blijf chatten met vrienden';

  @override
  String get authLoginIllustration => 'Inlogillustratie';

  @override
  String get authRegisterIllustration => 'Registerillustratie';

  @override
  String get authSecurityIllustration => 'Verificatieillustratie';

  @override
  String get authResetIllustration =>
      'Illustratie van wachtwoord opnieuw instellen';

  @override
  String get authServerLabel => 'Server';

  @override
  String get authServerCustomLabel => 'Custom server';

  @override
  String get authServerCustomHint => 'Enter server address';

  @override
  String get authPhoneLabel => 'Telefoonnummer';

  @override
  String get authPasswordLabel => 'Wachtwoord';

  @override
  String get authForgotPassword => 'Wachtwoord vergeten?';

  @override
  String get authLoginButton => 'Inloggen';

  @override
  String get authLoginLoading => 'Inloggen...';

  @override
  String get authRegisterButton => 'Registreren';

  @override
  String get authLoginWithApple => 'Sign in with Apple';

  @override
  String get authLoginWithGoogle => 'Sign in with Google';

  @override
  String get authLoginWithGithub => 'Sign in with GitHub';

  @override
  String get authLoginAgreementPrefix => 'Door in te loggen, ga je akkoord';

  @override
  String get authTermsTitle => 'Servicevoorwaarden';

  @override
  String get authAgreementConnector => 'en';

  @override
  String get authPrivacyTitle => 'Privacybeleid';

  @override
  String get authVerifyTitle => 'Verificatie-aanmelding';

  @override
  String authVerifySubtitleWithPhone(Object phone) {
    return 'Voer de code in die naar $phone is verzonden';
  }

  @override
  String get authVerifySubtitlePasswordFirst =>
      'Log eerst in met uw wachtwoord om de beveiligingsverificatie te starten';

  @override
  String get authVerifyButton => 'Verifiëren';

  @override
  String get authVerifyLoading => 'Verifiëren...';

  @override
  String get authResendCode => 'Geen code ontvangen? Opnieuw verzenden';

  @override
  String get authVerificationCodeSent => 'Verificatiecode verzonden';

  @override
  String get authVerificationCodeRequired => 'Voer de verificatiecode in';

  @override
  String get authVerificationCodeSixDigits => 'Voer de 6-cijferige code in';

  @override
  String get authPasswordResetTitle => 'Loginwachtwoord opnieuw instellen';

  @override
  String get authPasswordResetSubtitle =>
      'Controleer uw telefoonnummer en stel vervolgens een nieuw inlogwachtwoord in';

  @override
  String get authPasswordResetButton => 'Wachtwoord opnieuw instellen';

  @override
  String get authKickedTitle =>
      'Je account was ingelogd op een ander apparaat.';

  @override
  String get authSubmitting => 'Verzenden...';

  @override
  String get authVerificationCodeLabel => 'Verificatiecode';

  @override
  String get authGetVerificationCode => 'Ontvang code';

  @override
  String get authNewPasswordLabel => 'Nieuw wachtwoord';

  @override
  String get authPasswordResetSuccess => 'Wachtwoord opnieuw instellen';

  @override
  String authRegisterTitle(Object appName) {
    return 'Maak een $appName-account aan';
  }

  @override
  String get authRegisterSubtitle =>
      'Registreer met uw telefoonnummer en begin meteen met chatten';

  @override
  String get authCreateAccount => 'Account aanmaken';

  @override
  String get authNicknameLabel => 'Bijnaam';

  @override
  String get authInviteCodeRequiredLabel => 'Uitnodigingscode (vereist)';

  @override
  String authCodeRetryAfter(Object seconds) {
    return 'Opnieuw proberen over ${seconds}s';
  }

  @override
  String get authRegisterAgreement =>
      'Ik heb de Servicevoorwaarden en het Privacybeleid gelezen en ga hiermee akkoord';

  @override
  String get authInvalidPhone => 'Ongeldig telefoonnummer';

  @override
  String get authAcceptAgreementFirst =>
      'Ga eerst akkoord met de Servicevoorwaarden en het Privacybeleid';

  @override
  String get authCodeEmpty => 'Verificatiecode is vereist';

  @override
  String get authPasswordLengthInvalid =>
      'Wachtwoord moet 6-16 tekens bevatten';

  @override
  String get authInviteCodeEmpty => 'Uitnodigingscode is vereist';

  @override
  String get authRegisterSuccess => 'Succesvol geregistreerd';

  @override
  String get settingsCheckNewVersion => 'Controleer op updates';

  @override
  String get settingsChecking => 'Controleren';

  @override
  String get settingsVersionFound => 'Update beschikbaar';

  @override
  String get settingsUserAgreement => 'Servicevoorwaarden';

  @override
  String get settingsPrivacyPolicy => 'Privacybeleid';

  @override
  String get settingsView => 'Bekijken';

  @override
  String get settingsSwitchAccount => 'Van account wisselen';

  @override
  String get settingsCacheCleared => 'Cache gewist';

  @override
  String get settingsClearCacheSheetTitle =>
      'Afbeeldings-/videocache wissen?\nChatafbeeldingen, videocovers en avatars worden opnieuw gedownload.';

  @override
  String get settingsClearCacheAction => 'Cache wissen';

  @override
  String get settingsMessagesCleared => 'Chatgeschiedenis gewist';

  @override
  String settingsClearMessagesFailed(Object error) {
    return 'Kan chatgeschiedenis niet wissen: $error';
  }

  @override
  String get settingsAlreadyLatestVersion =>
      'Je gebruikt al de nieuwste versie';

  @override
  String get settingsCheckFailed => 'Controle mislukt';

  @override
  String settingsUpdateDialogTitle(Object version) {
    return 'Update beschikbaar\nNieuwste versie: $version';
  }

  @override
  String settingsUpdateDialogTitleWithDescription(
    Object description,
    Object version,
  ) {
    return 'Update beschikbaar\nNieuwste versie: $version\n$description';
  }

  @override
  String get settingsLater => 'Later';

  @override
  String get settingsUpdateNow => 'Nu bijwerken';

  @override
  String get settingsSaveFailedRetry =>
      'Kan niet opslaan. Probeer het opnieuw.';

  @override
  String get securityAllowPhoneSearch =>
      'Laat anderen mij vinden op telefoonnummer';

  @override
  String securityAllowFoxIdSearch(Object appName) {
    return 'Sta anderen toe mij te vinden op basis van $appName ID';
  }

  @override
  String get securitySearchRemark =>
      'Indien uitgeschakeld, kunnen andere gebruikers u niet vinden via de bovenstaande informatie.';

  @override
  String get securityJoinGroupNeedConfirm =>
      'Require confirmation to join groups';

  @override
  String get securityJoinGroupNeedConfirmRemark =>
      'When on, invitations to add you to a group must be confirmed by you first.';

  @override
  String get securityLoginPassword => 'Loginwachtwoord';

  @override
  String get securityChatPassword => 'Chatwachtwoord';

  @override
  String get securityScreenProtection => 'Schermbescherming';

  @override
  String get securityLockPassword => 'Wachtwoord vergrendelen';

  @override
  String get securityOfflineProtection => 'Offline schermvergrendeling';

  @override
  String get securityDeviceManagement => 'Inloggen apparaatbeheer';

  @override
  String get securityDeviceRemark =>
      'Bekijk en beheer apparaten, schakel inlogbeveiliging in en houd uw account veilig.';

  @override
  String get securityBlacklist => 'Zwarte lijst';

  @override
  String get securityAccountDeletion => 'Account verwijderen';

  @override
  String get accountDeletionBody =>
      'Het verwijderen van een account kan niet ongedaan worden gemaakt. Na bevestiging wordt er per sms een verificatiecode verzonden om de verwijdering te voltooien.';

  @override
  String get accountDeletionSubmitted => 'Verwijderingsverzoek ingediend';

  @override
  String get accountDeletionGetCode => 'Ontvang code';

  @override
  String get passwordResetInstruction =>
      'Voor het wijzigen van uw inlogwachtwoord is een sms-code vereist. Het nieuwe wachtwoord moet minimaal 6 tekens lang zijn.';

  @override
  String get accountPhoneLabel => 'Telefoonnummer';

  @override
  String get passwordRuleLabel => 'Wachtwoordregel';

  @override
  String get passwordAtLeastSix => 'Minimaal 6 tekens';

  @override
  String get passwordConfirmLabel => 'Wachtwoord bevestigen';

  @override
  String get passwordConfirmHint => 'Voer het aanmeldingswachtwoord opnieuw in';

  @override
  String get passwordChanged => 'Inlogwachtwoord gewijzigd';

  @override
  String get phoneRequired => 'Telefoonnummer is vereist';

  @override
  String get passwordMismatch => 'Wachtwoorden komen niet overeen';

  @override
  String get chatPasswordInstruction =>
      'Indien ingeschakeld, is dit 6-cijferige wachtwoord vereist voordat beveiligde chats worden geopend.';

  @override
  String get currentStatusLabel => 'Huidige status';

  @override
  String get passwordSixDigits => '6 cijfers';

  @override
  String get chatPasswordEnableAction => 'Chatwachtwoord inschakelen';

  @override
  String get loginPasswordRequired => 'Loginwachtwoord is vereist';

  @override
  String get chatPasswordSixDigitsRequired =>
      'Chatwachtwoord moet uit 6 cijfers bestaan';

  @override
  String get lockSetTitle =>
      'Stel een vergrendelingswachtwoord van 6 cijfers in';

  @override
  String lockSetSubtitle(Object appName) {
    return 'Vereist om $appName te ontgrendelen';
  }

  @override
  String get lockCurrentPromptTitle =>
      'Voer het huidige vergrendelingswachtwoord in';

  @override
  String get lockCurrentPromptSubtitle =>
      'Controleer dit voordat u het wijzigt of uitschakelt';

  @override
  String get lockAutoLock => 'Automatische vergrendeling';

  @override
  String get lockChangePassword => 'Wijzig het ontgrendelingswachtwoord';

  @override
  String get lockClosePassword => 'Schakel het ontgrendelingswachtwoord uit';

  @override
  String get lockWrongPassword => 'Verkeerd wachtwoord. Probeer het opnieuw.';

  @override
  String get lockSixDigitsRequired =>
      'Het vergrendelingswachtwoord moet uit 6 cijfers bestaan';

  @override
  String get lockInputTitle => 'Voer het vergrendelingswachtwoord in';

  @override
  String lockInputSubtitle(Object appName) {
    return 'Ontgrendel om $appName te blijven gebruiken';
  }

  @override
  String get lockSetFailed => 'Kan niet worden ingesteld. Probeer het opnieuw.';

  @override
  String get lockImmediately => 'Onmiddellijk';

  @override
  String get lockAfter5Minutes => 'Na 5 minuten weg';

  @override
  String get lockAfter30Minutes => 'Na 30 minuten weg';

  @override
  String get lockAfter1Hour => 'Na 1 uur rijden';

  @override
  String get deviceLoginProtection => 'Inlogbeveiliging';

  @override
  String get deviceProtectionRemark =>
      'Wanneer inlogbeveiliging is ingeschakeld, is beveiligingsverificatie vereist op onbekende apparaten. Aanbevolen voor accountveiligheid.';

  @override
  String get deviceNone => 'Geen ingelogde apparaten';

  @override
  String get deviceDebugName => 'Huidig apparaat';

  @override
  String get deviceDebugPlatform => 'iPhone/Android-foutopsporingsapparaat';

  @override
  String get deviceProtectionEnabled => 'Inlogbeveiliging ingeschakeld';

  @override
  String get deviceProtectionDisabled => 'Inlogbeveiliging uitgeschakeld';

  @override
  String get deviceProtectionUpdateFailed =>
      'Updaten van de inlogbeveiliging is mislukt. Probeer het opnieuw.';

  @override
  String get blacklistEmpty => 'Geen contacten op de zwarte lijst';

  @override
  String get switchAccountRecent => 'Recente accounts';

  @override
  String get switchAccountLoading => 'Recente accounts lezen';

  @override
  String get switchAccountAddOther =>
      'Voeg een ander account toe of log in op een ander account';

  @override
  String get switchAccountCurrent => 'Huidig';

  @override
  String get appModulesLoading => 'Functiemodules laden';

  @override
  String get appModulesEmpty => 'Geen featuremodules';

  @override
  String get appModulesUnavailable => 'Module niet beschikbaar';

  @override
  String get errorLogsLoading => 'Foutlogboeken lezen';

  @override
  String get errorLogsEmpty => 'Geen foutenlogboeken';

  @override
  String get errorLogFileName => 'Bestandsnaam';

  @override
  String get errorLogFileSize => 'Bestandsgrootte';

  @override
  String get errorLogGeneratedAt => 'Gegenereerd op';

  @override
  String get errorLogFilePath => 'Bestandspad';

  @override
  String get notificationReceiveNew => 'Ontvang nieuwe berichtmeldingen';

  @override
  String get notificationSound => 'Geluid';

  @override
  String get notificationVibration => 'Trillingen';

  @override
  String get notificationShowDetails => 'Meldingsdetails weergeven';

  @override
  String get notificationSystem => 'Systeemberichtmeldingen';

  @override
  String get notificationCalls => 'Audio-/video-oproepmeldingen';

  @override
  String get settingsGoToSystem => 'Instellingen';

  @override
  String aboutAppIconSemantic(Object appName) {
    return '$appName pictogram';
  }

  @override
  String aboutCopyright(Object appName) {
    return 'Auteursrecht © 2026\n$appName. Alle rechten voorbehouden.';
  }

  @override
  String get policyWebUrl => 'Web URL';

  @override
  String get appearanceTitle => 'Uiterlijk';

  @override
  String get appearanceAppIcon => 'App-pictogram';

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
  String get appearanceChatColor => 'Chatkleur';

  @override
  String get appearanceBubbleRadius => 'Bolhoekradius';

  @override
  String get appearanceBubbleColorInk => 'Inktzwart';

  @override
  String get appearanceSquare => 'Vierkant';

  @override
  String get appearanceRound => 'Rond';

  @override
  String get appearancePreviewOne => 'Wil hij dat ik rechts of linksaf ga? 🤔';

  @override
  String get appearancePreviewTwo => 'Juist. En, nou ja, maak het sterk.';

  @override
  String get appearancePreviewThree =>
      'Is dat alles? Ik heb het gevoel dat hij meer heeft gezegd dan dat. 😯';

  @override
  String get appearancePreviewFour =>
      'Dat is het dan ook. Ik stuur later een gesproken bericht met meer details.';

  @override
  String get contactsEmptyTitle => 'Nog geen contacten';

  @override
  String get contactsEmptySubtitle =>
      'Voeg vrienden toe rechtsboven of scan een profielkaart';

  @override
  String contactsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contacten',
      one: '1 contactpersoon',
    );
    return '$_temp0';
  }

  @override
  String get contactAddTooltip => 'Vriend toevoegen';

  @override
  String get contactSearchHint => 'Zoek contacten en groepen';

  @override
  String get contactSetRemark => 'Opmerking instellen';

  @override
  String get contactAddToBlacklist => 'Toevoegen aan zwarte lijst';

  @override
  String get contactDeleteFriend => 'Vriend verwijderen';

  @override
  String get contactAddedToBlacklist => 'Toegevoegd aan zwarte lijst';

  @override
  String get operationFailed => 'Bewerking mislukt. Probeer het opnieuw.';

  @override
  String operationFailedWithError(String error) {
    return 'Bewerking mislukt: $error';
  }

  @override
  String contactDeleteFriendConfirm(Object name) {
    return 'Vriend \"$name\" verwijderen?\nDe chatgeschiedenis wordt ook gewist.';
  }

  @override
  String get contactConfirmDelete => 'Bevestig verwijderen';

  @override
  String get contactDeleted => 'Vriend verwijderd';

  @override
  String get contactUnknownUser => 'Onbekende gebruiker';

  @override
  String get contactActionNewFriends => 'Nieuwe vrienden';

  @override
  String get contactActionSavedGroups => 'Opgeslagen groepen';

  @override
  String get contactSearchNoMatches => 'Geen overeenkomende contacten';

  @override
  String get addFriendTitle => 'Vriend toevoegen';

  @override
  String addFriendSearchHint(Object appName) {
    return 'Telefoon / $appName ID';
  }

  @override
  String get addFriendNotFound => 'Account niet gevonden';

  @override
  String get myQrCodeTitle => 'Mijn QR-code';

  @override
  String myQrCodeSubtitle(Object appName) {
    return 'Scan deze QR-code om mij toe te voegen op $appName';
  }

  @override
  String get myQrCodeEmpty => 'Geen QR-code';

  @override
  String get scanTitle => 'Scannen';

  @override
  String get scanQrNotFound => 'Geen QR-code herkend';

  @override
  String scanResolveFailed(String error) {
    return 'Kan QR-code niet parseren: $error';
  }

  @override
  String get scanUnrecognized => 'Deze QR-code kan niet worden herkend';

  @override
  String get scanInfoIncomplete => 'QR-code-informatie is onvolledig';

  @override
  String get scanSocialUnavailable => 'Sociale dienst is niet geïnitialiseerd';

  @override
  String get scanJoinedGroup => 'Deelgenomen aan groepschat';

  @override
  String get scanCannotOpenGroup => 'Deze pagina kan geen groepschats openen';

  @override
  String get scanGroupNotFound => 'Groepschat niet gevonden';

  @override
  String get scanOpenGroupFailed => 'Kan groepschat niet openen';

  @override
  String get scanSelfQr => 'Dit is je eigen QR-code';

  @override
  String get scanUserNotFound => 'Gebruiker niet gevonden';

  @override
  String get scanCameraPermissionRequired => 'Cameratoestemming vereist';

  @override
  String get scanOpenSettings => 'Instellingen openen';

  @override
  String get scanCameraUnavailable => 'Camera niet beschikbaar';

  @override
  String get scanAlbum => 'Album';

  @override
  String get scanLightOn => 'Licht aan';

  @override
  String get scanLightOff => 'Licht uit';

  @override
  String get scanQrCode => 'QR-code';

  @override
  String get scanGroupFallback => 'Groepschat';

  @override
  String get scanGroupLoadingInfo => 'Groepsinfo laden';

  @override
  String scanGroupMemberCount(int count) {
    return '$count leden';
  }

  @override
  String get scanJoinGroupConfirm => 'Neem deel aan de groepschat';

  @override
  String get scanJoining => 'Deelnemen';

  @override
  String get scanJoinGroup => 'Neem deel aan de groepschat';

  @override
  String scanJoinFailed(String error) {
    return 'Kan niet deelnemen: $error';
  }

  @override
  String get tagsTitle => 'Tags';

  @override
  String get tagsCreateTooltip => 'Nieuwe tag';

  @override
  String get tagsContactSection => 'Contacttags';

  @override
  String get tagsEmptyTitle => 'Geen tags';

  @override
  String get tagsEmptySubtitle =>
      'Tik op + in de rechterbovenhoek om contacten of chats te groeperen.';

  @override
  String tagsCreateFailed(Object error) {
    return 'Kan tag niet maken: $error';
  }

  @override
  String tagsUpdateFailed(Object error) {
    return 'Kan tag niet updaten: $error';
  }

  @override
  String tagsDeleteFailed(Object error) {
    return 'Kan tag niet verwijderen: $error';
  }

  @override
  String tagsLoadFailed(Object error) {
    return 'Kan tags niet laden: $error';
  }

  @override
  String tagsDeleteConfirm(String name) {
    return 'Tag \"$name\" verwijderen?\nContacten en groepen in deze tag worden niet verwijderd.';
  }

  @override
  String get tagsEditTitle => 'Tag bewerken';

  @override
  String get tagsCreateTitle => 'Nieuwe tag';

  @override
  String get tagsNameSection => 'Tagnaam';

  @override
  String get tagsNameHint => 'Familie, vrienden';

  @override
  String tagsMembersSection(int count) {
    return 'Tag leden ($count)';
  }

  @override
  String get tagsAddMember => 'Lid toevoegen';

  @override
  String get tagsDelete => 'Tag verwijderen';

  @override
  String get tagsGroupInitial => 'G';

  @override
  String get tagsUnknownUser => 'Onbekende gebruiker';

  @override
  String get tagsSelectMembersTitle => 'Selecteer Leden';

  @override
  String tagsDoneCount(int count) {
    return 'Klaar ($count)';
  }

  @override
  String get tagsSearchHint => 'Zoek contacten of groepen';

  @override
  String get tagsGroupsSection => 'Groepschats';

  @override
  String get tagsContactsSection => 'Contacten';

  @override
  String get tagsNoMatchesTitle => 'Geen overeenkomsten';

  @override
  String get tagsNoMatchesSubtitle => 'Probeer een ander zoekwoord';

  @override
  String tagsRowTitle(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get phoneContactsTitle => 'Telefooncontacten';

  @override
  String get phoneContactsSection => 'Toevoegen vanuit telefooncontacten';

  @override
  String get phoneContactsEmpty => 'Geen telefooncontacten';

  @override
  String get phoneContactsNoAddable =>
      'Geen telefooncontacten om toe te voegen';

  @override
  String get phoneContactsServerSyncFailed =>
      'Serversynchronisatie mislukt. Bestaande contacten tonen.';

  @override
  String get friendAlreadyAdded => 'Toegevoegd';

  @override
  String get friendRequestSent => 'Vriendschapsverzoek verzonden';

  @override
  String phoneContactsInviteSmsBody(Object appName) {
    return 'Ik gebruik $appName. De chatervaring is best aardig. Kom het ook proberen.';
  }

  @override
  String get phoneContactsInviteOpened => 'Sms-uitnodiging geopend';

  @override
  String get phoneContactsInviteFailed =>
      'Kan SMS niet openen. Gelieve handmatig uit te nodigen.';

  @override
  String get friendRequestsEmptyTitle => 'Geen nieuwe vrienden';

  @override
  String get friendRequestsEmptySubtitle =>
      'Nodig vrienden uit om uw QR-code te scannen';

  @override
  String get friendRequestsPendingSection => 'In behandeling';

  @override
  String get friendRequestRefused => 'Geweigerd';

  @override
  String contactOpenFromContacts(Object name) {
    return 'Open de chat van @$name vanuit Contacten';
  }

  @override
  String get fileHelperIntro =>
      'Log in op de webversie en stuur mij berichten om tekst, foto\'s, audio, video\'s en bestanden over te zetten tussen telefoon en computer.';

  @override
  String get fileHelperName => 'File Transfer';

  @override
  String get systemAccountName => 'System';

  @override
  String systemAccountIntro(Object appName) {
    return 'Officieel $appName account voor het verzenden van meldingen.';
  }

  @override
  String get contactIntroTitle => 'Introductie';

  @override
  String get contactSource => 'Bron';

  @override
  String get contactRemoveFriendRelation => 'Vriend verwijderen';

  @override
  String get contactRemoveFromBlacklist => 'Verwijderen van zwarte lijst';

  @override
  String get contactSendMessage => 'Bericht';

  @override
  String get contactAddToContacts => 'Toevoegen aan contacten';

  @override
  String get contactRemoveFriendConfirm => 'Deze vriend verwijderen?';

  @override
  String contactNicknameLine(Object name) {
    return 'Bijnaam: $name';
  }

  @override
  String get contactRemoveFromBlacklistConfirm =>
      'Dit contact verwijderen van de zwarte lijst?';

  @override
  String get webLoginTitle => 'Web Inloggen';

  @override
  String get webLoginConfirmTitle => 'Web-login bevestigen?';

  @override
  String get webLoginConfirmBody =>
      'Hiermee kan uw account inloggen op de huidige browser of desktopclient. Als jij dit niet was, tik je op Annuleren.';

  @override
  String get webLoginConfirmAction => 'Bevestig inloggen';

  @override
  String get webLoginConfirming => 'Bevestigen...';

  @override
  String get webLoginConfirmed => 'Web aanmelding bevestigd';

  @override
  String webLoginConfirmFailed(Object error) {
    return 'Bevestiging mislukt: $error';
  }

  @override
  String get applyFriendTitle => 'Vriendschapsverzoek';

  @override
  String get applyFriendSectionTitle => 'Vriendschapsverzoek verzenden';

  @override
  String get applyFriendRemarkHint => 'Hallo, ik ben...';

  @override
  String friendRequestSendFailed(Object error) {
    return 'Kan niet verzenden: $error';
  }

  @override
  String get contactRemarkHint => 'Opmerking';

  @override
  String get momentPermissionsTitle => 'Momenten Privacy';

  @override
  String get momentHideMineFromContact => 'Verberg mijn momenten voor hen';

  @override
  String get momentHideContactFromMe => 'Verberg hun momenten voor mij';

  @override
  String get momentTitle => 'Momenten';

  @override
  String get momentPersonalEmpty => 'Nog geen berichten';

  @override
  String get momentEmpty => 'Nog geen momenten';

  @override
  String get momentCoverUploadFailed => 'Kan omslag niet uploaden';

  @override
  String momentCoverUploadFailedWithError(Object error) {
    return 'Kan omslag niet uploaden: $error';
  }

  @override
  String get momentDeleteConfirm => 'Dit moment verwijderen?';

  @override
  String get momentJustNow => 'Zojuist';

  @override
  String get momentPublishing => 'Posting…';

  @override
  String get momentPublishFailed => 'Failed to post. Tap to dismiss.';

  @override
  String get momentRemindedYou =>
      'Heeft je eraan herinnerd dit moment te bekijken';

  @override
  String momentRemindedNames(Object names) {
    return 'Herinnerd $names';
  }

  @override
  String get momentKeepEditingConfirm => 'Deze bewerking behouden?';

  @override
  String get momentContinueEditing => 'Blijf bewerken';

  @override
  String get momentSaveDraft => 'Concept opslaan';

  @override
  String get momentDiscardDraft => 'Weggooien';

  @override
  String get momentPublishTitle => 'Bericht';

  @override
  String get momentPublishHint => 'Waar denk je aan...';

  @override
  String get momentLocationTitle => 'Locatie';

  @override
  String get momentRemindWho => 'Herinnering';

  @override
  String get locationUnsupported =>
      'Locatie is niet beschikbaar in deze versie';

  @override
  String momentPrivacyContactCount(Object count, Object label) {
    return '$label · $count';
  }

  @override
  String get momentSelectVisibleContacts =>
      'Selecteer Zichtbare contactpersonen';

  @override
  String get momentSelectHiddenContacts => 'Selecteer Verborgen contacten';

  @override
  String get momentPrivacyPublic => 'Openbaar';

  @override
  String get momentPrivacyPrivate => 'Privé';

  @override
  String get momentPrivacyInternal => 'Zichtbaar voor sommigen';

  @override
  String get momentPrivacyProhibit => 'Verbergen voor';

  @override
  String get momentPrivacyWhoCanSee => 'Wie kan zien';

  @override
  String momentCommentFailed(Object error) {
    return 'Reactie mislukt: $error';
  }

  @override
  String get momentDetailTitle => 'Details';

  @override
  String get momentDeleted => 'Dit moment is verwijderd';

  @override
  String get momentCollapse => 'Samenvouwen';

  @override
  String get momentFullText => 'Volledige tekst';

  @override
  String get momentDeleteCommentConfirm => 'Deze opmerking verwijderen?';

  @override
  String get momentCommentPlaceholder => 'Commentaar';

  @override
  String momentReplyPlaceholder(Object name) {
    return 'Antwoord $name';
  }

  @override
  String get momentLikeAction => 'Vind ik leuk';

  @override
  String get momentCommentAction => 'Commentaar';

  @override
  String momentNewMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nieuwe berichten',
      one: '1 nieuw bericht',
    );
    return '$_temp0';
  }

  @override
  String get messagesTitle => 'Berichten';

  @override
  String get messagesEmpty => 'Geen berichten';

  @override
  String get messagesEmptyTitle => 'Nog geen berichten';

  @override
  String get messagesEmptySubtitle => 'Start rechtsboven een nieuwe chat';

  @override
  String get messagesNewConversation => 'Nieuw';

  @override
  String get messagesStartGroupChat => 'Groepschat starten';

  @override
  String get messagesImDisconnected => 'IM is niet verbonden';

  @override
  String get messagesPinned => 'Vastgezet';

  @override
  String get messagesUnpinned => 'Losgemaakt';

  @override
  String get messagesMuted => 'Gedempt';

  @override
  String get messagesNotificationsOn => 'Meldingen ingeschakeld';

  @override
  String messagesDeleteConversationTitle(String name) {
    return '\"$name\" verwijderen?';
  }

  @override
  String get messagesConfirmDelete => 'Verwijderen';

  @override
  String get messagesCleared => 'Chatgeschiedenis gewist';

  @override
  String get messagesConversationDeleted => 'Gesprek verwijderd';

  @override
  String get messagesUnknownUser => 'Onbekende gebruiker';

  @override
  String get messagesFriendAvatarFallback => 'F';

  @override
  String get messagesGroupFallback => 'Groepschat';

  @override
  String get messagesGroupAvatarFallback => 'G';

  @override
  String get messagesNewMessageDigest => '[Nieuw bericht]';

  @override
  String get messagesConversationPin => 'Speld';

  @override
  String get messagesConversationUnpin => 'Losmaken';

  @override
  String get messagesConversationMute => 'Dempen';

  @override
  String get messagesConversationUnmute => 'Dempen opheffen';

  @override
  String get messagesConnectionNoNetwork =>
      'Netwerk niet beschikbaar. Controleer uw verbinding.';

  @override
  String get messagesConnectionDisconnected => 'Verbinding verbroken';

  @override
  String get messagesConnectionConnecting => 'Verbinden';

  @override
  String get messagesConnectionSyncing => 'Synchroniseren';

  @override
  String get globalSearchTitle => 'Zoeken';

  @override
  String get globalSearchTabChats => 'Chatgesprekken';

  @override
  String get globalSearchTabContacts => 'Contacten';

  @override
  String get globalSearchTabGroups => 'Groepen';

  @override
  String get globalSearchTabFiles => 'Bestanden';

  @override
  String get globalSearchContactsSection => 'Contacten';

  @override
  String get globalSearchGroupsSection => 'Groepschats';

  @override
  String get globalSearchMessagesSection => 'Chatgeschiedenis';

  @override
  String get globalSearchFilesSection => 'Bestanden';

  @override
  String get globalSearchNoMatches => 'Geen overeenkomsten';

  @override
  String get globalSearchNoMore => 'Geen resultaten meer';

  @override
  String get locationLocating => 'Lokaliseren...';

  @override
  String locationPermissionOff(Object appName) {
    return 'Locatietoestemming is uitgeschakeld. Sta $appName toe om de locatie te gebruiken in de systeeminstellingen.';
  }

  @override
  String get locationPermissionDenied =>
      'Locatietoestemming is geweigerd. Plaatsen in de buurt kunnen niet worden geladen.';

  @override
  String get locationMapUnsupported =>
      'AMap wordt niet ondersteund op dit platform';

  @override
  String locationFailed(String error) {
    return 'Locatie mislukt: $error';
  }

  @override
  String get locationSearchPrompt =>
      'Voer trefwoorden in om plaatsen in de buurt te zoeken';

  @override
  String get locationNoNearbyPoi => 'Geen POI in de buurt';

  @override
  String get locationSearchHint => 'Zoek plaatsen in de buurt';

  @override
  String get locationPickerTitle => 'Locatie';

  @override
  String get locationSending => 'Verzenden';

  @override
  String get locationUnnamed => 'Naamloze plaats';

  @override
  String get locationCopiedAddress => 'Adres gekopieerd';

  @override
  String get locationNoMapApp => 'Geen kaartapp beschikbaar';

  @override
  String get locationFallbackTitle => 'Locatie';

  @override
  String get locationAmap => 'AMap';

  @override
  String get locationBaiduMap => 'Baidu-kaarten';

  @override
  String get locationTencentMap => 'Tencent-kaarten';

  @override
  String get locationAppleMap => 'Apple-kaarten';

  @override
  String get locationOtherMap => 'Andere kaarten';

  @override
  String get locationMyLocation => 'Mijn locatie';

  @override
  String locationOpenMapFailed(String name) {
    return 'Kan $name niet openen';
  }

  @override
  String get locationCopyAddress => 'Adres kopiëren';

  @override
  String get locationNavigate => 'Navigeren';

  @override
  String get locationViewTitle => 'Kaart';

  @override
  String get momentPeerCommentDeleted => 'Reactie verwijderd';

  @override
  String get momentDigest => '[moment]';

  @override
  String get actionClose => 'Sluiten';

  @override
  String get saveToAlbum => 'Opslaan in album';

  @override
  String get savedToAlbum => 'Opgeslagen in album';

  @override
  String get saveFailed => 'Opslaan mislukt';

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
    return '$count foto\'s';
  }

  @override
  String get momentReplyConnector => 'heeft gereageerd';

  @override
  String get groupRemarkTitle => 'Groepsopmerking';

  @override
  String get groupRemarkHint =>
      'Stel een groepsopmerking in die alleen voor jou zichtbaar is';

  @override
  String get chatNotificationSettingsTitle => 'Berichtmeldingen';

  @override
  String get chatScreenshotNotification => 'Schermafbeeldingmeldingen';

  @override
  String get chatRevokeNotification => 'Terugroepmeldingen';

  @override
  String get completeProfileTitle => 'Volledig profiel';

  @override
  String get completeProfileUploadAvatar => 'Avatar uploaden';

  @override
  String get completeProfileReuploadAvatar => 'Upload nieuwe avatar';

  @override
  String get completeProfileChooseAvatar => 'Kies een profielfoto';

  @override
  String get completeProfileAvatarUploaded => 'Avatar geüpload';

  @override
  String get completeProfileAvatarRequired => 'Avatar is vereist.';

  @override
  String get nicknameLabel => 'Bijnaam';

  @override
  String get nicknameInputHint => 'Voer bijnaam in';

  @override
  String get nicknameRequired => 'Bijnaam is vereist.';

  @override
  String get completeProfileSaved => 'Profiel voltooid';

  @override
  String get chatSettingsTitle => 'Chatdetails';

  @override
  String chatSettingsGroupTitle(Object count) {
    return 'Chatinfo ($count)';
  }

  @override
  String get chatSettingsGroupName => 'Naam van groepschat';

  @override
  String get chatSettingsGroupQrCode => 'QR-code voor groep';

  @override
  String get chatSearchContentTitle => 'Zoekchat';

  @override
  String get chatSettingsBackground => 'Chatachtergrond instellen';

  @override
  String get chatSettingsBackgroundSelected =>
      'Huidige chatachtergrond ingesteld';

  @override
  String get chatSettingsMute => 'Meldingen dempen';

  @override
  String get chatSettingsPin => 'Pinchat';

  @override
  String get chatSettingsSaveToContacts => 'Opslaan in contacten';

  @override
  String get chatSettingsReadReceipt => 'Leesbevestigingen';

  @override
  String get chatSettingsReadReceiptSubtitle =>
      'Indien ingeschakeld, tonen verzonden berichten de status gelezen/ongelezen';

  @override
  String get chatSettingsFlame => 'Branden na lezen';

  @override
  String get chatFlameTipExit =>
      'Gelezen berichten worden vernietigd na het verlaten van de chat';

  @override
  String chatFlameTipMinutes(Object minutes) {
    return 'Berichten worden $minutes min. nadat ze zijn gelezen vernietigd';
  }

  @override
  String chatFlameTipSeconds(Object seconds) {
    return 'Berichten worden ${seconds}s nadat ze zijn gelezen vernietigd';
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
  String get chatSettingsGroupNickname => 'Bijnaam van mijn groep';

  @override
  String get chatSettingsBlacklisted => 'Op de zwarte lijst';

  @override
  String get chatSettingsPeerBlacklisted =>
      'Deze contactpersoon staat al op de zwarte lijst';

  @override
  String get chatSettingsComplaint => 'Rapport';

  @override
  String get chatSettingsDeleteAndExit => 'Verwijderen en afsluiten';

  @override
  String groupRemarkSyncFailed(Object error) {
    return 'Kan groepsopmerking niet synchroniseren: $error';
  }

  @override
  String get chatSocialDisconnected => 'Sociale dienst is niet verbonden';

  @override
  String get chatNoRemovableMembers => 'Geen verwijderbare leden';

  @override
  String get chatSelectMembersToRemove =>
      'Selecteer leden die u wilt verwijderen';

  @override
  String chatMemberNameQuoted(Object name) {
    return '\"$name\"';
  }

  @override
  String chatMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count leden',
      one: '1 lid',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersConfirm(Object names) {
    return 'Verwijder $names uit de groep';
  }

  @override
  String chatMembersRemoved(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count leden verwijderd',
      one: '1 lid verwijderd',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersFailed(Object error) {
    return 'Kan leden niet verwijderen: $error';
  }

  @override
  String get chatNoInviteCandidates =>
      'Geen contacten beschikbaar om uit te nodigen';

  @override
  String get chatInviteMembers => 'Leden uitnodigen';

  @override
  String get chatSelectContacts => 'Selecteer Contacten';

  @override
  String chatMembersInvited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uitgenodigde $count leden',
      one: '1 lid uitgenodigd',
    );
    return '$_temp0';
  }

  @override
  String chatInviteMembersFailed(Object error) {
    return 'Kan leden niet uitnodigen: $error';
  }

  @override
  String get chatGroupCreated =>
      'Groepschat aangemaakt. Controleer de chatlijst.';

  @override
  String get chatGroupCreateFailed => 'Kan groepschat niet maken';

  @override
  String chatGroupCreateFailedWithError(Object error) {
    return 'Kan groepschat niet maken: $error';
  }

  @override
  String get chatClearCurrentConfirm => 'De huidige chatgeschiedenis wissen?';

  @override
  String get chatDeleteAndExitConfirm =>
      'Na het verwijderen en afsluiten ontvang je geen berichten meer van deze groep.';

  @override
  String get chatBlockConfirm =>
      'Nadat je dit contact aan de zwarte lijst hebt toegevoegd, ontvang je zijn berichten niet meer.';

  @override
  String get chatSearchTabAll => 'Chatgesprekken';

  @override
  String get chatSearchTabMedia => 'Foto\'s/video\'s';

  @override
  String get chatSearchTabFile => 'Bestanden';

  @override
  String get chatSearchNoMatches => 'Geen overeenkomende chatgeschiedenis';

  @override
  String get chatSearchNoMore => 'Geen resultaten meer';

  @override
  String get chatDetailsTooltip => 'Chatdetails';

  @override
  String get chatVoiceInputTooltip => 'Spraakinvoer';

  @override
  String get chatInputHint => 'Bericht...';

  @override
  String get chatFlameEnabledTooltip => 'Branden na lezen is ingeschakeld';

  @override
  String get chatFlameDestroyOnExit => 'Vernietig na het verlaten van de chat';

  @override
  String chatFlameDestroyAfterMinutes(Object minutes) {
    return 'Vernietig na $minutes min';
  }

  @override
  String chatFlameDestroyAfterSeconds(Object seconds) {
    return 'Vernietig na ${seconds}s';
  }

  @override
  String chatFlameEnabledNotice(Object label) {
    return 'Branden na lezen is ingeschakeld. Berichten worden na het lezen $label vernietigd. Gebruik de instellingen rechtsboven om dit uit te schakelen.';
  }

  @override
  String get chatEmojiTooltip => 'Emoji';

  @override
  String get chatActionReply => 'Beantwoorden';

  @override
  String get chatActionCopy => 'Kopiëren';

  @override
  String get chatActionTranslate => 'Vertalen';

  @override
  String get chatActionTranscribe => 'Transcriberen';

  @override
  String get chatActionForward => 'Vooruit';

  @override
  String get chatActionFavorite => 'Favoriet';

  @override
  String get chatActionPin => 'Speld';

  @override
  String get chatActionUnpin => 'Losmaken';

  @override
  String get chatActionAddFriend => 'Vriend toevoegen';

  @override
  String get chatActionMultiSelect => 'Selecteer';

  @override
  String get chatActionEdit => 'Bewerken';

  @override
  String get chatActionEditImage => 'Afbeelding bewerken';

  @override
  String get chatActionRevoke => 'Terugroepen';

  @override
  String get chatActionDelete => 'Verwijderen';

  @override
  String get chatGroupCallActive => 'Groepsgesprek bezig';

  @override
  String chatMessageRevokedBy(Object name) {
    return '$name heeft een bericht teruggehaald';
  }

  @override
  String get chatReedit => 'Opnieuw bewerken';

  @override
  String get chatEditedSuffix => '(bewerkt)';

  @override
  String chatActionReadBy(Object count) {
    return 'Gelezen door $count';
  }

  @override
  String chatActionReactedBy(Object count) {
    return '$count reacties';
  }

  @override
  String chatSelectedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Geselecteerde $count artikelen',
      one: '1 artikel geselecteerd',
    );
    return '$_temp0';
  }

  @override
  String get chatNoReactions => 'Nog geen reacties';

  @override
  String chatReadStatusReadCount(Object count) {
    return 'Lezen ($count)';
  }

  @override
  String get chatNoReadReceipts => 'Nog geen';

  @override
  String get chatHistoryAbove => 'Eerdere berichten hierboven';

  @override
  String chatUnreadNewMessages(Object count) {
    return '$count nieuwe berichten';
  }

  @override
  String get chatUnreadDivider => 'Nieuwe berichten hieronder';

  @override
  String get chatUnknownContentFallback =>
      'Deze versie kan dit bericht niet weergeven. Update naar de nieuwste versie.';

  @override
  String get chatMentionSomeone => 'Iemand heeft je genoemd';

  @override
  String get chatToolAlbum => 'Album';

  @override
  String get chatToolCamera => 'Camera';

  @override
  String get chatToolFile => 'Bestand';

  @override
  String get chatToolLocation => 'Locatie';

  @override
  String get chatToolContactCard => 'Contactkaart';

  @override
  String get chatToolAudioCall => 'Spraakoproep';

  @override
  String get chatToolVideoCall => 'Videogesprek';

  @override
  String get chatDraftLabel => '[Concept]';

  @override
  String get visitorBadge => 'Bezoeker';

  @override
  String get chatNoticeDeleted => 'Verwijderd';

  @override
  String get chatNoticeCopied => 'Gekopieerd';

  @override
  String get chatMentionLoadedOrInvisible =>
      'Het @-bericht is geladen of niet zichtbaar. Scroll naar boven om het te vinden.';

  @override
  String get chatLocationDefaultTitle => 'Locatie';

  @override
  String get chatLocationCopied => 'Locatie gekopieerd';

  @override
  String get chatReadStatusTitle => 'Leesstatus';

  @override
  String get chatReadStatusRead => 'Lezen';

  @override
  String get chatReadStatusUnread => 'Ongelezen';

  @override
  String get chatReadStatusUnavailable =>
      'Volledige gelezen/ongelezen lijsten zijn nog niet beschikbaar';

  @override
  String get chatComposerLeft => 'Je hebt deze chat verlaten';

  @override
  String get chatComposerMuted => 'Deze chat is gedempt';

  @override
  String chatComposerMutedUntil(Object time) {
    return 'Je bent gedempt tot $time';
  }

  @override
  String chatFavoriteCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Favoriet $count berichten',
      one: 'Favoriet 1 bericht',
    );
    return '$_temp0';
  }

  @override
  String chatFavoritePartial(Object failed, Object success) {
    return 'Favorieten voltooid: $success geslaagd, $failed mislukt';
  }

  @override
  String get chatForwardUnavailable => 'Kan momenteel niet doorsturen';

  @override
  String chatMergedForwardedTo(Object count, Object name) {
    return '$count berichten samengevoegd naar $name';
  }

  @override
  String chatForwardedIndividuallyTo(Object count, Object name) {
    return 'Heeft $count berichten één voor één doorgestuurd naar $name';
  }

  @override
  String chatForwardedPartialTo(Object name, Object sent, Object total) {
    return 'Heeft $sent/$total berichten doorgestuurd naar $name';
  }

  @override
  String get chatForwardModeIndividual => 'Eén voor één doorsturen';

  @override
  String get chatForwardModeMerge => 'Samenvoegen en doorsturen';

  @override
  String get chatPresenceOnline => 'Online';

  @override
  String get chatPresenceOffline => 'Offline';

  @override
  String get chatPresenceJustActive => 'Zojuist actief';

  @override
  String chatPresenceMinutesAgo(Object minutes) {
    return 'Actief $minutes min geleden';
  }

  @override
  String chatPresenceHoursAgo(Object hours) {
    return 'Actief $hours uur geleden';
  }

  @override
  String chatPresenceDaysAgo(Object days) {
    return 'Actief $days dagen geleden';
  }

  @override
  String get chatSensitiveDefaultTip =>
      'Dit bericht kan gevoelige informatie bevatten';

  @override
  String get chatMessageDigestFallback => '[Bericht]';

  @override
  String get chatMediaServiceUnavailable => 'Mediaservice is niet gereed';

  @override
  String get chatImDisconnected => 'IM is niet verbonden';

  @override
  String get chatPinFailedNotSent =>
      'Kan niet vastzetten voordat het bericht de server bereikt';

  @override
  String get chatPinFailed => 'Kan niet vastzetten. Probeer het opnieuw.';

  @override
  String get chatPinned => 'Vastgezet';

  @override
  String get chatUnpinFailed =>
      'Kan niet worden losgemaakt. Probeer het opnieuw.';

  @override
  String get chatUnpinned => 'Losgemaakt';

  @override
  String get chatClearPinnedConfirm => 'Alle vastgezette berichten losmaken?';

  @override
  String get chatClearPinnedAction => 'Losmaken';

  @override
  String get chatAllUnpinned => 'Alle vastgezette berichten zijn losgemaakt';

  @override
  String get chatPinnedMessageNotVisible =>
      'Dit bericht bevindt zich niet in het zichtbare bereik. Bekijk het vanuit de lijst.';

  @override
  String get chatImageMissing => 'Afbeeldingsinformatie ontbreekt';

  @override
  String get chatImageDownloadFailedEdit =>
      'Kan afbeelding niet downloaden. Kan niet bewerken.';

  @override
  String get chatReactionFailed => 'Reactie mislukt. Probeer het opnieuw.';

  @override
  String get chatEditNotSynced =>
      'Bewerken mislukt: bericht is niet gesynchroniseerd';

  @override
  String get chatEditFailed => 'Bewerken mislukt. Probeer het opnieuw.';

  @override
  String get chatFavoriteUnsupportedType =>
      'Dit type kan nog niet als favoriet worden aangemerkt';

  @override
  String get chatFavoriteNotSent =>
      'Het bericht heeft de server niet bereikt en kan dus niet als favoriet worden aangemerkt';

  @override
  String get chatFavoriteSuccess => 'Toegevoegd aan favorieten';

  @override
  String get chatFavoriteFailed =>
      'Favoriet maken is mislukt. Probeer het opnieuw.';

  @override
  String chatToolSelected(Object title) {
    return 'Geselecteerd $title';
  }

  @override
  String chatCardDigest(Object name) {
    return '[Kaart] $name';
  }

  @override
  String get chatFriendAvatarFallback => 'F';

  @override
  String get chatUnknownMessageDigest => '[Onbekend]';

  @override
  String chatOpenFromContacts(Object name) {
    return 'Open de chat van @$name vanuit Contacten';
  }

  @override
  String get chatLoadingCard => 'Contactkaart laden...';

  @override
  String get chatFileMissing => 'Bestandsinformatie ontbreekt';

  @override
  String get chatVideoUnavailable => 'Video kan niet worden afgespeeld';

  @override
  String get chatVideoSourceEmpty => 'Videobron is leeg';

  @override
  String get chatLivePhotoUnavailable =>
      'Live Photo kan niet worden afgespeeld';

  @override
  String get messageAiTranslating => 'Vertalen...';

  @override
  String get messageAiTranscribedShort => 'Klaar';

  @override
  String get messageAiVoiceSendingWait =>
      'De stem is nog steeds bezig met verzenden. Probeer het later opnieuw.';

  @override
  String get messageAiNoTranscript => 'Geen spraak herkend';

  @override
  String get messageAiMessageSendingWait =>
      'Bericht wordt nog steeds verzonden. Probeer het later opnieuw.';

  @override
  String get messageAiNoTranslation => 'Geen vertaalresultaat';

  @override
  String get messageAiTemporarilyUnavailable => 'Tijdelijk niet beschikbaar';

  @override
  String get chatVoiceFileUnavailable => 'Spraakbestand is niet beschikbaar';

  @override
  String get chatVoicePlayFailed => 'Afspelen mislukt. Probeer het opnieuw.';

  @override
  String get chatVoiceHoldToRecord =>
      'Houd ingedrukt om op te nemen · Schuif omhoog om te annuleren';

  @override
  String chatVoiceReleaseToCancel(Object duration) {
    return 'Vrijgeven om te annuleren ($duration)';
  }

  @override
  String chatVoiceRecordingSlideCancel(Object duration) {
    return '$duration · Schuif omhoog om te annuleren';
  }

  @override
  String get chatQrcodeNotFound => 'Geen QR-code herkend';

  @override
  String chatWebLoginQrcodeDetected(Object payload) {
    return 'Web login QR-code herkend\n$payload';
  }

  @override
  String get chatWebLoginConfirmTitle => 'Inloggen op internet bevestigen?';

  @override
  String get chatWebLoginConfirmAction => 'Bevestig Web Inloggen';

  @override
  String get chatWebLoginConfirmed => 'Web aanmelding bevestigd';

  @override
  String chatQrcodeDetected(Object payload) {
    return 'QR-code herkend\n$payload';
  }

  @override
  String get chatStickerPlaceholder => '[Sticker]';

  @override
  String get chatStickerAdded => 'Toegevoegd aan stickers';

  @override
  String get chatStickerAddFailed =>
      'Kan sticker niet toevoegen. Probeer het opnieuw.';

  @override
  String get mentionAllMembers => 'Alle leden';

  @override
  String get mentionAllMembersSubtitle =>
      'Breng iedereen in deze groep op de hoogte';

  @override
  String get chatQuoteOriginalRevoked =>
      'Oorspronkelijk bericht is ingetrokken';

  @override
  String get chatRecognizeImageQrcode => 'Scan QR-code in afbeelding';

  @override
  String get chatAddToStickers => 'Toevoegen aan stickers';

  @override
  String get chatGroupInviteApprovalUrlEmpty =>
      'Goedkeurings-URL voor groepsuitnodiging is leeg';

  @override
  String get chatGroupInviteApprovalTitle =>
      'Goedkeuring van groepsuitnodiging';

  @override
  String get chatGroupInviteApprovalBody =>
      'Voltooi de bevestiging van de groepsuitnodiging op de webpagina.';

  @override
  String get chatGroupInviteGoConfirm => 'Bevestigen';

  @override
  String get chatGroupInviteApprovalOpenFailed =>
      'Kan de goedkeuring van de groepsuitnodiging niet openen. Probeer het opnieuw.';

  @override
  String get chatSendFailed => 'Kan niet verzenden. Probeer het opnieuw.';

  @override
  String get chatCallActiveHangupFirst =>
      'Er is een oproep actief. Hang eerst op.';

  @override
  String get chatCallActiveCannotJoinAgain =>
      'Er is een oproep actief. Kan niet opnieuw meedoen.';

  @override
  String get chatCallUnsupported =>
      'Oproepen worden niet ondersteund in deze versie';

  @override
  String get chatCallServiceUnavailable => 'Oproepservice is niet gereed';

  @override
  String get chatCallJoinFailedEnded =>
      'Kan niet deelnemen. Het gesprek is mogelijk beëindigd.';

  @override
  String get callWaitingAnswer => 'Wachten op antwoord';

  @override
  String get callMessage => 'Belbericht';

  @override
  String get callEnded => 'Oproep beëindigd';

  @override
  String get callPeerRefused => 'Peer geweigerd';

  @override
  String get callPeerHungUp => 'Peer heeft opgehangen';

  @override
  String get callPeerDeclinedVideoSwitch =>
      'Peer heeft het verzoek om van video te wisselen afgewezen';

  @override
  String get callSwitchVideoRequestTitle =>
      'Peerverzoeken om over te schakelen naar video';

  @override
  String get callAgree => 'Mee eens';

  @override
  String get callReconnecting => 'Opnieuw verbinden…';

  @override
  String get callWaitingPeerCamera => 'Wachten op peercamera';

  @override
  String get callSelfFallbackName => 'Ik';

  @override
  String get callUnknownUser => 'Onbekende gebruiker';

  @override
  String callJoinedCount(int joined, int total) {
    return '$joined/$total is lid geworden';
  }

  @override
  String get callMute => 'Dempen';

  @override
  String get callSpeaker => 'Luidspreker';

  @override
  String get callSwitchToVideo => 'Video';

  @override
  String get callHangup => 'Ophangen';

  @override
  String get callFlipCamera => 'Omdraaien';

  @override
  String get callSwitchToVoice => 'Audio';

  @override
  String get callCamera => 'Camera';

  @override
  String get callBack => 'Terug';

  @override
  String get callPermissionMicrophone => 'microfoon';

  @override
  String get callPermissionMicrophoneCamera => 'microfoon en camera';

  @override
  String callPermissionOpenSettings(String what) {
    return 'Schakel $what toestemming in systeeminstellingen in';
  }

  @override
  String callPermissionRequired(String what) {
    return 'Voor oproepen is $what toestemming nodig';
  }

  @override
  String get callWaitingPeerConsent => 'Wachten op goedkeuring door collega\'s';

  @override
  String get callSwitchRequestFailed =>
      'Kan het overstapverzoek niet verzenden';

  @override
  String get callCameraPermissionRequired => 'Cameratoestemming vereist';

  @override
  String get callCameraEnableFailed => 'Kan de camera niet inschakelen';

  @override
  String get incomingCallAccepting => 'Beantwoordt...';

  @override
  String get incomingVideoCall => 'nodigt je uit voor een videogesprek';

  @override
  String get incomingAudioCall => 'nodigt u uit voor een spraakoproep';

  @override
  String incomingAcceptFailed(String error) {
    return 'Antwoord mislukt: $error';
  }

  @override
  String get incomingCallDecline => 'Weigeren';

  @override
  String get incomingCallAccept => 'Antwoord';

  @override
  String get chatGroupNoInviteCandidates =>
      'Er zijn geen leden beschikbaar om uit te nodigen';

  @override
  String get chatInviteGroupMembersVideo =>
      'Groepsleden uitnodigen (videogesprek)';

  @override
  String get chatInviteGroupMembersAudio =>
      'Groepsleden uitnodigen (spraakoproep)';

  @override
  String get chatSelfName => 'Ik';

  @override
  String get chatPeerPlaceholder => 'Anders';

  @override
  String get chatSomeonePlaceholder => 'Iemand';

  @override
  String chatScreenshotNotice(Object name) {
    return '$name heeft een screenshot gemaakt in de chat';
  }

  @override
  String chatDuplicateGroupMention(Object name) {
    return 'Meerdere groepsleden komen overeen met @$name';
  }

  @override
  String chatDuplicateContactMention(Object name) {
    return 'Meerdere contacten komen overeen met @$name';
  }

  @override
  String chatMentionNotFound(Object name) {
    return '@$name niet gevonden';
  }

  @override
  String get chatForwardPickerTitle => 'Doorsturen naar';

  @override
  String get chatRecentContactsSection => 'Recente contacten';

  @override
  String chatForwardedTo(Object name) {
    return 'Doorgestuurd naar $name';
  }

  @override
  String get favoriteTitle => 'Favorieten';

  @override
  String get favoriteEmptyTitle => 'Geen favorieten';

  @override
  String get favoriteEmptySubtitle =>
      'Houd een bericht in de chat lang ingedrukt en kies Favoriet om het hier op te slaan.';

  @override
  String get favoriteDeleted => 'Verwijderd';

  @override
  String favoriteDeleteFailed(Object error) {
    return 'Verwijderen mislukt: $error';
  }

  @override
  String get favoriteDeleteFailedPlain => 'Verwijderen mislukt';

  @override
  String get favoriteUnsupportedSend =>
      'Dit type kan nog niet verzonden worden';

  @override
  String favoriteSentTo(String name) {
    return 'Verzonden naar $name';
  }

  @override
  String favoriteSendFailed(Object error) {
    return 'Verzenden mislukt: $error';
  }

  @override
  String get favoriteSendFailedPlain => 'Verzenden mislukt';

  @override
  String get favoriteSendToFriend => 'Verzenden naar vriend';

  @override
  String get favoriteCopied => 'Gekopieerd';

  @override
  String get favoriteUnknownUser => 'Onbekende gebruiker';

  @override
  String favoriteDateMonthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String get groupSavedTitle => 'Opgeslagen groepen';

  @override
  String get groupSaveTooltip => 'Groep opslaan';

  @override
  String get groupSearchHint => 'Zoekgroepen';

  @override
  String get groupNoMatched => 'Geen overeenkomende groepen';

  @override
  String get groupNoSaveCandidatesToast =>
      'Geen groepen beschikbaar om op te slaan';

  @override
  String get groupSavedToContacts => 'Opgeslagen in contacten';

  @override
  String groupSaveFailed(Object error) {
    return 'Kan niet opslaan: $error';
  }

  @override
  String get groupSelectTitle => 'Selecteer Groep';

  @override
  String get groupNoSaveCandidates => 'Geen groepen beschikbaar om op te slaan';

  @override
  String get groupCreateTitle => 'Groepschat starten';

  @override
  String get groupSearchContactsHint => 'Contacten zoeken';

  @override
  String get groupNoMatchedContacts => 'Geen overeenkomende contacten';

  @override
  String groupMemberSummary(num count, Object subtitle) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count leden',
      one: '1 lid',
    );
    return '$_temp0· $subtitle';
  }

  @override
  String get groupMuted => 'Gedempt';

  @override
  String get groupDetailsTitle => 'Groepsdetails';

  @override
  String groupMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count leden',
      one: '1 lid',
    );
    return '$_temp0';
  }

  @override
  String get groupMembersSection => 'Groepsleden';

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
  String get groupNoMembers => 'Geen groepsleden';

  @override
  String get groupInviteMembers => 'Leden uitnodigen';

  @override
  String get groupInviteMembersSubtitle => 'Kies uit contacten';

  @override
  String get groupRemoveMembers => 'Leden verwijderen';

  @override
  String get groupRemoveMembersEmptySubtitle => 'Geen leden om te verwijderen';

  @override
  String get groupRemoveMembersSubtitle => 'Kies leden om te verwijderen';

  @override
  String get groupQrCodeTitle => 'QR-code voor groep';

  @override
  String get groupQrCodeSubtitle => 'Scan om lid te worden van deze groep';

  @override
  String get groupNameTitle => 'Groepsnaam';

  @override
  String get groupNoticeTitle => 'Groepsaankondiging';

  @override
  String get groupNoticeUnset => 'Niet ingesteld';

  @override
  String get groupManageTitle => 'Groepsbeheer';

  @override
  String get groupManageSubtitle => 'Beheerders, dempen en groepsrechten';

  @override
  String get groupInviteConfirm => 'Bevestiging van uitnodiging';

  @override
  String get groupBlacklistTitle => 'Zwarte lijst van groepen';

  @override
  String get groupBlacklistSubtitle =>
      'Beheer leden die niet mogen spreken of deelnemen';

  @override
  String get groupSaveToContacts => 'Opslaan in contacten';

  @override
  String get groupMuteMessages => 'Meldingen dempen';

  @override
  String get groupExited => 'Groepschat verlaten';

  @override
  String get groupExitAction => 'Groep verlaten';

  @override
  String groupMembersSyncFailed(Object error) {
    return 'Kan groepsleden niet synchroniseren: $error';
  }

  @override
  String get groupInvitePickerTitle => 'Kies leden om uit te nodigen';

  @override
  String groupInviteSentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Verzonden $count ledenuitnodigingen',
      one: '1 uitnodiging voor lid verzonden',
    );
    return '$_temp0';
  }

  @override
  String groupInvitedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Uitgenodigde $count leden',
      one: '1 lid uitgenodigd',
    );
    return '$_temp0';
  }

  @override
  String groupInviteMembersFailed(Object error) {
    return 'Kan leden niet uitnodigen: $error';
  }

  @override
  String get groupRemovePickerTitle => 'Kies leden die u wilt verwijderen';

  @override
  String groupQuotedMemberName(Object name) {
    return '\"$name\"';
  }

  @override
  String groupSelectedMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count leden',
      one: '1 lid',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersConfirm(Object target) {
    return '$target uit deze groep verwijderen?';
  }

  @override
  String get groupRemoveAction => 'Verwijderen';

  @override
  String groupRemovedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count leden verwijderd',
      one: '1 lid verwijderd',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersFailed(Object error) {
    return 'Kan leden niet verwijderen: $error';
  }

  @override
  String get groupSettingsUpdated => 'Groepsinstellingen bijgewerkt';

  @override
  String groupSettingsUpdateFailed(Object error) {
    return 'Kan groepsinstellingen niet bijwerken: $error';
  }

  @override
  String get groupExitConfirm =>
      'Je ontvangt geen berichten meer van deze groep nadat je deze hebt verlaten.';

  @override
  String get groupExitSuccess => 'Groepschat verlaten';

  @override
  String groupExitFailed(Object error) {
    return 'Kan niet vertrekken: $error';
  }

  @override
  String get groupOwnerAdminSection => 'Eigenaar en beheerders';

  @override
  String get groupOwnerRole => 'Eigenaar';

  @override
  String get groupAdminRole => 'Beheerder';

  @override
  String get groupRemove => 'Verwijderen';

  @override
  String get groupAddAdmin => 'Groepsbeheerder toevoegen';

  @override
  String get groupNoAdmins => 'Geen beheerders';

  @override
  String get groupInviteConfirmRemark =>
      'Indien ingeschakeld, hebben leden goedkeuring van de eigenaar of beheerder nodig voordat ze vrienden kunnen uitnodigen. Deelnemen via QR-code wordt ook uitgeschakeld.';

  @override
  String get groupOwnerTransfer => 'Eigendom overdragen';

  @override
  String get groupMemberSettingsSection => 'Lidinstellingen';

  @override
  String get groupAllMutedRemark =>
      'Wanneer het dempen van alle leden is ingeschakeld, kunnen alleen de eigenaar en beheerders spreken.';

  @override
  String get groupAllMuted => 'Alle leden dempen';

  @override
  String get groupForbiddenAddFriendRemark =>
      'Indien ingeschakeld kunnen leden geen vrienden toevoegen via deze groep.';

  @override
  String get groupForbiddenAddFriend => 'Voorkom dat leden vrienden toevoegen';

  @override
  String get groupAllowHistoryRemark =>
      'Indien ingeschakeld, kunnen nieuwe leden de eerdere chatgeschiedenis zien.';

  @override
  String get groupAllowHistory =>
      'Sta toe dat nieuwe leden de geschiedenis bekijken';

  @override
  String get groupAddAdminPickerTitle => 'Groepsbeheerder toevoegen';

  @override
  String groupAdminAddedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count beheerders toegevoegd',
      one: '1 beheerder toegevoegd',
    );
    return '$_temp0';
  }

  @override
  String groupAddAdminFailed(Object error) {
    return 'Kan beheerder niet toevoegen: $error';
  }

  @override
  String groupRemoveAdminConfirm(Object name) {
    return 'Beheerdersrol verwijderen van \"$name\"?';
  }

  @override
  String get groupRemoveAdminAction => 'Beheerder verwijderen';

  @override
  String get groupRemoveAdminSuccess => 'Beheerder verwijderd';

  @override
  String groupRemoveAdminFailed(Object error) {
    return 'Kan beheerder niet verwijderen: $error';
  }

  @override
  String get groupSelectNewOwner => 'Selecteer Nieuwe eigenaar';

  @override
  String groupTransferOwnerConfirm(Object name) {
    return 'Eigendom overdragen naar \"$name\"? Je wordt een gewoon lid.';
  }

  @override
  String get groupTransferOwnerAction => 'Overdracht bevestigen';

  @override
  String get groupOwnerTransferred => 'Eigendom overgedragen';

  @override
  String groupOwnerTransferFailed(Object error) {
    return 'Kan eigendom niet overdragen: $error';
  }

  @override
  String get groupNoticePublisherDefault => 'Groepsaankondiging';

  @override
  String get groupNoticePublishTitle => 'Groepsaankondiging plaatsen';

  @override
  String get groupNoticeEditTitle => 'Groepsaankondiging bewerken';

  @override
  String get groupNoticePublishAction => 'Bericht';

  @override
  String get groupNoticeEmpty => 'Geen groepsaankondiging';

  @override
  String get groupNoticePublishedAtUnknown => 'Publicatietijd onbekend';

  @override
  String get groupMemberRemarkTitle => 'Mijn bijnaam in deze groep';

  @override
  String get groupMemberRemarkHint => 'Stel je bijnaam in deze groep in';

  @override
  String get groupQrCodeEmpty => 'Geen groeps-QR-code';

  @override
  String groupQrCodeValid(Object day, Object expire) {
    return 'Deze QR-code is $day dagen geldig ($expire)';
  }

  @override
  String get groupQrCodeScanToJoin =>
      'Scan de QR-code om lid te worden van deze groep';

  @override
  String get groupBlacklistLoadFailed =>
      'Kan de zwarte lijst niet laden. Probeer het opnieuw.';

  @override
  String get groupBlacklistEmpty => 'Geen leden op de zwarte lijst';

  @override
  String get groupBlacklistAddMember => 'Zwarte lijstlid toevoegen';

  @override
  String get groupBlacklistNoCandidates =>
      'Er kunnen geen leden aan de zwarte lijst worden toegevoegd';

  @override
  String get groupSelectMember => 'Selecteer lid';

  @override
  String get groupBlacklistAdded => 'Toegevoegd aan zwarte lijst';

  @override
  String get groupBlacklistAddFailed =>
      'Toevoegen aan zwarte lijst is mislukt. Probeer het opnieuw.';

  @override
  String groupBlacklistRemoveConfirm(Object name) {
    return '\"$name\" verwijderen uit de zwarte lijst van de groep?';
  }

  @override
  String get groupBlacklistRemoveAction => 'Verwijderen van zwarte lijst';

  @override
  String get groupBlacklistRemoveFailed =>
      'Kan niet van de zwarte lijst worden verwijderd. Probeer het opnieuw.';

  @override
  String get groupAvatarTitle => 'Groepsavatar';

  @override
  String get groupAvatarTakePhoto => 'Maak een foto';

  @override
  String get groupAvatarChooseFromAlbum => 'Kies uit album';

  @override
  String get groupAvatarSaveImage => 'Afbeelding opslaan';

  @override
  String get groupAvatarUnsupported =>
      'Deze chat biedt geen ondersteuning voor het wijzigen van de groepsavatar';

  @override
  String get groupAvatarUpdated => 'Groepsavatar bijgewerkt';

  @override
  String get groupAvatarUpdateFailed =>
      'Kan groepsavatar niet bijwerken. Probeer het opnieuw.';

  @override
  String get groupAvatarNoImageToSave => 'Geen avatar om op te slaan';

  @override
  String groupPhotoPermissionRequired(Object appName) {
    return 'Geef $appName toegang tot uw foto\'s';
  }

  @override
  String get groupImageSavedToAlbum => 'Opgeslagen in album';

  @override
  String get groupImageSaveFailed => 'Kan niet opslaan. Probeer het opnieuw.';

  @override
  String get imageEditorProcessing => 'Verwerken...';

  @override
  String get imageEditorDiscardTitle => 'Bewerkingen negeren?';

  @override
  String get imageEditorDiscardMessage =>
      'Niet-opgeslagen bewerkingen gaan verloren.';

  @override
  String get imageEditorDiscardConfirm => 'Weggooien';

  @override
  String get imageEditorPaint => 'Tekenen';

  @override
  String get imageEditorFreestyle => 'Uit de vrije hand';

  @override
  String get imageEditorArrow => 'Pijl';

  @override
  String get imageEditorLine => 'Lijn';

  @override
  String get imageEditorRectangle => 'Rechthoek';

  @override
  String get imageEditorCircle => 'Cirkel';

  @override
  String get imageEditorDashLine => 'Stippellijn';

  @override
  String get imageEditorMoveAndZoom => 'Verplaatsen/zoomen';

  @override
  String get imageEditorEraser => 'Gum';

  @override
  String get imageEditorLineWidth => 'Breedte';

  @override
  String get imageEditorToggleFill => 'Vullen';

  @override
  String get imageEditorOpacity => 'Dekking';

  @override
  String get imageEditorUndo => 'Ongedaan maken';

  @override
  String get imageEditorRedo => 'Opnieuw uitvoeren';

  @override
  String get imageEditorInputHint => 'Voer tekst in';

  @override
  String get imageEditorText => 'Tekst';

  @override
  String get imageEditorTextAlign => 'Uitlijnen';

  @override
  String get imageEditorBackground => 'Achtergrond';

  @override
  String get imageEditorFontScale => 'Lettergrootte';

  @override
  String get imageEditorCrop => 'Bijsnijden';

  @override
  String get imageEditorRotate => 'Draaien';

  @override
  String get imageEditorRatio => 'Verhouding';

  @override
  String get imageEditorReset => 'Opnieuw instellen';

  @override
  String get imageEditorFlip => 'Omdraaien';

  @override
  String get imageEditorFilter => 'Filters';

  @override
  String get imageEditorFilterNone => 'Origineel';

  @override
  String get imageEditorFilterAddictiveBlue => 'Verslavend blauw';

  @override
  String get imageEditorFilterAddictiveRed => 'Verslavend rood';

  @override
  String get imageEditorFilterAden => 'Aden';

  @override
  String get imageEditorFilterAmaro => 'Amaro';

  @override
  String get imageEditorFilterAshby => 'Asby';

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
  String get imageEditorFilterDogpatch => 'Hondenpatch';

  @override
  String get imageEditorFilterEarlybird => 'Vroege vogel';

  @override
  String get imageEditorFilterGingham => 'Gingham';

  @override
  String get imageEditorFilterGinza => 'Ginza';

  @override
  String get imageEditorFilterHefe => 'Hef';

  @override
  String get imageEditorFilterHelena => 'Helena';

  @override
  String get imageEditorFilterHudson => 'Hudson';

  @override
  String get imageEditorFilterInkwell => 'Inktpot';

  @override
  String get imageEditorFilterJuno => 'Juno';

  @override
  String get imageEditorFilterKelvin => 'Kelvin';

  @override
  String get imageEditorFilterLark => 'Leeuwerik';

  @override
  String get imageEditorFilterLoFi => 'LoFi';

  @override
  String get imageEditorFilterLudwig => 'Lodewijk';

  @override
  String get imageEditorFilterMaven => 'Maven';

  @override
  String get imageEditorFilterMayfair => 'Mayfair';

  @override
  String get imageEditorFilterMoon => 'Maan';

  @override
  String get imageEditorFilterNashville => 'Nashville';

  @override
  String get imageEditorFilterPerpetua => 'Eeuwigdurend';

  @override
  String get imageEditorFilterReyes => 'Reyes';

  @override
  String get imageEditorFilterRise => 'Stijg';

  @override
  String get imageEditorFilterSierra => 'Sierra';

  @override
  String get imageEditorFilterSkyline => 'Horizon';

  @override
  String get imageEditorFilterSlumber => 'Sluimeren';

  @override
  String get imageEditorFilterStinson => 'Stinson';

  @override
  String get imageEditorFilterSutro => 'Sutro';

  @override
  String get imageEditorFilterToaster => 'Broodrooster';

  @override
  String get imageEditorFilterValencia => 'Valencia';

  @override
  String get imageEditorFilterVesper => 'Vesper';

  @override
  String get imageEditorFilterWalden => 'Walden';

  @override
  String get imageEditorFilterWillow => 'Wilg';

  @override
  String get imageEditorBlur => 'Vervagen';

  @override
  String get imageEditorTune => 'Aanpassen';

  @override
  String get imageEditorBrightness => 'Helderheid';

  @override
  String get imageEditorContrast => 'Contrast';

  @override
  String get imageEditorSaturation => 'Verzadiging';

  @override
  String get imageEditorExposure => 'Blootstelling';

  @override
  String get imageEditorHue => 'Tint';

  @override
  String get imageEditorTemperature => 'Temperatuur';

  @override
  String get imageEditorSharpness => 'Scherpte';

  @override
  String get imageEditorFade => 'Vervagen';

  @override
  String get imageEditorLuminance => 'Luminantie';

  @override
  String get imageEditorEmoji => 'Emoji';

  @override
  String get imageEditorEmojiRecent => 'Recent';

  @override
  String get imageEditorEmojiSmileys => 'Smileys';

  @override
  String get imageEditorEmojiAnimals => 'Dieren';

  @override
  String get imageEditorEmojiFood => 'Eten';

  @override
  String get imageEditorEmojiActivities => 'Activiteiten';

  @override
  String get imageEditorEmojiTravel => 'Reizen';

  @override
  String get imageEditorEmojiObjects => 'Objecten';

  @override
  String get imageEditorEmojiSymbols => 'Symbolen';

  @override
  String get imageEditorEmojiFlags => 'Vlaggen';

  @override
  String get imageEditorSticker => 'Stickers';

  @override
  String get imageEditorRemove => 'Verwijderen';

  @override
  String get imageEditorSaving => 'Opslaan...';

  @override
  String get imageEditorImporting => 'Importeren';

  @override
  String get imagePreviewTitle => 'Afbeeldingsvoorbeeld';

  @override
  String get imagePreviewSavingToAlbum => 'Opslaan...';

  @override
  String get imagePreviewAddToSticker => 'Toevoegen aan stickers';

  @override
  String get imagePreviewAddingToSticker => 'Toevoegen...';

  @override
  String get imagePreviewRecognizeQr => 'Herken QR-code';

  @override
  String get imagePreviewRecognizingQr => 'Herkennen...';

  @override
  String get imagePreviewConfirmWebLogin => 'Bevestig Web Inloggen';

  @override
  String get imagePreviewConfirmingWebLogin => 'Bevestigen...';

  @override
  String get imagePreviewOpenLink => 'Link openen';

  @override
  String get imagePreviewImageNotDownloadedSave =>
      'Afbeelding is nog niet gedownload';

  @override
  String get imagePreviewMediaUnavailable => 'Mediaservice is niet beschikbaar';

  @override
  String get imagePreviewImageNotUploadedSticker =>
      'Afbeelding is nog niet geüpload';

  @override
  String get imagePreviewStickerUnavailable =>
      'Stickerservice is niet beschikbaar';

  @override
  String get imagePreviewAddedToSticker => 'Toegevoegd aan stickers';

  @override
  String get imagePreviewImageNotDownloadedRecognize =>
      'Afbeelding is nog niet gedownload';

  @override
  String get imagePreviewQrNotFound => 'Geen QR-code gevonden';

  @override
  String get imagePreviewWebLoginQrRecognized => 'Web login QR-code herkend';

  @override
  String get imagePreviewWebLinkRecognized => 'Web link herkend';

  @override
  String get imagePreviewQrRecognized => 'QR-code herkend';

  @override
  String get imagePreviewWebLoginConfirmed => 'Web aanmelding bevestigd';

  @override
  String get pickerFileTitle => 'Kies Bestand';

  @override
  String get pickerRecentFiles => 'Recente bestanden';

  @override
  String get pickerSampleProjectFile => 'Projectnotities.pdf';

  @override
  String get pickerSampleProjectFileSubtitle => '128 KB · Vandaag';

  @override
  String get pickerSampleScreenshotFile => 'Chatschermafbeelding.png';

  @override
  String get pickerSampleScreenshotFileSubtitle => '2,4 MB · Gisteren';

  @override
  String get pickerContactTitle => 'Kies Contactpersoon';

  @override
  String get pickerContactCardSection => 'Contactkaart verzenden';

  @override
  String get pickerSearchContacts => 'Contacten zoeken';

  @override
  String get pickerNoMatchingContacts => 'Geen overeenkomende contacten';

  @override
  String get chatSendFailedShort => 'Verzenden mislukt';

  @override
  String get chatResend => 'Opnieuw verzenden';

  @override
  String get chatStatusRead => 'Lezen';

  @override
  String get pinnedMessageTitle => 'Vastgezet bericht';

  @override
  String pinnedMessageTitleWithIndex(int index, int total) {
    return 'Vastgezet bericht $index/$total';
  }

  @override
  String get pinnedMessageOpen => 'Tik om te bekijken';

  @override
  String get pinnedMessageViewAllTooltip => 'Alles bekijken Vastgezet';

  @override
  String get pinnedMessageUnpinTooltip => 'Losmaken';

  @override
  String pinnedMessageListCount(int count) {
    return '$count Vastgezette berichten';
  }

  @override
  String get pinnedMessageClearAll => 'Alles losmaken';

  @override
  String get pinnedMessageFallback => 'Vastgezet bericht';

  @override
  String get fileUnnamed => 'Naamloos bestand';

  @override
  String get fileNoDownloadUrl => 'Geen downloadlink beschikbaar';

  @override
  String get fileTitle => 'Bestand';

  @override
  String fileSizeLabel(String size) {
    return 'Bestandsgrootte: $size';
  }

  @override
  String get fileDownloadFailed => 'Downloaden mislukt';

  @override
  String get filePreview => 'Voorbeeld';

  @override
  String get fileOpenWithOtherApp => 'Openen in andere app';

  @override
  String get actionEnable => 'Inschakelen';

  @override
  String get actionDisable => 'Uitschakelen';

  @override
  String get profileInviteLoading => 'Uitnodigingscode laden';

  @override
  String get profileInviteEnabled => 'Uitnodigingscode ingeschakeld';

  @override
  String get profileInviteDisabled => 'Uitnodigingscode uitgeschakeld';

  @override
  String profileInviteLoadFailed(String error) {
    return 'Kan uitnodigingscode niet laden: $error';
  }

  @override
  String get profileInviteCopied => 'Gekopieerd';

  @override
  String profileInviteUpdateFailed(String error) {
    return 'Kan uitnodigingscode niet bijwerken: $error';
  }

  @override
  String get stickerStoreTitle => 'Stickerwinkel';

  @override
  String get stickerNoPacks => 'Geen stickerpakketten';

  @override
  String get stickerDetailTitle => 'Stickerdetails';

  @override
  String get stickerProcessing => 'Verwerken...';

  @override
  String get stickerAddCustomTitle => 'Aangepaste sticker toevoegen';

  @override
  String get stickerSortTitle => 'Stickers sorteren';

  @override
  String get stickerMyStickersTitle => 'Mijn stickers';

  @override
  String get stickerSaving => 'Opslaan';

  @override
  String get stickerSortAction => 'Sorteren';

  @override
  String get stickerOrganize => 'Organiseren';

  @override
  String get stickerCustomTitle => 'Aangepaste stickers';

  @override
  String get stickerCustomSubtitle => 'Beheer opgeslagen aangepaste stickers';

  @override
  String get stickerNoSortablePacks => 'Geen stickerpakketten om te sorteren';

  @override
  String get stickerNoCategories => 'Geen stickercategorieën';

  @override
  String get stickerMoveUp => 'Omhoog';

  @override
  String get stickerMoveDown => 'Omlaag';

  @override
  String get stickerNoCustomStickers => 'Geen aangepaste stickers';

  @override
  String get stickerMoveToFront => 'Verplaats naar voren';

  @override
  String get stickerDeleteConfirmTitle =>
      'Verwijderde stickers kunnen niet worden hersteld';

  @override
  String get complaintTitle => 'Rapport';

  @override
  String get complaintHint => 'Beschrijf het probleem';

  @override
  String get complaintType => 'Rapporttype';

  @override
  String get complaintSubmitted => 'Rapport ingediend';

  @override
  String get complaintSubmit => 'Rapport indienen';

  @override
  String get complaintSubmitting => 'Verzenden…';

  @override
  String get complaintFallbackOtherViolation => 'Andere beleidsschending';

  @override
  String get complaintFallbackFraud => 'Andere fraude of oplichting';

  @override
  String get complaintFallbackAccountCompromised =>
      'Account is mogelijk gehackt';

  @override
  String get chatBackgroundTitle => 'Chatachtergrond';

  @override
  String get chatBackgroundLoading => 'Chatachtergronden laden';

  @override
  String get chatBackgroundEmpty => 'Geen chatachtergronden';

  @override
  String get chatBackgroundDefault => 'Standaardachtergrond';

  @override
  String chatBackgroundItem(int index) {
    return 'Achtergrond $index';
  }

  @override
  String get chatBackgroundPreviewTitle => 'Voorbeeldachtergrond';

  @override
  String get chatBackgroundSet => 'Achtergrond instellen';

  @override
  String get chatBackgroundSelectedStatus => 'Chatachtergrond ingesteld';

  @override
  String get chatBackgroundInUse => 'In gebruik';

  @override
  String get chatContactFallback => 'Contactpersoon';

  @override
  String get chatPersonalCard => 'Contactkaart';

  @override
  String get chatSystemMessageDigest => '[Systeembericht]';

  @override
  String get chatMessageDigestMessage => '[Bericht]';

  @override
  String get chatMessageDigestImage => '[Afbeelding]';

  @override
  String get chatMessageDigestVoice => '[Stem]';

  @override
  String get chatMessageDigestVideo => '[Video]';

  @override
  String get chatMessageDigestLocation => '[Locatie]';

  @override
  String get chatMessageDigestCard => '[Contactkaart]';

  @override
  String get chatMessageDigestFile => '[Bestand]';

  @override
  String get chatMessageDigestHistory => '[Chatgeschiedenis]';

  @override
  String get chatMessageDigestSticker => '[Sticker]';

  @override
  String get dateWeekdayShortMonday => 'ma';

  @override
  String get dateWeekdayShortTuesday => 'di';

  @override
  String get dateWeekdayShortWednesday => 'wo';

  @override
  String get dateWeekdayShortThursday => 'Do';

  @override
  String get dateWeekdayShortFriday => 'Vr';

  @override
  String get dateWeekdayShortSaturday => 'za';

  @override
  String get dateWeekdayShortSunday => 'zo';

  @override
  String get appIconClassic => 'Klassiek';

  @override
  String get appIconSimple => 'Eenvoudig';

  @override
  String get appIconDark => 'Donker';

  @override
  String get appIconFestive => 'Feestelijk';

  @override
  String get appIconGradient => 'Verloop';

  @override
  String get appIconUpdated => 'Icoon bijgewerkt';

  @override
  String get appIconUpdateFailed =>
      'Overschakelen mislukt. Probeer het later opnieuw.';

  @override
  String get appearanceBubbleColorPurple => 'Paars';

  @override
  String get appearanceBubbleColorGreen => 'Groen';

  @override
  String get appearanceBubbleColorBlue => 'Blauw';

  @override
  String get appearanceBubbleColorOrange => 'Oranje';

  @override
  String get appearanceBubbleColorPink => 'Roze';

  @override
  String replyPreviewTitle(String name) {
    return 'Reageer op $name';
  }

  @override
  String get replyPreviewCancel => 'Antwoord annuleren';

  @override
  String get chatPasswordTitle => 'Chatwachtwoord';

  @override
  String get chatPasswordHint => 'Voer een wachtwoord van 6 cijfers in';

  @override
  String chatPasswordErrorRemain(int remain) {
    return 'Verkeerd wachtwoord. De chatgeschiedenis wordt gewist na nog eens $remain mislukte pogingen.';
  }

  @override
  String get emojiPackEmpty => 'Geen stickers in dit pakket';

  @override
  String get emojiRecentSection => 'Recent';

  @override
  String get emojiAllSection => 'Alle emoji\'s';

  @override
  String get stickerSearching => 'Zoeken...';

  @override
  String get stickerNoSearchResults => 'Geen resultaten';

  @override
  String get stickerSearchResultsTitle => 'Resultaten:';

  @override
  String get homeChatPasswordWiped =>
      'Te veel verkeerde pogingen. Chatgeschiedenis is verwijderd.';

  @override
  String get homeGroupNotFound => 'Groepschat niet gevonden';

  @override
  String get homeConversationNoHistory => 'Geen chatgeschiedenis';

  @override
  String get homeConversationStartChat => 'Chat starten';

  @override
  String get homeEnterGroupChat => 'Ga naar de groepschat';

  @override
  String get homeNewGroup => 'Nieuwe groepschat';

  @override
  String homeFriendRequestAcceptFailed(String error) {
    return 'Kan niet accepteren: $error';
  }

  @override
  String get homeFriendRequestAccepted => 'Vriendschapsverzoek geaccepteerd';

  @override
  String homeFriendRequestRefuseFailed(String error) {
    return 'Kan niet weigeren: $error';
  }

  @override
  String homeFriendRequestDeleteFailed(String error) {
    return 'Kan niet verwijderen: $error';
  }

  @override
  String contactPresenceOnlineWithDevice(String device) {
    return 'Online op $device';
  }

  @override
  String contactPresenceJustOnlineWithDevice(String device) {
    return 'Zojuist online op $device';
  }

  @override
  String contactPresenceMinutesOnlineWithDevice(int minutes, String device) {
    return 'Online op $device $minutes min geleden';
  }

  @override
  String contactPresenceLastOnline(String time) {
    return 'Laatste online $time';
  }

  @override
  String get contactPresenceDeviceWeb => 'internet';

  @override
  String get contactPresenceDeviceDesktop => 'bureaublad';

  @override
  String get contactPresenceDeviceMobile => 'mobiel';

  @override
  String get botCommandsEmpty => 'Nog geen opdrachten';
}
