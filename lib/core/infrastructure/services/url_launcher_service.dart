import 'package:debs_driver_app/core/domain/failure/exception.dart';
import 'package:debs_driver_app/core/infrastructure/injection/injection_setup.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class UrlLauncherService {
  static get instance => getIt<UrlLauncherService>();

  Future<void> launch(Uri uri, {LaunchMode mode = LaunchMode.externalApplication});
}

@LazySingleton(as: UrlLauncherService)
class UrlLauncherServiceImpl implements UrlLauncherService {
  @override
  Future<void> launch(Uri? uri, {LaunchMode mode = LaunchMode.externalApplication}) async {
    // if (kDebugMode) {
    //   print('Launching URL: $uri');
    //   return;
    // }
    if (uri == null) {
      throw CannotLaunchUriException();
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw CannotLaunchUriException();
    }
  }
}
