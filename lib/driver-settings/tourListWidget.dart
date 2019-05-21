import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share_pool/common/currency.dart';
import 'package:share_pool/driver-settings/dto/tourDto.dart';
import 'package:share_pool/mydrawer.dart';

import 'addTourPage.dart';

class TourListWidget extends StatelessWidget {
  List<TourDto> tours;
  MyDrawer myDrawer;

  TourListWidget({this.myDrawer, this.tours});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tours == null ? 0 : tours.length,
        itemBuilder: (BuildContext context, int index) {
          return TourCard(tours[index], myDrawer);
        });
  }
}

class TourCard extends StatelessWidget {
  TourDto tour;
  MyDrawer myDrawer;

  TourCard(this.tour, this.myDrawer);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(10),
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Text(
                  tour.from,
                  style: TextStyle(fontSize: 18),
                ),
                Icon(Icons.arrow_forward),
                Text(tour.to, style: TextStyle(fontSize: 18)),
                Spacer(),
                Text(buildCurrencyString(), style: TextStyle(fontSize: 18))
              ],
            ),
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTourPage(myDrawer, tour))),
        ));
  }

  String buildCurrencyString() =>
      currencyStringtoSymbol(tour.currency) + " " + tour.cost.toString();
}
