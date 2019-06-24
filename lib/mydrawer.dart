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
  UserDto _userDto;

  @override
  void initState() {
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_userDto?.userName ?? ""),
            accountEmail: Text(_userDto?.email ?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
              _userDto?.profileImg == null || _userDto.profileImg.isEmpty
                  ? ExactAssetImage("assets/profile_img_placeholder.png")
                  : MemoryImage(base64Decode(_userDto?.profileImg)),
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
              _logoutUser(context);
            },
          ),
        ],
      ),
    );
  }

  void _logoutUser(BuildContext context) async {
    PreferencesService.deleteUserInfo();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => new UserManagementPage(widget.driverPage)));
  }

  Future _getUserInfo() async {
    UserDto loggedInUser = await PreferencesService.getLoggedInUser();
    setState(() {
      _userDto = loggedInUser;
    });
  }
}
