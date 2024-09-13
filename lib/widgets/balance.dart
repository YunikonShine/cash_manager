import 'package:cash_manager/models/enum/transaction_type.dart';
import 'package:cash_manager/screens/account_transaction_list_screen.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/calendar_picker.dart';
import 'package:cash_manager/widgets/icon_filled.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Balance extends StatefulWidget {
  const Balance({
    super.key,
    required this.accountTotal,
    required this.accountIncome,
    required this.accountExpenses,
    required this.selectedDate,
    required this.setDate,
  });

  final double accountTotal;
  final double accountIncome;
  final double accountExpenses;
  final DateTime selectedDate;
  final Function(DateTime date) setDate;

  @override
  BalanceState createState() => BalanceState();
}

class BalanceState extends State<Balance> {
  bool _eyeView = true;
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  _selectMonth(DateTime dateTime) {
    widget.setDate(dateTime);
  }

  _updateViewStyle() {
    setState(() {
      _eyeView = !_eyeView;
    });
  }

  String _formatedDate() {
    String format = "MMMM";
    if (widget.selectedDate.year != DateTime.now().year) {
      format = "MMM yyyy";
    }
    return DateFormat(format).format(widget.selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Box(
      width: 100,
      internalPadding: const EdgeInsets.only(
        left: 25,
        right: 25,
        bottom: 25,
        top: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => CalendarPicker(
                selectDate: _selectMonth,
                selectedDate: widget.selectedDate,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatedDate(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    FontAwesomeIcons.chevronDown,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            "Contas",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
          Text(
            _eyeView
                ? _formatCurrency.format(widget.accountTotal)
                : 'R\$ *****',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          IconButton(
            onPressed: _updateViewStyle,
            icon: Icon(
              _eyeView ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
              color: Colors.white,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountTransactionListScreen(
                        transactionType: TransactionType.income,
                      ),
                    ),
                  ),
                },
                child: Row(
                  children: [
                    const IconFilled(
                      backgroundColor: Colors.white,
                      color: Colors.green,
                      icon: FontAwesomeIcons.circleArrowUp,
                    ),
                    Column(
                      children: [
                        const Text(
                          "Entradas",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          _eyeView
                              ? _formatCurrency.format(widget.accountIncome)
                              : 'R\$ *****',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountTransactionListScreen(
                        transactionType: TransactionType.expense,
                      ),
                    ),
                  ),
                },
                child: Row(
                  children: [
                    const IconFilled(
                      backgroundColor: Colors.white,
                      color: Colors.red,
                      icon: FontAwesomeIcons.circleArrowDown,
                    ),
                    Column(
                      children: [
                        const Text(
                          "Saídas",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          _eyeView
                              ? _formatCurrency.format(widget.accountExpenses)
                              : 'R\$ *****',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
