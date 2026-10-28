import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {

  static SharedPreferences? _preferences;

  /// Initialize once (VERY IMPORTANT)
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Save Login
  static Future setLoggedIn(bool value) async {
    await _preferences?.setBool("isLoggedIn", value);
  }

  static bool isLoggedIn() {
    return _preferences?.getBool("isLoggedIn") ?? false;
  }

  /// Save Token
  static Future setToken(String token) async {
    await _preferences?.setString("token", token);
  }

  static String? getToken() {
    return _preferences?.getString("token");
  }

  /// Save User Mobile
  static Future setMobile(String mobile) async {
    await _preferences?.setString("mobile", mobile);
  }

  static String? getMobile() {
    return _preferences?.getString("mobile");
  }

  /// Logout
  static Future clear() async {
    await _preferences?.clear();
  }
}
