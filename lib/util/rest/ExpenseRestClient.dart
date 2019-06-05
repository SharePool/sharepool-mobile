import 'dart:convert';

import 'package:http/http.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/ExpenseConfirmationDto.dart';
import 'package:share_pool/model/dto/ExpenseRequestDto.dart';
import 'package:share_pool/model/dto/ExpenseRequestResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseRestClient {
  static const String BASE_URL = Constants.BASE_REST_URL + "/expenses";

  static Future<ExpenseRequestResponseDto> requestExpense(
      ExpenseRequestDto expenseRequestDto) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var body = expenseRequestDto.tourId.toString();

    var response = await post(BASE_URL + "/request", body: body, headers: {
      "Content-Type": "application/json",
      "Auth-Token": sharedPreferences.getString(Constants.SETTINGS_USER_TOKEN)
    });

    print(response.body);

    if (response.statusCode == 200) {
      return ExpenseRequestResponseDto.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<void> confirmExpense(
      ExpenseConfirmationDto expenseConfirmationDto) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var body = json.encode(expenseConfirmationDto);

    var response = await put(BASE_URL + "/confirmation", body: body, headers: {
      "Content-Type": "application/json",
      "Auth-Token": sharedPreferences.getString(Constants.SETTINGS_USER_TOKEN)
    });

    print(response.body);

    if (response.statusCode == 200) {
      // TODO: show confirmation
    }
  }
}
