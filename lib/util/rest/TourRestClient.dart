import 'dart:convert';

import 'package:http/http.dart';
import 'package:share_pool/model/dto/TourDto.dart';

class TourRestClient {
  static const String BASE_URL = "http://192.168.178.30:8080/tours";

  static Future<List<TourDto>> getToursForUser(int userId) async {
    var response = await get(BASE_URL + "/users/" + userId.toString());

    print(response.body);

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<TourDto>((json) => TourDto.fromJson(json)).toList();
    }

    return null;
  }

  static Future<void> createOrUpdateTour(TourDto tourDto) async {
    var body = json.encode(tourDto);

    var response;
    if (tourDto.tourId != null) {
      response = await put(BASE_URL + "/" + tourDto.tourId.toString(),
          body: body, headers: {"Content-Type": "application/json"});
    } else {
      response = await post(BASE_URL,
          body: body, headers: {"Content-Type": "application/json"});
    }

    print(response.body);
  }

  static Future<void> deleteTour(int tourId) async {
    var response = await delete(BASE_URL + "/" + tourId.toString());

    print(response.body);
  }
}
