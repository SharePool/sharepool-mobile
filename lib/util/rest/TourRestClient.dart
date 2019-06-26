import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/tour/TourDto.dart';
import 'package:share_pool/util/PreferencesService.dart';

import '../RestHelper.dart';

class TourRestClient {
  static const String BASE_URL = Constants.BASE_REST_URL + "/tours";

  static Future<List<TourDto>> getToursForUser([bool includeInactive]) async {
    String url = BASE_URL;

    if (includeInactive != null) {
      url += "?includeInactive=" + includeInactive?.toString();
    }

    var response = await get(url, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: await PreferencesService.getUserToken()
    });

//    print(response.body);

    if (RestHelper.statusOk(response.statusCode)) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<TourDto>((json) => TourDto.fromJson(json)).toList();
    }

    return null;
  }

  static Future<void> createOrUpdateTour(TourDto tourDto) async {
    var body = json.encode(tourDto);

    var response;
    if (tourDto.tourId != null) {
      response = await put("$BASE_URL/${tourDto.tourId.toString()}",
          body: body,
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.json.value,
            HttpHeaders.authorizationHeader:
                await PreferencesService.getUserToken()
          });
    } else {
      response = await post(BASE_URL, body: body, headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
        HttpHeaders.authorizationHeader: await PreferencesService.getUserToken()
      });
    }

//    print(response.body);
  }

  static Future<void> deleteTour(int tourId) async {
    var response = await delete("$BASE_URL/${tourId.toString()}", headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: await PreferencesService.getUserToken()
    });

//    print(response.body);
  }

  static Future<void> activateTour(int tourId) async {
    var response =
        await put("$BASE_URL/${tourId.toString()}/activate", headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.authorizationHeader: await PreferencesService.getUserToken()
    });

//    print(response.body);
  }
}
