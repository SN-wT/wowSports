import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  PreferenceHelper._();

  /// Save a token
  static Future saveAddress(String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (token == null) return;
    pref.setString("address", token);
  }

  static Future saveLike(String postid) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (postid == null) return;
    pref.setBool(postid, true);
  }

  static Future clearStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    //await prefs.setBool("isSeen", true);
  }

  static Future<bool> checkLikedPost(String postid) async {
    bool value;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.reload();
    value = pref.getBool(postid);
    if (value != null && value) {
      return value;
    } else {
      return false;
    }
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
