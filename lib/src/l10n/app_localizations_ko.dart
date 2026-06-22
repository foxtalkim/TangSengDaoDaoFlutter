// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get tabMessages => '채팅';

  @override
  String get tabContacts => '연락처';

  @override
  String get tabDiscover => '발견';

  @override
  String get tabMe => '나';

  @override
  String get pageMessagesTitle => '채팅';

  @override
  String get pageContactsTitle => '연락처';

  @override
  String get pageDiscoverTitle => '발견';

  @override
  String get pageMeTitle => '나';

  @override
  String get actionCancel => '취소';

  @override
  String get actionConfirm => '확인';

  @override
  String get actionDone => '완료';

  @override
  String get actionSave => '저장';

  @override
  String get actionDelete => '삭제';

  @override
  String get actionEdit => '편집';

  @override
  String get actionAdd => '추가';

  @override
  String get actionRemove => '제거';

  @override
  String get actionInvite => '초대';

  @override
  String get actionSearch => '검색';

  @override
  String get actionSend => '보내기';

  @override
  String get actionRetry => '재시도';

  @override
  String get actionBack => '뒤로';

  @override
  String get actionMore => '더보기';

  @override
  String get actionJoin => '가입';

  @override
  String get actionSkip => '건너뛰기';

  @override
  String get actionContinue => '계속';

  @override
  String get actionGetStarted => '시작하기';

  @override
  String get actionSaving => '저장 중...';

  @override
  String get moduleUnsupported => '이 기능은 이 버전에서 사용할 수 없습니다.';

  @override
  String get moduleLoading => '기능 액세스를 확인하는 중입니다. 나중에 다시 시도하세요.';

  @override
  String get moduleOfflineStale => '기능 액세스를 확인하려면 네트워크에 연결하세요.';

  @override
  String get onboardingMenuTitle => '빠른 가이드';

  @override
  String onboardingChatTitle(Object appName) {
    return '$appName에 오신 것을 환영합니다.';
  }

  @override
  String get onboardingChatSubtitle => '더욱 편안하게 대화를 나눌 수 있는 깨끗하고 밝은 장소입니다.';

  @override
  String get onboardingFriendsTitle => '간단하게 연락을 유지하세요';

  @override
  String get onboardingFriendsSubtitle => '친구, 그룹, 공유 기능을 더 쉽게 찾을 수 있습니다.';

  @override
  String get onboardingSecurityTitle => '자유롭게 말하세요. 안심하고 사용하세요.';

  @override
  String get onboardingSecuritySubtitle =>
      '계정 보안 및 개인 정보 보호는 귀하의 경계를 보호하는 데 도움이 됩니다.';

  @override
  String get onboardingChatSemantic => '메시지 동기화 온보딩 그림';

  @override
  String get onboardingFriendsSemantic => '친구 및 그룹 온보딩 일러스트레이션';

  @override
  String get onboardingSecuritySemantic => '보안 및 개인정보 보호 온보딩 일러스트레이션';

  @override
  String get settingsLanguageRow => '언어';

  @override
  String get settingsLanguageSystem => '시스템 기본값';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => '영어';

  @override
  String get profileRowFavorites => '즐겨찾기';

  @override
  String get profileRowSecurityPrivacy => '보안 및 개인정보 보호';

  @override
  String get profileRowNotifications => '알림';

  @override
  String get profileRowInviteCode => '초대 코드';

  @override
  String get profileRowGeneral => '일반';

  @override
  String profileRowAbout(Object appName) {
    return '$appName 정보';
  }

  @override
  String get profileLogout => '로그아웃';

  @override
  String get profileLogoutConfirm =>
      '로그아웃해도 기록은 삭제되지 않습니다. 언제든지 이 계정으로 다시 로그인할 수 있습니다.';

  @override
  String profileMoyuIdLabel(Object appName, Object value) {
    return '$appName ID: $value';
  }

  @override
  String get profileDefaultName => '나';

  @override
  String get profileDetailTitle => '프로필';

  @override
  String get profileAvatar => '아바타';

  @override
  String get profileNickname => '닉네임';

  @override
  String get profileEditNickname => '닉네임 수정';

  @override
  String profileEditFoxId(Object appName) {
    return '$appName ID 수정';
  }

  @override
  String get profileGender => '성별';

  @override
  String get profileGenderMale => '남성';

  @override
  String get profileGenderFemale => '여성';

  @override
  String get profileGenderSelected => '선택됨';

  @override
  String get profileGenderUnset => '설정되지 않음';

  @override
  String get profilePhoneUnbound => '연결되지 않음';

  @override
  String get profileAvatarUpdated => '아바타가 업데이트되었습니다.';

  @override
  String get profileAvatarUpdateFailed => '아바타를 업로드하지 못했습니다. 다시 시도해 보세요.';

  @override
  String get generalPageTitle => '일반';

  @override
  String get generalFontSize => '글꼴 크기';

  @override
  String get generalChatBackground => '채팅 배경';

  @override
  String get generalDarkMode => '다크 모드';

  @override
  String get generalClearCache => '캐시 지우기';

  @override
  String get generalClearMessages => '채팅 기록 지우기';

  @override
  String get generalAppModules => '특징';

  @override
  String get generalErrorLogs => '오류 로그';

  @override
  String get generalThirdShare => '타사 SDK';

  @override
  String get fontSizeSmall => '소형';

  @override
  String get fontSizeStandard => '표준';

  @override
  String get fontSizeLarge => '대형';

  @override
  String get fontSizeExtraLarge => '특대형';

  @override
  String get darkModeSystem => '시스템 기본값';

  @override
  String get darkModeLight => '빛';

  @override
  String get darkModeDark => '어두운';

  @override
  String get valueConfigure => '구성';

  @override
  String get valueManage => '관리';

  @override
  String get valueClear => '지우기';

  @override
  String get valueUpload => '업로드';

  @override
  String get valueDownload => '다운로드';

  @override
  String get valueView => '보기';

  @override
  String get valueEnabled => '활성화됨';

  @override
  String get valueDisabled => '비활성화됨';

  @override
  String get valueOn => '켜기';

  @override
  String get valueOff => '꺼짐';

  @override
  String get valueConfigured => '설정';

  @override
  String get valueNotEnabled => '활성화되지 않음';

  @override
  String get valueSelected => '선택됨';

  @override
  String get valueCurrentDevice => '이 장치';

  @override
  String get valueSdkInfo => 'SDK 정보';

  @override
  String get statusProcessing => '처리 중';

  @override
  String get statusLoading => '로드 중';

  @override
  String get statusSending => '보내는 중';

  @override
  String get statusSaving => '저장 중';

  @override
  String get statusSaved => '저장됨';

  @override
  String get statusSent => '보냄';

  @override
  String get statusSubmitted => '제출됨';

  @override
  String get dateJustNow => '방금';

  @override
  String get dateToday => '오늘';

  @override
  String get dateYesterday => '어제';

  @override
  String get dateDayBeforeYesterday => '어제 전날';

  @override
  String dateTodayTime(Object time) {
    return '오늘 $time';
  }

  @override
  String dateYesterdayTime(Object time) {
    return '어제 $time';
  }

  @override
  String dateDayBeforeYesterdayTime(Object time) {
    return '이틀 전 $time';
  }

  @override
  String dateWeekdayTime(Object time, Object weekday) {
    return '$weekday $time';
  }

  @override
  String dateMonthDayTime(Object day, Object month, Object time) {
    return '$month월 $day일 $time';
  }

  @override
  String dateYearMonthDayTime(
    Object day,
    Object month,
    Object time,
    Object year,
  ) {
    return '$year년 $month월 $day일 $time';
  }

  @override
  String dateMonthDay(Object day, Object month) {
    return '$month월 $day일';
  }

  @override
  String dateYearMonthDay(Object day, Object month, Object year) {
    return '$year년 $month월 $day일';
  }

  @override
  String get weekdayMonday => '월요일';

  @override
  String get weekdayTuesday => '화요일';

  @override
  String get weekdayWednesday => '수요일';

  @override
  String get weekdayThursday => '목요일';

  @override
  String get weekdayFriday => '금요일';

  @override
  String get weekdaySaturday => '토요일';

  @override
  String get weekdaySunday => '일요일';

  @override
  String get dialogClearAllTitle => '모든 채팅 기록을 삭제하시겠습니까?';

  @override
  String get dialogClearAllBody => '모든 로컬 채팅 기록 및 대화 항목이 제거됩니다.';

  @override
  String get authLoginSubtitle => '전화번호로 로그인하고 친구들과 계속 채팅하세요';

  @override
  String get authLoginIllustration => '로그인 그림';

  @override
  String get authRegisterIllustration => '등록 그림';

  @override
  String get authSecurityIllustration => '확인 그림';

  @override
  String get authResetIllustration => '비밀번호 재설정 그림';

  @override
  String get authServerLabel => '서버';

  @override
  String get authServerCustomLabel => 'Custom server';

  @override
  String get authServerCustomHint => 'Enter server address';

  @override
  String get authPhoneLabel => '전화번호';

  @override
  String get authPasswordLabel => '비밀번호';

  @override
  String get authForgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get authLoginButton => '로그인';

  @override
  String get authLoginLoading => '로그인 중...';

  @override
  String get authRegisterButton => '등록';

  @override
  String get authLoginWithApple => 'Sign in with Apple';

  @override
  String get authLoginWithGoogle => 'Sign in with Google';

  @override
  String get authLoginWithGithub => 'Sign in with GitHub';

  @override
  String get authLoginAgreementPrefix => '로그인하면 다음에 동의하게 됩니다.';

  @override
  String get authTermsTitle => '서비스 약관';

  @override
  String get authAgreementConnector => '및';

  @override
  String get authPrivacyTitle => '개인정보 보호정책';

  @override
  String get authVerifyTitle => '인증 로그인';

  @override
  String authVerifySubtitleWithPhone(Object phone) {
    return '$phone(으)로 전송된 코드를 입력하세요';
  }

  @override
  String get authVerifySubtitlePasswordFirst => '보안 인증을 시작하려면 먼저 비밀번호로 로그인하세요.';

  @override
  String get authVerifyButton => '확인';

  @override
  String get authVerifyLoading => '확인 중...';

  @override
  String get authResendCode => '코드를 받지 못하셨나요? 재전송';

  @override
  String get authVerificationCodeSent => '인증 코드가 전송되었습니다.';

  @override
  String get authVerificationCodeRequired => '인증코드를 입력하세요';

  @override
  String get authVerificationCodeSixDigits => '6자리 코드를 입력하세요';

  @override
  String get authPasswordResetTitle => '로그인 비밀번호 재설정';

  @override
  String get authPasswordResetSubtitle => '전화번호를 확인한 후 새 로그인 비밀번호를 설정하세요.';

  @override
  String get authPasswordResetButton => '비밀번호 재설정';

  @override
  String get authKickedTitle => '귀하의 계정이 다른 기기에 로그인되었습니다.';

  @override
  String get authSubmitting => '제출 중...';

  @override
  String get authVerificationCodeLabel => '인증 코드';

  @override
  String get authGetVerificationCode => '코드 받기';

  @override
  String get authNewPasswordLabel => '새 비밀번호';

  @override
  String get authPasswordResetSuccess => '비밀번호 재설정';

  @override
  String authRegisterTitle(Object appName) {
    return '$appName 계정 만들기';
  }

  @override
  String get authRegisterSubtitle => '전화번호로 등록하고 바로 채팅을 시작해 보세요';

  @override
  String get authCreateAccount => '계정 만들기';

  @override
  String get authNicknameLabel => '닉네임';

  @override
  String get authInviteCodeRequiredLabel => '초대코드 (필수)';

  @override
  String authCodeRetryAfter(Object seconds) {
    return '$seconds초 후에 재시도';
  }

  @override
  String get authRegisterAgreement => '서비스 약관 및 개인정보 보호정책을 읽었으며 이에 동의합니다.';

  @override
  String get authInvalidPhone => '잘못된 전화번호';

  @override
  String get authAcceptAgreementFirst => '먼저 서비스 약관 및 개인정보 보호정책에 동의하세요.';

  @override
  String get authCodeEmpty => '인증 코드가 필요합니다';

  @override
  String get authPasswordLengthInvalid => '비밀번호는 6~16자여야 합니다.';

  @override
  String get authInviteCodeEmpty => '초대 코드가 필요합니다';

  @override
  String get authRegisterSuccess => '성공적으로 등록되었습니다';

  @override
  String get settingsCheckNewVersion => '업데이트 확인';

  @override
  String get settingsChecking => '확인 중';

  @override
  String get settingsVersionFound => '업데이트 가능';

  @override
  String get settingsUserAgreement => '서비스 약관';

  @override
  String get settingsPrivacyPolicy => '개인정보 보호정책';

  @override
  String get settingsView => '보기';

  @override
  String get settingsSwitchAccount => '계정 전환';

  @override
  String get settingsCacheCleared => '캐시가 삭제되었습니다.';

  @override
  String get settingsClearCacheSheetTitle =>
      '이미지/동영상 캐시 지우기?\n채팅 이미지, 동영상 커버, 아바타가 다시 다운로드됩니다.';

  @override
  String get settingsClearCacheAction => '캐시 지우기';

  @override
  String get settingsMessagesCleared => '채팅 기록이 삭제되었습니다.';

  @override
  String settingsClearMessagesFailed(Object error) {
    return '채팅 기록을 지우지 못했습니다: $error';
  }

  @override
  String get settingsAlreadyLatestVersion => '이미 최신 버전을 사용하고 있습니다.';

  @override
  String get settingsCheckFailed => '확인 실패';

  @override
  String settingsUpdateDialogTitle(Object version) {
    return '업데이트 가능\n최신 버전: $version';
  }

  @override
  String settingsUpdateDialogTitleWithDescription(
    Object description,
    Object version,
  ) {
    return '업데이트 가능\n최신 버전: $version\n$description';
  }

  @override
  String get settingsLater => '나중에';

  @override
  String get settingsUpdateNow => '지금 업데이트';

  @override
  String get settingsSaveFailedRetry => '저장하지 못했습니다. 다시 시도해 보세요.';

  @override
  String get securityAllowPhoneSearch => '다른 사람이 전화번호로 나를 찾을 수 있도록 허용';

  @override
  String securityAllowFoxIdSearch(Object appName) {
    return '다른 사람이 $appName ID로 나를 찾을 수 있도록 허용';
  }

  @override
  String get securitySearchRemark => '꺼져 있으면 다른 사용자가 위 정보를 통해 귀하를 찾을 수 없습니다.';

  @override
  String get securityJoinGroupNeedConfirm =>
      'Require confirmation to join groups';

  @override
  String get securityJoinGroupNeedConfirmRemark =>
      'When on, invitations to add you to a group must be confirmed by you first.';

  @override
  String get securityLoginPassword => '로그인 비밀번호';

  @override
  String get securityChatPassword => '채팅 비밀번호';

  @override
  String get securityScreenProtection => '화면 보호';

  @override
  String get securityLockPassword => '비밀번호 잠금';

  @override
  String get securityOfflineProtection => '오프라인 화면 잠금';

  @override
  String get securityDeviceManagement => '로그인 장치 관리';

  @override
  String get securityDeviceRemark =>
      '장치를 보고 관리하고, 로그인 보호를 활성화하고, 계정을 안전하게 유지하세요.';

  @override
  String get securityBlacklist => '블랙리스트';

  @override
  String get securityAccountDeletion => '계정 삭제';

  @override
  String get accountDeletionBody =>
      '계정 삭제는 취소할 수 없습니다. 확인 후 삭제를 완료하기 위해 인증번호가 SMS로 전송됩니다.';

  @override
  String get accountDeletionSubmitted => '삭제 요청이 제출되었습니다.';

  @override
  String get accountDeletionGetCode => '코드 받기';

  @override
  String get passwordResetInstruction =>
      '로그인 비밀번호를 변경하려면 SMS 코드가 필요합니다. 새 비밀번호는 6자 이상이어야 합니다.';

  @override
  String get accountPhoneLabel => '전화번호';

  @override
  String get passwordRuleLabel => '비밀번호 규칙';

  @override
  String get passwordAtLeastSix => '6자 이상';

  @override
  String get passwordConfirmLabel => '비밀번호 확인';

  @override
  String get passwordConfirmHint => '로그인 비밀번호를 다시 입력하세요';

  @override
  String get passwordChanged => '로그인 비밀번호가 변경되었습니다.';

  @override
  String get phoneRequired => '전화번호가 필요합니다.';

  @override
  String get passwordMismatch => '비밀번호가 일치하지 않습니다.';

  @override
  String get chatPasswordInstruction =>
      '활성화되면 보호된 채팅을 열기 전에 이 6자리 비밀번호가 필요합니다.';

  @override
  String get currentStatusLabel => '현재 상태';

  @override
  String get passwordSixDigits => '6자리';

  @override
  String get chatPasswordEnableAction => '채팅 비밀번호 활성화';

  @override
  String get loginPasswordRequired => '로그인 비밀번호가 필요합니다';

  @override
  String get chatPasswordSixDigitsRequired => '채팅 비밀번호는 6자리여야 합니다.';

  @override
  String get lockSetTitle => '6자리 잠금 비밀번호를 설정하세요';

  @override
  String lockSetSubtitle(Object appName) {
    return '$appName을(를) 잠금 해제하는 데 필요합니다.';
  }

  @override
  String get lockCurrentPromptTitle => '현재 잠금 비밀번호를 입력하세요';

  @override
  String get lockCurrentPromptSubtitle => '변경하거나 끄기 전에 확인하세요.';

  @override
  String get lockAutoLock => '자동 잠금';

  @override
  String get lockChangePassword => '잠금 해제 비밀번호 변경';

  @override
  String get lockClosePassword => '잠금 해제 비밀번호 끄기';

  @override
  String get lockWrongPassword => '비밀번호가 잘못되었습니다. 다시 시도해 보세요.';

  @override
  String get lockSixDigitsRequired => '잠금 비밀번호는 6자리여야 합니다.';

  @override
  String get lockInputTitle => '잠금 비밀번호를 입력하세요';

  @override
  String lockInputSubtitle(Object appName) {
    return '$appName을(를) 계속 사용하려면 잠금 해제하세요.';
  }

  @override
  String get lockSetFailed => '설정하지 못했습니다. 다시 시도해 보세요.';

  @override
  String get lockImmediately => '즉시';

  @override
  String get lockAfter5Minutes => '5분 후';

  @override
  String get lockAfter30Minutes => '30분 후';

  @override
  String get lockAfter1Hour => '1시간 후';

  @override
  String get deviceLoginProtection => '로그인 보호';

  @override
  String get deviceProtectionRemark =>
      '로그인 보호가 활성화되면 낯선 장치에 대한 보안 확인이 필요합니다. 계정 안전을 위해 권장됩니다.';

  @override
  String get deviceNone => '로그인된 장치가 없습니다.';

  @override
  String get deviceDebugName => '현재 장치';

  @override
  String get deviceDebugPlatform => 'iPhone/Android 디버그 장치';

  @override
  String get deviceProtectionEnabled => '로그인 보호 활성화됨';

  @override
  String get deviceProtectionDisabled => '로그인 보호가 비활성화되었습니다.';

  @override
  String get deviceProtectionUpdateFailed =>
      '로그인 보호를 업데이트하지 못했습니다. 다시 시도해 보세요.';

  @override
  String get blacklistEmpty => '블랙리스트에 있는 연락처가 없습니다.';

  @override
  String get switchAccountRecent => '최근 계정';

  @override
  String get switchAccountLoading => '최근 계정 읽기';

  @override
  String get switchAccountAddOther => '다른 계정 추가 또는 로그인';

  @override
  String get switchAccountCurrent => '현재';

  @override
  String get appModulesLoading => '기능 모듈 로드 중';

  @override
  String get appModulesEmpty => '기능 모듈 없음';

  @override
  String get appModulesUnavailable => '모듈을 사용할 수 없습니다.';

  @override
  String get errorLogsLoading => '오류 로그 읽기';

  @override
  String get errorLogsEmpty => '오류 로그 없음';

  @override
  String get errorLogFileName => '파일 이름';

  @override
  String get errorLogFileSize => '파일 크기';

  @override
  String get errorLogGeneratedAt => '생성 날짜';

  @override
  String get errorLogFilePath => '파일 경로';

  @override
  String get notificationReceiveNew => '새 메시지 알림 받기';

  @override
  String get notificationSound => '소리';

  @override
  String get notificationVibration => '진동';

  @override
  String get notificationShowDetails => '알림 세부정보 표시';

  @override
  String get notificationSystem => '시스템 메시지 알림';

  @override
  String get notificationCalls => '음성/영상 통화 알림';

  @override
  String get settingsGoToSystem => '설정';

  @override
  String aboutAppIconSemantic(Object appName) {
    return '$appName 아이콘';
  }

  @override
  String aboutCopyright(Object appName) {
    return '저작권 © 2026\n$appName. 모든 권리 보유.';
  }

  @override
  String get policyWebUrl => 'Web URL';

  @override
  String get appearanceTitle => '외관';

  @override
  String get appearanceAppIcon => '앱 아이콘';

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
  String get appearanceChatColor => '채팅 색상';

  @override
  String get appearanceBubbleRadius => '버블 코너 반경';

  @override
  String get appearanceBubbleColorInk => '잉크 블랙';

  @override
  String get appearanceSquare => '정사각형';

  @override
  String get appearanceRound => '라운드';

  @override
  String get appearancePreviewOne => '그는 내가 우회전하길 원하나요, 아니면 좌회전하길 원하나요? 🤔';

  @override
  String get appearancePreviewTwo => '그렇죠. 그리고, 강하게 만들어 보세요.';

  @override
  String get appearancePreviewThree => '그게 다인가요? 그 사람이 그보다 더 많은 말을 한 것 같아요. 😯';

  @override
  String get appearancePreviewFour => '그게 전부입니다. 자세한 내용은 나중에 음성 메시지로 보내드리겠습니다.';

  @override
  String get contactsEmptyTitle => '아직 연락처가 없습니다.';

  @override
  String get contactsEmptySubtitle => '오른쪽 상단에서 친구를 추가하거나 프로필 카드를 스캔하세요.';

  @override
  String contactsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 연락처',
      one: '연락처 1개',
    );
    return '$_temp0';
  }

  @override
  String get contactAddTooltip => '친구 추가';

  @override
  String get contactSearchHint => '연락처 및 그룹 검색';

  @override
  String get contactSetRemark => '비고 설정';

  @override
  String get contactAddToBlacklist => '블랙리스트에 추가';

  @override
  String get contactDeleteFriend => '친구 삭제';

  @override
  String get contactAddedToBlacklist => '블랙리스트에 추가됨';

  @override
  String get operationFailed => '작업이 실패했습니다. 다시 시도해 보세요.';

  @override
  String operationFailedWithError(String error) {
    return '작업 실패: $error';
  }

  @override
  String contactDeleteFriendConfirm(Object name) {
    return '친구 삭제 \"$name\"?\n채팅 기록도 삭제됩니다.';
  }

  @override
  String get contactConfirmDelete => '삭제 확인';

  @override
  String get contactDeleted => '친구가 삭제되었습니다.';

  @override
  String get contactUnknownUser => '알 수 없는 사용자';

  @override
  String get contactActionNewFriends => '새 친구';

  @override
  String get contactActionSavedGroups => '저장된 그룹';

  @override
  String get contactSearchNoMatches => '일치하는 연락처가 없습니다.';

  @override
  String get addFriendTitle => '친구 추가';

  @override
  String addFriendSearchHint(Object appName) {
    return '전화번호 / $appName ID';
  }

  @override
  String get addFriendNotFound => '계정을 찾을 수 없습니다';

  @override
  String get myQrCodeTitle => '내 QR 코드';

  @override
  String myQrCodeSubtitle(Object appName) {
    return '$appName에 나를 추가하려면 이 QR 코드를 스캔하세요.';
  }

  @override
  String get myQrCodeEmpty => 'QR 코드 없음';

  @override
  String get scanTitle => '스캔';

  @override
  String get scanQrNotFound => 'QR 코드가 인식되지 않습니다.';

  @override
  String scanResolveFailed(String error) {
    return 'QR 코드 구문 분석 실패: $error';
  }

  @override
  String get scanUnrecognized => '이 QR 코드를 인식할 수 없습니다.';

  @override
  String get scanInfoIncomplete => 'QR 코드 정보가 불완전합니다.';

  @override
  String get scanSocialUnavailable => '소셜 서비스가 초기화되지 않았습니다.';

  @override
  String get scanJoinedGroup => '그룹 채팅에 참여했습니다.';

  @override
  String get scanCannotOpenGroup => '이 페이지에서는 그룹 채팅을 열 수 없습니다.';

  @override
  String get scanGroupNotFound => '그룹 채팅을 찾을 수 없습니다.';

  @override
  String get scanOpenGroupFailed => '그룹 채팅을 열지 못했습니다.';

  @override
  String get scanSelfQr => '나만의 QR 코드입니다.';

  @override
  String get scanUserNotFound => '사용자를 찾을 수 없음';

  @override
  String get scanCameraPermissionRequired => '카메라 권한이 필요합니다';

  @override
  String get scanOpenSettings => '설정 열기';

  @override
  String get scanCameraUnavailable => '카메라를 사용할 수 없습니다.';

  @override
  String get scanAlbum => '앨범';

  @override
  String get scanLightOn => '불 켜짐';

  @override
  String get scanLightOff => '불 꺼짐';

  @override
  String get scanQrCode => 'QR 코드';

  @override
  String get scanGroupFallback => '그룹 채팅';

  @override
  String get scanGroupLoadingInfo => '그룹 정보 로드 중';

  @override
  String scanGroupMemberCount(int count) {
    return '$count 회원';
  }

  @override
  String get scanJoinGroupConfirm => '그룹 채팅에 참여';

  @override
  String get scanJoining => '가입 중';

  @override
  String get scanJoinGroup => '그룹 채팅에 참여';

  @override
  String scanJoinFailed(String error) {
    return '가입 실패: $error';
  }

  @override
  String get tagsTitle => '태그';

  @override
  String get tagsCreateTooltip => '새 태그';

  @override
  String get tagsContactSection => '연락처 태그';

  @override
  String get tagsEmptyTitle => '태그 없음';

  @override
  String get tagsEmptySubtitle => '연락처나 채팅을 그룹화하려면 오른쪽 상단의 +를 탭하세요.';

  @override
  String tagsCreateFailed(Object error) {
    return '태그 생성 실패: $error';
  }

  @override
  String tagsUpdateFailed(Object error) {
    return '태그 업데이트 실패: $error';
  }

  @override
  String tagsDeleteFailed(Object error) {
    return '태그 삭제 실패: $error';
  }

  @override
  String tagsLoadFailed(Object error) {
    return '태그를 로드하지 못했습니다: $error';
  }

  @override
  String tagsDeleteConfirm(String name) {
    return '태그 \"$name\"을 삭제하시겠습니까?\n이 태그의 연락처 및 그룹은 삭제되지 않습니다.';
  }

  @override
  String get tagsEditTitle => '태그 편집';

  @override
  String get tagsCreateTitle => '새 태그';

  @override
  String get tagsNameSection => '태그 이름';

  @override
  String get tagsNameHint => '가족, 친구';

  @override
  String tagsMembersSection(int count) {
    return '태그 멤버($count)';
  }

  @override
  String get tagsAddMember => '회원 추가';

  @override
  String get tagsDelete => '태그 삭제';

  @override
  String get tagsGroupInitial => 'G';

  @override
  String get tagsUnknownUser => '알 수 없는 사용자';

  @override
  String get tagsSelectMembersTitle => '회원 선택';

  @override
  String tagsDoneCount(int count) {
    return '완료($count)';
  }

  @override
  String get tagsSearchHint => '연락처 또는 그룹 검색';

  @override
  String get tagsGroupsSection => '그룹 채팅';

  @override
  String get tagsContactsSection => '연락처';

  @override
  String get tagsNoMatchesTitle => '일치하는 항목이 없습니다.';

  @override
  String get tagsNoMatchesSubtitle => '다른 키워드를 사용해 보세요';

  @override
  String tagsRowTitle(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get phoneContactsTitle => '전화 연락처';

  @override
  String get phoneContactsSection => '전화 연락처에서 추가';

  @override
  String get phoneContactsEmpty => '전화 연락처 없음';

  @override
  String get phoneContactsNoAddable => '추가할 전화 연락처가 없습니다.';

  @override
  String get phoneContactsServerSyncFailed => '서버 동기화에 실패했습니다. 기존 연락처를 표시합니다.';

  @override
  String get friendAlreadyAdded => '추가됨';

  @override
  String get friendRequestSent => '친구 요청이 전송되었습니다.';

  @override
  String phoneContactsInviteSmsBody(Object appName) {
    return '저는 $appName을(를) 사용하고 있습니다. 채팅 경험은 꽤 좋습니다. 여러분도 한번 시도해 보세요.';
  }

  @override
  String get phoneContactsInviteOpened => 'SMS 초대가 열렸습니다.';

  @override
  String get phoneContactsInviteFailed => 'SMS를 열 수 없습니다. 수동으로 초대해 주세요.';

  @override
  String get friendRequestsEmptyTitle => '새 친구가 없습니다';

  @override
  String get friendRequestsEmptySubtitle => '친구를 초대하여 QR 코드를 스캔하세요.';

  @override
  String get friendRequestsPendingSection => '보류 중';

  @override
  String get friendRequestRefused => '거부됨';

  @override
  String contactOpenFromContacts(Object name) {
    return '주소록에서 @$name님의 채팅을 엽니다.';
  }

  @override
  String get fileHelperIntro =>
      '웹 버전에 로그인하고 메시지를 보내 휴대전화와 컴퓨터 간에 텍스트, 사진, 오디오, 동영상, 파일을 전송할 수 있습니다.';

  @override
  String get fileHelperName => 'File Transfer';

  @override
  String get systemAccountName => 'System';

  @override
  String systemAccountIntro(Object appName) {
    return '알림 전송을 위한 공식 $appName 계정입니다.';
  }

  @override
  String get contactIntroTitle => '소개';

  @override
  String get contactSource => '출처';

  @override
  String get contactRemoveFriendRelation => '친구 삭제';

  @override
  String get contactRemoveFromBlacklist => '블랙리스트에서 제거';

  @override
  String get contactSendMessage => '메시지';

  @override
  String get contactAddToContacts => '연락처에 추가';

  @override
  String get contactRemoveFriendConfirm => '이 친구를 삭제하시겠습니까?';

  @override
  String contactNicknameLine(Object name) {
    return '닉네임: $name';
  }

  @override
  String get contactRemoveFromBlacklistConfirm => '블랙리스트에서 이 연락처를 제거하시겠습니까?';

  @override
  String get webLoginTitle => 'Web 로그인';

  @override
  String get webLoginConfirmTitle => '웹 로그인을 확인하시겠습니까?';

  @override
  String get webLoginConfirmBody =>
      '이렇게 하면 귀하의 계정이 현재 브라우저 또는 데스크톱 클라이언트에 로그인할 수 있습니다. 본인이 아닌 경우 취소를 탭하세요.';

  @override
  String get webLoginConfirmAction => '로그인 확인';

  @override
  String get webLoginConfirming => '확인 중...';

  @override
  String get webLoginConfirmed => 'Web 로그인이 확인되었습니다.';

  @override
  String webLoginConfirmFailed(Object error) {
    return '확인 실패: $error';
  }

  @override
  String get applyFriendTitle => '친구 요청';

  @override
  String get applyFriendSectionTitle => '친구 요청 보내기';

  @override
  String get applyFriendRemarkHint => '안녕하세요, 저는...';

  @override
  String friendRequestSendFailed(Object error) {
    return '전송 실패: $error';
  }

  @override
  String get contactRemarkHint => '비고';

  @override
  String get momentPermissionsTitle => '순간 개인정보 보호';

  @override
  String get momentHideMineFromContact => '내 순간을 그들로부터 숨기세요';

  @override
  String get momentHideContactFromMe => '그 순간을 나에게서 숨기세요';

  @override
  String get momentTitle => '순간';

  @override
  String get momentPersonalEmpty => '아직 게시물이 없습니다';

  @override
  String get momentEmpty => '아직 활동이 없습니다.';

  @override
  String get momentCoverUploadFailed => '표지를 업로드하지 못했습니다.';

  @override
  String momentCoverUploadFailedWithError(Object error) {
    return '표지 업로드 실패: $error';
  }

  @override
  String get momentDeleteConfirm => '이 순간을 삭제하시겠습니까?';

  @override
  String get momentJustNow => '방금';

  @override
  String get momentPublishing => 'Posting…';

  @override
  String get momentPublishFailed => 'Failed to post. Tap to dismiss.';

  @override
  String get momentRemindedYou => '이 순간을 보도록 알림';

  @override
  String momentRemindedNames(Object names) {
    return '알림 $names';
  }

  @override
  String get momentKeepEditingConfirm => '이 수정사항을 유지하시겠습니까?';

  @override
  String get momentContinueEditing => '계속 수정하세요';

  @override
  String get momentSaveDraft => '초안 저장';

  @override
  String get momentDiscardDraft => '삭제';

  @override
  String get momentPublishTitle => '게시물';

  @override
  String get momentPublishHint => '무슨 생각을 하고 계시나요...';

  @override
  String get momentLocationTitle => '위치';

  @override
  String get momentRemindWho => '알림';

  @override
  String get locationUnsupported => '이 버전에서는 위치를 사용할 수 없습니다.';

  @override
  String momentPrivacyContactCount(Object count, Object label) {
    return '$label · $count';
  }

  @override
  String get momentSelectVisibleContacts => '표시되는 연락처 선택';

  @override
  String get momentSelectHiddenContacts => '숨겨진 연락처 선택';

  @override
  String get momentPrivacyPublic => '공개';

  @override
  String get momentPrivacyPrivate => '비공개';

  @override
  String get momentPrivacyInternal => '일부에게 표시됨';

  @override
  String get momentPrivacyProhibit => '숨기기 대상';

  @override
  String get momentPrivacyWhoCanSee => '볼 수 있는 사람';

  @override
  String momentCommentFailed(Object error) {
    return '댓글 실패: $error';
  }

  @override
  String get momentDetailTitle => '세부정보';

  @override
  String get momentDeleted => '이 순간이 삭제되었습니다.';

  @override
  String get momentCollapse => '접기';

  @override
  String get momentFullText => '전문';

  @override
  String get momentDeleteCommentConfirm => '이 댓글을 삭제하시겠습니까?';

  @override
  String get momentCommentPlaceholder => '댓글';

  @override
  String momentReplyPlaceholder(Object name) {
    return '답글 $name';
  }

  @override
  String get momentLikeAction => '좋아요';

  @override
  String get momentCommentAction => '댓글';

  @override
  String momentNewMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 새 메시지',
      one: '새 메시지 1개',
    );
    return '$_temp0';
  }

  @override
  String get messagesTitle => '메시지';

  @override
  String get messagesEmpty => '메시지 없음';

  @override
  String get messagesEmptyTitle => '아직 메시지가 없습니다';

  @override
  String get messagesEmptySubtitle => '오른쪽 상단에서 새 채팅을 시작하세요';

  @override
  String get messagesNewConversation => '신규';

  @override
  String get messagesStartGroupChat => '그룹 채팅 시작';

  @override
  String get messagesImDisconnected => 'IM이 연결되지 않았습니다.';

  @override
  String get messagesPinned => '고정됨';

  @override
  String get messagesUnpinned => '고정 해제됨';

  @override
  String get messagesMuted => '음소거됨';

  @override
  String get messagesNotificationsOn => '알림 대상';

  @override
  String messagesDeleteConversationTitle(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get messagesConfirmDelete => '삭제';

  @override
  String get messagesCleared => '채팅 기록이 삭제되었습니다.';

  @override
  String get messagesConversationDeleted => '대화가 삭제되었습니다.';

  @override
  String get messagesUnknownUser => '알 수 없는 사용자';

  @override
  String get messagesFriendAvatarFallback => 'F';

  @override
  String get messagesGroupFallback => '그룹 채팅';

  @override
  String get messagesGroupAvatarFallback => 'G';

  @override
  String get messagesNewMessageDigest => '[새 메시지]';

  @override
  String get messagesConversationPin => '핀';

  @override
  String get messagesConversationUnpin => '고정 해제';

  @override
  String get messagesConversationMute => '음소거';

  @override
  String get messagesConversationUnmute => '음소거 해제';

  @override
  String get messagesConnectionNoNetwork => '네트워크를 사용할 수 없습니다. 연결을 확인하세요.';

  @override
  String get messagesConnectionDisconnected => '연결이 끊어졌습니다.';

  @override
  String get messagesConnectionConnecting => '연결 중';

  @override
  String get messagesConnectionSyncing => '동기화 중';

  @override
  String get globalSearchTitle => '검색';

  @override
  String get globalSearchTabChats => '채팅';

  @override
  String get globalSearchTabContacts => '연락처';

  @override
  String get globalSearchTabGroups => '그룹';

  @override
  String get globalSearchTabFiles => '파일';

  @override
  String get globalSearchContactsSection => '연락처';

  @override
  String get globalSearchGroupsSection => '그룹 채팅';

  @override
  String get globalSearchMessagesSection => '채팅 기록';

  @override
  String get globalSearchFilesSection => '파일';

  @override
  String get globalSearchNoMatches => '일치하는 항목이 없습니다.';

  @override
  String get globalSearchNoMore => '더 이상 결과가 없습니다.';

  @override
  String get locationLocating => '찾는 중...';

  @override
  String locationPermissionOff(Object appName) {
    return '위치 권한이 꺼져 있습니다. $appName이(가) 시스템 설정에서 위치를 사용하도록 허용하세요.';
  }

  @override
  String get locationPermissionDenied => '위치 권한이 거부되었습니다. 주변 장소를 로드할 수 없습니다.';

  @override
  String get locationMapUnsupported => 'AMap은(는) 이 플랫폼에서 지원되지 않습니다.';

  @override
  String locationFailed(String error) {
    return '위치 실패: $error';
  }

  @override
  String get locationSearchPrompt => '주변 장소를 검색하려면 키워드를 입력하세요.';

  @override
  String get locationNoNearbyPoi => '근처 POI 없음';

  @override
  String get locationSearchHint => '주변 장소 검색';

  @override
  String get locationPickerTitle => '위치';

  @override
  String get locationSending => '보내는 중';

  @override
  String get locationUnnamed => '이름 없는 장소';

  @override
  String get locationCopiedAddress => '주소 복사됨';

  @override
  String get locationNoMapApp => '사용 가능한 지도 앱이 없습니다.';

  @override
  String get locationFallbackTitle => '위치';

  @override
  String get locationAmap => 'AMap';

  @override
  String get locationBaiduMap => '바이두 지도';

  @override
  String get locationTencentMap => '텐센트 지도';

  @override
  String get locationAppleMap => 'Apple 지도';

  @override
  String get locationOtherMap => '기타 지도';

  @override
  String get locationMyLocation => '내 위치';

  @override
  String locationOpenMapFailed(String name) {
    return '$name을(를) 열 수 없습니다.';
  }

  @override
  String get locationCopyAddress => '주소 복사';

  @override
  String get locationNavigate => '탐색';

  @override
  String get locationViewTitle => '지도';

  @override
  String get momentPeerCommentDeleted => '댓글이 삭제되었습니다.';

  @override
  String get momentDigest => '[순간]';

  @override
  String get actionClose => '닫기';

  @override
  String get saveToAlbum => '앨범에 저장';

  @override
  String get savedToAlbum => '앨범에 저장됨';

  @override
  String get saveFailed => '저장 실패';

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
    return '$count 사진';
  }

  @override
  String get momentReplyConnector => '님이 답변했습니다.';

  @override
  String get groupRemarkTitle => '그룹 비고';

  @override
  String get groupRemarkHint => '나만 볼 수 있는 그룹 댓글 설정';

  @override
  String get chatNotificationSettingsTitle => '메시지 알림';

  @override
  String get chatScreenshotNotification => '스크린샷 알림';

  @override
  String get chatRevokeNotification => '리콜 알림';

  @override
  String get completeProfileTitle => '프로필 작성';

  @override
  String get completeProfileUploadAvatar => '아바타 업로드';

  @override
  String get completeProfileReuploadAvatar => '새 아바타 업로드';

  @override
  String get completeProfileChooseAvatar => '프로필 사진을 선택하세요';

  @override
  String get completeProfileAvatarUploaded => '아바타 업로드됨';

  @override
  String get completeProfileAvatarRequired => '아바타가 필요합니다.';

  @override
  String get nicknameLabel => '닉네임';

  @override
  String get nicknameInputHint => '닉네임을 입력하세요';

  @override
  String get nicknameRequired => '닉네임이 필요합니다.';

  @override
  String get completeProfileSaved => '프로필이 완료되었습니다.';

  @override
  String get chatSettingsTitle => '채팅 세부정보';

  @override
  String chatSettingsGroupTitle(Object count) {
    return '채팅 정보($count)';
  }

  @override
  String get chatSettingsGroupName => '그룹 채팅 이름';

  @override
  String get chatSettingsGroupQrCode => '그룹 QR 코드';

  @override
  String get chatSearchContentTitle => '채팅 검색';

  @override
  String get chatSettingsBackground => '채팅 배경 설정';

  @override
  String get chatSettingsBackgroundSelected => '현재 채팅 배경 설정';

  @override
  String get chatSettingsMute => '알림 음소거';

  @override
  String get chatSettingsPin => '핀 채팅';

  @override
  String get chatSettingsSaveToContacts => '연락처에 저장';

  @override
  String get chatSettingsReadReceipt => '읽음 확인';

  @override
  String get chatSettingsReadReceiptSubtitle =>
      '활성화되면 보낸 메시지에 읽음/읽지 않음 상태가 표시됩니다.';

  @override
  String get chatSettingsFlame => '읽은 후 굽기';

  @override
  String get chatFlameTipExit => '읽은 메시지는 채팅 종료 후 폐기됩니다.';

  @override
  String chatFlameTipMinutes(Object minutes) {
    return '메시지는 읽은 후 $minutes분 후에 폐기됩니다.';
  }

  @override
  String chatFlameTipSeconds(Object seconds) {
    return '메시지는 읽은 후 $seconds초 후에 폐기됩니다.';
  }

  @override
  String chatFlameLabelMinutes(Object minutes) {
    return '$minutes분';
  }

  @override
  String chatFlameLabelSeconds(Object seconds) {
    return '${seconds}s';
  }

  @override
  String get chatSettingsGroupNickname => '내 그룹 닉네임';

  @override
  String get chatSettingsBlacklisted => '블랙리스트에 등록됨';

  @override
  String get chatSettingsPeerBlacklisted => '이 연락처는 이미 블랙리스트에 등록되어 있습니다.';

  @override
  String get chatSettingsComplaint => '신고';

  @override
  String get chatSettingsDeleteAndExit => '삭제 및 종료';

  @override
  String groupRemarkSyncFailed(Object error) {
    return '그룹 설명을 동기화하지 못했습니다: $error';
  }

  @override
  String get chatSocialDisconnected => '소셜 서비스가 연결되지 않았습니다.';

  @override
  String get chatNoRemovableMembers => '제거 가능한 멤버 없음';

  @override
  String get chatSelectMembersToRemove => '제거할 구성원 선택';

  @override
  String chatMemberNameQuoted(Object name) {
    return '\"$name\"';
  }

  @override
  String chatMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 회원',
      one: '회원 1명',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersConfirm(Object names) {
    return '그룹에서 $names 제거';
  }

  @override
  String chatMembersRemoved(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 회원을 삭제했습니다.',
      one: '회원 1명 삭제됨',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersFailed(Object error) {
    return '구성원 제거 실패: $error';
  }

  @override
  String get chatNoInviteCandidates => '초대할 수 있는 연락처가 없습니다.';

  @override
  String get chatInviteMembers => '회원 초대';

  @override
  String get chatSelectContacts => '연락처 선택';

  @override
  String chatMembersInvited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 회원을 초대했습니다.',
      one: '회원 1명을 초대했습니다.',
    );
    return '$_temp0';
  }

  @override
  String chatInviteMembersFailed(Object error) {
    return '회원 초대 실패: $error';
  }

  @override
  String get chatGroupCreated => '그룹 채팅이 생성되었습니다. 채팅 목록을 확인하세요.';

  @override
  String get chatGroupCreateFailed => '그룹 채팅을 생성하지 못했습니다.';

  @override
  String chatGroupCreateFailedWithError(Object error) {
    return '그룹 채팅을 생성하지 못했습니다: $error';
  }

  @override
  String get chatClearCurrentConfirm => '현재 채팅 기록을 삭제하시겠습니까?';

  @override
  String get chatDeleteAndExitConfirm =>
      '삭제하고 탈퇴한 후에는 더 이상 이 그룹으로부터 메시지를 받지 않습니다.';

  @override
  String get chatBlockConfirm => '이 연락처를 블랙리스트에 추가하면 더 이상 해당 메시지를 받을 수 없습니다.';

  @override
  String get chatSearchTabAll => '채팅';

  @override
  String get chatSearchTabMedia => '사진/비디오';

  @override
  String get chatSearchTabFile => '파일';

  @override
  String get chatSearchNoMatches => '일치하는 채팅 기록이 없습니다.';

  @override
  String get chatSearchNoMore => '더 이상 결과가 없습니다.';

  @override
  String get chatDetailsTooltip => '채팅 세부정보';

  @override
  String get chatVoiceInputTooltip => '음성 입력';

  @override
  String get chatInputHint => '메시지...';

  @override
  String get chatFlameEnabledTooltip => '읽은 후 굽기';

  @override
  String get chatFlameDestroyOnExit => '채팅 종료 후 폐기';

  @override
  String chatFlameDestroyAfterMinutes(Object minutes) {
    return '$minutes분 후 폐기';
  }

  @override
  String chatFlameDestroyAfterSeconds(Object seconds) {
    return '$seconds초 후 폐기';
  }

  @override
  String chatFlameEnabledNotice(Object label) {
    return '읽기가 켜진 후 굽습니다. 메시지는 읽은 후 $label 폐기됩니다. 끄려면 오른쪽 상단 설정을 사용하세요.';
  }

  @override
  String get chatEmojiTooltip => '이모티콘';

  @override
  String get chatActionReply => '답글';

  @override
  String get chatActionCopy => '복사';

  @override
  String get chatActionTranslate => '번역';

  @override
  String get chatActionTranscribe => '기록';

  @override
  String get chatActionForward => '전달';

  @override
  String get chatActionFavorite => '즐겨찾기';

  @override
  String get chatActionPin => '핀';

  @override
  String get chatActionUnpin => '고정 해제';

  @override
  String get chatActionAddFriend => '친구 추가';

  @override
  String get chatActionMultiSelect => '선택';

  @override
  String get chatActionEdit => '편집';

  @override
  String get chatActionEditImage => '이미지 편집';

  @override
  String get chatActionRevoke => '회상';

  @override
  String get chatActionDelete => '삭제';

  @override
  String get chatGroupCallActive => '그룹 통화 진행 중';

  @override
  String chatMessageRevokedBy(Object name) {
    return '$name이(가) 메시지를 회수했습니다.';
  }

  @override
  String get chatReedit => '재수정';

  @override
  String get chatEditedSuffix => '(수정됨)';

  @override
  String chatActionReadBy(Object count) {
    return '$count이(가) 읽음';
  }

  @override
  String chatActionReactedBy(Object count) {
    return '$count 반응';
  }

  @override
  String chatSelectedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '선택한 $count 항목',
      one: '1개 항목을 선택했습니다.',
    );
    return '$_temp0';
  }

  @override
  String get chatNoReactions => '아직 반응이 없습니다';

  @override
  String chatReadStatusReadCount(Object count) {
    return '읽기($count)';
  }

  @override
  String get chatNoReadReceipts => '아직 없음';

  @override
  String get chatHistoryAbove => '위의 이전 메시지';

  @override
  String chatUnreadNewMessages(Object count) {
    return '$count 새 메시지';
  }

  @override
  String get chatUnreadDivider => '아래 새 메시지';

  @override
  String get chatUnknownContentFallback =>
      '이 버전에서는 이 메시지를 표시할 수 없습니다. 최신 버전으로 업데이트하세요.';

  @override
  String get chatMentionSomeone => '누군가가 당신을 언급했습니다.';

  @override
  String get chatToolAlbum => '앨범';

  @override
  String get chatToolCamera => '카메라';

  @override
  String get chatToolFile => '파일';

  @override
  String get chatToolLocation => '위치';

  @override
  String get chatToolContactCard => '연락처 카드';

  @override
  String get chatToolAudioCall => '음성 통화';

  @override
  String get chatToolVideoCall => '영상 통화';

  @override
  String get chatDraftLabel => '[초안]';

  @override
  String get visitorBadge => '방문자';

  @override
  String get chatNoticeDeleted => '삭제됨';

  @override
  String get chatNoticeCopied => '복사됨';

  @override
  String get chatMentionLoadedOrInvisible =>
      '@ 메시지가 로드되었거나 표시되지 않습니다. 위로 스크롤하여 찾으세요.';

  @override
  String get chatLocationDefaultTitle => '위치';

  @override
  String get chatLocationCopied => '위치가 복사되었습니다.';

  @override
  String get chatReadStatusTitle => '읽기 상태';

  @override
  String get chatReadStatusRead => '읽기';

  @override
  String get chatReadStatusUnread => '읽지 않음';

  @override
  String get chatReadStatusUnavailable => '전체 읽음/읽지 않음 목록은 아직 사용할 수 없습니다.';

  @override
  String get chatComposerLeft => '이 채팅에서 나갔습니다.';

  @override
  String get chatComposerMuted => '이 채팅은 음소거되었습니다.';

  @override
  String chatComposerMutedUntil(Object time) {
    return '$time까지 음소거됩니다.';
  }

  @override
  String chatFavoriteCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '즐겨찾기에 추가된 $count 메시지',
      one: '즐겨찾기에 추가된 메시지 1개',
    );
    return '$_temp0';
  }

  @override
  String chatFavoritePartial(Object failed, Object success) {
    return '즐겨찾기 완료: $success 성공, $failed 실패';
  }

  @override
  String get chatForwardUnavailable => '지금은 전달할 수 없습니다.';

  @override
  String chatMergedForwardedTo(Object count, Object name) {
    return '$count 메시지를 $name에 병합했습니다.';
  }

  @override
  String chatForwardedIndividuallyTo(Object count, Object name) {
    return '$count 메시지를 하나씩 $name에 전달했습니다.';
  }

  @override
  String chatForwardedPartialTo(Object name, Object sent, Object total) {
    return '$sent/$total 메시지를 $name로 전달했습니다.';
  }

  @override
  String get chatForwardModeIndividual => '하나씩 전달';

  @override
  String get chatForwardModeMerge => '병합 및 전달';

  @override
  String get chatPresenceOnline => '온라인';

  @override
  String get chatPresenceOffline => '오프라인';

  @override
  String get chatPresenceJustActive => '현재 활성 상태';

  @override
  String chatPresenceMinutesAgo(Object minutes) {
    return '활성 $minutes분 전';
  }

  @override
  String chatPresenceHoursAgo(Object hours) {
    return '활성 $hours시간 전';
  }

  @override
  String chatPresenceDaysAgo(Object days) {
    return '활성 $days일 전';
  }

  @override
  String get chatSensitiveDefaultTip => '이 메시지에는 민감한 정보가 포함되어 있을 수 있습니다.';

  @override
  String get chatMessageDigestFallback => '[메시지]';

  @override
  String get chatMediaServiceUnavailable => '미디어 서비스가 준비되지 않았습니다.';

  @override
  String get chatImDisconnected => 'IM이 연결되지 않았습니다.';

  @override
  String get chatPinFailedNotSent => '메시지가 서버에 도달하기 전에 고정할 수 없습니다.';

  @override
  String get chatPinFailed => '고정하지 못했습니다. 다시 시도해 보세요.';

  @override
  String get chatPinned => '고정됨';

  @override
  String get chatUnpinFailed => '고정 해제에 실패했습니다. 다시 시도해 보세요.';

  @override
  String get chatUnpinned => '고정 해제됨';

  @override
  String get chatClearPinnedConfirm => '고정된 메시지를 모두 고정 해제하시겠습니까?';

  @override
  String get chatClearPinnedAction => '고정 해제';

  @override
  String get chatAllUnpinned => '고정된 모든 메시지가 고정 해제되었습니다.';

  @override
  String get chatPinnedMessageNotVisible => '이 메시지는 가시 범위에 없습니다. 목록에서 봅니다.';

  @override
  String get chatImageMissing => '이미지 정보가 누락되었습니다.';

  @override
  String get chatImageDownloadFailedEdit => '이미지를 다운로드하지 못했습니다. 편집할 수 없습니다.';

  @override
  String get chatReactionFailed => '반응이 실패했습니다. 다시 시도해 보세요.';

  @override
  String get chatEditNotSynced => '편집 실패: 메시지가 동기화되지 않았습니다.';

  @override
  String get chatEditFailed => '편집에 실패했습니다. 다시 시도해 보세요.';

  @override
  String get chatFavoriteUnsupportedType => '이 유형은 아직 즐겨찾기에 추가할 수 없습니다.';

  @override
  String get chatFavoriteNotSent => '메시지가 서버에 도달하지 않았으므로 즐겨찾기에 추가할 수 없습니다.';

  @override
  String get chatFavoriteSuccess => '즐겨찾기에 추가됨';

  @override
  String get chatFavoriteFailed => '즐겨찾기에 실패했습니다. 다시 시도해 보세요.';

  @override
  String chatToolSelected(Object title) {
    return '선택됨 $title';
  }

  @override
  String chatCardDigest(Object name) {
    return '[카드] $name';
  }

  @override
  String get chatFriendAvatarFallback => 'F';

  @override
  String get chatUnknownMessageDigest => '[알 수 없음]';

  @override
  String chatOpenFromContacts(Object name) {
    return '주소록에서 @$name님의 채팅을 엽니다.';
  }

  @override
  String get chatLoadingCard => '연락처 카드 로드 중...';

  @override
  String get chatFileMissing => '파일 정보가 누락되었습니다.';

  @override
  String get chatVideoUnavailable => '동영상을 재생할 수 없습니다.';

  @override
  String get chatVideoSourceEmpty => '비디오 소스가 비어 있습니다.';

  @override
  String get chatLivePhotoUnavailable => 'Live Photo를 재생할 수 없습니다.';

  @override
  String get messageAiTranslating => '번역 중...';

  @override
  String get messageAiTranscribedShort => '완료';

  @override
  String get messageAiVoiceSendingWait => '음성이 아직 전송 중입니다. 나중에 다시 시도하세요.';

  @override
  String get messageAiNoTranscript => '음성이 인식되지 않습니다.';

  @override
  String get messageAiMessageSendingWait => '메시지가 아직 전송 중입니다. 나중에 다시 시도하세요.';

  @override
  String get messageAiNoTranslation => '번역 결과가 없습니다.';

  @override
  String get messageAiTemporarilyUnavailable => '일시적으로 사용할 수 없습니다.';

  @override
  String get chatVoiceFileUnavailable => '음성 파일을 사용할 수 없습니다.';

  @override
  String get chatVoicePlayFailed => '재생에 실패했습니다. 다시 시도해 보세요.';

  @override
  String get chatVoiceHoldToRecord => '기록하려면 길게 누르세요. 취소하려면 위로 슬라이드하세요.';

  @override
  String chatVoiceReleaseToCancel(Object duration) {
    return '취소하려면 취소하세요($duration)';
  }

  @override
  String chatVoiceRecordingSlideCancel(Object duration) {
    return '$duration · 취소하려면 위로 슬라이드하세요.';
  }

  @override
  String get chatQrcodeNotFound => 'QR 코드가 인식되지 않습니다.';

  @override
  String chatWebLoginQrcodeDetected(Object payload) {
    return 'Web 로그인 QR 코드가 인식되었습니다\n$payload';
  }

  @override
  String get chatWebLoginConfirmTitle => '웹에서 로그인을 확인하시겠습니까?';

  @override
  String get chatWebLoginConfirmAction => 'Web 로그인 확인';

  @override
  String get chatWebLoginConfirmed => 'Web 로그인이 확인되었습니다.';

  @override
  String chatQrcodeDetected(Object payload) {
    return 'QR 코드가 인식되었습니다\n$payload';
  }

  @override
  String get chatStickerPlaceholder => '[스티커]';

  @override
  String get chatStickerAdded => '스티커에 추가됨';

  @override
  String get chatStickerAddFailed => '스티커를 추가하지 못했습니다. 다시 시도해 보세요.';

  @override
  String get mentionAllMembers => '모든 회원';

  @override
  String get mentionAllMembersSubtitle => '이 그룹의 모든 사람에게 알림';

  @override
  String get chatQuoteOriginalRevoked => '원본 메시지가 회수되었습니다.';

  @override
  String get chatRecognizeImageQrcode => '이미지의 QR 코드 스캔';

  @override
  String get chatAddToStickers => '스티커에 추가';

  @override
  String get chatGroupInviteApprovalUrlEmpty => '그룹 초대 승인 URL이 비어 있습니다.';

  @override
  String get chatGroupInviteApprovalTitle => '그룹 초대 승인';

  @override
  String get chatGroupInviteApprovalBody => '웹페이지에서 그룹 초대 확인을 완료하세요.';

  @override
  String get chatGroupInviteGoConfirm => '확인';

  @override
  String get chatGroupInviteApprovalOpenFailed =>
      '그룹 초대 승인을 열지 못했습니다. 다시 시도해 보세요.';

  @override
  String get chatSendFailed => '전송에 실패했습니다. 다시 시도해 보세요.';

  @override
  String get chatCallActiveHangupFirst => '통화가 진행 중입니다. 먼저 끊으세요.';

  @override
  String get chatCallActiveCannotJoinAgain => '통화가 진행 중입니다. 다시 가입할 수 없습니다.';

  @override
  String get chatCallUnsupported => '이 버전에서는 통화가 지원되지 않습니다.';

  @override
  String get chatCallServiceUnavailable => '통화 서비스가 준비되지 않았습니다.';

  @override
  String get chatCallJoinFailedEnded => '가입하지 못했습니다. 통화가 종료되었을 수 있습니다.';

  @override
  String get callWaitingAnswer => '답변을 기다리는 중';

  @override
  String get callMessage => '전화 메시지';

  @override
  String get callEnded => '통화가 종료되었습니다.';

  @override
  String get callPeerRefused => '상대방이 거부했습니다.';

  @override
  String get callPeerHungUp => '상대방이 전화를 끊었습니다.';

  @override
  String get callPeerDeclinedVideoSwitch => '피어가 비디오 전환 요청을 거부했습니다.';

  @override
  String get callSwitchVideoRequestTitle => '동료가 비디오로 전환을 요청합니다.';

  @override
  String get callAgree => '동의함';

  @override
  String get callReconnecting => '다시 연결하는 중…';

  @override
  String get callWaitingPeerCamera => '피어 카메라를 기다리는 중';

  @override
  String get callSelfFallbackName => '나';

  @override
  String get callUnknownUser => '알 수 없는 사용자';

  @override
  String callJoinedCount(int joined, int total) {
    return '$joined/$total 가입됨';
  }

  @override
  String get callMute => '음소거';

  @override
  String get callSpeaker => '스피커';

  @override
  String get callSwitchToVideo => '비디오';

  @override
  String get callHangup => '전화 끊기';

  @override
  String get callFlipCamera => '뒤집기';

  @override
  String get callSwitchToVoice => '오디오';

  @override
  String get callCamera => '카메라';

  @override
  String get callBack => '뒤로';

  @override
  String get callPermissionMicrophone => '마이크';

  @override
  String get callPermissionMicrophoneCamera => '마이크 및 카메라';

  @override
  String callPermissionOpenSettings(String what) {
    return '시스템 설정에서 $what 권한을 활성화하세요.';
  }

  @override
  String callPermissionRequired(String what) {
    return '통화에는 $what 권한이 필요합니다.';
  }

  @override
  String get callWaitingPeerConsent => '동료 승인을 기다리는 중';

  @override
  String get callSwitchRequestFailed => '전환 요청을 보내지 못했습니다.';

  @override
  String get callCameraPermissionRequired => '카메라 권한이 필요합니다';

  @override
  String get callCameraEnableFailed => '카메라를 켜지 못했습니다.';

  @override
  String get incomingCallAccepting => '답변 중...';

  @override
  String get incomingVideoCall => '님이 귀하를 화상 통화에 초대했습니다.';

  @override
  String get incomingAudioCall => '님이 귀하를 음성 통화에 초대했습니다.';

  @override
  String incomingAcceptFailed(String error) {
    return '답변 실패: $error';
  }

  @override
  String get incomingCallDecline => '거절';

  @override
  String get incomingCallAccept => '답변';

  @override
  String get chatGroupNoInviteCandidates => '초대할 수 있는 회원이 없습니다.';

  @override
  String get chatInviteGroupMembersVideo => '그룹 구성원 초대(영상 통화)';

  @override
  String get chatInviteGroupMembersAudio => '그룹 구성원 초대(음성통화)';

  @override
  String get chatSelfName => '나';

  @override
  String get chatPeerPlaceholder => '기타';

  @override
  String get chatSomeonePlaceholder => '누군가';

  @override
  String chatScreenshotNotice(Object name) {
    return '$name이(가) 채팅에서 스크린샷을 찍었습니다.';
  }

  @override
  String chatDuplicateGroupMention(Object name) {
    return '여러 그룹 구성원이 @$name과(와) 일치합니다.';
  }

  @override
  String chatDuplicateContactMention(Object name) {
    return '여러 연락처가 @$name과(와) 일치합니다.';
  }

  @override
  String chatMentionNotFound(Object name) {
    return '@$name 찾을 수 없음';
  }

  @override
  String get chatForwardPickerTitle => '전달 대상';

  @override
  String get chatRecentContactsSection => '최근 연락처';

  @override
  String chatForwardedTo(Object name) {
    return '$name(으)로 전달됨';
  }

  @override
  String get favoriteTitle => '즐겨찾기';

  @override
  String get favoriteEmptyTitle => '즐겨찾기 없음';

  @override
  String get favoriteEmptySubtitle => '채팅에서 메시지를 길게 누르고 즐겨찾기를 선택하여 여기에 저장하세요.';

  @override
  String get favoriteDeleted => '삭제됨';

  @override
  String favoriteDeleteFailed(Object error) {
    return '삭제 실패: $error';
  }

  @override
  String get favoriteDeleteFailedPlain => '삭제 실패';

  @override
  String get favoriteUnsupportedSend => '이 유형은 아직 보낼 수 없습니다.';

  @override
  String favoriteSentTo(String name) {
    return '$name(으)로 전송됨';
  }

  @override
  String favoriteSendFailed(Object error) {
    return '보내기 실패: $error';
  }

  @override
  String get favoriteSendFailedPlain => '보내기 실패';

  @override
  String get favoriteSendToFriend => '친구에게 보내기';

  @override
  String get favoriteCopied => '복사됨';

  @override
  String get favoriteUnknownUser => '알 수 없는 사용자';

  @override
  String favoriteDateMonthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String get groupSavedTitle => '저장된 그룹';

  @override
  String get groupSaveTooltip => '그룹 저장';

  @override
  String get groupSearchHint => '검색 그룹';

  @override
  String get groupNoMatched => '일치하는 그룹이 없습니다.';

  @override
  String get groupNoSaveCandidatesToast => '저장할 수 있는 그룹이 없습니다.';

  @override
  String get groupSavedToContacts => '연락처에 저장됨';

  @override
  String groupSaveFailed(Object error) {
    return '저장 실패: $error';
  }

  @override
  String get groupSelectTitle => '그룹 선택';

  @override
  String get groupNoSaveCandidates => '저장할 수 있는 그룹이 없습니다.';

  @override
  String get groupCreateTitle => '그룹 채팅 시작';

  @override
  String get groupSearchContactsHint => '연락처 검색';

  @override
  String get groupNoMatchedContacts => '일치하는 연락처가 없습니다.';

  @override
  String groupMemberSummary(num count, Object subtitle) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 회원',
      one: '회원 1명',
    );
    return '$_temp0· $subtitle';
  }

  @override
  String get groupMuted => '음소거됨';

  @override
  String get groupDetailsTitle => '그룹 세부정보';

  @override
  String groupMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 회원',
      one: '회원 1명',
    );
    return '$_temp0';
  }

  @override
  String get groupMembersSection => '그룹 구성원';

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
  String get groupNoMembers => '그룹 구성원 없음';

  @override
  String get groupInviteMembers => '회원 초대';

  @override
  String get groupInviteMembersSubtitle => '연락처에서 선택';

  @override
  String get groupRemoveMembers => '회원 제거';

  @override
  String get groupRemoveMembersEmptySubtitle => '제거할 구성원이 없습니다.';

  @override
  String get groupRemoveMembersSubtitle => '제거할 구성원을 선택하세요.';

  @override
  String get groupQrCodeTitle => '그룹 QR 코드';

  @override
  String get groupQrCodeSubtitle => '이 그룹에 가입하려면 스캔하세요.';

  @override
  String get groupNameTitle => '그룹 이름';

  @override
  String get groupNoticeTitle => '그룹 공지';

  @override
  String get groupNoticeUnset => '설정되지 않음';

  @override
  String get groupManageTitle => '그룹 관리';

  @override
  String get groupManageSubtitle => '관리자, 음소거 및 그룹 권한';

  @override
  String get groupInviteConfirm => '초대 확인';

  @override
  String get groupBlacklistTitle => '그룹 블랙리스트';

  @override
  String get groupBlacklistSubtitle => '발언 또는 참여가 차단된 회원 관리';

  @override
  String get groupSaveToContacts => '연락처에 저장';

  @override
  String get groupMuteMessages => '알림 음소거';

  @override
  String get groupExited => '왼쪽 그룹 채팅';

  @override
  String get groupExitAction => '그룹 탈퇴';

  @override
  String groupMembersSyncFailed(Object error) {
    return '그룹 구성원을 동기화하지 못했습니다: $error';
  }

  @override
  String get groupInvitePickerTitle => '초대할 구성원 선택';

  @override
  String groupInviteSentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 회원 초대장을 보냈습니다.',
      one: '회원 1명에게 초대장을 보냈습니다.',
    );
    return '$_temp0';
  }

  @override
  String groupInvitedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 회원을 초대했습니다.',
      one: '회원 1명을 초대했습니다.',
    );
    return '$_temp0';
  }

  @override
  String groupInviteMembersFailed(Object error) {
    return '회원 초대 실패: $error';
  }

  @override
  String get groupRemovePickerTitle => '제거할 구성원 선택';

  @override
  String groupQuotedMemberName(Object name) {
    return '\"$name\"';
  }

  @override
  String groupSelectedMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 회원',
      one: '회원 1명',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersConfirm(Object target) {
    return '이 그룹에서 $target을(를) 제거하시겠습니까?';
  }

  @override
  String get groupRemoveAction => '제거';

  @override
  String groupRemovedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 회원을 삭제했습니다.',
      one: '회원 1명 삭제됨',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersFailed(Object error) {
    return '구성원 제거 실패: $error';
  }

  @override
  String get groupSettingsUpdated => '그룹 설정이 업데이트되었습니다.';

  @override
  String groupSettingsUpdateFailed(Object error) {
    return '그룹 설정을 업데이트하지 못했습니다: $error';
  }

  @override
  String get groupExitConfirm => '탈퇴 후에는 더 이상 이 그룹으로부터 메시지를 받지 않습니다.';

  @override
  String get groupExitSuccess => '왼쪽 그룹 채팅';

  @override
  String groupExitFailed(Object error) {
    return '떠나지 못했습니다: $error';
  }

  @override
  String get groupOwnerAdminSection => '소유자 및 관리자';

  @override
  String get groupOwnerRole => '소유자';

  @override
  String get groupAdminRole => '관리자';

  @override
  String get groupRemove => '제거';

  @override
  String get groupAddAdmin => '그룹 관리자 추가';

  @override
  String get groupNoAdmins => '관리자 없음';

  @override
  String get groupInviteConfirmRemark =>
      '활성화되면 회원은 친구를 초대하기 전에 소유자 또는 관리자 승인이 필요합니다. QR 코드를 통한 참여도 비활성화됩니다.';

  @override
  String get groupOwnerTransfer => '소유권 이전';

  @override
  String get groupMemberSettingsSection => '회원 설정';

  @override
  String get groupAllMutedRemark => '모든 구성원 음소거가 활성화되면 소유자와 관리자만 말할 수 있습니다.';

  @override
  String get groupAllMuted => '모든 회원 음소거';

  @override
  String get groupForbiddenAddFriendRemark =>
      '활성화되면 회원은 이 그룹을 통해 친구를 추가할 수 없습니다.';

  @override
  String get groupForbiddenAddFriend => '회원의 친구 추가 차단';

  @override
  String get groupAllowHistoryRemark => '활성화되면 새 회원은 이전 채팅 기록을 볼 수 있습니다.';

  @override
  String get groupAllowHistory => '신규 회원이 기록을 볼 수 있도록 허용';

  @override
  String get groupAddAdminPickerTitle => '그룹 관리자 추가';

  @override
  String groupAdminAddedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 관리자를 추가했습니다.',
      one: '관리자 1명 추가됨',
    );
    return '$_temp0';
  }

  @override
  String groupAddAdminFailed(Object error) {
    return '관리자 추가 실패: $error';
  }

  @override
  String groupRemoveAdminConfirm(Object name) {
    return '\"$name\"에서 관리자 역할을 제거하시겠습니까?';
  }

  @override
  String get groupRemoveAdminAction => '관리자 제거';

  @override
  String get groupRemoveAdminSuccess => '관리자가 삭제됨';

  @override
  String groupRemoveAdminFailed(Object error) {
    return '관리자 제거 실패: $error';
  }

  @override
  String get groupSelectNewOwner => '새 소유자 선택';

  @override
  String groupTransferOwnerConfirm(Object name) {
    return '소유권을 \"$name\"(으)로 이전하시겠습니까? 정회원이 됩니다.';
  }

  @override
  String get groupTransferOwnerAction => '이전 확인';

  @override
  String get groupOwnerTransferred => '소유권 이전됨';

  @override
  String groupOwnerTransferFailed(Object error) {
    return '소유권 이전 실패: $error';
  }

  @override
  String get groupNoticePublisherDefault => '그룹 공지';

  @override
  String get groupNoticePublishTitle => '게시물 그룹 공지';

  @override
  String get groupNoticeEditTitle => '그룹 공지 편집';

  @override
  String get groupNoticePublishAction => '게시물';

  @override
  String get groupNoticeEmpty => '그룹 공지 없음';

  @override
  String get groupNoticePublishedAtUnknown => '게시 시간 알 수 없음';

  @override
  String get groupMemberRemarkTitle => '이 그룹의 내 별명';

  @override
  String get groupMemberRemarkHint => '이 그룹의 닉네임을 설정하세요';

  @override
  String get groupQrCodeEmpty => '그룹 QR 코드 없음';

  @override
  String groupQrCodeValid(Object day, Object expire) {
    return '이 QR 코드는 $day일($expire) 동안 유효합니다.';
  }

  @override
  String get groupQrCodeScanToJoin => '이 그룹에 가입하려면 QR 코드를 스캔하세요.';

  @override
  String get groupBlacklistLoadFailed => '블랙리스트를 로드하지 못했습니다. 다시 시도해 보세요.';

  @override
  String get groupBlacklistEmpty => '블랙리스트에 등록된 회원이 없습니다.';

  @override
  String get groupBlacklistAddMember => '블랙리스트 회원 추가';

  @override
  String get groupBlacklistNoCandidates => '블랙리스트에 회원을 추가할 수 없습니다.';

  @override
  String get groupSelectMember => '회원 선택';

  @override
  String get groupBlacklistAdded => '블랙리스트에 추가됨';

  @override
  String get groupBlacklistAddFailed => '블랙리스트에 추가하지 못했습니다. 다시 시도해 보세요.';

  @override
  String groupBlacklistRemoveConfirm(Object name) {
    return '그룹 블랙리스트에서 \"$name\"을(를) 제거하시겠습니까?';
  }

  @override
  String get groupBlacklistRemoveAction => '블랙리스트에서 제거';

  @override
  String get groupBlacklistRemoveFailed => '블랙리스트에서 제거하지 못했습니다. 다시 시도해 보세요.';

  @override
  String get groupAvatarTitle => '그룹 아바타';

  @override
  String get groupAvatarTakePhoto => '사진 찍기';

  @override
  String get groupAvatarChooseFromAlbum => '앨범에서 선택';

  @override
  String get groupAvatarSaveImage => '이미지 저장';

  @override
  String get groupAvatarUnsupported => '이 채팅은 그룹 아바타 변경을 지원하지 않습니다.';

  @override
  String get groupAvatarUpdated => '그룹 아바타가 업데이트되었습니다.';

  @override
  String get groupAvatarUpdateFailed => '그룹 아바타를 업데이트하지 못했습니다. 다시 시도해 보세요.';

  @override
  String get groupAvatarNoImageToSave => '저장할 아바타가 없습니다.';

  @override
  String groupPhotoPermissionRequired(Object appName) {
    return '$appName이(가) 사진에 액세스하도록 허용합니다.';
  }

  @override
  String get groupImageSavedToAlbum => '앨범에 저장됨';

  @override
  String get groupImageSaveFailed => '저장하지 못했습니다. 다시 시도해 보세요.';

  @override
  String get imageEditorProcessing => '처리 중...';

  @override
  String get imageEditorDiscardTitle => '수정사항을 삭제하시겠습니까?';

  @override
  String get imageEditorDiscardMessage => '저장되지 않은 편집 내용은 손실됩니다.';

  @override
  String get imageEditorDiscardConfirm => '삭제';

  @override
  String get imageEditorPaint => '추첨';

  @override
  String get imageEditorFreestyle => '자유형';

  @override
  String get imageEditorArrow => '화살표';

  @override
  String get imageEditorLine => '라인';

  @override
  String get imageEditorRectangle => '직사각형';

  @override
  String get imageEditorCircle => '원';

  @override
  String get imageEditorDashLine => '점선';

  @override
  String get imageEditorMoveAndZoom => '이동/확대/축소';

  @override
  String get imageEditorEraser => '지우개';

  @override
  String get imageEditorLineWidth => '너비';

  @override
  String get imageEditorToggleFill => '채우기';

  @override
  String get imageEditorOpacity => '불투명도';

  @override
  String get imageEditorUndo => '실행 취소';

  @override
  String get imageEditorRedo => '다시 실행';

  @override
  String get imageEditorInputHint => '텍스트를 입력하세요';

  @override
  String get imageEditorText => '텍스트';

  @override
  String get imageEditorTextAlign => '정렬';

  @override
  String get imageEditorBackground => '배경';

  @override
  String get imageEditorFontScale => '글꼴 크기';

  @override
  String get imageEditorCrop => '자르기';

  @override
  String get imageEditorRotate => '회전';

  @override
  String get imageEditorRatio => '비율';

  @override
  String get imageEditorReset => '재설정';

  @override
  String get imageEditorFlip => '뒤집기';

  @override
  String get imageEditorFilter => '필터';

  @override
  String get imageEditorFilterNone => '원본';

  @override
  String get imageEditorFilterAddictiveBlue => '중독성 블루';

  @override
  String get imageEditorFilterAddictiveRed => '중독성 레드';

  @override
  String get imageEditorFilterAden => '아덴';

  @override
  String get imageEditorFilterAmaro => '아마로';

  @override
  String get imageEditorFilterAshby => '애쉬비';

  @override
  String get imageEditorFilterBrannan => '브래넌';

  @override
  String get imageEditorFilterBrooklyn => '브루클린';

  @override
  String get imageEditorFilterCharmes => '매력';

  @override
  String get imageEditorFilterClarendon => '클라렌든';

  @override
  String get imageEditorFilterCrema => '크레마';

  @override
  String get imageEditorFilterDogpatch => '도그패치';

  @override
  String get imageEditorFilterEarlybird => '얼리버드';

  @override
  String get imageEditorFilterGingham => '깅엄';

  @override
  String get imageEditorFilterGinza => '긴자';

  @override
  String get imageEditorFilterHefe => '헤페';

  @override
  String get imageEditorFilterHelena => '헬레나';

  @override
  String get imageEditorFilterHudson => '허드슨';

  @override
  String get imageEditorFilterInkwell => '잉크병';

  @override
  String get imageEditorFilterJuno => '주노';

  @override
  String get imageEditorFilterKelvin => '켈빈';

  @override
  String get imageEditorFilterLark => '종달새';

  @override
  String get imageEditorFilterLoFi => 'Lo-Fi';

  @override
  String get imageEditorFilterLudwig => '루드비히';

  @override
  String get imageEditorFilterMaven => '메이븐';

  @override
  String get imageEditorFilterMayfair => '메이페어';

  @override
  String get imageEditorFilterMoon => '달';

  @override
  String get imageEditorFilterNashville => '내쉬빌';

  @override
  String get imageEditorFilterPerpetua => '퍼페투아';

  @override
  String get imageEditorFilterReyes => '레예스';

  @override
  String get imageEditorFilterRise => '라이즈';

  @override
  String get imageEditorFilterSierra => '시에라';

  @override
  String get imageEditorFilterSkyline => '스카이라인';

  @override
  String get imageEditorFilterSlumber => '파자마';

  @override
  String get imageEditorFilterStinson => '스틴슨';

  @override
  String get imageEditorFilterSutro => '수트로';

  @override
  String get imageEditorFilterToaster => '토스터';

  @override
  String get imageEditorFilterValencia => '발렌시아';

  @override
  String get imageEditorFilterVesper => '베스퍼';

  @override
  String get imageEditorFilterWalden => '월든';

  @override
  String get imageEditorFilterWillow => '버드나무';

  @override
  String get imageEditorBlur => '흐림';

  @override
  String get imageEditorTune => '조정';

  @override
  String get imageEditorBrightness => '밝기';

  @override
  String get imageEditorContrast => '대비';

  @override
  String get imageEditorSaturation => '채도';

  @override
  String get imageEditorExposure => '노출';

  @override
  String get imageEditorHue => '색조';

  @override
  String get imageEditorTemperature => '온도';

  @override
  String get imageEditorSharpness => '선명도';

  @override
  String get imageEditorFade => '페이드';

  @override
  String get imageEditorLuminance => '휘도';

  @override
  String get imageEditorEmoji => '이모티콘';

  @override
  String get imageEditorEmojiRecent => '최근';

  @override
  String get imageEditorEmojiSmileys => '스마일';

  @override
  String get imageEditorEmojiAnimals => '동물';

  @override
  String get imageEditorEmojiFood => '음식';

  @override
  String get imageEditorEmojiActivities => '활동';

  @override
  String get imageEditorEmojiTravel => '여행';

  @override
  String get imageEditorEmojiObjects => '개체';

  @override
  String get imageEditorEmojiSymbols => '기호';

  @override
  String get imageEditorEmojiFlags => '플래그';

  @override
  String get imageEditorSticker => '스티커';

  @override
  String get imageEditorRemove => '제거';

  @override
  String get imageEditorSaving => '저장 중...';

  @override
  String get imageEditorImporting => '가져오는 중';

  @override
  String get imagePreviewTitle => '이미지 미리보기';

  @override
  String get imagePreviewSavingToAlbum => '저장 중...';

  @override
  String get imagePreviewAddToSticker => '스티커에 추가';

  @override
  String get imagePreviewAddingToSticker => '추가 중...';

  @override
  String get imagePreviewRecognizeQr => 'QR 코드 인식';

  @override
  String get imagePreviewRecognizingQr => '인식 중...';

  @override
  String get imagePreviewConfirmWebLogin => 'Web 로그인 확인';

  @override
  String get imagePreviewConfirmingWebLogin => '확인 중...';

  @override
  String get imagePreviewOpenLink => '링크 열기';

  @override
  String get imagePreviewImageNotDownloadedSave => '이미지가 아직 다운로드되지 않았습니다.';

  @override
  String get imagePreviewMediaUnavailable => '미디어 서비스를 사용할 수 없습니다.';

  @override
  String get imagePreviewImageNotUploadedSticker => '이미지가 아직 업로드되지 않았습니다.';

  @override
  String get imagePreviewStickerUnavailable => '스티커 서비스를 이용할 수 없습니다.';

  @override
  String get imagePreviewAddedToSticker => '스티커에 추가됨';

  @override
  String get imagePreviewImageNotDownloadedRecognize => '이미지가 아직 다운로드되지 않았습니다.';

  @override
  String get imagePreviewQrNotFound => 'QR 코드를 찾을 수 없습니다.';

  @override
  String get imagePreviewWebLoginQrRecognized => 'Web 로그인 QR 코드가 인식되었습니다.';

  @override
  String get imagePreviewWebLinkRecognized => 'Web 링크가 인식되었습니다.';

  @override
  String get imagePreviewQrRecognized => 'QR 코드가 인식되었습니다.';

  @override
  String get imagePreviewWebLoginConfirmed => 'Web 로그인이 확인되었습니다.';

  @override
  String get pickerFileTitle => '파일 선택';

  @override
  String get pickerRecentFiles => '최근 파일';

  @override
  String get pickerSampleProjectFile => '프로젝트 노트.pdf';

  @override
  String get pickerSampleProjectFileSubtitle => '128KB · 오늘';

  @override
  String get pickerSampleScreenshotFile => '채팅 스크린샷.png';

  @override
  String get pickerSampleScreenshotFileSubtitle => '2.4MB · 어제';

  @override
  String get pickerContactTitle => '연락처 선택';

  @override
  String get pickerContactCardSection => '연락처 카드 보내기';

  @override
  String get pickerSearchContacts => '연락처 검색';

  @override
  String get pickerNoMatchingContacts => '일치하는 연락처가 없습니다.';

  @override
  String get chatSendFailedShort => '전송 실패';

  @override
  String get chatResend => '재전송';

  @override
  String get chatStatusRead => '읽기';

  @override
  String get pinnedMessageTitle => '고정된 메시지';

  @override
  String pinnedMessageTitleWithIndex(int index, int total) {
    return '고정된 메시지 $index/$total';
  }

  @override
  String get pinnedMessageOpen => '보려면 탭하세요.';

  @override
  String get pinnedMessageViewAllTooltip => '고정된 항목 모두 보기';

  @override
  String get pinnedMessageUnpinTooltip => '고정 해제';

  @override
  String pinnedMessageListCount(int count) {
    return '$count 고정된 메시지';
  }

  @override
  String get pinnedMessageClearAll => '모두 고정 해제';

  @override
  String get pinnedMessageFallback => '고정된 메시지';

  @override
  String get fileUnnamed => '제목 없는 파일';

  @override
  String get fileNoDownloadUrl => '사용 가능한 다운로드 링크가 없습니다.';

  @override
  String get fileTitle => '파일';

  @override
  String fileSizeLabel(String size) {
    return '파일 크기: $size';
  }

  @override
  String get fileDownloadFailed => '다운로드 실패';

  @override
  String get filePreview => '미리보기';

  @override
  String get fileOpenWithOtherApp => '다른 앱에서 열기';

  @override
  String get actionEnable => '활성화';

  @override
  String get actionDisable => '비활성화';

  @override
  String get profileInviteLoading => '초대 코드 로드 중';

  @override
  String get profileInviteEnabled => '초대 코드 활성화됨';

  @override
  String get profileInviteDisabled => '초대 코드가 비활성화되었습니다.';

  @override
  String profileInviteLoadFailed(String error) {
    return '초대 코드를 로드하지 못했습니다: $error';
  }

  @override
  String get profileInviteCopied => '복사됨';

  @override
  String profileInviteUpdateFailed(String error) {
    return '초대 코드 업데이트 실패: $error';
  }

  @override
  String get stickerStoreTitle => '스티커 판매점';

  @override
  String get stickerNoPacks => '스티커 팩 없음';

  @override
  String get stickerDetailTitle => '스티커 세부정보';

  @override
  String get stickerProcessing => '처리 중...';

  @override
  String get stickerAddCustomTitle => '맞춤 스티커 추가';

  @override
  String get stickerSortTitle => '스티커 정렬';

  @override
  String get stickerMyStickersTitle => '내 스티커';

  @override
  String get stickerSaving => '저장 중';

  @override
  String get stickerSortAction => '정렬';

  @override
  String get stickerOrganize => '정리';

  @override
  String get stickerCustomTitle => '맞춤 스티커';

  @override
  String get stickerCustomSubtitle => '저장된 맞춤 스티커 관리';

  @override
  String get stickerNoSortablePacks => '정렬할 스티커 팩이 없습니다.';

  @override
  String get stickerNoCategories => '스티커 카테고리 없음';

  @override
  String get stickerMoveUp => '위로 이동';

  @override
  String get stickerMoveDown => '아래로 이동';

  @override
  String get stickerNoCustomStickers => '맞춤 스티커가 없습니다.';

  @override
  String get stickerMoveToFront => '앞으로 이동';

  @override
  String get stickerDeleteConfirmTitle => '삭제된 스티커는 복구할 수 없습니다.';

  @override
  String get complaintTitle => '신고';

  @override
  String get complaintHint => '문제를 설명하세요.';

  @override
  String get complaintType => '보고서 유형';

  @override
  String get complaintSubmitted => '보고서가 제출되었습니다.';

  @override
  String get complaintSubmit => '보고서 제출';

  @override
  String get complaintSubmitting => '제출 중…';

  @override
  String get complaintFallbackOtherViolation => '기타 정책 위반';

  @override
  String get complaintFallbackFraud => '기타 사기 또는 사기';

  @override
  String get complaintFallbackAccountCompromised => '계정이 손상되었을 수 있습니다.';

  @override
  String get chatBackgroundTitle => '채팅 배경';

  @override
  String get chatBackgroundLoading => '채팅 배경 로드 중';

  @override
  String get chatBackgroundEmpty => '채팅 배경 없음';

  @override
  String get chatBackgroundDefault => '기본 배경';

  @override
  String chatBackgroundItem(int index) {
    return '배경 $index';
  }

  @override
  String get chatBackgroundPreviewTitle => '미리보기 배경';

  @override
  String get chatBackgroundSet => '배경 설정';

  @override
  String get chatBackgroundSelectedStatus => '채팅 배경 설정';

  @override
  String get chatBackgroundInUse => '사용 중';

  @override
  String get chatContactFallback => '연락처';

  @override
  String get chatPersonalCard => '연락처 카드';

  @override
  String get chatSystemMessageDigest => '[시스템 메시지]';

  @override
  String get chatMessageDigestMessage => '[메시지]';

  @override
  String get chatMessageDigestImage => '[이미지]';

  @override
  String get chatMessageDigestVoice => '[음성]';

  @override
  String get chatMessageDigestVideo => '[동영상]';

  @override
  String get chatMessageDigestLocation => '[위치]';

  @override
  String get chatMessageDigestCard => '[연락처 카드]';

  @override
  String get chatMessageDigestFile => '[파일]';

  @override
  String get chatMessageDigestHistory => '[채팅 기록]';

  @override
  String get chatMessageDigestSticker => '[스티커]';

  @override
  String get dateWeekdayShortMonday => '월';

  @override
  String get dateWeekdayShortTuesday => '화요일';

  @override
  String get dateWeekdayShortWednesday => '수요일';

  @override
  String get dateWeekdayShortThursday => '목';

  @override
  String get dateWeekdayShortFriday => '금요일';

  @override
  String get dateWeekdayShortSaturday => '토요일';

  @override
  String get dateWeekdayShortSunday => '일요일';

  @override
  String get appIconClassic => '클래식';

  @override
  String get appIconSimple => '단순';

  @override
  String get appIconDark => '어두움';

  @override
  String get appIconFestive => '축제';

  @override
  String get appIconGradient => '그라데이션';

  @override
  String get appIconUpdated => '아이콘이 업데이트되었습니다.';

  @override
  String get appIconUpdateFailed => '전환에 실패했습니다. 나중에 다시 시도하세요.';

  @override
  String get appearanceBubbleColorPurple => '보라색';

  @override
  String get appearanceBubbleColorGreen => '녹색';

  @override
  String get appearanceBubbleColorBlue => '파란색';

  @override
  String get appearanceBubbleColorOrange => '오렌지';

  @override
  String get appearanceBubbleColorPink => '핑크';

  @override
  String replyPreviewTitle(String name) {
    return '$name에 답장';
  }

  @override
  String get replyPreviewCancel => '답장 취소';

  @override
  String get chatPasswordTitle => '채팅 비밀번호';

  @override
  String get chatPasswordHint => '비밀번호 6자리를 입력하세요';

  @override
  String chatPasswordErrorRemain(int remain) {
    return '비밀번호가 잘못되었습니다. $remain번 더 실패하면 채팅 기록이 삭제됩니다.';
  }

  @override
  String get emojiPackEmpty => '이 팩에는 스티커가 없습니다.';

  @override
  String get emojiRecentSection => '최근';

  @override
  String get emojiAllSection => '모든 이모티콘';

  @override
  String get stickerSearching => '검색 중...';

  @override
  String get stickerNoSearchResults => '결과 없음';

  @override
  String get stickerSearchResultsTitle => '결과:';

  @override
  String get homeChatPasswordWiped => '잘못된 시도가 너무 많습니다. 채팅기록이 삭제되었습니다.';

  @override
  String get homeGroupNotFound => '그룹 채팅을 찾을 수 없습니다.';

  @override
  String get homeConversationNoHistory => '채팅 기록이 없습니다.';

  @override
  String get homeConversationStartChat => '채팅 시작';

  @override
  String get homeEnterGroupChat => '그룹 채팅 시작';

  @override
  String get homeNewGroup => '새 그룹 채팅';

  @override
  String homeFriendRequestAcceptFailed(String error) {
    return '수락 실패: $error';
  }

  @override
  String get homeFriendRequestAccepted => '친구 요청이 수락되었습니다.';

  @override
  String homeFriendRequestRefuseFailed(String error) {
    return '거부 실패: $error';
  }

  @override
  String homeFriendRequestDeleteFailed(String error) {
    return '삭제 실패: $error';
  }

  @override
  String contactPresenceOnlineWithDevice(String device) {
    return '온라인: $device';
  }

  @override
  String contactPresenceJustOnlineWithDevice(String device) {
    return '지금 $device에 온라인 상태입니다.';
  }

  @override
  String contactPresenceMinutesOnlineWithDevice(int minutes, String device) {
    return '온라인 접속: $device $minutes분 전';
  }

  @override
  String contactPresenceLastOnline(String time) {
    return '마지막 온라인 $time';
  }

  @override
  String get contactPresenceDeviceWeb => '웹';

  @override
  String get contactPresenceDeviceDesktop => '데스크탑';

  @override
  String get contactPresenceDeviceMobile => '모바일';

  @override
  String get botCommandsEmpty => '아직 명령어가 없습니다';
}
