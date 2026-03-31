import 'package:bloc/bloc.dart';
import 'package:debs_driver_app/core/application/controllers/view_contracts/view_contract.dart';
import 'package:debs_driver_app/core/application/controllers/view_contracts/view_contract_mixin.dart';
import 'package:flutter/foundation.dart';

abstract class ViewContractCubit<S, V extends ViewContract> extends Cubit<S>
    with ViewContractMixin<V> {
  ViewContractCubit(super.initialState) {
    debugPrint('init $runtimeType');
  }

  @override
  void emit(S state) {
    if (isClosed) return;
    super.emit(state);
  }

  @override
  Future<void> close() {
    debugPrint('close $runtimeType');
    return super.close();
  }
}
