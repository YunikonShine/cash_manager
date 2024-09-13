import 'package:cash_manager/models/enum/transaction_type.dart';
import 'package:cash_manager/screens/account_transaction_list_screen.dart';
import 'package:cash_manager/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required this.selectedIndex,
  });

  final int selectedIndex;

  Color _getColor(int index) {
    return index == selectedIndex ? Colors.purple : Colors.white60;
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
                    if (selectedIndex != 0) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.house,
                        color: _getColor(0),
                      ),
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          color: _getColor(0),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (selectedIndex != 1) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AccountTransactionListScreen(
                            transactionType: TransactionType.income,
                          ),
                        ),
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.listUl,
                        color: _getColor(1),
                      ),
                      Text(
                        "Transações",
                        style: TextStyle(
                          color: _getColor(1),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.coins,
                        color: _getColor(2),
                      ),
                      Text(
                        "Orçamentos",
                        style: TextStyle(
                          color: _getColor(2),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.ellipsis,
                        color: _getColor(3),
                      ),
                      Text(
                        "Mais",
                        style: TextStyle(
                          color: _getColor(3),
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
    );
  }
}
