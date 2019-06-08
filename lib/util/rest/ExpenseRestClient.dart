import 'dart:convert';

import 'package:http/http.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/expense/ExpenseConfirmationDto.dart';
import 'package:share_pool/model/dto/expense/ExpenseRequestResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseRestClient {
  static const String BASE_URL = Constants.BASE_REST_URL + "/expenses/";

  static Future<ExpenseRequestResponseDto> requestExpense(int tourId) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var response = await post(
        BASE_URL + tourId.toString(), headers: {
      "Content-Type": "application/json",
      Constants.HTTP_AUTHORIZATION: sharedPreferences.getString(
          Constants.SETTINGS_USER_TOKEN)
    });

    print(response.body);

    if (response.statusCode == 200) {
      return ExpenseRequestResponseDto.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<bool> confirmExpense(
      ExpenseConfirmationDto expenseConfirmationDto) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var body = "";

    var response = await put(
        BASE_URL + "/confirmations/" + expenseConfirmationDto.tourId.toString(),
        body: body, headers: {
      "Content-Type": "application/json",
      Constants.HTTP_AUTHORIZATION: sharedPreferences.getString(
          Constants.SETTINGS_USER_TOKEN)
    });

    print(response.body);

    return response.statusCode == 201;
  }
}
