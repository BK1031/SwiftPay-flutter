import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:swift_pay/theme.dart';
import 'package:swift_pay/user_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HistoryDetailsPage extends StatefulWidget {
  @override
  _HistoryDetailsPageState createState() => _HistoryDetailsPageState();
}

class _HistoryDetailsPageState extends State<HistoryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(currTransaction.name),
      ),
      backgroundColor: currBackgroundColor,
      body: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
