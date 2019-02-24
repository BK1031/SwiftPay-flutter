import 'package:flutter/material.dart';
import 'package:swift_pay/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:swift_pay/user_info.dart';

class AuthChecker extends StatefulWidget {
  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {

  final databaseRef = FirebaseDatabase.instance.reference();

  Future<void> checkUserLogged() async {
    var user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      //User logged in
      print("User Logged");
      userID = user.uid;

      databaseRef.child("users").child(userID).once().then((DataSnapshot snapshot) {
        var userInfo = snapshot.value;
        email = userInfo["email"];
        firstName = userInfo["firstName"];
        lastName = userInfo["lastName"];
        fullName = firstName + " " + lastName;
        darkMode = userInfo["darkMode"];
        fcmToken = userInfo["fcmToken"];
        print("");
        print("------------ USER DEBUG INFO ------------");
        print("NAME: $firstName $lastName}");
        print("EMAIL: $email");
        print("USERID: $userID");
        print("-----------------------------------------");
        print("");
        if (email == null || firstName == null || lastName == null) {
          // User Data Corrupted (Log Out)
          FirebaseAuth.instance.signOut();
          router.navigateTo(context, '/register', transition: TransitionType.fadeIn, replace: true);
        }
        if (darkMode) {
          setState(() {
            currCardColor = darkCardColor;
            currBackgroundColor = darkBackgroundColor;
            currTextColor = darkTextColor;
            currDividerColor = darkDividerColor;
          });
        }
        else {
          setState(() {
            currCardColor = lightCardColor;
            currBackgroundColor = lightBackgroundColor;
            currTextColor = lightTextColor;
            currDividerColor = lightDividerColor;
          });
        }
      });
      await Future.delayed(const Duration(milliseconds: 300), () {
        router.navigateTo(context, '/logged', transition: TransitionType.fadeIn, replace: true);
      });
    }
    else {
      //User log required
      print("User Not Logged");
      router.navigateTo(context, '/register', transition: TransitionType.fadeIn, replace: true);
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: currAccentColor,
    );
  }
}
