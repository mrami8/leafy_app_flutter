// providers/user_profile_provider.dart
import 'package:flutter/material.dart';

class UserProfileProvider extends ChangeNotifier {
  String _username = 'casico23';
  String _email = 'casico23@leafy.com';

  String get username => _username;
  String get email => _email;

  void updateProfile({required String username, required String email}) {
    _username = username;
    _email = email;
    notifyListeners();
  }
}
