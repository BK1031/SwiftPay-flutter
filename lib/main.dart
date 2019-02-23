import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:swift_pay/theme.dart';
import 'tab_bar_controller.dart';
import 'user_info.dart';

void main() {

  // Define Fluro Routes
  router.define('/logged', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TabBarController();
  }));

  
  runApp(new MaterialApp(
    title: "SwiftPay",
    home: new TabBarController(),
    onGenerateRoute: router.generator,
    theme: mainTheme,
  ));
}