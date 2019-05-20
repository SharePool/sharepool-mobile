class TourCreationDto {
  String from;
  String to;
  String currency;
  double cost;
  double kilometers;

  TourCreationDto(
      {this.from, this.to, this.currency, this.cost, this.kilometers});

  factory TourCreationDto.fromJson(Map<String, dynamic> json) {
    return TourCreationDto(
      from: json['from'],
      to: json['to'],
      currency: json['currency'],
      cost: json['cost'],
      kilometers: json['kilometers'],
    );
  }
}
