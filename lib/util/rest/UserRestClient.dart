import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/user/UserDto.dart';
import 'package:share_pool/model/dto/user/UserLoginDto.dart';
import 'package:share_pool/model/dto/user/UserTokenDto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRestClient {
  static const String BASE_URL = Constants.BASE_REST_URL + "/users";

  static Future<UserCredentialsDto> loginUser(UserLoginDto userLoginDto) async {
    var body = json.encode(userLoginDto);

    var response = await post(BASE_URL,
        body: body, headers: {"Content-Type": "application/json"});

    print(response.body);

    if (response.statusCode == 200) {
      return UserCredentialsDto.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<UserCredentialsDto> registerUser(UserDto registerUserDto) async {
    var body = json.encode(registerUserDto);

    var response = await put(BASE_URL,
        body: body, headers: {"Content-Type": "application/json"});

    print(response.body);

    if (response.statusCode == 200) {
      return UserCredentialsDto.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<UserDto> getUser() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var response =
    await get(BASE_URL, headers: {
      "Authorization": sharedPreferences.getString(
          Constants.SETTINGS_USER_TOKEN)
    });

    print(response.body);

    if (response.statusCode == 200) {
      return UserDto.fromJson(json.decode(response.body));
    }

    return null;
  }
}
