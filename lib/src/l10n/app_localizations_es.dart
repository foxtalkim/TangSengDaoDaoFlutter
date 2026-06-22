// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get tabMessages => 'Conversaciones';

  @override
  String get tabContacts => 'Contactos';

  @override
  String get tabDiscover => 'Descubrir';

  @override
  String get tabMe => 'Yo';

  @override
  String get pageMessagesTitle => 'Conversaciones';

  @override
  String get pageContactsTitle => 'Contactos';

  @override
  String get pageDiscoverTitle => 'Descubrir';

  @override
  String get pageMeTitle => 'Yo';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get actionDone => 'Hecho';

  @override
  String get actionSave => 'Guardar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionAdd => 'Agregar';

  @override
  String get actionRemove => 'Eliminar';

  @override
  String get actionInvite => 'Invitar';

  @override
  String get actionSearch => 'Buscar';

  @override
  String get actionSend => 'Enviar';

  @override
  String get actionRetry => 'Reintentar';

  @override
  String get actionBack => 'Volver';

  @override
  String get actionMore => 'Más';

  @override
  String get actionJoin => 'Unirse';

  @override
  String get actionSkip => 'Saltar';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get actionGetStarted => 'Empezar';

  @override
  String get actionSaving => 'Guardando...';

  @override
  String get moduleUnsupported =>
      'Esta característica no está disponible en esta versión';

  @override
  String get moduleLoading =>
      'Comprobando el acceso a funciones. Vuelve a intentarlo más tarde.';

  @override
  String get moduleOfflineStale =>
      'Conéctese a la red para confirmar el acceso a la función';

  @override
  String get onboardingMenuTitle => 'Guía rápida';

  @override
  String onboardingChatTitle(Object appName) {
    return 'Bienvenido a $appName';
  }

  @override
  String get onboardingChatSubtitle =>
      'Un lugar limpio y luminoso para conversaciones más cómodas.';

  @override
  String get onboardingFriendsTitle => 'Simplifica el contacto';

  @override
  String get onboardingFriendsSubtitle =>
      'Amigos, grupos y compartir son más fáciles de encontrar.';

  @override
  String get onboardingSecurityTitle =>
      'Habla libremente. Úselo con confianza.';

  @override
  String get onboardingSecuritySubtitle =>
      'La seguridad de la cuenta y la protección de la privacidad ayudan a proteger sus límites.';

  @override
  String get onboardingChatSemantic =>
      'Ilustración de incorporación de sincronización de mensajes';

  @override
  String get onboardingFriendsSemantic =>
      'Ilustración de incorporación de amigos y grupos';

  @override
  String get onboardingSecuritySemantic =>
      'Ilustración de incorporación de seguridad y privacidad';

  @override
  String get settingsLanguageRow => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Valor predeterminado del sistema';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => 'Inglés';

  @override
  String get profileRowFavorites => 'Favoritos';

  @override
  String get profileRowSecurityPrivacy => 'Seguridad y privacidad';

  @override
  String get profileRowNotifications => 'Notificaciones';

  @override
  String get profileRowInviteCode => 'Código de invitación';

  @override
  String get profileRowGeneral => 'Generalidades';

  @override
  String profileRowAbout(Object appName) {
    return 'Acerca de $appName';
  }

  @override
  String get profileLogout => 'Cerrar sesión';

  @override
  String get profileLogoutConfirm =>
      'Cerrar sesión no eliminará ningún historial. Puede volver a iniciar sesión con esta cuenta en cualquier momento.';

  @override
  String profileMoyuIdLabel(Object appName, Object value) {
    return '$appName ID: $value';
  }

  @override
  String get profileDefaultName => 'Yo';

  @override
  String get profileDetailTitle => 'Perfil';

  @override
  String get profileAvatar => 'Avatar';

  @override
  String get profileNickname => 'Apodo';

  @override
  String get profileEditNickname => 'Editar apodo';

  @override
  String profileEditFoxId(Object appName) {
    return 'Editar $appName ID';
  }

  @override
  String get profileGender => 'Género';

  @override
  String get profileGenderMale => 'Masculino';

  @override
  String get profileGenderFemale => 'Mujer';

  @override
  String get profileGenderSelected => 'Seleccionado';

  @override
  String get profileGenderUnset => 'No establecido';

  @override
  String get profilePhoneUnbound => 'No vinculado';

  @override
  String get profileAvatarUpdated => 'Avatar actualizado';

  @override
  String get profileAvatarUpdateFailed =>
      'No se pudo cargar el avatar. Intentar otra vez.';

  @override
  String get generalPageTitle => 'Generalidades';

  @override
  String get generalFontSize => 'Tamaño de fuente';

  @override
  String get generalChatBackground => 'Fondo de chat';

  @override
  String get generalDarkMode => 'Modo oscuro';

  @override
  String get generalClearCache => 'Borrar caché';

  @override
  String get generalClearMessages => 'Borrar historial de chat';

  @override
  String get generalAppModules => 'Características';

  @override
  String get generalErrorLogs => 'Registros de errores';

  @override
  String get generalThirdShare => 'SDKs de terceros';

  @override
  String get fontSizeSmall => 'Pequeño';

  @override
  String get fontSizeStandard => 'Estándar';

  @override
  String get fontSizeLarge => 'Grande';

  @override
  String get fontSizeExtraLarge => 'Extra grande';

  @override
  String get darkModeSystem => 'Valor predeterminado del sistema';

  @override
  String get darkModeLight => 'Luz';

  @override
  String get darkModeDark => 'Oscuro';

  @override
  String get valueConfigure => 'Configurar';

  @override
  String get valueManage => 'Administrar';

  @override
  String get valueClear => 'Borrar';

  @override
  String get valueUpload => 'Subir';

  @override
  String get valueDownload => 'Descargar';

  @override
  String get valueView => 'Ver';

  @override
  String get valueEnabled => 'Habilitado';

  @override
  String get valueDisabled => 'Deshabilitado';

  @override
  String get valueOn => 'En';

  @override
  String get valueOff => 'Desactivado';

  @override
  String get valueConfigured => 'Conjunto';

  @override
  String get valueNotEnabled => 'No habilitado';

  @override
  String get valueSelected => 'Seleccionado';

  @override
  String get valueCurrentDevice => 'Este dispositivo';

  @override
  String get valueSdkInfo => 'SDK Información';

  @override
  String get statusProcessing => 'Procesamiento';

  @override
  String get statusLoading => 'Cargando';

  @override
  String get statusSending => 'Enviando';

  @override
  String get statusSaving => 'Ahorro';

  @override
  String get statusSaved => 'Guardado';

  @override
  String get statusSent => 'Enviado';

  @override
  String get statusSubmitted => 'Enviado';

  @override
  String get dateJustNow => 'Justo ahora';

  @override
  String get dateToday => 'Hoy';

  @override
  String get dateYesterday => 'Ayer';

  @override
  String get dateDayBeforeYesterday => 'Anteayer';

  @override
  String dateTodayTime(Object time) {
    return 'Hoy $time';
  }

  @override
  String dateYesterdayTime(Object time) {
    return 'Ayer $time';
  }

  @override
  String dateDayBeforeYesterdayTime(Object time) {
    return 'Hace dos días $time';
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
  String get weekdayMonday => 'Lunes';

  @override
  String get weekdayTuesday => 'Martes';

  @override
  String get weekdayWednesday => 'miércoles';

  @override
  String get weekdayThursday => 'jueves';

  @override
  String get weekdayFriday => 'viernes';

  @override
  String get weekdaySaturday => 'Sábado';

  @override
  String get weekdaySunday => 'domingo';

  @override
  String get dialogClearAllTitle => '¿Borrar todo el historial de chat?';

  @override
  String get dialogClearAllBody =>
      'Se eliminarán todo el historial de chat local y las entradas de conversación.';

  @override
  String get authLoginSubtitle =>
      'Inicia sesión con tu número de teléfono y sigue chateando con amigos';

  @override
  String get authLoginIllustration => 'Ilustración de inicio de sesión';

  @override
  String get authRegisterIllustration => 'Ilustración de registro';

  @override
  String get authSecurityIllustration => 'Ilustración de verificación';

  @override
  String get authResetIllustration =>
      'Ilustración de restablecimiento de contraseña';

  @override
  String get authServerLabel => 'Servidor';

  @override
  String get authServerCustomLabel => 'Custom server';

  @override
  String get authServerCustomHint => 'Enter server address';

  @override
  String get authPhoneLabel => 'Número de teléfono';

  @override
  String get authPasswordLabel => 'Contraseña';

  @override
  String get authForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get authLoginButton => 'Iniciar sesión';

  @override
  String get authLoginLoading => 'Iniciando sesión...';

  @override
  String get authRegisterButton => 'Registrarse';

  @override
  String get authLoginWithApple => 'Sign in with Apple';

  @override
  String get authLoginWithGoogle => 'Sign in with Google';

  @override
  String get authLoginWithGithub => 'Sign in with GitHub';

  @override
  String get authLoginAgreementPrefix => 'Al iniciar sesión, aceptas';

  @override
  String get authTermsTitle => 'Términos de servicio';

  @override
  String get authAgreementConnector => 'y';

  @override
  String get authPrivacyTitle => 'Política de privacidad';

  @override
  String get authVerifyTitle => 'Inicio de sesión de verificación';

  @override
  String authVerifySubtitleWithPhone(Object phone) {
    return 'Ingrese el código enviado a $phone';
  }

  @override
  String get authVerifySubtitlePasswordFirst =>
      'Inicie sesión con su contraseña primero para iniciar la verificación de seguridad';

  @override
  String get authVerifyButton => 'Verificar';

  @override
  String get authVerifyLoading => 'Verificando...';

  @override
  String get authResendCode => '¿No recibiste un código? Reenviar';

  @override
  String get authVerificationCodeSent => 'Código de verificación enviado';

  @override
  String get authVerificationCodeRequired =>
      'Ingrese el código de verificación';

  @override
  String get authVerificationCodeSixDigits => 'Ingrese el código de 6 dígitos';

  @override
  String get authPasswordResetTitle =>
      'Restablecer contraseña de inicio de sesión';

  @override
  String get authPasswordResetSubtitle =>
      'Verifique su número de teléfono y luego establezca una nueva contraseña de inicio de sesión';

  @override
  String get authPasswordResetButton => 'Restablecer contraseña';

  @override
  String get authKickedTitle => 'Su cuenta inició sesión en otro dispositivo.';

  @override
  String get authSubmitting => 'Enviando...';

  @override
  String get authVerificationCodeLabel => 'Código de verificación';

  @override
  String get authGetVerificationCode => 'Obtener código';

  @override
  String get authNewPasswordLabel => 'Nueva contraseña';

  @override
  String get authPasswordResetSuccess => 'Restablecer contraseña';

  @override
  String authRegisterTitle(Object appName) {
    return 'Crear una cuenta $appName';
  }

  @override
  String get authRegisterSubtitle =>
      'Regístrese con su número de teléfono y comience a chatear de inmediato';

  @override
  String get authCreateAccount => 'Crear cuenta';

  @override
  String get authNicknameLabel => 'Apodo';

  @override
  String get authInviteCodeRequiredLabel =>
      'Código de invitación (obligatorio)';

  @override
  String authCodeRetryAfter(Object seconds) {
    return 'Reintentar en ${seconds}s';
  }

  @override
  String get authRegisterAgreement =>
      'He leído y acepto los Términos de servicio y la Política de privacidad';

  @override
  String get authInvalidPhone => 'Número de teléfono no válido';

  @override
  String get authAcceptAgreementFirst =>
      'Primero acepte los Términos de servicio y la Política de privacidad';

  @override
  String get authCodeEmpty => 'Se requiere código de verificación';

  @override
  String get authPasswordLengthInvalid =>
      'La contraseña debe tener entre 6 y 16 caracteres';

  @override
  String get authInviteCodeEmpty => 'Se requiere código de invitación';

  @override
  String get authRegisterSuccess => 'Registrado exitosamente';

  @override
  String get settingsCheckNewVersion => 'Buscar actualizaciones';

  @override
  String get settingsChecking => 'Comprobando';

  @override
  String get settingsVersionFound => 'Actualización disponible';

  @override
  String get settingsUserAgreement => 'Términos de servicio';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidad';

  @override
  String get settingsView => 'Ver';

  @override
  String get settingsSwitchAccount => 'Cambiar cuenta';

  @override
  String get settingsCacheCleared => 'Caché borrada';

  @override
  String get settingsClearCacheSheetTitle =>
      '¿Borrar caché de imágenes/videos? \nLas imágenes de chat, portadas de videos y avatares se descargarán nuevamente.';

  @override
  String get settingsClearCacheAction => 'Borrar caché';

  @override
  String get settingsMessagesCleared => 'Historial de chat borrado';

  @override
  String settingsClearMessagesFailed(Object error) {
    return 'No se pudo borrar el historial de chat: $error';
  }

  @override
  String get settingsAlreadyLatestVersion => 'Ya estás en la última versión';

  @override
  String get settingsCheckFailed => 'Verificación fallida';

  @override
  String settingsUpdateDialogTitle(Object version) {
    return 'Actualización disponible\nÚltima versión: $version';
  }

  @override
  String settingsUpdateDialogTitleWithDescription(
    Object description,
    Object version,
  ) {
    return 'Actualización disponible\nÚltima versión: $version\n$description';
  }

  @override
  String get settingsLater => 'Más tarde';

  @override
  String get settingsUpdateNow => 'Actualizar ahora';

  @override
  String get settingsSaveFailedRetry =>
      'No se pudo guardar. Intentar otra vez.';

  @override
  String get securityAllowPhoneSearch =>
      'Permitir que otros me encuentren por número de teléfono';

  @override
  String securityAllowFoxIdSearch(Object appName) {
    return 'Permitir que otros me encuentren por $appName ID';
  }

  @override
  String get securitySearchRemark =>
      'Cuando está desactivado, otros usuarios no pueden encontrarlo a través de la información anterior.';

  @override
  String get securityJoinGroupNeedConfirm =>
      'Require confirmation to join groups';

  @override
  String get securityJoinGroupNeedConfirmRemark =>
      'When on, invitations to add you to a group must be confirmed by you first.';

  @override
  String get securityLoginPassword => 'Contraseña de inicio de sesión';

  @override
  String get securityChatPassword => 'Contraseña de chat';

  @override
  String get securityScreenProtection => 'Protección de pantalla';

  @override
  String get securityLockPassword => 'Contraseña de bloqueo';

  @override
  String get securityOfflineProtection => 'Bloqueo de pantalla sin conexión';

  @override
  String get securityDeviceManagement =>
      'Iniciar sesión Gestión de dispositivos';

  @override
  String get securityDeviceRemark =>
      'Vea y administre dispositivos, habilite la protección de inicio de sesión y mantenga su cuenta segura.';

  @override
  String get securityBlacklist => 'Lista negra';

  @override
  String get securityAccountDeletion => 'Eliminar cuenta';

  @override
  String get accountDeletionBody =>
      'La eliminación de la cuenta no se puede deshacer. Después de la confirmación, se enviará un código de verificación por SMS para completar la eliminación.';

  @override
  String get accountDeletionSubmitted => 'Solicitud de eliminación enviada';

  @override
  String get accountDeletionGetCode => 'Obtener código';

  @override
  String get passwordResetInstruction =>
      'Cambiar su contraseña de inicio de sesión requiere un código SMS. La nueva contraseña debe tener al menos 6 caracteres.';

  @override
  String get accountPhoneLabel => 'Número de teléfono';

  @override
  String get passwordRuleLabel => 'Regla de contraseña';

  @override
  String get passwordAtLeastSix => 'Al menos 6 caracteres';

  @override
  String get passwordConfirmLabel => 'Confirmar contraseña';

  @override
  String get passwordConfirmHint =>
      'Ingrese la contraseña de inicio de sesión nuevamente';

  @override
  String get passwordChanged => 'Contraseña de inicio de sesión cambiada';

  @override
  String get phoneRequired => 'Se requiere el número de teléfono';

  @override
  String get passwordMismatch => 'Las contraseñas no coinciden';

  @override
  String get chatPasswordInstruction =>
      'Cuando está habilitada, se requiere esta contraseña de 6 dígitos antes de abrir chats protegidos.';

  @override
  String get currentStatusLabel => 'Estado actual';

  @override
  String get passwordSixDigits => '6 dígitos';

  @override
  String get chatPasswordEnableAction => 'Habilitar contraseña de chat';

  @override
  String get loginPasswordRequired =>
      'Se requiere contraseña de inicio de sesión';

  @override
  String get chatPasswordSixDigitsRequired =>
      'La contraseña del chat debe tener 6 dígitos';

  @override
  String get lockSetTitle =>
      'Establecer una contraseña de bloqueo de 6 dígitos';

  @override
  String lockSetSubtitle(Object appName) {
    return 'Requerido para desbloquear $appName';
  }

  @override
  String get lockCurrentPromptTitle =>
      'Ingrese la contraseña de bloqueo actual';

  @override
  String get lockCurrentPromptSubtitle =>
      'Verificar antes de cambiarlo o apagarlo';

  @override
  String get lockAutoLock => 'Bloqueo automático';

  @override
  String get lockChangePassword => 'Cambiar contraseña de desbloqueo';

  @override
  String get lockClosePassword => 'Desactivar contraseña de desbloqueo';

  @override
  String get lockWrongPassword => 'Contraseña incorrecta. Intentar otra vez.';

  @override
  String get lockSixDigitsRequired =>
      'La contraseña de bloqueo debe tener 6 dígitos';

  @override
  String get lockInputTitle => 'Ingrese la contraseña de bloqueo';

  @override
  String lockInputSubtitle(Object appName) {
    return 'Desbloquear para continuar usando $appName';
  }

  @override
  String get lockSetFailed => 'No se pudo establecer. Intentar otra vez.';

  @override
  String get lockImmediately => 'Inmediatamente';

  @override
  String get lockAfter5Minutes => 'Después de 5 minutos de distancia';

  @override
  String get lockAfter30Minutes => 'Después de 30 minutos de ausencia';

  @override
  String get lockAfter1Hour => 'Después de 1 hora de ausencia';

  @override
  String get deviceLoginProtection => 'Protección de inicio de sesión';

  @override
  String get deviceProtectionRemark =>
      'Cuando la protección de inicio de sesión está habilitada, se requiere verificación de seguridad en dispositivos desconocidos. Recomendado para la seguridad de la cuenta.';

  @override
  String get deviceNone => 'No hay dispositivos conectados';

  @override
  String get deviceDebugName => 'Dispositivo actual';

  @override
  String get deviceDebugPlatform => 'Dispositivo de depuración iPhone/Android';

  @override
  String get deviceProtectionEnabled =>
      'Protección de inicio de sesión habilitada';

  @override
  String get deviceProtectionDisabled =>
      'Protección de inicio de sesión deshabilitada';

  @override
  String get deviceProtectionUpdateFailed =>
      'No se pudo actualizar la protección de inicio de sesión. Intentar otra vez.';

  @override
  String get blacklistEmpty => 'No hay contactos en la lista negra';

  @override
  String get switchAccountRecent => 'Cuentas recientes';

  @override
  String get switchAccountLoading => 'Leyendo cuentas recientes';

  @override
  String get switchAccountAddOther => 'Agregar o iniciar sesión en otra cuenta';

  @override
  String get switchAccountCurrent => 'Actual';

  @override
  String get appModulesLoading => 'Cargando módulos de funciones';

  @override
  String get appModulesEmpty => 'Sin módulos de funciones';

  @override
  String get appModulesUnavailable => 'Módulo no disponible';

  @override
  String get errorLogsLoading => 'Lectura de registros de errores';

  @override
  String get errorLogsEmpty => 'No hay registros de errores';

  @override
  String get errorLogFileName => 'Nombre de archivo';

  @override
  String get errorLogFileSize => 'Tamaño del archivo';

  @override
  String get errorLogGeneratedAt => 'Generado en';

  @override
  String get errorLogFilePath => 'Ruta del archivo';

  @override
  String get notificationReceiveNew =>
      'Recibir notificaciones de mensajes nuevos';

  @override
  String get notificationSound => 'Sonido';

  @override
  String get notificationVibration => 'Vibración';

  @override
  String get notificationShowDetails => 'Mostrar detalles de notificación';

  @override
  String get notificationSystem => 'Notificaciones de mensajes del sistema';

  @override
  String get notificationCalls => 'Notificaciones de llamadas de audio/vídeo';

  @override
  String get settingsGoToSystem => 'Configuración';

  @override
  String aboutAppIconSemantic(Object appName) {
    return '$appName icono';
  }

  @override
  String aboutCopyright(Object appName) {
    return 'Copyright © 2026\n$appName. Reservados todos los derechos.';
  }

  @override
  String get policyWebUrl => 'Web URL';

  @override
  String get appearanceTitle => 'Apariencia';

  @override
  String get appearanceAppIcon => 'Icono de aplicación';

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
  String get appearanceChatColor => 'Color de conversación';

  @override
  String get appearanceBubbleRadius => 'Radio de esquina de burbuja';

  @override
  String get appearanceBubbleColorInk => 'Tinta negra';

  @override
  String get appearanceSquare => 'Cuadrado';

  @override
  String get appearanceRound => 'Redondo';

  @override
  String get appearancePreviewOne =>
      '¿Quiere que gire a la derecha o a la izquierda? 🤔';

  @override
  String get appearancePreviewTwo => 'Correcto. Y, bueno, hazlo fuerte.';

  @override
  String get appearancePreviewThree =>
      '¿Eso es todo? Siento que dijo más que eso. 😯';

  @override
  String get appearancePreviewFour =>
      'Eso es todo. Enviaré un mensaje de voz con más detalles más tarde.';

  @override
  String get contactsEmptyTitle => 'Aún no hay contactos';

  @override
  String get contactsEmptySubtitle =>
      'Agregue amigos desde la esquina superior derecha o escanee una tarjeta de perfil';

  @override
  String contactsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contactos',
      one: '1 contacto',
    );
    return '$_temp0';
  }

  @override
  String get contactAddTooltip => 'Agregar amigo';

  @override
  String get contactSearchHint => 'Buscar contactos y grupos';

  @override
  String get contactSetRemark => 'Establecer comentario';

  @override
  String get contactAddToBlacklist => 'Agregar a la lista negra';

  @override
  String get contactDeleteFriend => 'Eliminar amigo';

  @override
  String get contactAddedToBlacklist => 'Agregado a la lista negra';

  @override
  String get operationFailed => 'La operación falló. Intentar otra vez.';

  @override
  String operationFailedWithError(String error) {
    return 'Operación fallida: $error';
  }

  @override
  String contactDeleteFriendConfirm(Object name) {
    return '¿Eliminar amigo \"$name\"? \nEl historial de chat también se borrará.';
  }

  @override
  String get contactConfirmDelete => 'Confirmar eliminación';

  @override
  String get contactDeleted => 'Amigo eliminado';

  @override
  String get contactUnknownUser => 'Usuario desconocido';

  @override
  String get contactActionNewFriends => 'Nuevos amigos';

  @override
  String get contactActionSavedGroups => 'Grupos guardados';

  @override
  String get contactSearchNoMatches => 'No hay contactos coincidentes';

  @override
  String get addFriendTitle => 'Agregar amigo';

  @override
  String addFriendSearchHint(Object appName) {
    return 'Teléfono / $appName ID';
  }

  @override
  String get addFriendNotFound => 'Cuenta no encontrada';

  @override
  String get myQrCodeTitle => 'Mi código QR';

  @override
  String myQrCodeSubtitle(Object appName) {
    return 'Escanee este código QR para agregarme en $appName';
  }

  @override
  String get myQrCodeEmpty => 'Sin código QR';

  @override
  String get scanTitle => 'Escanear';

  @override
  String get scanQrNotFound => 'No se reconoce ningún código QR';

  @override
  String scanResolveFailed(String error) {
    return 'Error al analizar el código QR: $error';
  }

  @override
  String get scanUnrecognized => 'Este código QR no se puede reconocer';

  @override
  String get scanInfoIncomplete =>
      'La información del código QR está incompleta';

  @override
  String get scanSocialUnavailable => 'El servicio social no está inicializado';

  @override
  String get scanJoinedGroup => 'Se unió al chat grupal';

  @override
  String get scanCannotOpenGroup => 'Esta página no puede abrir chats grupales';

  @override
  String get scanGroupNotFound => 'Chat grupal no encontrado';

  @override
  String get scanOpenGroupFailed => 'No se pudo abrir el chat grupal';

  @override
  String get scanSelfQr => 'Este es tu propio código QR';

  @override
  String get scanUserNotFound => 'Usuario no encontrado';

  @override
  String get scanCameraPermissionRequired =>
      'Se requiere permiso para la cámara';

  @override
  String get scanOpenSettings => 'Abrir configuración';

  @override
  String get scanCameraUnavailable => 'Cámara no disponible';

  @override
  String get scanAlbum => 'Álbum';

  @override
  String get scanLightOn => 'Luz encendida';

  @override
  String get scanLightOff => 'Luz apagada';

  @override
  String get scanQrCode => 'Código QR';

  @override
  String get scanGroupFallback => 'Chat grupal';

  @override
  String get scanGroupLoadingInfo => 'Cargando información del grupo';

  @override
  String scanGroupMemberCount(int count) {
    return '$count miembros';
  }

  @override
  String get scanJoinGroupConfirm => 'Unirse al chat grupal';

  @override
  String get scanJoining => 'Unirse';

  @override
  String get scanJoinGroup => 'Unirse al chat grupal';

  @override
  String scanJoinFailed(String error) {
    return 'No se pudo unir: $error';
  }

  @override
  String get tagsTitle => 'Etiquetas';

  @override
  String get tagsCreateTooltip => 'Nueva etiqueta';

  @override
  String get tagsContactSection => 'Etiquetas de contacto';

  @override
  String get tagsEmptyTitle => 'Sin etiquetas';

  @override
  String get tagsEmptySubtitle =>
      'Toque + en la parte superior derecha para agrupar contactos o chats.';

  @override
  String tagsCreateFailed(Object error) {
    return 'Error al crear la etiqueta: $error';
  }

  @override
  String tagsUpdateFailed(Object error) {
    return 'Error al actualizar la etiqueta: $error';
  }

  @override
  String tagsDeleteFailed(Object error) {
    return 'No se pudo eliminar la etiqueta: $error';
  }

  @override
  String tagsLoadFailed(Object error) {
    return 'Error al cargar etiquetas: $error';
  }

  @override
  String tagsDeleteConfirm(String name) {
    return '¿Eliminar etiqueta \"$name\"? \nLos contactos y grupos de esta etiqueta no se eliminarán.';
  }

  @override
  String get tagsEditTitle => 'Editar etiqueta';

  @override
  String get tagsCreateTitle => 'Nueva etiqueta';

  @override
  String get tagsNameSection => 'Nombre de etiqueta';

  @override
  String get tagsNameHint => 'Familia, amigos';

  @override
  String tagsMembersSection(int count) {
    return 'Etiquetar miembros ($count)';
  }

  @override
  String get tagsAddMember => 'Agregar miembro';

  @override
  String get tagsDelete => 'Eliminar etiqueta';

  @override
  String get tagsGroupInitial => 'G';

  @override
  String get tagsUnknownUser => 'Usuario desconocido';

  @override
  String get tagsSelectMembersTitle => 'Seleccionar miembros';

  @override
  String tagsDoneCount(int count) {
    return 'Hecho ($count)';
  }

  @override
  String get tagsSearchHint => 'Buscar contactos o grupos';

  @override
  String get tagsGroupsSection => 'Chats grupales';

  @override
  String get tagsContactsSection => 'Contactos';

  @override
  String get tagsNoMatchesTitle => 'No hay coincidencias';

  @override
  String get tagsNoMatchesSubtitle => 'Pruebe con otra palabra clave';

  @override
  String tagsRowTitle(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get phoneContactsTitle => 'Contactos telefónicos';

  @override
  String get phoneContactsSection => 'Agregar desde contactos telefónicos';

  @override
  String get phoneContactsEmpty => 'Sin contactos telefónicos';

  @override
  String get phoneContactsNoAddable =>
      'No hay contactos telefónicos para agregar';

  @override
  String get phoneContactsServerSyncFailed =>
      'Falló la sincronización del servidor. Mostrando contactos existentes.';

  @override
  String get friendAlreadyAdded => 'Agregado';

  @override
  String get friendRequestSent => 'Solicitud de amistad enviada';

  @override
  String phoneContactsInviteSmsBody(Object appName) {
    return 'Estoy usando $appName. La experiencia del chat es bastante agradable. Ven a probarlo también.';
  }

  @override
  String get phoneContactsInviteOpened => 'Invitación por SMS abierta';

  @override
  String get phoneContactsInviteFailed =>
      'No se pueden abrir SMS. Invita manualmente.';

  @override
  String get friendRequestsEmptyTitle => 'No hay nuevos amigos';

  @override
  String get friendRequestsEmptySubtitle =>
      'Invita a tus amigos a escanear tu código QR';

  @override
  String get friendRequestsPendingSection => 'Pendiente';

  @override
  String get friendRequestRefused => 'Rechazado';

  @override
  String contactOpenFromContacts(Object name) {
    return 'Abrir el chat de @$name desde Contactos';
  }

  @override
  String get fileHelperIntro =>
      'Inicie sesión en la versión web y envíeme mensajes para transferir texto, fotos, audio, videos y archivos entre el teléfono y la computadora.';

  @override
  String get fileHelperName => 'File Transfer';

  @override
  String get systemAccountName => 'System';

  @override
  String systemAccountIntro(Object appName) {
    return 'Cuenta oficial $appName para envío de notificaciones.';
  }

  @override
  String get contactIntroTitle => 'Introducción';

  @override
  String get contactSource => 'Fuente';

  @override
  String get contactRemoveFriendRelation => 'Eliminar amigo';

  @override
  String get contactRemoveFromBlacklist => 'Eliminar de la lista negra';

  @override
  String get contactSendMessage => 'Mensaje';

  @override
  String get contactAddToContacts => 'Agregar a Contactos';

  @override
  String get contactRemoveFriendConfirm => '¿Eliminar a este amigo?';

  @override
  String contactNicknameLine(Object name) {
    return 'Apodo: $name';
  }

  @override
  String get contactRemoveFromBlacklistConfirm =>
      '¿Eliminar este contacto de la lista negra?';

  @override
  String get webLoginTitle => 'Web Iniciar sesión';

  @override
  String get webLoginConfirmTitle => '¿Confirmar inicio de sesión web?';

  @override
  String get webLoginConfirmBody =>
      'Esto permitirá que su cuenta inicie sesión en el navegador o cliente de escritorio actual. Si no eres tú, toca Cancelar.';

  @override
  String get webLoginConfirmAction => 'Confirmar inicio de sesión';

  @override
  String get webLoginConfirming => 'Confirmando...';

  @override
  String get webLoginConfirmed => 'Web inicio de sesión confirmado';

  @override
  String webLoginConfirmFailed(Object error) {
    return 'Error de confirmación: $error';
  }

  @override
  String get applyFriendTitle => 'Solicitud de amistad';

  @override
  String get applyFriendSectionTitle => 'Enviar solicitud de amistad';

  @override
  String get applyFriendRemarkHint => 'Hola, soy...';

  @override
  String friendRequestSendFailed(Object error) {
    return 'Error al enviar: $error';
  }

  @override
  String get contactRemarkHint => 'Observación';

  @override
  String get momentPermissionsTitle => 'Momentos Privacidad';

  @override
  String get momentHideMineFromContact => 'Ocultarles mis Momentos';

  @override
  String get momentHideContactFromMe => 'Ocultarme sus Momentos';

  @override
  String get momentTitle => 'Momentos';

  @override
  String get momentPersonalEmpty => 'Aún no hay publicaciones';

  @override
  String get momentEmpty => 'Aún no hay momentos';

  @override
  String get momentCoverUploadFailed => 'No se pudo cargar la portada';

  @override
  String momentCoverUploadFailedWithError(Object error) {
    return 'No se pudo cargar la portada: $error';
  }

  @override
  String get momentDeleteConfirm => '¿Eliminar este momento?';

  @override
  String get momentJustNow => 'Justo ahora';

  @override
  String get momentPublishing => 'Posting…';

  @override
  String get momentPublishFailed => 'Failed to post. Tap to dismiss.';

  @override
  String get momentRemindedYou => 'Te recordamos que veas este momento';

  @override
  String momentRemindedNames(Object names) {
    return 'Recordado $names';
  }

  @override
  String get momentKeepEditingConfirm => '¿Mantener esta edición?';

  @override
  String get momentContinueEditing => 'Seguir editando';

  @override
  String get momentSaveDraft => 'Guardar borrador';

  @override
  String get momentDiscardDraft => 'Descartar';

  @override
  String get momentPublishTitle => 'Publicación';

  @override
  String get momentPublishHint => '¿Qué tienes en mente...?';

  @override
  String get momentLocationTitle => 'Ubicación';

  @override
  String get momentRemindWho => 'Recordar';

  @override
  String get locationUnsupported =>
      'La ubicación no está disponible en esta versión';

  @override
  String momentPrivacyContactCount(Object count, Object label) {
    return '$label · $count';
  }

  @override
  String get momentSelectVisibleContacts => 'Seleccionar contactos visibles';

  @override
  String get momentSelectHiddenContacts => 'Seleccionar contactos ocultos';

  @override
  String get momentPrivacyPublic => 'Público';

  @override
  String get momentPrivacyPrivate => 'Privado';

  @override
  String get momentPrivacyInternal => 'Visible para algunos';

  @override
  String get momentPrivacyProhibit => 'Ocultar de';

  @override
  String get momentPrivacyWhoCanSee => '¿Quién puede ver?';

  @override
  String momentCommentFailed(Object error) {
    return 'Error en el comentario: $error';
  }

  @override
  String get momentDetailTitle => 'Detalles';

  @override
  String get momentDeleted => 'Este momento fue eliminado';

  @override
  String get momentCollapse => 'Colapso';

  @override
  String get momentFullText => 'Texto completo';

  @override
  String get momentDeleteCommentConfirm => '¿Eliminar este comentario?';

  @override
  String get momentCommentPlaceholder => 'Comentario';

  @override
  String momentReplyPlaceholder(Object name) {
    return 'Responder $name';
  }

  @override
  String get momentLikeAction => 'Me gusta';

  @override
  String get momentCommentAction => 'Comentario';

  @override
  String momentNewMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mensajes nuevos',
      one: '1 mensaje nuevo',
    );
    return '$_temp0';
  }

  @override
  String get messagesTitle => 'Mensajes';

  @override
  String get messagesEmpty => 'Sin mensajes';

  @override
  String get messagesEmptyTitle => 'Aún no hay mensajes';

  @override
  String get messagesEmptySubtitle =>
      'Iniciar un nuevo chat desde la parte superior derecha';

  @override
  String get messagesNewConversation => 'Nuevo';

  @override
  String get messagesStartGroupChat => 'Iniciar chat grupal';

  @override
  String get messagesImDisconnected => 'IM no está conectado';

  @override
  String get messagesPinned => 'Fijado';

  @override
  String get messagesUnpinned => 'Desanclado';

  @override
  String get messagesMuted => 'Silenciado';

  @override
  String get messagesNotificationsOn => 'Notificaciones en';

  @override
  String messagesDeleteConversationTitle(String name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get messagesConfirmDelete => 'Eliminar';

  @override
  String get messagesCleared => 'Historial de chat borrado';

  @override
  String get messagesConversationDeleted => 'Conversación eliminada';

  @override
  String get messagesUnknownUser => 'Usuario desconocido';

  @override
  String get messagesFriendAvatarFallback => 'F';

  @override
  String get messagesGroupFallback => 'Chat grupal';

  @override
  String get messagesGroupAvatarFallback => 'G';

  @override
  String get messagesNewMessageDigest => '[Mensaje nuevo]';

  @override
  String get messagesConversationPin => 'Alfiler';

  @override
  String get messagesConversationUnpin => 'Desanclar';

  @override
  String get messagesConversationMute => 'Silenciar';

  @override
  String get messagesConversationUnmute => 'Activar silencio';

  @override
  String get messagesConnectionNoNetwork =>
      'Red no disponible. Comprueba tu conexión.';

  @override
  String get messagesConnectionDisconnected => 'Desconectado';

  @override
  String get messagesConnectionConnecting => 'Conectando';

  @override
  String get messagesConnectionSyncing => 'Sincronización';

  @override
  String get globalSearchTitle => 'Buscar';

  @override
  String get globalSearchTabChats => 'Charlas';

  @override
  String get globalSearchTabContacts => 'Contactos';

  @override
  String get globalSearchTabGroups => 'Grupos';

  @override
  String get globalSearchTabFiles => 'Archivos';

  @override
  String get globalSearchContactsSection => 'Contactos';

  @override
  String get globalSearchGroupsSection => 'Chats grupales';

  @override
  String get globalSearchMessagesSection => 'Historial de chat';

  @override
  String get globalSearchFilesSection => 'Archivos';

  @override
  String get globalSearchNoMatches => 'No hay coincidencias';

  @override
  String get globalSearchNoMore => 'No más resultados';

  @override
  String get locationLocating => 'Ubicando...';

  @override
  String locationPermissionOff(Object appName) {
    return 'El permiso de ubicación está desactivado. Permita que $appName use la ubicación en la configuración del sistema.';
  }

  @override
  String get locationPermissionDenied =>
      'Se denegó el permiso de ubicación. No se pueden cargar lugares cercanos.';

  @override
  String get locationMapUnsupported =>
      'AMap no es compatible con esta plataforma';

  @override
  String locationFailed(String error) {
    return 'Error en la ubicación: $error';
  }

  @override
  String get locationSearchPrompt =>
      'Ingrese palabras clave para buscar lugares cercanos';

  @override
  String get locationNoNearbyPoi => 'No hay puntos de interés cercanos';

  @override
  String get locationSearchHint => 'Buscar lugares cercanos';

  @override
  String get locationPickerTitle => 'Ubicación';

  @override
  String get locationSending => 'Enviando';

  @override
  String get locationUnnamed => 'Lugar sin nombre';

  @override
  String get locationCopiedAddress => 'Dirección copiada';

  @override
  String get locationNoMapApp => 'No hay aplicación de mapas disponible';

  @override
  String get locationFallbackTitle => 'Ubicación';

  @override
  String get locationAmap => 'AMap';

  @override
  String get locationBaiduMap => 'Mapas de Baidu';

  @override
  String get locationTencentMap => 'Mapas Tencent';

  @override
  String get locationAppleMap => 'Mapas de Apple';

  @override
  String get locationOtherMap => 'Otros mapas';

  @override
  String get locationMyLocation => 'Mi ubicación';

  @override
  String locationOpenMapFailed(String name) {
    return 'No se puede abrir $name';
  }

  @override
  String get locationCopyAddress => 'Copiar dirección';

  @override
  String get locationNavigate => 'Navegar';

  @override
  String get locationViewTitle => 'Mapa';

  @override
  String get momentPeerCommentDeleted => 'Comentario eliminado';

  @override
  String get momentDigest => '[Momento]';

  @override
  String get actionClose => 'Cerrar';

  @override
  String get saveToAlbum => 'Guardar en álbum';

  @override
  String get savedToAlbum => 'Guardado en el álbum';

  @override
  String get saveFailed => 'Error al guardar';

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
    return '$count fotos';
  }

  @override
  String get momentReplyConnector => 'respondió a';

  @override
  String get groupRemarkTitle => 'Observación del grupo';

  @override
  String get groupRemarkHint =>
      'Establecer un comentario de grupo visible solo para usted';

  @override
  String get chatNotificationSettingsTitle => 'Notificaciones de mensajes';

  @override
  String get chatScreenshotNotification =>
      'Notificaciones de captura de pantalla';

  @override
  String get chatRevokeNotification => 'Notificaciones de retiro del mercado';

  @override
  String get completeProfileTitle => 'Perfil completo';

  @override
  String get completeProfileUploadAvatar => 'Subir avatar';

  @override
  String get completeProfileReuploadAvatar => 'Subir nuevo avatar';

  @override
  String get completeProfileChooseAvatar => 'Elige una foto de perfil';

  @override
  String get completeProfileAvatarUploaded => 'Avatar subido';

  @override
  String get completeProfileAvatarRequired => 'Se requiere avatar.';

  @override
  String get nicknameLabel => 'Apodo';

  @override
  String get nicknameInputHint => 'Ingrese el apodo';

  @override
  String get nicknameRequired => 'Se requiere un apodo.';

  @override
  String get completeProfileSaved => 'Perfil completado';

  @override
  String get chatSettingsTitle => 'Detalles del chat';

  @override
  String chatSettingsGroupTitle(Object count) {
    return 'Información de chat ($count)';
  }

  @override
  String get chatSettingsGroupName => 'Nombre del chat grupal';

  @override
  String get chatSettingsGroupQrCode => 'Código QR del grupo';

  @override
  String get chatSearchContentTitle => 'Chat de búsqueda';

  @override
  String get chatSettingsBackground => 'Establecer fondo de chat';

  @override
  String get chatSettingsBackgroundSelected =>
      'Conjunto de fondo de chat actual';

  @override
  String get chatSettingsMute => 'Silenciar notificaciones';

  @override
  String get chatSettingsPin => 'Pin Chat';

  @override
  String get chatSettingsSaveToContacts => 'Guardar en Contactos';

  @override
  String get chatSettingsReadReceipt => 'Leer recibos';

  @override
  String get chatSettingsReadReceiptSubtitle =>
      'Cuando está habilitado, los mensajes enviados muestran el estado leído/no leído';

  @override
  String get chatSettingsFlame => 'Quemar después de leer';

  @override
  String get chatFlameTipExit =>
      'Los mensajes leídos se destruyen después de salir del chat.';

  @override
  String chatFlameTipMinutes(Object minutes) {
    return 'Los mensajes se destruyen $minutes min después de ser leídos';
  }

  @override
  String chatFlameTipSeconds(Object seconds) {
    return 'Los mensajes se destruyen ${seconds}s después de ser leídos';
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
  String get chatSettingsGroupNickname => 'Apodo de mi grupo';

  @override
  String get chatSettingsBlacklisted => 'En la lista negra';

  @override
  String get chatSettingsPeerBlacklisted =>
      'Este contacto ya está en la lista negra';

  @override
  String get chatSettingsComplaint => 'Informe';

  @override
  String get chatSettingsDeleteAndExit => 'Eliminar y salir';

  @override
  String groupRemarkSyncFailed(Object error) {
    return 'Error al sincronizar el comentario del grupo: $error';
  }

  @override
  String get chatSocialDisconnected => 'El servicio social no está conectado';

  @override
  String get chatNoRemovableMembers => 'No hay miembros removibles';

  @override
  String get chatSelectMembersToRemove => 'Seleccionar miembros para eliminar';

  @override
  String chatMemberNameQuoted(Object name) {
    return '\"$name\"';
  }

  @override
  String chatMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersConfirm(Object names) {
    return 'Eliminar $names del grupo';
  }

  @override
  String chatMembersRemoved(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se eliminaron $count miembros',
      one: 'Eliminado 1 miembro',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersFailed(Object error) {
    return 'No se pudieron eliminar miembros: $error';
  }

  @override
  String get chatNoInviteCandidates =>
      'No hay contactos disponibles para invitar';

  @override
  String get chatInviteMembers => 'Invitar miembros';

  @override
  String get chatSelectContacts => 'Seleccionar contactos';

  @override
  String chatMembersInvited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros invitados',
      one: 'Invitó a 1 miembro',
    );
    return '$_temp0';
  }

  @override
  String chatInviteMembersFailed(Object error) {
    return 'No se pudo invitar a miembros: $error';
  }

  @override
  String get chatGroupCreated =>
      'Chat grupal creado. Consulta la lista de chats.';

  @override
  String get chatGroupCreateFailed => 'No se pudo crear el chat grupal';

  @override
  String chatGroupCreateFailedWithError(Object error) {
    return 'No se pudo crear el chat grupal: $error';
  }

  @override
  String get chatClearCurrentConfirm => '¿Borrar el historial de chat actual?';

  @override
  String get chatDeleteAndExitConfirm =>
      'Después de eliminar y salir, ya no recibirás mensajes de este grupo.';

  @override
  String get chatBlockConfirm =>
      'Después de agregar este contacto a la lista negra, ya no recibirás sus mensajes.';

  @override
  String get chatSearchTabAll => 'Conversaciones';

  @override
  String get chatSearchTabMedia => 'Fotos/Videos';

  @override
  String get chatSearchTabFile => 'Archivos';

  @override
  String get chatSearchNoMatches => 'No hay historial de chat coincidente';

  @override
  String get chatSearchNoMore => 'No más resultados';

  @override
  String get chatDetailsTooltip => 'Detalles del chat';

  @override
  String get chatVoiceInputTooltip => 'Entrada de voz';

  @override
  String get chatInputHint => 'Mensaje...';

  @override
  String get chatFlameEnabledTooltip =>
      'Grabar después de que la lectura esté activada';

  @override
  String get chatFlameDestroyOnExit => 'Destruir después de salir del chat';

  @override
  String chatFlameDestroyAfterMinutes(Object minutes) {
    return 'Destruir después de $minutes min';
  }

  @override
  String chatFlameDestroyAfterSeconds(Object seconds) {
    return 'Destruir después de ${seconds}s';
  }

  @override
  String chatFlameEnabledNotice(Object label) {
    return 'Grabar después de leer está activado. Los mensajes se destruirán $label después de leerlos. Utilice la configuración superior derecha para desactivarlo.';
  }

  @override
  String get chatEmojiTooltip => 'Emojis';

  @override
  String get chatActionReply => 'Responder';

  @override
  String get chatActionCopy => 'Copiar';

  @override
  String get chatActionTranslate => 'Traducir';

  @override
  String get chatActionTranscribe => 'Transcribir';

  @override
  String get chatActionForward => 'Adelante';

  @override
  String get chatActionFavorite => 'Favorito';

  @override
  String get chatActionPin => 'Alfiler';

  @override
  String get chatActionUnpin => 'Desanclar';

  @override
  String get chatActionAddFriend => 'Agregar amigo';

  @override
  String get chatActionMultiSelect => 'Seleccionar';

  @override
  String get chatActionEdit => 'Editar';

  @override
  String get chatActionEditImage => 'Editar imagen';

  @override
  String get chatActionRevoke => 'Retiro';

  @override
  String get chatActionDelete => 'Eliminar';

  @override
  String get chatGroupCallActive => 'Llamada grupal en curso';

  @override
  String chatMessageRevokedBy(Object name) {
    return '$name recordó un mensaje';
  }

  @override
  String get chatReedit => 'Reeditar';

  @override
  String get chatEditedSuffix => '(editado)';

  @override
  String chatActionReadBy(Object count) {
    return 'Leído por $count';
  }

  @override
  String chatActionReactedBy(Object count) {
    return '$count reacciones';
  }

  @override
  String chatSelectedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos seleccionados',
      one: '1 artículo seleccionado',
    );
    return '$_temp0';
  }

  @override
  String get chatNoReactions => 'Aún no hay reacciones';

  @override
  String chatReadStatusReadCount(Object count) {
    return 'Lectura ($count)';
  }

  @override
  String get chatNoReadReceipts => 'Ninguno todavía';

  @override
  String get chatHistoryAbove => 'Mensajes anteriores arriba';

  @override
  String chatUnreadNewMessages(Object count) {
    return '$count mensajes nuevos';
  }

  @override
  String get chatUnreadDivider => 'Nuevos mensajes a continuación';

  @override
  String get chatUnknownContentFallback =>
      'Esta versión no puede mostrar este mensaje. Actualice a la última versión.';

  @override
  String get chatMentionSomeone => 'Alguien te mencionó';

  @override
  String get chatToolAlbum => 'Álbum';

  @override
  String get chatToolCamera => 'Cámara';

  @override
  String get chatToolFile => 'Archivo';

  @override
  String get chatToolLocation => 'Ubicación';

  @override
  String get chatToolContactCard => 'Tarjeta de contacto';

  @override
  String get chatToolAudioCall => 'Llamada de voz';

  @override
  String get chatToolVideoCall => 'Videollamada';

  @override
  String get chatDraftLabel => '[Borrador]';

  @override
  String get visitorBadge => 'Visitante';

  @override
  String get chatNoticeDeleted => 'Eliminado';

  @override
  String get chatNoticeCopied => 'Copiado';

  @override
  String get chatMentionLoadedOrInvisible =>
      'El mensaje @ está cargado o no es visible. Desplácese hacia arriba para encontrarlo.';

  @override
  String get chatLocationDefaultTitle => 'Ubicación';

  @override
  String get chatLocationCopied => 'Ubicación copiada';

  @override
  String get chatReadStatusTitle => 'Estado de lectura';

  @override
  String get chatReadStatusRead => 'Leer';

  @override
  String get chatReadStatusUnread => 'No leído';

  @override
  String get chatReadStatusUnavailable =>
      'Las listas completas de lecturas/no lecturas aún no están disponibles';

  @override
  String get chatComposerLeft => 'Dejaste este chat';

  @override
  String get chatComposerMuted => 'Este chat está silenciado';

  @override
  String chatComposerMutedUntil(Object time) {
    return 'Estás silenciado hasta el $time';
  }

  @override
  String chatFavoriteCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mensajes favoritos',
      one: '1 mensaje favorito',
    );
    return '$_temp0';
  }

  @override
  String chatFavoritePartial(Object failed, Object success) {
    return 'Favoritos completos: $success exitoso, $failed fallido';
  }

  @override
  String get chatForwardUnavailable => 'No se puede reenviar en este momento';

  @override
  String chatMergedForwardedTo(Object count, Object name) {
    return 'Fusionó $count mensajes a $name';
  }

  @override
  String chatForwardedIndividuallyTo(Object count, Object name) {
    return 'Reenvió $count mensajes uno por uno a $name';
  }

  @override
  String chatForwardedPartialTo(Object name, Object sent, Object total) {
    return 'Reenviado $sent/$total mensajes a $name';
  }

  @override
  String get chatForwardModeIndividual => 'Reenviar uno por uno';

  @override
  String get chatForwardModeMerge => 'Fusionar y reenviar';

  @override
  String get chatPresenceOnline => 'En línea';

  @override
  String get chatPresenceOffline => 'Sin conexión';

  @override
  String get chatPresenceJustActive => 'Activo ahora mismo';

  @override
  String chatPresenceMinutesAgo(Object minutes) {
    return 'Activo hace $minutes minutos';
  }

  @override
  String chatPresenceHoursAgo(Object hours) {
    return 'Activo hace $hours horas';
  }

  @override
  String chatPresenceDaysAgo(Object days) {
    return 'Activo hace $days días';
  }

  @override
  String get chatSensitiveDefaultTip =>
      'Este mensaje puede contener información confidencial.';

  @override
  String get chatMessageDigestFallback => '[Mensaje]';

  @override
  String get chatMediaServiceUnavailable =>
      'El servicio de medios no está listo';

  @override
  String get chatImDisconnected => 'IM no está conectado';

  @override
  String get chatPinFailedNotSent =>
      'No se puede fijar antes de que el mensaje llegue al servidor';

  @override
  String get chatPinFailed => 'No se pudo fijar. Intentar otra vez.';

  @override
  String get chatPinned => 'Fijado';

  @override
  String get chatUnpinFailed => 'No se pudo desanclar. Intentar otra vez.';

  @override
  String get chatUnpinned => 'Desanclado';

  @override
  String get chatClearPinnedConfirm => '¿Desanclar todos los mensajes fijados?';

  @override
  String get chatClearPinnedAction => 'Desanclar';

  @override
  String get chatAllUnpinned => 'Todos los mensajes fijados se desanclaron';

  @override
  String get chatPinnedMessageNotVisible =>
      'Este mensaje no está en el rango visible. Véalo desde la lista.';

  @override
  String get chatImageMissing => 'Falta información de la imagen';

  @override
  String get chatImageDownloadFailedEdit =>
      'No se pudo descargar la imagen. No se puede editar.';

  @override
  String get chatReactionFailed => 'La reacción falló. Intentar otra vez.';

  @override
  String get chatEditNotSynced =>
      'Error al editar: el mensaje no está sincronizado';

  @override
  String get chatEditFailed => 'Error al editar. Intentar otra vez.';

  @override
  String get chatFavoriteUnsupportedType =>
      'Este tipo aún no se puede marcar como favorito';

  @override
  String get chatFavoriteNotSent =>
      'El mensaje no ha llegado al servidor, por lo que no se puede marcar como favorito';

  @override
  String get chatFavoriteSuccess => 'Añadido a favoritos';

  @override
  String get chatFavoriteFailed =>
      'No se pudo marcar como favorito. Intentar otra vez.';

  @override
  String chatToolSelected(Object title) {
    return 'Seleccionado $title';
  }

  @override
  String chatCardDigest(Object name) {
    return '[Tarjeta] $name';
  }

  @override
  String get chatFriendAvatarFallback => 'F';

  @override
  String get chatUnknownMessageDigest => '[Desconocido]';

  @override
  String chatOpenFromContacts(Object name) {
    return 'Abrir el chat de @$name desde Contactos';
  }

  @override
  String get chatLoadingCard => 'Cargando tarjeta de contacto...';

  @override
  String get chatFileMissing => 'Falta información del archivo';

  @override
  String get chatVideoUnavailable => 'No se puede reproducir el vídeo';

  @override
  String get chatVideoSourceEmpty => 'La fuente del vídeo está vacía';

  @override
  String get chatLivePhotoUnavailable => 'Live Photo no se puede reproducir';

  @override
  String get messageAiTranslating => 'Traduciendo...';

  @override
  String get messageAiTranscribedShort => 'Hecho';

  @override
  String get messageAiVoiceSendingWait =>
      'La voz aún se está enviando. Vuelve a intentarlo más tarde.';

  @override
  String get messageAiNoTranscript => 'No se reconoce voz';

  @override
  String get messageAiMessageSendingWait =>
      'El mensaje aún se está enviando. Vuelve a intentarlo más tarde.';

  @override
  String get messageAiNoTranslation => 'No hay resultados de traducción';

  @override
  String get messageAiTemporarilyUnavailable => 'No disponible temporalmente';

  @override
  String get chatVoiceFileUnavailable => 'El archivo de voz no está disponible';

  @override
  String get chatVoicePlayFailed => 'Falló la reproducción. Intentar otra vez.';

  @override
  String get chatVoiceHoldToRecord =>
      'Mantener para grabar · Deslizar hacia arriba para cancelar';

  @override
  String chatVoiceReleaseToCancel(Object duration) {
    return 'Liberación para cancelar ($duration)';
  }

  @override
  String chatVoiceRecordingSlideCancel(Object duration) {
    return '$duration · Deslice hacia arriba para cancelar';
  }

  @override
  String get chatQrcodeNotFound => 'No se reconoce ningún código QR';

  @override
  String chatWebLoginQrcodeDetected(Object payload) {
    return 'Web inicio de sesión Código QR reconocido\n$payload';
  }

  @override
  String get chatWebLoginConfirmTitle =>
      '¿Confirmar inicio de sesión en la web?';

  @override
  String get chatWebLoginConfirmAction => 'Confirmar Web Iniciar sesión';

  @override
  String get chatWebLoginConfirmed => 'Web inicio de sesión confirmado';

  @override
  String chatQrcodeDetected(Object payload) {
    return 'Código QR reconocido\n$payload';
  }

  @override
  String get chatStickerPlaceholder => '[Pegatina]';

  @override
  String get chatStickerAdded => 'Añadido a pegatinas';

  @override
  String get chatStickerAddFailed =>
      'No se pudo agregar la etiqueta. Intentar otra vez.';

  @override
  String get mentionAllMembers => 'Todos los miembros';

  @override
  String get mentionAllMembersSubtitle => 'Notificar a todos en este grupo';

  @override
  String get chatQuoteOriginalRevoked => 'Se recordó el mensaje original';

  @override
  String get chatRecognizeImageQrcode => 'Escanear código QR en imagen';

  @override
  String get chatAddToStickers => 'Agregar a pegatinas';

  @override
  String get chatGroupInviteApprovalUrlEmpty =>
      'La URL de aprobación de invitación grupal está vacía';

  @override
  String get chatGroupInviteApprovalTitle => 'Aprobación de invitación grupal';

  @override
  String get chatGroupInviteApprovalBody =>
      'Complete la confirmación de invitación al grupo en la página web.';

  @override
  String get chatGroupInviteGoConfirm => 'Confirmar';

  @override
  String get chatGroupInviteApprovalOpenFailed =>
      'No se pudo abrir la aprobación de la invitación al grupo. Intentar otra vez.';

  @override
  String get chatSendFailed => 'No se pudo enviar. Intentar otra vez.';

  @override
  String get chatCallActiveHangupFirst =>
      'Una llamada está activa. Cuelga primero.';

  @override
  String get chatCallActiveCannotJoinAgain =>
      'Hay una llamada activa. No puedo volver a unirme.';

  @override
  String get chatCallUnsupported =>
      'Las llamadas no son compatibles con esta versión';

  @override
  String get chatCallServiceUnavailable =>
      'El servicio de llamadas no está listo';

  @override
  String get chatCallJoinFailedEnded =>
      'No se pudo unir. Es posible que la llamada haya terminado.';

  @override
  String get callWaitingAnswer => 'Esperando respuesta';

  @override
  String get callMessage => 'Mensaje de llamada';

  @override
  String get callEnded => 'Llamada finalizada';

  @override
  String get callPeerRefused => 'Compañero rechazado';

  @override
  String get callPeerHungUp => 'El compañero colgó';

  @override
  String get callPeerDeclinedVideoSwitch =>
      'El par rechazó la solicitud de cambio de video';

  @override
  String get callSwitchVideoRequestTitle =>
      'Solicitudes de pares para cambiar a video';

  @override
  String get callAgree => 'De acuerdo';

  @override
  String get callReconnecting => 'Reconectando…';

  @override
  String get callWaitingPeerCamera => 'Esperando cámara par';

  @override
  String get callSelfFallbackName => 'Yo';

  @override
  String get callUnknownUser => 'Usuario desconocido';

  @override
  String callJoinedCount(int joined, int total) {
    return '$joined/$total se unió';
  }

  @override
  String get callMute => 'Silenciar';

  @override
  String get callSpeaker => 'Altavoz';

  @override
  String get callSwitchToVideo => 'Vídeo';

  @override
  String get callHangup => 'Colgar';

  @override
  String get callFlipCamera => 'Voltear';

  @override
  String get callSwitchToVoice => 'Audio';

  @override
  String get callCamera => 'Cámara';

  @override
  String get callBack => 'Volver';

  @override
  String get callPermissionMicrophone => 'micrófono';

  @override
  String get callPermissionMicrophoneCamera => 'micrófono y cámara';

  @override
  String callPermissionOpenSettings(String what) {
    return 'Habilitar el permiso $what en la configuración del sistema';
  }

  @override
  String callPermissionRequired(String what) {
    return 'Las llamadas necesitan el permiso $what';
  }

  @override
  String get callWaitingPeerConsent => 'Esperando aprobación de pares';

  @override
  String get callSwitchRequestFailed =>
      'No se pudo enviar la solicitud de cambio';

  @override
  String get callCameraPermissionRequired =>
      'Se requiere permiso para la cámara';

  @override
  String get callCameraEnableFailed => 'No se pudo encender la cámara';

  @override
  String get incomingCallAccepting => 'Respondiendo...';

  @override
  String get incomingVideoCall => 'te invita a una videollamada';

  @override
  String get incomingAudioCall => 'te invita a una llamada de voz';

  @override
  String incomingAcceptFailed(String error) {
    return 'Respuesta fallida: $error';
  }

  @override
  String get incomingCallDecline => 'Rechazar';

  @override
  String get incomingCallAccept => 'Respuesta';

  @override
  String get chatGroupNoInviteCandidates =>
      'No hay miembros disponibles para invitar';

  @override
  String get chatInviteGroupMembersVideo =>
      'Invitar a miembros del grupo (videollamada)';

  @override
  String get chatInviteGroupMembersAudio =>
      'Invitar a miembros del grupo (llamada de voz)';

  @override
  String get chatSelfName => 'Yo';

  @override
  String get chatPeerPlaceholder => 'Otro';

  @override
  String get chatSomeonePlaceholder => 'Alguien';

  @override
  String chatScreenshotNotice(Object name) {
    return '$name tomó una captura de pantalla en el chat';
  }

  @override
  String chatDuplicateGroupMention(Object name) {
    return 'Varios miembros del grupo coinciden con @$name';
  }

  @override
  String chatDuplicateContactMention(Object name) {
    return 'Varios contactos coinciden con @$name';
  }

  @override
  String chatMentionNotFound(Object name) {
    return '@$name no encontrado';
  }

  @override
  String get chatForwardPickerTitle => 'Reenviar a';

  @override
  String get chatRecentContactsSection => 'Contactos recientes';

  @override
  String chatForwardedTo(Object name) {
    return 'Reenviado a $name';
  }

  @override
  String get favoriteTitle => 'Favoritos';

  @override
  String get favoriteEmptyTitle => 'Sin favoritos';

  @override
  String get favoriteEmptySubtitle =>
      'Mantenga presionado un mensaje en el chat y elija Favorito para guardarlo aquí.';

  @override
  String get favoriteDeleted => 'Eliminado';

  @override
  String favoriteDeleteFailed(Object error) {
    return 'Error al eliminar: $error';
  }

  @override
  String get favoriteDeleteFailedPlain => 'Error al eliminar';

  @override
  String get favoriteUnsupportedSend => 'Este tipo aún no se puede enviar';

  @override
  String favoriteSentTo(String name) {
    return 'Enviado a $name';
  }

  @override
  String favoriteSendFailed(Object error) {
    return 'Error de envío: $error';
  }

  @override
  String get favoriteSendFailedPlain => 'Envío fallido';

  @override
  String get favoriteSendToFriend => 'Enviar a un amigo';

  @override
  String get favoriteCopied => 'Copiado';

  @override
  String get favoriteUnknownUser => 'Usuario desconocido';

  @override
  String favoriteDateMonthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String get groupSavedTitle => 'Grupos guardados';

  @override
  String get groupSaveTooltip => 'Guardar grupo';

  @override
  String get groupSearchHint => 'Buscar grupos';

  @override
  String get groupNoMatched => 'No hay grupos coincidentes';

  @override
  String get groupNoSaveCandidatesToast =>
      'No hay grupos disponibles para guardar';

  @override
  String get groupSavedToContacts => 'Guardado en contactos';

  @override
  String groupSaveFailed(Object error) {
    return 'No se pudo guardar: $error';
  }

  @override
  String get groupSelectTitle => 'Seleccionar grupo';

  @override
  String get groupNoSaveCandidates => 'No hay grupos disponibles para guardar';

  @override
  String get groupCreateTitle => 'Iniciar chat grupal';

  @override
  String get groupSearchContactsHint => 'Buscar contactos';

  @override
  String get groupNoMatchedContacts => 'No hay contactos coincidentes';

  @override
  String groupMemberSummary(num count, Object subtitle) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0· $subtitle';
  }

  @override
  String get groupMuted => 'Silenciado';

  @override
  String get groupDetailsTitle => 'Detalles del grupo';

  @override
  String groupMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String get groupMembersSection => 'Miembros del grupo';

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
  String get groupNoMembers => 'Ningún miembro del grupo';

  @override
  String get groupInviteMembers => 'Invitar miembros';

  @override
  String get groupInviteMembersSubtitle => 'Elegir entre contactos';

  @override
  String get groupRemoveMembers => 'Eliminar miembros';

  @override
  String get groupRemoveMembersEmptySubtitle => 'No hay miembros para eliminar';

  @override
  String get groupRemoveMembersSubtitle => 'Elija miembros para eliminar';

  @override
  String get groupQrCodeTitle => 'Código QR del grupo';

  @override
  String get groupQrCodeSubtitle => 'Escanee para unirse a este grupo';

  @override
  String get groupNameTitle => 'Nombre del grupo';

  @override
  String get groupNoticeTitle => 'Anuncio del grupo';

  @override
  String get groupNoticeUnset => 'No establecido';

  @override
  String get groupManageTitle => 'Gestión de grupo';

  @override
  String get groupManageSubtitle =>
      'Administradores, silencio y permisos de grupo';

  @override
  String get groupInviteConfirm => 'Confirmación de invitación';

  @override
  String get groupBlacklistTitle => 'Lista negra de grupo';

  @override
  String get groupBlacklistSubtitle =>
      'Administrar miembros bloqueados para hablar o unirse';

  @override
  String get groupSaveToContacts => 'Guardar en Contactos';

  @override
  String get groupMuteMessages => 'Silenciar notificaciones';

  @override
  String get groupExited => 'Abandonó el chat grupal';

  @override
  String get groupExitAction => 'Abandonar grupo';

  @override
  String groupMembersSyncFailed(Object error) {
    return 'Error al sincronizar los miembros del grupo: $error';
  }

  @override
  String get groupInvitePickerTitle => 'Elija miembros para invitar';

  @override
  String groupInviteSentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Envió $count invitaciones de miembros',
      one: 'Envió 1 invitación de miembro',
    );
    return '$_temp0';
  }

  @override
  String groupInvitedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros invitados',
      one: 'Invitó a 1 miembro',
    );
    return '$_temp0';
  }

  @override
  String groupInviteMembersFailed(Object error) {
    return 'No se pudo invitar a los miembros: $error';
  }

  @override
  String get groupRemovePickerTitle => 'Elija miembros para eliminar';

  @override
  String groupQuotedMemberName(Object name) {
    return '\"$name\"';
  }

  @override
  String groupSelectedMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersConfirm(Object target) {
    return '¿Eliminar $target de este grupo?';
  }

  @override
  String get groupRemoveAction => 'Eliminar';

  @override
  String groupRemovedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se eliminaron $count miembros',
      one: 'Eliminado 1 miembro',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersFailed(Object error) {
    return 'No se pudieron eliminar miembros: $error';
  }

  @override
  String get groupSettingsUpdated => 'Configuración del grupo actualizada';

  @override
  String groupSettingsUpdateFailed(Object error) {
    return 'Error al actualizar la configuración del grupo: $error';
  }

  @override
  String get groupExitConfirm =>
      'Ya no recibirás mensajes de este grupo después de abandonarlo.';

  @override
  String get groupExitSuccess => 'Abandonó el chat grupal';

  @override
  String groupExitFailed(Object error) {
    return 'No se pudo salir: $error';
  }

  @override
  String get groupOwnerAdminSection => 'Propietario y administradores';

  @override
  String get groupOwnerRole => 'Propietario';

  @override
  String get groupAdminRole => 'Administrador';

  @override
  String get groupRemove => 'Eliminar';

  @override
  String get groupAddAdmin => 'Agregar administrador de grupo';

  @override
  String get groupNoAdmins => 'Sin administradores';

  @override
  String get groupInviteConfirmRemark =>
      'Cuando está habilitado, los miembros necesitan la aprobación del propietario o administrador antes de invitar a amigos. Unirse mediante código QR también estará deshabilitado.';

  @override
  String get groupOwnerTransfer => 'Transferir propiedad';

  @override
  String get groupMemberSettingsSection => 'Configuración de miembros';

  @override
  String get groupAllMutedRemark =>
      'Cuando el silencio de todos los miembros está habilitado, solo el propietario y los administradores pueden hablar.';

  @override
  String get groupAllMuted => 'Silenciar a todos los miembros';

  @override
  String get groupForbiddenAddFriendRemark =>
      'Cuando está habilitado, los miembros no pueden agregar amigos a través de este grupo.';

  @override
  String get groupForbiddenAddFriend =>
      'Bloquear miembros para que no agreguen amigos';

  @override
  String get groupAllowHistoryRemark =>
      'Cuando está habilitado, los nuevos miembros pueden ver el historial de chat anterior.';

  @override
  String get groupAllowHistory =>
      'Permitir que los nuevos miembros vean el historial';

  @override
  String get groupAddAdminPickerTitle => 'Agregar administrador de grupo';

  @override
  String groupAdminAddedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se agregaron $count administradores',
      one: 'Añadido 1 administrador',
    );
    return '$_temp0';
  }

  @override
  String groupAddAdminFailed(Object error) {
    return 'No se pudo agregar el administrador: $error';
  }

  @override
  String groupRemoveAdminConfirm(Object name) {
    return 'Remove admin role from \"$name\"?';
  }

  @override
  String get groupRemoveAdminAction => 'Eliminar administrador';

  @override
  String get groupRemoveAdminSuccess => 'Administrador eliminado';

  @override
  String groupRemoveAdminFailed(Object error) {
    return 'No se pudo eliminar el administrador: $error';
  }

  @override
  String get groupSelectNewOwner => 'Seleccionar nuevo propietario';

  @override
  String groupTransferOwnerConfirm(Object name) {
    return '¿Transferir propiedad a \"$name\"? Te convertirás en miembro regular.';
  }

  @override
  String get groupTransferOwnerAction => 'Confirmar transferencia';

  @override
  String get groupOwnerTransferred => 'Propiedad transferida';

  @override
  String groupOwnerTransferFailed(Object error) {
    return 'No se pudo transferir la propiedad: $error';
  }

  @override
  String get groupNoticePublisherDefault => 'Anuncio del grupo';

  @override
  String get groupNoticePublishTitle => 'Publicar anuncio de grupo';

  @override
  String get groupNoticeEditTitle => 'Editar anuncio de grupo';

  @override
  String get groupNoticePublishAction => 'Publicación';

  @override
  String get groupNoticeEmpty => 'Sin anuncio de grupo';

  @override
  String get groupNoticePublishedAtUnknown => 'Hora de publicación desconocida';

  @override
  String get groupMemberRemarkTitle => 'Mi apodo en este grupo';

  @override
  String get groupMemberRemarkHint => 'Establece tu apodo en este grupo';

  @override
  String get groupQrCodeEmpty => 'Sin código QR de grupo';

  @override
  String groupQrCodeValid(Object day, Object expire) {
    return 'Este código QR es válido por $day días ($expire)';
  }

  @override
  String get groupQrCodeScanToJoin =>
      'Escanea el código QR para unirte a este grupo';

  @override
  String get groupBlacklistLoadFailed =>
      'Error al cargar la lista negra. Intentar otra vez.';

  @override
  String get groupBlacklistEmpty => 'No hay miembros en la lista negra';

  @override
  String get groupBlacklistAddMember => 'Agregar miembro a la lista negra';

  @override
  String get groupBlacklistNoCandidates =>
      'No se pueden agregar miembros a la lista negra';

  @override
  String get groupSelectMember => 'Seleccionar miembro';

  @override
  String get groupBlacklistAdded => 'Agregado a la lista negra';

  @override
  String get groupBlacklistAddFailed =>
      'No se pudo agregar a la lista negra. Intentar otra vez.';

  @override
  String groupBlacklistRemoveConfirm(Object name) {
    return '¿Eliminar \"$name\" de la lista negra del grupo?';
  }

  @override
  String get groupBlacklistRemoveAction => 'Eliminar de la lista negra';

  @override
  String get groupBlacklistRemoveFailed =>
      'No se pudo eliminar de la lista negra. Intentar otra vez.';

  @override
  String get groupAvatarTitle => 'Avatar de grupo';

  @override
  String get groupAvatarTakePhoto => 'Tomar foto';

  @override
  String get groupAvatarChooseFromAlbum => 'Elegir del álbum';

  @override
  String get groupAvatarSaveImage => 'Guardar imagen';

  @override
  String get groupAvatarUnsupported =>
      'Este chat no admite cambiar el avatar del grupo';

  @override
  String get groupAvatarUpdated => 'Avatar de grupo actualizado';

  @override
  String get groupAvatarUpdateFailed =>
      'No se pudo actualizar el avatar del grupo. Intentar otra vez.';

  @override
  String get groupAvatarNoImageToSave => 'No hay avatar para guardar';

  @override
  String groupPhotoPermissionRequired(Object appName) {
    return 'Permitir que $appName acceda a tus fotos';
  }

  @override
  String get groupImageSavedToAlbum => 'Guardado en el álbum';

  @override
  String get groupImageSaveFailed => 'No se pudo guardar. Intentar otra vez.';

  @override
  String get imageEditorProcessing => 'Procesando...';

  @override
  String get imageEditorDiscardTitle => '¿Descartar ediciones?';

  @override
  String get imageEditorDiscardMessage =>
      'Las ediciones no guardadas se perderán.';

  @override
  String get imageEditorDiscardConfirm => 'Descartar';

  @override
  String get imageEditorPaint => 'Sorteo';

  @override
  String get imageEditorFreestyle => 'Mano alzada';

  @override
  String get imageEditorArrow => 'Flecha';

  @override
  String get imageEditorLine => 'Línea';

  @override
  String get imageEditorRectangle => 'Rectángulo';

  @override
  String get imageEditorCircle => 'Círculo';

  @override
  String get imageEditorDashLine => 'Línea discontinua';

  @override
  String get imageEditorMoveAndZoom => 'Mover/Acercar';

  @override
  String get imageEditorEraser => 'Borrador';

  @override
  String get imageEditorLineWidth => 'Ancho';

  @override
  String get imageEditorToggleFill => 'Rellenar';

  @override
  String get imageEditorOpacity => 'Opacidad';

  @override
  String get imageEditorUndo => 'Deshacer';

  @override
  String get imageEditorRedo => 'Rehacer';

  @override
  String get imageEditorInputHint => 'Ingrese texto';

  @override
  String get imageEditorText => 'Texto';

  @override
  String get imageEditorTextAlign => 'Alinear';

  @override
  String get imageEditorBackground => 'Antecedentes';

  @override
  String get imageEditorFontScale => 'Tamaño de fuente';

  @override
  String get imageEditorCrop => 'Cultivo';

  @override
  String get imageEditorRotate => 'Rotar';

  @override
  String get imageEditorRatio => 'Relación';

  @override
  String get imageEditorReset => 'Restablecer';

  @override
  String get imageEditorFlip => 'Voltear';

  @override
  String get imageEditorFilter => 'Filtros';

  @override
  String get imageEditorFilterNone => 'Originales';

  @override
  String get imageEditorFilterAddictiveBlue => 'Azul Adictivo';

  @override
  String get imageEditorFilterAddictiveRed => 'Rojo Adictivo';

  @override
  String get imageEditorFilterAden => 'Adén';

  @override
  String get imageEditorFilterAmaro => 'Amaro';

  @override
  String get imageEditorFilterAshby => 'Ashby';

  @override
  String get imageEditorFilterBrannan => 'Brannan';

  @override
  String get imageEditorFilterBrooklyn => 'Brooklyn';

  @override
  String get imageEditorFilterCharmes => 'Encantos';

  @override
  String get imageEditorFilterClarendon => 'Clarendon';

  @override
  String get imageEditorFilterCrema => 'Crema';

  @override
  String get imageEditorFilterDogpatch => 'Parche para perros';

  @override
  String get imageEditorFilterEarlybird => 'Madrugador';

  @override
  String get imageEditorFilterGingham => 'Guingán';

  @override
  String get imageEditorFilterGinza => 'Ginza';

  @override
  String get imageEditorFilterHefe => 'Hefe';

  @override
  String get imageEditorFilterHelena => 'Helena';

  @override
  String get imageEditorFilterHudson => 'Hudson';

  @override
  String get imageEditorFilterInkwell => 'Tintero';

  @override
  String get imageEditorFilterJuno => 'Juno';

  @override
  String get imageEditorFilterKelvin => 'Kelvin';

  @override
  String get imageEditorFilterLark => 'Alondra';

  @override
  String get imageEditorFilterLoFi => 'Lo-Fi';

  @override
  String get imageEditorFilterLudwig => 'Luis';

  @override
  String get imageEditorFilterMaven => 'Experto';

  @override
  String get imageEditorFilterMayfair => 'Mayfair';

  @override
  String get imageEditorFilterMoon => 'Luna';

  @override
  String get imageEditorFilterNashville => 'Nashville';

  @override
  String get imageEditorFilterPerpetua => 'Perpetua';

  @override
  String get imageEditorFilterReyes => 'Reyes';

  @override
  String get imageEditorFilterRise => 'Subida';

  @override
  String get imageEditorFilterSierra => 'Sierra';

  @override
  String get imageEditorFilterSkyline => 'Horizonte';

  @override
  String get imageEditorFilterSlumber => 'Sueño';

  @override
  String get imageEditorFilterStinson => 'Stinson';

  @override
  String get imageEditorFilterSutro => 'Sutro';

  @override
  String get imageEditorFilterToaster => 'Tostadora';

  @override
  String get imageEditorFilterValencia => 'Valencia';

  @override
  String get imageEditorFilterVesper => 'Víspera';

  @override
  String get imageEditorFilterWalden => 'Walden';

  @override
  String get imageEditorFilterWillow => 'Sauce';

  @override
  String get imageEditorBlur => 'Desenfoque';

  @override
  String get imageEditorTune => 'Ajustar';

  @override
  String get imageEditorBrightness => 'Brillo';

  @override
  String get imageEditorContrast => 'Contraste';

  @override
  String get imageEditorSaturation => 'Saturación';

  @override
  String get imageEditorExposure => 'Exposición';

  @override
  String get imageEditorHue => 'Tono';

  @override
  String get imageEditorTemperature => 'Temperatura';

  @override
  String get imageEditorSharpness => 'Nitidez';

  @override
  String get imageEditorFade => 'Desvanecerse';

  @override
  String get imageEditorLuminance => 'Luminancia';

  @override
  String get imageEditorEmoji => 'Emoji';

  @override
  String get imageEditorEmojiRecent => 'Reciente';

  @override
  String get imageEditorEmojiSmileys => 'Emoticonos';

  @override
  String get imageEditorEmojiAnimals => 'Animales';

  @override
  String get imageEditorEmojiFood => 'Comida';

  @override
  String get imageEditorEmojiActivities => 'Actividades';

  @override
  String get imageEditorEmojiTravel => 'Viajes';

  @override
  String get imageEditorEmojiObjects => 'Objetos';

  @override
  String get imageEditorEmojiSymbols => 'Símbolos';

  @override
  String get imageEditorEmojiFlags => 'Banderas';

  @override
  String get imageEditorSticker => 'Pegatinas';

  @override
  String get imageEditorRemove => 'Eliminar';

  @override
  String get imageEditorSaving => 'Guardando...';

  @override
  String get imageEditorImporting => 'Importando';

  @override
  String get imagePreviewTitle => 'Vista previa de imagen';

  @override
  String get imagePreviewSavingToAlbum => 'Guardando...';

  @override
  String get imagePreviewAddToSticker => 'Agregar a pegatinas';

  @override
  String get imagePreviewAddingToSticker => 'Añadiendo...';

  @override
  String get imagePreviewRecognizeQr => 'Reconocer código QR';

  @override
  String get imagePreviewRecognizingQr => 'Reconociendo...';

  @override
  String get imagePreviewConfirmWebLogin => 'Confirmar Web Iniciar sesión';

  @override
  String get imagePreviewConfirmingWebLogin => 'Confirmando...';

  @override
  String get imagePreviewOpenLink => 'Abrir enlace';

  @override
  String get imagePreviewImageNotDownloadedSave =>
      'La imagen aún no se ha descargado';

  @override
  String get imagePreviewMediaUnavailable =>
      'El servicio de medios no está disponible';

  @override
  String get imagePreviewImageNotUploadedSticker =>
      'La imagen aún no está cargada';

  @override
  String get imagePreviewStickerUnavailable =>
      'El servicio de pegatinas no está disponible';

  @override
  String get imagePreviewAddedToSticker => 'Añadido a pegatinas';

  @override
  String get imagePreviewImageNotDownloadedRecognize =>
      'La imagen aún no se ha descargado';

  @override
  String get imagePreviewQrNotFound => 'No se encontró ningún código QR';

  @override
  String get imagePreviewWebLoginQrRecognized =>
      'Web inicio de sesión Código QR reconocido';

  @override
  String get imagePreviewWebLinkRecognized => 'Web enlace reconocido';

  @override
  String get imagePreviewQrRecognized => 'Código QR reconocido';

  @override
  String get imagePreviewWebLoginConfirmed => 'Web inicio de sesión confirmado';

  @override
  String get pickerFileTitle => 'Elija Archivo';

  @override
  String get pickerRecentFiles => 'Archivos recientes';

  @override
  String get pickerSampleProjectFile => 'Notas del Proyecto.pdf';

  @override
  String get pickerSampleProjectFileSubtitle => '128 KB · Hoy';

  @override
  String get pickerSampleScreenshotFile => 'Captura de pantalla del chat.png';

  @override
  String get pickerSampleScreenshotFileSubtitle => '2.4 MB · Ayer';

  @override
  String get pickerContactTitle => 'Elija contacto';

  @override
  String get pickerContactCardSection => 'Enviar tarjeta de contacto';

  @override
  String get pickerSearchContacts => 'Buscar contactos';

  @override
  String get pickerNoMatchingContacts => 'No hay contactos coincidentes';

  @override
  String get chatSendFailedShort => 'Error de envío';

  @override
  String get chatResend => 'Reenviar';

  @override
  String get chatStatusRead => 'Leer';

  @override
  String get pinnedMessageTitle => 'Mensaje fijado';

  @override
  String pinnedMessageTitleWithIndex(int index, int total) {
    return 'Mensaje fijado $index/$total';
  }

  @override
  String get pinnedMessageOpen => 'Toque para ver';

  @override
  String get pinnedMessageViewAllTooltip => 'Ver todo fijado';

  @override
  String get pinnedMessageUnpinTooltip => 'Desanclar';

  @override
  String pinnedMessageListCount(int count) {
    return '$count Mensajes fijados';
  }

  @override
  String get pinnedMessageClearAll => 'Desanclar todo';

  @override
  String get pinnedMessageFallback => 'Mensaje fijado';

  @override
  String get fileUnnamed => 'Archivo sin título';

  @override
  String get fileNoDownloadUrl => 'No hay enlace de descarga disponible';

  @override
  String get fileTitle => 'Archivo';

  @override
  String fileSizeLabel(String size) {
    return 'Tamaño de archivo: $size';
  }

  @override
  String get fileDownloadFailed => 'Error al descargar';

  @override
  String get filePreview => 'Vista previa';

  @override
  String get fileOpenWithOtherApp => 'Abrir en otra aplicación';

  @override
  String get actionEnable => 'Habilitar';

  @override
  String get actionDisable => 'Desactivar';

  @override
  String get profileInviteLoading => 'Cargando código de invitación';

  @override
  String get profileInviteEnabled => 'Código de invitación habilitado';

  @override
  String get profileInviteDisabled => 'Código de invitación deshabilitado';

  @override
  String profileInviteLoadFailed(String error) {
    return 'Error al cargar el código de invitación: $error';
  }

  @override
  String get profileInviteCopied => 'Copiado';

  @override
  String profileInviteUpdateFailed(String error) {
    return 'No se pudo actualizar el código de invitación: $error';
  }

  @override
  String get stickerStoreTitle => 'Tienda de pegatinas';

  @override
  String get stickerNoPacks => 'Sin paquetes de pegatinas';

  @override
  String get stickerDetailTitle => 'Detalles de la etiqueta';

  @override
  String get stickerProcessing => 'Procesando...';

  @override
  String get stickerAddCustomTitle => 'Agregar pegatina personalizada';

  @override
  String get stickerSortTitle => 'Ordenar pegatinas';

  @override
  String get stickerMyStickersTitle => 'Mis pegatinas';

  @override
  String get stickerSaving => 'Ahorro';

  @override
  String get stickerSortAction => 'Ordenar';

  @override
  String get stickerOrganize => 'Organizar';

  @override
  String get stickerCustomTitle => 'Calcomanías personalizadas';

  @override
  String get stickerCustomSubtitle =>
      'Administrar stickers personalizados guardados';

  @override
  String get stickerNoSortablePacks =>
      'No hay paquetes de pegatinas para ordenar';

  @override
  String get stickerNoCategories => 'Sin categorías de pegatinas';

  @override
  String get stickerMoveUp => 'Subir';

  @override
  String get stickerMoveDown => 'Mover hacia abajo';

  @override
  String get stickerNoCustomStickers => 'Sin pegatinas personalizadas';

  @override
  String get stickerMoveToFront => 'Mover al frente';

  @override
  String get stickerDeleteConfirmTitle =>
      'Los stickers eliminados no se pueden recuperar';

  @override
  String get complaintTitle => 'Informe';

  @override
  String get complaintHint => 'Describe el problema';

  @override
  String get complaintType => 'Tipo de informe';

  @override
  String get complaintSubmitted => 'Informe enviado';

  @override
  String get complaintSubmit => 'Enviar informe';

  @override
  String get complaintSubmitting => 'Enviando…';

  @override
  String get complaintFallbackOtherViolation => 'Otra infracción de política';

  @override
  String get complaintFallbackFraud => 'Otro fraude o estafa';

  @override
  String get complaintFallbackAccountCompromised =>
      'La cuenta puede estar comprometida';

  @override
  String get chatBackgroundTitle => 'Fondo de chat';

  @override
  String get chatBackgroundLoading => 'Cargando fondos de chat';

  @override
  String get chatBackgroundEmpty => 'Sin fondos de chat';

  @override
  String get chatBackgroundDefault => 'Fondo predeterminado';

  @override
  String chatBackgroundItem(int index) {
    return 'Antecedentes $index';
  }

  @override
  String get chatBackgroundPreviewTitle => 'Vista previa del fondo';

  @override
  String get chatBackgroundSet => 'Establecer fondo';

  @override
  String get chatBackgroundSelectedStatus => 'Conjunto de fondo de chat';

  @override
  String get chatBackgroundInUse => 'En uso';

  @override
  String get chatContactFallback => 'Contacto';

  @override
  String get chatPersonalCard => 'Tarjeta de contacto';

  @override
  String get chatSystemMessageDigest => '[Mensaje del sistema]';

  @override
  String get chatMessageDigestMessage => '[Mensaje]';

  @override
  String get chatMessageDigestImage => '[Imagen]';

  @override
  String get chatMessageDigestVoice => '[Voz]';

  @override
  String get chatMessageDigestVideo => '[Vídeo]';

  @override
  String get chatMessageDigestLocation => '[Ubicación]';

  @override
  String get chatMessageDigestCard => '[Tarjeta de contacto]';

  @override
  String get chatMessageDigestFile => '[Archivo]';

  @override
  String get chatMessageDigestHistory => '[Historial de chat]';

  @override
  String get chatMessageDigestSticker => '[Pegatina]';

  @override
  String get dateWeekdayShortMonday => 'lunes';

  @override
  String get dateWeekdayShortTuesday => 'martes';

  @override
  String get dateWeekdayShortWednesday => 'miércoles';

  @override
  String get dateWeekdayShortThursday => 'jueves';

  @override
  String get dateWeekdayShortFriday => 'Viernes';

  @override
  String get dateWeekdayShortSaturday => 'sábado';

  @override
  String get dateWeekdayShortSunday => 'sol';

  @override
  String get appIconClassic => 'Clásico';

  @override
  String get appIconSimple => 'Sencillo';

  @override
  String get appIconDark => 'Oscuro';

  @override
  String get appIconFestive => 'Festivo';

  @override
  String get appIconGradient => 'Degradado';

  @override
  String get appIconUpdated => 'Icono actualizado';

  @override
  String get appIconUpdateFailed =>
      'Error en el cambio. Vuelve a intentarlo más tarde.';

  @override
  String get appearanceBubbleColorPurple => 'Púrpura';

  @override
  String get appearanceBubbleColorGreen => 'Verde';

  @override
  String get appearanceBubbleColorBlue => 'Azul';

  @override
  String get appearanceBubbleColorOrange => 'Naranja';

  @override
  String get appearanceBubbleColorPink => 'Rosa';

  @override
  String replyPreviewTitle(String name) {
    return 'Responder a $name';
  }

  @override
  String get replyPreviewCancel => 'Cancelar respuesta';

  @override
  String get chatPasswordTitle => 'Contraseña de chat';

  @override
  String get chatPasswordHint => 'Ingrese una contraseña de 6 dígitos';

  @override
  String chatPasswordErrorRemain(int remain) {
    return 'Contraseña incorrecta. El historial de chat se borrará después de $remain intentos fallidos más.';
  }

  @override
  String get emojiPackEmpty => 'No hay pegatinas en este paquete';

  @override
  String get emojiRecentSection => 'Reciente';

  @override
  String get emojiAllSection => 'Todos los emojis';

  @override
  String get stickerSearching => 'Buscando...';

  @override
  String get stickerNoSearchResults => 'Sin resultados';

  @override
  String get stickerSearchResultsTitle => 'Resultados:';

  @override
  String get homeChatPasswordWiped =>
      'Demasiados intentos incorrectos. Se eliminó el historial de chat.';

  @override
  String get homeGroupNotFound => 'Chat grupal no encontrado';

  @override
  String get homeConversationNoHistory => 'Sin historial de chat';

  @override
  String get homeConversationStartChat => 'Iniciar chat';

  @override
  String get homeEnterGroupChat => 'Ingresar al chat grupal';

  @override
  String get homeNewGroup => 'Nuevo chat grupal';

  @override
  String homeFriendRequestAcceptFailed(String error) {
    return 'No se pudo aceptar: $error';
  }

  @override
  String get homeFriendRequestAccepted => 'Solicitud de amistad aceptada';

  @override
  String homeFriendRequestRefuseFailed(String error) {
    return 'No se pudo rechazar: $error';
  }

  @override
  String homeFriendRequestDeleteFailed(String error) {
    return 'No se pudo eliminar: $error';
  }

  @override
  String contactPresenceOnlineWithDevice(String device) {
    return 'En línea el $device';
  }

  @override
  String contactPresenceJustOnlineWithDevice(String device) {
    return 'En línea el $device hace un momento';
  }

  @override
  String contactPresenceMinutesOnlineWithDevice(int minutes, String device) {
    return 'En línea el $device Hace $minutes minutos';
  }

  @override
  String contactPresenceLastOnline(String time) {
    return 'Última conexión $time';
  }

  @override
  String get contactPresenceDeviceWeb => 'web';

  @override
  String get contactPresenceDeviceDesktop => 'escritorio';

  @override
  String get contactPresenceDeviceMobile => 'móvil';

  @override
  String get botCommandsEmpty => 'Aún no hay comandos';
}
