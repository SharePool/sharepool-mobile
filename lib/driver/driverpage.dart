import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_pool/driver-settings/driverSettingsPage.dart';
import 'package:share_pool/driver-settings/editTourPage.dart';
import 'package:share_pool/driver-settings/tourListWidget.dart';
import 'package:share_pool/driver/searchTour.dart';
import 'package:share_pool/model/dto/tour/TourDto.dart';
import 'package:share_pool/util/PreferencesService.dart';
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
      List<TourDto> tours = await TourRestClient.getToursForUser(
          await PreferencesService.getUserId());

      setState(() {
        this.tours = tours;

        if (widget.tour != null) {
          this.selectedTour = widget.tour;
        } else {
          this.selectedTour =
          tours != null && tours.isNotEmpty ? tours[0] : null;
        }
      });
    } on SocketException catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Tours couldn't be loaded!"),
        duration: Duration(seconds: 3),
      ));
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
