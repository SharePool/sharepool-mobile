import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_pool/model/dto/ExpenseConfirmationDto.dart';
import 'package:share_pool/model/dto/ExpenseRequestDto.dart';
import 'package:share_pool/util/rest/ExpenseRestClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/Constants.dart';
import 'model/dto/ExpenseRequestResponse.dart';
import 'mydrawer.dart';

class PassengerPage extends StatefulWidget {
  final String title = "Passenger";
  MyDrawer myDrawer;

  PassengerPage(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  _PassengerPageState createState() => _PassengerPageState(myDrawer);
}

class _PassengerPageState extends State<PassengerPage> {
  MyDrawer myDrawer;

  _PassengerPageState(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      int tourId = int.parse(await BarcodeScanner.scan());

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt(Constants.SETTINGS_USER_ID);

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
                      child: new Text("Yes"),
                      onPressed: () async {
                        bool created =
                        await confirmExpense(requestResponse, userId);

                        Navigator.of(context).pop();

                        if (created) {
                          // TODO: show snackbar with confirmation
//                          Scaffold.of(context).showSnackBar(SnackBar(
//                            content: Text('Camera permissions not granted!'),
//                            duration: Duration(seconds: 3),
//                          ));
                        }
                      },
                    ),
                    new FlatButton(
                      child: new Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
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
          // TODO: fix context errors
//          Scaffold.of(context).showSnackBar(SnackBar(
//            content: Text('Camera permissions not granted!'),
//            duration: Duration(seconds: 3),
//          ));
        });
      } else {
        // TODO: fix context errors
//        Scaffold.of(context).showSnackBar(SnackBar(
//          content: Text('Unknown error: $e'),
//          duration: Duration(seconds: 3),
//        ));
      }
    } on FormatException {} catch (e) {}
  }

  Future<ExpenseRequestResponseDto> requestExpense(int tourId) async {
    return ExpenseRestClient.requestExpense(new ExpenseRequestDto(tourId));
  }

  Future<bool> confirmExpense(ExpenseRequestResponseDto requestResponse,
      int userId) async {
    return await ExpenseRestClient.confirmExpense(new ExpenseConfirmationDto(
        requestResponse.tour.tourId,
        userId,
        "Drive from " +
            requestResponse.tour.from +
            " to " +
            requestResponse.tour.to));
  }
}
