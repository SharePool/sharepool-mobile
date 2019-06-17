import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/common/HateoasDto.dart';
import 'package:share_pool/model/dto/expense/ExpenseRequestResponse.dart';
import 'package:share_pool/util/PreferencesService.dart';
import 'package:share_pool/util/RestHelper.dart';

class ExpenseRestClient {
  static const String BASE_URL = Constants.BASE_REST_URL + "/expenses";

  static Future<HateoasDto<ExpenseRequestResponseDto>> requestExpense(int tourId) async {
    var response = await post(
        "$BASE_URL/${tourId.toString()}",
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
          HttpHeaders.authorizationHeader: await PreferencesService
              .getUserToken()
        }
    );

    print(response.body);

    if (RestHelper.statusOk(response.statusCode)) {
      var decode = json.decode(response.body);
      var hateoasDto = HateoasDto.create(() => ExpenseRequestResponseDto.fromJson(decode), decode);
      return hateoasDto;
    }

    return null;
  }

  static Future<bool> confirmExpense(HateoasDto<ExpenseRequestResponseDto> hateoasDto) async {
    var response = await put(
        hateoasDto.link,
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.value,
          HttpHeaders.authorizationHeader: await PreferencesService
              .getUserToken()
        }
    );

    print(response.body);

    return RestHelper.statusOk(response.statusCode);
  }
}
