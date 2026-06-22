// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get tabMessages => 'Чаты';

  @override
  String get tabContacts => 'Контакты';

  @override
  String get tabDiscover => 'Откройте для себя';

  @override
  String get tabMe => 'Я';

  @override
  String get pageMessagesTitle => 'Чаты';

  @override
  String get pageContactsTitle => 'Контакты';

  @override
  String get pageDiscoverTitle => 'Откройте для себя';

  @override
  String get pageMeTitle => 'Я';

  @override
  String get actionCancel => 'Отмена';

  @override
  String get actionConfirm => 'Подтвердить';

  @override
  String get actionDone => 'Готово';

  @override
  String get actionSave => 'Сохранить';

  @override
  String get actionDelete => 'Удалить';

  @override
  String get actionEdit => 'Редактировать';

  @override
  String get actionAdd => 'Добавить';

  @override
  String get actionRemove => 'Удалить';

  @override
  String get actionInvite => 'Пригласить';

  @override
  String get actionSearch => 'Поиск';

  @override
  String get actionSend => 'Отправить';

  @override
  String get actionRetry => 'Повторить попытку';

  @override
  String get actionBack => 'Назад';

  @override
  String get actionMore => 'Подробнее';

  @override
  String get actionJoin => 'Присоединяйтесь';

  @override
  String get actionSkip => 'Пропустить';

  @override
  String get actionContinue => 'Продолжить';

  @override
  String get actionGetStarted => 'Начало работы';

  @override
  String get actionSaving => 'Сохранение...';

  @override
  String get moduleUnsupported => 'Эта функция недоступна в этой версии.';

  @override
  String get moduleLoading =>
      'Проверка доступа к функциям. Повторите попытку позже.';

  @override
  String get moduleOfflineStale =>
      'Подключитесь к сети, чтобы подтвердить доступ к функциям.';

  @override
  String get onboardingMenuTitle => 'Краткое руководство';

  @override
  String onboardingChatTitle(Object appName) {
    return 'Добро пожаловать в $appName';
  }

  @override
  String get onboardingChatSubtitle =>
      'Чистое, светлое место для более комфортного общения.';

  @override
  String get onboardingFriendsTitle => 'Сделайте общение проще';

  @override
  String get onboardingFriendsSubtitle =>
      'Стало легче находить друзей, группы и функции обмена.';

  @override
  String get onboardingSecurityTitle =>
      'Говорите свободно. Используйте его с уверенностью.';

  @override
  String get onboardingSecuritySubtitle =>
      'Безопасность учетной записи и защита конфиденциальности помогают защитить ваши границы.';

  @override
  String get onboardingChatSemantic =>
      'Иллюстрация подключения синхронизации сообщений';

  @override
  String get onboardingFriendsSemantic =>
      'Иллюстрация регистрации друзей и групп';

  @override
  String get onboardingSecuritySemantic =>
      'Иллюстрация безопасности и конфиденциальности';

  @override
  String get settingsLanguageRow => 'Язык';

  @override
  String get settingsLanguageSystem => 'Система по умолчанию';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => 'английский';

  @override
  String get profileRowFavorites => 'Избранное';

  @override
  String get profileRowSecurityPrivacy => 'Безопасность и конфиденциальность';

  @override
  String get profileRowNotifications => 'Уведомления';

  @override
  String get profileRowInviteCode => 'Пригласительный код';

  @override
  String get profileRowGeneral => 'Общие сведения';

  @override
  String profileRowAbout(Object appName) {
    return 'О $appName';
  }

  @override
  String get profileLogout => 'Выйти';

  @override
  String get profileLogoutConfirm =>
      'Выход из системы не приведет к удалению истории. Вы можете войти в систему с этой учетной записью в любое время.';

  @override
  String profileMoyuIdLabel(Object appName, Object value) {
    return '$appName ID: $value';
  }

  @override
  String get profileDefaultName => 'Я';

  @override
  String get profileDetailTitle => 'Профиль';

  @override
  String get profileAvatar => 'Аватар';

  @override
  String get profileNickname => 'Псевдоним';

  @override
  String get profileEditNickname => 'Изменить псевдоним';

  @override
  String profileEditFoxId(Object appName) {
    return 'Изменить идентификатор $appName';
  }

  @override
  String get profileGender => 'Пол';

  @override
  String get profileGenderMale => 'Мужчина';

  @override
  String get profileGenderFemale => 'Женский';

  @override
  String get profileGenderSelected => 'Выбрано';

  @override
  String get profileGenderUnset => 'Не установлено';

  @override
  String get profilePhoneUnbound => 'Не связано';

  @override
  String get profileAvatarUpdated => 'Аватар обновлен';

  @override
  String get profileAvatarUpdateFailed =>
      'Не удалось загрузить аватар. Попробуйте еще раз.';

  @override
  String get generalPageTitle => 'Общие сведения';

  @override
  String get generalFontSize => 'Размер шрифта';

  @override
  String get generalChatBackground => 'Фон чата';

  @override
  String get generalDarkMode => 'Темный режим';

  @override
  String get generalClearCache => 'Очистить кэш';

  @override
  String get generalClearMessages => 'Очистить историю чата';

  @override
  String get generalAppModules => 'Особенности';

  @override
  String get generalErrorLogs => 'Журналы ошибок';

  @override
  String get generalThirdShare => 'Сторонние SDKs';

  @override
  String get fontSizeSmall => 'Маленький';

  @override
  String get fontSizeStandard => 'Стандартный';

  @override
  String get fontSizeLarge => 'Большой';

  @override
  String get fontSizeExtraLarge => 'Очень большой';

  @override
  String get darkModeSystem => 'Система по умолчанию';

  @override
  String get darkModeLight => 'Свет';

  @override
  String get darkModeDark => 'Темный';

  @override
  String get valueConfigure => 'Настроить';

  @override
  String get valueManage => 'Управление';

  @override
  String get valueClear => 'Очистить';

  @override
  String get valueUpload => 'Загрузить';

  @override
  String get valueDownload => 'Скачать';

  @override
  String get valueView => 'Посмотреть';

  @override
  String get valueEnabled => 'Включено';

  @override
  String get valueDisabled => 'Отключено';

  @override
  String get valueOn => 'Вкл.';

  @override
  String get valueOff => 'Выкл.';

  @override
  String get valueConfigured => 'Набор';

  @override
  String get valueNotEnabled => 'Не включено';

  @override
  String get valueSelected => 'Выбрано';

  @override
  String get valueCurrentDevice => 'Это устройство';

  @override
  String get valueSdkInfo => 'SDK Информация';

  @override
  String get statusProcessing => 'Обработка';

  @override
  String get statusLoading => 'Загрузка';

  @override
  String get statusSending => 'Отправка';

  @override
  String get statusSaving => 'Сохранение';

  @override
  String get statusSaved => 'сохранено';

  @override
  String get statusSent => 'Отправлено';

  @override
  String get statusSubmitted => 'Отправлено';

  @override
  String get dateJustNow => 'Только что';

  @override
  String get dateToday => 'Сегодня';

  @override
  String get dateYesterday => 'Вчера';

  @override
  String get dateDayBeforeYesterday => 'Позавчера';

  @override
  String dateTodayTime(Object time) {
    return 'Сегодня $time';
  }

  @override
  String dateYesterdayTime(Object time) {
    return 'Вчера $time';
  }

  @override
  String dateDayBeforeYesterdayTime(Object time) {
    return 'Два дня назад $time';
  }

  @override
  String dateWeekdayTime(Object time, Object weekday) {
    return '$weekday $time';
  }

  @override
  String dateMonthDayTime(Object day, Object month, Object time) {
    return '$day.$month $time';
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
    return '$day.$month';
  }

  @override
  String dateYearMonthDay(Object day, Object month, Object year) {
    return '$day.$month.$year';
  }

  @override
  String get weekdayMonday => 'понедельник';

  @override
  String get weekdayTuesday => 'вторник';

  @override
  String get weekdayWednesday => 'среда';

  @override
  String get weekdayThursday => 'Четверг';

  @override
  String get weekdayFriday => 'Пятница';

  @override
  String get weekdaySaturday => 'Суббота';

  @override
  String get weekdaySunday => 'воскресенье';

  @override
  String get dialogClearAllTitle => 'Очистить всю историю чата?';

  @override
  String get dialogClearAllBody =>
      'Вся история локального чата и записи разговоров будут удалены.';

  @override
  String get authLoginSubtitle =>
      'Войдите под своим номером телефона и продолжайте общаться с друзьями';

  @override
  String get authLoginIllustration => 'Иллюстрация входа в систему';

  @override
  String get authRegisterIllustration => 'Иллюстрация регистрации';

  @override
  String get authSecurityIllustration => 'Иллюстрация проверки';

  @override
  String get authResetIllustration => 'Иллюстрация сброса пароля';

  @override
  String get authServerLabel => 'Сервер';

  @override
  String get authServerCustomLabel => 'Custom server';

  @override
  String get authServerCustomHint => 'Enter server address';

  @override
  String get authPhoneLabel => 'Номер телефона';

  @override
  String get authPasswordLabel => 'Пароль';

  @override
  String get authForgotPassword => 'Забыли пароль?';

  @override
  String get authLoginButton => 'Войти';

  @override
  String get authLoginLoading => 'Вход в систему...';

  @override
  String get authRegisterButton => 'Зарегистрироваться';

  @override
  String get authLoginWithApple => 'Sign in with Apple';

  @override
  String get authLoginWithGoogle => 'Sign in with Google';

  @override
  String get authLoginWithGithub => 'Sign in with GitHub';

  @override
  String get authLoginAgreementPrefix => 'Входя в систему, вы соглашаетесь';

  @override
  String get authTermsTitle => 'Условия использования';

  @override
  String get authAgreementConnector => 'и';

  @override
  String get authPrivacyTitle => 'Политика конфиденциальности';

  @override
  String get authVerifyTitle => 'Проверка входа в систему';

  @override
  String authVerifySubtitleWithPhone(Object phone) {
    return 'Введите код, отправленный на $phone.';
  }

  @override
  String get authVerifySubtitlePasswordFirst =>
      'Сначала войдите под своим паролем, чтобы начать проверку безопасности.';

  @override
  String get authVerifyButton => 'Проверить';

  @override
  String get authVerifyLoading => 'Проверка...';

  @override
  String get authResendCode => 'Не получили код? Отправить повторно';

  @override
  String get authVerificationCodeSent => 'Код подтверждения отправлен';

  @override
  String get authVerificationCodeRequired => 'Введите проверочный код';

  @override
  String get authVerificationCodeSixDigits => 'Введите 6-значный код';

  @override
  String get authPasswordResetTitle => 'Сбросить пароль для входа';

  @override
  String get authPasswordResetSubtitle =>
      'Подтвердите свой номер телефона, затем установите новый пароль для входа.';

  @override
  String get authPasswordResetButton => 'Сбросить пароль';

  @override
  String get authKickedTitle =>
      'В вашу учетную запись выполнен вход на другом устройстве.';

  @override
  String get authSubmitting => 'Отправка...';

  @override
  String get authVerificationCodeLabel => 'Код подтверждения';

  @override
  String get authGetVerificationCode => 'Получить код';

  @override
  String get authNewPasswordLabel => 'Новый пароль';

  @override
  String get authPasswordResetSuccess => 'Сброс пароля';

  @override
  String authRegisterTitle(Object appName) {
    return 'Создайте учетную запись $appName';
  }

  @override
  String get authRegisterSubtitle =>
      'Зарегистрируйтесь, указав свой номер телефона, и сразу же начните общаться';

  @override
  String get authCreateAccount => 'Создать учетную запись';

  @override
  String get authNicknameLabel => 'Псевдоним';

  @override
  String get authInviteCodeRequiredLabel => 'Пригласительный код (обязательно)';

  @override
  String authCodeRetryAfter(Object seconds) {
    return 'Повторить попытку через $seconds с.';
  }

  @override
  String get authRegisterAgreement =>
      'Я прочитал и согласен с Условиями обслуживания и Политикой конфиденциальности.';

  @override
  String get authInvalidPhone => 'Неверный номер телефона.';

  @override
  String get authAcceptAgreementFirst =>
      'Сначала согласитесь с Условиями обслуживания и Политикой конфиденциальности.';

  @override
  String get authCodeEmpty => 'Требуется код подтверждения';

  @override
  String get authPasswordLengthInvalid =>
      'Пароль должен состоять из 6–16 символов.';

  @override
  String get authInviteCodeEmpty => 'Требуется пригласительный код';

  @override
  String get authRegisterSuccess => 'Зарегистрирован успешно';

  @override
  String get settingsCheckNewVersion => 'Проверить наличие обновлений';

  @override
  String get settingsChecking => 'Проверка';

  @override
  String get settingsVersionFound => 'Доступно обновление';

  @override
  String get settingsUserAgreement => 'Условия использования';

  @override
  String get settingsPrivacyPolicy => 'Политика конфиденциальности';

  @override
  String get settingsView => 'Посмотреть';

  @override
  String get settingsSwitchAccount => 'Сменить аккаунт';

  @override
  String get settingsCacheCleared => 'Кэш очищен';

  @override
  String get settingsClearCacheSheetTitle =>
      'Очистить кеш изображений/видео?\nИзображения чата, обложки видео и аватары будут загружены повторно.';

  @override
  String get settingsClearCacheAction => 'Очистить кэш';

  @override
  String get settingsMessagesCleared => 'История чата очищена';

  @override
  String settingsClearMessagesFailed(Object error) {
    return 'Не удалось очистить историю чата: $error.';
  }

  @override
  String get settingsAlreadyLatestVersion =>
      'Вы уже используете последнюю версию';

  @override
  String get settingsCheckFailed => 'Проверка не удалась';

  @override
  String settingsUpdateDialogTitle(Object version) {
    return 'Доступно обновление\nПоследняя версия: $version';
  }

  @override
  String settingsUpdateDialogTitleWithDescription(
    Object description,
    Object version,
  ) {
    return 'Доступно обновление\nПоследняя версия: $version\n$description';
  }

  @override
  String get settingsLater => 'Позже';

  @override
  String get settingsUpdateNow => 'Обновить сейчас';

  @override
  String get settingsSaveFailedRetry =>
      'Не удалось сохранить. Попробуйте еще раз.';

  @override
  String get securityAllowPhoneSearch =>
      'Разрешить другим найти меня по номеру телефона';

  @override
  String securityAllowFoxIdSearch(Object appName) {
    return 'Разрешить другим найти меня по идентификатору $appName';
  }

  @override
  String get securitySearchRemark =>
      'Если этот параметр отключен, другие пользователи не смогут найти вас по приведенной выше информации.';

  @override
  String get securityJoinGroupNeedConfirm =>
      'Require confirmation to join groups';

  @override
  String get securityJoinGroupNeedConfirmRemark =>
      'When on, invitations to add you to a group must be confirmed by you first.';

  @override
  String get securityLoginPassword => 'Пароль для входа';

  @override
  String get securityChatPassword => 'Пароль чата';

  @override
  String get securityScreenProtection => 'Защита экрана';

  @override
  String get securityLockPassword => 'Пароль блокировки';

  @override
  String get securityOfflineProtection =>
      'Блокировка экрана в автономном режиме';

  @override
  String get securityDeviceManagement => 'Управление устройствами входа';

  @override
  String get securityDeviceRemark =>
      'Просматривайте устройства и управляйте ими, включите защиту входа в систему и обеспечьте безопасность своей учетной записи.';

  @override
  String get securityBlacklist => 'Черный список';

  @override
  String get securityAccountDeletion => 'Удалить аккаунт';

  @override
  String get accountDeletionBody =>
      'Удаление аккаунта невозможно отменить. После подтверждения по SMS будет отправлен код подтверждения для завершения удаления.';

  @override
  String get accountDeletionSubmitted => 'Запрос на удаление отправлен';

  @override
  String get accountDeletionGetCode => 'Получить код';

  @override
  String get passwordResetInstruction =>
      'Для изменения пароля для входа требуется SMS-код. Новый пароль должен содержать не менее 6 символов.';

  @override
  String get accountPhoneLabel => 'Номер телефона';

  @override
  String get passwordRuleLabel => 'Правило пароля';

  @override
  String get passwordAtLeastSix => 'Не менее 6 символов';

  @override
  String get passwordConfirmLabel => 'Подтвердите пароль';

  @override
  String get passwordConfirmHint => 'Введите пароль для входа еще раз';

  @override
  String get passwordChanged => 'Пароль для входа изменен';

  @override
  String get phoneRequired => 'Требуется номер телефона';

  @override
  String get passwordMismatch => 'Пароли не совпадают';

  @override
  String get chatPasswordInstruction =>
      'Если этот параметр включен, этот 6-значный пароль требуется перед открытием защищенных чатов.';

  @override
  String get currentStatusLabel => 'Текущий статус';

  @override
  String get passwordSixDigits => '6 цифр';

  @override
  String get chatPasswordEnableAction => 'Включить пароль чата';

  @override
  String get loginPasswordRequired => 'Требуется пароль для входа';

  @override
  String get chatPasswordSixDigitsRequired =>
      'Пароль чата должен состоять из 6 цифр.';

  @override
  String get lockSetTitle => 'Установите 6-значный пароль блокировки';

  @override
  String lockSetSubtitle(Object appName) {
    return 'Требуется для разблокировки $appName';
  }

  @override
  String get lockCurrentPromptTitle => 'Введите текущий пароль блокировки';

  @override
  String get lockCurrentPromptSubtitle =>
      'Проверьте, прежде чем изменять или отключать его.';

  @override
  String get lockAutoLock => 'Автоматическая блокировка';

  @override
  String get lockChangePassword => 'Изменить пароль разблокировки';

  @override
  String get lockClosePassword => 'Отключить пароль разблокировки';

  @override
  String get lockWrongPassword => 'Неправильный пароль. Попробуйте еще раз.';

  @override
  String get lockSixDigitsRequired =>
      'Пароль блокировки должен состоять из 6 цифр.';

  @override
  String get lockInputTitle => 'Введите пароль блокировки';

  @override
  String lockInputSubtitle(Object appName) {
    return 'Разблокируйте, чтобы продолжить использование $appName.';
  }

  @override
  String get lockSetFailed => 'Не удалось установить. Попробуйте еще раз.';

  @override
  String get lockImmediately => 'Немедленно';

  @override
  String get lockAfter5Minutes => 'Через 5 минут';

  @override
  String get lockAfter30Minutes => 'Через 30 минут езды';

  @override
  String get lockAfter1Hour => 'Через 1 час езды';

  @override
  String get deviceLoginProtection => 'Защита входа';

  @override
  String get deviceProtectionRemark =>
      'Если включена защита входа в систему, требуется проверка безопасности на незнакомых устройствах. Рекомендуется для безопасности аккаунта.';

  @override
  String get deviceNone => 'Нет устройств, вошедших в систему';

  @override
  String get deviceDebugName => 'Текущее устройство';

  @override
  String get deviceDebugPlatform => 'Устройство отладки iPhone/Android';

  @override
  String get deviceProtectionEnabled => 'Защита входа включена';

  @override
  String get deviceProtectionDisabled => 'Защита входа отключена';

  @override
  String get deviceProtectionUpdateFailed =>
      'Не удалось обновить защиту входа. Попробуйте еще раз.';

  @override
  String get blacklistEmpty => 'Нет контактов в черном списке';

  @override
  String get switchAccountRecent => 'Недавние аккаунты';

  @override
  String get switchAccountLoading => 'Чтение последних аккаунтов';

  @override
  String get switchAccountAddOther =>
      'Добавьте или войдите в другую учетную запись';

  @override
  String get switchAccountCurrent => 'Текущий';

  @override
  String get appModulesLoading => 'Загрузка функциональных модулей';

  @override
  String get appModulesEmpty => 'Нет функциональных модулей';

  @override
  String get appModulesUnavailable => 'Модуль недоступен';

  @override
  String get errorLogsLoading => 'Чтение журналов ошибок';

  @override
  String get errorLogsEmpty => 'Нет журналов ошибок';

  @override
  String get errorLogFileName => 'Имя файла';

  @override
  String get errorLogFileSize => 'Размер файла';

  @override
  String get errorLogGeneratedAt => 'Создано в';

  @override
  String get errorLogFilePath => 'Путь к файлу';

  @override
  String get notificationReceiveNew =>
      'Получать уведомления о новых сообщениях';

  @override
  String get notificationSound => 'Звук';

  @override
  String get notificationVibration => 'Вибрация';

  @override
  String get notificationShowDetails => 'Показать сведения об уведомлении';

  @override
  String get notificationSystem => 'Уведомления о системных сообщениях';

  @override
  String get notificationCalls => 'Уведомления об аудио/видеовызовах';

  @override
  String get settingsGoToSystem => 'Настройки';

  @override
  String aboutAppIconSemantic(Object appName) {
    return 'Значок $appName';
  }

  @override
  String aboutCopyright(Object appName) {
    return 'Авторские права © 2026\n$appName. Все права защищены.';
  }

  @override
  String get policyWebUrl => 'Web URL';

  @override
  String get appearanceTitle => 'Внешний вид';

  @override
  String get appearanceAppIcon => 'Значок приложения';

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
  String get appearanceChatColor => 'Цвет чата';

  @override
  String get appearanceBubbleRadius => 'Радиус угла пузыря';

  @override
  String get appearanceBubbleColorInk => 'Чернила черные';

  @override
  String get appearanceSquare => 'Квадрат';

  @override
  String get appearanceRound => 'Раунд';

  @override
  String get appearancePreviewOne =>
      'Он хочет, чтобы я повернул направо или налево? 🤔';

  @override
  String get appearancePreviewTwo => 'Верно. И, ну, сделайте его сильным.';

  @override
  String get appearancePreviewThree =>
      'И это все? Мне кажется, он сказал больше, чем это. 😯';

  @override
  String get appearancePreviewFour =>
      'Вот и все. Позже я отправлю голосовое сообщение с более подробной информацией.';

  @override
  String get contactsEmptyTitle => 'Контактов пока нет';

  @override
  String get contactsEmptySubtitle =>
      'Добавьте друзей вверху справа или отсканируйте карточку профиля.';

  @override
  String contactsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count контакты',
      one: '1 контакт',
    );
    return '$_temp0';
  }

  @override
  String get contactAddTooltip => 'Добавить друга';

  @override
  String get contactSearchHint => 'Поиск контактов и групп';

  @override
  String get contactSetRemark => 'Установить примечание';

  @override
  String get contactAddToBlacklist => 'Добавить в черный список';

  @override
  String get contactDeleteFriend => 'Удалить друга';

  @override
  String get contactAddedToBlacklist => 'Добавлен в черный список';

  @override
  String get operationFailed => 'Операция не удалась. Попробуйте еще раз.';

  @override
  String operationFailedWithError(String error) {
    return 'Операция не удалась: $error';
  }

  @override
  String contactDeleteFriendConfirm(Object name) {
    return 'Удалить друга \"$name\"?\nИстория чата также будет очищена.';
  }

  @override
  String get contactConfirmDelete => 'Подтвердить удаление';

  @override
  String get contactDeleted => 'Друг удален';

  @override
  String get contactUnknownUser => 'Неизвестный пользователь';

  @override
  String get contactActionNewFriends => 'Новые друзья';

  @override
  String get contactActionSavedGroups => 'Сохраненные группы';

  @override
  String get contactSearchNoMatches => 'Нет подходящих контактов';

  @override
  String get addFriendTitle => 'Добавить друга';

  @override
  String addFriendSearchHint(Object appName) {
    return 'Телефон / $appName Идентификатор';
  }

  @override
  String get addFriendNotFound => 'Аккаунт не найден';

  @override
  String get myQrCodeTitle => 'Мой QR-код';

  @override
  String myQrCodeSubtitle(Object appName) {
    return 'Отсканируйте этот QR-код, чтобы добавить меня в $appName';
  }

  @override
  String get myQrCodeEmpty => 'Нет QR-кода';

  @override
  String get scanTitle => 'Сканирование';

  @override
  String get scanQrNotFound => 'QR-код не распознан';

  @override
  String scanResolveFailed(String error) {
    return 'Не удалось проанализировать QR-код: $error.';
  }

  @override
  String get scanUnrecognized => 'Этот QR-код невозможно распознать';

  @override
  String get scanInfoIncomplete => 'Информация о QR-коде неполная';

  @override
  String get scanSocialUnavailable => 'Социальная служба не инициализирована';

  @override
  String get scanJoinedGroup => 'Присоединился к групповому чату';

  @override
  String get scanCannotOpenGroup =>
      'На этой странице нельзя открывать групповые чаты';

  @override
  String get scanGroupNotFound => 'Групповой чат не найден';

  @override
  String get scanOpenGroupFailed => 'Не удалось открыть групповой чат.';

  @override
  String get scanSelfQr => 'Это ваш собственный QR-код';

  @override
  String get scanUserNotFound => 'Пользователь не найден';

  @override
  String get scanCameraPermissionRequired => 'Требуется разрешение камеры';

  @override
  String get scanOpenSettings => 'Открыть настройки';

  @override
  String get scanCameraUnavailable => 'Камера недоступна';

  @override
  String get scanAlbum => 'Альбом';

  @override
  String get scanLightOn => 'Свет горит';

  @override
  String get scanLightOff => 'Свет выключен';

  @override
  String get scanQrCode => 'QR-код';

  @override
  String get scanGroupFallback => 'Групповой чат';

  @override
  String get scanGroupLoadingInfo => 'Загрузка информации о группе';

  @override
  String scanGroupMemberCount(int count) {
    return '$count участников';
  }

  @override
  String get scanJoinGroupConfirm => 'Присоединиться к групповому чату';

  @override
  String get scanJoining => 'Присоединение';

  @override
  String get scanJoinGroup => 'Присоединиться к групповому чату';

  @override
  String scanJoinFailed(String error) {
    return 'Не удалось присоединиться: $error';
  }

  @override
  String get tagsTitle => 'Теги';

  @override
  String get tagsCreateTooltip => 'Новый тег';

  @override
  String get tagsContactSection => 'Теги контактов';

  @override
  String get tagsEmptyTitle => 'Нет тегов';

  @override
  String get tagsEmptySubtitle =>
      'Нажмите + в правом верхнем углу, чтобы сгруппировать контакты или чаты.';

  @override
  String tagsCreateFailed(Object error) {
    return 'Не удалось создать тег: $error.';
  }

  @override
  String tagsUpdateFailed(Object error) {
    return 'Не удалось обновить тег: $error.';
  }

  @override
  String tagsDeleteFailed(Object error) {
    return 'Не удалось удалить тег: $error.';
  }

  @override
  String tagsLoadFailed(Object error) {
    return 'Не удалось загрузить теги: $error.';
  }

  @override
  String tagsDeleteConfirm(String name) {
    return 'Удалить тег \"$name\"?\nКонтакты и группы в этом теге не будут удалены.';
  }

  @override
  String get tagsEditTitle => 'Изменить тег';

  @override
  String get tagsCreateTitle => 'Новый тег';

  @override
  String get tagsNameSection => 'Имя тега';

  @override
  String get tagsNameHint => 'Семья, друзья';

  @override
  String tagsMembersSection(int count) {
    return 'Отметить участников ($count)';
  }

  @override
  String get tagsAddMember => 'Добавить участника';

  @override
  String get tagsDelete => 'Удалить тег';

  @override
  String get tagsGroupInitial => 'Г';

  @override
  String get tagsUnknownUser => 'Неизвестный пользователь';

  @override
  String get tagsSelectMembersTitle => 'Выбор участников';

  @override
  String tagsDoneCount(int count) {
    return 'Готово ($count)';
  }

  @override
  String get tagsSearchHint => 'Поиск контактов или групп';

  @override
  String get tagsGroupsSection => 'Групповые чаты';

  @override
  String get tagsContactsSection => 'Контакты';

  @override
  String get tagsNoMatchesTitle => 'Нет совпадений';

  @override
  String get tagsNoMatchesSubtitle => 'Попробуйте другое ключевое слово';

  @override
  String tagsRowTitle(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get phoneContactsTitle => 'Телефонные контакты';

  @override
  String get phoneContactsSection => 'Добавить из контактов телефона';

  @override
  String get phoneContactsEmpty => 'Нет телефонных контактов';

  @override
  String get phoneContactsNoAddable =>
      'Нет телефонных контактов для добавления.';

  @override
  String get phoneContactsServerSyncFailed =>
      'Не удалось синхронизировать сервер. Показаны существующие контакты.';

  @override
  String get friendAlreadyAdded => 'Добавлено';

  @override
  String get friendRequestSent => 'Запрос на добавление в друзья отправлен';

  @override
  String phoneContactsInviteSmsBody(Object appName) {
    return 'Я использую $appName. Опыт общения в чате довольно приятный. Приходите и вы попробуйте.';
  }

  @override
  String get phoneContactsInviteOpened => 'SMS-приглашение открыто.';

  @override
  String get phoneContactsInviteFailed =>
      'Невозможно открыть SMS. Пожалуйста, пригласите вручную.';

  @override
  String get friendRequestsEmptyTitle => 'Нет новых друзей';

  @override
  String get friendRequestsEmptySubtitle =>
      'Пригласите друзей отсканировать ваш QR-код';

  @override
  String get friendRequestsPendingSection => 'Ожидается';

  @override
  String get friendRequestRefused => 'Отказано';

  @override
  String contactOpenFromContacts(Object name) {
    return 'Открыть чат @$name из контактов';
  }

  @override
  String get fileHelperIntro =>
      'Войдите в веб-версию и отправляйте мне сообщения для передачи текста, фотографий, аудио, видео и файлов между телефоном и компьютером.';

  @override
  String get fileHelperName => 'File Transfer';

  @override
  String get systemAccountName => 'System';

  @override
  String systemAccountIntro(Object appName) {
    return 'Официальный аккаунт $appName для отправки уведомлений.';
  }

  @override
  String get contactIntroTitle => 'Введение';

  @override
  String get contactSource => 'Источник';

  @override
  String get contactRemoveFriendRelation => 'Удалить друга';

  @override
  String get contactRemoveFromBlacklist => 'Удалить из черного списка';

  @override
  String get contactSendMessage => 'Сообщение';

  @override
  String get contactAddToContacts => 'Добавить в контакты';

  @override
  String get contactRemoveFriendConfirm => 'Удалить этого друга?';

  @override
  String contactNicknameLine(Object name) {
    return 'Псевдоним: $name';
  }

  @override
  String get contactRemoveFromBlacklistConfirm =>
      'Удалить этот контакт из черного списка?';

  @override
  String get webLoginTitle => 'Web Вход';

  @override
  String get webLoginConfirmTitle => 'Подтвердить вход в Интернет?';

  @override
  String get webLoginConfirmBody =>
      'Это позволит вашей учетной записи войти в текущий клиент браузера или настольного компьютера. Если это были не вы, нажмите «Отмена».';

  @override
  String get webLoginConfirmAction => 'Подтвердить вход';

  @override
  String get webLoginConfirming => 'Подтверждаю...';

  @override
  String get webLoginConfirmed => 'Web вход подтвержден';

  @override
  String webLoginConfirmFailed(Object error) {
    return 'Не удалось подтвердить: $error';
  }

  @override
  String get applyFriendTitle => 'Запрос на добавление в друзья';

  @override
  String get applyFriendSectionTitle =>
      'Отправить запрос на добавление в друзья';

  @override
  String get applyFriendRemarkHint => 'Привет, я...';

  @override
  String friendRequestSendFailed(Object error) {
    return 'Не удалось отправить: $error';
  }

  @override
  String get contactRemarkHint => 'Примечание';

  @override
  String get momentPermissionsTitle => 'Моменты конфиденциальности';

  @override
  String get momentHideMineFromContact => 'Скрыть от них мои моменты';

  @override
  String get momentHideContactFromMe => 'Скройте от меня свои моменты';

  @override
  String get momentTitle => 'Моменты';

  @override
  String get momentPersonalEmpty => 'Сообщений пока нет';

  @override
  String get momentEmpty => 'Пока нет моментов';

  @override
  String get momentCoverUploadFailed => 'Не удалось загрузить обложку.';

  @override
  String momentCoverUploadFailedWithError(Object error) {
    return 'Не удалось загрузить обложку: $error.';
  }

  @override
  String get momentDeleteConfirm => 'Удалить этот момент?';

  @override
  String get momentJustNow => 'Только что';

  @override
  String get momentPublishing => 'Posting…';

  @override
  String get momentPublishFailed => 'Failed to post. Tap to dismiss.';

  @override
  String get momentRemindedYou => 'Напомнил вам просмотреть этот момент';

  @override
  String momentRemindedNames(Object names) {
    return 'Напомнил $names';
  }

  @override
  String get momentKeepEditingConfirm => 'Сохранить это изменение?';

  @override
  String get momentContinueEditing => 'Продолжайте редактировать';

  @override
  String get momentSaveDraft => 'Сохранить черновик';

  @override
  String get momentDiscardDraft => 'Отменить';

  @override
  String get momentPublishTitle => 'Публикация';

  @override
  String get momentPublishHint => 'Что у тебя на уме...';

  @override
  String get momentLocationTitle => 'Местоположение';

  @override
  String get momentRemindWho => 'Напомнить';

  @override
  String get locationUnsupported => 'Местоположение недоступно в этой версии';

  @override
  String momentPrivacyContactCount(Object count, Object label) {
    return '$label · $count';
  }

  @override
  String get momentSelectVisibleContacts => 'Выберите видимые контакты';

  @override
  String get momentSelectHiddenContacts => 'Выберите скрытые контакты';

  @override
  String get momentPrivacyPublic => 'Публичный';

  @override
  String get momentPrivacyPrivate => 'Частное';

  @override
  String get momentPrivacyInternal => 'Виден некоторым';

  @override
  String get momentPrivacyProhibit => 'Скрыть от';

  @override
  String get momentPrivacyWhoCanSee => 'Кто может видеть';

  @override
  String momentCommentFailed(Object error) {
    return 'Не удалось оставить комментарий: $error';
  }

  @override
  String get momentDetailTitle => 'Подробности';

  @override
  String get momentDeleted => 'Этот момент был удален';

  @override
  String get momentCollapse => 'Свернуть';

  @override
  String get momentFullText => 'Полный текст';

  @override
  String get momentDeleteCommentConfirm => 'Удалить этот комментарий?';

  @override
  String get momentCommentPlaceholder => 'Комментарий';

  @override
  String momentReplyPlaceholder(Object name) {
    return 'Ответить $name';
  }

  @override
  String get momentLikeAction => 'Нравится';

  @override
  String get momentCommentAction => 'Комментарий';

  @override
  String momentNewMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count новых сообщений',
      one: '1 новое сообщение',
    );
    return '$_temp0';
  }

  @override
  String get messagesTitle => 'Сообщения';

  @override
  String get messagesEmpty => 'Нет сообщений';

  @override
  String get messagesEmptyTitle => 'Сообщений пока нет';

  @override
  String get messagesEmptySubtitle => 'Начать новый чат сверху справа';

  @override
  String get messagesNewConversation => 'Новый';

  @override
  String get messagesStartGroupChat => 'Начать групповой чат';

  @override
  String get messagesImDisconnected => 'чат не подключен';

  @override
  String get messagesPinned => 'закреплено';

  @override
  String get messagesUnpinned => 'Откреплено';

  @override
  String get messagesMuted => 'Звук отключен';

  @override
  String get messagesNotificationsOn => 'Уведомления включены';

  @override
  String messagesDeleteConversationTitle(String name) {
    return 'Удалить \"$name\"?';
  }

  @override
  String get messagesConfirmDelete => 'Удалить';

  @override
  String get messagesCleared => 'История чата очищена';

  @override
  String get messagesConversationDeleted => 'Разговор удален';

  @override
  String get messagesUnknownUser => 'Неизвестный пользователь';

  @override
  String get messagesFriendAvatarFallback => 'Ф';

  @override
  String get messagesGroupFallback => 'Групповой чат';

  @override
  String get messagesGroupAvatarFallback => 'Г';

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
      'Network unavailable. Проверьте свое соединение.';

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
    return 'Location permission is off. Разрешите $appName использовать местоположение в настройках системы.';
  }

  @override
  String get locationPermissionDenied =>
      'Location permission was denied. Nearby places cannot be loaded.';

  @override
  String get locationMapUnsupported =>
      'AMap не поддерживается на этой платформе';

  @override
  String locationFailed(String error) {
    return 'Location failed: $error';
  }

  @override
  String get locationSearchPrompt =>
      'Введите ключевые слова для поиска мест поблизости';

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
  String get momentReplyConnector => 'replied to';

  @override
  String get groupRemarkTitle => 'Примечание группы';

  @override
  String get groupRemarkHint =>
      'Сделать групповое примечание видимым только для вас';

  @override
  String get chatNotificationSettingsTitle => 'Уведомления о сообщениях';

  @override
  String get chatScreenshotNotification => 'Уведомления о снимках экрана';

  @override
  String get chatRevokeNotification => 'Уведомления об отзыве';

  @override
  String get completeProfileTitle => 'Полный профиль';

  @override
  String get completeProfileUploadAvatar => 'Загрузить аватар';

  @override
  String get completeProfileReuploadAvatar => 'Загрузить новый аватар';

  @override
  String get completeProfileChooseAvatar => 'Выберите фотографию профиля';

  @override
  String get completeProfileAvatarUploaded => 'Аватар загружен';

  @override
  String get completeProfileAvatarRequired => 'Требуется аватар.';

  @override
  String get nicknameLabel => 'Псевдоним';

  @override
  String get nicknameInputHint => 'Введите псевдоним';

  @override
  String get nicknameRequired => 'Требуется псевдоним.';

  @override
  String get completeProfileSaved => 'Профиль завершен';

  @override
  String get chatSettingsTitle => 'Подробности чата';

  @override
  String chatSettingsGroupTitle(Object count) {
    return 'Информация о чате ($count)';
  }

  @override
  String get chatSettingsGroupName => 'Имя группового чата';

  @override
  String get chatSettingsGroupQrCode => 'QR-код группы';

  @override
  String get chatSearchContentTitle => 'Поиск в чате';

  @override
  String get chatSettingsBackground => 'Установить фон чата';

  @override
  String get chatSettingsBackgroundSelected => 'Текущий набор фона чата';

  @override
  String get chatSettingsMute => 'Отключение уведомлений';

  @override
  String get chatSettingsPin => 'Закрепить чат';

  @override
  String get chatSettingsSaveToContacts => 'Сохранить в контактах';

  @override
  String get chatSettingsReadReceipt => 'Квитанции о прочтении';

  @override
  String get chatSettingsReadReceiptSubtitle =>
      'Если эта функция включена, отправленные сообщения показывают статус прочитанного/непрочитанного.';

  @override
  String get chatSettingsFlame => 'Сжечь после прочтения';

  @override
  String get chatFlameTipExit =>
      'Прочитанные сообщения удаляются после выхода из чата';

  @override
  String chatFlameTipMinutes(Object minutes) {
    return 'Сообщения уничтожаются через $minutes минут после прочтения';
  }

  @override
  String chatFlameTipSeconds(Object seconds) {
    return 'Сообщения уничтожаются через $seconds с. после прочтения';
  }

  @override
  String chatFlameLabelMinutes(Object minutes) {
    return '$minutes мин.';
  }

  @override
  String chatFlameLabelSeconds(Object seconds) {
    return '$secondsс';
  }

  @override
  String get chatSettingsGroupNickname => 'Псевдоним моей группы';

  @override
  String get chatSettingsBlacklisted => 'Внесен в черный список';

  @override
  String get chatSettingsPeerBlacklisted =>
      'Этот контакт уже занесен в черный список';

  @override
  String get chatSettingsComplaint => 'Отчет';

  @override
  String get chatSettingsDeleteAndExit => 'Удалить и выйти';

  @override
  String groupRemarkSyncFailed(Object error) {
    return 'Не удалось синхронизировать примечание группы: $error.';
  }

  @override
  String get chatSocialDisconnected => 'Социальный сервис не подключен';

  @override
  String get chatNoRemovableMembers => 'Нет съемных элементов';

  @override
  String get chatSelectMembersToRemove => 'Выберите участников для удаления';

  @override
  String chatMemberNameQuoted(Object name) {
    return '\"$name\"';
  }

  @override
  String chatMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участников',
      one: '1 участник',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersConfirm(Object names) {
    return 'Удалить $names из группы';
  }

  @override
  String chatMembersRemoved(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удален $count участников',
      one: 'Удален 1 участник',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersFailed(Object error) {
    return 'Не удалось удалить участников: $error.';
  }

  @override
  String get chatNoInviteCandidates =>
      'Нет доступных контактов для приглашения';

  @override
  String get chatInviteMembers => 'Пригласить участников';

  @override
  String get chatSelectContacts => 'Выберите контакты';

  @override
  String chatMembersInvited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Приглашено $count участников',
      one: 'Приглашен 1 участник',
    );
    return '$_temp0';
  }

  @override
  String chatInviteMembersFailed(Object error) {
    return 'Не удалось пригласить участников: $error.';
  }

  @override
  String get chatGroupCreated =>
      'Групповой чат создан. Проверьте список чатов.';

  @override
  String get chatGroupCreateFailed => 'Не удалось создать групповой чат.';

  @override
  String chatGroupCreateFailedWithError(Object error) {
    return 'Не удалось создать групповой чат: $error.';
  }

  @override
  String get chatClearCurrentConfirm => 'Очистить текущую историю чата?';

  @override
  String get chatDeleteAndExitConfirm =>
      'После удаления и выхода вы больше не будете получать сообщения из этой группы.';

  @override
  String get chatBlockConfirm =>
      'После добавления этого контакта в черный список вы больше не будете получать его сообщения.';

  @override
  String get chatSearchTabAll => 'Чаты';

  @override
  String get chatSearchTabMedia => 'Фото/Видео';

  @override
  String get chatSearchTabFile => 'Файлы';

  @override
  String get chatSearchNoMatches => 'Нет подходящей истории чата';

  @override
  String get chatSearchNoMore => 'Больше результатов нет';

  @override
  String get chatDetailsTooltip => 'Подробности чата';

  @override
  String get chatVoiceInputTooltip => 'Голосовой ввод';

  @override
  String get chatInputHint => 'Сообщение...';

  @override
  String get chatFlameEnabledTooltip => 'Запись после чтения включена';

  @override
  String get chatFlameDestroyOnExit => 'Удалить после выхода из чата';

  @override
  String chatFlameDestroyAfterMinutes(Object minutes) {
    return 'Уничтожить через $minutes мин.';
  }

  @override
  String chatFlameDestroyAfterSeconds(Object seconds) {
    return 'Уничтожить через $secondsс.';
  }

  @override
  String chatFlameEnabledNotice(Object label) {
    return 'Запись после чтения включена. Сообщения будут уничтожены $label после прочтения. Используйте настройки в правом верхнем углу, чтобы отключить его.';
  }

  @override
  String get chatEmojiTooltip => 'Эмодзи';

  @override
  String get chatActionReply => 'Ответить';

  @override
  String get chatActionCopy => 'Копировать';

  @override
  String get chatActionTranslate => 'Перевести';

  @override
  String get chatActionTranscribe => 'Расшифровать';

  @override
  String get chatActionForward => 'Вперед';

  @override
  String get chatActionFavorite => 'Избранное';

  @override
  String get chatActionPin => 'Пин';

  @override
  String get chatActionUnpin => 'Открепить';

  @override
  String get chatActionAddFriend => 'Добавить друга';

  @override
  String get chatActionMultiSelect => 'Выбрать';

  @override
  String get chatActionEdit => 'Редактировать';

  @override
  String get chatActionEditImage => 'Редактировать изображение';

  @override
  String get chatActionRevoke => 'Напомним';

  @override
  String get chatActionDelete => 'Удалить';

  @override
  String get chatGroupCallActive => 'Идет групповой звонок';

  @override
  String chatMessageRevokedBy(Object name) {
    return '$name вспомнил сообщение';
  }

  @override
  String get chatReedit => 'Повторное редактирование';

  @override
  String get chatEditedSuffix => '(отредактировано)';

  @override
  String chatActionReadBy(Object count) {
    return 'Прочитал $count';
  }

  @override
  String chatActionReactedBy(Object count) {
    return '$count реакции';
  }

  @override
  String chatSelectedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выбрано $count элементов',
      one: 'Выбран 1 товар',
    );
    return '$_temp0';
  }

  @override
  String get chatNoReactions => 'Реакций пока нет';

  @override
  String chatReadStatusReadCount(Object count) {
    return 'Прочитать ($count)';
  }

  @override
  String get chatNoReadReceipts => 'Пока нет';

  @override
  String get chatHistoryAbove => 'Предыдущие сообщения выше';

  @override
  String chatUnreadNewMessages(Object count) {
    return '$count новых сообщений';
  }

  @override
  String get chatUnreadDivider => 'Новые сообщения ниже';

  @override
  String get chatUnknownContentFallback =>
      'Эта версия не может отображать это сообщение. Обновитесь до последней версии.';

  @override
  String get chatMentionSomeone => 'Кто-то упомянул вас';

  @override
  String get chatToolAlbum => 'Альбом';

  @override
  String get chatToolCamera => 'Камера';

  @override
  String get chatToolFile => 'Файл';

  @override
  String get chatToolLocation => 'Местоположение';

  @override
  String get chatToolContactCard => 'Карточка контакта';

  @override
  String get chatToolAudioCall => 'Голосовой вызов';

  @override
  String get chatToolVideoCall => 'Видеозвонок';

  @override
  String get chatDraftLabel => '[Черновик]';

  @override
  String get visitorBadge => 'Посетитель';

  @override
  String get chatNoticeDeleted => 'Удалено';

  @override
  String get chatNoticeCopied => 'скопировано';

  @override
  String get chatMentionLoadedOrInvisible =>
      'Сообщение @ загружено или не отображается. Прокрутите вверх, чтобы найти его.';

  @override
  String get chatLocationDefaultTitle => 'Местоположение';

  @override
  String get chatLocationCopied => 'Местоположение скопировано';

  @override
  String get chatReadStatusTitle => 'Статус чтения';

  @override
  String get chatReadStatusRead => 'Прочитать';

  @override
  String get chatReadStatusUnread => 'Непрочитано';

  @override
  String get chatReadStatusUnavailable =>
      'Полные списки прочитанных/непрочитанных пока недоступны.';

  @override
  String get chatComposerLeft => 'Вы покинули этот чат';

  @override
  String get chatComposerMuted => 'Этот чат отключен';

  @override
  String chatComposerMutedUntil(Object time) {
    return 'Ваш звук отключен до $time';
  }

  @override
  String chatFavoriteCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Избранные $count сообщений',
      one: 'В избранное 1 сообщение',
    );
    return '$_temp0';
  }

  @override
  String chatFavoritePartial(Object failed, Object success) {
    return 'Избранное завершено: $success выполнено успешно, $failed не выполнено';
  }

  @override
  String get chatForwardUnavailable => 'Сейчас невозможно переслать';

  @override
  String chatMergedForwardedTo(Object count, Object name) {
    return 'Объединил $count сообщений с $name';
  }

  @override
  String chatForwardedIndividuallyTo(Object count, Object name) {
    return 'переслал $count сообщений по одному на $name.';
  }

  @override
  String chatForwardedPartialTo(Object name, Object sent, Object total) {
    return 'переадресовал $sent/$total сообщений на $name';
  }

  @override
  String get chatForwardModeIndividual => 'Вперед по одному';

  @override
  String get chatForwardModeMerge => 'Объединение и пересылка';

  @override
  String get chatPresenceOnline => 'Онлайн';

  @override
  String get chatPresenceOffline => 'Не в сети';

  @override
  String get chatPresenceJustActive => 'Активен только что';

  @override
  String chatPresenceMinutesAgo(Object minutes) {
    return 'Активен $minutes мин. назад';
  }

  @override
  String chatPresenceHoursAgo(Object hours) {
    return 'Активен $hours час назад';
  }

  @override
  String chatPresenceDaysAgo(Object days) {
    return 'Активен $days дней назад';
  }

  @override
  String get chatSensitiveDefaultTip =>
      'Это сообщение может содержать конфиденциальную информацию.';

  @override
  String get chatMessageDigestFallback => '[Сообщение]';

  @override
  String get chatMediaServiceUnavailable => 'Медиа-сервис не готов';

  @override
  String get chatImDisconnected => 'чат не подключен';

  @override
  String get chatPinFailedNotSent =>
      'Невозможно закрепить до того, как сообщение достигнет сервера';

  @override
  String get chatPinFailed => 'Не удалось закрепить. Попробуйте еще раз.';

  @override
  String get chatPinned => 'закреплено';

  @override
  String get chatUnpinFailed => 'Не удалось открепить. Попробуйте еще раз.';

  @override
  String get chatUnpinned => 'Откреплено';

  @override
  String get chatClearPinnedConfirm => 'Открепить все закрепленные сообщения?';

  @override
  String get chatClearPinnedAction => 'Открепить';

  @override
  String get chatAllUnpinned => 'Все закрепленные сообщения откреплены';

  @override
  String get chatPinnedMessageNotVisible =>
      'Это сообщение находится вне видимого диапазона. Посмотреть его из списка.';

  @override
  String get chatImageMissing => 'Информация об изображении отсутствует';

  @override
  String get chatImageDownloadFailedEdit =>
      'Не удалось загрузить изображение. Невозможно редактировать.';

  @override
  String get chatReactionFailed =>
      'Не удалось выполнить реакцию. Попробуйте еще раз.';

  @override
  String get chatEditNotSynced =>
      'Ошибка редактирования: сообщение не синхронизировано';

  @override
  String get chatEditFailed => 'Не удалось изменить. Попробуйте еще раз.';

  @override
  String get chatFavoriteUnsupportedType =>
      'Этот тип пока нельзя добавить в избранное';

  @override
  String get chatFavoriteNotSent =>
      'Сообщение не дошло до сервера, поэтому его нельзя добавить в избранное';

  @override
  String get chatFavoriteSuccess => 'Добавлен в избранное';

  @override
  String get chatFavoriteFailed =>
      'Не удалось добавить в избранное. Попробуйте еще раз.';

  @override
  String chatToolSelected(Object title) {
    return 'Выбрано $title';
  }

  @override
  String chatCardDigest(Object name) {
    return '[Карта] $name';
  }

  @override
  String get chatFriendAvatarFallback => 'Ф';

  @override
  String get chatUnknownMessageDigest => '[Неизвестно]';

  @override
  String chatOpenFromContacts(Object name) {
    return 'Открыть чат @$name из контактов';
  }

  @override
  String get chatLoadingCard => 'Загрузка карточки контакта...';

  @override
  String get chatFileMissing => 'Информация о файле отсутствует';

  @override
  String get chatVideoUnavailable => 'Видео невозможно воспроизвести.';

  @override
  String get chatVideoSourceEmpty => 'Источник видео пуст';

  @override
  String get chatLivePhotoUnavailable => 'Live Photo невозможно воспроизвести.';

  @override
  String get messageAiTranslating => 'Перевод...';

  @override
  String get messageAiTranscribedShort => 'Готово';

  @override
  String get messageAiVoiceSendingWait =>
      'Голос все еще отправляется. Повторите попытку позже.';

  @override
  String get messageAiNoTranscript => 'Речь не распознается';

  @override
  String get messageAiMessageSendingWait =>
      'Сообщение все еще отправляется. Повторите попытку позже.';

  @override
  String get messageAiNoTranslation => 'Нет результатов перевода';

  @override
  String get messageAiTemporarilyUnavailable => 'Временно недоступен';

  @override
  String get chatVoiceFileUnavailable => 'Голосовой файл недоступен.';

  @override
  String get chatVoicePlayFailed =>
      'Не удалось воспроизвести. Попробуйте еще раз.';

  @override
  String get chatVoiceHoldToRecord =>
      'Удерживайте для записи · Проведите пальцем вверх для отмены';

  @override
  String chatVoiceReleaseToCancel(Object duration) {
    return 'Разрешить отмену ($duration)';
  }

  @override
  String chatVoiceRecordingSlideCancel(Object duration) {
    return '$duration · Проведите вверх, чтобы отменить';
  }

  @override
  String get chatQrcodeNotFound => 'QR-код не распознан';

  @override
  String chatWebLoginQrcodeDetected(Object payload) {
    return 'Web QR-код для входа распознан\n$payload';
  }

  @override
  String get chatWebLoginConfirmTitle => 'Подтвердить вход в Интернет?';

  @override
  String get chatWebLoginConfirmAction => 'Подтвердите вход Web';

  @override
  String get chatWebLoginConfirmed => 'Web вход подтвержден';

  @override
  String chatQrcodeDetected(Object payload) {
    return 'QR-код распознан\n$payload';
  }

  @override
  String get chatStickerPlaceholder => '[Наклейка]';

  @override
  String get chatStickerAdded => 'Добавлен в стикеры';

  @override
  String get chatStickerAddFailed =>
      'Не удалось добавить стикер. Попробуйте еще раз.';

  @override
  String get mentionAllMembers => 'Все участники';

  @override
  String get mentionAllMembersSubtitle => 'Уведомить всех в этой группе';

  @override
  String get chatQuoteOriginalRevoked => 'Исходное сообщение отозвано';

  @override
  String get chatRecognizeImageQrcode => 'Сканировать QR-код на изображении';

  @override
  String get chatAddToStickers => 'Добавить в стикеры';

  @override
  String get chatGroupInviteApprovalUrlEmpty =>
      'URL-адрес одобрения приглашения в группу пуст.';

  @override
  String get chatGroupInviteApprovalTitle => 'Утверждение приглашения в группу';

  @override
  String get chatGroupInviteApprovalBody =>
      'Заполните подтверждение приглашения в группу на веб-странице.';

  @override
  String get chatGroupInviteGoConfirm => 'Подтвердить';

  @override
  String get chatGroupInviteApprovalOpenFailed =>
      'Не удалось открыть утверждение приглашения в группу. Попробуйте еще раз.';

  @override
  String get chatSendFailed => 'Не удалось отправить. Попробуйте еще раз.';

  @override
  String get chatCallActiveHangupFirst =>
      'Вызов активен. Сначала повесь трубку.';

  @override
  String get chatCallActiveCannotJoinAgain =>
      'Вызов активен. Не могу присоединиться снова.';

  @override
  String get chatCallUnsupported => 'Звонки в этой версии не поддерживаются';

  @override
  String get chatCallServiceUnavailable => 'Услуга вызова не готова';

  @override
  String get chatCallJoinFailedEnded =>
      'Не удалось присоединиться. Возможно, звонок завершился.';

  @override
  String get callWaitingAnswer => 'Ожидание ответа';

  @override
  String get callMessage => 'Сообщение о вызове';

  @override
  String get callEnded => 'Звонок завершен';

  @override
  String get callPeerRefused => 'Пир отклонен';

  @override
  String get callPeerHungUp => 'Партнер повесил трубку';

  @override
  String get callPeerDeclinedVideoSwitch =>
      'Узел отклонил запрос на переключение видео';

  @override
  String get callSwitchVideoRequestTitle =>
      'Одноранговый узел запрашивает переключение на видео';

  @override
  String get callAgree => 'Согласен';

  @override
  String get callReconnecting => 'Повторное подключение…';

  @override
  String get callWaitingPeerCamera => 'Ожидание одноранговой камеры';

  @override
  String get callSelfFallbackName => 'Я';

  @override
  String get callUnknownUser => 'Неизвестный пользователь';

  @override
  String callJoinedCount(int joined, int total) {
    return '$joined/$total присоединился';
  }

  @override
  String get callMute => 'Без звука';

  @override
  String get callSpeaker => 'Динамик';

  @override
  String get callSwitchToVideo => 'Видео';

  @override
  String get callHangup => 'Повесьте трубку';

  @override
  String get callFlipCamera => 'Перевернуть';

  @override
  String get callSwitchToVoice => 'Аудио';

  @override
  String get callCamera => 'Камера';

  @override
  String get callBack => 'Назад';

  @override
  String get callPermissionMicrophone => 'микрофон';

  @override
  String get callPermissionMicrophoneCamera => 'микрофон и камера';

  @override
  String callPermissionOpenSettings(String what) {
    return 'Включите разрешение $what в настройках системы.';
  }

  @override
  String callPermissionRequired(String what) {
    return 'Для звонков требуется разрешение $what';
  }

  @override
  String get callWaitingPeerConsent => 'Ожидание одобрения коллег';

  @override
  String get callSwitchRequestFailed =>
      'Не удалось отправить запрос на переключение.';

  @override
  String get callCameraPermissionRequired => 'Требуется разрешение камеры';

  @override
  String get callCameraEnableFailed => 'Не удалось включить камеру.';

  @override
  String get incomingCallAccepting => 'Отвечаю...';

  @override
  String get incomingVideoCall => 'приглашает вас на видеозвонок';

  @override
  String get incomingAudioCall => 'приглашает вас на голосовой вызов';

  @override
  String incomingAcceptFailed(String error) {
    return 'Не удалось ответить: $error';
  }

  @override
  String get incomingCallDecline => 'Отклонение';

  @override
  String get incomingCallAccept => 'Ответ';

  @override
  String get chatGroupNoInviteCandidates =>
      'Нет участников, которых можно пригласить';

  @override
  String get chatInviteGroupMembersVideo =>
      'Пригласить участников группы (видеозвонок)';

  @override
  String get chatInviteGroupMembersAudio =>
      'Пригласить участников группы (голосовой вызов)';

  @override
  String get chatSelfName => 'Я';

  @override
  String get chatPeerPlaceholder => 'Другое';

  @override
  String get chatSomeonePlaceholder => 'Кто-то';

  @override
  String chatScreenshotNotice(Object name) {
    return '$name сделал снимок экрана в чате';
  }

  @override
  String chatDuplicateGroupMention(Object name) {
    return 'Несколько участников группы соответствуют @$name';
  }

  @override
  String chatDuplicateContactMention(Object name) {
    return 'Несколько контактов соответствуют @$name';
  }

  @override
  String chatMentionNotFound(Object name) {
    return '@$name не найден';
  }

  @override
  String get chatForwardPickerTitle => 'Переслать кому';

  @override
  String get chatRecentContactsSection => 'Недавние контакты';

  @override
  String chatForwardedTo(Object name) {
    return 'Перенаправлено на $name';
  }

  @override
  String get favoriteTitle => 'Избранное';

  @override
  String get favoriteEmptyTitle => 'Нет избранного';

  @override
  String get favoriteEmptySubtitle =>
      'Нажмите и удерживайте сообщение в чате и выберите «Избранное», чтобы сохранить его здесь.';

  @override
  String get favoriteDeleted => 'Удалено';

  @override
  String favoriteDeleteFailed(Object error) {
    return 'Не удалось удалить: $error';
  }

  @override
  String get favoriteDeleteFailedPlain => 'Не удалось удалить';

  @override
  String get favoriteUnsupportedSend => 'Этот тип пока невозможно отправить';

  @override
  String favoriteSentTo(String name) {
    return 'Отправлено $name';
  }

  @override
  String favoriteSendFailed(Object error) {
    return 'Не удалось отправить: $error';
  }

  @override
  String get favoriteSendFailedPlain => 'Не удалось отправить';

  @override
  String get favoriteSendToFriend => 'Отправить другу';

  @override
  String get favoriteCopied => 'скопировано';

  @override
  String get favoriteUnknownUser => 'Неизвестный пользователь';

  @override
  String favoriteDateMonthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String get groupSavedTitle => 'Сохраненные группы';

  @override
  String get groupSaveTooltip => 'Сохранить группу';

  @override
  String get groupSearchHint => 'Группы поиска';

  @override
  String get groupNoMatched => 'Нет подходящих групп';

  @override
  String get groupNoSaveCandidatesToast =>
      'Нет групп, доступных для сохранения.';

  @override
  String get groupSavedToContacts => 'Сохранено в контактах.';

  @override
  String groupSaveFailed(Object error) {
    return 'Не удалось сохранить: $error.';
  }

  @override
  String get groupSelectTitle => 'Выбрать группу';

  @override
  String get groupNoSaveCandidates => 'Нет групп, доступных для сохранения.';

  @override
  String get groupCreateTitle => 'Начать групповой чат';

  @override
  String get groupSearchContactsHint => 'Поиск контактов';

  @override
  String get groupNoMatchedContacts => 'Нет подходящих контактов';

  @override
  String groupMemberSummary(num count, Object subtitle) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участников',
      one: '1 участник',
    );
    return '$_temp0· $subtitle';
  }

  @override
  String get groupMuted => 'Звук отключен';

  @override
  String get groupDetailsTitle => 'Подробности о группе';

  @override
  String groupMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участников',
      one: '1 участник',
    );
    return '$_temp0';
  }

  @override
  String get groupMembersSection => 'Члены группы';

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
  String get groupNoMembers => 'В группе нет участников';

  @override
  String get groupInviteMembers => 'Пригласить участников';

  @override
  String get groupInviteMembersSubtitle => 'Выбрать из контактов';

  @override
  String get groupRemoveMembers => 'Удаление участников';

  @override
  String get groupRemoveMembersEmptySubtitle => 'Нет участников для удаления';

  @override
  String get groupRemoveMembersSubtitle =>
      'Выберите участников, которых хотите удалить';

  @override
  String get groupQrCodeTitle => 'QR-код группы';

  @override
  String get groupQrCodeSubtitle =>
      'Отсканируйте, чтобы присоединиться к этой группе';

  @override
  String get groupNameTitle => 'Имя группы';

  @override
  String get groupNoticeTitle => 'Объявление группы';

  @override
  String get groupNoticeUnset => 'Не установлено';

  @override
  String get groupManageTitle => 'Управление группой';

  @override
  String get groupManageSubtitle =>
      'Администраторы, отключение звука и разрешения для групп';

  @override
  String get groupInviteConfirm => 'Подтверждение приглашения';

  @override
  String get groupBlacklistTitle => 'Черный список группы';

  @override
  String get groupBlacklistSubtitle =>
      'Управление участниками, которым запрещено говорить или присоединяться';

  @override
  String get groupSaveToContacts => 'Сохранить в контактах';

  @override
  String get groupMuteMessages => 'Отключение уведомлений';

  @override
  String get groupExited => 'Вышел из группового чата';

  @override
  String get groupExitAction => 'Покинуть группу';

  @override
  String groupMembersSyncFailed(Object error) {
    return 'Не удалось синхронизировать участников группы: $error.';
  }

  @override
  String get groupInvitePickerTitle =>
      'Выберите участников, которых хотите пригласить';

  @override
  String groupInviteSentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Отправлено $count приглашения участника',
      one: 'Отправлено 1 приглашение в качестве участника',
    );
    return '$_temp0';
  }

  @override
  String groupInvitedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Приглашено $count участников',
      one: 'Приглашен 1 участник',
    );
    return '$_temp0';
  }

  @override
  String groupInviteMembersFailed(Object error) {
    return 'Не удалось пригласить участников: $error.';
  }

  @override
  String get groupRemovePickerTitle =>
      'Выберите участников, которых нужно удалить';

  @override
  String groupQuotedMemberName(Object name) {
    return '\"$name\"';
  }

  @override
  String groupSelectedMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участников',
      one: '1 участник',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersConfirm(Object target) {
    return 'Удалить $target из этой группы?';
  }

  @override
  String get groupRemoveAction => 'Удалить';

  @override
  String groupRemovedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удален $count участников',
      one: 'Удален 1 участник',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersFailed(Object error) {
    return 'Не удалось удалить участников: $error.';
  }

  @override
  String get groupSettingsUpdated => 'Настройки группы обновлены';

  @override
  String groupSettingsUpdateFailed(Object error) {
    return 'Не удалось обновить настройки группы: $error.';
  }

  @override
  String get groupExitConfirm =>
      'После выхода из этой группы вы больше не будете получать сообщения из этой группы.';

  @override
  String get groupExitSuccess => 'Вышел из группового чата';

  @override
  String groupExitFailed(Object error) {
    return 'Не удалось уйти: $error';
  }

  @override
  String get groupOwnerAdminSection => 'Владелец и администраторы';

  @override
  String get groupOwnerRole => 'Владелец';

  @override
  String get groupAdminRole => 'Администратор';

  @override
  String get groupRemove => 'Удалить';

  @override
  String get groupAddAdmin => 'Добавить администратора группы';

  @override
  String get groupNoAdmins => 'Нет администраторов';

  @override
  String get groupInviteConfirmRemark =>
      'Если этот параметр включен, участникам требуется одобрение владельца или администратора, прежде чем приглашать друзей. Присоединение по QR-коду также будет отключено.';

  @override
  String get groupOwnerTransfer => 'Передача права собственности';

  @override
  String get groupMemberSettingsSection => 'Настройки участника';

  @override
  String get groupAllMutedRemark =>
      'Если отключен звук для всех участников, говорить могут только владелец и администраторы.';

  @override
  String get groupAllMuted => 'Отключить звук у всех участников';

  @override
  String get groupForbiddenAddFriendRemark =>
      'Если этот параметр включен, участники не могут добавлять друзей через эту группу.';

  @override
  String get groupForbiddenAddFriend => 'Запретить участникам добавлять друзей';

  @override
  String get groupAllowHistoryRemark =>
      'Если эта функция включена, новые участники могут видеть предыдущую историю чата.';

  @override
  String get groupAllowHistory =>
      'Разрешить новым участникам просматривать историю';

  @override
  String get groupAddAdminPickerTitle => 'Добавить администратора группы';

  @override
  String groupAdminAddedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Добавлено $count администраторов',
      one: 'Добавлен 1 администратор',
    );
    return '$_temp0';
  }

  @override
  String groupAddAdminFailed(Object error) {
    return 'Не удалось добавить администратора: $error.';
  }

  @override
  String groupRemoveAdminConfirm(Object name) {
    return 'Удалить роль администратора из \"$name\"?';
  }

  @override
  String get groupRemoveAdminAction => 'Удалить администратора';

  @override
  String get groupRemoveAdminSuccess => 'Администратор удален';

  @override
  String groupRemoveAdminFailed(Object error) {
    return 'Не удалось удалить администратора: $error.';
  }

  @override
  String get groupSelectNewOwner => 'Выбор нового владельца';

  @override
  String groupTransferOwnerConfirm(Object name) {
    return 'Передать право собственности на \"$name\"? Вы станете постоянным участником.';
  }

  @override
  String get groupTransferOwnerAction => 'Подтвердить перевод';

  @override
  String get groupOwnerTransferred => 'Право собственности передано';

  @override
  String groupOwnerTransferFailed(Object error) {
    return 'Не удалось передать право собственности: $error.';
  }

  @override
  String get groupNoticePublisherDefault => 'Объявление группы';

  @override
  String get groupNoticePublishTitle => 'Опубликовать объявление группы';

  @override
  String get groupNoticeEditTitle => 'Редактировать объявление группы';

  @override
  String get groupNoticePublishAction => 'Сообщение';

  @override
  String get groupNoticeEmpty => 'Нет объявления в группе';

  @override
  String get groupNoticePublishedAtUnknown => 'Время публикации неизвестно';

  @override
  String get groupMemberRemarkTitle => 'Мой ник в этой группе';

  @override
  String get groupMemberRemarkHint => 'Установите свой никнейм в этой группе';

  @override
  String get groupQrCodeEmpty => 'Нет группового QR-кода';

  @override
  String groupQrCodeValid(Object day, Object expire) {
    return 'Этот QR-код действителен в течение $day дней ($expire)';
  }

  @override
  String get groupQrCodeScanToJoin =>
      'Отсканируйте QR-код, чтобы присоединиться к этой группе';

  @override
  String get groupBlacklistLoadFailed =>
      'Не удалось загрузить черный список. Попробуйте еще раз.';

  @override
  String get groupBlacklistEmpty => 'Нет участников в черном списке';

  @override
  String get groupBlacklistAddMember => 'Добавить участника в черный список';

  @override
  String get groupBlacklistNoCandidates =>
      'В черный список нельзя добавить ни одного участника';

  @override
  String get groupSelectMember => 'Выбрать участника';

  @override
  String get groupBlacklistAdded => 'Добавлен в черный список';

  @override
  String get groupBlacklistAddFailed =>
      'Не удалось добавить в черный список. Попробуйте еще раз.';

  @override
  String groupBlacklistRemoveConfirm(Object name) {
    return 'Удалить \"$name\" из черного списка группы?';
  }

  @override
  String get groupBlacklistRemoveAction => 'Удалить из черного списка';

  @override
  String get groupBlacklistRemoveFailed =>
      'Не удалось удалить из черного списка. Попробуйте еще раз.';

  @override
  String get groupAvatarTitle => 'Аватар группы';

  @override
  String get groupAvatarTakePhoto => 'Сфотографироваться';

  @override
  String get groupAvatarChooseFromAlbum => 'Выбрать из альбома';

  @override
  String get groupAvatarSaveImage => 'Сохранить изображение';

  @override
  String get groupAvatarUnsupported =>
      'Этот чат не поддерживает смену аватара группы';

  @override
  String get groupAvatarUpdated => 'Аватар группы обновлен.';

  @override
  String get groupAvatarUpdateFailed =>
      'Не удалось обновить аватар группы. Попробуйте еще раз.';

  @override
  String get groupAvatarNoImageToSave => 'Нет аватара для сохранения.';

  @override
  String groupPhotoPermissionRequired(Object appName) {
    return 'Разрешите $appName доступ к вашим фотографиям';
  }

  @override
  String get groupImageSavedToAlbum => 'Сохранено в альбом.';

  @override
  String get groupImageSaveFailed =>
      'Не удалось сохранить. Попробуйте еще раз.';

  @override
  String get imageEditorProcessing => 'Обработка...';

  @override
  String get imageEditorDiscardTitle => 'Отменить изменения?';

  @override
  String get imageEditorDiscardMessage =>
      'Несохраненные изменения будут потеряны.';

  @override
  String get imageEditorDiscardConfirm => 'Отменить';

  @override
  String get imageEditorPaint => 'Розыгрыш';

  @override
  String get imageEditorFreestyle => 'От руки';

  @override
  String get imageEditorArrow => 'Стрелка';

  @override
  String get imageEditorLine => 'Строка';

  @override
  String get imageEditorRectangle => 'Прямоугольник';

  @override
  String get imageEditorCircle => 'Круг';

  @override
  String get imageEditorDashLine => 'Пунктирная линия';

  @override
  String get imageEditorMoveAndZoom => 'Переместить/Увеличить';

  @override
  String get imageEditorEraser => 'Ластик';

  @override
  String get imageEditorLineWidth => 'Ширина';

  @override
  String get imageEditorToggleFill => 'Заполнить';

  @override
  String get imageEditorOpacity => 'Непрозрачность';

  @override
  String get imageEditorUndo => 'Отменить';

  @override
  String get imageEditorRedo => 'Повторить';

  @override
  String get imageEditorInputHint => 'Введите текст';

  @override
  String get imageEditorText => 'Текст';

  @override
  String get imageEditorTextAlign => 'Выровнять';

  @override
  String get imageEditorBackground => 'Фон';

  @override
  String get imageEditorFontScale => 'Размер шрифта';

  @override
  String get imageEditorCrop => 'Обрезка';

  @override
  String get imageEditorRotate => 'Поворот';

  @override
  String get imageEditorRatio => 'Соотношение';

  @override
  String get imageEditorReset => 'Сброс';

  @override
  String get imageEditorFlip => 'Перевернуть';

  @override
  String get imageEditorFilter => 'Фильтры';

  @override
  String get imageEditorFilterNone => 'Оригинал';

  @override
  String get imageEditorFilterAddictiveBlue => 'Захватывающий синий';

  @override
  String get imageEditorFilterAddictiveRed => 'Красный, вызывающий привыкание';

  @override
  String get imageEditorFilterAden => 'Аден';

  @override
  String get imageEditorFilterAmaro => 'Амаро';

  @override
  String get imageEditorFilterAshby => 'Эшби';

  @override
  String get imageEditorFilterBrannan => 'Браннан';

  @override
  String get imageEditorFilterBrooklyn => 'Бруклин';

  @override
  String get imageEditorFilterCharmes => 'Подвески';

  @override
  String get imageEditorFilterClarendon => 'Кларендон';

  @override
  String get imageEditorFilterCrema => 'Крема';

  @override
  String get imageEditorFilterDogpatch => 'Собачья нашивка';

  @override
  String get imageEditorFilterEarlybird => 'Ранняя пташка';

  @override
  String get imageEditorFilterGingham => 'Джинсовый';

  @override
  String get imageEditorFilterGinza => 'Гинза';

  @override
  String get imageEditorFilterHefe => 'Хефе';

  @override
  String get imageEditorFilterHelena => 'Елена';

  @override
  String get imageEditorFilterHudson => 'Хадсон';

  @override
  String get imageEditorFilterInkwell => 'Чернильница';

  @override
  String get imageEditorFilterJuno => 'Юнона';

  @override
  String get imageEditorFilterKelvin => 'Кельвин';

  @override
  String get imageEditorFilterLark => 'Жаворонок';

  @override
  String get imageEditorFilterLoFi => 'Лоу-фай';

  @override
  String get imageEditorFilterLudwig => 'Людвиг';

  @override
  String get imageEditorFilterMaven => 'Знаток';

  @override
  String get imageEditorFilterMayfair => 'Мейфэр';

  @override
  String get imageEditorFilterMoon => 'Луна';

  @override
  String get imageEditorFilterNashville => 'Нэшвилл';

  @override
  String get imageEditorFilterPerpetua => 'Перпетуя';

  @override
  String get imageEditorFilterReyes => 'Рейес';

  @override
  String get imageEditorFilterRise => 'Подъем';

  @override
  String get imageEditorFilterSierra => 'Сьерра';

  @override
  String get imageEditorFilterSkyline => 'Горизонт';

  @override
  String get imageEditorFilterSlumber => 'Сон';

  @override
  String get imageEditorFilterStinson => 'Стинсон';

  @override
  String get imageEditorFilterSutro => 'Сутро';

  @override
  String get imageEditorFilterToaster => 'Тостер';

  @override
  String get imageEditorFilterValencia => 'Валенсия';

  @override
  String get imageEditorFilterVesper => 'Веспер';

  @override
  String get imageEditorFilterWalden => 'Уолден';

  @override
  String get imageEditorFilterWillow => 'Ива';

  @override
  String get imageEditorBlur => 'Размытие';

  @override
  String get imageEditorTune => 'Настроить';

  @override
  String get imageEditorBrightness => 'Яркость';

  @override
  String get imageEditorContrast => 'Контраст';

  @override
  String get imageEditorSaturation => 'Насыщенность';

  @override
  String get imageEditorExposure => 'Воздействие';

  @override
  String get imageEditorHue => 'Оттенок';

  @override
  String get imageEditorTemperature => 'Температура';

  @override
  String get imageEditorSharpness => 'Резкость';

  @override
  String get imageEditorFade => 'Затухание';

  @override
  String get imageEditorLuminance => 'Яркость';

  @override
  String get imageEditorEmoji => 'Эмодзи';

  @override
  String get imageEditorEmojiRecent => 'Недавние';

  @override
  String get imageEditorEmojiSmileys => 'Смайлы';

  @override
  String get imageEditorEmojiAnimals => 'Животные';

  @override
  String get imageEditorEmojiFood => 'Еда';

  @override
  String get imageEditorEmojiActivities => 'Действия';

  @override
  String get imageEditorEmojiTravel => 'Путешествие';

  @override
  String get imageEditorEmojiObjects => 'Объекты';

  @override
  String get imageEditorEmojiSymbols => 'Символы';

  @override
  String get imageEditorEmojiFlags => 'Флаги';

  @override
  String get imageEditorSticker => 'Наклейки';

  @override
  String get imageEditorRemove => 'Удалить';

  @override
  String get imageEditorSaving => 'Сохранение...';

  @override
  String get imageEditorImporting => 'Импорт';

  @override
  String get imagePreviewTitle => 'Предварительный просмотр изображения';

  @override
  String get imagePreviewSavingToAlbum => 'Сохранение...';

  @override
  String get imagePreviewAddToSticker => 'Добавить в стикеры';

  @override
  String get imagePreviewAddingToSticker => 'Добавление...';

  @override
  String get imagePreviewRecognizeQr => 'Распознать QR-код';

  @override
  String get imagePreviewRecognizingQr => 'Признавая...';

  @override
  String get imagePreviewConfirmWebLogin => 'Подтвердите вход Web';

  @override
  String get imagePreviewConfirmingWebLogin => 'Подтверждаю...';

  @override
  String get imagePreviewOpenLink => 'Открыть ссылку';

  @override
  String get imagePreviewImageNotDownloadedSave =>
      'Изображение еще не загружено';

  @override
  String get imagePreviewMediaUnavailable => 'Медиа-сервис недоступен';

  @override
  String get imagePreviewImageNotUploadedSticker =>
      'Изображение еще не загружено';

  @override
  String get imagePreviewStickerUnavailable => 'Сервис стикеров недоступен.';

  @override
  String get imagePreviewAddedToSticker => 'Добавлено в стикеры';

  @override
  String get imagePreviewImageNotDownloadedRecognize =>
      'Изображение еще не загружено';

  @override
  String get imagePreviewQrNotFound => 'QR-код не найден';

  @override
  String get imagePreviewWebLoginQrRecognized =>
      'Web QR-код для входа распознан';

  @override
  String get imagePreviewWebLinkRecognized => 'Web ссылка распознана';

  @override
  String get imagePreviewQrRecognized => 'QR-код распознан';

  @override
  String get imagePreviewWebLoginConfirmed => 'Web вход подтвержден';

  @override
  String get pickerFileTitle => 'Выберите файл';

  @override
  String get pickerRecentFiles => 'Последние файлы';

  @override
  String get pickerSampleProjectFile => 'Примечания к проекту.pdf';

  @override
  String get pickerSampleProjectFileSubtitle => '128 КБ · Сегодня';

  @override
  String get pickerSampleScreenshotFile => 'Скриншот чата.png';

  @override
  String get pickerSampleScreenshotFileSubtitle => '2,4 МБ · Вчера';

  @override
  String get pickerContactTitle => 'Выберите контакт';

  @override
  String get pickerContactCardSection => 'Отправить карточку контакта';

  @override
  String get pickerSearchContacts => 'Поиск контактов';

  @override
  String get pickerNoMatchingContacts => 'Нет подходящих контактов';

  @override
  String get chatSendFailedShort => 'Ошибка отправки';

  @override
  String get chatResend => 'Отправить повторно';

  @override
  String get chatStatusRead => 'Прочитать';

  @override
  String get pinnedMessageTitle => 'Закрепленное сообщение';

  @override
  String pinnedMessageTitleWithIndex(int index, int total) {
    return 'Закрепленное сообщение $index/$total';
  }

  @override
  String get pinnedMessageOpen => 'Нажмите, чтобы просмотреть';

  @override
  String get pinnedMessageViewAllTooltip => 'Просмотреть все закрепленные';

  @override
  String get pinnedMessageUnpinTooltip => 'Открепить';

  @override
  String pinnedMessageListCount(int count) {
    return '$count Закрепленные сообщения';
  }

  @override
  String get pinnedMessageClearAll => 'Открепить все';

  @override
  String get pinnedMessageFallback => 'Закрепленное сообщение';

  @override
  String get fileUnnamed => 'Файл без названия';

  @override
  String get fileNoDownloadUrl => 'Ссылка для скачивания недоступна.';

  @override
  String get fileTitle => 'Файл';

  @override
  String fileSizeLabel(String size) {
    return 'Размер файла: $size';
  }

  @override
  String get fileDownloadFailed => 'Не удалось загрузить';

  @override
  String get filePreview => 'Предварительный просмотр';

  @override
  String get fileOpenWithOtherApp => 'Открыть в другом приложении';

  @override
  String get actionEnable => 'Включить';

  @override
  String get actionDisable => 'Отключить';

  @override
  String get profileInviteLoading => 'Загрузка пригласительного кода';

  @override
  String get profileInviteEnabled => 'Код приглашения включен';

  @override
  String get profileInviteDisabled => 'Пригласительный код отключен';

  @override
  String profileInviteLoadFailed(String error) {
    return 'Не удалось загрузить код приглашения: $error.';
  }

  @override
  String get profileInviteCopied => 'скопировано';

  @override
  String profileInviteUpdateFailed(String error) {
    return 'Не удалось обновить код приглашения: $error.';
  }

  @override
  String get stickerStoreTitle => 'Магазин стикеров';

  @override
  String get stickerNoPacks => 'Нет наклеек';

  @override
  String get stickerDetailTitle => 'Подробности о стикере';

  @override
  String get stickerProcessing => 'Обработка...';

  @override
  String get stickerAddCustomTitle => 'Добавить персонализированную наклейку';

  @override
  String get stickerSortTitle => 'Сортировка стикеров';

  @override
  String get stickerMyStickersTitle => 'Мои стикеры';

  @override
  String get stickerSaving => 'Сохранение';

  @override
  String get stickerSortAction => 'Сортировать';

  @override
  String get stickerOrganize => 'Организовать';

  @override
  String get stickerCustomTitle => 'Пользовательские наклейки';

  @override
  String get stickerCustomSubtitle =>
      'Управление сохраненными пользовательскими стикерами';

  @override
  String get stickerNoSortablePacks => 'Нет наборов наклеек для сортировки';

  @override
  String get stickerNoCategories => 'Нет категорий стикеров';

  @override
  String get stickerMoveUp => 'Вверх';

  @override
  String get stickerMoveDown => 'Вниз';

  @override
  String get stickerNoCustomStickers => 'Никаких специальных наклеек';

  @override
  String get stickerMoveToFront => 'Переместить на передний план';

  @override
  String get stickerDeleteConfirmTitle =>
      'Удаленные стикеры невозможно восстановить.';

  @override
  String get complaintTitle => 'Отчет';

  @override
  String get complaintHint => 'Опишите проблему';

  @override
  String get complaintType => 'Тип отчета';

  @override
  String get complaintSubmitted => 'Отчет отправлен';

  @override
  String get complaintSubmit => 'Отправить отчет';

  @override
  String get complaintSubmitting => 'Отправка…';

  @override
  String get complaintFallbackOtherViolation => 'Другое нарушение правил';

  @override
  String get complaintFallbackFraud => 'Другое мошенничество или мошенничество';

  @override
  String get complaintFallbackAccountCompromised => 'Возможно, аккаунт взломан';

  @override
  String get chatBackgroundTitle => 'Фон чата';

  @override
  String get chatBackgroundLoading => 'Загрузка фона чата';

  @override
  String get chatBackgroundEmpty => 'Нет фона чата';

  @override
  String get chatBackgroundDefault => 'Фон по умолчанию';

  @override
  String chatBackgroundItem(int index) {
    return 'Фон $index';
  }

  @override
  String get chatBackgroundPreviewTitle => 'Фон предварительного просмотра';

  @override
  String get chatBackgroundSet => 'Установить фон';

  @override
  String get chatBackgroundSelectedStatus => 'Набор фонов для чата';

  @override
  String get chatBackgroundInUse => 'Используется';

  @override
  String get chatContactFallback => 'Контакт';

  @override
  String get chatPersonalCard => 'Карточка контакта';

  @override
  String get chatSystemMessageDigest => '[Системное сообщение]';

  @override
  String get chatMessageDigestMessage => '[Сообщение]';

  @override
  String get chatMessageDigestImage => '[Изображение]';

  @override
  String get chatMessageDigestVoice => '[Голос]';

  @override
  String get chatMessageDigestVideo => '[Видео]';

  @override
  String get chatMessageDigestLocation => '[Местоположение]';

  @override
  String get chatMessageDigestCard => '[Карточка контакта]';

  @override
  String get chatMessageDigestFile => '[Файл]';

  @override
  String get chatMessageDigestHistory => '[История чата]';

  @override
  String get chatMessageDigestSticker => '[Наклейка]';

  @override
  String get dateWeekdayShortMonday => 'Пн';

  @override
  String get dateWeekdayShortTuesday => 'Вт';

  @override
  String get dateWeekdayShortWednesday => 'Ср';

  @override
  String get dateWeekdayShortThursday => 'Четверг';

  @override
  String get dateWeekdayShortFriday => 'Пт';

  @override
  String get dateWeekdayShortSaturday => 'Сб';

  @override
  String get dateWeekdayShortSunday => 'Вс';

  @override
  String get appIconClassic => 'Классический';

  @override
  String get appIconSimple => 'Простой';

  @override
  String get appIconDark => 'Темный';

  @override
  String get appIconFestive => 'Праздничный';

  @override
  String get appIconGradient => 'Градиент';

  @override
  String get appIconUpdated => 'Значок обновлен';

  @override
  String get appIconUpdateFailed =>
      'Не удалось выполнить переключение. Повторите попытку позже.';

  @override
  String get appearanceBubbleColorPurple => 'Фиолетовый';

  @override
  String get appearanceBubbleColorGreen => 'Зеленый';

  @override
  String get appearanceBubbleColorBlue => 'Синий';

  @override
  String get appearanceBubbleColorOrange => 'Оранжевый';

  @override
  String get appearanceBubbleColorPink => 'Розовый';

  @override
  String replyPreviewTitle(String name) {
    return 'Ответить на $name';
  }

  @override
  String get replyPreviewCancel => 'Отменить ответ';

  @override
  String get chatPasswordTitle => 'Пароль чата';

  @override
  String get chatPasswordHint => 'Введите 6-значный пароль';

  @override
  String chatPasswordErrorRemain(int remain) {
    return 'Неправильный пароль. История чата будет очищена после еще $remain неудачных попыток.';
  }

  @override
  String get emojiPackEmpty => 'В этом наборе нет наклеек';

  @override
  String get emojiRecentSection => 'Недавние';

  @override
  String get emojiAllSection => 'Все эмодзи';

  @override
  String get stickerSearching => 'Ищем...';

  @override
  String get stickerNoSearchResults => 'Нет результатов';

  @override
  String get stickerSearchResultsTitle => 'Результаты:';

  @override
  String get homeChatPasswordWiped =>
      'Слишком много неправильных попыток. История чата удалена.';

  @override
  String get homeGroupNotFound => 'Групповой чат не найден';

  @override
  String get homeConversationNoHistory => 'Нет истории чата';

  @override
  String get homeConversationStartChat => 'Начать чат';

  @override
  String get homeEnterGroupChat => 'Войти в групповой чат';

  @override
  String get homeNewGroup => 'Новый групповой чат';

  @override
  String homeFriendRequestAcceptFailed(String error) {
    return 'Не удалось принять: $error';
  }

  @override
  String get homeFriendRequestAccepted =>
      'Запрос на добавление в друзья принят';

  @override
  String homeFriendRequestRefuseFailed(String error) {
    return 'Не удалось отклонить: $error';
  }

  @override
  String homeFriendRequestDeleteFailed(String error) {
    return 'Не удалось удалить: $error.';
  }

  @override
  String contactPresenceOnlineWithDevice(String device) {
    return 'На сайте $device';
  }

  @override
  String contactPresenceJustOnlineWithDevice(String device) {
    return 'Только что был на сайте $device';
  }

  @override
  String contactPresenceMinutesOnlineWithDevice(int minutes, String device) {
    return 'Был на сайте $device $minutes мин. назад';
  }

  @override
  String contactPresenceLastOnline(String time) {
    return 'Последний раз был на сайте $time';
  }

  @override
  String get contactPresenceDeviceWeb => 'веб-сайт';

  @override
  String get contactPresenceDeviceDesktop => 'рабочий стол';

  @override
  String get contactPresenceDeviceMobile => 'мобильный';

  @override
  String get botCommandsEmpty => 'Пока нет команд';
}
