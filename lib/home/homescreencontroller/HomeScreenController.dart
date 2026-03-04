import 'dart:convert';

import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/home/model/ProfileDetailsResponse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homescreencontroller {
   String baseUrl = "https://staging.allowmena.com/api/v1";

  Future<ProfileDetailsResponse?> getProfileDetails(BuildContext context) async {
    final url = Uri.parse("$baseUrl/profile");
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
        return ProfileDetailsResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${response.statusCode}")));
        // throw "${response.body}";
        return null;
      }
    } catch (e , s) {
      debugPrint("Error fetching orders: $e $s");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch orders")),
      );
      return null;
    }
  }


}