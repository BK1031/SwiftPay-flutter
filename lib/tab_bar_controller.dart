import 'package:flutter/material.dart';
import 'package:swift_pay/screens/history/history_page.dart';
import 'package:swift_pay/screens/home/home_page.dart';
import 'package:swift_pay/screens/settings/settings_page.dart';
import 'theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'user_info.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {

  final databaseRef = FirebaseDatabase.instance.reference();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  int _currentIndex = 0;
  String _title = "SwiftPay";
  Widget _currentBody = new HomePage();

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 1) {
        _title = "Payment History";
        _currentBody = HistoryPage();
      }
      else if (_currentIndex == 2) {
        _title = "Settings";
        _currentBody = SettingsPage();
      }
      else {
        _title = "SwiftPay";
        _currentBody = HomePage();
      }
    });
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print(token);
      databaseRef.child("users").child(userID).child("fcmToken").set(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(_title),
      ),
      body: _currentBody,
      backgroundColor: currBackgroundColor,
      bottomNavigationBar: new Theme(
        data: ThemeData(
          canvasColor: currCardColor,
          primaryColor: currAccentColor
        ),
        child: new BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            new BottomNavigationBarItem(icon: Icon(Icons.home), title: new Text("Home")),
            new BottomNavigationBarItem(icon: Icon(Icons.receipt), title: new Text("History")),
            new BottomNavigationBarItem(icon: Icon(Icons.settings), title: new Text("Settings")),
          ],
        ),
      ),
    );
  }

}
