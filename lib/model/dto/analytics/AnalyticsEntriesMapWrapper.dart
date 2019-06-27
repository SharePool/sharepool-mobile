import 'dart:collection';

import 'package:share_pool/model/dto/analytics/AnalyticsEntry.dart';

class AnalyticsEntriesMapWrapper {
  Map<DateTime, AnalyticsEntry> entriesMap;

  AnalyticsEntriesMapWrapper(this.entriesMap);

  factory AnalyticsEntriesMapWrapper.fromJson(Map<String, dynamic> json) {
    var resultMap = new LinkedHashMap<DateTime, AnalyticsEntry>();

    json.forEach((date, analyticsEntry) => resultMap[DateTime.parse(date)] =
        AnalyticsEntry.fromJson(analyticsEntry));

    return new AnalyticsEntriesMapWrapper(resultMap);
  }
}
