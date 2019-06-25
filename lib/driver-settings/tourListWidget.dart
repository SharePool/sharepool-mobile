import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share_pool/common/SnackBars.dart';
import 'package:share_pool/common/currency.dart';
import 'package:share_pool/model/dto/tour/TourDto.dart';
import 'package:share_pool/mydrawer.dart';
import 'package:share_pool/util/rest/TourRestClient.dart';

import 'editTourPage.dart';

class TourListWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  List<TourDto> tours;
  MyDrawer myDrawer;
  bool isDismissable;
  TourTapCallback tourTapCallback;

  TourListWidget(
      {this.myDrawer,
      this.tours,
      this.isDismissable = true,
      this.tourTapCallback,
      this.scaffoldKey});

  @override
  _TourListWidgetState createState() => _TourListWidgetState();
}

class _TourListWidgetState extends State<TourListWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return widget.tours == null || widget.tours.isEmpty
        ? Text("No tours defined yet.")
        : ListView.builder(
        itemCount: widget.tours == null ? 0 : widget.tours.length,
        itemBuilder: (BuildContext context, int index) {
          var tour = widget.tours[index];

          if (widget.isDismissable) {
            return Dismissible(
              child: TourCard(tour, widget.myDrawer),
              key: ObjectKey(tour),
              onDismissed: (direction) {
                deleteTour(direction, tour);
              },
              background: Card(
                margin: const EdgeInsets.all(10),
                color: Colors.red,
              ),
              direction: DismissDirection.endToStart,
            );
          } else {
            return TourCard(tour, widget.myDrawer, widget.tourTapCallback);
          }
        });
  }

  Future<void> deleteTour(DismissDirection direction, TourDto tour) async {
    try {
      await TourRestClient.deleteTour(tour.tourId);

      setState(() {
        widget.tours.remove(tour);
      });
    } on Exception {
      _scaffoldKey.currentState
          .showSnackBar(FailureSnackBar("Tour couldn't be deleted!"));
    }
  }
}

class TourCard extends StatelessWidget {
  TourDto tour;
  MyDrawer myDrawer;
  TourTapCallback tourTapCallback;

  TourCard(this.tour, this.myDrawer, [this.tourTapCallback]);

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: tour.active ? 1 : .5,
        child: Card(
            margin: const EdgeInsets.all(10),
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    displayTour(tour, 18),
                    Spacer(),
                    Text(buildCurrencyString(), style: TextStyle(fontSize: 18))
                  ],
                ),
              ),
              onTap: () => tourTapCallback != null
                  ? tourTapCallback(context, myDrawer, tour)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TourEditPage(myDrawer, tour))),
            )));
  }

  String buildCurrencyString() =>
      currencyStringtoSymbol(tour.currency) + tour.cost.toStringAsFixed(2);
}

typedef TourTapCallback = void Function(
    BuildContext context, MyDrawer myDrawer, TourDto tour);

Widget displayTour(TourDto tourDto, double fontSize) {
  return Row(
    children: <Widget>[
      Text(
        tourDto.from,
        style: TextStyle(fontSize: fontSize),
      ),
      Icon(Icons.arrow_forward),
      Text(tourDto.to, style: TextStyle(fontSize: fontSize))
    ],
  );
}
