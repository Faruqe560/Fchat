import 'package:fchat/FrontEnd/Auth/common_auth_methods.dart';
import 'package:fchat/FrontEnd/main_screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../BackEnd/Firebase/onlineDatabaseManagement/new_user_data_firestore.dart';

class TakePrimaryUserData extends StatefulWidget {
  const TakePrimaryUserData({super.key});

  @override
  State<TakePrimaryUserData> createState() => _TakePrimaryUserDataState();
}

class _TakePrimaryUserDataState extends State<TakePrimaryUserData> {
  final GlobalKey<FormState> _SaveInfoformKey = GlobalKey<FormState>();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _userAbout = TextEditingController();
  final CloudStoreDataManagement _cloudStoreDataManagement =
      CloudStoreDataManagement();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LoadingOverlay(
          isLoading: this.isLoading,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              shrinkWrap: true,
              children: [
                //header section
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color.fromARGB(188, 132, 243, 117),
                  ),
                  child: Image(
                    image: AssetImage(
                      "assets/images/fchat.png",
                    ),
                    height: 200.0,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: Text(
                    "Set Up Your Account".toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0,
                      //color: Colors.white,
                    ),
                  ),
                ),
                //header section end
                SizedBox(
                  height: 30.0,
                ),
                Form(
                  key: _SaveInfoformKey,
                  child: Column(
                    children: [
                      CommonTextFormField(
                        hintText: "User Name",
                        labelText: "User Name",
                        prefixIcon: Icon(Icons.person),
                        validator: (inputUserName) {
                          /// Regular Expression
                          final RegExp _messageRegex = RegExp(r'[a-zA-Z0-9]');

                          if (inputUserName!.length < 6)
                            return "User Name At Least 6 Characters";
                          else if (inputUserName.contains(' ') ||
                              inputUserName.contains('@'))
                            return "Space and '@' Not Allowed...User '_' instead of space";
                          else if (inputUserName.contains('__'))
                            return "'__' Not Allowed...User '_' instead of '__'";
                          else if (!_messageRegex.hasMatch(inputUserName))
                            return "Sorry,Only Emoji Not Supported";
                          return null;
                        },
                        textEditingController: _userName,
                      ),
                      CommonTextFormField(
                        hintText: "User About",
                        labelText: "User About",
                        prefixIcon: Icon(Icons.question_mark),
                        validator: (inputVal) {
                          if (inputVal!.length < 6)
                            return "User Name Must have 6 Cherectore";
                          return null;
                        },
                        textEditingController: _userAbout,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                SaveUserInformationButton(context, "Save"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget SaveUserInformationButton(BuildContext context, String buttonName) {
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
        if (this._SaveInfoformKey.currentState!.validate()) {
          print("Data validated");
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          if (mounted) {
            setState(() {
              isLoading = true;
            });
          }
          final bool canRegisterNewUser = await _cloudStoreDataManagement
              .checkThisUserAlreadyPresenOrNot(userName: _userName.text);
          String msg = "";
          if (!canRegisterNewUser)
            msg = "UserName Already Present";
          else {
            final bool _userEntryResponse =
                await _cloudStoreDataManagement.registerNewUser(
                    userName: this._userName.text,
                    userAbout: _userAbout.text,
                    userEmail:
                        FirebaseAuth.instance.currentUser!.email.toString());
            if (_userEntryResponse) {
              msg = "User Data Entry Successfully";
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                  (route) => false);
            } else
              msg = "User Data Not Entry Succssfully";
          }
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        } else {
          print("Data Not Validated");
        }
      },
    );
  }
}
