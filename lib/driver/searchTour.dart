import 'package:flutter/material.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/driver-settings/tourListWidget.dart';
import 'package:share_pool/model/dto/tour/TourDto.dart';
import 'package:share_pool/util/rest/TourRestClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mydrawer.dart';

class SearchTourPage extends StatefulWidget {
  final String title = "Search for a tour";
  MyDrawer myDrawer;

  SearchTourPage(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  _SearchTourPageState createState() => _SearchTourPageState();
}

class _SearchTourPageState extends State<SearchTourPage> {
  TourDto selectedTour;
  List<TourDto> tours;

  List<TourDto> unfilteredTours;

  Future<void> loadTours() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    List<TourDto> tours = await TourRestClient.getToursForUser(
        sharedPreferences.getInt(Constants.SETTINGS_USER_ID));

    unfilteredTours = tours;

    setState(() {
      this.tours = tours;
      this.selectedTour = tours != null ? tours[0] : null;
    });
  }

  @override
  void initState() {
    super.initState();

    loadTours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child:
                  // todo replace lambdas of tour list widget and tour card
                  TourListWidget(
                      tours: tours,
                      myDrawer: widget.myDrawer,
                      isDismissable: false)),
            ],
          ),
        ));
  }

  void applyFilter(String value) {
    if (value.isEmpty) {
      setState(() {
        tours = unfilteredTours;
      });
      return;
    }

    setState(() {
      tours = unfilteredTours
          .where((t) =>
              t.from.toLowerCase().contains(value.toLowerCase()) ||
              t.to.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
}
