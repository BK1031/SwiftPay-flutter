import 'package:flutter/material.dart';
import 'package:swift_pay/models/transaction.dart';
import 'package:swift_pay/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:swift_pay/user_info.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  List<Transaction> historyList = new List();

  @override
  void initState() {
    super.initState();
    databaseRef.child("users").child(userID).child("history").onChildAdded.listen((Event event) {
      setState(() {
        var history = event.snapshot.value;
        historyList.add(new Transaction(history["name"], history["id"], history["date"], history["price"], history["lat"], history["long"]));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: new ListView.builder(
        itemCount: historyList.length,
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
                      "\$${historyList[index].price}",
                      style: TextStyle(color: currAccentColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    new Expanded(
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            historyList[index].name,
                            style: TextStyle(color: currTextColor, fontSize: 18.0),
                          ),
                          new Padding(padding: EdgeInsets.all(4.0)),
                          new Text(
                            "${historyList[index].date}",
                            style: TextStyle(color: currTextColor, fontSize: 15.0),
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
    );
  }
}
