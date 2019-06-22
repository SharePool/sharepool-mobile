import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_pool/common/SnackBars.dart';
import 'package:share_pool/driver-settings/driverSettingsPage.dart';
import 'package:share_pool/driver-settings/tourListWidget.dart';
import 'package:share_pool/driver/searchTour.dart';
import 'package:share_pool/model/dto/tour/TourDto.dart';
import 'package:share_pool/util/rest/TourRestClient.dart';

import '../mydrawer.dart';

class DriverPage extends StatefulWidget {
  final String title = "Driver";

  MyDrawer myDrawer;
  TourDto tour;

  DriverPage(this.myDrawer, [this.tour]);

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TourDto selectedTour;
  List<TourDto> tours;

  Future<void> loadTours() async {
    try {
      List<TourDto> tours = await TourRestClient.getToursForUser();

      setState(() {
        this.tours = tours;

        if (widget.tour != null) {
          this.selectedTour = widget.tour;
        } else {
          this.selectedTour =
              tours != null && tours.isNotEmpty ? tours[0] : null;
        }
      });
    } on SocketException {
      _scaffoldKey.currentState
          .showSnackBar(FailureSnackBar("Tours couldn't be loaded!"));
    }
  }

  @override
  void initState() {
    super.initState();

    loadTours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                                      SearchTourPage(widget.myDrawer, tours)));
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
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        curve: Curves.bounceIn,
        overlayOpacity: 0.5,
        tooltip: "You found the easter egg.",
        children: [
          SpeedDialChild(
            child: Icon(Icons.photo_camera),
            label: "Scan QR code",
            backgroundColor: Colors.green,
          ),
          SpeedDialChild(
            child: Icon(Icons.navigation),
            backgroundColor: Colors.blue,
            label: "Create a tour",
          )
        ],
      ),
    );
  }

  String buildQrCodeData() {
    return selectedTour == null ? "error" : selectedTour.tourId.toString();
  }
}
