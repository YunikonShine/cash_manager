import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/calendar_picker.dart';
import 'package:cash_manager/widgets/icon_filled.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Balance extends StatefulWidget {
  const Balance({super.key});

  @override
  BalanceState createState() => BalanceState();
}

class BalanceState extends State<Balance> {
  bool _eyeView = true;
  double accountTotal = 15500.20;
  double accountIncome = 15500.20;
  double accountExpenses = 15500.20;
  final formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");
  int _selectedMonth = DateTime.now().month;

  _selectMonth(int i) {
    setState(() {
      _selectedMonth = i;
    });
    Navigator.pop(context);
  }

  _updateViewStyle() {
    setState(() {
      _eyeView = !_eyeView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Box(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => CalendarPicker(
                onTap: _selectMonth,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('MMMM').format(
                    DateTime(0, _selectedMonth),
                  ),
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
            _eyeView ? formatCurrency.format(accountTotal) : 'R\$ *****',
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
              Row(
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
                            ? formatCurrency.format(accountIncome)
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
              Row(
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
                            ? formatCurrency.format(accountExpenses)
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
            ],
          )
        ],
      ),
    );
  }
}
