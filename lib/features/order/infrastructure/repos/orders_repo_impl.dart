import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:debs_driver_app/core/domain/failure/exception.dart';
import 'package:debs_driver_app/core/infrastructure/clients/http_client.dart';
import 'package:debs_driver_app/core/infrastructure/services/server_uploader_service.dart';
import 'package:debs_driver_app/features/order/infrastructure/dtos/drop_order_dto.dart';
import 'package:debs_driver_app/features/order/domain/entities/hold_order_reason.dart';
import 'package:debs_driver_app/features/order/domain/entities/order_details.dart';
import 'package:debs_driver_app/features/order/domain/repos/orders_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@LazySingleton(as: OrdersRepo)
class OrdersRepoImpl implements OrdersRepo {
  OrdersRepoImpl(this._client, this._uploader);

  final HttpApiClient _client;
  final ServerUploaderService _uploader;

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
  Future<Either<AppException, Unit>> reachLocation(int orderID, int taskId) async {
    final url = "/driver/order-tasks/$taskId/reached-location";
    try {
      await _client.api.post(url);
      return right(unit);
    } on DioException catch (e, s) {
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
  Future<Either<AppException, Unit>> dropOrder(DropOrderDto dto) async {
    final url = "/driver/orders/${dto.orderID}/delivery";
    try {
      final formDataMap = <String, dynamic>{};

      if (dto.amountDue != null && dto.amountDue! > 0) {
        formDataMap['amount'] = dto.amountDue.toString();
      }

      if (dto.deliveryImage != null) {
        formDataMap['delivery_proof_img'] = await MultipartFile.fromFile(
          dto.deliveryImage!.path,
        );
      }

      if (dto.signatureFile != null) {
        formDataMap['signature_proof_img'] = dto.signatureFile;
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

  @override
  Future<Either<AppException, File>> pickImageAndCompress() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image == null) {
        return left(NoImagePickedException());
      }

      final tempDir = await getTemporaryDirectory();
      final targetPath = "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

      final compressedXFile = await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 80, // 70-80 is the "sweet spot" for mobile apps
        minWidth: 1024, // Optional: resizing saves more space than quality reduction
        minHeight: 1024,
      );


      if (compressedXFile == null) {
        return right(File(image.path));
      }
      await _uploader
          .uploadFile(UploadedFile(file: File(compressedXFile.path), type: UploadedFileType.deliveryProof));

      return right(File(compressedXFile.path));
    } catch (e, s) {
      return left(UnExpectedException(exception: e, stackTrace: s));
    }
  }
}
