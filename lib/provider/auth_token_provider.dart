import 'dart:async';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;

  Future<bool> validateToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool usedAppBefore = prefs.getBool("usedAppBefore") ?? false;

    try {
      if (usedAppBefore) {
        return true; // Token is valid
      } else {
        return false; // Token is invalid
      }
    } catch (e) {
      debugPrint('Error validating token: $e');
      return false; // Error occurred during validation
    }
  }
}
