// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get tabMessages => 'チャット';

  @override
  String get tabContacts => '連絡先';

  @override
  String get tabDiscover => '発見する';

  @override
  String get tabMe => '私';

  @override
  String get pageMessagesTitle => 'チャット';

  @override
  String get pageContactsTitle => '連絡先';

  @override
  String get pageDiscoverTitle => '発見する';

  @override
  String get pageMeTitle => '私';

  @override
  String get actionCancel => 'キャンセル';

  @override
  String get actionConfirm => '確認';

  @override
  String get actionDone => '完了';

  @override
  String get actionSave => '保存';

  @override
  String get actionDelete => '削除';

  @override
  String get actionEdit => '編集';

  @override
  String get actionAdd => '追加';

  @override
  String get actionRemove => '削除';

  @override
  String get actionInvite => '招待する';

  @override
  String get actionSearch => '検索';

  @override
  String get actionSend => '送信';

  @override
  String get actionRetry => '再試行';

  @override
  String get actionBack => '戻る';

  @override
  String get actionMore => '詳細';

  @override
  String get actionJoin => '参加する';

  @override
  String get actionSkip => 'スキップ';

  @override
  String get actionContinue => '続行';

  @override
  String get actionGetStarted => '始めましょう';

  @override
  String get actionSaving => '保存中...';

  @override
  String get moduleUnsupported => 'この機能はこのバージョンでは使用できません';

  @override
  String get moduleLoading => '機能へのアクセスをチェックしています。後でもう一度試してください。';

  @override
  String get moduleOfflineStale => 'ネットワークに接続して機能へのアクセスを確認してください';

  @override
  String get onboardingMenuTitle => 'クイックガイド';

  @override
  String onboardingChatTitle(Object appName) {
    return '$appName へようこそ';
  }

  @override
  String get onboardingChatSubtitle => 'より快適な会話のための清潔で明るい場所。';

  @override
  String get onboardingFriendsTitle => '連絡を取り合うのが簡単になります';

  @override
  String get onboardingFriendsSubtitle => '友達、グループ、共有を簡単に見つけられます。';

  @override
  String get onboardingSecurityTitle => '自由に話してください。安心してご使用ください。';

  @override
  String get onboardingSecuritySubtitle =>
      'アカウントのセキュリティとプライバシー保護は、境界を守るのに役立ちます。';

  @override
  String get onboardingChatSemantic => 'メッセージ同期オンボーディングの図';

  @override
  String get onboardingFriendsSemantic => '友達とグループのオンボーディングの図';

  @override
  String get onboardingSecuritySemantic => 'セキュリティとプライバシーのオンボーディングの図';

  @override
  String get settingsLanguageRow => '言語';

  @override
  String get settingsLanguageSystem => 'システムのデフォルト';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => '英語';

  @override
  String get profileRowFavorites => 'お気に入り';

  @override
  String get profileRowSecurityPrivacy => 'セキュリティとプライバシー';

  @override
  String get profileRowNotifications => '通知';

  @override
  String get profileRowInviteCode => '招待コード';

  @override
  String get profileRowGeneral => '一般';

  @override
  String profileRowAbout(Object appName) {
    return '$appName について';
  }

  @override
  String get profileLogout => 'ログアウト';

  @override
  String get profileLogoutConfirm =>
      'ログアウトしても履歴は削除されません。このアカウントでいつでも再度サインインできます。';

  @override
  String profileMoyuIdLabel(Object appName, Object value) {
    return '$appName ID: $value';
  }

  @override
  String get profileDefaultName => '私';

  @override
  String get profileDetailTitle => 'プロフィール';

  @override
  String get profileAvatar => 'アバター';

  @override
  String get profileNickname => 'ニックネーム';

  @override
  String get profileEditNickname => 'ニックネームを編集';

  @override
  String profileEditFoxId(Object appName) {
    return '$appName ID を編集';
  }

  @override
  String get profileGender => '性別';

  @override
  String get profileGenderMale => '男性';

  @override
  String get profileGenderFemale => '女性';

  @override
  String get profileGenderSelected => '選択済み';

  @override
  String get profileGenderUnset => '未設定';

  @override
  String get profilePhoneUnbound => 'リンクされていません';

  @override
  String get profileAvatarUpdated => 'アバターが更新されました';

  @override
  String get profileAvatarUpdateFailed => 'アバターのアップロードに失敗しました。もう一度やり直してください。';

  @override
  String get generalPageTitle => '一般';

  @override
  String get generalFontSize => 'フォント サイズ';

  @override
  String get generalChatBackground => 'チャットの背景';

  @override
  String get generalDarkMode => 'ダークモード';

  @override
  String get generalClearCache => 'キャッシュをクリア';

  @override
  String get generalClearMessages => 'チャット履歴をクリアする';

  @override
  String get generalAppModules => '特徴';

  @override
  String get generalErrorLogs => 'エラーログ';

  @override
  String get generalThirdShare => 'サードパーティ SDK';

  @override
  String get fontSizeSmall => '小';

  @override
  String get fontSizeStandard => '標準';

  @override
  String get fontSizeLarge => '大';

  @override
  String get fontSizeExtraLarge => '特大';

  @override
  String get darkModeSystem => 'システムのデフォルト';

  @override
  String get darkModeLight => 'ライト';

  @override
  String get darkModeDark => 'ダーク';

  @override
  String get valueConfigure => '構成';

  @override
  String get valueManage => '管理';

  @override
  String get valueClear => 'クリア';

  @override
  String get valueUpload => 'アップロード';

  @override
  String get valueDownload => 'ダウンロード';

  @override
  String get valueView => 'ビュー';

  @override
  String get valueEnabled => '有効';

  @override
  String get valueDisabled => '無効';

  @override
  String get valueOn => 'オン';

  @override
  String get valueOff => 'オフ';

  @override
  String get valueConfigured => 'セット';

  @override
  String get valueNotEnabled => '有効になっていません';

  @override
  String get valueSelected => '選択済み';

  @override
  String get valueCurrentDevice => 'このデバイス';

  @override
  String get valueSdkInfo => 'SDK 情報';

  @override
  String get statusProcessing => '処理中';

  @override
  String get statusLoading => '読み込み中';

  @override
  String get statusSending => '送信中';

  @override
  String get statusSaving => '保存中';

  @override
  String get statusSaved => '保存しました';

  @override
  String get statusSent => '送信しました';

  @override
  String get statusSubmitted => '送信されました';

  @override
  String get dateJustNow => 'たった今';

  @override
  String get dateToday => '今日';

  @override
  String get dateYesterday => '昨日';

  @override
  String get dateDayBeforeYesterday => '一昨日';

  @override
  String dateTodayTime(Object time) {
    return '今日 $time';
  }

  @override
  String dateYesterdayTime(Object time) {
    return '昨日 $time';
  }

  @override
  String dateDayBeforeYesterdayTime(Object time) {
    return '2 日前 $time';
  }

  @override
  String dateWeekdayTime(Object time, Object weekday) {
    return '$weekday $time';
  }

  @override
  String dateMonthDayTime(Object day, Object month, Object time) {
    return '$month月$day日 $time';
  }

  @override
  String dateYearMonthDayTime(
    Object day,
    Object month,
    Object time,
    Object year,
  ) {
    return '$year年$month月$day日 $time';
  }

  @override
  String dateMonthDay(Object day, Object month) {
    return '$month月$day日';
  }

  @override
  String dateYearMonthDay(Object day, Object month, Object year) {
    return '$year年$month月$day日';
  }

  @override
  String get weekdayMonday => '月曜日';

  @override
  String get weekdayTuesday => '火曜日';

  @override
  String get weekdayWednesday => '水曜日';

  @override
  String get weekdayThursday => '木曜日';

  @override
  String get weekdayFriday => '金曜日';

  @override
  String get weekdaySaturday => '土曜日';

  @override
  String get weekdaySunday => '日曜日';

  @override
  String get dialogClearAllTitle => 'チャット履歴をすべてクリアしますか?';

  @override
  String get dialogClearAllBody => 'ローカル チャット履歴と会話エントリはすべて削除されます。';

  @override
  String get authLoginSubtitle => '電話番号でログインして友達とチャットを続けましょう';

  @override
  String get authLoginIllustration => 'ログインの図';

  @override
  String get authRegisterIllustration => '登録イラスト';

  @override
  String get authSecurityIllustration => '検証イラスト';

  @override
  String get authResetIllustration => 'パスワードリセットの図';

  @override
  String get authServerLabel => 'サーバー';

  @override
  String get authServerCustomLabel => 'Custom server';

  @override
  String get authServerCustomHint => 'Enter server address';

  @override
  String get authPhoneLabel => '電話番号';

  @override
  String get authPasswordLabel => 'パスワード';

  @override
  String get authForgotPassword => 'パスワードをお忘れですか?';

  @override
  String get authLoginButton => 'ログイン';

  @override
  String get authLoginLoading => 'ログイン中...';

  @override
  String get authRegisterButton => '登録する';

  @override
  String get authLoginWithApple => 'Sign in with Apple';

  @override
  String get authLoginWithGoogle => 'Sign in with Google';

  @override
  String get authLoginWithGithub => 'Sign in with GitHub';

  @override
  String get authLoginAgreementPrefix => 'ログインすると、次のことに同意したことになります。';

  @override
  String get authTermsTitle => '利用規約';

  @override
  String get authAgreementConnector => 'および';

  @override
  String get authPrivacyTitle => 'プライバシー ポリシー';

  @override
  String get authVerifyTitle => '認証ログイン';

  @override
  String authVerifySubtitleWithPhone(Object phone) {
    return '$phone に送信されたコードを入力してください';
  }

  @override
  String get authVerifySubtitlePasswordFirst =>
      'セキュリティ検証を開始するには、まずパスワードを使用してログインしてください';

  @override
  String get authVerifyButton => '確認する';

  @override
  String get authVerifyLoading => '確認中...';

  @override
  String get authResendCode => 'コードを取得できませんでしたか?再送信';

  @override
  String get authVerificationCodeSent => '確認コードが送信されました';

  @override
  String get authVerificationCodeRequired => '確認コードを入力してください';

  @override
  String get authVerificationCodeSixDigits => '6桁のコードを入力してください';

  @override
  String get authPasswordResetTitle => 'ログインパスワードをリセット';

  @override
  String get authPasswordResetSubtitle => '電話番号を確認して、新しいログイン パスワードを設定してください';

  @override
  String get authPasswordResetButton => 'パスワードをリセット';

  @override
  String get authKickedTitle => 'あなたのアカウントは別のデバイスでログインしました。';

  @override
  String get authSubmitting => '送信中...';

  @override
  String get authVerificationCodeLabel => '確認コード';

  @override
  String get authGetVerificationCode => 'コードを取得';

  @override
  String get authNewPasswordLabel => '新しいパスワード';

  @override
  String get authPasswordResetSuccess => 'パスワードのリセット';

  @override
  String authRegisterTitle(Object appName) {
    return '$appName アカウントを作成する';
  }

  @override
  String get authRegisterSubtitle => '電話番号を登録して、すぐにチャットを始めましょう';

  @override
  String get authCreateAccount => 'アカウントの作成';

  @override
  String get authNicknameLabel => 'ニックネーム';

  @override
  String get authInviteCodeRequiredLabel => '招待コード (必須)';

  @override
  String authCodeRetryAfter(Object seconds) {
    return '$seconds秒後に再試行してください';
  }

  @override
  String get authRegisterAgreement => 'サービス利用規約とプライバシー ポリシーを読み、同意します';

  @override
  String get authInvalidPhone => '無効な電話番号です';

  @override
  String get authAcceptAgreementFirst => 'まず利用規約とプライバシーポリシーに同意してください';

  @override
  String get authCodeEmpty => '確認コードが必要です';

  @override
  String get authPasswordLengthInvalid => 'パスワードは 6 ～ 16 文字である必要があります';

  @override
  String get authInviteCodeEmpty => '招待コードが必要です';

  @override
  String get authRegisterSuccess => '正常に登録されました';

  @override
  String get settingsCheckNewVersion => 'アップデートを確認する';

  @override
  String get settingsChecking => 'チェック中';

  @override
  String get settingsVersionFound => 'アップデートが利用可能です';

  @override
  String get settingsUserAgreement => '利用規約';

  @override
  String get settingsPrivacyPolicy => 'プライバシー ポリシー';

  @override
  String get settingsView => '表示';

  @override
  String get settingsSwitchAccount => 'アカウントを切り替える';

  @override
  String get settingsCacheCleared => 'キャッシュがクリアされました';

  @override
  String get settingsClearCacheSheetTitle =>
      '画像/ビデオ キャッシュをクリアしますか?\nチャット画像、ビデオ カバー、アバターが再度ダウンロードされます。';

  @override
  String get settingsClearCacheAction => 'キャッシュをクリア';

  @override
  String get settingsMessagesCleared => 'チャット履歴が消去されました';

  @override
  String settingsClearMessagesFailed(Object error) {
    return 'チャット履歴をクリアできませんでした: $error';
  }

  @override
  String get settingsAlreadyLatestVersion => 'すでに最新バージョンを使用しています';

  @override
  String get settingsCheckFailed => 'チェックに失敗しました';

  @override
  String settingsUpdateDialogTitle(Object version) {
    return 'アップデートが利用可能\n最新バージョン: $version';
  }

  @override
  String settingsUpdateDialogTitleWithDescription(
    Object description,
    Object version,
  ) {
    return 'アップデートが利用可能\n最新バージョン: $version\n$description';
  }

  @override
  String get settingsLater => '後で';

  @override
  String get settingsUpdateNow => '今すぐ更新';

  @override
  String get settingsSaveFailedRetry => '保存に失敗しました。もう一度やり直してください。';

  @override
  String get securityAllowPhoneSearch => '他の人が電話番号で私を見つけられるようにする';

  @override
  String securityAllowFoxIdSearch(Object appName) {
    return '他の人が $appName ID で私を見つけられるようにします';
  }

  @override
  String get securitySearchRemark => 'オフの場合、他のユーザーは上記の情報であなたを見つけることができません。';

  @override
  String get securityJoinGroupNeedConfirm =>
      'Require confirmation to join groups';

  @override
  String get securityJoinGroupNeedConfirmRemark =>
      'When on, invitations to add you to a group must be confirmed by you first.';

  @override
  String get securityLoginPassword => 'ログインパスワード';

  @override
  String get securityChatPassword => 'チャットパスワード';

  @override
  String get securityScreenProtection => '画面保護';

  @override
  String get securityLockPassword => 'ロックパスワード';

  @override
  String get securityOfflineProtection => 'オフライン画面ロック';

  @override
  String get securityDeviceManagement => 'ログインデバイス管理';

  @override
  String get securityDeviceRemark =>
      'デバイスを表示および管理し、ログイン保護を有効にして、アカウントを安全に保ちます。';

  @override
  String get securityBlacklist => 'ブラックリスト';

  @override
  String get securityAccountDeletion => 'アカウントを削除';

  @override
  String get accountDeletionBody =>
      'アカウントの削除は元に戻せません。確認後、SMS で削除を完了するための確認コードが送信されます。';

  @override
  String get accountDeletionSubmitted => '削除リクエストが送信されました';

  @override
  String get accountDeletionGetCode => 'コードを取得';

  @override
  String get passwordResetInstruction =>
      'ログイン パスワードを変更するには、SMS コードが必要です。新しいパスワードは 6 文字以上である必要があります。';

  @override
  String get accountPhoneLabel => '電話番号';

  @override
  String get passwordRuleLabel => 'パスワードルール';

  @override
  String get passwordAtLeastSix => '少なくとも 6 文字';

  @override
  String get passwordConfirmLabel => 'パスワードを確認してください';

  @override
  String get passwordConfirmHint => 'ログインパスワードを再度入力してください';

  @override
  String get passwordChanged => 'ログインパスワードが変更されました';

  @override
  String get phoneRequired => '電話番号は必須です';

  @override
  String get passwordMismatch => 'パスワードが一致しません';

  @override
  String get chatPasswordInstruction =>
      '有効にすると、保護されたチャットを開く前にこの 6 桁のパスワードが必要になります。';

  @override
  String get currentStatusLabel => '現在のステータス';

  @override
  String get passwordSixDigits => '6桁';

  @override
  String get chatPasswordEnableAction => 'チャットパスワードを有効にする';

  @override
  String get loginPasswordRequired => 'ログインパスワードが必要です';

  @override
  String get chatPasswordSixDigitsRequired => 'チャットのパスワードは 6 桁である必要があります';

  @override
  String get lockSetTitle => '6桁のロックパスワードを設定します';

  @override
  String lockSetSubtitle(Object appName) {
    return '$appName のロックを解除するには必要です';
  }

  @override
  String get lockCurrentPromptTitle => '現在のロックパスワードを入力してください';

  @override
  String get lockCurrentPromptSubtitle => '変更またはオフにする前に確認してください';

  @override
  String get lockAutoLock => 'オートロック';

  @override
  String get lockChangePassword => 'ロック解除パスワードの変更';

  @override
  String get lockClosePassword => 'ロック解除パスワードをオフにする';

  @override
  String get lockWrongPassword => 'パスワードが間違っています。もう一度やり直してください。';

  @override
  String get lockSixDigitsRequired => 'ロックパスワードは6桁でなければなりません';

  @override
  String get lockInputTitle => 'ロックパスワードを入力してください';

  @override
  String lockInputSubtitle(Object appName) {
    return '$appName を引き続き使用するにはロックを解除してください';
  }

  @override
  String get lockSetFailed => '設定に失敗しました。もう一度やり直してください。';

  @override
  String get lockImmediately => 'すぐに';

  @override
  String get lockAfter5Minutes => '5分後';

  @override
  String get lockAfter30Minutes => '30分後に出発';

  @override
  String get lockAfter1Hour => '1時間離れた後';

  @override
  String get deviceLoginProtection => 'ログイン保護';

  @override
  String get deviceProtectionRemark =>
      'ログイン保護が有効になっている場合、不慣れなデバイスではセキュリティ検証が必要です。アカウントの安全のために推奨されます。';

  @override
  String get deviceNone => 'ログインしているデバイスがありません';

  @override
  String get deviceDebugName => '現在のデバイス';

  @override
  String get deviceDebugPlatform => 'iPhone / Android デバッグデバイス';

  @override
  String get deviceProtectionEnabled => 'ログイン保護が有効になりました';

  @override
  String get deviceProtectionDisabled => 'ログイン保護が無効になりました';

  @override
  String get deviceProtectionUpdateFailed => 'ログイン保護を更新できませんでした。もう一度やり直してください。';

  @override
  String get blacklistEmpty => 'ブラックリストに登録された連絡先はありません';

  @override
  String get switchAccountRecent => '最近のアカウント';

  @override
  String get switchAccountLoading => '最近のアカウントを読んでいます';

  @override
  String get switchAccountAddOther => '別のアカウントを追加またはログインします';

  @override
  String get switchAccountCurrent => '現在';

  @override
  String get appModulesLoading => '機能モジュールをロードしています';

  @override
  String get appModulesEmpty => '機能モジュールはありません';

  @override
  String get appModulesUnavailable => 'モジュールが使用できません';

  @override
  String get errorLogsLoading => 'エラー ログの読み取り';

  @override
  String get errorLogsEmpty => 'エラー ログはありません';

  @override
  String get errorLogFileName => 'ファイル名';

  @override
  String get errorLogFileSize => 'ファイルサイズ';

  @override
  String get errorLogGeneratedAt => 'で生成されました';

  @override
  String get errorLogFilePath => 'ファイルパス';

  @override
  String get notificationReceiveNew => '新しいメッセージの通知を受け取る';

  @override
  String get notificationSound => 'サウンド';

  @override
  String get notificationVibration => '振動';

  @override
  String get notificationShowDetails => '通知の詳細を表示';

  @override
  String get notificationSystem => 'システムメッセージ通知';

  @override
  String get notificationCalls => 'オーディオ/ビデオ通話通知';

  @override
  String get settingsGoToSystem => '設定';

  @override
  String aboutAppIconSemantic(Object appName) {
    return '$appName アイコン';
  }

  @override
  String aboutCopyright(Object appName) {
    return '著作権 © 2026\n$appName。無断転載を禁じます。';
  }

  @override
  String get policyWebUrl => 'Web URL';

  @override
  String get appearanceTitle => '外観';

  @override
  String get appearanceAppIcon => 'アプリアイコン';

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
  String get appearanceChatColor => 'チャットの色';

  @override
  String get appearanceBubbleRadius => 'バブルのコーナー半径';

  @override
  String get appearanceBubbleColorInk => 'インクブラック';

  @override
  String get appearanceSquare => 'スクエア';

  @override
  String get appearanceRound => 'ラウンド';

  @override
  String get appearancePreviewOne => '彼は私に右に曲がってほしいですか、それとも左に曲がってほしいですか? 🤔';

  @override
  String get appearancePreviewTwo => 'そうです。そして、まあ、それを強くしてください。';

  @override
  String get appearancePreviewThree => 'それだけですか?それ以上のことを言っていたような気がします。 😯';

  @override
  String get appearancePreviewFour => '以上です。後ほど詳細を音声メッセージでお知らせします。';

  @override
  String get contactsEmptyTitle => '連絡先はまだありません';

  @override
  String get contactsEmptySubtitle => '右上から友達を追加するか、プロフィール カードをスキャンします';

  @override
  String contactsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count の連絡先',
      one: '連絡先 1 件',
    );
    return '$_temp0';
  }

  @override
  String get contactAddTooltip => '友達を追加';

  @override
  String get contactSearchHint => '連絡先とグループを検索する';

  @override
  String get contactSetRemark => '備考の設定';

  @override
  String get contactAddToBlacklist => 'ブラックリストに追加';

  @override
  String get contactDeleteFriend => '友達を削除';

  @override
  String get contactAddedToBlacklist => 'ブラックリストに追加されました';

  @override
  String get operationFailed => '操作が失敗しました。もう一度やり直してください。';

  @override
  String operationFailedWithError(String error) {
    return '操作が失敗しました: $error';
  }

  @override
  String contactDeleteFriendConfirm(Object name) {
    return '友達「$name」を削除しますか?\nチャット履歴も消去されます。';
  }

  @override
  String get contactConfirmDelete => '削除の確認';

  @override
  String get contactDeleted => '友達が削除されました';

  @override
  String get contactUnknownUser => '不明なユーザー';

  @override
  String get contactActionNewFriends => '新しい友達';

  @override
  String get contactActionSavedGroups => '保存されたグループ';

  @override
  String get contactSearchNoMatches => '一致する連絡先がありません';

  @override
  String get addFriendTitle => '友達追加';

  @override
  String addFriendSearchHint(Object appName) {
    return '電話番号 / $appName ID';
  }

  @override
  String get addFriendNotFound => 'アカウントが見つかりません';

  @override
  String get myQrCodeTitle => '私の QR コード';

  @override
  String myQrCodeSubtitle(Object appName) {
    return 'この QR コードをスキャンして $appName に私を追加してください';
  }

  @override
  String get myQrCodeEmpty => 'QR コードがありません';

  @override
  String get scanTitle => 'スキャン';

  @override
  String get scanQrNotFound => 'QR コードが認識されませんでした';

  @override
  String scanResolveFailed(String error) {
    return 'QR コードの解析に失敗しました: $error';
  }

  @override
  String get scanUnrecognized => 'この QR コードは認識できません';

  @override
  String get scanInfoIncomplete => 'QRコード情報が不完全です';

  @override
  String get scanSocialUnavailable => 'ソーシャル サービスが初期化されていません';

  @override
  String get scanJoinedGroup => 'グループチャットに参加しました';

  @override
  String get scanCannotOpenGroup => 'このページではグループ チャットを開けません';

  @override
  String get scanGroupNotFound => 'グループ チャットが見つかりません';

  @override
  String get scanOpenGroupFailed => 'グループ チャットを開けませんでした';

  @override
  String get scanSelfQr => 'これはあなた自身の QR コードです';

  @override
  String get scanUserNotFound => 'ユーザーが見つかりません';

  @override
  String get scanCameraPermissionRequired => 'カメラの許可が必要です';

  @override
  String get scanOpenSettings => '設定を開く';

  @override
  String get scanCameraUnavailable => 'カメラが使用できません';

  @override
  String get scanAlbum => 'アルバム';

  @override
  String get scanLightOn => 'ライトオン';

  @override
  String get scanLightOff => 'ライトオフ';

  @override
  String get scanQrCode => 'QRコード';

  @override
  String get scanGroupFallback => 'グループチャット';

  @override
  String get scanGroupLoadingInfo => 'グループ情報を読み込み中';

  @override
  String scanGroupMemberCount(int count) {
    return '$count メンバー';
  }

  @override
  String get scanJoinGroupConfirm => 'グループチャットに参加する';

  @override
  String get scanJoining => '参加中';

  @override
  String get scanJoinGroup => 'グループチャットに参加する';

  @override
  String scanJoinFailed(String error) {
    return '参加できませんでした: $error';
  }

  @override
  String get tagsTitle => 'タグ';

  @override
  String get tagsCreateTooltip => '新しいタグ';

  @override
  String get tagsContactSection => '連絡先タグ';

  @override
  String get tagsEmptyTitle => 'タグがありません';

  @override
  String get tagsEmptySubtitle => '連絡先またはチャットをグループ化するには、右上の + をタップします。';

  @override
  String tagsCreateFailed(Object error) {
    return 'タグの作成に失敗しました: $error';
  }

  @override
  String tagsUpdateFailed(Object error) {
    return 'タグの更新に失敗しました: $error';
  }

  @override
  String tagsDeleteFailed(Object error) {
    return 'タグの削除に失敗しました: $error';
  }

  @override
  String tagsLoadFailed(Object error) {
    return 'タグのロードに失敗しました: $error';
  }

  @override
  String tagsDeleteConfirm(String name) {
    return 'タグ「$name」を削除しますか?\nこのタグ内の連絡先とグループは削除されません。';
  }

  @override
  String get tagsEditTitle => 'タグを編集';

  @override
  String get tagsCreateTitle => '新しいタグ';

  @override
  String get tagsNameSection => 'タグ名';

  @override
  String get tagsNameHint => '家族、友人';

  @override
  String tagsMembersSection(int count) {
    return 'タグメンバー ($count)';
  }

  @override
  String get tagsAddMember => 'メンバーを追加';

  @override
  String get tagsDelete => 'タグを削除';

  @override
  String get tagsGroupInitial => 'G';

  @override
  String get tagsUnknownUser => '不明なユーザー';

  @override
  String get tagsSelectMembersTitle => 'メンバーを選択';

  @override
  String tagsDoneCount(int count) {
    return '完了 ($count)';
  }

  @override
  String get tagsSearchHint => '連絡先またはグループを検索する';

  @override
  String get tagsGroupsSection => 'グループチャット';

  @override
  String get tagsContactsSection => '連絡先';

  @override
  String get tagsNoMatchesTitle => '一致するものはありません';

  @override
  String get tagsNoMatchesSubtitle => '別のキーワードを試してください';

  @override
  String tagsRowTitle(String name, int count) {
    return '$name ($count)';
  }

  @override
  String get phoneContactsTitle => '電話連絡先';

  @override
  String get phoneContactsSection => '電話連絡先から追加';

  @override
  String get phoneContactsEmpty => '電話連絡先がありません';

  @override
  String get phoneContactsNoAddable => '追加する電話連絡先がありません';

  @override
  String get phoneContactsServerSyncFailed => 'サーバーの同期に失敗しました。既存の連絡先を表示しています。';

  @override
  String get friendAlreadyAdded => '追加されました';

  @override
  String get friendRequestSent => '友達リクエストを送信しました';

  @override
  String phoneContactsInviteSmsBody(Object appName) {
    return '$appName を使用しています。チャット体験はかなりいいです。あなたも試してみてください。';
  }

  @override
  String get phoneContactsInviteOpened => 'SMS 招待が開かれました';

  @override
  String get phoneContactsInviteFailed => 'SMSを開けません。手動で招待してください。';

  @override
  String get friendRequestsEmptyTitle => '新しい友達はいません';

  @override
  String get friendRequestsEmptySubtitle => '友達を招待して QR コードをスキャンしてもらいます';

  @override
  String get friendRequestsPendingSection => '保留中';

  @override
  String get friendRequestRefused => '拒否されました';

  @override
  String contactOpenFromContacts(Object name) {
    return '連絡先から @$name のチャットを開きます';
  }

  @override
  String get fileHelperIntro =>
      'Web バージョンにログインし、メッセージを送信して、携帯電話とコンピュータ間でテキスト、写真、オーディオ、ビデオ、ファイルを転送します。';

  @override
  String get fileHelperName => 'File Transfer';

  @override
  String get systemAccountName => 'System';

  @override
  String systemAccountIntro(Object appName) {
    return '通知を送信するための公式 $appName アカウント。';
  }

  @override
  String get contactIntroTitle => 'はじめに';

  @override
  String get contactSource => 'ソース';

  @override
  String get contactRemoveFriendRelation => '友達を削除';

  @override
  String get contactRemoveFromBlacklist => 'ブラックリストから削除';

  @override
  String get contactSendMessage => 'メッセージ';

  @override
  String get contactAddToContacts => '連絡先に追加';

  @override
  String get contactRemoveFriendConfirm => 'この友達を削除しますか?';

  @override
  String contactNicknameLine(Object name) {
    return 'ニックネーム: $name';
  }

  @override
  String get contactRemoveFromBlacklistConfirm => 'この連絡先をブラックリストから削除しますか?';

  @override
  String get webLoginTitle => 'Web ログイン';

  @override
  String get webLoginConfirmTitle => 'Web ログインを確認しますか?';

  @override
  String get webLoginConfirmBody =>
      'これにより、アカウントが現在のブラウザまたはデスクトップ クライアントにログインできるようになります。あなた以外の場合は、「キャンセル」をタップしてください。';

  @override
  String get webLoginConfirmAction => 'ログインの確認';

  @override
  String get webLoginConfirming => '確認中...';

  @override
  String get webLoginConfirmed => 'Web ログインが確認されました';

  @override
  String webLoginConfirmFailed(Object error) {
    return '確認に失敗しました: $error';
  }

  @override
  String get applyFriendTitle => '友達リクエスト';

  @override
  String get applyFriendSectionTitle => '友達リクエストを送信';

  @override
  String get applyFriendRemarkHint => 'こんにちは、私は...';

  @override
  String friendRequestSendFailed(Object error) {
    return '送信に失敗しました: $error';
  }

  @override
  String get contactRemarkHint => '備考';

  @override
  String get momentPermissionsTitle => '瞬間のプライバシー';

  @override
  String get momentHideMineFromContact => '私の瞬間を彼らから隠す';

  @override
  String get momentHideContactFromMe => '彼らの瞬間を私から隠してください';

  @override
  String get momentTitle => '瞬間';

  @override
  String get momentPersonalEmpty => 'まだ投稿はありません';

  @override
  String get momentEmpty => 'まだ瞬間はありません';

  @override
  String get momentCoverUploadFailed => '表紙のアップロードに失敗しました';

  @override
  String momentCoverUploadFailedWithError(Object error) {
    return '表紙のアップロードに失敗しました: $error';
  }

  @override
  String get momentDeleteConfirm => 'このモーメントを削除しますか?';

  @override
  String get momentJustNow => 'たった今';

  @override
  String get momentPublishing => 'Posting…';

  @override
  String get momentPublishFailed => 'Failed to post. Tap to dismiss.';

  @override
  String get momentRemindedYou => 'このモーメントを閲覧するよう通知しました';

  @override
  String momentRemindedNames(Object names) {
    return '$names を思い出させました';
  }

  @override
  String get momentKeepEditingConfirm => 'この編集を保存しますか?';

  @override
  String get momentContinueEditing => '編集を続ける';

  @override
  String get momentSaveDraft => '下書きを保存';

  @override
  String get momentDiscardDraft => '破棄';

  @override
  String get momentPublishTitle => '投稿';

  @override
  String get momentPublishHint => '何を考えているのですか...';

  @override
  String get momentLocationTitle => '場所';

  @override
  String get momentRemindWho => 'リマインド';

  @override
  String get locationUnsupported => 'このバージョンでは位置情報を利用できません';

  @override
  String momentPrivacyContactCount(Object count, Object label) {
    return '$label · $count';
  }

  @override
  String get momentSelectVisibleContacts => '表示される連絡先を選択';

  @override
  String get momentSelectHiddenContacts => '非表示の連絡先を選択';

  @override
  String get momentPrivacyPublic => '公開';

  @override
  String get momentPrivacyPrivate => 'プライベート';

  @override
  String get momentPrivacyInternal => '一部の人に表示される';

  @override
  String get momentPrivacyProhibit => 'から隠す';

  @override
  String get momentPrivacyWhoCanSee => '誰が見ることができますか';

  @override
  String momentCommentFailed(Object error) {
    return 'コメントに失敗しました: $error';
  }

  @override
  String get momentDetailTitle => '詳細';

  @override
  String get momentDeleted => 'このモーメントは削除されました';

  @override
  String get momentCollapse => '折りたたむ';

  @override
  String get momentFullText => '全文';

  @override
  String get momentDeleteCommentConfirm => 'このコメントを削除しますか?';

  @override
  String get momentCommentPlaceholder => 'コメント';

  @override
  String momentReplyPlaceholder(Object name) {
    return '返信 $name';
  }

  @override
  String get momentLikeAction => 'いいね！';

  @override
  String get momentCommentAction => 'コメント';

  @override
  String momentNewMessages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 新しいメッセージ',
      one: '1 件の新しいメッセージ',
    );
    return '$_temp0';
  }

  @override
  String get messagesTitle => 'メッセージ';

  @override
  String get messagesEmpty => 'メッセージはありません';

  @override
  String get messagesEmptyTitle => 'まだメッセージはありません';

  @override
  String get messagesEmptySubtitle => '右上から新しいチャットを開始します';

  @override
  String get messagesNewConversation => '新規';

  @override
  String get messagesStartGroupChat => 'グループ チャットを開始する';

  @override
  String get messagesImDisconnected => 'IM が接続されていません';

  @override
  String get messagesPinned => '固定されました';

  @override
  String get messagesUnpinned => '固定解除';

  @override
  String get messagesMuted => 'ミュート';

  @override
  String get messagesNotificationsOn => 'に関する通知';

  @override
  String messagesDeleteConversationTitle(String name) {
    return '「$name」を削除しますか?';
  }

  @override
  String get messagesConfirmDelete => '削除';

  @override
  String get messagesCleared => 'チャット履歴が消去されました';

  @override
  String get messagesConversationDeleted => '会話が削除されました';

  @override
  String get messagesUnknownUser => '不明なユーザー';

  @override
  String get messagesFriendAvatarFallback => 'F';

  @override
  String get messagesGroupFallback => 'グループチャット';

  @override
  String get messagesGroupAvatarFallback => 'G';

  @override
  String get messagesNewMessageDigest => '[新しいメッセージ]';

  @override
  String get messagesConversationPin => 'ピン';

  @override
  String get messagesConversationUnpin => '固定を解除';

  @override
  String get messagesConversationMute => 'ミュート';

  @override
  String get messagesConversationUnmute => 'ミュートを解除';

  @override
  String get messagesConnectionNoNetwork => 'ネットワークが利用できません。接続を確認してください。';

  @override
  String get messagesConnectionDisconnected => '切断されました';

  @override
  String get messagesConnectionConnecting => '接続中';

  @override
  String get messagesConnectionSyncing => '同期中';

  @override
  String get globalSearchTitle => '検索';

  @override
  String get globalSearchTabChats => 'チャット';

  @override
  String get globalSearchTabContacts => '連絡先';

  @override
  String get globalSearchTabGroups => 'グループ';

  @override
  String get globalSearchTabFiles => 'ファイル';

  @override
  String get globalSearchContactsSection => '連絡先';

  @override
  String get globalSearchGroupsSection => 'グループチャット';

  @override
  String get globalSearchMessagesSection => 'チャット履歴';

  @override
  String get globalSearchFilesSection => 'ファイル';

  @override
  String get globalSearchNoMatches => '一致するものはありません';

  @override
  String get globalSearchNoMore => 'これ以上の結果はありません';

  @override
  String get locationLocating => '探しています...';

  @override
  String locationPermissionOff(Object appName) {
    return '位置情報の許可がオフになっています。システム設定で $appName が位置情報を使用できるようにします。';
  }

  @override
  String get locationPermissionDenied => '位置情報の許可が拒否されました。近くの場所は読み込めません。';

  @override
  String get locationMapUnsupported => 'AMap はこのプラットフォームではサポートされていません';

  @override
  String locationFailed(String error) {
    return '位置情報に失敗しました: $error';
  }

  @override
  String get locationSearchPrompt => 'キーワードを入力して近くの場所を検索します';

  @override
  String get locationNoNearbyPoi => '近くにPOIはありません';

  @override
  String get locationSearchHint => '近くの場所を検索';

  @override
  String get locationPickerTitle => '場所';

  @override
  String get locationSending => '送信中';

  @override
  String get locationUnnamed => '名前のない場所';

  @override
  String get locationCopiedAddress => 'アドレスがコピーされました';

  @override
  String get locationNoMapApp => '利用可能な地図アプリがありません';

  @override
  String get locationFallbackTitle => '場所';

  @override
  String get locationAmap => 'AMap';

  @override
  String get locationBaiduMap => '百度地図';

  @override
  String get locationTencentMap => 'テンセントマップ';

  @override
  String get locationAppleMap => 'Apple マップ';

  @override
  String get locationOtherMap => 'その他のマップ';

  @override
  String get locationMyLocation => '私の現在地';

  @override
  String locationOpenMapFailed(String name) {
    return '$name を開けません';
  }

  @override
  String get locationCopyAddress => 'アドレスをコピー';

  @override
  String get locationNavigate => 'ナビゲート';

  @override
  String get locationViewTitle => '地図';

  @override
  String get momentPeerCommentDeleted => 'コメントが削除されました';

  @override
  String get momentDigest => '[瞬間]';

  @override
  String get actionClose => '閉じる';

  @override
  String get saveToAlbum => 'アルバムに保存';

  @override
  String get savedToAlbum => 'アルバムに保存されました';

  @override
  String get saveFailed => '保存に失敗しました';

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
    return '$count 写真';
  }

  @override
  String get momentReplyConnector => 'さんが返信しました';

  @override
  String get groupRemarkTitle => 'グループのコメント';

  @override
  String get groupRemarkHint => '自分だけに表示されるグループ発言を設定する';

  @override
  String get chatNotificationSettingsTitle => 'メッセージ通知';

  @override
  String get chatScreenshotNotification => 'スクリーンショット通知';

  @override
  String get chatRevokeNotification => 'リコール通知';

  @override
  String get completeProfileTitle => '完全なプロフィール';

  @override
  String get completeProfileUploadAvatar => 'アバターをアップロード';

  @override
  String get completeProfileReuploadAvatar => '新しいアバターをアップロード';

  @override
  String get completeProfileChooseAvatar => 'プロフィール写真を選択してください';

  @override
  String get completeProfileAvatarUploaded => 'アバターがアップロードされました';

  @override
  String get completeProfileAvatarRequired => 'アバターは必須です。';

  @override
  String get nicknameLabel => 'ニックネーム';

  @override
  String get nicknameInputHint => 'ニックネームを入力してください';

  @override
  String get nicknameRequired => 'ニックネームは必須です。';

  @override
  String get completeProfileSaved => 'プロファイルが完了しました';

  @override
  String get chatSettingsTitle => 'チャットの詳細';

  @override
  String chatSettingsGroupTitle(Object count) {
    return 'チャット情報 ($count)';
  }

  @override
  String get chatSettingsGroupName => 'グループ チャット名';

  @override
  String get chatSettingsGroupQrCode => 'グループ QR コード';

  @override
  String get chatSearchContentTitle => 'チャットを検索';

  @override
  String get chatSettingsBackground => 'チャットの背景を設定する';

  @override
  String get chatSettingsBackgroundSelected => '現在のチャット背景セット';

  @override
  String get chatSettingsMute => '通知をミュートする';

  @override
  String get chatSettingsPin => 'チャットをピン留めする';

  @override
  String get chatSettingsSaveToContacts => '連絡先に保存';

  @override
  String get chatSettingsReadReceipt => '開封確認';

  @override
  String get chatSettingsReadReceiptSubtitle =>
      '有効にすると、送信されたメッセージに既読/未読ステータスが表示されます';

  @override
  String get chatSettingsFlame => '読んだ後に書き込みます';

  @override
  String get chatFlameTipExit => 'チャットを終了すると既読メッセージが破棄される';

  @override
  String chatFlameTipMinutes(Object minutes) {
    return 'メッセージは読み取られてから $minutes 分後に破棄されます';
  }

  @override
  String chatFlameTipSeconds(Object seconds) {
    return 'メッセージは読み取られてから $seconds 秒後に破棄されます';
  }

  @override
  String chatFlameLabelMinutes(Object minutes) {
    return '$minutes 分';
  }

  @override
  String chatFlameLabelSeconds(Object seconds) {
    return '${seconds}s';
  }

  @override
  String get chatSettingsGroupNickname => '私のグループのニックネーム';

  @override
  String get chatSettingsBlacklisted => 'ブラックリストに登録されました';

  @override
  String get chatSettingsPeerBlacklisted => 'この連絡先はすでにブラックリストに登録されています';

  @override
  String get chatSettingsComplaint => 'レポート';

  @override
  String get chatSettingsDeleteAndExit => '削除して終了';

  @override
  String groupRemarkSyncFailed(Object error) {
    return 'グループのコメントを同期できませんでした: $error';
  }

  @override
  String get chatSocialDisconnected => 'ソーシャル サービスが接続されていません';

  @override
  String get chatNoRemovableMembers => '取り外し可能なメンバーはありません';

  @override
  String get chatSelectMembersToRemove => '削除するメンバーを選択してください';

  @override
  String chatMemberNameQuoted(Object name) {
    return '「$name」';
  }

  @override
  String chatMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count メンバー',
      one: 'メンバー 1 人',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersConfirm(Object names) {
    return '$names をグループから削除します';
  }

  @override
  String chatMembersRemoved(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count メンバーを削除しました',
      one: '1 人のメンバーを削除しました',
    );
    return '$_temp0';
  }

  @override
  String chatRemoveMembersFailed(Object error) {
    return 'メンバーの削除に失敗しました: $error';
  }

  @override
  String get chatNoInviteCandidates => '招待できる連絡先がありません';

  @override
  String get chatInviteMembers => 'メンバーを招待';

  @override
  String get chatSelectContacts => '連絡先を選択';

  @override
  String chatMembersInvited(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count メンバーを招待しました',
      one: '1 人のメンバーを招待しました',
    );
    return '$_temp0';
  }

  @override
  String chatInviteMembersFailed(Object error) {
    return 'メンバーを招待できませんでした: $error';
  }

  @override
  String get chatGroupCreated => 'グループ チャットが作成されました。チャットリストを確認してください。';

  @override
  String get chatGroupCreateFailed => 'グループ チャットの作成に失敗しました';

  @override
  String chatGroupCreateFailedWithError(Object error) {
    return 'グループ チャットの作成に失敗しました: $error';
  }

  @override
  String get chatClearCurrentConfirm => '現在のチャット履歴をクリアしますか?';

  @override
  String get chatDeleteAndExitConfirm => '削除して終了すると、このグループからメッセージを受信しなくなります。';

  @override
  String get chatBlockConfirm => 'この連絡先をブラックリストに追加すると、メッセージを受信できなくなります。';

  @override
  String get chatSearchTabAll => 'チャット';

  @override
  String get chatSearchTabMedia => '写真/ビデオ';

  @override
  String get chatSearchTabFile => 'ファイル';

  @override
  String get chatSearchNoMatches => '一致するチャット履歴はありません';

  @override
  String get chatSearchNoMore => 'これ以上の結果はありません';

  @override
  String get chatDetailsTooltip => 'チャットの詳細';

  @override
  String get chatVoiceInputTooltip => '音声入力';

  @override
  String get chatInputHint => 'メッセージ...';

  @override
  String get chatFlameEnabledTooltip => '読み取り後の書き込みがオンになっています';

  @override
  String get chatFlameDestroyOnExit => 'チャットを終了した後に破棄します';

  @override
  String chatFlameDestroyAfterMinutes(Object minutes) {
    return '$minutes分後に破棄';
  }

  @override
  String chatFlameDestroyAfterSeconds(Object seconds) {
    return '$seconds秒後に破棄';
  }

  @override
  String chatFlameEnabledNotice(Object label) {
    return '読み取り後に書き込みがオンになっています。メッセージは読み取り後に $label 破棄されます。右上の設定を使用してオフにします。';
  }

  @override
  String get chatEmojiTooltip => '絵文字';

  @override
  String get chatActionReply => '返信';

  @override
  String get chatActionCopy => 'コピー';

  @override
  String get chatActionTranslate => '翻訳';

  @override
  String get chatActionTranscribe => '文字起こし';

  @override
  String get chatActionForward => '前へ';

  @override
  String get chatActionFavorite => 'お気に入り';

  @override
  String get chatActionPin => 'ピン';

  @override
  String get chatActionUnpin => '固定を解除';

  @override
  String get chatActionAddFriend => '友達を追加';

  @override
  String get chatActionMultiSelect => '選択してください';

  @override
  String get chatActionEdit => '編集';

  @override
  String get chatActionEditImage => '画像を編集';

  @override
  String get chatActionRevoke => 'リコール';

  @override
  String get chatActionDelete => '削除';

  @override
  String get chatGroupCallActive => 'グループ通話中です';

  @override
  String chatMessageRevokedBy(Object name) {
    return '$name がメッセージを取り消しました';
  }

  @override
  String get chatReedit => '再編集';

  @override
  String get chatEditedSuffix => '(編集済み)';

  @override
  String chatActionReadBy(Object count) {
    return '$count による読み取り';
  }

  @override
  String chatActionReactedBy(Object count) {
    return '$count の反応';
  }

  @override
  String chatSelectedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '選択された $count アイテム',
      one: '1 個のアイテムが選択されました',
    );
    return '$_temp0';
  }

  @override
  String get chatNoReactions => 'まだ反応がありません';

  @override
  String chatReadStatusReadCount(Object count) {
    return '読み取り ($count)';
  }

  @override
  String get chatNoReadReceipts => 'まだありません';

  @override
  String get chatHistoryAbove => '上記の以前のメッセージ';

  @override
  String chatUnreadNewMessages(Object count) {
    return '$count 新しいメッセージ';
  }

  @override
  String get chatUnreadDivider => '以下の新しいメッセージ';

  @override
  String get chatUnknownContentFallback =>
      'このバージョンではこのメッセージを表示できません。最新バージョンにアップデートしてください。';

  @override
  String get chatMentionSomeone => '誰かがあなたについて言及しました';

  @override
  String get chatToolAlbum => 'アルバム';

  @override
  String get chatToolCamera => 'カメラ';

  @override
  String get chatToolFile => 'ファイル';

  @override
  String get chatToolLocation => '場所';

  @override
  String get chatToolContactCard => '連絡先カード';

  @override
  String get chatToolAudioCall => '音声通話';

  @override
  String get chatToolVideoCall => 'ビデオ通話';

  @override
  String get chatDraftLabel => '[ドラフト]';

  @override
  String get visitorBadge => '訪問者';

  @override
  String get chatNoticeDeleted => '削除されました';

  @override
  String get chatNoticeCopied => 'コピーしました';

  @override
  String get chatMentionLoadedOrInvisible =>
      '@ メッセージが読み込まれているか、表示されません。上にスクロールして見つけてください。';

  @override
  String get chatLocationDefaultTitle => '場所';

  @override
  String get chatLocationCopied => '場所をコピーしました';

  @override
  String get chatReadStatusTitle => 'ステータスの読み取り';

  @override
  String get chatReadStatusRead => '読む';

  @override
  String get chatReadStatusUnread => '未読';

  @override
  String get chatReadStatusUnavailable => '完全な既読/未読リストはまだ利用できません';

  @override
  String get chatComposerLeft => 'このチャットから退出しました';

  @override
  String get chatComposerMuted => 'このチャットはミュートされています';

  @override
  String chatComposerMutedUntil(Object time) {
    return '$time までミュートされます';
  }

  @override
  String chatFavoriteCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'お気に入りの $count メッセージ',
      one: '1 件のメッセージをお気に入りに追加しました',
    );
    return '$_temp0';
  }

  @override
  String chatFavoritePartial(Object failed, Object success) {
    return 'お気に入りが完了しました: $success は成功しました、$failed は失敗しました';
  }

  @override
  String get chatForwardUnavailable => '現在転送できません';

  @override
  String chatMergedForwardedTo(Object count, Object name) {
    return '$count メッセージを $name に統合しました';
  }

  @override
  String chatForwardedIndividuallyTo(Object count, Object name) {
    return '$count メッセージを $name に 1 つずつ転送しました';
  }

  @override
  String chatForwardedPartialTo(Object name, Object sent, Object total) {
    return '$sent/$total メッセージを $name に転送しました';
  }

  @override
  String get chatForwardModeIndividual => '1 つずつ転送';

  @override
  String get chatForwardModeMerge => 'マージして転送';

  @override
  String get chatPresenceOnline => 'オンライン';

  @override
  String get chatPresenceOffline => 'オフライン';

  @override
  String get chatPresenceJustActive => '現在アクティブです';

  @override
  String chatPresenceMinutesAgo(Object minutes) {
    return 'アクティブ $minutes 分前';
  }

  @override
  String chatPresenceHoursAgo(Object hours) {
    return 'アクティブ $hours 時間前';
  }

  @override
  String chatPresenceDaysAgo(Object days) {
    return '$days日前にアクティブになりました';
  }

  @override
  String get chatSensitiveDefaultTip => 'このメッセージには機密情報が含まれている可能性があります';

  @override
  String get chatMessageDigestFallback => '[メッセージ]';

  @override
  String get chatMediaServiceUnavailable => 'メディア サービスの準備ができていません';

  @override
  String get chatImDisconnected => 'IM が接続されていません';

  @override
  String get chatPinFailedNotSent => 'メッセージがサーバーに到達する前にピン留めできません';

  @override
  String get chatPinFailed => '固定に失敗しました。もう一度やり直してください。';

  @override
  String get chatPinned => '固定されました';

  @override
  String get chatUnpinFailed => '固定を解除できませんでした。もう一度やり直してください。';

  @override
  String get chatUnpinned => '固定解除';

  @override
  String get chatClearPinnedConfirm => '固定されたメッセージをすべて固定解除しますか?';

  @override
  String get chatClearPinnedAction => '固定を解除';

  @override
  String get chatAllUnpinned => '固定されたすべてのメッセージの固定が解除されました';

  @override
  String get chatPinnedMessageNotVisible =>
      'This message is not in the visible range.一覧からご覧ください。';

  @override
  String get chatImageMissing => '画像情報がありません';

  @override
  String get chatImageDownloadFailedEdit => '画像のダウンロードに失敗しました。編集できません。';

  @override
  String get chatReactionFailed => '反応が失敗しました。もう一度やり直してください。';

  @override
  String get chatEditNotSynced => '編集に失敗しました: メッセージが同期されていません';

  @override
  String get chatEditFailed => '編集に失敗しました。もう一度やり直してください。';

  @override
  String get chatFavoriteUnsupportedType => 'このタイプはまだお気に入りに登録できません';

  @override
  String get chatFavoriteNotSent => 'メッセージがサーバーに届いていないため、お気に入りに登録できません';

  @override
  String get chatFavoriteSuccess => 'お気に入りに追加されました';

  @override
  String get chatFavoriteFailed => 'お気に入りに登録できませんでした。もう一度やり直してください。';

  @override
  String chatToolSelected(Object title) {
    return '$title が選択されました';
  }

  @override
  String chatCardDigest(Object name) {
    return '[カード] $name';
  }

  @override
  String get chatFriendAvatarFallback => 'F';

  @override
  String get chatUnknownMessageDigest => '[不明]';

  @override
  String chatOpenFromContacts(Object name) {
    return '連絡先から @$name のチャットを開きます';
  }

  @override
  String get chatLoadingCard => '連絡先カードを読み込み中...';

  @override
  String get chatFileMissing => 'ファイル情報がありません';

  @override
  String get chatVideoUnavailable => 'ビデオを再生できません';

  @override
  String get chatVideoSourceEmpty => 'ビデオ ソースが空です';

  @override
  String get chatLivePhotoUnavailable => 'Live Photo を再生できません';

  @override
  String get messageAiTranslating => '翻訳中...';

  @override
  String get messageAiTranscribedShort => '完了';

  @override
  String get messageAiVoiceSendingWait => '音声はまだ送信中です。後でもう一度試してください。';

  @override
  String get messageAiNoTranscript => '音声が認識されませんでした';

  @override
  String get messageAiMessageSendingWait => 'メッセージはまだ送信中です。後でもう一度試してください。';

  @override
  String get messageAiNoTranslation => '翻訳結果がありません';

  @override
  String get messageAiTemporarilyUnavailable => '一時的に利用できません';

  @override
  String get chatVoiceFileUnavailable => '音声ファイルが利用できません';

  @override
  String get chatVoicePlayFailed => '再生に失敗しました。もう一度やり直してください。';

  @override
  String get chatVoiceHoldToRecord => '長押しして録音 · 上にスライドしてキャンセル';

  @override
  String chatVoiceReleaseToCancel(Object duration) {
    return 'リリースしてキャンセル ($duration)';
  }

  @override
  String chatVoiceRecordingSlideCancel(Object duration) {
    return '$duration · 上にスライドしてキャンセルします';
  }

  @override
  String get chatQrcodeNotFound => 'QR コードが認識されませんでした';

  @override
  String chatWebLoginQrcodeDetected(Object payload) {
    return 'Web ログイン QR コードが認識されました\n$payload';
  }

  @override
  String get chatWebLoginConfirmTitle => 'Web でのログインを確認しますか?';

  @override
  String get chatWebLoginConfirmAction => 'Web ログインを確認';

  @override
  String get chatWebLoginConfirmed => 'Web ログインが確認されました';

  @override
  String chatQrcodeDetected(Object payload) {
    return 'QR コードが認識されました\n$payload';
  }

  @override
  String get chatStickerPlaceholder => '【ステッカー】';

  @override
  String get chatStickerAdded => 'Added to stickers';

  @override
  String get chatStickerAddFailed => 'ステッカーの追加に失敗しました。もう一度やり直してください。';

  @override
  String get mentionAllMembers => 'メンバー全員';

  @override
  String get mentionAllMembersSubtitle => 'このグループの全員に通知';

  @override
  String get chatQuoteOriginalRevoked => '元のメッセージが取り消されました';

  @override
  String get chatRecognizeImageQrcode => '画像内の QR コードをスキャンします';

  @override
  String get chatAddToStickers => 'ステッカーに追加';

  @override
  String get chatGroupInviteApprovalUrlEmpty => 'グループ招待の承認 URL が空です';

  @override
  String get chatGroupInviteApprovalTitle => 'グループ招待の承認';

  @override
  String get chatGroupInviteApprovalBody => 'Web ページでグループ招待の確認を完了します。';

  @override
  String get chatGroupInviteGoConfirm => '確認';

  @override
  String get chatGroupInviteApprovalOpenFailed =>
      'グループ招待の承認を開くことができませんでした。もう一度やり直してください。';

  @override
  String get chatSendFailed => '送信に失敗しました。もう一度やり直してください。';

  @override
  String get chatCallActiveHangupFirst => '通話中です。まず電話を切ります。';

  @override
  String get chatCallActiveCannotJoinAgain => '通話中です。再度参加することはできません。';

  @override
  String get chatCallUnsupported => 'このバージョンでは通話はサポートされていません';

  @override
  String get chatCallServiceUnavailable => '通話サービスの準備ができていません';

  @override
  String get chatCallJoinFailedEnded => '参加できませんでした。通話が終了した可能性があります。';

  @override
  String get callWaitingAnswer => '回答を待っています';

  @override
  String get callMessage => '通話メッセージ';

  @override
  String get callEnded => '通話が終了しました';

  @override
  String get callPeerRefused => 'ピアが拒否されました';

  @override
  String get callPeerHungUp => 'ピアが電話を切りました';

  @override
  String get callPeerDeclinedVideoSwitch => 'ピアがビデオ切り替え要求を拒否しました';

  @override
  String get callSwitchVideoRequestTitle => 'ピアがビデオへの切り替えを要求しました';

  @override
  String get callAgree => '同意する';

  @override
  String get callReconnecting => '再接続中…';

  @override
  String get callWaitingPeerCamera => 'ピアカメラを待っています';

  @override
  String get callSelfFallbackName => '私';

  @override
  String get callUnknownUser => '不明なユーザー';

  @override
  String callJoinedCount(int joined, int total) {
    return '$joined/$total が参加しました';
  }

  @override
  String get callMute => 'ミュート';

  @override
  String get callSpeaker => 'スピーカー';

  @override
  String get callSwitchToVideo => 'ビデオ';

  @override
  String get callHangup => '電話を切る';

  @override
  String get callFlipCamera => 'フリップ';

  @override
  String get callSwitchToVoice => 'オーディオ';

  @override
  String get callCamera => 'カメラ';

  @override
  String get callBack => '戻る';

  @override
  String get callPermissionMicrophone => 'マイク';

  @override
  String get callPermissionMicrophoneCamera => 'マイクとカメラ';

  @override
  String callPermissionOpenSettings(String what) {
    return 'システム設定で $what 権限を有効にします';
  }

  @override
  String callPermissionRequired(String what) {
    return '呼び出しには $what 権限が必要です';
  }

  @override
  String get callWaitingPeerConsent => 'ピアの承認を待っています';

  @override
  String get callSwitchRequestFailed => '切り替えリクエストの送信に失敗しました';

  @override
  String get callCameraPermissionRequired => 'カメラの許可が必要です';

  @override
  String get callCameraEnableFailed => 'カメラをオンにできませんでした';

  @override
  String get incomingCallAccepting => '応答中...';

  @override
  String get incomingVideoCall => 'からビデオ通話に招待されます';

  @override
  String get incomingAudioCall => 'は音声通話に招待します';

  @override
  String incomingAcceptFailed(String error) {
    return '回答は失敗しました: $error';
  }

  @override
  String get incomingCallDecline => '拒否';

  @override
  String get incomingCallAccept => '回答';

  @override
  String get chatGroupNoInviteCandidates => '招待できるメンバーがいません';

  @override
  String get chatInviteGroupMembersVideo => 'グループメンバーを招待する (ビデオ通話)';

  @override
  String get chatInviteGroupMembersAudio => 'グループメンバーを招待（音声通話）';

  @override
  String get chatSelfName => '私';

  @override
  String get chatPeerPlaceholder => 'その他';

  @override
  String get chatSomeonePlaceholder => '誰か';

  @override
  String chatScreenshotNotice(Object name) {
    return '$name がチャットでスクリーンショットを撮りました';
  }

  @override
  String chatDuplicateGroupMention(Object name) {
    return '複数のグループ メンバーが @$name と一致します';
  }

  @override
  String chatDuplicateContactMention(Object name) {
    return '複数の連絡先が @$name と一致します';
  }

  @override
  String chatMentionNotFound(Object name) {
    return '@$name が見つかりません';
  }

  @override
  String get chatForwardPickerTitle => '転送先';

  @override
  String get chatRecentContactsSection => '最近の連絡先';

  @override
  String chatForwardedTo(Object name) {
    return '$name に転送されました';
  }

  @override
  String get favoriteTitle => 'お気に入り';

  @override
  String get favoriteEmptyTitle => 'お気に入りはありません';

  @override
  String get favoriteEmptySubtitle => 'チャット内のメッセージを長押しし、[お気に入り] を選択してここに保存します。';

  @override
  String get favoriteDeleted => '削除されました';

  @override
  String favoriteDeleteFailed(Object error) {
    return '削除に失敗しました: $error';
  }

  @override
  String get favoriteDeleteFailedPlain => '削除に失敗しました';

  @override
  String get favoriteUnsupportedSend => 'このタイプはまだ送信できません';

  @override
  String favoriteSentTo(String name) {
    return '$name に送信されました';
  }

  @override
  String favoriteSendFailed(Object error) {
    return '送信失敗: $error';
  }

  @override
  String get favoriteSendFailedPlain => '送信に失敗しました';

  @override
  String get favoriteSendToFriend => '友達に送信';

  @override
  String get favoriteCopied => 'コピーしました';

  @override
  String get favoriteUnknownUser => '不明なユーザー';

  @override
  String favoriteDateMonthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String get groupSavedTitle => '保存されたグループ';

  @override
  String get groupSaveTooltip => 'グループを保存';

  @override
  String get groupSearchHint => 'グループを検索';

  @override
  String get groupNoMatched => '一致するグループがありません';

  @override
  String get groupNoSaveCandidatesToast => '保存できるグループがありません';

  @override
  String get groupSavedToContacts => '連絡先に保存されました';

  @override
  String groupSaveFailed(Object error) {
    return '保存に失敗しました: $error';
  }

  @override
  String get groupSelectTitle => 'グループの選択';

  @override
  String get groupNoSaveCandidates => '保存できるグループがありません';

  @override
  String get groupCreateTitle => 'グループ チャットを開始する';

  @override
  String get groupSearchContactsHint => '連絡先を検索';

  @override
  String get groupNoMatchedContacts => '一致する連絡先がありません';

  @override
  String groupMemberSummary(num count, Object subtitle) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count メンバー',
      one: 'メンバー 1 人',
    );
    return '$_temp0· $subtitle';
  }

  @override
  String get groupMuted => 'ミュート';

  @override
  String get groupDetailsTitle => 'グループの詳細';

  @override
  String groupMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count メンバー',
      one: 'メンバー 1 人',
    );
    return '$_temp0';
  }

  @override
  String get groupMembersSection => 'グループメンバー';

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
  String get groupNoMembers => 'グループメンバーがいません';

  @override
  String get groupInviteMembers => 'メンバーを招待';

  @override
  String get groupInviteMembersSubtitle => '連絡先から選択';

  @override
  String get groupRemoveMembers => 'メンバーの削除';

  @override
  String get groupRemoveMembersEmptySubtitle => '削除するメンバーがありません';

  @override
  String get groupRemoveMembersSubtitle => '削除するメンバーを選択してください';

  @override
  String get groupQrCodeTitle => 'グループ QR コード';

  @override
  String get groupQrCodeSubtitle => 'スキャンしてこのグループに参加してください';

  @override
  String get groupNameTitle => 'グループ名';

  @override
  String get groupNoticeTitle => 'グループのお知らせ';

  @override
  String get groupNoticeUnset => '未設定';

  @override
  String get groupManageTitle => 'グループ管理';

  @override
  String get groupManageSubtitle => '管理者、ミュート、およびグループの権限';

  @override
  String get groupInviteConfirm => '招待の確認';

  @override
  String get groupBlacklistTitle => 'グループ ブラックリスト';

  @override
  String get groupBlacklistSubtitle => '発言または参加をブロックされたメンバーを管理する';

  @override
  String get groupSaveToContacts => '連絡先に保存';

  @override
  String get groupMuteMessages => '通知をミュートする';

  @override
  String get groupExited => 'グループチャットから退出しました';

  @override
  String get groupExitAction => 'グループを脱退';

  @override
  String groupMembersSyncFailed(Object error) {
    return 'グループメンバーを同期できませんでした: $error';
  }

  @override
  String get groupInvitePickerTitle => '招待するメンバーを選択してください';

  @override
  String groupInviteSentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 人のメンバー招待を送信しました',
      one: '1 人のメンバー招待を送信しました',
    );
    return '$_temp0';
  }

  @override
  String groupInvitedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count メンバーを招待しました',
      one: '1 人のメンバーを招待しました',
    );
    return '$_temp0';
  }

  @override
  String groupInviteMembersFailed(Object error) {
    return 'メンバーを招待できませんでした: $error';
  }

  @override
  String get groupRemovePickerTitle => '削除するメンバーを選択してください';

  @override
  String groupQuotedMemberName(Object name) {
    return '「$name」';
  }

  @override
  String groupSelectedMemberCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count メンバー',
      one: 'メンバー 1 人',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersConfirm(Object target) {
    return '$target をこのグループから削除しますか?';
  }

  @override
  String get groupRemoveAction => '削除';

  @override
  String groupRemovedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count メンバーを削除しました',
      one: '1 人のメンバーを削除しました',
    );
    return '$_temp0';
  }

  @override
  String groupRemoveMembersFailed(Object error) {
    return 'メンバーの削除に失敗しました: $error';
  }

  @override
  String get groupSettingsUpdated => 'グループ設定が更新されました';

  @override
  String groupSettingsUpdateFailed(Object error) {
    return 'グループ設定を更新できませんでした: $error';
  }

  @override
  String get groupExitConfirm => '退会後は、このグループからメッセージを受信しなくなります。';

  @override
  String get groupExitSuccess => 'グループチャットから退出しました';

  @override
  String groupExitFailed(Object error) {
    return '退出できませんでした: $error';
  }

  @override
  String get groupOwnerAdminSection => '所有者と管理者';

  @override
  String get groupOwnerRole => 'オーナー';

  @override
  String get groupAdminRole => '管理者';

  @override
  String get groupRemove => '削除';

  @override
  String get groupAddAdmin => 'グループ管理者の追加';

  @override
  String get groupNoAdmins => '管理者がいません';

  @override
  String get groupInviteConfirmRemark =>
      '有効にすると、メンバーは友人を招待する前に所有者または管理者の承認が必要になります。 QRコードによる参加も無効となります。';

  @override
  String get groupOwnerTransfer => '所有権の譲渡';

  @override
  String get groupMemberSettingsSection => 'メンバー設定';

  @override
  String get groupAllMutedRemark => '全メンバーのミュートが有効になっている場合、所有者と管理者のみが発言できます。';

  @override
  String get groupAllMuted => 'すべてのメンバーをミュート';

  @override
  String get groupForbiddenAddFriendRemark =>
      '有効にすると、メンバーはこのグループを通じて友達を追加できなくなります。';

  @override
  String get groupForbiddenAddFriend => 'メンバーによる友達の追加をブロックする';

  @override
  String get groupAllowHistoryRemark => '有効にすると、新しいメンバーは以前のチャット履歴を表示できます。';

  @override
  String get groupAllowHistory => '新しいメンバーに履歴の表示を許可する';

  @override
  String get groupAddAdminPickerTitle => 'グループ管理者の追加';

  @override
  String groupAdminAddedCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 管理者を追加しました',
      one: '管理者を 1 人追加しました',
    );
    return '$_temp0';
  }

  @override
  String groupAddAdminFailed(Object error) {
    return '管理者の追加に失敗しました: $error';
  }

  @override
  String groupRemoveAdminConfirm(Object name) {
    return '「$name」から管理者の役割を削除しますか?';
  }

  @override
  String get groupRemoveAdminAction => '管理者の削除';

  @override
  String get groupRemoveAdminSuccess => '管理者が削除されました';

  @override
  String groupRemoveAdminFailed(Object error) {
    return '管理者の削除に失敗しました: $error';
  }

  @override
  String get groupSelectNewOwner => '新しい所有者を選択してください';

  @override
  String groupTransferOwnerConfirm(Object name) {
    return '所有権を「$name」に譲渡しますか?正会員となります。';
  }

  @override
  String get groupTransferOwnerAction => '転送の確認';

  @override
  String get groupOwnerTransferred => '所有権が譲渡されました';

  @override
  String groupOwnerTransferFailed(Object error) {
    return '所有権の譲渡に失敗しました: $error';
  }

  @override
  String get groupNoticePublisherDefault => 'グループのお知らせ';

  @override
  String get groupNoticePublishTitle => 'グループ発表の投稿';

  @override
  String get groupNoticeEditTitle => 'グループアナウンスの編集';

  @override
  String get groupNoticePublishAction => '投稿';

  @override
  String get groupNoticeEmpty => 'グループのアナウンスはありません';

  @override
  String get groupNoticePublishedAtUnknown => '公開時期不明';

  @override
  String get groupMemberRemarkTitle => 'このグループでの私のニックネーム';

  @override
  String get groupMemberRemarkHint => 'このグループにニックネームを設定してください';

  @override
  String get groupQrCodeEmpty => 'グループ QR コードがありません';

  @override
  String groupQrCodeValid(Object day, Object expire) {
    return 'この QR コードは $day 日間有効です ($expire)';
  }

  @override
  String get groupQrCodeScanToJoin => 'QR コードをスキャンしてこのグループに参加してください';

  @override
  String get groupBlacklistLoadFailed => 'ブラックリストのロードに失敗しました。もう一度やり直してください。';

  @override
  String get groupBlacklistEmpty => 'ブラックリストに登録されたメンバーはいません';

  @override
  String get groupBlacklistAddMember => 'ブラックリスト メンバーを追加';

  @override
  String get groupBlacklistNoCandidates => 'ブラックリストにメンバーを追加できません';

  @override
  String get groupSelectMember => 'メンバーを選択';

  @override
  String get groupBlacklistAdded => 'ブラックリストに追加されました';

  @override
  String get groupBlacklistAddFailed => 'ブラックリストへの追加に失敗しました。もう一度やり直してください。';

  @override
  String groupBlacklistRemoveConfirm(Object name) {
    return 'グループのブラックリストから「$name」を削除しますか?';
  }

  @override
  String get groupBlacklistRemoveAction => 'ブラックリストから削除';

  @override
  String get groupBlacklistRemoveFailed => 'ブラックリストからの削除に失敗しました。もう一度やり直してください。';

  @override
  String get groupAvatarTitle => 'グループアバター';

  @override
  String get groupAvatarTakePhoto => '写真を撮る';

  @override
  String get groupAvatarChooseFromAlbum => 'アルバムから選択';

  @override
  String get groupAvatarSaveImage => '画像を保存';

  @override
  String get groupAvatarUnsupported => 'このチャットはグループ アバターの変更をサポートしていません';

  @override
  String get groupAvatarUpdated => 'グループアバターが更新されました';

  @override
  String get groupAvatarUpdateFailed => 'グループアバターの更新に失敗しました。もう一度やり直してください。';

  @override
  String get groupAvatarNoImageToSave => '保存するアバターがありません';

  @override
  String groupPhotoPermissionRequired(Object appName) {
    return '$appName にあなたの写真へのアクセスを許可します';
  }

  @override
  String get groupImageSavedToAlbum => 'アルバムに保存されました';

  @override
  String get groupImageSaveFailed => '保存に失敗しました。もう一度やり直してください。';

  @override
  String get imageEditorProcessing => '処理中...';

  @override
  String get imageEditorDiscardTitle => '編集を破棄しますか?';

  @override
  String get imageEditorDiscardMessage => '保存されていない編集内容は失われます。';

  @override
  String get imageEditorDiscardConfirm => '破棄';

  @override
  String get imageEditorPaint => '描画';

  @override
  String get imageEditorFreestyle => 'Freehand';

  @override
  String get imageEditorArrow => '矢印';

  @override
  String get imageEditorLine => 'ライン';

  @override
  String get imageEditorRectangle => '長方形';

  @override
  String get imageEditorCircle => 'サークル';

  @override
  String get imageEditorDashLine => '破線';

  @override
  String get imageEditorMoveAndZoom => '移動/ズーム';

  @override
  String get imageEditorEraser => '消しゴム';

  @override
  String get imageEditorLineWidth => '幅';

  @override
  String get imageEditorToggleFill => '塗りつぶし';

  @override
  String get imageEditorOpacity => '不透明度';

  @override
  String get imageEditorUndo => '元に戻す';

  @override
  String get imageEditorRedo => 'やり直し';

  @override
  String get imageEditorInputHint => 'テキストを入力してください';

  @override
  String get imageEditorText => 'テキスト';

  @override
  String get imageEditorTextAlign => '整列';

  @override
  String get imageEditorBackground => '背景';

  @override
  String get imageEditorFontScale => 'フォントサイズ';

  @override
  String get imageEditorCrop => '作物';

  @override
  String get imageEditorRotate => '回転';

  @override
  String get imageEditorRatio => '比率';

  @override
  String get imageEditorReset => 'リセット';

  @override
  String get imageEditorFlip => 'フリップ';

  @override
  String get imageEditorFilter => 'フィルター';

  @override
  String get imageEditorFilterNone => 'オリジナル';

  @override
  String get imageEditorFilterAddictiveBlue => 'アディクティブブルー';

  @override
  String get imageEditorFilterAddictiveRed => 'アディクティブレッド';

  @override
  String get imageEditorFilterAden => 'アデン';

  @override
  String get imageEditorFilterAmaro => 'アマロ';

  @override
  String get imageEditorFilterAshby => 'アシュビー';

  @override
  String get imageEditorFilterBrannan => 'ブラナン';

  @override
  String get imageEditorFilterBrooklyn => 'ブルックリン';

  @override
  String get imageEditorFilterCharmes => 'チャーム';

  @override
  String get imageEditorFilterClarendon => 'クラレンドン';

  @override
  String get imageEditorFilterCrema => 'クレマ';

  @override
  String get imageEditorFilterDogpatch => 'ドッグパッチ';

  @override
  String get imageEditorFilterEarlybird => 'アーリーバード';

  @override
  String get imageEditorFilterGingham => 'ギンガムチェック';

  @override
  String get imageEditorFilterGinza => '銀座';

  @override
  String get imageEditorFilterHefe => 'ヘフェ';

  @override
  String get imageEditorFilterHelena => 'ヘレナ';

  @override
  String get imageEditorFilterHudson => 'ハドソン';

  @override
  String get imageEditorFilterInkwell => 'インク壺';

  @override
  String get imageEditorFilterJuno => 'ジュノ';

  @override
  String get imageEditorFilterKelvin => 'ケルビン';

  @override
  String get imageEditorFilterLark => 'ヒバリ';

  @override
  String get imageEditorFilterLoFi => 'ローファイ';

  @override
  String get imageEditorFilterLudwig => 'ルートヴィヒ';

  @override
  String get imageEditorFilterMaven => 'メイブン';

  @override
  String get imageEditorFilterMayfair => 'メイフェア';

  @override
  String get imageEditorFilterMoon => '月';

  @override
  String get imageEditorFilterNashville => 'ナッシュビル';

  @override
  String get imageEditorFilterPerpetua => 'パーペチュア';

  @override
  String get imageEditorFilterReyes => 'レイエス';

  @override
  String get imageEditorFilterRise => '上昇';

  @override
  String get imageEditorFilterSierra => 'シエラ';

  @override
  String get imageEditorFilterSkyline => 'スカイライン';

  @override
  String get imageEditorFilterSlumber => 'まどろみ';

  @override
  String get imageEditorFilterStinson => 'スティンソン';

  @override
  String get imageEditorFilterSutro => 'ストロ';

  @override
  String get imageEditorFilterToaster => 'トースター';

  @override
  String get imageEditorFilterValencia => 'バレンシア';

  @override
  String get imageEditorFilterVesper => 'ヴェスパー';

  @override
  String get imageEditorFilterWalden => 'Walden';

  @override
  String get imageEditorFilterWillow => 'ヤナギ';

  @override
  String get imageEditorBlur => 'ぼかし';

  @override
  String get imageEditorTune => '調整';

  @override
  String get imageEditorBrightness => '明るさ';

  @override
  String get imageEditorContrast => 'コントラスト';

  @override
  String get imageEditorSaturation => '彩度';

  @override
  String get imageEditorExposure => '露出';

  @override
  String get imageEditorHue => '色相';

  @override
  String get imageEditorTemperature => '温度';

  @override
  String get imageEditorSharpness => 'シャープネス';

  @override
  String get imageEditorFade => 'フェード';

  @override
  String get imageEditorLuminance => '輝度';

  @override
  String get imageEditorEmoji => '絵文字';

  @override
  String get imageEditorEmojiRecent => '最近';

  @override
  String get imageEditorEmojiSmileys => 'スマイリー';

  @override
  String get imageEditorEmojiAnimals => '動物';

  @override
  String get imageEditorEmojiFood => '食品';

  @override
  String get imageEditorEmojiActivities => 'アクティビティ';

  @override
  String get imageEditorEmojiTravel => '旅行';

  @override
  String get imageEditorEmojiObjects => 'オブジェクト';

  @override
  String get imageEditorEmojiSymbols => '記号';

  @override
  String get imageEditorEmojiFlags => 'フラグ';

  @override
  String get imageEditorSticker => 'ステッカー';

  @override
  String get imageEditorRemove => '削除';

  @override
  String get imageEditorSaving => '保存中...';

  @override
  String get imageEditorImporting => 'インポート中';

  @override
  String get imagePreviewTitle => '画像プレビュー';

  @override
  String get imagePreviewSavingToAlbum => '保存中...';

  @override
  String get imagePreviewAddToSticker => 'ステッカーに追加';

  @override
  String get imagePreviewAddingToSticker => '追加中...';

  @override
  String get imagePreviewRecognizeQr => 'QR コードを認識';

  @override
  String get imagePreviewRecognizingQr => '認識中...';

  @override
  String get imagePreviewConfirmWebLogin => 'Web ログインを確認';

  @override
  String get imagePreviewConfirmingWebLogin => '確認中...';

  @override
  String get imagePreviewOpenLink => 'リンクを開く';

  @override
  String get imagePreviewImageNotDownloadedSave => '画像はまだダウンロードされていません';

  @override
  String get imagePreviewMediaUnavailable => 'メディア サービスが利用できません';

  @override
  String get imagePreviewImageNotUploadedSticker => '画像はまだアップロードされていません';

  @override
  String get imagePreviewStickerUnavailable => 'ステッカー サービスは利用できません';

  @override
  String get imagePreviewAddedToSticker => 'ステッカーに追加されました';

  @override
  String get imagePreviewImageNotDownloadedRecognize => '画像はまだダウンロードされていません';

  @override
  String get imagePreviewQrNotFound => 'QR コードが見つかりません';

  @override
  String get imagePreviewWebLoginQrRecognized => 'Web ログイン QR コードが認識されました';

  @override
  String get imagePreviewWebLinkRecognized => 'Web リンクが認識されました';

  @override
  String get imagePreviewQrRecognized => 'QR コードが認識されました';

  @override
  String get imagePreviewWebLoginConfirmed => 'Web ログインが確認されました';

  @override
  String get pickerFileTitle => 'ファイルを選択してください';

  @override
  String get pickerRecentFiles => '最近のファイル';

  @override
  String get pickerSampleProjectFile => 'プロジェクトノート.pdf';

  @override
  String get pickerSampleProjectFileSubtitle => '128 KB · 今日';

  @override
  String get pickerSampleScreenshotFile => 'チャットのスクリーンショット.png';

  @override
  String get pickerSampleScreenshotFileSubtitle => '2.4 MB · 昨日';

  @override
  String get pickerContactTitle => '連絡先を選択してください';

  @override
  String get pickerContactCardSection => '連絡先カードを送信';

  @override
  String get pickerSearchContacts => '連絡先の検索';

  @override
  String get pickerNoMatchingContacts => '一致する連絡先がありません';

  @override
  String get chatSendFailedShort => '送信に失敗しました';

  @override
  String get chatResend => '再送信';

  @override
  String get chatStatusRead => '読み取り';

  @override
  String get pinnedMessageTitle => '固定メッセージ';

  @override
  String pinnedMessageTitleWithIndex(int index, int total) {
    return '固定メッセージ $index/$total';
  }

  @override
  String get pinnedMessageOpen => 'タップして表示';

  @override
  String get pinnedMessageViewAllTooltip => '固定されたものをすべて表示';

  @override
  String get pinnedMessageUnpinTooltip => '固定を解除';

  @override
  String pinnedMessageListCount(int count) {
    return '$count 固定メッセージ';
  }

  @override
  String get pinnedMessageClearAll => 'すべての固定を解除';

  @override
  String get pinnedMessageFallback => '固定メッセージ';

  @override
  String get fileUnnamed => '無題のファイル';

  @override
  String get fileNoDownloadUrl => '利用可能なダウンロード リンクがありません';

  @override
  String get fileTitle => 'ファイル';

  @override
  String fileSizeLabel(String size) {
    return 'ファイルサイズ: $size';
  }

  @override
  String get fileDownloadFailed => 'ダウンロードに失敗しました';

  @override
  String get filePreview => 'プレビュー';

  @override
  String get fileOpenWithOtherApp => '他のアプリで開く';

  @override
  String get actionEnable => '有効にする';

  @override
  String get actionDisable => '無効にする';

  @override
  String get profileInviteLoading => '招待コードを読み込んでいます';

  @override
  String get profileInviteEnabled => '招待コードが有効になりました';

  @override
  String get profileInviteDisabled => '招待コードが無効になっています';

  @override
  String profileInviteLoadFailed(String error) {
    return '招待コードの読み込みに失敗しました: $error';
  }

  @override
  String get profileInviteCopied => 'コピーされました';

  @override
  String profileInviteUpdateFailed(String error) {
    return '招待コードを更新できませんでした: $error';
  }

  @override
  String get stickerStoreTitle => 'ステッカーストア';

  @override
  String get stickerNoPacks => 'ステッカー パックなし';

  @override
  String get stickerDetailTitle => 'ステッカーの詳細';

  @override
  String get stickerProcessing => '処理中...';

  @override
  String get stickerAddCustomTitle => 'カスタムステッカーを追加';

  @override
  String get stickerSortTitle => 'ステッカーの並べ替え';

  @override
  String get stickerMyStickersTitle => '私のステッカー';

  @override
  String get stickerSaving => '保存中';

  @override
  String get stickerSortAction => '並べ替え';

  @override
  String get stickerOrganize => '整理する';

  @override
  String get stickerCustomTitle => 'カスタムステッカー';

  @override
  String get stickerCustomSubtitle => '保存されたカスタム ステッカーを管理する';

  @override
  String get stickerNoSortablePacks => '並べ替えるステッカー パックがありません';

  @override
  String get stickerNoCategories => 'ステッカー カテゴリがありません';

  @override
  String get stickerMoveUp => '上に移動';

  @override
  String get stickerMoveDown => '下に移動';

  @override
  String get stickerNoCustomStickers => 'カスタムステッカーはありません';

  @override
  String get stickerMoveToFront => '前へ移動';

  @override
  String get stickerDeleteConfirmTitle => '削除したステッカーは復元できません';

  @override
  String get complaintTitle => 'レポート';

  @override
  String get complaintHint => '問題の説明';

  @override
  String get complaintType => 'レポートの種類';

  @override
  String get complaintSubmitted => 'レポートが送信されました';

  @override
  String get complaintSubmit => 'レポートを送信';

  @override
  String get complaintSubmitting => '送信中…';

  @override
  String get complaintFallbackOtherViolation => 'その他のポリシー違反';

  @override
  String get complaintFallbackFraud => 'その他の詐欺または詐欺';

  @override
  String get complaintFallbackAccountCompromised => 'アカウントが侵害される可能性があります';

  @override
  String get chatBackgroundTitle => 'チャットの背景';

  @override
  String get chatBackgroundLoading => 'チャットの背景を読み込んでいます';

  @override
  String get chatBackgroundEmpty => 'チャット背景なし';

  @override
  String get chatBackgroundDefault => 'デフォルトの背景';

  @override
  String chatBackgroundItem(int index) {
    return '背景 $index';
  }

  @override
  String get chatBackgroundPreviewTitle => 'プレビューの背景';

  @override
  String get chatBackgroundSet => '背景の設定';

  @override
  String get chatBackgroundSelectedStatus => 'チャット背景セット';

  @override
  String get chatBackgroundInUse => '使用中';

  @override
  String get chatContactFallback => '連絡先';

  @override
  String get chatPersonalCard => '連絡先カード';

  @override
  String get chatSystemMessageDigest => '[システムメッセージ]';

  @override
  String get chatMessageDigestMessage => '[メッセージ]';

  @override
  String get chatMessageDigestImage => '[画像]';

  @override
  String get chatMessageDigestVoice => '[音声]';

  @override
  String get chatMessageDigestVideo => '[ビデオ]';

  @override
  String get chatMessageDigestLocation => '[場所]';

  @override
  String get chatMessageDigestCard => '[連絡先カード]';

  @override
  String get chatMessageDigestFile => '[ファイル]';

  @override
  String get chatMessageDigestHistory => '[チャット履歴]';

  @override
  String get chatMessageDigestSticker => '[ステッカー]';

  @override
  String get dateWeekdayShortMonday => '月';

  @override
  String get dateWeekdayShortTuesday => '火曜日';

  @override
  String get dateWeekdayShortWednesday => '水';

  @override
  String get dateWeekdayShortThursday => '木';

  @override
  String get dateWeekdayShortFriday => '金';

  @override
  String get dateWeekdayShortSaturday => '土';

  @override
  String get dateWeekdayShortSunday => '日';

  @override
  String get appIconClassic => 'クラシック';

  @override
  String get appIconSimple => 'シンプル';

  @override
  String get appIconDark => 'ダーク';

  @override
  String get appIconFestive => 'お祝い';

  @override
  String get appIconGradient => 'グラデーション';

  @override
  String get appIconUpdated => 'アイコンが更新されました';

  @override
  String get appIconUpdateFailed => '切り替えに失敗しました。後でもう一度試してください。';

  @override
  String get appearanceBubbleColorPurple => 'パープル';

  @override
  String get appearanceBubbleColorGreen => 'グリーン';

  @override
  String get appearanceBubbleColorBlue => 'ブルー';

  @override
  String get appearanceBubbleColorOrange => 'オレンジ';

  @override
  String get appearanceBubbleColorPink => 'ピンク';

  @override
  String replyPreviewTitle(String name) {
    return '$name に返信';
  }

  @override
  String get replyPreviewCancel => '返信をキャンセル';

  @override
  String get chatPasswordTitle => 'チャットのパスワード';

  @override
  String get chatPasswordHint => '6 桁のパスワードを入力してください';

  @override
  String chatPasswordErrorRemain(int remain) {
    return 'パスワードが間違っています。チャット履歴は、$remain 回以上失敗するとクリアされます。';
  }

  @override
  String get emojiPackEmpty => 'このパックにはステッカーは含まれていません';

  @override
  String get emojiRecentSection => '最近';

  @override
  String get emojiAllSection => 'すべての絵文字';

  @override
  String get stickerSearching => '検索中...';

  @override
  String get stickerNoSearchResults => '結果がありません';

  @override
  String get stickerSearchResultsTitle => '結果:';

  @override
  String get homeChatPasswordWiped => '間違った試行が多すぎます。チャット履歴が削除されました。';

  @override
  String get homeGroupNotFound => 'グループ チャットが見つかりません';

  @override
  String get homeConversationNoHistory => 'チャット履歴はありません';

  @override
  String get homeConversationStartChat => 'チャットを開始';

  @override
  String get homeEnterGroupChat => 'グループ チャットに参加する';

  @override
  String get homeNewGroup => '新しいグループ チャット';

  @override
  String homeFriendRequestAcceptFailed(String error) {
    return '受け入れられませんでした: $error';
  }

  @override
  String get homeFriendRequestAccepted => '友達リクエストが承認されました';

  @override
  String homeFriendRequestRefuseFailed(String error) {
    return '拒否できませんでした: $error';
  }

  @override
  String homeFriendRequestDeleteFailed(String error) {
    return '削除に失敗しました: $error';
  }

  @override
  String contactPresenceOnlineWithDevice(String device) {
    return '$device のオンライン';
  }

  @override
  String contactPresenceJustOnlineWithDevice(String device) {
    return '只今 $device でオンライン中です';
  }

  @override
  String contactPresenceMinutesOnlineWithDevice(int minutes, String device) {
    return '$device $minutes 分前にオンライン';
  }

  @override
  String contactPresenceLastOnline(String time) {
    return '前回のオンライン $time';
  }

  @override
  String get contactPresenceDeviceWeb => 'ウェブ';

  @override
  String get contactPresenceDeviceDesktop => 'デスクトップ';

  @override
  String get contactPresenceDeviceMobile => 'モバイル';

  @override
  String get botCommandsEmpty => 'コマンドがまだありません';
}
