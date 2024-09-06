import 'dart:collection';

import 'package:cash_manager/models/transaction_account.dart';
import 'package:cash_manager/models/transaction_type.dart';
import 'package:cash_manager/screens/home_screen.dart';
import 'package:cash_manager/services/database/queries/transaction_account_query.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/button_alert.dart';
import 'package:cash_manager/widgets/calendar_picker.dart';
import 'package:cash_manager/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({
    super.key,
    required this.transactionType,
  });

  final TransactionType transactionType;

  @override
  TransactionListScreenState createState() => TransactionListScreenState();
}

class TransactionListScreenState extends State<TransactionListScreen> {
  TransactionType listType = TransactionType.income;
  DateTime selectedDate = DateTime.now();

  final formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");
  double _totalTransaction = 0;

  Map<DateTime, List<TransactionAccount>> transactions = {};

  @override
  void initState() {
    super.initState();
    _getTransactions();
  }

  Future<void> _getTransactions() async {
    List<TransactionAccount> transactionTemp = [];
    double total = 0;

    switch (listType) {
      case TransactionType.income:
        transactionTemp =
            await TransactionAccountQuery.getTransactionUpToDateWithType(
                selectedDate, true);
        total = _calcTotal(transactionTemp);
        break;
      case TransactionType.expense:
        transactionTemp =
            await TransactionAccountQuery.getTransactionUpToDateWithType(
                selectedDate, false);
        total = _calcTotal(transactionTemp);
        break;
      case TransactionType.transaction:
        transactionTemp =
            await TransactionAccountQuery.getTransactionUpToDate(selectedDate);
        total = _calcTotal(transactionTemp);
        break;
    }

    SplayTreeMap<DateTime, List<TransactionAccount>> map = SplayTreeMap();

    for (var t in transactionTemp) {
      if (map[t.date] == null) {
        map[t.date] = [t];
      } else {
        map[t.date]!.add(t);
      }
    }

    setState(() {
      transactions = LinkedHashMap.fromEntries(map.entries.toList().reversed);
      _totalTransaction = total;
    });
  }

  double _calcTotal(List<TransactionAccount> transactionsTemp) {
    double total = 0;
    for (TransactionAccount item in transactionsTemp) {
      if (item.type == 1) {
        total += item.amount;
      } else {
        total -= item.amount;
      }
    }
    return total;
  }

  _selectValue(String? value) {
    setState(() {
      listType = TransactionTypeHelper.fromString(value);
    });
    _getTransactions();
  }

  _selectMonth(DateTime dateTime) {
    setState(() {
      selectedDate = dateTime;
    });
    _getTransactions();
  }

  _addMonth() {
    DateTime date = DateTime(selectedDate.year, selectedDate.month + 1);
    _selectMonth(date);
  }

  _subtractMonth() {
    DateTime date = DateTime(selectedDate.year, selectedDate.month - 1);
    _selectMonth(date);
  }

  String _getText() {
    switch (listType) {
      case TransactionType.income:
        return "Receita do mês";
      case TransactionType.expense:
        return "Despesas do mês";
      case TransactionType.transaction:
        return "Transações do mês";
    }
  }

  Color _getColor() {
    switch (listType) {
      case TransactionType.income:
        return Colors.green;
      case TransactionType.expense:
        return Colors.red;
      case TransactionType.transaction:
        return _totalTransaction >= 0 ? Colors.green : Colors.red;
    }
  }

  String _formatedDate() {
    String format = "MMMM";
    if (selectedDate.year != DateTime.now().year) {
      format = "MMM yyyy";
    }
    return DateFormat(format).format(selectedDate);
  }

  String _formatDateHeader(DateTime date) {
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    if (date == now) {
      return "Hoje";
    }
    return DateFormat("E, d").format(date);
  }

  List<Widget> _transactionWidget() {
    List<Widget> widgets = [];
    transactions.forEach((key, t) {
      widgets.add(Container(
        padding: const EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        child: Text(
          textAlign: TextAlign.start,
          _formatDateHeader(key),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ));
      widgets.addAll(t
          .map(
            (TransactionAccount transaction) => SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          height: 40,
                          width: 40,
                          color: Colors.blue,
                          padding: const EdgeInsets.all(8),
                          child: Image(
                            image: AssetImage(
                                "assets/categories/${transaction.category!.icon}.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.description,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${transaction.category!.name} | ${transaction.account!.description}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    formatCurrency.format(transaction.amount),
                    style: TextStyle(
                      color:
                          (transaction.type == 1) ? Colors.green : Colors.red,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList());
    });
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
              ButtonAlert(refresh: _getTransactions),
        ),
        child: const Icon(
          FontAwesomeIcons.plus,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: const Color(0xFF4C4C4C),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: (MediaQuery.of(context).size.width * 40) / 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.house,
                          color: Colors.white60,
                        ),
                        Text(
                          "Dashboard",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {},
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.listUl,
                          color: Colors.purple,
                        ),
                        Text(
                          "Transações",
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width * 40) / 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.coins,
                          color: Colors.white60,
                        ),
                        Text(
                          "Orçamentos",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.ellipsis,
                          color: Colors.white60,
                        ),
                        Text(
                          "Mais",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF141414),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: (MediaQuery.of(context).size.height * 17) / 100,
            child: Column(
              children: [
                Header(
                  dropdown: true,
                  selectedValue: listType.toString(),
                  selectValue: _selectValue,
                  hideBack: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _subtractMonth,
                      icon: const FaIcon(
                        FontAwesomeIcons.chevronLeft,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: TextButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => CalendarPicker(
                            onTap: _selectMonth,
                            selectedDate: selectedDate,
                          ),
                        ),
                        child: Text(
                          _formatedDate(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _addMonth,
                      icon: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Box(
            width: 100,
            top: true,
            bottom: false,
            height: (MediaQuery.of(context).size.height * 83) / 100,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 75,
                  padding: const EdgeInsets.only(bottom: 15),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            _getText(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            formatCurrency.format(_totalTransaction),
                            style: TextStyle(
                              color: _getColor(),
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: SingleChildScrollView(
                      child: Column(
                        children: _transactionWidget(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
