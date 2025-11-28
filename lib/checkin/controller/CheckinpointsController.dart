import 'dart:convert';

import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/checkin/model/CheckinpointsResponse.dart';

import 'package:http/http.dart' as http;

class Checkinpointscontroller {
  String baseUrl = "https://staging.allowmena.com/api/v1";

  // replace with your API v1/driver/login

  Future<CheckinpointsResponse?> getCheckinPoints() async {
    final url = Uri.parse("$baseUrl/driver/check-points");
    String? token = await Utils().getToken();
    try {
      final response =
          await http.get(url, headers: {'Authorization': '$token'});
      print(url);
      print('this is the status code ${response.statusCode}');
      print('this is the status code ${response.body}');
      if (response.statusCode == 200) {
        final jsondata =
            CheckinpointsResponse.fromJson(jsonDecode(response.body));

        return jsondata;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
