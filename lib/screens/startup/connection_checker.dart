import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:swift_pay/user_info.dart';

class ConnectionChecker extends StatefulWidget {
  @override
  _ConnectionCheckerState createState() => _ConnectionCheckerState();
}

class _ConnectionCheckerState extends State<ConnectionChecker> {

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
        router.navigateTo(context, '/checkConnectionAgain', transition: TransitionType.fadeIn, replace: true);
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
