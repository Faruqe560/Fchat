import 'package:fchat/BackEnd/Firebase/Auth/sign_up_auth_firebase.dart';
import 'package:fchat/FrontEnd/Auth/common_auth_methods.dart';
import 'package:fchat/FrontEnd/Auth/log_in_screen.dart';
import 'package:fchat/global_utils/reg_exp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../global_utils/enum_genaration.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _signUpformKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  final TextEditingController _confirmPwd = TextEditingController();
  bool isLoading = false;
  final EmailAndPasswordAuth _emailAndPasswordAuth = EmailAndPasswordAuth();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  "Sign Up".toUpperCase(),
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
                  key: this._signUpformKey,
                  child: ListView(
                    children: [
                      CommonTextFormField(
                        hintText: "E-Mail",
                        labelText: "E-Mail",
                        prefixIcon: Icon(Icons.email_outlined),
                        validator: (inputVal) {
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
                          textEditingController: this._pwd),
                      CommonTextFormField(
                          hintText: "Confirm Password",
                          labelText: "Confirm Password",
                          prefixIcon: Icon(Icons.fingerprint),
                          validator: (String? inputVal) {
                            if (inputVal!.length < 6)
                              return "Password Length must be 6 charecters";
                            if (this._pwd.text != this._confirmPwd.text)
                              return "Password and confirm Password not same Here.";
                            return null;
                          },
                          textEditingController: this._confirmPwd),
                      SignUpButton(context, "Sign Up")
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
              SocialMeatiaIntegrationButtons(),
              SwitchAnotherAuthScreen(
                  context, "Already have an account?", "Log In")
            ],
          ),
        ),
      ),
    );
  }

  Widget SignUpButton(BuildContext context, String buttonName) {
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
        if (this._signUpformKey.currentState!.validate()) {
          print("Validated");
          if (mounted) {
            setState(() {
              this.isLoading = true;
            });
          }
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          final response = await this._emailAndPasswordAuth.signUpAuthFirebase(
                email: this._email.text,
                pwd: this._pwd.text,
              );
          if (response == EmailSignUpResults.SignUpCompleted) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => LogInScreen()));
          } else {
            final String msg =
                response == EmailSignUpResults.EmailAlreadyPresent
                    ? "Email Already Present Here"
                    : "Sign Up Not Completed";
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg)));
          }
        } else {
          print("Not Validated");
        }
        if (mounted) {
          setState(() {
            this.isLoading = false;
          });
        }
      },
    );
  }
}
