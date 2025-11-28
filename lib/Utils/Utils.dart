import 'package:shared_preferences/shared_preferences.dart';

class Utils {


 Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Saved Token: $token');
    return token; // return nullable String
}
}