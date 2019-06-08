import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/user/UserDto.dart';
import 'package:share_pool/mydrawer.dart';
import 'package:share_pool/passengerpage.dart';
import 'package:share_pool/settingspage.dart';
import 'package:share_pool/user_management/usermanagementpage.dart';
import 'package:share_pool/util/rest/UserRestClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'driver/driverpage.dart';

bool _isAuthenticated = false;
UserDto currentUser;

void main() async {
  _isAuthenticated = await _checkUserLoggedIn() != null;

  try {
    currentUser = await UserRestClient.getUser();
  } on SocketException catch (e) {
    print("Error fetching user from server");
  }

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
          primarySwatch: Colors.blueGrey,
        ),
        home:
        _isAuthenticated ? driverPage : new UserManagementPage(
            driverPage, currentUser));
  }

  @override
  initState() {
    super.initState();

    if (currentUser == null) {
//      showDialog(
//          context: context,
//          builder: (BuildContext context) {
//            return SimpleDialog(
//              title: const Text('Server not reachable'),
//              children: <Widget>[
//                SimpleDialogOption(
//                  onPressed: () {
//                    exit(0);
//                  },
//                  child: const Text('OK'),
//                ),
//              ],
//            );
//          });
    }

    MyDrawer myDrawer = new MyDrawer(currentUser);

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

  return prefs.getString(Constants.SETTINGS_USER_TOKEN) ?? null;
}
