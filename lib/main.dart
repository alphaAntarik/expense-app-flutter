import 'dart:io';

import 'package:expense/widgets/new_transaction.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'model/Transaction.dart';
import 'package:intl/intl.dart';

import 'widgets/chart.dart';
import 'widgets/transaction_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      // theme: ThemeData(
      //     primarySwatch: Colors.purple,
      //     accentColor: Colors.amber,
      //     fontFamily: 'Quicksand'),

      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<transaction> _transactions = [];

  List<transaction> get _recenttransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addnewTransaction(String title, double amount, DateTime selectedDate) {
    final newTx =
        transaction(DateTime.now().toString(), title, amount, selectedDate);
    setState(() {
      _transactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final _isLandscape = mediaquery.orientation == Orientation.landscape;
    bool _showchart = false;
    final PreferredSizeWidget appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewActivity(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text("Personal Expenses"),
            backgroundColor: Colors.purple,
            actions: <Widget>[
              IconButton(
                  iconSize: 50,
                  icon: const Icon(Icons.add),
                  onPressed: () => _startAddNewActivity(context))
            ],
          );
    final sevenTx = Container(
        height: (mediaquery.size.height -
                appbar.preferredSize.height -
                mediaquery.padding.top) *
            0.2,
        child: Chart(_recenttransactions));
    final tranx = Container(
        height: (mediaquery.size.height -
                appbar.preferredSize.height -
                mediaquery.padding.top) *
            0.8,
        child: TransactionList(_transactions, _deleteTransaction));
    return MaterialApp(
        home: Scaffold(
            appBar: appbar,
            body: Center(
              child: Container(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    if (_isLandscape)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Show chart"),
                          Switch.adaptive(
                              activeColor: Colors.amber,
                              value: _showchart,
                              onChanged: (val) {
                                setState(() {
                                  _showchart = val;
                                });
                              })
                        ],
                      ),
                    if (_isLandscape) _showchart ? sevenTx : tranx,
                    if (!_isLandscape) sevenTx,
                    if (!_isLandscape) tranx,
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    backgroundColor: Colors.amber,
                    onPressed: () => _startAddNewActivity(context))));
  }

  _startAddNewActivity(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addnewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }
}
