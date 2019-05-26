import 'package:flutter/material.dart';
import 'package:share_pool/user_management/usermanagementpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'driverpage.dart';
import 'passengerpage.dart';
import 'settingspage.dart';

class MyDrawer extends StatelessWidget {
  DriverPage driverPage;
  PassengerPage passengerPage;
  SettingsPage settingsPage;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Geanik"),
            accountEmail: Text("geanik@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://store.playstation.com/store/api/chihiro/00_09_000/container/US/en/999/UP0151-CUSA09971_00-AV00000000000001/1553247430000/image?w=240&h=240&bg_color=000000&opacity=100&_version=00_09_000"),
            ),
          ),
          ListTile(
            title: Text("Driver"),
            trailing: Icon(Icons.time_to_leave),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => this.driverPage));
            },
          ),
          ListTile(
            title: Text("Passenger"),
            trailing: Icon(Icons.thumb_up),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => this.passengerPage));
            },
          ),
          ListTile(
            title: Text("Settings"),
            trailing: Icon(Icons.settings),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => this.settingsPage));
            },
          ),
          ListTile(
            title: Text("Logout"),
            trailing: Icon(Icons.exit_to_app),
            onTap: () {
              logoutUser(context);
            },
          ),
        ],
      ),
    );
  }

  void logoutUser(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userToken");

    Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (context) => new UserManagementPage(driverPage)));
  }
}
