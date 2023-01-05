import 'package:fchat/FrontEnd/Auth/log_in_screen.dart';
import 'package:fchat/FrontEnd/Auth/sign_up_screen.dart';
import 'package:flutter/material.dart';

Widget SwitchAnotherAuthScreen(
  BuildContext context,
  String buttonNameFirst,
  String buttonNameLast,
) {
  return TextButton(
      onPressed: () {
        if (buttonNameLast == "Log In")
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => LogInScreen()));
        else
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => SignUpScreen()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            buttonNameFirst,
            style: TextStyle(color: Colors.black),
          ),
          Text(
            buttonNameLast.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ));
}

// Widget SocialMeatiaIntegrationButtons() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: [
//       GestureDetector(
//         onTap: () {
//           print("Google Preshed");
//         },
//         child: Image(
//           image: AssetImage("assets/images/googlelogo.png"),
//           width: 50.0,
//         ),
//       ),
//       GestureDetector(
//         onTap: () {
//           print("Facebook Preshed");
//         },
//         child: Image(
//           image: AssetImage("assets/images/facebooklogo.png"),
//           width: 50.0,
//         ),
//       ),
//     ],
//   );
// }

// Widget SignInAndSignUpButton(BuildContext context, String buttonName) {
//   return ElevatedButton(
//     style: ElevatedButton.styleFrom(
//         backgroundColor: Color.fromARGB(188, 132, 243, 117),
//         padding: EdgeInsets.symmetric(vertical: 15.0),
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
//     child: Text(
//       buttonName.toUpperCase(),
//       style: TextStyle(
//         fontSize: 22.0,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     onPressed: () {},
//   );
// }

Widget CommonTextFormField({
  required String hintText,
  required String labelText,
  required Icon prefixIcon,
  required String? Function(String?)? validator,
  required TextEditingController textEditingController,
}) {
  return Container(
    padding: EdgeInsets.only(bottom: 15.0),
    child: TextFormField(
      validator: validator,
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
      ),
    ),
  );
}
//So I have found the solution. On windows, open terminal and write "cd C:\Users\put_here_your_username\.android" and then write "keytool -list -v -keystore ".\debug.keystore" -alias androiddebugkey -storepass android -keypass android"