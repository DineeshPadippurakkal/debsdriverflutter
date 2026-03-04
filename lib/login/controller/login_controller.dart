import 'package:debs_driver_app/login/model/LoginResposne.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController {
  String baseUrl = "https://staging.allowmena.com/api/v1";

  // replace with your API v1/driver/login

  Future<LoginResponse?> controller(String username, String password,String playerID) async {
    final url = Uri.parse("$baseUrl/driver/login");

    try {
      final response = await http.post(url, body: {
        "email": username,
        "password": password,
        "player_id": playerID
      });
        print(url);
      print('this is the status code ${response.statusCode}');
      print('this is the status code ${response.body}');
      if (response.statusCode == 200) {
        final jsondata = LoginResponse.fromJson(jsonDecode(response.body));


        return jsondata;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  } 
}
