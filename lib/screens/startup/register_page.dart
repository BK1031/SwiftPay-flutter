import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:swift_pay/theme.dart';
import 'package:fluro/fluro.dart';
import 'package:swift_pay/user_info.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _password = "";
  String _confirm = "";

  final databaseRef = FirebaseDatabase.instance.reference();

  Widget buttonChild = new Text("Create Account");

  void accountErrorDialog(String error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Account Creation Error", style: TextStyle(fontFamily: "Product Sans"),),
          content: new Text(
            "There was an error creating your VC DECA Account: $error",
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

  void register() async {
    if (_firstName == "" || _lastName == "") {
      print("Name cannot be empty");
      accountErrorDialog("Name cannot be empty");
    }
    else if (_password != _confirm) {
      print("Password don't match");
      accountErrorDialog("Passwords do not match");
    }
    else if (_email == "") {
      print("Email cannot be empty");
      accountErrorDialog("Email cannot be empty");
    }
    else {
      try {
        FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        print("Signed in! ${user.uid}");

        firstName = _firstName;
        lastName = _lastName;
        fullName = _firstName + " " + _lastName;
        email = _email;
        userID = user.uid;

        databaseRef.child("users").child(userID).set({
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "userID": userID,
          "darkMode": darkMode
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
    }
    setState(() {
      buttonChild = new Text("Create Account");
    });
  }

  void firstNameField(input) {
    _firstName = input;
  }

  void lastNameField(input) {
    _lastName = input;
  }

  void emailField(input) {
    _email = input;
  }

  void passwordField(input) {
    _password = input;
  }

  void confirmField(input) {
    _confirm = input;
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
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: new Container(
        padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
        child: new Center(
          child: new ListView(
            children: <Widget>[
              new Text("Create your SwiftPay Account below!", style: TextStyle(fontFamily: "Product Sans",), textAlign: TextAlign.center,),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.person),
                    labelText: "First Name",
                    hintText: "Enter your first name"
                ),
                autocorrect: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                onChanged: firstNameField,
              ),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.person),
                    labelText: "Last Name",
                    hintText: "Enter your last name"
                ),
                autocorrect: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                onChanged: lastNameField,
              ),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.email),
                    labelText: "Email",
                    hintText: "Enter your email"
                ),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                onChanged: emailField,
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
                onChanged: passwordField,
              ),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.lock),
                    labelText: "Confirm Password",
                    hintText: "Confirm your password"
                ),
                autocorrect: false,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                obscureText: true,
                onChanged: confirmField,
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new RaisedButton(
                child: buttonChild,
                onPressed: register,
                color: currAccentColor,
                textColor: Colors.white,
                highlightColor: currAccentColor,
              ),
              new Padding(padding: EdgeInsets.all(16.0)),
              new FlatButton(
                child: new Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: currAccentColor,
                  ),
                ),
                splashColor: currAccentColor,
                onPressed: () {
                  router.navigateTo(context,'/login', transition: TransitionType.fadeIn);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
