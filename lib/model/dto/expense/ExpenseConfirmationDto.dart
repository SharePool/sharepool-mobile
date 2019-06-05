class ExpenseConfirmationDto {
  int tourId;
  int payerId;
  String description;

  ExpenseConfirmationDto(this.tourId, this.payerId, this.description);

  ExpenseConfirmationDto.fromJson(Map<String, dynamic> json)
      : tourId = json['tourId'],
        payerId = json['payerId'],
        description = json['description'];

  dynamic toJson() =>
      {'tourId': tourId, 'payerId': payerId, 'description': description};
}
