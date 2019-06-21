import 'package:share_pool/model/dto/expense/ExpenseDto.dart';
import 'package:share_pool/model/dto/user/UserDto.dart';

class ExpensePerUserDto {
  UserDto userDto;
  double sumOfExpenses;
  List<ExpenseDto> expenses;

  ExpensePerUserDto(this.userDto, this.sumOfExpenses, this.expenses);

  factory ExpensePerUserDto.fromJson(Map<String, dynamic> json) {
    var expenses = json["expenses"] as List;

    List<ExpenseDto> expensesDtos =
        expenses.map((json) => ExpenseDto.fromJson(json)).toList();

    return ExpensePerUserDto(UserDto.fromJson(json["receiver"]),
        json["sumOfExpenses"], expensesDtos);
  }
}
