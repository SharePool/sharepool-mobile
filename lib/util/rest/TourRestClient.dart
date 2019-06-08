import 'dart:convert';

import 'package:http/http.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/tour/TourDto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TourRestClient {
  static const String BASE_URL = Constants.BASE_REST_URL + "/tours";

  static Future<List<TourDto>> getToursForUser(int userId) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var response =
        await get(BASE_URL + "/users/" + userId.toString(), headers: {
          Constants.HTTP_AUTHORIZATION:
          sharedPreferences.getString(Constants.SETTINGS_USER_TOKEN)
    });

    print(response.body);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<TourDto>((json) => TourDto.fromJson(json)).toList();
    }

    return null;
  }

  static Future<void> createOrUpdateTour(TourDto tourDto) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var body = json.encode(tourDto);

    var response;
    if (tourDto.tourId != null) {
      response = await put(BASE_URL + "/" + tourDto.tourId.toString(),
          body: body,
          headers: {
            "Content-Type": "application/json",
            Constants.HTTP_AUTHORIZATION:
                sharedPreferences.getString(Constants.SETTINGS_USER_TOKEN)
          });
    } else {
      response = await post(BASE_URL, body: body, headers: {
        "Content-Type": "application/json",
        Constants.HTTP_AUTHORIZATION:
        sharedPreferences.getString(Constants.SETTINGS_USER_TOKEN)
      });
    }

    print(response.body);
  }

  static Future<void> deleteTour(int tourId) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var response = await delete(BASE_URL + "/" + tourId.toString(), headers: {
      Constants.HTTP_AUTHORIZATION:
      sharedPreferences.getString(Constants.SETTINGS_USER_TOKEN)
    });

    print(response.body);
  }
}
