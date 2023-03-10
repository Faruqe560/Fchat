import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../global_utils/reg_exp.dart';
import 'common_auth_methods.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<FormState> _signInformKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color.fromARGB(255, 247, 210, 210),
        body: ListView(
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
            SocialMeatiaIntegrationButtons(),
            SwitchAnotherAuthScreen(
                context, "Don't have a Account?", "Sign Up"),
          ],
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
      onPressed: () {
        if (_signInformKey.currentState!.validate()) {
          print("Validated");
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        } else {
          print("Not Validated");
        }
      },
    );
  }
}
