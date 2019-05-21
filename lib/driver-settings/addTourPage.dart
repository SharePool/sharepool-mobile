import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:share_pool/driver-settings/dto/TourCreationDto.dart';

import '../mydrawer.dart';

class AddTourPage extends StatefulWidget {
  final String title = "Create a tour";
  MyDrawer myDrawer;

  AddTourPage(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  State<StatefulWidget> createState() {
    return _AddTourFormState(myDrawer);
  }
}

class _AddTourFormState extends State<AddTourPage> {
  final _formKey = GlobalKey<FormState>();
  MyDrawer myDrawer;
  List tours;

  String fromLocation;
  String toLocation;
  double tourCost;

  _AddTourFormState(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: myDrawer,
        body: Form(
          autovalidate: true,
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Starting point",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Starting point must be set";
                    }
                  },
                  onSaved: (String value) {
                    this.fromLocation = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Destination"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Destination must be set";
                    }
                  },
                  onSaved: (String value) {
                    this.toLocation = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Tour cost"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Cost must be set";
                    }

                    if (double.parse(value) < 0.1) {
                      return "Value must be over 0.1";
                    }
                  },
                  onSaved: (String value) {
                    this.tourCost = double.parse(value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                      onPressed: () {
                        var form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          createTour();
                        }
                      },
                      child: Text('Submit')),
                ),
              ],
            ),
          ),
        ));
  }

  void createTour() async {
    // todo get user id from context
    var body = json.encode(new TourDto(
        from: this.fromLocation,
        to: this.toLocation,
        cost: this.tourCost,
        currency: "EUR",
        ownerId: 1));

    print(body);

    var response = await post(
      "http://192.168.0.7:8080/tours", 
      body: body,
      headers: {
        "Content-Type": "application/json"
      });
    print(response.body);
  }
}
