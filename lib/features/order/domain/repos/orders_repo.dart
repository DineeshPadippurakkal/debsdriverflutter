import 'package:dartz/dartz.dart';
import 'package:debs_driver_app/core/domain/failure/exception.dart';
import 'package:debs_driver_app/features/order/domain/entities/hold_order_reason.dart';
import 'package:debs_driver_app/features/order/domain/entities/order_details.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

abstract class OrdersRepo {
  Future<Either<AppException, OrderData>> getOrderDetails(int orderID, int taskId);

  Future<Either<AppException, Unit>> holdOrder(int orderID, String reason);

  Future<Either<AppException, List<HoldOrderReason>>> getHoldOrderReasons();

  Future<Either<AppException, Unit>> dropOrder(int orderID);

  Future<Either<AppException, Unit>> dropOrderWithAmount(int orderID, double amountDueOnDelivery);

  Future<Either<AppException, Unit>> reachLocation(int orderID, int taskId);

  Future<Either<AppException, Unit>> pickupOrder(int orderID, int taskId);

  Future<Either<AppException, Unit>> dropOrderWithProof(
    int orderID, {
    XFile? deliveryImage,
    MultipartFile? signatureFile,
    double? amountDue,
  });
}
