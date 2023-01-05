import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../global_utils/enum_genaration.dart';

class GoogleAuthentication {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInResults> sighInWithGoogle() async {
    try {
      if (await this._googleSignIn.isSignedIn())
        return GoogleSignInResults.AlreadySignedIn;
      else {
        final GoogleSignInAccount? _googleSignInAccount =
            await this._googleSignIn.signIn();
        if (_googleSignInAccount == null) {
          print("Google Sign In not Completed");
          return GoogleSignInResults.SignInNotCompleted;
        } else {
          final GoogleSignInAuthentication _googleSignInAuthentication =
              await _googleSignInAccount.authentication;
          final OAuthCredential _oauthCredential =
              GoogleAuthProvider.credential(
            accessToken: _googleSignInAuthentication.accessToken,
            idToken: _googleSignInAuthentication.idToken,
          );
          final UserCredential userCredential = await FirebaseAuth.instance
              .signInWithCredential(_oauthCredential);
          if (userCredential.user!.email != null)
            return GoogleSignInResults.SignInCompleted;
          else
            print("Google Sign In have Problem");
          return GoogleSignInResults.UnexpectedError;
        }
      }
    } catch (e) {
      print("Error in Google Sign in ${e.toString()}");
      return GoogleSignInResults.UnexpectedError;
    }
  }

  Future<bool> LogOutFirebase() async {
    try {
      print("Google Log Out");
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print("Error in Google Log Out");
      return false;
    }
  }
}
