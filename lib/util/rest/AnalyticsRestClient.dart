import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/analytics/AnalyticsEntriesMapWrapper.dart';
import 'package:share_pool/model/dto/analytics/AnalyticsEntry.dart';

import '../PreferencesService.dart';
import '../RestHelper.dart';

class AnalyticsRestClient {
  static var formatter = new DateFormat('yyyy-MM-dd');

  static const String BASE_URL =
      Constants.BASE_ANALYTICS_REST_URL + "/analytics";

  static Future<Map<DateTime, AnalyticsEntry>> getAnalyticsDataForTimeSpan(
      DateTime from, DateTime to) async {
    var response = await get(
        "$BASE_URL?from=${formatter.format(from)}&to=${formatter.format(to)}",
        headers: {
          HttpHeaders.authorizationHeader:
              await PreferencesService.getUserToken()
        });

    print(response.body);

    if (RestHelper.statusOk(response.statusCode)) {
      var wrapper =
          AnalyticsEntriesMapWrapper.fromJson(json.decode(response.body));
      return wrapper.entriesMap;
    }
  }
}
