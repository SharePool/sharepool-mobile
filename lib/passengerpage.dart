import 'package:flutter/material.dart';
import 'mydrawer.dart';

class PassengerPage extends StatefulWidget {
  final String title = "Passenger";
  MyDrawer myDrawer;

  PassengerPage(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  _PassengerPageState createState() => _PassengerPageState(myDrawer);
}

class _PassengerPageState extends State<PassengerPage> {
  MyDrawer myDrawer;

  _PassengerPageState(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: this.myDrawer,
    );
  }
}
