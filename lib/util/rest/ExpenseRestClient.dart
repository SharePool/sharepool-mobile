import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/common/HateoasDto.dart';
import 'package:share_pool/model/dto/expense/ExpenseDto.dart';
import 'package:share_pool/model/dto/expense/ExpenseRequestResponse.dart';
import 'package:share_pool/model/dto/expense/ExpenseWrapper.dart';
import 'package:share_pool/util/PreferencesService.dart';

class ExpenseRestClient {
  static const String BASE_URL = Constants.BASE_REST_URL + "/expenses/";

  static Future<HateoasDto<ExpenseRequestResponseDto>> requestExpense(
      int tourId) async {
    var response = await post(BASE_URL + tourId.toString(), headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: await PreferencesService.getUserToken()
    });

    print(response.body);

    if (response.statusCode == 200) {
      var decode = json.decode(response.body);
      var hateoasDto = HateoasDto.create(
          () => ExpenseRequestResponseDto.fromJson(decode), decode);
      return hateoasDto;
    }

    return null;
  }

  static Future<bool> confirmExpense(
      HateoasDto<ExpenseRequestResponseDto> hateoasDto) async {
    var response = await put(hateoasDto.link, headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: await PreferencesService.getUserToken()
    });

    print(response.body);

    return response.statusCode == 201;
  }

  static Future<ExpensesWrapper> getAllExpensesForLoggedInUser(
      [int receiverId]) async {
    var response;
    if (receiverId != null) {
      response =
          await get(BASE_URL + "receiverId=" + receiverId.toString(), headers: {
        HttpHeaders.authorizationHeader: await PreferencesService.getUserToken()
      });
    } else {
      response = await get(BASE_URL, headers: {
        HttpHeaders.authorizationHeader: await PreferencesService.getUserToken()
      });
    }

    print(response.body);

    if (response.statusCode == 200) {
      return ExpensesWrapper.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<double> getTotalBalancegetAllExpensesForLoggedInUser() async {
    var response = await get(BASE_URL + "balance", headers: {
      HttpHeaders.authorizationHeader: await PreferencesService.getUserToken()
    });

    print(response.body);

    if (response.statusCode == 200) {
      return json.decode(response.body) as double;
    }

    return null;
  }
}
