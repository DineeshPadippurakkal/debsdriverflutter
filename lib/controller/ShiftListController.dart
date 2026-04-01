import 'dart:convert';

import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/checkin/model/CheckinResponse.dart';
import 'package:debs_driver_app/home/model/LogoutResponse.dart';
import 'package:debs_driver_app/home/model/ShiftResponse.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;

class Shiftlistcontroller {
  String baseUrl = "https://staging.allowmena.com/api/v1";

  // replace with your API v1/driver/login

  Future<ShiftListResponse?> getShiftList(String date) async {
    final url = Uri.parse("$baseUrl/driver/shifts?date=$date");
    String? token = await Utils().getToken();
    try {
      final response = await http.get(url, headers: {'Authorization': '$token'});
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
// get location using geolocator package and pass the lat and long in the body of the request

    try {
      final currentLocation = await Geolocator.getCurrentPosition();

      final response = await http.post(
        url,
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "slot_id": slotID,
          "latitude": currentLocation.latitude,
          "longitude": currentLocation.longitude,
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

  Future<LogoutResponse?> callLogoutApi() async {
    try {
      final url = Uri.parse("$baseUrl/logout");
      String? token = await Utils().getToken();
      final response = await http.get(
        url,
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
      );

      print('this is the status code ${response.body}');
      final jsondata = LogoutResponse.fromJson(jsonDecode(response.body));
      return jsondata;
    } catch (e) {
      rethrow;
    }
  }
}

final x = {
  "status": true,
  "message": "Success",
  "data": {
    "order_details": {
      "id": 32057,
      "reference_id": null,
      "task_id": 24077,
      "status": "Assigned",
      "date": "2026-03-30",
      "time": "03:07 PM",
      "day": "Monday",
      "is_acknowledged": true,
      "payment_type": "Online",
      "payment_amount": 3333.0,
      "amount_due_on_delivery": 0.0,
      "need_delivery_proof": true,
      "need_signature": true,
      "items_details": [],
      "collection_method": "Collect",
      "order_alerts": []
    },
    "pickup_details": {
      "name": "Culinary Fusion catering company - Hawally",
      "mobile": "99996438",
      "logo":
          "http://staging.allowmena.com/media/supplier/logo/d97177441fff47fdb333b59a628818d1.jpeg",
      "latitude": 29.3456636,
      "longitude": 48.0122536,
      "state": "Hawally",
      "area": "Hawally",
      "block": "Block 1",
      "building": "sondos complex Floor 1 Kitchen 34",
      "street": "Abdullah Al Othman",
      "pickup_postal_code": null,
      "landmark": null,
      "house_number": null,
      "flat": null,
      "city": null,
      "floor": null,
      "instructions": {"attachments": [], "notes": ""},
      "expected_pickup_reach_ts": "2026-03-30 15:25:50"
    },
    "drop_off_details": {}
  }
};
