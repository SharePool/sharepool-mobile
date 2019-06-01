import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/driver-settings/driverSettingsPage.dart';
import 'package:share_pool/model/dto/TourDto.dart';
import 'package:share_pool/util/rest/TourRestClient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mydrawer.dart';
import 'generate.dart';

class DriverPage extends StatefulWidget {
  final String title = "Driver";
  MyDrawer myDrawer;

  DriverPage(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  TourDto selectedTour;
  List<TourDto> tours = new List();

  Future<void> loadTours() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    List<TourDto> tours = await TourRestClient.getToursForUser(
        sharedPreferences.getInt(Constants.SETTINGS_USER_ID));

    setState(() {
      this.tours = tours;
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
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DriverSettingsPage(widget.myDrawer))))
        ],
      ),
      drawer: widget.myDrawer,
      body: Center(
        child: Column(children: <Widget>[
          DropdownButton<TourDto>(
              value: tours.isEmpty ? null : tours[0],
              onChanged: (TourDto value) {
                setState(() {
                  selectedTour = value;
                  print(selectedTour.toJson().toString());
                });
              },
              items: tours.map((TourDto tour) {
                return new DropdownMenuItem<TourDto>(
                    child: Row(
                      children: <Widget>[
                        new Text(tour.from),
                        new Icon(Icons.arrow_forward),
                        new Text(tour.to)
                      ],
                    ),
                    value: tour);
              }).toList()),
          Text("Current tour"),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: QrImage(
              data: buildQrCodeData(),
              onError: (ex) {
                print("[QR] ERROR - $ex");
              }
            ),
          )
        ]),
      ),
    );
  }

  String buildQrCodeData() {
    return selectedTour == null ? "error" : selectedTour.toJson().toString();
  }
}
