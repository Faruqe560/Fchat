import 'package:flutter/material.dart';

import '../BackEnd/Firebase/Auth/google_auth_firebase.dart';
import '../BackEnd/Firebase/Auth/sign_up_and_sign_in_auth_firebase.dart';
import 'Auth/log_in_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EmailAndPasswordAuth _emailAndPasswordAuth = EmailAndPasswordAuth();
  final GoogleAuthentication _googleAuthentication = GoogleAuthentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              final bool response =
                  await this._googleAuthentication.LogOutFirebase();
              if (!response) {
                await this._emailAndPasswordAuth.LogOutFirebase();
              }
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LogInScreen()),
                  (route) => false);
            },
            child: Text("Log Out")),
      ),
    );
  }
}
