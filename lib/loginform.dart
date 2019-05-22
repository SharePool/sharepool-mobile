import 'package:flutter/material.dart';
import 'package:share_pool/driverpage.dart';
import 'package:share_pool/passengerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {

  DriverPage driverPage;


  LoginForm(this.driverPage);

  @override
  State<LoginForm> createState() => _LoginFormState(driverPage);
}

class _LoginFormState extends State<LoginForm> {
  String _email = "";
  String _password = "";
  DriverPage driverPage;


  _LoginFormState(this.driverPage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: "email",
            ),
            onChanged: (text) => _email = text,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "password",
            ),
            onChanged: (text) => _password = text,
          ),
          RaisedButton(
            child: Text("Login"),
            onPressed: () {
              saveLogin();
            },
          )
        ],
      ),
    );
  }

  void saveLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("userToken", "0sd9f09s");

    Navigator.push(context, MaterialPageRoute(builder: (context) => driverPage));
  }
}
