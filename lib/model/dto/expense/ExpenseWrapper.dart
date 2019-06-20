import 'ExpenseDto.dart';

class ExpensesWrapper {
  List<ExpenseDto> receivingExpenses;
  List<ExpenseDto> payedExpenses;

  ExpensesWrapper(this.receivingExpenses, this.payedExpenses);

  factory ExpensesWrapper.fromJson(Map<String, dynamic> json) {
    var receivingExpenses = json["receivingExpenses"] as List<dynamic>;
    var payedExpenses = json["payedExpenses"] as List<dynamic>;

    receivingExpenses =
        receivingExpenses.map((json) => ExpenseDto.fromJson(json)).toList();
    payedExpenses =
        payedExpenses.map((json) => ExpenseDto.fromJson(json)).toList();

    return ExpensesWrapper(receivingExpenses, payedExpenses);
  }
}
