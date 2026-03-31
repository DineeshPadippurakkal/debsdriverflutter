import 'dart:developer';

abstract class AppException implements Exception {
  AppException({
    this.slug = '',
    this.message = '',
    this.stackTrace = StackTrace.empty,
    this.exception = Null,
  }) {
    log(slug ?? 'Something went wrong', error: exception, stackTrace: stackTrace);
  }

  final String slug;
  final String message;
  final StackTrace stackTrace;
  final Object exception;
}

class ServerException extends AppException {
  ServerException({super.slug, super.stackTrace, super.exception, super.message});
}

class PermissionDeniedException extends AppException {
  PermissionDeniedException({super.slug, super.stackTrace, super.exception, super.message});
}

class UnExpectedException extends AppException {
  UnExpectedException({super.stackTrace, super.exception, super.message})
      : super(slug: 'UNEXPECTED_ERROR');
}

class PhoneNotExist extends AppException {
  PhoneNotExist({super.slug, super.stackTrace, super.exception, super.message});
}

class SomethingWrongException extends AppException {
  SomethingWrongException({super.slug, super.stackTrace, super.exception, super.message});
}

class InvalidOtpException extends AppException {
  InvalidOtpException({super.stackTrace, super.exception, super.message})
      : super(slug: 'INVALID_OTP');
}

class OtpSessionExpiredException extends AppException {
  OtpSessionExpiredException({super.slug, super.stackTrace, super.exception, super.message});
}

class TooManyRequestsException extends AppException {
  TooManyRequestsException({super.stackTrace, super.exception, super.message})
      : super(slug: 'TOO_MANY_REQUESTS');
}

class InvalidPhoneNumberException extends AppException {
  InvalidPhoneNumberException({super.slug, super.stackTrace, super.exception, super.message});
}

class PhoneAlreadyUsed extends AppException {
  PhoneAlreadyUsed({super.slug, super.stackTrace, super.exception, super.message});
}

class UserAlreadyRegistered extends AppException {
  UserAlreadyRegistered({super.slug, super.stackTrace, super.exception, super.message});
}

class InvalidCouponCode extends AppException {
  InvalidCouponCode({super.slug, super.stackTrace, super.exception, super.message});
}

class NoRouteFound extends AppException {
  NoRouteFound({super.slug, super.stackTrace, super.exception, super.message});
}

class EmailAlreadyUsed extends AppException {
  EmailAlreadyUsed({super.slug, super.stackTrace, super.exception, super.message});
}

class InvalidPhoneNumber extends AppException {
  InvalidPhoneNumber({
    super.slug,
    super.stackTrace,
    super.exception,
    super.message,
  });
}

class OutOfServiceAreaException extends AppException {
  OutOfServiceAreaException({super.slug, super.stackTrace, super.exception, super.message});
}

class CannotLaunchUriException extends AppException {
  CannotLaunchUriException({super.slug, super.stackTrace, super.exception, super.message});
}

class NotNearToSupplierException extends AppException {
  NotNearToSupplierException({super.slug, super.stackTrace, super.exception, super.message});
}

class NoImagePickedException extends AppException {
  NoImagePickedException({super.slug, super.stackTrace, super.exception, super.message});
}