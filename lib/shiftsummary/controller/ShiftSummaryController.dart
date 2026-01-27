import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/shiftsummary/model/ShiftSummaryResponse.dart';
import 'package:flutter/material.dart';

class Shiftsummarycontroller {
  String baseUrl = "https://staging.allowmena.com/api/v1";

  Future<ShiftSummaryResponse?> fetchShiftSummary(BuildContext context,String startDate,String endDate) async {
    final url = Uri.parse("$baseUrl/driver/shift-summary?start_date=$startDate&end_date=$endDate");
    String? token = await Utils().getToken();
    log(url.toString());
    try {
      final response = await http.get(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });

      log(response.body);
      if (response.statusCode == 200) {
        return ShiftSummaryResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${response.statusCode}")));
        // throw "${response.body}";
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
      // throw "${response.body}";
    }
    return null;
  }
}
