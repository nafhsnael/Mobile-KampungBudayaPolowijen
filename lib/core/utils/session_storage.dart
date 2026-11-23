import 'package:shared_preferences/shared_preferences.dart';

abstract final class SessionStorage {
  static const _isLoggedInKey = 'isLoggedIn';
  static const _userNameKey = 'userName';

  static Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String?> getUserName() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_userNameKey);
  }

  static Future<bool> saveSession(String userName) async {
    final preferences = await SharedPreferences.getInstance();
    final nameSaved = await preferences.setString(_userNameKey, userName);
    if (!nameSaved) {
      return false;
    }
    return preferences.setBool(_isLoggedInKey, true);
  }

  static Future<bool> clearSession() async {
    final preferences = await SharedPreferences.getInstance();
    final loginRemoved = await preferences.remove(_isLoggedInKey);
    final nameRemoved = await preferences.remove(_userNameKey);
    return loginRemoved && nameRemoved;
  }
}
