import '../app/app_runtime.dart';
import '../modules/module_ids.dart';

final class SocialProcessCacheApi {
  const SocialProcessCacheApi({required this.clear, required this.bindAccount});

  final void Function() clear;
  final void Function(String loginUid) bindAccount;
}

SocialProcessCacheApi? _socialProcessCacheApi() {
  final feature = AppRuntime.current?.registry.featureById(
    ModuleFeatureIds.socialProcessCache,
  );
  final value = feature?.value;
  return value is SocialProcessCacheApi ? value : null;
}

void clearSocialProcessCaches() {
  _socialProcessCacheApi()?.clear();
}

void bindSocialProcessCaches(String loginUid) {
  _socialProcessCacheApi()?.bindAccount(loginUid);
}
