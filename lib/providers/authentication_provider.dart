import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  loginUser() async {
    return {"userName": "admin", "password": "admin"};
  }

  logoutUser() async {
    return true;
  }
}
