import 'package:event_sports/ui/login_or_register.dart';
import 'package:event_sports/ui/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is Logged in
          if (snapshot.hasData) {
            return const HomePage();
          }

          // User is NOT Logged in
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
