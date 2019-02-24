import 'dart:async';
import 'package:flutter/material.dart';
import 'package:swift_pay/models/geofence.dart';
import 'package:swift_pay/secret.dart';
import 'package:swift_pay/theme.dart';
import 'package:swift_pay/user_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:date_format/date_format.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  var geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 5);

  String paymentStatus = "";
  bool _paymentVisible = false;

  StreamSubscription<Position> positionStream;
  List<Geofence> fenceList = new List();

  Future getLocationStream() async {
    positionStream = geolocator.getPositionStream(locationOptions).listen((Position position) {
      print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
      getGeofences(position.latitude, position.longitude);
      databaseRef.child("users").child(userID).update({
        "lat": position.latitude,
        "long": position.longitude
      });
    });
  }
  
  Future getGeofences(double lat, double long) async {
    await http.get("https://api.tomtom.com/geofencing/1/report/$projectID?key=$key&point=$long,$lat&range=10000").then((response) {
      print(response.body);
      var responseJson = jsonDecode(response.body);
      var insideJson = responseJson["inside"]["features"];
      var outsideJson = responseJson["outside"]["features"];
      setState(() {
        fenceList.clear();
        for (int i = 0; i < insideJson.length; i++) {
          print("Inside - ${insideJson[i]["name"]}");
          fenceList.add(new Geofence(insideJson[i]["id"], insideJson[i]["name"], insideJson[i]["distance"], insideJson[i]["properties"]["price"], insideJson[i]["geometry"]["coordinates"][1], insideJson[i]["geometry"]["coordinates"][0], true));
          databaseRef.child("geofences").child(fenceList[i].id).child("transactions").child(userID).child("completed").once().then((DataSnapshot snapshot) {
            if (snapshot.value == null) {
              print("Creating new transaction @ ${fenceList[i].name}");
              currFence = fenceList[i];
              databaseRef.child("geofences").child(fenceList[i].id).child("transactions").child(userID).set({
                "completed": false,
                "started": false,
                "fcmToken": fcmToken
              });
              autoPay();
            }
            else {
              print("Transaction Already Exists!");
            }
          });
        }
        for (int i = 0; i < outsideJson.length; i++) {
          print("Outside - ${outsideJson[i]["name"]}");
          fenceList.add(new Geofence(outsideJson[i]["id"], outsideJson[i]["name"], outsideJson[i]["distance"], outsideJson[i]["properties"]["price"], outsideJson[i]["geometry"]["coordinates"][1], outsideJson[i]["geometry"]["coordinates"][0], false));
        }
      });
    });
  }

  Future autoPay() async {
    print("STARTING AUTOMATIC PAYMENT PROCCESS");
    setState(() {
      _paymentVisible = true;
      paymentStatus = "Transaction in Progress...";
    });
    databaseRef.child("geofences").child(currFence.id).child("transactions").child(userID).child("started").set(true);
    await Future.delayed(const Duration(seconds: 3), () {
      databaseRef.child("geofences").child(currFence.id).child("transactions").child(userID).child("completed").set(true);
      setState(() {
        _paymentVisible = true;
        paymentStatus = "Payment Successful!";
      });
      // Update history in Firebase
      databaseRef.child("users").child(userID).child("history").push().set({
        "id": currFence.id,
        "name": currFence.name,
        "lat": currFence.lat,
        "long": currFence.long,
        "price": currFence.price,
        "date": formatDate(DateTime.now(), [mm, '/', dd, '/', yyyy, ' ', HH, ':', mm])
      });
      databaseRef.child("geofences").child(currFence.id).child("completedTransactions").child(userID).set({
        "name": currFence.name,
        "date": formatDate(DateTime.now(), [mm, '/', dd, '/', yyyy, ' ', HH, ':', mm])
      });
    });
    await Future.delayed(const Duration(seconds: 5), () {
      print("Removing from current transactions");
      databaseRef.child("geofences").child(currFence.id).child("transactions").child(userID).remove();
      setState(() {
        _paymentVisible = false;
        paymentStatus = "";
      });
    });
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
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(12.0),
        color: currBackgroundColor,
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new ListView.builder(
                itemCount: fenceList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(4.0),
                    child: new Card(
                      color: currCardColor,
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      child: new Container(
                        padding: EdgeInsets.all(8.0),
                        child: new Row(
                          children: <Widget>[
                            new Text(
                              "\$${fenceList[index].price}",
                              style: TextStyle(color: currAccentColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            new Expanded(
                              child: new Column(
                                children: <Widget>[
                                  new Text(
                                    fenceList[index].name,
                                    style: TextStyle(color: currTextColor, fontSize: 18.0),
                                  ),
                                  new Padding(padding: EdgeInsets.all(4.0)),
                                  new Text(
                                    "${fenceList[index].distance.abs().toString()} m",
                                    style: TextStyle(color: currTextColor, fontSize: 15.0),
                                  ),
                                  new Visibility(visible: _paymentVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
                                  new Visibility(
                                    visible: _paymentVisible,
                                    child: new Text(
                                      paymentStatus,
                                      style: TextStyle(color: currAccentColor, fontSize: 18.0),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
