import 'package:flutter/material.dart';
import 'package:share_pool/driverpage.dart';
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

  DriverPage driverPage;
  Widget userManagementWidget;

  Widget registerButton;
  Widget loginButton;
  Widget switchButton;

  _UserManagementPageState(this.driverPage) {
    userManagementWidget = LoginForm(driverPage);

    registerButton = RaisedButton(
        onPressed: () {
          setState(() {
            userManagementWidget = RegisterForm(driverPage);
            switchButton = loginButton;
          });
        },
        child: Text('Register'));

    loginButton = RaisedButton(
        onPressed: () {
          setState(() {
            userManagementWidget = LoginForm(driverPage);
            switchButton = registerButton;
          });
        },
        child: Text('Login'));

    switchButton = registerButton;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          userManagementWidget,
          switchButton
        ],
      ),
    );
  }
}
