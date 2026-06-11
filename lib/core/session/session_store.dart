import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/models/auth_session.dart';

class SessionStore {
  static const sessionKey = 'auth_session';

  Future<AuthSession?> load() async {
    final preferences = await SharedPreferences.getInstance();
    final sessionText = preferences.getString(sessionKey);

    if (sessionText == null) {
      return null;
    }

    try {
      return AuthSession.fromJson(jsonDecode(sessionText));
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> save(AuthSession session) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(sessionKey, jsonEncode(session.toJson()));
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(sessionKey);
  }
}
