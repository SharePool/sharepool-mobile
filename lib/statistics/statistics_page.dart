import 'package:flutter/material.dart';
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

  _StatisticsPageState(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  void initState() {
    super.initState();

    loadUserBalance();
  }

  void loadUserBalance() async {
    var totalBalance = await ExpenseRestClient
        .getTotalBalancegetAllExpensesForLoggedInUser();

    setState(() {
      _userBalance = totalBalance;
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
          Padding(
            padding: const EdgeInsets.all(8.0),
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
          )
        ],
      ),
    );
  }
}
