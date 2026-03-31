import 'package:debs_driver_app/core/application/controllers/view_contracts/view_contract.dart';
import 'package:debs_driver_app/core/application/controllers/view_contracts/view_contract_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ControllerLifeCycle {
  void onInit();

  void onClose();
}

abstract class ViewContractCubit<S, V extends ViewContract> extends Cubit<S>
    with ViewContractMixin<V> {
  ViewContractCubit(super.initialState) {
    debugPrint('🌞 onInit called from $runtimeType');
  }

  /*
  @override
  void emit(S state) {
    super.emit(state);
  }
*/

  @override
  Future<void> close() {
    debugPrint(
      '🌑 onClose called from $runtimeType, no need for continue listening to this observer anymore.',
    );
    return super.close();
  }
}

abstract class ViewContractBloc<EVENT, STATE, V extends ViewContract> extends Bloc<EVENT, STATE>
    with ViewContractMixin<V> {
  ViewContractBloc(super.state) {
    onInit();
  }

  @override
  Future<void> close() async {
    onClose();
    super.close();
  }

  @override
  void onClose() {
    debugPrint(
      '🌑 onClose called from $runtimeType, no need for continue listening to this observer anymore.',
    );
  }

  @override
  void onInit() {
    debugPrint('🌞 onInit called from $runtimeType');
  }
}
