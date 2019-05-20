import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:share_pool/driver-settings/addTourPage.dart';

import '../mydrawer.dart';

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

  List tours;

  _SettingsPageState(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  void getToursForUser() async {
    // todo get user id from context
    var response = await get("http://192.168.0.7:8080/tours/users/1");

    print(response.body);

    if (response.statusCode == 200) {
      this.setState(() {
        tours = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    getToursForUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddTourPage(myDrawer)));
          },
        ),
        drawer: myDrawer,
        body: Center(
          child: tours == null || tours.isEmpty
              ? Text("No tours defined yet.")
              : ListView.builder(
                  itemCount: tours == null ? 0 : tours.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: new Text(tours[index]["fromLocation"]),
                    );
                  }),
        ));
  }
}
