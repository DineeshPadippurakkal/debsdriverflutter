
import 'package:debs_driver_app/core/domain/failure/exception.dart';

abstract class ViewContract {}

abstract class SuccessViewContract<S> extends ViewContract {
  void onSuccess(S s);
}

abstract class SuccessLoadingViewContract extends ViewContract {
  void onSuccess<T>(T value);
}

abstract class FailedViewContract extends ViewContract {
  void onFailed(AppException e);
}

abstract class SuccessMessageViewContract extends ViewContract {
  void showSuccessMessage();
}

abstract class LoadingViewContract extends ViewContract {
  void showLoading();

  void hideLoading();
}

abstract class LoadingMessageViewContract extends ViewContract {
  void showLoadingMessage();
}

abstract class ValidateViewContract<T> extends ViewContract {
  bool validate(T data);
}

abstract class ValidateNullableViewContract<T> extends ViewContract {
  bool validate(T? data);
}

class NoParams {}

mixin SuccessViewContractImpl implements SuccessMessageViewContract {
  @override
  void showSuccessMessage() {}
}
mixin LoadingViewContractImpl implements LoadingViewContract {
  late final dynamic loadingDialog;

  @override
  void showLoading() {
    return loadingDialog.showLoading();
  }

  @override
  void hideLoading() {
    return loadingDialog.hideLoading();
  }
}

class NoViewContract extends ViewContract {}
