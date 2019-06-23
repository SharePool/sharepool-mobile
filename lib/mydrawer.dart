import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_pool/settingspage.dart';
import 'package:share_pool/statistics/statistics_page.dart';
import 'package:share_pool/user_management/usermanagementpage.dart';
import 'package:share_pool/util/PreferencesService.dart';

import 'driver/driverpage.dart';
import 'model/dto/user/UserDto.dart';

class MyDrawer extends StatefulWidget {
  DriverPage driverPage;
  SettingsPage settingsPage;
  StatisticsPage statisticsPage;

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  UserDto userDto;

  @override
  void initState() {
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userDto?.userName ?? ""),
            accountEmail: Text(userDto?.email ?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  MemoryImage(base64Decode(userDto?.profileImg ?? "")),
            ),
          ),
          ListTile(
            title: Text("Driver"),
            trailing: Icon(Icons.time_to_leave),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => widget.driverPage));
            },
          ),
          ListTile(
            title: Text("Statistics"),
            trailing: Icon(Icons.insert_chart),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => widget.statisticsPage));
            },
          ),
          ListTile(
            title: Text("Settings"),
            trailing: Icon(Icons.settings),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => widget.settingsPage));
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
    PreferencesService.deleteUserInfo();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => new UserManagementPage(widget.driverPage)));
  }

  Future getUserInfo() async {
    UserDto loggedInUser = await PreferencesService.getLoggedInUser();
    setState(() {
      userDto = loggedInUser;
    });
  }
}
