import 'dart:convert';
import 'dart:developer';

import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/shiftSelection/model/AvialableShiftResponse.dart';
import 'package:debs_driver_app/shiftSelection/model/GetAllShiftDayResponse.dart';
import 'package:debs_driver_app/shiftSelection/model/OffDateModelResponse.dart';
import 'package:debs_driver_app/shiftSelection/model/SubmitShiftResponse.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
      // throw "${response.body}";
    }
    return null;
  }

  Future<OffDateModelResponse?> fetchOffDates(
      BuildContext context, int week_schedule) async {
    final url =
        Uri.parse("$baseUrl/driver/weekly-schedule/$week_schedule/suggest-off");
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
      // throw "${response.body}";
    }
    return null;
  }

  Future<bool> submitOffDate(BuildContext context, int offDateId) async {
    final url = Uri.parse("$baseUrl/driver/off-day/select");

    String? token = await Utils().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "off_date_id": offDateId,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _showError(context, response.body);
        return false;
      }
    } catch (e) {
      _showError(context, e.toString());
      return false;
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<GetAllShiftDayResponse?> fetchSuggestShift(
      BuildContext context, int weekScheduleId) async {
    final url = Uri.parse(
        "$baseUrl/driver/weekly-schedule/$weekScheduleId/suggest-shift");

    String? token = await Utils().getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return GetAllShiftDayResponse.fromJson(jsonDecode(response.body));
      } else {
        _showError(context, response.body);
        return null;
      }
    } catch (e) {
      _showError(context, e.toString());
      return null;
    }
  }

  Future<SubmitShiftResponse?> submitShift(
      BuildContext context, int weekScheduleId, int i) async {
    final url = Uri.parse(
        "$baseUrl/driver/weekly-schedule/$weekScheduleId/suggest-shift");

    String? token = await Utils().getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return SubmitShiftResponse.fromJson(jsonDecode(response.body));
      } else {
        _showError(context, response.body);
        return null;
      }
    } catch (e) {
      _showError(context, e.toString());
      return null;
    }
  }
}
