import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:swift_pay/theme.dart';
import 'package:fluro/fluro.dart';
import 'package:swift_pay/user_info.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email = "";
  String _password = "";

  final databaseRef = FirebaseDatabase.instance.reference();

  Widget buttonChild = new Text("Login");

  void accountErrorDialog(String error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Login Error"),
          content: new Text(
            "There was an error logging you in: $error",
            style: TextStyle(fontFamily: "Product Sans", fontSize: 14.0),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("GOT IT"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void login() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      print("Signed in! ${user.uid}");

      userID = user.uid;

      databaseRef.child("users").child(userID).once().then((DataSnapshot snapshot) {
        var userInfo = snapshot.value;
        email = userInfo["email"];
        firstName = userInfo["firstName"];
        lastName = userInfo["lastName"];
        darkMode = userInfo["darkMode"];
        fullName = firstName + " " + lastName;
        print("");
        print("------------ USER DEBUG INFO ------------");
        print("NAME: $firstName $lastName}");
        print("EMAIL: $email");
        print("USERID: $userID");
        print("-----------------------------------------");
        print("");
        if (email == null || firstName == null || lastName == null) {
          FirebaseAuth.instance.signOut();
          router.navigateTo(context, '/register', transition: TransitionType.fadeIn, replace: true);
        }
      });
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
      await Future.delayed(const Duration(milliseconds: 300), () {
        router.navigateTo(context, '/logged', transition: TransitionType.fadeIn, replace: true);
      });
    }
    catch (error) {
      print("Error: ${error.details}");
      accountErrorDialog(error.details);
    }
    setState(() {
      buttonChild = new Text("Login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: currAccentColor,
        title: Text(
          "SwiftPay",
          style: TextStyle(
              fontFamily: "Product Sans",
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: new Container(
        padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
        child: new Center(
          child: new ListView(
            children: <Widget>[
              new Text("Login to your SwiftPay Account below!", style: TextStyle(fontFamily: "Product Sans",), textAlign: TextAlign.center,),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.email),
                    labelText: "Email",
                    hintText: "Enter your email"
                ),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                onChanged: (input) {
                  _email = input;
                },
              ),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.lock),
                    labelText: "Password",
                    hintText: "Enter a password"
                ),
                autocorrect: false,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                obscureText: true,
                onChanged: (input) {
                  _password = input;
                },
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new RaisedButton(
                child: buttonChild,
                onPressed: login,
                color: currAccentColor,
                textColor: Colors.white,
              ),
              new Padding(padding: EdgeInsets.all(16.0)),
              new FlatButton(
                child: new Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: currAccentColor,
                  ),
                ),
                splashColor: currAccentColor,
                onPressed: () {
                  router.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
