import 'dart:convert';

import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/orderdetail/model/OrderDetailsResponse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Orderdetailcontroller {
  String baseUrl = "https://staging.allowmena.com/api/v1";

  Future<OrderDetailResponse?> fetchOrderDetail(
      BuildContext context, int orderID, int task_id) async {
    final url =
        Uri.parse("$baseUrl/driver/order-tasks/$task_id?order_id=$orderID");

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
        SnackBar(content: Text("Failed to fetch orders")),
      );
      return null;
    }
  }
}
