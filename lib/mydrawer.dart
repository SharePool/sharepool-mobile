import 'package:flutter/material.dart';
import 'package:share_pool/settingspage.dart';
import 'package:share_pool/user_management/usermanagementpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/Constants.dart';
import 'driver/driverpage.dart';
import 'model/dto/user/UserDto.dart';
import 'passengerpage.dart';

class MyDrawer extends StatelessWidget {
  DriverPage driverPage;
  PassengerPage passengerPage;
  SettingsPage settingsPage;

  final UserDto userDto;

  MyDrawer(this.userDto);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userDto?.userName ?? ""),
            accountEmail: Text(userDto?.email ?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://images.sk-static.com/images/media/img/col6/20180129-145533-323755.jpg"),
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
    prefs.remove(Constants.SETTINGS_USER_TOKEN);
    prefs.remove(Constants.SETTINGS_USER_ID);

    Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (context) => new UserManagementPage(driverPage, userDto)));
  }
}
