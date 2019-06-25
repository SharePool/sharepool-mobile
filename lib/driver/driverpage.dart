import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_pool/common/SnackBars.dart';
import 'package:share_pool/common/currency.dart';
import 'package:share_pool/driver-settings/driverSettingsPage.dart';
import 'package:share_pool/driver-settings/editTourPage.dart';
import 'package:share_pool/driver-settings/tourListWidget.dart';
import 'package:share_pool/driver/searchTour.dart';
import 'package:share_pool/model/dto/common/HateoasDto.dart';
import 'package:share_pool/model/dto/expense/ExpenseRequestResponse.dart';
import 'package:share_pool/model/dto/tour/TourDto.dart';
import 'package:share_pool/util/PreferencesService.dart';
import 'package:share_pool/util/rest/ExpenseRestClient.dart';
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

  TourDto _selectedTour;
  List<TourDto> _tours;

  Future<void> loadTours() async {
    try {
      List<TourDto> tours = await TourRestClient.getToursForUser();

      setState(() {
        this._tours = tours;

        if (widget.tour != null) {
          this._selectedTour = widget.tour;
        } else {
          this._selectedTour =
          tours != null && tours.isNotEmpty ? tours[0] : null;
        }
      });
    } on Exception {
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
        child: _tours == null || _tours.isEmpty
            ? Text("No tours defined yet.")
            : Column(children: <Widget>[
          Spacer(),
          Row(
            children: <Widget>[
              Flexible(
                  child: new TourCard(_selectedTour, widget.myDrawer)),
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchTourPage(widget.myDrawer, _tours)));
                  })
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: QrImage(
                data: _buildQrCodeForSelectedTour(),
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
        tooltip: "You found an easter egg.",
        children: [
          SpeedDialChild(
              child: Icon(Icons.photo_camera),
              label: "Scan QR code",
              backgroundColor: Colors.green,
              onTap: _openQrCodesScanner),
          SpeedDialChild(
            child: Icon(Icons.navigation),
            backgroundColor: Colors.blue,
            label: "Create a tour",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TourEditPage(widget.myDrawer)));
            },
          )
        ],
      ),
    );
  }

  String _buildQrCodeForSelectedTour() {
    return _selectedTour == null ? "error" : _selectedTour.tourId.toString();
  }

  Future _openQrCodesScanner() async {
    try {
      String qrCode = await BarcodeScanner.scan();

      int tourId = int.parse(qrCode);
      int userId = await PreferencesService.getUserId();

      if (userId != null) {
        HateoasDto<ExpenseRequestResponseDto> requestResponse =
        await _requestExpense(tourId);

        if (requestResponse != null) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: displayTour(requestResponse.dto.tour, null),
                  content: new Text(
                      "Do you want to ride with "
                          "${requestResponse.dto.receiver.userName} "
                          "for ${requestResponse.dto.tour.cost.toStringAsFixed(
                          2)} "
                          "${currencyStringtoSymbol(
                          requestResponse.dto.tour.currency)}?"
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new RaisedButton(
                      child: new Text("Yes"),
                      textColor: Colors.white,
                      onPressed: () async {
                        bool created = await _confirmExpense(requestResponse);

                        Navigator.of(context).pop();

                        if (created) {
                          _scaffoldKey.currentState.showSnackBar(
                              new SuccessSnackBar("Expense confirmed."));
                        }
                      },
                    ),
                  ],
                );
              });
        }
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          _scaffoldKey.currentState.showSnackBar(
              FailureSnackBar("Camera permissions not granted!"));
        });
      } else {
        _scaffoldKey.currentState
            .showSnackBar(FailureSnackBar("Unknown error!"));
      }
    } on FormatException {} catch (e) {}
  }

  Future<HateoasDto<ExpenseRequestResponseDto>> _requestExpense(
      int tourId) async {
    try {
      return ExpenseRestClient.requestExpense(tourId);
    } on Exception {
      _scaffoldKey.currentState
          .showSnackBar(FailureSnackBar("Something went wrong!"));
    }

    return null;
  }

  Future<bool> _confirmExpense(
      HateoasDto<ExpenseRequestResponseDto> requestResponse) async {
    try {
      return await ExpenseRestClient.confirmExpense(requestResponse);
    } on Exception {
      _scaffoldKey.currentState
          .showSnackBar(FailureSnackBar("Something went wrong!"));
    }
    return false;
  }
}
