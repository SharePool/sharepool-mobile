import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/common/HateoasDto.dart';
import 'package:share_pool/model/dto/expense/ExpenseRequestResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseRestClient {
  static const String BASE_URL = Constants.BASE_REST_URL + "/expenses/";

  static Future<HateoasDto<ExpenseRequestResponseDto>> requestExpense(
      int tourId) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var response = await post(BASE_URL + tourId.toString(), headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader:
          sharedPreferences.getString(Constants.SETTINGS_USER_TOKEN)
    });

    print(response.body);

    if (response.statusCode == 200) {
      var decode = json.decode(response.body);
      var hateoasDto = HateoasDto.create(() => ExpenseRequestResponseDto.fromJson(decode), decode);
      return hateoasDto;
    }

    return null;
  }

  static Future<bool> confirmExpense(HateoasDto<ExpenseRequestResponseDto> hateoasDto) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var response = await put(
       hateoasDto.link,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader:
              sharedPreferences.getString(Constants.SETTINGS_USER_TOKEN)
        });

    print(response.body);

    return response.statusCode == 201;
  }
}
