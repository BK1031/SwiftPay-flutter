import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:swift_pay/models/geofence.dart';
import 'package:swift_pay/models/transaction.dart';

final router = Router();

String firstName = "[ERROR]";
String lastName = "[ERROR]";
String fullName = "[ERROR]";
String email = "Email Not Found";
String userID = "";
String fcmToken = "";

Geofence currFence;
Transaction currTransaction;