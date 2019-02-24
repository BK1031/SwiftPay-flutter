import 'package:flutter/material.dart';
import 'package:swift_pay/theme.dart';
import 'package:swift_pay/user_info.dart';
import 'package:firebase_database/firebase_database.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: currBackgroundColor,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(16.0),
      child: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              color: currCardColor,
              child: new Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                child: new Column(
                  children: <Widget>[
                    new Text(
                      fullName.toUpperCase(),
                      style: TextStyle(
                        color: currAccentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                      ),
                    ),
                    new ListTile(
                      title: new Text("Email", style: TextStyle(color: currTextColor),),
                      trailing: new Text(email, style: TextStyle(fontSize: 15.0, color: currTextColor)),
                    ),
                  ],
                ),
              ),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              color: currCardColor,
              child: new Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                child: new Column(
                  children: <Widget>[
                    new Text(
                      "PREFERENCES",
                      style: TextStyle(
                          color: currAccentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0
                      ),
                    ),
                    new SwitchListTile.adaptive(
                      value: darkMode,
                      activeColor: currAccentColor,
                      title: new Text("Dark Mode", style: TextStyle(color: currTextColor),),
                      onChanged: (value) {
                        setState(() {
                          darkMode = value;
                          databaseRef.child("users").child(userID).child("darkMode").set(darkMode);
                          if (darkMode) {
                            currCardColor = darkCardColor;
                            currBackgroundColor = darkBackgroundColor;
                            currTextColor = darkTextColor;
                            currDividerColor = darkDividerColor;
                          }
                          else {
                            currCardColor = lightCardColor;
                            currBackgroundColor = lightBackgroundColor;
                            currTextColor = lightTextColor;
                            currDividerColor = lightDividerColor;
                          }
                        });
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
