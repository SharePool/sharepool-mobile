import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/user/UserDto.dart';
import 'package:share_pool/model/dto/user/UserLoginDto.dart';
import 'package:share_pool/model/dto/user/UserTokenDto.dart';
import 'package:share_pool/util/PreferencesService.dart';

import '../RestHelper.dart';

class UserRestClient {
  static const String BASE_URL = Constants.BASE_REST_URL + "/users";

  static Future<UserCredentialsDto> loginUser(UserLoginDto userLoginDto) async {
    var body = json.encode(userLoginDto);

    var response = await put(BASE_URL + "/login",
        body: body,
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.value})
        .timeout(const Duration(seconds: 10));

//    print(response.body);

    if (RestHelper.statusOk(response.statusCode)) {
      return UserCredentialsDto.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<UserCredentialsDto> registerUser(
      UserDto registerUserDto) async {
    var body = json.encode(registerUserDto);

    var response = await post(BASE_URL,
        body: body,
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.value})
        .timeout(const Duration(seconds: 10));

//    print(response.body);

    if (RestHelper.statusOk(response.statusCode)) {
      return UserCredentialsDto.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<UserDto> getUser() async {
    var response = await get(BASE_URL, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: await PreferencesService.getUserToken()
    });

//    print(response.body);

    if (RestHelper.statusOk(response.statusCode)) {
      return UserDto.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<bool> updateUser(UserDto userDto) async {
    var body = json.encode(userDto);

    var response = await put(BASE_URL, body: body, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: await PreferencesService.getUserToken()
    });

//    print(response.body);

    return response.statusCode == 200;
  }
}
