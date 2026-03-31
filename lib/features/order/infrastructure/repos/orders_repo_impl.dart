import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/core/domain/failure/exception.dart';
import 'package:debs_driver_app/core/infrastructure/clients/http_client.dart';
import 'package:debs_driver_app/temp/CommonResponse.dart';
import 'package:debs_driver_app/temp/DropOrderRequest.dart';
import 'package:debs_driver_app/features/order/domain/entities/hold_order_reason.dart';
import 'package:debs_driver_app/temp/HoldOrderRequest.dart';
import 'package:debs_driver_app/temp/HoldOrderResponse.dart';
import 'package:debs_driver_app/features/order/domain/entities/order_details.dart';
import 'package:debs_driver_app/features/order/domain/repos/orders_repo.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrdersRepo)
class OrdersRepoImpl implements OrdersRepo {
  OrdersRepoImpl(this._client);

  final HttpApiClient _client;

  @override
  Future<Either<AppException, OrderData>> getOrderDetails(int orderID, int taskId) async {
    final url = "/driver/order-tasks/$taskId?order_id=$orderID";
    try {
      final response = await _client.api.get(
        url,
      );
      return right(OrderData.fromJson(response.data['data']));
    } catch (e, s) {
      return left(UnExpectedException(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<AppException, Unit>> holdOrder(int orderID, String reason) async {
    final url = "/driver/orders/$orderID/hold";
    try {
      final response = await _client.api.post(
        url,
        data: {
          "reason": reason,
        },
      );
      return right(unit);
    } catch (e, s) {
      return left(UnExpectedException(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<AppException, List<HoldOrderReason>>> getHoldOrderReasons() async {
    const url = "/order-hold-reasons";
    try {
      final response = await _client.api.get(url);
      return right(
          (response.data['data'] as List).map((e) => HoldOrderReason.fromJson(e)).toList());
    } catch (e, s) {
      return left(UnExpectedException(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<AppException, Unit>> dropOrder(int orderID) async {
    final url = "/driver/orders/$orderID/delivery";
    try {
      await _client.api.post(url);
      return right(unit);
    } catch (e, s) {
      return left(UnExpectedException(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<AppException, Unit>> dropOrderWithAmount(
      int orderID, double amountDueOnDelivery) async {
    final url = "/driver/orders/$orderID/delivery";
    try {
      await _client.api.post(
        url,
        data: {
          "amount": amountDueOnDelivery,
        },
      );
      return right(unit);
    } catch (e, s) {
      return left(UnExpectedException(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<AppException, Unit>> reachLocation(int orderID, int taskId) async {
    final url = "/driver/order-tasks/$taskId/reached-location";
    try {
      await _client.api.post(url);
      return right(unit);
    } on DioException catch (e,s) {
      final data = e.response?.data;
      if (data['message'] == 'You are not near the Supplier location') {
        return left(NotNearToSupplierException(
            exception: e,
            stackTrace: e.stackTrace,
            message: 'You are not near the Supplier location'));
      }
      return left(UnExpectedException(exception: e, stackTrace: s));
    } catch (e, s) {
      return left(UnExpectedException(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<AppException, Unit>> pickupOrder(int orderID, int taskId) async {
    final url = "/driver/order-tasks/$taskId/pick-up";
    try {
      await _client.api.post(url);
      return right(unit);
    } catch (e, s) {
      return left(UnExpectedException(exception: e, stackTrace: s));
    }
  }

  @override
  Future<Either<AppException, Unit>> dropOrderWithProof(
    int orderID, {
    XFile? deliveryImage,
    MultipartFile? signatureFile,
    double? amountDue,
  }) async {
    final url = "/driver/orders/$orderID/delivery";
    try {
      final formDataMap = <String, dynamic>{};

      if (amountDue != null && amountDue > 0) {
        formDataMap['amount'] = amountDue.toString();
      }

      if (deliveryImage != null) {
        formDataMap['delivery_proof_img'] = await MultipartFile.fromFile(
          deliveryImage.path,
          filename: deliveryImage.name,
        );
      }

      if (signatureFile != null) {
        formDataMap['signature_proof_img'] = signatureFile;
      }

      await _client.api.post(
        url,
        data: FormData.fromMap(formDataMap),
      );
      return right(unit);
    } catch (e, s) {
      return left(UnExpectedException(exception: e, stackTrace: s));
    }
  }
}
