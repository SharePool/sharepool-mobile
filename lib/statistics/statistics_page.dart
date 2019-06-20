import 'package:flutter/material.dart';
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
    var totalBalance = await ExpenseRestClient.getTotalBalance();
    var expensesWrapper = await ExpenseRestClient
        .getAllExpensesForLoggedInUser();

    setState(() {
      _userBalance = totalBalance;
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
      body: ListView(
        children: <Widget>[
          TotalBalanceWidget(userBalance: _userBalance)
        ],
      ),
    );
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
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.teal
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _userBalance <= 0 ? "You owe: " : "You are owed: ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                    Text(
                      _userBalance?.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: _userBalance <= 0
                              ? Colors.redAccent
                              : Colors.greenAccent
                      ),
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
