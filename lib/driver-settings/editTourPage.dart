import 'package:flutter/material.dart';
import 'package:share_pool/common/currency.dart';
import 'package:share_pool/common/currencyDropdown.dart';
import 'package:share_pool/driver-settings/driverSettingsPage.dart';
import 'package:share_pool/model/dto/TourDto.dart';
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
  TourDto tourDto;

  _TourEditPageState(this.tourDto);

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
                CurrencyDropdown(
                  onSaved: handleCurrency,
                  initialValue: currencyfromString(tourDto.currency) ??
                      Currency.EUR,
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
                    tourDto.cost = double.parse(value);
                  },
                  initialValue:
                      tourDto.cost == null ? null : tourDto.cost.toString(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: <Widget>[
                      tourDto.tourId != null
                          ? RaisedButton(
                        onPressed: deleteTour,
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
    // todo get user id from context
    tourDto.ownerId = 1;

    await TourRestClient.createOrUpdateTour(tourDto);

    // push here instead of pop to trigger reload
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DriverSettingsPage(widget.myDrawer)));
  }

  void deleteTour() async {
    await TourRestClient.deleteTour(tourDto.tourId);

    // push here instead of pop to trigger reload
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DriverSettingsPage(widget.myDrawer)));
  }
}
