import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/orderdetail/model/CommonResponse.dart';
import 'package:debs_driver_app/orderdetail/model/DropOrderRequest.dart';
import 'package:debs_driver_app/orderdetail/model/HoldOrderReasonResponse.dart';
import 'package:debs_driver_app/orderdetail/model/HoldOrderRequest.dart';
import 'package:debs_driver_app/orderdetail/model/HoldOrderResponse.dart';
import 'package:debs_driver_app/orderdetail/model/OrderDetailsResponse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Orderdetailcontroller {
  String baseUrl = "https://staging.allowmena.com/api/v1";

  Future<OrderDetailResponse?> fetchOrderDetail(
      BuildContext context, int orderID, int taskId) async {
    final url =
        Uri.parse("$baseUrl/driver/order-tasks/$taskId?order_id=$orderID");

    String? token = await Utils().getToken();

    try {
      final response = await http.get(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });
      print(url);
      print(token);
      log('this is the status code ${response.body}');
      if (response.statusCode == 200) {
        return OrderDetailResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${response.statusCode}")));
        // throw "${response.body}";
        return null;
      }
    } catch (e, s) {
      debugPrint("Error fetching orders: $e $s");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error. Please try again.")),
      );
      return null;
    }
  }

  Future<HoldOrderResponse?> callHoldOrderApi(
    BuildContext context,
    int orderID,
    HoldOrderRequest request,
  ) async {
    // https://staging.allowmena.com/api/v1/driver/orders/31865/hold
    final url = Uri.parse("$baseUrl/driver/orders/$orderID/hold");
    String? token = await Utils().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(request.toJson()),
      );
      print(url);
      print(token);
      log('this is the status code ${response.body}');
      if (response.statusCode == 200) {
        return HoldOrderResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${response.statusCode}")));
        // throw "${response.body}";
        return null;
      }
    } catch (e, s) {
      debugPrint("Error fetching orders: $e $s");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error. Please try again.")),
      );
      return null;
    }
  }

  Future<HoldOrderReasonResponse?> callHoldOrderReasonApi(
      BuildContext context) async {
    final url = Uri.parse("$baseUrl/order-hold-reasons");

    String? token = await Utils().getToken();

    try {
      final response = await http.get(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });
      log('this is the status code ${response.body}');
      if (response.statusCode == 200) {
        return HoldOrderReasonResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${response.statusCode}")));
        // throw "${response.body}";
        return null;
      }
    } catch (e, s) {
      debugPrint("Error fetching orders: $e $s");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error. Please try again.")),
      );
      return null;
    }
  }

  Future<CommonResponse?> callDropOrderApi(
      BuildContext context, int orderID) async {
    // https://staging.allowmena.com/api/v1/driver/orders/31888/delivery
    //  {"status":true,"message":"Success","data":{}}
    final url = Uri.parse("$baseUrl/driver/orders/$orderID/delivery");

    String? token = await Utils().getToken();

    try {
      final response = await http.post(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });
      print(url);
      log("callDropOrderApi");
      print(token);
      log('this is the status code ${response.body}');
      final Map<String, dynamic> body = jsonDecode(response.body);

      final String message = body['message'] ?? 'Something went wrong';

      if (response.statusCode == 200) {
        return CommonResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        // throw "${response.body}";
        return null;
      }
    } catch (e, s) {
      debugPrint("Error fetching orders: $e $s");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error. Please try again.")),
      );
      return null;
    }
  }

  Future<CommonResponse?> callDropOrderwithAmountApi(
    BuildContext context,
    int orderID,
    DropOrderRequest request,
  ) async {
    // https://staging.allowmena.com/api/v1/driver/orders/31888/delivery
    //  {"status":true,"message":"Success","data":{}}
    final url = Uri.parse("$baseUrl/driver/orders/$orderID/delivery");

    String? token = await Utils().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );
      print(url);
      log("callDropOrderwithAmountApi");
      print(token);
      log('this is the status code ${response.body}');
      final Map<String, dynamic> body = jsonDecode(response.body);

      final String message = body['message'] ?? 'Something went wrong';

      if (response.statusCode == 200) {
        return CommonResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        // throw "${response.body}";
        return null;
      }
    } catch (e, s) {
      debugPrint("Error fetching orders: $e $s");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error. Please try again.")),
      );
      return null;
    }
  }

  Future<CommonResponse?> callDriverReachApi(
      BuildContext context, int orderID, int taskId) async {
    // https://staging.allowmena.com/api/v1/driver/order-tasks/23939/reached-location
    //  {"status":true,"message":"Success","data":{}}
    final url =
        Uri.parse("$baseUrl/driver/order-tasks/$taskId/reached-location");

    String? token = await Utils().getToken();

    try {
      final response = await http.post(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });
      print(url);
      print(token);

      final Map<String, dynamic> body = jsonDecode(response.body);

      log('this is the status code ${response.body}');
      final String message = body['message'] ?? 'Something went wrong';

      if (response.statusCode == 200) {
        return CommonResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        // throw "${response.body}";
        return null;
      }
    } catch (e, s) {
      debugPrint("Error fetching orders: $e $s");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error. Please try again.")),
      );
      return null;
    }
  }

  Future<CommonResponse?> callPickupOrderApi(
      BuildContext context, int orderID, int taskId) async {
    //  https://staging.allowmena.com/api/v1/driver/order-tasks/23939/pick-up
    //  {"status":true,"message":"Success","data":{}}
    final url = Uri.parse("$baseUrl/driver/order-tasks/$taskId/pick-up");

    String? token = await Utils().getToken();

    try {
      final response = await http.post(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });
      print(url);
      print(token);
      log('this is the status code ${response.body}');
      if (response.statusCode == 200) {
        return CommonResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${response.statusCode}")));
        // throw "${response.body}";
        return null;
      }
    } catch (e, s) {
      debugPrint("Error fetching orders: $e $s");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error. Please try again.")),
      );
      return null;
    }
  }

  Future<CommonResponse?> callDropOrderApiwithProofSignature(
    BuildContext context,
    int orderID,
    XFile? deliveryImage,
    SignatureController signature,
    double amountDue,
  ) async {
    final uri = Uri.parse("$baseUrl/driver/orders/$orderID/delivery");
    final token = await Utils().getToken();

    try {
      // ✅ Multipart request
      final request = http.MultipartRequest("POST", uri);

      // ✅ Headers (NO content-type)
      request.headers['Authorization'] = token ?? '';

      // ✅ Text fields
      if (amountDue > 0) {
        request.fields['amount'] = amountDue.toString();
      }

      // ✅ Delivery proof image
      if (deliveryImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "delivery_proof_img", // backend key
            deliveryImage.path,
          ),
        );
      }

      // ✅ Signature image
      final signatureFile = await signatureToFile(signature);
      if (signatureFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "signature_proof_img",
            signatureFile.path,
          ),
        );
      }
      log("callDropOrderApiwithProofSignature");
      print(uri);
      print(token);
      // 🔥 Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log("Response: ${response.body}");

      final Map<String, dynamic> body = jsonDecode(response.body);
      final String message = body['message'] ?? "Something went wrong";

      if (response.statusCode == 200) {
        return CommonResponse.fromJson(body);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        return null;
      }
    } catch (e, s) {
      debugPrint("Upload error: $e\n$s");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error. Please try again.")),
      );
      return null;
    }
  }

  Future<File?> signatureToFile(SignatureController controller) async {
    if (controller.isEmpty) return null;

    final ui.Image? image = await controller.toImage();
    final ByteData? byteData =
        await image!.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) return null;

    final Uint8List pngBytes = byteData.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/signature.png');

    await file.writeAsBytes(pngBytes);
    return file;
  }

  Future<CommonResponse?> callDropOrderApiwithProof(
    BuildContext context,
    int orderID,
    XFile? deliveryImage,
    double amountDue,
  ) async {
    final uri = Uri.parse("$baseUrl/driver/orders/$orderID/delivery");
    final token = await Utils().getToken();

    try {
      // ✅ Multipart request
      final request = http.MultipartRequest("POST", uri);

      // ✅ Headers (NO content-type)
      request.headers['Authorization'] = token ?? '';

      // ✅ Text fields
      request.fields['amount'] = amountDue.toString();

      // ✅ Delivery proof image
      if (deliveryImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "delivery_proof_img", // backend key
            deliveryImage.path,
          ),
        );
      }

      // 🔥 Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log("Response: ${response.body}");

      final Map<String, dynamic> body = jsonDecode(response.body);
      final String message = body['message'] ?? "Something went wrong";

      if (response.statusCode == 200) {
        return CommonResponse.fromJson(body);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        return null;
      }
    } catch (e, s) {
      debugPrint("Upload error: $e\n$s");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error. Please try again.")),
      );
      return null;
    }
  }

  Future<CommonResponse?> callDropOrderApiwithSignature(
    BuildContext context,
    int orderID,
    SignatureController signatureController,
    double amountDue,
  ) async {
    final uri = Uri.parse("$baseUrl/driver/orders/$orderID/delivery");
    final token = await Utils().getToken();

    try {
      // ✅ Multipart request
      final request = http.MultipartRequest("POST", uri);

      // ✅ Headers (NO content-type)
      request.headers['Authorization'] = token ?? '';

      // ✅ Text fields
      if (amountDue > 0) request.fields['amount'] = amountDue.toString();

      // ✅ Signature image
      final signatureFile = await signatureToFile(signatureController);
      if (signatureFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "signature_proof_img",
            signatureFile.path,
          ),
        );
      }

      log("callDropOrderApiwithProof");
      print(uri);
      print(token);

      // 🔥 Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log("Response: ${response.body}");

      final Map<String, dynamic> body = jsonDecode(response.body);
      final String message = body['message'] ?? "Something went wrong";

      if (response.statusCode == 200) {
        return CommonResponse.fromJson(body);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        return null;
      }
    } catch (e, s) {
      debugPrint("Upload error: $e\n$s");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error. Please try again.")),
      );
      return null;
    }
  }
}
