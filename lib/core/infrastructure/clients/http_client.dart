import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/core/infrastructure/clients/shared_pref/shared_pref_keys.dart';
import 'package:debs_driver_app/core/infrastructure/clients/shared_pref/shared_pref_local_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class HttpApiClient {
  HttpApiClient(this._sharedPrefLocalClient);

  final SharedPrefLocalClient _sharedPrefLocalClient;

  static const stagingHostUrl = 'https://staging.allowmena.com';

  late Dio api;
  late Dio instance;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    api = Dio(BaseOptions(baseUrl: '$stagingHostUrl/api/v1'));
    instance = Dio(BaseOptions());
    if (kDebugMode) {
      final logInterceptor = LogInterceptor(
        requestBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
        request: true,
        responseBody: true,
      );
      api.interceptors.add(logInterceptor);
      instance.interceptors.add(logInterceptor);
    }
    api.interceptors.add(AuthInterceptor());
    String? token = await Utils().getToken();
    if (token != null) {
      updateToken(token);
    }
  }

  void updateToken(String token) {
    api.options.headers['Authorization'] = token;
  }

  void clearToken() {
    api.options.headers.remove('Authorization');
  }

  Future<String?> getCachedHost() async {
    try {
      return _sharedPrefLocalClient.instance.getString(LocalStorageKeys.env.name);
    } catch (_) {
      return null;
    }
  }
}

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  static bool _isClearing = false;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    if (_isClearing) {
      return;
    }

    _isClearing = true;

    // await Navigation.navigatorKey.currentState?.pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return PhoneVerificationScreen(trigger: SplashScreenTriggerType.sessionExpired);
    //     },
    //   ),
    //   (route) => false,
    // );

    _isClearing = false;
  }
}
