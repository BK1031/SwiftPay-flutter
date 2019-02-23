import 'package:flutter/material.dart';
import 'package:swift_pay/theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
