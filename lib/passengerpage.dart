import 'dart:async';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_pool/model/dto/expense/ExpenseConfirmationDto.dart';
import 'package:share_pool/model/dto/expense/ExpenseRequestResponse.dart';
import 'package:share_pool/util/PreferencesService.dart';
import 'package:share_pool/util/rest/ExpenseRestClient.dart';

import 'mydrawer.dart';

class PassengerPage extends StatefulWidget {
  final String title = "Passenger";
  MyDrawer myDrawer;

  PassengerPage(this.myDrawer);

  @override
  _PassengerPageState createState() => _PassengerPageState(myDrawer);
}

class _PassengerPageState extends State<PassengerPage> {
  MyDrawer myDrawer;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _PassengerPageState(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: this.myDrawer,
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: scan,
                    child: const Text('START CAMERA SCAN')),
              ),
            ],
          ),
        ));
  }

  Future scan() async {
    try {
      String qrCode = await BarcodeScanner.scan();

      int tourId = int.parse(qrCode);
      int userId = await PreferencesService.getUserId();

      if (userId != null) {
        ExpenseRequestResponseDto requestResponse =
        await requestExpense(tourId);

        if (requestResponse != null) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text(requestResponse.tour.from +
                      " -> " +
                      requestResponse.tour.to),
                  content: new Text("Wanna ride with " +
                      requestResponse.receiver.userName +
                      " for " +
                      requestResponse.tour.cost.toString() +
                      " " +
                      requestResponse.tour.currency +
                      "?"),
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
                        bool created =
                        await confirmExpense(requestResponse, userId);

                        Navigator.of(context).pop();

                        if (created) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Expense confirmed'),
                            duration: Duration(seconds: 3),
                          ));
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
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Camera permissions not granted!'),
            duration: Duration(seconds: 3),
          ));
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Unknown error: $e'),
          duration: Duration(seconds: 3),
        ));
      }
    } on FormatException {} catch (e) {}
  }

  Future<ExpenseRequestResponseDto> requestExpense(int tourId) async {
    try {
      return ExpenseRestClient.requestExpense(tourId);
    } on SocketException catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went wrong!'),
        duration: Duration(seconds: 3),
      ));
    }

    return null;
  }

  Future<bool> confirmExpense(ExpenseRequestResponseDto requestResponse,
      int userId) async {
    try {
      return await ExpenseRestClient.confirmExpense(new ExpenseConfirmationDto(
          requestResponse.tour.tourId,
          userId,
          "Drive from " +
              requestResponse.tour.from +
              " to " +
              requestResponse.tour.to));
    } on SocketException catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went wrong!'),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
