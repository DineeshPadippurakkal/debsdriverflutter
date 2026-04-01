// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../../features/order/application/controllers/order_details_bloc/order_details_bloc.dart'
    as _i16;
import '../../../features/order/application/order_details_args.dart' as _i655;
import '../../../features/order/domain/repos/orders_repo.dart' as _i890;
import '../../../features/order/infrastructure/repos/orders_repo_impl.dart'
    as _i554;
import '../clients/http_client.dart' as _i400;
import '../clients/shared_pref/shared_pref_local_client.dart' as _i996;
import '../services/server_uploader_service.dart' as _i346;
import '../services/url_launcher_service.dart' as _i140;
import '../services/whatsapp_service.dart' as _i397;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    await gh.factoryAsync<_i996.SharedPrefLocalClient>(
      () => _i996.SharedPrefLocalClient.create(),
      preResolve: true,
    );
    gh.lazySingleton<_i397.WhatsappService>(
        () => _i397.WhatsappService.create());
    await gh.factoryAsync<_i400.HttpApiClient>(
      () {
        final i = _i400.HttpApiClient(gh<_i996.SharedPrefLocalClient>());
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i346.ServerUploaderService>(
        () => _i346.ServerUploaderService(gh<_i400.HttpApiClient>()));
    gh.lazySingleton<_i140.UrlLauncherService>(
        () => _i140.UrlLauncherServiceImpl());
    gh.lazySingleton<_i890.OrdersRepo>(() => _i554.OrdersRepoImpl(
          gh<_i400.HttpApiClient>(),
          gh<_i346.ServerUploaderService>(),
        ));
    gh.factoryParam<_i16.OrderDetailsBloc, _i655.OrderDetailsArguments,
        dynamic>((
      arguments,
      _,
    ) =>
        _i16.OrderDetailsBloc(
          gh<_i890.OrdersRepo>(),
          arguments,
        ));
    return this;
  }
}
