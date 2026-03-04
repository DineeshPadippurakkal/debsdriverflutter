import 'dart:convert';
import 'dart:developer';

import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/shiftSelection/model/AvialableShiftResponse.dart';
import 'package:debs_driver_app/shiftSelection/model/OffDateModelResponse.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Shitslectioncontroller {
   String baseUrl = "https://staging.allowmena.com/api/v1";

  Future<AvialableShiftResponse?> fetchShifts(BuildContext context) async {
    final url = Uri.parse("$baseUrl/driver/weekly-schedule");
    String? token = await Utils().getToken();
    log(url.toString());
    try {
      final response = await http.get(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });
    
      log(response.body);
      print(response.body);
      if (response.statusCode == 200) {
        return AvialableShiftResponse.fromJson(jsonDecode(response.body));
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

   Future<OffDateModelResponse?> fetchOffDates(BuildContext context,int week_schedule) async {
    final url = Uri.parse("$baseUrl/driver/weekly-schedule/$week_schedule/suggest-off");
    String? token = await Utils().getToken();
    log(url.toString());
    try {
      final response = await http.get(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });
    
      log(response.body);
      print(response.body);
      if (response.statusCode == 200) {
        return OffDateModelResponse.fromJson(jsonDecode(response.body));
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