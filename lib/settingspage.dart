import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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

  UserDto user;

  String email = "";
  String userName = "";
  String homePage = "";
  String profileImg;
  double gasConsumption = 0.0;

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _userNameController = new TextEditingController();
  final TextEditingController _gasConsumptionController =
  new TextEditingController();

  _SettingsPageState(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  void initState() {
    super.initState();

    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: myDrawer,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: "UserName"),
                    controller: _userNameController,
                    validator: (value) {
                      int strLen = value.length;
                      if (strLen < 5 || strLen > 20) {
                        return "Username must have between 5 and 20 characters";
                      }
                    },
                    onSaved: (String value) {
                      userName = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Email"),
                    controller: _emailController,
                    validator: (value) {
                      if (value.isEmpty ||
                          !Constants.EMAIL_REG_EXP.hasMatch(value)) {
                        return "Email must be valid";
                      }
                    },
                    onSaved: (String value) {
                      email = value;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Gas Consumption (l per 100 km)"),
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: true),
                    controller: _gasConsumptionController,
                    validator: (value) {
                      double gasConsumption = double.parse(value);

                      if (gasConsumption < 0) {
                        return "Gas Consumption must be greater than or equal 0";
                      }
                    },
                    onSaved: (String value) {
                      gasConsumption = double.parse(value);
                    },
                  ),
                  Row(children: <Widget>[
                    Flexible(flex: 1, child: Text("Homepage:")),
                    Flexible(
                        flex: 3,
                        child: Container(
                            margin: EdgeInsets.only(left: 15),
                            child: DropdownButton<String>(
                              value: homePage,
                              isExpanded: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  homePage = newValue;
                                });
                              },
                              items: <String>[
                                'Driver',
                                'Passenger'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )))
                  ]),
                  showProfileImage(user, 100),
                  FlatButton(
                    child: Text("Change Profile-Picture"),
                    onPressed: () {
                      showPicDialog();
                    },
                  ),
                  RaisedButton(
                      onPressed: () {
                        var form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          doSave();
                        }
                      },
                      child: Text('Submit')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future loadUserData() async {
    user = await PreferencesService.getLoggedInUser();
    String homePagePref = await PreferencesService.getHomePage();

    if (homePagePref == null || homePagePref.isEmpty) homePagePref = "Driver";

    setState(() {
      email = user.email;
      _emailController.text = email;

      userName = user.userName;
      _userNameController.text = userName;

      gasConsumption = user.gasConsumption;
      _gasConsumptionController.text = gasConsumption.toString();

      profileImg = user.profileImg;

      homePage = homePagePref;
    });
  }

  Future doSave() async {
    if (homePage != null && homePage.isNotEmpty) {
      PreferencesService.setHomePage(homePage);
    }

    bool changed = false;

    if (user.userName != userName) {
      user.userName = userName;
      changed = true;
    }

    if (user.email != email) {
      user.email = email;
      changed = true;
    }

    if (user.profileImg != profileImg) {
      user.profileImg = profileImg;
      changed = true;
    }

    if (user.gasConsumption != gasConsumption) {
      user.gasConsumption = gasConsumption;
      changed = true;
    }

    if (changed) {
      try {
        bool updated = await UserRestClient.updateUser(user);

        if (updated) {
          PreferencesService.saveLoggedInUser(user);
          _scaffoldKey.currentState
              .showSnackBar(new SuccessSnackBar("Info updated."));
        } else {
          _scaffoldKey.currentState
              .showSnackBar(new FailureSnackBar("Something went wrong."));
        }
      } on SocketException catch (e) {
        _scaffoldKey.currentState
            .showSnackBar(new FailureSnackBar("Something went wrong."));
      }
    }
  }

  void openCamera(BuildContext context) async {
    File picture = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );

    String encodedImg = base64Encode(picture.readAsBytesSync());
    print(encodedImg);

    setState(() {
      profileImg = encodedImg;
    });

    Navigator.pop(context);
  }

  void openGallery(BuildContext context) async {
    File galleryPicture = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    String encodedImg = base64Encode(galleryPicture.readAsBytesSync());

    setState(() {
      profileImg = encodedImg;
    });

    Navigator.pop(context);
  }

  void showPicDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take a picture'),
                    onTap: () {
                      openCamera(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select from gallery'),
                    onTap: () {
                      openGallery(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
