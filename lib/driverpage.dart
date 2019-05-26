import 'package:flutter/material.dart';
import 'package:share_pool/driver-settings/driverSettingsPage.dart';
import 'mydrawer.dart';
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
        /*
        child: ListView(
          children: <Widget>[
            Text("Title"),
            new QrImage(
              data: "1234567890",
              size: 200.0,
            )
          ],
        ),
        */
        child: GenerateScreen(),
      ),
    );
  }
}
