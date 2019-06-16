import 'package:flutter/material.dart';
import 'package:share_pool/driver-settings/editTourPage.dart';
import 'package:share_pool/driver-settings/tourListWidget.dart';
import 'package:share_pool/driver/driverpage.dart';
import 'package:share_pool/model/dto/tour/TourDto.dart';
import 'package:share_pool/util/rest/TourRestClient.dart';

import '../mydrawer.dart';

class DriverSettingsPage extends StatefulWidget {
  final String title = "Your Tours";
  MyDrawer myDrawer;

  DriverSettingsPage(this.myDrawer);

  @override
  _DriverSettingsPageState createState() => _DriverSettingsPageState();
}

class _DriverSettingsPageState extends State<DriverSettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<TourDto> _activeTours;
  List<TourDto> _inactiveTours;

  Future<void> loadTours() async {
    List<TourDto> tours = await TourRestClient.getToursForUser();
    List<TourDto> inactiveTours = await TourRestClient.getToursForUser(true);

    inactiveTours = inactiveTours.where((t) => !t.active).toList();

    setState(() {
      this._activeTours = tours;
      this._inactiveTours = inactiveTours;
    });
  }

  @override
  void initState() {
    super.initState();

    loadTours();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(widget.title),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.directions_car, color: Colors.white),
                  onPressed: () =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DriverPage(widget.myDrawer))))
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: "Active"),
                Tab(text: "Inactive"),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TourEditPage(widget.myDrawer)));
            },
          ),
          drawer: widget.myDrawer,
          // todo make it so empty list is also refreshable
          body: TabBarView(
            children: <Widget>[
              RefreshIndicator(
                child: Center(
                    child: _activeTours == null || _activeTours.isEmpty
                        ? Text("No tours defined yet.")
                        : TourListWidget(
                        myDrawer: widget.myDrawer,
                        tours: _activeTours
                    )
                ),
                onRefresh: loadTours,
              ),
              RefreshIndicator(
                child: Center(
                  child: TourListWidget(
                    myDrawer: widget.myDrawer,
                    tours: _inactiveTours,
                    isDismissable: false,
                    tourTapCallback: (context, drawer, tour) {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: Text("Activate tour"),
                                content: Text(
                                    "Do you want to re-activate this tour?"),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text("No"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  new RaisedButton(
                                      child: new Text("Yes"),
                                      textColor: Colors.white,
                                      onPressed: () =>
                                          reActivateTour(context, tour)
                                  ),
                                ],
                              )
                      );
                    },
                  ),
                ),
                onRefresh: loadTours,
              )
            ],
          )),
    );
  }

  void reActivateTour(BuildContext context, TourDto tour) async {
    tour.active = true;
    await TourRestClient.activateTour(tour.tourId);
    Navigator.pop(context);
    loadTours();
  }
}
