import 'dart:convert';
import 'dart:developer'; 

import 'package:debs_driver_app/OrderHistory/model/OrderHistoryRes.dart';
import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class OrderHistoryController{
  String baseUrl = "https://staging.allowmena.com/api/v1";

  Future<OrderHistoryRes?> fetchORderHistory(BuildContext context,int limit,int offset) async {
    final url = Uri.parse("$baseUrl/driver/order-history?limit=$limit&offset=$offset");
    String? token = await Utils().getToken();
    log(url.toString());
    try {
      final response = await http.get(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });
    
      log(response.body);
      if (response.statusCode == 200) {
        return OrderHistoryRes.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${response.statusCode}")));
        // throw "${response.body}";
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$e")));
      // throw "${response.body}";
    }
    return null;
  }
}
