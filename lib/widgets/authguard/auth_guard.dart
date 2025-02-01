import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({required this.child});

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken') != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == true) {
          return child;
        } else {
          return const LoginScreen(); // Redirigir a la pantalla de login si no está autenticado
        }
      },
    );
  }
}