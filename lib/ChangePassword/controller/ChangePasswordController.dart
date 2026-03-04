import 'dart:convert';
import 'dart:developer'; 

import 'package:debs_driver_app/ChangePassword/model/ChangePasswordRequest.dart';
import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/orderdetail/model/CommonResponse.dart';

import 'package:http/http.dart' as http;

class ChangePasswordController {
  String baseUrl = "https://staging.allowmena.com/api/v1";

  Future<CommonResponse?> changePassowrdApi(
      ChangePasswordRequest changePasswordRequest) async {
    final url = Uri.parse("$baseUrl/change-password");
    String? token = await Utils().getToken();
log(url.toString());
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': '$token', // Often APIs require 'Bearer ' prefix
          'Content-Type': 'application/json', // CRITICAL for jsonEncode
          'Accept': 'application/json',
        },
        body: jsonEncode(changePasswordRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final jsondata = CommonResponse.fromJson(jsonDecode(response.body));
        print("Success Response: ${response.body}");
        return jsondata;
      } else {
        // Log the error body to see why the server rejected it
        print("Error Response: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception during API call: $e");
      rethrow;
    }
  }
}
