import 'dart:convert';
import 'dart:developer';

import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/orders/AcknowledgementReq.dart';
import 'package:debs_driver_app/orders/OrderListResponse.dart';
import 'package:debs_driver_app/orders/ResumeOrderResponse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Orderlistcontroller {
  String baseUrl = "https://staging.allowmena.com/api/v1";

  Future<OrderListResponse?> getOrderList(BuildContext context) async {
    final url = Uri.parse("$baseUrl/driver/order-tasks");
    String? token = await Utils().getToken();

    try {
      final response = await http.get(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });

      print(url);
      print(token);
      print('this is the status code ${response.body}');
      if (response.statusCode == 200) {
        return OrderListResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${response.statusCode}")));
        // throw "${response.body}";
        return null;
      }
    } catch (e, s) {
      debugPrint("Error fetching orders: $e $s");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch orders")),
      );
      return null;
    }
  }

  Future<ResumeOrderResponse?> callResumeOrderApi(
      BuildContext context, int orderId) async {
    final url = Uri.parse("$baseUrl/driver/orders/$orderId/resume");
    String? token = await Utils().getToken();

    try {
      final response = await http.post(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });

      print(url);
      print(token);
      print('this is the status code ${response.body}');
      if (response.statusCode == 200) {
        return ResumeOrderResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${response.statusCode}")));
        // throw "${response.body}";
        return null;
      }
    } catch (e, s) {
      debugPrint("Error fetching orders: $e $s");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch orders")),
      );
      return null;
    }
  }

  Future<ResumeOrderResponse?> callAcknowledgmentApi(BuildContext context,
      int taskID, AcknowledgementReq acknowledgementReq) async {
    final url = Uri.parse("$baseUrl/driver/order-tasks/$taskID/acknowledge");
    // https://staging.allowmena.com/api/v1/driver/order-tasks/24002/acknowledge
    String? token = await Utils().getToken();
    try {
      final response = await http.post(url,
          headers: {
            'Authorization': '$token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(acknowledgementReq.toJson()));
      log("location $url}");
      print(url);
      print(token);
      print('this is the status code ${response.body}');
      if (response.statusCode == 200) {
        return ResumeOrderResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${response.statusCode}")));
        // throw "${response.body}";
        return null;
      }
    } catch (e, s) {
      debugPrint("Error fetching orders: $e $s");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch orders")),
      );
      return null;
    }
  }
}
