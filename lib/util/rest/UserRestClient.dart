import 'dart:convert';

import 'package:http/http.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/LoginUserDto.dart';
import 'package:share_pool/model/dto/RegisterUserDto.dart';
import 'package:share_pool/model/dto/UserTokenDto.dart';

class UserRestClient {
  static const String BASE_URL = Constants.BASE_REST_URL + "/users";

  static Future<UserCredentialsDto> loginUser(LoginUserDto loginUserDto) async {
    var body = json.encode(loginUserDto);

    var response = await post(BASE_URL,
        body: body, headers: {"Content-Type": "application/json"});

    print(response.body);

    if (response.statusCode == 200) {
      return UserCredentialsDto.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<UserCredentialsDto> registerUser(
      RegisterUserDto registerUserDto) async {
    var body = json.encode(registerUserDto);

    var response = await put(BASE_URL,
        body: body, headers: {"Content-Type": "application/json"});

    print(response.body);

    if (response.statusCode == 200) {
      return UserCredentialsDto.fromJson(json.decode(response.body));
    }

    return null;
  }
}
