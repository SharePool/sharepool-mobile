import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_pool/common/SnackBars.dart';
import 'package:share_pool/model/dto/user/UserLoginDto.dart';
import 'package:share_pool/model/dto/user/UserTokenDto.dart';
import 'package:share_pool/user_management/registerPage.dart';
import 'package:share_pool/util/PreferencesService.dart';
import 'package:share_pool/util/rest/UserRestClient.dart';

class LoginPage extends StatefulWidget {
  final Widget followingPage;

  LoginPage(this.followingPage);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String _userNameOrEmail = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Email or Username",
                    suffixIcon: Icon(Icons.person)),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Email or Username must not be empty";
                  }
                },
                onSaved: (String value) {
                  _userNameOrEmail = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Password", suffixIcon: Icon(Icons.lock)),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Password must not be empty";
                  }
                },
                onSaved: (String value) {
                  _password = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text("Register"),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            BuildContext context) => RegisterForm()));
                      },
                    ),
                    Spacer(),
                    RaisedButton(
                        onPressed: () {
                          var form = _formKey.currentState;
                          if (form.validate()) {
                            form.save();
                            _doLogin();
                          }
                        },
                        child: Text('Submit')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _doLogin() async {
    try {
      UserCredentialsDto credentials = await UserRestClient.loginUser(
          new UserLoginDto(_userNameOrEmail, _password));

      if (credentials != null) {
        PreferencesService.saveUserToken(credentials.userToken);
        PreferencesService.saveUserId(credentials.userId);
        PreferencesService.saveLoggedInUser(await UserRestClient.getUser());

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => widget.followingPage));
      } else {
        _scaffoldKey.currentState
            .showSnackBar(FailureSnackBar("Invalid Credentials!"));
      }
    } on SocketException {
      _scaffoldKey.currentState
          .showSnackBar(FailureSnackBar("Something went wrong!"));
    }
  }
}
