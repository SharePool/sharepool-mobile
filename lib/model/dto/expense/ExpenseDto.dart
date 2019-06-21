import 'package:share_pool/model/dto/tour/TourDto.dart';
import 'package:share_pool/model/dto/user/UserDto.dart';

class ExpenseDto {
  double amount;
  String creationDate;
  String currency;
  UserDto receiver;
  TourDto tour;

  ExpenseDto(this.amount, this.creationDate, this.currency, this.receiver, this.tour);

  ExpenseDto.fromJson(Map<String, dynamic> json)
      : amount = json["amount"],
      creationDate = json["creationDate"],
      currency = json["currency"],
        tour = json["tour"] == null ? null : TourDto.fromJson(json["tour"]),
        receiver = json["receiver"] == null ? null : UserDto.fromJson(
            json["receiver"]);
}