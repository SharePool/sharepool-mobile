import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/user/UserDto.dart';
import 'package:share_pool/model/dto/user/UserTokenDto.dart';
import 'package:share_pool/util/rest/UserRestClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterForm extends StatefulWidget {
  final Widget followingPage;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  const RegisterForm(this.followingPage, this._scaffoldKey);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final RegExp emailRegExp = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  final RegExp passwordRegExp = new RegExp(
      r"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\S+$).*$");

  String _firstName = "";
  String _lastName = "";
  String _userName = "";
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "First Name",
              ),
              validator: (value) {
                int strLen = value.length;
                if (strLen < 3 || strLen > 20) {
                  return "First Name must have between 3 and 20 characters";
                }
              },
              onSaved: (String value) {
                _firstName = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Last Name",
              ),
              validator: (value) {
                int strLen = value.length;
                if (strLen < 3 || strLen > 20) {
                  return "Last Name must have between 3 and 20 characters";
                }
              },
              onSaved: (String value) {
                _lastName = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Username",
              ),
              validator: (value) {
                int strLen = value.length;
                if (strLen < 5 || strLen > 20) {
                  return "Username must have between 5 and 20 characters";
                }
              },
              onSaved: (String value) {
                _userName = value;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
              ),
              validator: (value) {
                if (value.isEmpty || !emailRegExp.hasMatch(value)) {
                  return "Email must be valid";
                }
              },
              onSaved: (String value) {
                _email = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
              validator: (value) {
                if (value.isEmpty || !passwordRegExp.hasMatch(value)) {
                  return "Password must have between 8 and 25 characters\nContain lower- and uppercase letters\nand one special character";
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
                          doRegister();
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

  Future doRegister() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    UserCredentialsDto credentials = null;
    try {
      credentials = await UserRestClient.registerUser(
          new UserDto(
              firstName: _firstName,
              lastName: _lastName,
              userName: _userName,
              email: _email,
              password: _password));
    } on SocketException catch (e) {
      // NOP: is handled by null check below
    }

    if (credentials != null) {
      prefs.setString(Constants.SETTINGS_USER_TOKEN, credentials.userToken);
      prefs.setInt(Constants.SETTINGS_USER_ID, credentials.userId);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => widget.followingPage));
    } else {
      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went wrong!'),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
