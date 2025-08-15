import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:flutter/material.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  Future<bool> isAuthenticated() async {
    final user = await PreferencesManager().getUserData();
    return user != null;
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
