import '../app/app_runtime.dart';
import '../modules/module_ids.dart';
import '../modules/module_rtc_route.dart';

Future<void> notifyActiveCallPeerOnExit() {
  final feature = AppRuntime.current?.registry.featureById(
    ModuleFeatureIds.rtcSessionApi,
  );
  final sessionApi = feature?.value;
  if (sessionApi is ModuleRtcSessionApi) {
    return sessionApi.notifyPeerOnExit?.call() ?? Future.value();
  }
  return Future.value();
}
