import 'package:flutter/material.dart';
import 'mydrawer.dart';

class SettingsPage extends StatefulWidget {
  final String title = "Settings";
  MyDrawer myDrawer;

  SettingsPage(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  _SettingsPageState createState() => _SettingsPageState(this.myDrawer);
}

class _SettingsPageState extends State<SettingsPage> {
  MyDrawer myDrawer;

  _SettingsPageState(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: myDrawer,
    );
  }
}
