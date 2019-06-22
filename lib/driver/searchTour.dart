import 'package:flutter/material.dart';
import 'package:share_pool/driver-settings/tourListWidget.dart';
import 'package:share_pool/driver/driverpage.dart';
import 'package:share_pool/model/dto/tour/TourDto.dart';

import '../mydrawer.dart';

class SearchTourPage extends StatefulWidget {
  final String title = "Search for a tour";

  MyDrawer myDrawer;
  List<TourDto> tours;

  SearchTourPage(this.myDrawer, this.tours);

  @override
  _SearchTourPageState createState() => _SearchTourPageState();
}

class _SearchTourPageState extends State<SearchTourPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<TourDto> tours;

  @override
  void initState() {
    super.initState();

    this.tours = widget.tours;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: widget.myDrawer,
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    onChanged: (String value) {
                      applyFilter(value);
                    },
                    decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0))))),
              ),
              Flexible(
                  child: TourListWidget(
                tours: tours,
                myDrawer: widget.myDrawer,
                isDismissable: false,
                tourTapCallback: (context, myDrawer, tour) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DriverPage(myDrawer, tour)));
                },
                scaffoldKey: _scaffoldKey,
              )),
            ],
          ),
        ));
  }

  void applyFilter(String value) {
    if (value.isEmpty) {
      setState(() {
        tours = widget.tours;
      });
      return;
    }

    setState(() {
      tours = widget.tours
          .where((t) =>
              t.from.toLowerCase().contains(value.toLowerCase()) ||
              t.to.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
}
