import 'dart:collection';

import 'package:cash_manager/models/card_brand.dart';
import 'package:cash_manager/models/card_transaction.dart';
import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/enum/invoice_status.dart';
import 'package:cash_manager/models/header_dropdown_item.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/models/transaction_account.dart';
import 'package:cash_manager/screens/home_screen.dart';
import 'package:cash_manager/services/database/queries/card_transaction_query.dart';
import 'package:cash_manager/services/database/queries/invoice_query.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/button_alert.dart';
import 'package:cash_manager/widgets/calendar_picker.dart';
import 'package:cash_manager/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CardTransactionListScreen extends StatefulWidget {
  const CardTransactionListScreen({
    super.key,
    required this.selectedItem,
    required this.creditCards,
  });

  final String selectedItem;
  final List<CreditCard> creditCards;

  @override
  CardTransactionListScreenState createState() =>
      CardTransactionListScreenState();
}

class CardTransactionListScreenState extends State<CardTransactionListScreen> {
  DateTime _selectedDate = DateTime.now();
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  Map<DateTime, List<CardTransaction>> _transactions = {};

  late List<HeaderDropdownItem>? _headerItems;
  late String _selectedItem;
  late CreditCard _selectedCard;
  late Invoice _selectedInvoice;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
    _headerItems = widget.creditCards
        .map((e) =>
            HeaderDropdownItem(name: e.description, color: Colors.transparent))
        .toList();
    _setSelectedCard(_selectedItem);
    _selectedInvoice = _selectedCard.currentInvoice!;
    _getTransactions();
  }

  _setSelectedCard(String item) {
    for (CreditCard card in widget.creditCards) {
      if (card.description == item) {
        setState(() {
          _selectedCard = card;
        });
      }
    }
  }

  Future<void> _getTransactions() async {
    List<CardTransaction> transactionTemp = [];
    Invoice tempInvoice =
        await InvoiceQuery.getByCardAndDate(_selectedCard, _selectedDate);
    if (tempInvoice.id != null) {
      transactionTemp =
          await CardTransactionQuery.getTransactionByInvoice(tempInvoice.id!);
    }

    SplayTreeMap<DateTime, List<CardTransaction>> map = SplayTreeMap();

    for (var t in transactionTemp) {
      if (map[t.date] == null) {
        map[t.date] = [t];
      } else {
        map[t.date]!.add(t);
      }
    }

    setState(() {
      _transactions = LinkedHashMap.fromEntries(map.entries.toList().reversed);
      _selectedInvoice = tempInvoice;
    });
  }

  _selectValue(String? value) {
    _getTransactions();
  }

  _selectMonth(DateTime dateTime) {
    setState(() {
      _selectedDate = dateTime;
    });
    _getTransactions();
  }

  _addMonth() {
    DateTime date = DateTime(
        _selectedDate.year, _selectedDate.month + 1, _selectedCard.closeDate);
    _selectMonth(date);
  }

  _subtractMonth() {
    DateTime date = DateTime(
        _selectedDate.year, _selectedDate.month - 1, _selectedCard.closeDate);
    _selectMonth(date);
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
    _transactions.forEach((key, t) {
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
            (CardTransaction transaction) => SizedBox(
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
                              "${transaction.category!.name} | ${transaction.description}",
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
                    style: const TextStyle(
                      color: Colors.white,
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
                  selectedValue: _selectedItem,
                  selectValue: _selectValue,
                  hideBack: true,
                  dropdownItems: _headerItems ?? [],
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
                            selectedDate: _selectedDate,
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
                  padding: const EdgeInsets.only(bottom: 15),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image(
                            alignment: Alignment.center,
                            width: 75,
                            height: 50,
                            image: AssetImage(
                                "assets/card_brands/${CardBrandHelper.fromId(_selectedCard.brand).image}.png"),
                            fit: BoxFit.cover,
                          ),
                          Text(
                            _selectedCard.description,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 130,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 30,
                                      child: FaIcon(
                                        FontAwesomeIcons.calendarWeek,
                                        color: Colors.grey,
                                        size: 28,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Fechamento",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            DateFormat("dd/MMM").format(
                                                _selectedInvoice.closeDate),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 30,
                                      child: FaIcon(
                                        FontAwesomeIcons.receipt,
                                        color: Colors.grey,
                                        size: 28,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Status",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            _selectedInvoice.status.description,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 30,
                                      child: FaIcon(
                                        FontAwesomeIcons.calendarCheck,
                                        color: Colors.grey,
                                        size: 28,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Vencimento",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            DateFormat("dd/MMM").format(
                                                _selectedInvoice.dueDate),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 30,
                                      child: FaIcon(
                                        FontAwesomeIcons.moneyBill,
                                        color: Colors.grey,
                                        size: 28,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Valor",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            _formatCurrency.format(
                                                _selectedInvoice.amount),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
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
