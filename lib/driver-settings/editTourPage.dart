import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_pool/common/SnackBars.dart';
import 'package:share_pool/common/currency.dart';
import 'package:share_pool/common/currencyDropdown.dart';
import 'package:share_pool/driver-settings/driverSettingsPage.dart';
import 'package:share_pool/model/dto/tour/TourDto.dart';
import 'package:share_pool/util/rest/TourRestClient.dart';

import '../mydrawer.dart';

class TourEditPage extends StatefulWidget {
  MyDrawer myDrawer;

  TourDto editableTour;

  TourEditPage(this.myDrawer, [this.editableTour]);

  @override
  State<StatefulWidget> createState() {
    if (editableTour == null) {
      return _TourEditPageState(TourDto());
    }
    return _TourEditPageState(editableTour);
  }
}

class _TourEditPageState extends State<TourEditPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TourDto tourDto;

  _TourEditPageState(this.tourDto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
                      suffixIcon: Icon(Icons.location_on)
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
                  decoration: InputDecoration(
                      labelText: "Destination",
                      suffixIcon: Icon(Icons.flag)
                  ),
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
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  decoration: InputDecoration(
                      labelText: "Estimated Kilometers",
                      suffixIcon: Icon(Icons.transfer_within_a_station)
                  ),
                  onSaved: (String value) {
                    tourDto.kilometers = double.parse(value);
                  },
                  initialValue: tourDto.kilometers == null ? null : tourDto
                      .kilometers.toStringAsFixed(2),
                ),
                Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(top: 11),
                          child: CurrencyDropdown(
                            onSaved: handleCurrency,
                            initialValue:
                            currencyfromString(tourDto.currency) ??
                                Currency.EUR,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "Tour cost",
                              suffixIcon: Icon(Icons.attach_money)
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: true),
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
                          initialValue: tourDto.cost == null ? null : tourDto
                              .cost.toStringAsFixed(2),
                        ),
                      ),
                    ]
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      RaisedButton(
                          onPressed: () {
                            var form = _formKey.currentState;
                            if (form.validate()) {
                              form.save();
                              createOrUpdateTour();
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

  void createOrUpdateTour() async {
    try {
      await TourRestClient.createOrUpdateTour(tourDto);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DriverSettingsPage(widget.myDrawer)));
    } on SocketException {
      _scaffoldKey.currentState.showSnackBar(
          FailureSnackBar("Tour couldn't be updated/created!")
      );
    }
  }
}
