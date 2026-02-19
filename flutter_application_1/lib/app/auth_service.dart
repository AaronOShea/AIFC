import 'package:shared_preferences/shared_preferences.dart';

/// Simple local auth for demo. Replace with backend (e.g. Django) later.
class AuthService {
  static const _keyEmail = 'auth_email';
  static const _keyPassword = 'auth_password'; // demo only; use hashed/API in production
  static const _keyLoggedIn = 'auth_logged_in';

  final SharedPreferences _prefs;

  AuthService(this._prefs);

  bool get isLoggedIn => _prefs.getBool(_keyLoggedIn) ?? false;
  String? get email => _prefs.getString(_keyEmail);

  Future<void> signUp(String email, String password) async {
    await _prefs.setString(_keyEmail, email);
    await _prefs.setString(_keyPassword, password);
    await _prefs.setBool(_keyLoggedIn, true);
  }

  Future<bool> login(String email, String password) async {
    final storedEmail = _prefs.getString(_keyEmail);
    final storedPassword = _prefs.getString(_keyPassword);
    if (storedEmail == email && storedPassword == password) {
      await _prefs.setBool(_keyLoggedIn, true);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyPassword);
    await _prefs.setBool(_keyLoggedIn, false);
  }

  static Future<AuthService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthService(prefs);
  }
}
