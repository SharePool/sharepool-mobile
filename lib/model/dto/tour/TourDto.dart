class TourDto {
  int tourId;
  String from;
  String to;
  String currency;
  double cost;
  double kilometers;
  int ownerId;
  bool active;

  TourDto(
      {this.tourId,
      this.from,
      this.to,
      this.currency,
      this.cost,
      this.kilometers,
        this.ownerId,
        this.active});

  factory TourDto.fromJson(Map<String, dynamic> json) {
    return TourDto(
        tourId: json['tourId'],
        from: json['from'],
        to: json['to'],
        currency: json['currency'],
        cost: json['cost'],
        kilometers: json['kilometers'],
        ownerId: json['ownerId'],
        active: json['active']);
  }

  toJson() {
    return {
      "from": from,
      "to": to,
      "currency": currency,
      "cost": cost,
      "kilometers": kilometers,
      "ownerId": ownerId,
      "active": active
    };
  }
}
