import 'dart:async';
import 'package:flutter/material.dart';
import 'package:swift_pay/theme.dart';
import 'package:swift_pay/user_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  var geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 5);

  StreamSubscription<Position> positionStream;

  Future getLocationStream() async {
    positionStream = geolocator.getPositionStream(locationOptions).listen((Position position) {
      print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
    });
  }
  
  Future getGeofences(double lat, double long) async {
    await http.get(url)
  }

  @override
  void initState() {
    super.initState();
    getLocationStream();
  }

  @override
  void dispose() {
    super.dispose();
    positionStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: currBackgroundColor,
      child: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Card(
              color: currCardColor,
              child: new Container(
              ),
            )
          ],
        ),
      ),
    );
  }
}
