import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_pool/common/SnackBars.dart';
import 'package:share_pool/driver-settings/tourListWidget.dart';
import 'package:share_pool/model/dto/expense/ExpensePerUserDto.dart';
import 'package:share_pool/model/dto/expense/PaybackDto.dart';
import 'package:share_pool/model/dto/user/UserDto.dart';
import 'package:share_pool/mydrawer.dart';
import 'package:share_pool/statistics/statistics_page.dart';
import 'package:share_pool/util/rest/ExpenseRestClient.dart';

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
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PaybackForm(myDrawer, _expensePerUserDto.userDto)));
            }),
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
                        expense.tour != null
                            ? displayTour(expense.tour, 18)
                            : Text("Payback"),
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

class PaybackForm extends StatefulWidget {
  UserDto userDto;

  var myDrawer;

  PaybackForm(this.myDrawer, this.userDto);

  @override
  _PaybackFormState createState() => _PaybackFormState(this.userDto);
}

class _PaybackFormState extends State<PaybackForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PaybackDto paybackDto;

  _PaybackFormState(UserDto userDto) {
    this.paybackDto = new PaybackDto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Payback with ${widget.userDto.userName}"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Amount you want to pay back",
                      suffixIcon: Icon(Icons.attach_money)),
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Amount must be set";
                    }

                    if (double.parse(value) < 0.1) {
                      return "Value must be over 0.1";
                    }
                  },
                  onSaved: (String value) {
                    paybackDto.amount = double.parse(value);
                  },
                  initialValue: null,
                ),
                Row(
                  children: <Widget>[
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RaisedButton(
                        child: Text("Submit"),
                        onPressed: () {
                          var formState = _formKey.currentState;
                          if (formState.validate()) {
                            formState.save();

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm payback"),
                                    content: Text(
                                        "Do you really want to pay back ${paybackDto
                                            .amount.toStringAsFixed(
                                            2)} to ${widget.userDto
                                            .userName}?"),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      new RaisedButton(
                                        child: new Text("Yes"),
                                        textColor: Colors.white,
                                        onPressed: () =>
                                            confirmPayback(paybackDto),
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
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

  confirmPayback(PaybackDto paybackDto) async {
    paybackDto.userNameOrEmail = widget.userDto.userName;

    bool success = await ExpenseRestClient.sendPayback(paybackDto);

    if (success) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  StatisticsPage(widget.myDrawer)));
    } else {
      _scaffoldKey.currentState
          .showSnackBar(new FailureSnackBar("Payback could not be sent."));
    }
  }
}
