import 'package:flutter/material.dart';

bool darkMode = true;

// LIGHT THEME
const lightTextColor = Colors.black;
const lightAccentColor = Color(0xFFff6100);
const lightBackgroundColor = Colors.white;
const lightCardColor = Color(0xFFDFE0E5);
const lightDividerColor = const Color(0xFFC9C9C9);

// DARK THEME
const darkTextColor = Colors.white;
const darkAccentColor = Color(0xFFff6100);
const darkBackgroundColor = const Color(0xFF212121);
const darkCardColor = const Color(0xFF2C2C2C);
const darkDividerColor = const Color(0xFF616161);

// CURRENT COLORs
var currTextColor = darkTextColor;
var currAccentColor = lightAccentColor;
var currBackgroundColor = darkBackgroundColor;
var currCardColor = darkCardColor;
var currDividerColor = darkDividerColor;

ThemeData mainTheme = new ThemeData(
  accentColor: currAccentColor,
  primaryColor: currAccentColor
);