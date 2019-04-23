import 'package:flutter/material.dart';
import 'mydrawer.dart';
import 'generate.dart';

class DriverPage extends StatefulWidget {
  DriverPage({Key key}) : super(key: key);

  final String title = "Driver";

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MyDrawer(),
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
