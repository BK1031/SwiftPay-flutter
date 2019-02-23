import 'package:flutter/material.dart';
import 'package:swift_pay/theme.dart';
import 'package:swift_pay/user_info.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            )
          ],
        ),
      ),
    );
  }
}
