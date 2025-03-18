import 'package:flutter/material.dart';

class AuthGuard {
  static Future<bool> checkAccount(BuildContext context, String path) async {
    // Check if the account is created
    return true; // Allow access
  }
}
