import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_pool/driver-settings/tourListWidget.dart';
import 'package:share_pool/model/dto/expense/ExpensePerUserDto.dart';
import 'package:share_pool/mydrawer.dart';
import 'package:share_pool/statistics/statistics_page.dart';

class SingleUserExpensesPage extends StatelessWidget {
  final MyDrawer myDrawer;
  String _title;

  ExpensePerUserDto _expensePerUserDto;

  SingleUserExpensesPage(this.myDrawer, this._expensePerUserDto) {
    _title = "Expenses with ${_expensePerUserDto.userDto.userName}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        drawer: myDrawer,
        body: Column(
          children: <Widget>[
            TotalBalanceWidget(userBalance: _expensePerUserDto.sumOfExpenses),
            Flexible(
              child: ListView.builder(
                itemCount: _expensePerUserDto?.expenses?.length,
                itemBuilder: (context, index) {
                  var expense = _expensePerUserDto.expenses[index];
                  return ListTile(
                    title: Row(
                      children: <Widget>[
                        displayTour(expense.tour, 18),
                        Spacer(),
                        Text(
                          getFittingText(expense.amount),
                        ),
                        Text(expense.amount.toStringAsFixed(2),
                            style: TextStyle(
                                color: getFittingColor(expense.amount))),
                      ],
                    ),
                    subtitle: Text(expense.creationDate),
                  );
                },
              ),
            )
          ],
        ));
  }
}
