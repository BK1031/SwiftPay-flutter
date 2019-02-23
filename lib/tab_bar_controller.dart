import 'package:flutter/material.dart';
import 'package:swift_pay/screens/history/history_page.dart';
import 'package:swift_pay/screens/home/home_page.dart';
import 'package:swift_pay/screens/settings/settings_page.dart';
import 'theme.dart';
import 'user_info.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {

  int _currentIndex = 0;
  String _title = "SwiftPay";
  Widget _currentBody = new HomePage();

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 1) {
        _title = "Payment History";
        _currentBody = HistoryPage();
      }
      else if (_currentIndex == 2) {
        _title = "Settings";
        _currentBody = SettingsPage();
      }
      else {
        _title = "SwiftPay";
        _currentBody = HomePage();
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(_title),
      ),
      body: _currentBody,
      backgroundColor: currBackgroundColor,
      bottomNavigationBar: new Theme(
        data: ThemeData(
          canvasColor: currCardColor,
          primaryColor: currAccentColor
        ),
        child: new BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            new BottomNavigationBarItem(icon: Icon(Icons.home), title: new Text("Home")),
            new BottomNavigationBarItem(icon: Icon(Icons.receipt), title: new Text("History")),
            new BottomNavigationBarItem(icon: Icon(Icons.settings), title: new Text("Settings")),
          ],
        ),
      ),
    );
  }

}
