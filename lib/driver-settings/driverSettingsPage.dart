import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:share_pool/driver-settings/addTourPage.dart';
import 'package:share_pool/driver-settings/tourListWidget.dart';

import '../mydrawer.dart';
import 'dto/tourDto.dart';

class DriverSettingsPage extends StatefulWidget {
  final String title = "Your Tours";
  MyDrawer myDrawer;

  DriverSettingsPage(this.myDrawer);

  @override
  _DriverSettingsPageState createState() => _DriverSettingsPageState();
}

class _DriverSettingsPageState extends State<DriverSettingsPage> {
  List<TourDto> tours;

  Future<void> getToursForUser() async {
    // todo get user id from context
    var response = await get("http://192.168.0.7:8080/tours/users/1");

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      print(parsed);

      this.setState(() {
        tours = parsed.map<TourDto>((json) => TourDto.fromJson(json)).toList();
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTourPage(widget.myDrawer)));
          },
        ),
        drawer: widget.myDrawer,
        body: RefreshIndicator(
            child: Center(
              child: tours == null || tours.isEmpty
                  ? Text("No tours defined yet.")
                  : TourListWidget(
                myDrawer: widget.myDrawer,
                tours: tours,
              ),
            ),
            onRefresh: getToursForUser));
  }
}
