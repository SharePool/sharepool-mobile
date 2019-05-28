import 'package:flutter/material.dart';
import 'package:share_pool/model/dto/RegisterUserDto.dart';
import 'package:share_pool/util/rest/UserRestClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterForm extends StatefulWidget {
  final Widget followingPage;

  const RegisterForm(this.followingPage);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

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
                if (value.isEmpty) {
                  return "First Name must not be empty";
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
                if (value.isEmpty) {
                  return "Last Name must not be empty";
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
                if (value.isEmpty) {
                  return "Username must not be empty";
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

    String token = await UserRestClient.registerUser(new RegisterUserDto(
        _firstName, _lastName, _userName, _email, _password));

    if (token != null && token.isNotEmpty) {
      prefs.setString("userToken", token);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => widget.followingPage));
    }
  }
}
