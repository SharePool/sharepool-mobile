class AnalyticsEntry {
  DateTime creationDate;
  double kmSum;
  double litersGasSaved;

  AnalyticsEntry({this.creationDate, this.kmSum, this.litersGasSaved});

  factory AnalyticsEntry.fromJson(Map<String, dynamic> json) {
    return AnalyticsEntry(
        creationDate: DateTime.parse(json['creationDate']),
        kmSum: json['kmSum'],
        litersGasSaved: json['litersGasSaved']);
  }

  toJson() {
    return {
      "creationDate": creationDate,
      "kmSum": kmSum,
      "litersGasSaved": litersGasSaved
    };
  }
}
