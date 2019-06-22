class PaybackDto {
  String userNameOrEmail;
  double amount;

  toJson() {
    return {"userNameOrEmail": userNameOrEmail, "amount": amount};
  }
}
