import 'package:flutter/material.dart';
import 'package:share_pool/common/images.dart';
import 'package:share_pool/model/dto/expense/ExpenseWrapper.dart';
import 'package:share_pool/util/rest/ExpenseRestClient.dart';

import '../mydrawer.dart';

class StatisticsPage extends StatefulWidget {
  final String title = "Ride Statistics";
  MyDrawer myDrawer;

  StatisticsPage(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  _StatisticsPageState createState() => _StatisticsPageState(this.myDrawer);
}

class _StatisticsPageState extends State<StatisticsPage> {
  MyDrawer myDrawer;

  double _userBalance = 0;
  ExpensesWrapper _expensesWrapper;

  _StatisticsPageState(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  void initState() {
    super.initState();

    loadUserBalance();
  }

  void loadUserBalance() async {
    var expensesWrapper =
    await ExpenseRestClient.getAllExpensesForLoggedInUser();

    setState(() {
      _userBalance = expensesWrapper.totalBalance;
      _expensesWrapper = expensesWrapper;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: myDrawer,
        body: Column(
          children: <Widget>[
            TotalBalanceWidget(userBalance: _userBalance),
            Flexible(
              child: ExpensesPerUserWidget(expensesWrapper: _expensesWrapper),
            )
          ],
        ));
  }
}

class ExpensesPerUserWidget extends StatelessWidget {
  const ExpensesPerUserWidget({
    Key key,
    @required ExpensesWrapper expensesWrapper,
  })
      : _expensesWrapper = expensesWrapper,
        super(key: key);

  final ExpensesWrapper _expensesWrapper;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _expensesWrapper?.expenses == null
            ? 0
            : _expensesWrapper?.expenses?.length,
        itemBuilder: (BuildContext context, int index) {
          var expensePerReceiver = _expensesWrapper?.expenses[index];

          return InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      showProfileImage(expensePerReceiver.userDto, 50),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          expensePerReceiver.userDto.userName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer(),
                      Text(_getFittingText(expensePerReceiver.sumOfExpenses)),
                      Text(_fixUpNegative(expensePerReceiver.sumOfExpenses),
                          style: TextStyle(
                              fontSize: 16,
                              color: _getFittingColor(
                                  expensePerReceiver.sumOfExpenses))),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class TotalBalanceWidget extends StatelessWidget {
  const TotalBalanceWidget({
    Key key,
    @required double userBalance,
  })
      : _userBalance = userBalance,
        super(key: key);

  final double _userBalance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Total Balance",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: Colors.teal),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _getFittingText(_userBalance),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      _fixUpNegative(_userBalance),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, color: _getFittingColor(_userBalance)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _getFittingColor(double amount) {
  return amount <= 0 ? Colors.redAccent : Colors.greenAccent;
}

String _getFittingText(double amount) {
  return amount <= 0 ? "You owe: " : "You are owed: ";
}

String _fixUpNegative(double amount) {
  return amount < 0
      ? (amount * -1).toStringAsFixed(2)
      : amount.toStringAsFixed(2);
}
