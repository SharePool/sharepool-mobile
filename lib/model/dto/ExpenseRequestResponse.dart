import 'package:share_pool/model/dto/TourDto.dart';

import 'UserDto.dart';

class ExpenseRequestResponseDto {
  TourDto tour;
  UserDto receiver;

  ExpenseRequestResponseDto(this.tour, this.receiver);

  ExpenseRequestResponseDto.fromJson(Map<String, dynamic> json)
      : tour = TourDto.fromJson(json['tour']),
        receiver = UserDto.fromJson(json['receiver']);

  dynamic toJson() => {'tour': tour, 'receiver': receiver};
}
