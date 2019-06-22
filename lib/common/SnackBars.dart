import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuccessSnackBar extends SnackBar {
  SuccessSnackBar(String text)
      : super(
          content: Text(text),
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 3),
        );
}

class FailureSnackBar extends SnackBar {
  FailureSnackBar(String text)
      : super(
          content: Text(text),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
        );
}
