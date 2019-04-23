import 'package:flutter/material.dart';
import 'driverpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SharePool',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: DriverPage());
  }
}
