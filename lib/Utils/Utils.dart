import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class Utils {


 Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Saved Token: $token');
    return token; // return nullable String
}

 Future<int?> getDriverID() async {
    final prefs = await SharedPreferences.getInstance();
    final driverID = prefs.getInt('driverID');
    print('Saved driverID: $driverID');
    return driverID; // return nullable String
}
}