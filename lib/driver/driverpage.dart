import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/driver-settings/driverSettingsPage.dart';
import 'package:share_pool/driver-settings/editTourPage.dart';
import 'package:share_pool/driver-settings/tourListWidget.dart';
import 'package:share_pool/driver/searchTour.dart';
import 'package:share_pool/model/dto/tour/TourDto.dart';
import 'package:share_pool/util/rest/TourRestClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mydrawer.dart';

class DriverPage extends StatefulWidget {
  final String title = "Driver";
  MyDrawer myDrawer;

  DriverPage(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  TourDto selectedTour;
  List<TourDto> tours;

  Future<void> loadTours() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    List<TourDto> tours = await TourRestClient.getToursForUser(
        sharedPreferences.getInt(Constants.SETTINGS_USER_ID));

    setState(() {
      this.tours = tours;
      this.selectedTour = tours != null ? tours[0] : null;
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
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DriverSettingsPage(widget.myDrawer))))
        ],
      ),
      drawer: widget.myDrawer,
      body: Center(
        child: tours == null || tours.isEmpty
            ? Text("No tours defined yet.")
            : Column(children: <Widget>[
                Spacer(),
                Row(
                  children: <Widget>[
                    Flexible(
                        child: new TourCard(selectedTour, widget.myDrawer)),
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchTourPage(widget.myDrawer)));
                        })
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: QrImage(
                      data: buildQrCodeData(),
                      onError: (ex) {
                        print("[QR] ERROR - $ex");
                      }),
                ),
                Spacer()
              ]),
      ),
      floatingActionButton: tours == null || tours.isEmpty
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TourEditPage(widget.myDrawer)));
              },
            )
          : null,
    );
  }

  String buildQrCodeData() {
    return selectedTour == null ? "error" : selectedTour.tourId.toString();
  }
}
