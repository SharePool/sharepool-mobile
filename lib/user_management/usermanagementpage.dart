import 'package:flutter/material.dart';
import 'package:share_pool/driver/driverpage.dart';
import 'package:share_pool/user_management/loginform.dart';
import 'package:share_pool/user_management/registerform.dart';

class UserManagementPage extends StatefulWidget {
  DriverPage driverPage;

  UserManagementPage(this.driverPage);

  @override
  State<UserManagementPage> createState() =>
      _UserManagementPageState(driverPage);
}

class _UserManagementPageState extends State<UserManagementPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DriverPage driverPage;
  Widget userManagementWidget;

  Widget registerButton;
  Widget loginButton;
  Widget switchButton;

  _UserManagementPageState(this.driverPage) {
    userManagementWidget = LoginForm(driverPage, _scaffoldKey);

    registerButton = RaisedButton(
        onPressed: () {
          setState(() {
            userManagementWidget = RegisterForm(driverPage, _scaffoldKey);
            switchButton = loginButton;
          });
        },
        child: Text("Register"));

    loginButton = RaisedButton(
        onPressed: () {
          setState(() {
            userManagementWidget = LoginForm(driverPage, _scaffoldKey);
            switchButton = registerButton;
          });
        },
        child: Text("Login"));

    switchButton = registerButton;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(userManagementWidget is LoginForm ? "Login" : "Register"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          userManagementWidget,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: switchButton,
          )
        ],
      ),
    );
  }
}
