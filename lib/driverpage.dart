import 'package:flutter/material.dart';
import 'mydrawer.dart';
import 'generate.dart';

class DriverPage extends StatefulWidget {
  final String title = "Driver";
  MyDrawer myDrawer;

  DriverPage(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  _DriverPageState createState() => _DriverPageState(this.myDrawer);
}

class _DriverPageState extends State<DriverPage> {
  MyDrawer myDrawer;

  _DriverPageState(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: myDrawer,
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
