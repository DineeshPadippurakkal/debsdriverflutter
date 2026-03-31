import 'package:debs_driver_app/core/application/controllers/view_contracts/view_contract.dart';

mixin ViewContractMixin<V extends ViewContract> {
  late V _viewContract;

  void attachViewContract(V viewContract) {
    this._viewContract = viewContract;
  }

  V get viewContract => _viewContract;
}
