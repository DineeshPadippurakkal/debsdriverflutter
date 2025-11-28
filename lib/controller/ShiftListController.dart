import 'dart:convert';

import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/checkin/model/CheckinResponse.dart';
import 'package:debs_driver_app/model/ShiftResponse.dart';

import 'package:http/http.dart' as http;

class Shiftlistcontroller {
  String baseUrl = "https://staging.allowmena.com/api/v1";

  // replace with your API v1/driver/login

  Future<ShiftListResponse?> getShiftList(String date) async {
    final url = Uri.parse("$baseUrl/driver/shifts?date=$date");
    String? token = await Utils().getToken();
    try {
      final response =
          await http.get(url, headers: {'Authorization': '$token'});
      // print(url);
      // print('this is the status code ${response.statusCode}');
      // print('this is the status code ${response.body}');
      if (response.statusCode == 200) {
        final jsondata = ShiftListResponse.fromJson(jsonDecode(response.body));

        print(response.body);
        return jsondata;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CheckinResponse?> callCheckin(int slotID, int shiftID) async {
    final url = Uri.parse("$baseUrl/driver/shifts/$shiftID/check-in");
    String? token = await Utils().getToken();
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "slot_id": slotID,
        }),
      );

      print(slotID);
      print(url);
      print('this is the status code ${response.statusCode}');
      print('this is the status code ${response.body}');
      final jsondata = CheckinResponse.fromJson(jsonDecode(response.body));
      return jsondata;
    } catch (e) {
      rethrow;
    }
  }
}
