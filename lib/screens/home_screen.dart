import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/selection_item.dart';
import 'package:cash_manager/models/transaction_type.dart';
import 'package:cash_manager/screens/account_screen.dart';
import 'package:cash_manager/screens/card_screen.dart';
import 'package:cash_manager/screens/transaction_list_screen.dart';
import 'package:cash_manager/services/database/queries/account_query.dart';
import 'package:cash_manager/services/database/queries/credit_card_query.dart';
import 'package:cash_manager/services/database/queries/transaction_account_query.dart';
import 'package:cash_manager/widgets/balance.dart';
import 'package:cash_manager/widgets/button_alert.dart';
import 'package:cash_manager/widgets/empty_box.dart';
import 'package:cash_manager/widgets/item_box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late List<Account> _accounts = [];
  late List<CreditCard> _cards = [];
  Future<List<String>> _controller = Future.value([]);

  double _accountTotal = 0;
  double _accountIncome = 0;
  double _accountExpenses = 0;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _pullRefresh();
  }

  Future<void> _pullRefresh() async {
    List<Account> freshAccounts = await AccountQuery.selectAccounts();
    List<CreditCard> freshCards = await CreditCardQuery.selectCreditCards();
    double income = await TransactionAccountQuery.getTransactionAmountUpToDate(
        _selectedDate, true);
    double expense = await TransactionAccountQuery.getTransactionAmountUpToDate(
        _selectedDate, false);
    setState(() {
      _controller = Future.value([""]);
      _accounts = freshAccounts;
      _cards = freshCards;
      _accountIncome = income;
      _accountExpenses = expense;
      _accountTotal = income - expense;
    });
  }

  _setDate(DateTime date) {
    _pullRefresh();
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => ButtonAlert(refresh: _pullRefresh),
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
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.house,
                          color: Colors.purple,
                        ),
                        Text(
                          "Dashboard",
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionListScreen(
                            transactionType: TransactionType.income,
                          ),
                        ),
                      );
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.listUl,
                          color: Colors.white60,
                        ),
                        Text(
                          "Transações",
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
      body: FutureBuilder<List<String>>(
        future: _controller,
        builder: (context, snapshot) {
          return RefreshIndicator(
            onRefresh: _pullRefresh,
            child: ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Balance(
                      accountExpenses: _accountExpenses,
                      accountIncome: _accountIncome,
                      accountTotal: _accountTotal,
                      selectedDate: _selectedDate,
                      setDate: _setDate,
                    ),
                    _accounts.isEmpty
                        ? EmptyBox(
                            name: "Contas",
                            icon: FontAwesomeIcons.buildingColumns,
                            emptyText: "Você não tem contas cadastradas",
                            buttonText: "Cadastrar contas",
                            onClick: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccountScreen(
                                  onPop: _pullRefresh,
                                ),
                              ),
                            ),
                          )
                        : ItemBox(
                            name: "Contas",
                            buttonText: "Cadastrar conta",
                            icon: FontAwesomeIcons.buildingColumns,
                            total: _accountTotal,
                            items: SelectionItem.fromAccounts(_accounts),
                            onClick: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccountScreen(
                                  onPop: _pullRefresh,
                                ),
                              ),
                            ),
                          ),
                    _cards.isEmpty
                        ? EmptyBox(
                            name: "Cartões",
                            icon: FontAwesomeIcons.solidCreditCard,
                            emptyText: "Você não tem cartões cadastrados",
                            buttonText: "Cadastrar cartão",
                            onClick: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CardScreen(
                                  onPop: _pullRefresh,
                                ),
                              ),
                            ),
                          )
                        : ItemBox(
                            name: "Cartões",
                            buttonText: "Cadastrar cartão",
                            icon: FontAwesomeIcons.creditCard,
                            items: SelectionItem.fromCreditCards(_cards),
                            onClick: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CardScreen(
                                  onPop: _pullRefresh,
                                ),
                              ),
                            ),
                          ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
