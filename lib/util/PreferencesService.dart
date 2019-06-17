import 'dart:convert';

import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/user/UserDto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static Future<String> getUserToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.SETTINGS_USER_TOKEN);
  }

  static Future<int> getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt(Constants.SETTINGS_USER_ID);
  }

  static Future saveLoggedInUser(UserDto loggedInUser) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(
        Constants.SETTINGS_LOGGED_IN_USER, json.encode(loggedInUser.toJson()));
  }

  static Future saveUserId(int userId) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(Constants.SETTINGS_USER_ID, userId);
  }

  static Future saveUserToken(String token) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.SETTINGS_USER_TOKEN, token);
  }

  static Future deleteUserInfo() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.remove(Constants.SETTINGS_USER_TOKEN);
    prefs.remove(Constants.SETTINGS_USER_ID);
    prefs.remove(Constants.SETTINGS_LOGGED_IN_USER);
  }

  static Future<UserDto> getLoggedInUser() async {
    var prefs = await SharedPreferences.getInstance();

    return UserDto.fromJson(
        json.decode(prefs.getString(Constants.SETTINGS_LOGGED_IN_USER)));
  }

  static Future<String> getHomePage() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getString(Constants.SETTINGS_HOME_PAGE);
  }

  static Future setHomePage(String homePage) async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString(Constants.SETTINGS_HOME_PAGE, homePage);
  }
}
