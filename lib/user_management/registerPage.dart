import "package:flutter/material.dart";
import "package:share_pool/common/Constants.dart";
import "package:share_pool/common/SnackBars.dart";
import "package:share_pool/model/dto/user/UserDto.dart";
import "package:share_pool/model/dto/user/UserTokenDto.dart";
import "package:share_pool/util/PreferencesService.dart";
import "package:share_pool/util/rest/UserRestClient.dart";

class RegisterForm extends StatefulWidget {

  RegisterForm();

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String _firstName = "";
  String _lastName = "";
  String _userName = "";
  String _email = "";
  String _password = "";
  double _gasConsumption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          shrinkWrap: true,
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
                if (value.isEmpty || !Constants.EMAIL_REG_EXP.hasMatch(value)) {
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
                if (value.isEmpty ||
                    !Constants.PASSWORD_REG_EXP.hasMatch(value)) {
                  return "Password must have between 8 and 25 characters\nContain lower- and uppercase letters\nand one special character";
                }
              },
              onSaved: (String value) {
                _password = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Gas Consumption (l per 100 km)",
              ),
              keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: true),
              validator: (value) {
                if (value?.isEmpty) {
                  return "Gas consumption must be set";
                }

                double gasConsumption = double.parse(value);

                if (gasConsumption < 0) {
                  return "Gas consumption must be greater than or equal 0";
                }
              },
              onSaved: (String value) {
                _gasConsumption = double.parse(value);
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
                      child: Text("Register")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future doRegister() async {
    UserCredentialsDto credentials;
    try {
      credentials = await UserRestClient.registerUser(UserDto(
          firstName: _firstName,
          lastName: _lastName,
          userName: _userName,
          email: _email,
          password: _password,
          gasConsumption: _gasConsumption));
    } on Exception {
      _scaffoldKey.currentState
          .showSnackBar(FailureSnackBar("Something went wrong!"));
    }

    if (credentials != null) {
      PreferencesService.saveUserToken(credentials.userToken);
      PreferencesService.saveUserId(credentials.userId);
      PreferencesService.saveLoggedInUser(await UserRestClient.getUser());

      Navigator.pop(context);
    } else {
      _scaffoldKey.currentState
          .showSnackBar(FailureSnackBar("Something went wrong!"));
    }
  }
}
