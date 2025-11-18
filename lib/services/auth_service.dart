import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usernameKey = 'logged_in_username';

  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<void> clearUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
  }
}

