import 'package:share_pool/model/dto/expense/ExpensePerUserDto.dart';

class ExpensesWrapper {
  double totalBalance;
  List<ExpensePerUserDto> expenses;

  ExpensesWrapper(this.totalBalance, this.expenses);

  factory ExpensesWrapper.fromJson(Map<String, dynamic> json) {
    var expenses = json["expenses"] as List;

    List<ExpensePerUserDto> expensesPerUser = expenses.map((i) =>
        ExpensePerUserDto.fromJson(i)).toList();

    return ExpensesWrapper(
        json["totalBalance"],
        expensesPerUser
    );
  }
}
