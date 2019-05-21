import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:share_pool/common/currency.dart';
import 'package:share_pool/common/currencyDropdown.dart';
import 'package:share_pool/driver-settings/dto/tourDto.dart';

import '../mydrawer.dart';

class AddTourPage extends StatefulWidget {
  MyDrawer myDrawer;

  TourDto editableTour;

  AddTourPage(this.myDrawer, [this.editableTour]);

  @override
  State<StatefulWidget> createState() {
    if (editableTour == null) {
      return _AddTourFormState(TourDto());
    }
    return _AddTourFormState(editableTour);
  }
}

class _AddTourFormState extends State<AddTourPage> {
  final _formKey = GlobalKey<FormState>();
  TourDto tourDto;

  _AddTourFormState(this.tourDto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                widget.editableTour == null ? "Create tour" : "Edit tour")),
        drawer: widget.myDrawer,
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
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
                    tourDto.from = value;
                  },
                  initialValue: tourDto.from,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Destination"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Destination must be set";
                    }
                  },
                  onSaved: (String value) {
                    tourDto.to = value;
                  },
                  initialValue: tourDto.to,
                ),
                // todo set initialValue for currency
                CurrencyDropdown(onSaved: handleCurrency),
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
                    tourDto.cost = double.parse(value);
                  },
                  initialValue:
                      tourDto.cost == null ? null : tourDto.cost.toString(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: <Widget>[
                      // todo only show delete button if we have an id for the tour
                      tourDto.tourId != null
                          ? RaisedButton(
                              onPressed: () => print("test"),
                              child: Text("Delete"),
                              color: Colors.red,
                            )
                          : Spacer(),
                      Spacer(),
                      RaisedButton(
                          onPressed: () {
                            var form = _formKey.currentState;
                            if (form.validate()) {
                              form.save();
                              createTour();
                            }
                          },
                          child: Text('Submit')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void handleCurrency(Currency currency) {
    switch (currency) {
      case Currency.EUR:
        tourDto.currency = "EUR";
        break;

      case Currency.USD:
        tourDto.currency = "USD";
        break;

      case Currency.GBP:
        tourDto.currency = "GBP";
        break;
    }
  }

  void createTour() async {
    // todo get user id from context
    tourDto.ownerId = 1;
    var body = json.encode(tourDto);
    print(body);

    var response = await post("http://192.168.0.7:8080/tours",
        body: body, headers: {"Content-Type": "application/json"});

    print(response.body);
  }

  void deleteTour() async {
    // todo delete tour
  }
}
