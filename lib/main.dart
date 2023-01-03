import 'package:flutter/material.dart';
import 'FrontEnd/Auth/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fchat',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: SignUpScreen(),
    );
  }
}
