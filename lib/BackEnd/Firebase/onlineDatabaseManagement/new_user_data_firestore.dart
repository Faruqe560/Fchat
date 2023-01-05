import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class CloudStoreDataManagement {
  final _collectionName = "Fchat_users";
  Future<bool> checkThisUserAlreadyPresenOrNot(
      //chace user already present or not
      {required String userName}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> findReqRusults =
          await FirebaseFirestore.instance
              .collection(_collectionName)
              .where("user_name", isEqualTo: userName)
              .get();
      print("Debug1:${findReqRusults.docs}");

      return findReqRusults.docs.isEmpty ? true : false;
    } catch (e) {
      print("Error. Check THis User Already Presen or Not: ${e.toString()}");
      return false;
    }
  }

  Future<bool> registerNewUser( // user registration if user already not present
      {
    required String userName,
    required String userAbout,
    required String userEmail,
  }) async {
    try {
      final String? _getToken = await FirebaseMessaging.instance.getToken();

      final String currDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

      final String currTime = "${DateFormat('hh:mm a').format(DateTime.now())}";
      await FirebaseFirestore.instance.doc("$_collectionName/$userEmail").set({
        "about": userAbout,
        "activity": [],
        "connection_request": [],
        "connections": {},
        "creation_date": currDate,
        "creation_time": currTime,
        "phone_number": "",
        "profile_pic": "",
        "token": _getToken.toString(),
        "total_connections": "",
        "user_name": userName,
      });
      return true;
    } catch (e) {
      print("Error in Register new User${e.toString()}");
      return false;
    }
  }

  Future<bool> userRecordPresentOrNot({required String email}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.doc("$_collectionName/$email").get();
      return documentSnapshot.exists;
    } catch (e) {
      print("Error in User Record Presen of not ${e.toString()}");
      return false;
    }
  }
}
