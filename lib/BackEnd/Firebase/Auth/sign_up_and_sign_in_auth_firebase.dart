import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../global_utils/enum_genaration.dart';

class EmailAndPasswordAuth {
  //for Sign Up Method
  Future<EmailSignUpResults> signUpAuthFirebase(
      {required String email, required String pwd}) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pwd);

      if (userCredential.user!.email != null) {
        await userCredential.user!.sendEmailVerification();
        return EmailSignUpResults.SignUpCompleted;
      }
      return EmailSignUpResults.SignUpNotCompleted;
    } catch (e) {
      print("Error in Emai and Password Sign Up: ${e.toString()}");
      return EmailSignUpResults.EmailAlreadyPresent;
    }
  }

  // for LogIn Method
  Future<EmailSignInResults> LogInAuthFirebase(
      {required String email, required String pwd}) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);
      if (userCredential.user!.emailVerified)
        return EmailSignInResults.SignInCompleted;
      else {
        final LogOutResponse = await LogOutFirebase();
        return EmailSignInResults.EmailNotVerified;
        return EmailSignInResults.UnexpectedError;
      }
    } catch (e) {
      print("Error in Emai and Password Sign Up: ${e.toString()}");
      return EmailSignInResults.EmailOrPasswordInvalid;
    }
  }

  //for logout method
  Future<bool> LogOutFirebase() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
