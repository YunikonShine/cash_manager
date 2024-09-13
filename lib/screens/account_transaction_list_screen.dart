import 'dart:collection';

import 'package:cash_manager/models/account_transaction.dart';
import 'package:cash_manager/models/dto/header_dropdown_item.dart';
import 'package:cash_manager/models/enum/transaction_type.dart';
import 'package:cash_manager/services/account_transaction_service.dart';
import 'package:cash_manager/widgets/bottom_bar.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/calendar_picker.dart';
import 'package:cash_manager/widgets/dropdown_header.dart';
import 'package:cash_manager/widgets/floating_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AccountTransactionListScreen extends StatefulWidget {
  const AccountTransactionListScreen({
    super.key,
    required this.transactionType,
  });

  final TransactionType transactionType;

  @override
  AccountTransactionListScreenState createState() =>
      AccountTransactionListScreenState();
}

class AccountTransactionListScreenState
    extends State<AccountTransactionListScreen> {
  late TransactionType _listType;
  DateTime _selectedDate = DateTime.now();

  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");
  double _totalTransaction = 0;

  Map<DateTime, List<AccountTransaction>> _transactions = {};

  @override
  void initState() {
    super.initState();
    setState(() {
      _listType = widget.transactionType;
    });
    _getTransactions();
  }

  Future<void> _getTransactions() async {
    List<AccountTransaction> transactionTemp = [];
    double total = 0;

    switch (_listType) {
      case TransactionType.income:
        transactionTemp =
            await AccountTransactionService.getMonthTransactionsByType(
                _selectedDate, true);
        total = _calcTotal(transactionTemp);
        break;
      case TransactionType.expense:
        transactionTemp =
            await AccountTransactionService.getMonthTransactionsByType(
                _selectedDate, false);
        total = _calcTotal(transactionTemp);
        break;
      case TransactionType.transaction:
        transactionTemp =
            await AccountTransactionService.getMonthTransactions(_selectedDate);
        total = _calcTotal(transactionTemp);
        break;
    }

    SplayTreeMap<DateTime, List<AccountTransaction>> map = SplayTreeMap();

    for (var t in transactionTemp) {
      if (map[t.date] == null) {
        map[t.date] = [t];
      } else {
        map[t.date]!.add(t);
      }
    }

    setState(() {
      _transactions = LinkedHashMap.fromEntries(map.entries.toList().reversed);
      _totalTransaction =
          _listType == TransactionType.expense ? total.abs() : total;
    });
  }

  double _calcTotal(List<AccountTransaction> transactionsTemp) {
    double total = 0;
    for (AccountTransaction item in transactionsTemp) {
      if (item.type) {
        total += item.amount;
      } else {
        total -= item.amount;
      }
    }
    return total;
  }

  _selectValue(String? value) {
    setState(() {
      _listType = TransactionTypeHelper.fromString(value);
    });
    _getTransactions();
  }

  _selectDate(DateTime dateTime) {
    setState(() {
      _selectedDate = dateTime;
    });
    _getTransactions();
    Navigator.pop(context);
  }

  _addMonth() {
    DateTime date = DateTime(_selectedDate.year, _selectedDate.month + 1);
    setState(() {
      _selectedDate = date;
    });
    _getTransactions();
  }

  _subtractMonth() {
    DateTime date = DateTime(_selectedDate.year, _selectedDate.month - 1);
    setState(() {
      _selectedDate = date;
    });
    _getTransactions();
  }

  String _formatedDate() {
    String format = "MMMM";
    if (_selectedDate.year != DateTime.now().year) {
      format = "MMM yyyy";
    }
    return DateFormat(format).format(_selectedDate);
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
    _transactions.forEach((key, item) {
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
      widgets.addAll(item
          .map(
            (AccountTransaction transaction) => SizedBox(
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
                                transaction.category.image.imagePath),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 25),
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
                              "${transaction.category.name} | ${transaction.account.description}",
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
                    _formatCurrency.format(transaction.amount),
                    style: TextStyle(
                      color: transaction.type ? Colors.green : Colors.red,
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

  List<HeaderDropdownItem> _getDropdownItems() {
    return TransactionType.values
        .map((transactionType) => HeaderDropdownItem(
              name: transactionType.name,
              color: transactionType.color,
            ))
        .toList();
  }

  Color _getColor() {
    if (_listType == TransactionType.expense) {
      return Colors.red;
    } else if (_listType == TransactionType.income) {
      return Colors.green;
    }

    if (_totalTransaction >= 0) {
      return Colors.green;
    } else if (_totalTransaction < 0) {
      return Colors.red;
    }

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingMenuButton(
        onPop: _getTransactions,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomBar(
        selectedIndex: 1,
      ),
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownHeader(
              selectedValue: _listType.name,
              selectValue: _selectValue,
              dropdownItems: _getDropdownItems(),
            ),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          selectedDate: _selectedDate,
                          selectDate: _selectDate,
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
            ),
            Expanded(
              child: Box(
                width: 100,
                top: true,
                bottom: false,
                child: Column(
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
                                _listType.name,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                _formatCurrency.format(_totalTransaction),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
