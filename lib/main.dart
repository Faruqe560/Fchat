import 'package:fchat/BackEnd/Firebase/onlineDatabaseManagement/new_user_data_firestore.dart';
import 'package:fchat/FrontEnd/Auth/log_in_screen.dart';
import 'package:fchat/FrontEnd/main_screens/main_screen.dart';
import 'package:fchat/FrontEnd/new_users_entry/new_users_entry.dart';
import 'package:flutter/material.dart';
import 'FrontEnd/Auth/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    title: 'Fchat',
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    home: await differentContextDecisionTake(),
  ));
}

Future<Widget> differentContextDecisionTake() async {
  if (FirebaseAuth.instance.currentUser == null &&
      FirebaseAuth.instance.currentUser!.email == null) {
    return LogInScreen();
  } else {
    final CloudStoreDataManagement _cloudStoreDataManagement =
        CloudStoreDataManagement();
    final bool _dataPresentResponse =
        await _cloudStoreDataManagement.userRecordPresentOrNot(
            email: FirebaseAuth.instance.currentUser!.email.toString());
    return _dataPresentResponse ? MainScreen() : TakePrimaryUserData();
  }
}
