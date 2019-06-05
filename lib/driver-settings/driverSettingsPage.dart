import 'package:flutter/material.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/driver-settings/editTourPage.dart';
import 'package:share_pool/driver-settings/tourListWidget.dart';
import 'package:share_pool/model/dto/TourDto.dart';
import 'package:share_pool/util/rest/TourRestClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mydrawer.dart';

class DriverSettingsPage extends StatefulWidget {
  final String title = "Your Tours";
  MyDrawer myDrawer;

  DriverSettingsPage(this.myDrawer);

  @override
  _DriverSettingsPageState createState() => _DriverSettingsPageState();
}

class _DriverSettingsPageState extends State<DriverSettingsPage> {
  List<TourDto> tours;

  Future<void> loadTours() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    List<TourDto> tours = await TourRestClient.getToursForUser(
      sharedPreferences.getInt(Constants.SETTINGS_USER_ID));

    setState(() {
      this.tours = tours;
    });
  }

  @override
  void initState() {
    super.initState();

    loadTours();
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
                    builder: (context) => TourEditPage(widget.myDrawer)));
          },
        ),
        drawer: widget.myDrawer,
        // todo make it so empty list is also refreshable
        body: RefreshIndicator(
            child: Center(
              child: tours == null || tours.isEmpty
                  ? Text("No tours defined yet.")
                  : TourListWidget(
                      myDrawer: widget.myDrawer,
                      tours: tours,
                    ),
            ),
            onRefresh: loadTours));
  }
}
