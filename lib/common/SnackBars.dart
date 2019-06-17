import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuccessSnackBar extends SnackBar {
  String _text;

  SuccessSnackBar(this._text);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(_text),
      backgroundColor: Colors.greenAccent,
      duration: Duration(seconds: 3),
    );
  }
}

class FailureSnackBar extends SnackBar {
  String _text;

  FailureSnackBar(this._text);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(_text),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    );
  }
}
