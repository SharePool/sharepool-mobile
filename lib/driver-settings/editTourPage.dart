import "dart:io";

import "package:flutter/material.dart";
import "package:share_pool/common/SnackBars.dart";
import "package:share_pool/common/currency.dart";
import "package:share_pool/common/currencyDropdown.dart";
import "package:share_pool/driver-settings/driverSettingsPage.dart";
import "package:share_pool/model/dto/tour/TourDto.dart";
import "package:share_pool/util/rest/TourRestClient.dart";

import "../mydrawer.dart";

class TourEditPage extends StatefulWidget {
  MyDrawer myDrawer;

  TourDto _editableTour;

  TourEditPage(this.myDrawer, [this._editableTour]);

  @override
  State<StatefulWidget> createState() {
    if (_editableTour == null) {
      return _TourEditPageState(TourDto());
    }
    return _TourEditPageState(_editableTour);
  }
}

class _TourEditPageState extends State<TourEditPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TourDto _tourDto;

  _TourEditPageState(this._tourDto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text(
                widget._editableTour == null ? "Create tour" : "Edit tour")),
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
                      suffixIcon: Icon(Icons.location_on)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Starting point must be set";
                    }
                  },
                  onSaved: (String value) {
                    _tourDto.from = value;
                  },
                  initialValue: _tourDto.from,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Destination", suffixIcon: Icon(Icons.flag)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Destination must be set";
                    }
                  },
                  onSaved: (String value) {
                    _tourDto.to = value;
                  },
                  initialValue: _tourDto.to,
                ),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  decoration: InputDecoration(
                      labelText: "Estimated Kilometers",
                      suffixIcon: Icon(Icons.transfer_within_a_station)),
                  onSaved: (String value) {
                    _tourDto.kilometers = double.parse(value);
                  },
                  initialValue: _tourDto.kilometers == null
                      ? null
                      : _tourDto.kilometers.toStringAsFixed(2),
                ),
                Row(children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(top: 11),
                      child: CurrencyDropdown(
                        onSaved: _handleCurrency,
                        initialValue: currencyfromString(_tourDto.currency) ??
                            Currency.EUR,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "Tour cost",
                          suffixIcon: Icon(Icons.attach_money)),
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
                        _tourDto.cost = double.parse(value);
                      },
                      initialValue: _tourDto.cost == null
                          ? null
                          : _tourDto.cost.toStringAsFixed(2),
                    ),
                  ),
                ]),
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
                              _createOrUpdateTour();
                            }
                          },
                          child: Text("Submit")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _handleCurrency(Currency currency) {
    switch (currency) {
      case Currency.EUR:
        _tourDto.currency = "EUR";
        break;

      case Currency.USD:
        _tourDto.currency = "USD";
        break;

      case Currency.GBP:
        _tourDto.currency = "GBP";
        break;
    }
  }

  void _createOrUpdateTour() async {
    try {
      await TourRestClient.createOrUpdateTour(_tourDto);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DriverSettingsPage(widget.myDrawer)));
    } on SocketException {
      _scaffoldKey.currentState
          .showSnackBar(FailureSnackBar("Tour couldn't be updated/created!"));
    }
  }
}
