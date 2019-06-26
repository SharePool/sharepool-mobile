import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/common/SnackBars.dart';
import 'package:share_pool/model/dto/user/UserDto.dart';
import 'package:share_pool/util/PreferencesService.dart';
import 'package:share_pool/util/rest/UserRestClient.dart';

import 'common/images.dart';
import 'mydrawer.dart';

class SettingsPage extends StatefulWidget {
  final String title = "Settings";
  MyDrawer myDrawer;

  SettingsPage(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  _SettingsPageState createState() => _SettingsPageState(this.myDrawer);
}

class _SettingsPageState extends State<SettingsPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  MyDrawer myDrawer;

  UserDto _user;

  String _email;
  String _userName;
  String _profileImg;
  double _gasConsumption = 0.0;

  var _userNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _gasConsumptionController = TextEditingController();

  bool _hasSomeValueChanged = false;

  _SettingsPageState(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  void initState() {
    super.initState();

    _userNameController.addListener(() {
      setState(() {
        _hasSomeValueChanged = _userNameController.text != _userName;
      });
    });

    _emailController.addListener(() {
      setState(() {
        _hasSomeValueChanged = _emailController.text != _email;
      });
    });

    _gasConsumptionController.addListener(() {
      setState(() {
        _hasSomeValueChanged =
            _gasConsumptionController.text != _gasConsumption.toString();
      });
    });

    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: myDrawer,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          children: <Widget>[
            GestureDetector(
              child: showProfileImage(_profileImg),
              onTap: _showPicDialog,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: TextFormField(
                decoration: const InputDecoration(labelText: "UserName"),
                validator: (value) {
                  int strLen = value.length;
                  if (strLen < 5 || strLen > 20) {
                    return "Username must have between 5 and 20 characters";
                  }
                },
                controller: _userNameController,
                onSaved: (String value) {
                  _userName = value;
                },
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Email"),
              validator: (value) {
                if (value.isEmpty || !Constants.EMAIL_REG_EXP.hasMatch(value)) {
                  return "Email must set and be valid";
                }
              },
              controller: _emailController,
              onSaved: (String value) {
                _email = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Gas Consumption (l per 100 km)"),
              keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: true),
              validator: (value) {
                if (value.isEmpty) {
                  return "Gas consumption must be set";
                }

                double gasConsumption = double.parse(value);

                if (gasConsumption < 0) {
                  return "Gas Consumption must be greater than or equal 0";
                }
              },
              controller: _gasConsumptionController,
              onSaved: (String value) {
                _gasConsumption = double.parse(value);
              },
            ),
            Row(
              children: <Widget>[
                _hasSomeValueChanged
                    ? FlatButton(
                  child: Text(
                    "Reset",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    _loadUserData();
                    _hasSomeValueChanged = false;
                  },
                )
                    : Spacer(),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: RaisedButton(
                      onPressed: _hasSomeValueChanged
                          ? () {
                        var form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          _doSave();
                        }
                      }
                          : null,
                      child: Text("Update")),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _loadUserData() async {
    _user = await PreferencesService.getLoggedInUser();

    setState(() {
      _email = _user.email;
      _userName = _user.userName;
      _gasConsumption = _user.gasConsumption;
      _profileImg = _user.profileImg;

      _userNameController.text = _userName;
      _emailController.text = _email;
      _gasConsumptionController.text = _gasConsumption.toString();
    });
  }

  Future _doSave() async {
    _user.email = _email;
    _user.userName = _userName;
    _user.gasConsumption = _gasConsumption;
    _user.profileImg = _profileImg;

    try {
      bool updated = await UserRestClient.updateUser(_user);

      if (updated) {
        PreferencesService.saveLoggedInUser(_user);
        _scaffoldKey.currentState
            .showSnackBar(new SuccessSnackBar("Info updated."));

        setState(() {
          _hasSomeValueChanged = false;
        });
      } else {
        _scaffoldKey.currentState
            .showSnackBar(new FailureSnackBar("Something went wrong."));
      }
    } on Exception {
      _scaffoldKey.currentState
          .showSnackBar(new FailureSnackBar("Something went wrong."));
    }
  }

  void _openCamera(BuildContext context) async {
    File picture = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 200,
        maxWidth: 200
    );

    picture = await FlutterImageCompress.compressAndGetFile(
        picture.absolute.path, picture.absolute.path, quality: 70);

    String encodedImg = base64Encode(picture.readAsBytesSync());
    print(encodedImg);

    setState(() {
      _profileImg = encodedImg;
      _hasSomeValueChanged = _profileImg != _user.profileImg;
    });

    Navigator.pop(context);
  }

  void _openGallery(BuildContext context) async {
    File galleryPicture = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 200,
        maxWidth: 200
    );

    galleryPicture = await FlutterImageCompress.compressAndGetFile(
        galleryPicture.absolute.path, galleryPicture.absolute.path,
        quality: 70);

    String encodedImg = base64Encode(galleryPicture.readAsBytesSync());

    setState(() {
      _profileImg = encodedImg;
      _hasSomeValueChanged = _profileImg != _user.profileImg;
    });

    Navigator.pop(context);
  }

  void _showPicDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text(
                      "Remove Picture",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      setState(() {
                        _profileImg = null;
                        setState(() {
                          _hasSomeValueChanged =
                              _profileImg != _user.profileImg;
                        });
                        Navigator.pop(context);
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  GestureDetector(
                    child: new Text("Take a picture"),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  GestureDetector(
                    child: new Text("Select from gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
