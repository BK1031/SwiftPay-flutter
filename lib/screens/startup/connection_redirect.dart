import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:swift_pay/user_info.dart';

class ConnectionRedirect extends StatefulWidget {
  @override
  _ConnectionRedirectState createState() => _ConnectionRedirectState();
}

class _ConnectionRedirectState extends State<ConnectionRedirect> {

  final connectionRef = FirebaseDatabase.instance.reference().child(".info/connected");

  Future<void> checkConnection() async {
    connectionRef.onValue.listen((Event event) {
      print(event.snapshot.value);
      if (event.snapshot.value) {
        print("Connected");
        router.navigateTo(context, '/checkAuth', transition: TransitionType.fadeIn, replace: true);
      }
      else {
        print("Not Connected");
        router.navigateTo(context, '/checkConnection', transition: TransitionType.fadeIn, replace: true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
