import 'package:fchat/BackEnd/Firebase/Auth/sign_up_and_sign_in_auth_firebase.dart';
import 'package:fchat/FrontEnd/home_page.dart';
import 'package:fchat/global_utils/enum_genaration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../BackEnd/Firebase/Auth/google_auth_firebase.dart';
import '../../global_utils/reg_exp.dart';
import 'common_auth_methods.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<FormState> _signInformKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();

  final EmailAndPasswordAuth _emailAndPasswordAuth = EmailAndPasswordAuth();
  final GoogleAuthentication _googleAuthentication = GoogleAuthentication();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color.fromARGB(255, 247, 210, 210),
        body: LoadingOverlay(
          isLoading: this.isLoading,
          child: ListView(
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            shrinkWrap: true,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Color.fromARGB(188, 132, 243, 117),
                ),
                child: Image(
                  image: AssetImage(
                    "assets/images/fchat.png",
                  ),
                  height: 280.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Text(
                  "Sign In".toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                    //color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 15.0,
                ),
                height: MediaQuery.of(context).size.height / 2.60,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: this._signInformKey,
                  child: ListView(
                    children: [
                      CommonTextFormField(
                        hintText: "E-Mail",
                        labelText: "E-Mail",
                        prefixIcon: Icon(Icons.email_outlined),
                        validator: (String? inputVal) {
                          if (!emailRegex.hasMatch(inputVal.toString()))
                            return "Email Formate Not Matching";
                          return null;
                        },
                        textEditingController: _email,
                      ),
                      CommonTextFormField(
                        hintText: "Password",
                        labelText: "Password",
                        prefixIcon: Icon(Icons.fingerprint),
                        validator: (String? inputVal) {
                          if (inputVal!.length < 6)
                            return "Password Length must be 6 charecters";
                          return null;
                        },
                        textEditingController: _pwd,
                      ),
                      SignInButton(context, "Log In")
                    ],
                  ),
                ),
              ),
              Center(
                child: Text(
                  "OR",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              LogInSocialMeatiaIntegrationButtons(),
              SwitchAnotherAuthScreen(
                  context, "Don't have a Account?", "Sign Up"),
            ],
          ),
        ),
      ),
    );
  }

  Widget SignInButton(BuildContext context, String buttonName) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(188, 132, 243, 117),
          padding: EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0))),
      child: Text(
        buttonName.toUpperCase(),
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () async {
        if (_signInformKey.currentState!.validate()) {
          print("Validated");
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          if (mounted) {
            setState(() {
              isLoading = true;
            });
          }

          final EmailSignInResults emailSignInResults =
              await this._emailAndPasswordAuth.LogInAuthFirebase(
                    email: this._email.text,
                    pwd: this._pwd.text,
                  );
          String msg = "";
          if (emailSignInResults == EmailSignInResults.SignInCompleted) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomePage()),
                (route) => false);
          } else if (emailSignInResults ==
              EmailSignInResults.EmailNotVerified) {
            msg =
                'Email not Verified.\nPlease Verify your email and then Log In';
          } else if (emailSignInResults ==
              EmailSignInResults.EmailOrPasswordInvalid)
            msg = 'Email And Password Invalid';
          else
            msg = 'Sign In Not Completed';

          if (msg != '')
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg)));
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        } else {
          print("Not Validated");
        }
      },
    );
  }

  //
  //
  //
  Widget LogInSocialMeatiaIntegrationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () async {
            print("Google Preshed");
            if (mounted) {
              setState(() {
                this.isLoading = true;
              });
            }
            final GoogleSignInResults _googleSignInResults =
                await this._googleAuthentication.sighInWithGoogle();
            String msg = "";
            if (_googleSignInResults == GoogleSignInResults.SignInCompleted)
              msg = "Sign In Completed";
            else if (_googleSignInResults ==
                GoogleSignInResults.SignInNotCompleted)
              msg = "Sign In Not Completed";
            else if (_googleSignInResults ==
                GoogleSignInResults.AlreadySignedIn)
              msg = "Already Google Sign In";
            else
              msg = "Unexpected Error Happen";
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg)));

            if (_googleSignInResults == GoogleSignInResults.SignInCompleted)
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
            if (mounted) {
              setState(() {
                this.isLoading = false;
              });
            }
          },
          child: Image(
            image: AssetImage("assets/images/googlelogo.png"),
            width: 50.0,
          ),
        ),
        GestureDetector(
          onTap: () {
            print("Facebook Preshed");
          },
          child: Image(
            image: AssetImage("assets/images/facebooklogo.png"),
            width: 50.0,
          ),
        ),
      ],
    );
  }
}
