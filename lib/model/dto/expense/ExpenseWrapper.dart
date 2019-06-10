import 'ExpenseDto.dart';

class ExpensesWrapper {
  List<ExpenseDto> receivingExpenses;
  List<ExpenseDto> payedExpenses;

  ExpensesWrapper(this.receivingExpenses, this.payedExpenses);

  ExpensesWrapper.fromJson(Map<String, dynamic> json) {
    var receivingExpenses = json["receivingExpenses"];
    var payedExpenses = json["payedExpenses"];

    // todo deseriliaze correctly
  }
}
