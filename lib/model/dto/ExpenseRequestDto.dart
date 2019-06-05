class ExpenseRequestDto {
  int tourId;

  ExpenseRequestDto(this.tourId);

  ExpenseRequestDto.fromJson(Map<String, dynamic> json)
      : tourId = json['tourId'];

  dynamic toJson() => {'tourId': tourId};
}
