import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/calendar_picker.dart';
import 'package:cash_manager/widgets/icon_filled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool _eyeView = true;
  double accountTotal = 15500.20;
  double accountIncome = 15500.20;
  double accountExpenses = 15500.20;
  final formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  _updateViewStyle() {
    setState(() {
      _eyeView = !_eyeView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Box(
            width: 100,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(0),
                  child: TextButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => CalendarPicker(),
                    ),
                    child: const Text('Show Dialog'),
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
                    _eyeView ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
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
                          icon: CupertinoIcons.arrow_up_circle_fill,
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
                          icon: CupertinoIcons.arrow_down_circle_fill,
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
          ),
        ],
      ),
    );
  }
}
