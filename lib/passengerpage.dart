import 'package:flutter/material.dart';
import 'mydrawer.dart';

class PassengerPage extends StatefulWidget {
  PassengerPage({Key key}) : super(key: key);

  final String title = "Passenger";

  @override
  _PassengerPageState createState() => _PassengerPageState();
}

class _PassengerPageState extends State<PassengerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MyDrawer(),
    );
  }
}
