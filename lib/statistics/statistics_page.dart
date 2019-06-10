import 'package:flutter/material.dart';
import 'package:share_pool/util/PreferencesService.dart';
import 'package:share_pool/util/rest/ExpenseRestClient.dart';
import 'package:share_pool/util/services/StatisticsService.dart';
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

  double userBalance = 0;

  _StatisticsPageState(MyDrawer myDrawer) {
    this.myDrawer = myDrawer;
  }

  @override
  void initState() {
    super.initState();

    loadUserBalance();
  }

  void loadUserBalance() async {
    setState(() async {
      userBalance = await ExpenseRestClient
          .getTotalBalancegetAllExpensesForLoggedInUser();
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
          Card(
            child: Row(
              children: <Widget>[
                Text("Total balance:"),
                Text(userBalance?.toString())
              ],
            ),
          )
        ],
      ),
    );
  }
}
