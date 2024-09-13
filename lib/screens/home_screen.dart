import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/account_transaction.dart';
import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/services/account_service.dart';
import 'package:cash_manager/services/account_transaction_service.dart';
import 'package:cash_manager/services/credit_card_service.dart';
import 'package:cash_manager/services/invoice_service.dart';
import 'package:cash_manager/widgets/account_item_box.dart';
import 'package:cash_manager/widgets/balance.dart';
import 'package:cash_manager/widgets/bottom_bar.dart';
import 'package:cash_manager/widgets/floating_menu_button.dart';
import 'package:cash_manager/widgets/card_item_box.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Future<List<String>> _controller = Future.value([]);

  List<Account> _accounts = [];
  Map<CreditCard, Invoice> _cards = {};

  double _accountTotal = 0;
  double _accountIncome = 0;
  double _accountExpenses = 0;
  DateTime _selectedDate = DateTime.now();

  bool _invoiceType = true;

  @override
  void initState() {
    super.initState();
    _pullRefresh();
  }

  Future<void> _pullRefresh() async {
    List<Account> freshAccounts = await AccountService.findAll();
    List<CreditCard> freshCards = await CreditCardService.findAll();

    Map<CreditCard, Invoice> cardInvoice = {};
    for (CreditCard creditCard in freshCards) {
      Invoice invoice = await InvoiceService.findByCreditCardAndDate(
          creditCard, _getDateByInvoiceType());
      cardInvoice[creditCard] = invoice;
    }

    double income = await _getIncome(_selectedDate);
    double expense = await _getExpense(_selectedDate);

    setState(() {
      _controller = Future.value([""]);
      _accounts = freshAccounts;
      _cards = cardInvoice;
      _accountIncome = income;
      _accountExpenses = expense;
      _accountTotal = 0;
    });
  }

  DateTime _getDateByInvoiceType() {
    DateTime now = DateTime.now();
    if (_invoiceType) {
      return now;
    } else {
      return DateTime(now.year, now.month - 1, now.day);
    }
  }

  Future<double> _getIncome(DateTime date) async {
    List<AccountTransaction> monthTransactions =
        await AccountTransactionService.getMonthTransactionsByType(
            _selectedDate, true);
    if (monthTransactions.isEmpty) return 0;

    return monthTransactions
        .map((e) => e.amount)
        .reduce((value1, value2) => value1 + value2);
  }

  Future<double> _getExpense(DateTime date) async {
    List<AccountTransaction> monthTransactions =
        await AccountTransactionService.getMonthTransactionsByType(
            _selectedDate, false);
    if (monthTransactions.isEmpty) return 0;

    return monthTransactions
        .map((e) => e.amount)
        .reduce((value1, value2) => value1 + value2);
  }

  _setDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    Navigator.pop(context);
    _pullRefresh();
  }

  _selectInvoiceMonth(bool type) async {
    setState(() {
      _invoiceType = type;
    });
    await _pullRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingMenuButton(
        onPop: _pullRefresh,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomBar(
        selectedIndex: 0,
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
                    AccountItemBox(
                      accounts: _accounts,
                      onPop: _pullRefresh,
                    ),
                    CardItemBox(
                      invoiceType: _invoiceType,
                      cards: _cards,
                      selectType: _selectInvoiceMonth,
                      onPop: _pullRefresh,
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
