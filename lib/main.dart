import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:swift_pay/screens/startup/auth_checker.dart';
import 'package:swift_pay/screens/startup/connection_checker.dart';
import 'package:swift_pay/screens/startup/connection_redirect.dart';
import 'package:swift_pay/screens/startup/login_page.dart';
import 'package:swift_pay/screens/startup/register_page.dart';
import 'package:swift_pay/theme.dart';
import 'tab_bar_controller.dart';
import 'user_info.dart';

void main() {

  // Define Fluro Routes
  router.define('/checkConnection', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ConnectionChecker();
  }));
  router.define('/checkConnectionAgain', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ConnectionRedirect();
  }));
  router.define('/checkAuth', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AuthChecker();
  }));
  router.define('/logged', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TabBarController();
  }));
  router.define('/login', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoginPage();
  }));
  router.define('/register', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new RegisterPage();
  }));

  runApp(new MaterialApp(
    title: "SwiftPay",
    home: new ConnectionChecker(),
    onGenerateRoute: router.generator,
    theme: mainTheme,
  ));
}