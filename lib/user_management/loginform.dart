import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_pool/common/SnackBars.dart';
import 'package:share_pool/model/dto/user/UserLoginDto.dart';
import 'package:share_pool/model/dto/user/UserTokenDto.dart';
import 'package:share_pool/util/PreferencesService.dart';
import 'package:share_pool/util/rest/UserRestClient.dart';

class LoginForm extends StatefulWidget {
  final Widget followingPage;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  LoginForm(this.followingPage, this._scaffoldKey);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String _userNameOrEmail = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email or Username",
              ),
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
              decoration: InputDecoration(labelText: "Password"),
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
                  Spacer(),
                  RaisedButton(
                      onPressed: () {
                        var form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          doLogin();
                        }
                      },
                      child: Text('Submit')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void doLogin() async {
    try {
      UserCredentialsDto credentials = await UserRestClient.loginUser(
          new UserLoginDto(_userNameOrEmail, _password));

      if (credentials != null) {
        PreferencesService.saveUserToken(credentials.userToken);
        PreferencesService.saveUserId(credentials.userId);
        PreferencesService.saveLoggedInUser(await UserRestClient.getUser());

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => widget.followingPage));
      } else {
        widget._scaffoldKey.currentState.showSnackBar(
            FailureSnackBar("Invalid Credentials!")
        );
      }
    } on SocketException {
      widget._scaffoldKey.currentState.showSnackBar(
          FailureSnackBar("Something went wrong!")
      );
    }
  }
}
