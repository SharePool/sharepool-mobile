class TourDto {
  int tourId;
  String from;
  String to;
  String currency;
  double cost;
  double kilometers;
  int ownerId;

  TourDto(
      {this.tourId,
      this.from,
      this.to,
      this.currency,
      this.cost,
      this.kilometers,
      this.ownerId});

  factory TourDto.fromJson(Map<String, dynamic> json) {
    return TourDto(
        tourId: json['tourId'],
        from: json['from'],
        to: json['to'],
        currency: json['currency'],
        cost: json['cost'],
        kilometers: json['kilometers'],
        ownerId: json['ownerId']);
  }

  toJson() {
    return {
      "from": from,
      "to": to,
      "currency": currency,
      "cost": cost,
      "kilometers": kilometers,
      "ownerId": ownerId
    };
  }
}
