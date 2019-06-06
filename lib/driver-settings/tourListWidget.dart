import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share_pool/common/currency.dart';
import 'package:share_pool/model/dto/tour/TourDto.dart';
import 'package:share_pool/mydrawer.dart';
import 'package:share_pool/util/rest/TourRestClient.dart';

import 'editTourPage.dart';

class TourListWidget extends StatefulWidget {
  List<TourDto> tours;
  MyDrawer myDrawer;

  TourListWidget({this.myDrawer, this.tours});

  @override
  _TourListWidgetState createState() => _TourListWidgetState();
}

class _TourListWidgetState extends State<TourListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.tours == null ? 0 : widget.tours.length,
        itemBuilder: (BuildContext context, int index) {
          var tour = widget.tours[index];

          return Dismissible(
            child: TourCard(tour, widget.myDrawer),
            key: ObjectKey(tour),
            onDismissed: (direction) {
              deleteTour(direction, tour);
            },
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
          );
        });
  }

  Future<void> deleteTour(DismissDirection direction, TourDto tour) async {
    setState(() {
      widget.tours.remove(tour);
    });

    await TourRestClient.deleteTour(tour.tourId);
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
                  builder: (context) => TourEditPage(myDrawer, tour))),
        ));
  }

  String buildCurrencyString() =>
      currencyStringtoSymbol(tour.currency) + tour.cost.toStringAsFixed(2);
}
