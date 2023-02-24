import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  PreferenceHelper._();

  /// Save a token
  static Future saveAddress(String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (token == null) return;
    pref.setString("address", token);
  }

  static Future clearStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    //await prefs.setBool("isSeen", true);
  }

  static Future<String> getToken() async {
    String value;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.reload();
    value = pref.getString("address");
    if (value?.isEmpty ?? true) {
      return null;
    } else {
      return value;
    }
  }
}
