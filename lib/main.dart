import 'package:flutter/material.dart';
import 'package:share_pool/driver-settings/driverSettingsPage.dart';
import 'package:share_pool/mydrawer.dart';
import 'package:share_pool/passengerpage.dart';

import 'driverpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  DriverPage driverPage;

  MyApp() {
    MyDrawer myDrawer = new MyDrawer();

    DriverPage driverPage = new DriverPage(myDrawer);
    PassengerPage passengerPage = new PassengerPage(myDrawer);
    DriverSettingsPage settingsPage = new DriverSettingsPage(myDrawer);

    myDrawer.driverPage = driverPage;
    myDrawer.passengerPage = passengerPage;
    myDrawer.settingsPage = settingsPage;

    this.driverPage = driverPage;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SharePool',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: driverPage);
  }
}
