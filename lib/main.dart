import 'package:flutter/material.dart';
import 'package:share_pool/mydrawer.dart';
import 'package:share_pool/passengerpage.dart';
import 'package:share_pool/settingspage.dart';
import 'package:share_pool/user_management/usermanagementpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'driverpage.dart';

bool _isAuthenticated = false;

void main() async {
  _isAuthenticated = await _checkUserLoggedIn() != null;

  runApp(App());
}

class App extends StatefulWidget {
  MyApp() {}

  @override
  Widget build(BuildContext context) {}

  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  Widget startScreen;

  DriverPage driverPage;
  PassengerPage passengerPage;
  SettingsPage settingsPage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SharePool',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: _isAuthenticated ? driverPage : new UserManagementPage(
            driverPage));
  }

  @override
  initState() {
    super.initState();

    MyDrawer myDrawer = new MyDrawer();

    driverPage = new DriverPage(myDrawer);
    passengerPage = new PassengerPage(myDrawer);
    settingsPage = new SettingsPage(myDrawer);

    myDrawer.driverPage = driverPage;
    myDrawer.passengerPage = passengerPage;
    myDrawer.settingsPage = settingsPage;
  }
}

Future<String> _checkUserLoggedIn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString("userToken") ?? null;
}
