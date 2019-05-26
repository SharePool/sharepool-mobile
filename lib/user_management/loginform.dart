import 'package:flutter/material.dart';
import 'package:share_pool/model/dto/LoginUserDto.dart';
import 'package:share_pool/util/rest/UserRestClient.dart';
import 'package:share_pool/util/rest/UserRestClientImpl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  final Widget followingPage;

  LoginForm(this.followingPage);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";

  UserRestClient userRestClient = new UserRestClientImpl();

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
                labelText: "Email",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Email must not be empty";
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String token =
        userRestClient.loginUser(new LoginUserDto(_email, _password));

    prefs.setString("userToken", token);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget.followingPage));
  }
}
