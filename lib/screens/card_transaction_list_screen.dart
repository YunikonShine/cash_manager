import 'dart:collection';

import 'package:cash_manager/models/card_transaction.dart';
import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/dto/header_dropdown_item.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/services/card_transaction_service.dart';
import 'package:cash_manager/services/credit_card_service.dart';
import 'package:cash_manager/services/invoice_service.dart';
import 'package:cash_manager/widgets/bottom_bar.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/calendar_picker.dart';
import 'package:cash_manager/widgets/card_box_header.dart';
import 'package:cash_manager/widgets/dropdown_header.dart';
import 'package:cash_manager/widgets/floating_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CardTransactionListScreen extends StatefulWidget {
  const CardTransactionListScreen({
    super.key,
    required this.selectedCard,
    required this.selectedInvoice,
  });

  final CreditCard selectedCard;
  final Invoice selectedInvoice;

  @override
  CardTransactionListScreenState createState() =>
      CardTransactionListScreenState();
}

class CardTransactionListScreenState extends State<CardTransactionListScreen> {
  late CreditCard _selectedCard;
  late List<CreditCard> _cards = [];
  late Invoice _selectedInvoice;

  DateTime _selectedDate = DateTime.now();

  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  Map<DateTime, List<CardTransaction>> _transactions = {};

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedCard = widget.selectedCard;
      _selectedInvoice = widget.selectedInvoice;
    });
    _getCards();
    _getTransactions();
  }

  _getCards() async {
    List<CreditCard> tempCards = await CreditCardService.findAll();
    setState(() {
      _cards = tempCards;
    });
  }

  _selectValue(String? item) async {
    for (CreditCard card in _cards) {
      if (card.description == item) {
        setState(() {
          _selectedCard = card;
        });
      }
    }
    await _setInvoice();
  }

  Future<void> _getTransactions() async {
    List<CardTransaction> transactionTemp =
        await CardTransactionService.getTransactionsByInvoice(_selectedInvoice);

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
    });
  }

  DateTime _getDateToInvoice() {
    return DateTime(
        _selectedDate.year, _selectedDate.month, _selectedCard.closeDay);
  }

  _setInvoice() async {
    Invoice tempInvoice = await InvoiceService.findByCreditCardAndDate(
        _selectedCard, _getDateToInvoice());
    setState(() {
      _selectedInvoice = tempInvoice;
    });
    _getTransactions();
  }

  _selectDate(DateTime dateTime) {
    setState(() {
      _selectedDate = dateTime;
    });
    _setInvoice();
    Navigator.pop(context);
  }

  _addMonth() {
    DateTime date = DateTime(_selectedDate.year, _selectedDate.month + 1);
    setState(() {
      _selectedDate = date;
    });
    _setInvoice();
  }

  _subtractMonth() {
    DateTime date = DateTime(_selectedDate.year, _selectedDate.month - 1);
    setState(() {
      _selectedDate = date;
    });
    _setInvoice();
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
                                transaction.category.image.imagePath),
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
                              transaction.category.name,
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

  List<HeaderDropdownItem> _getDropdownItems() {
    return _cards
        .map((card) => HeaderDropdownItem(
              name: card.description,
              color: Colors.white,
            ))
        .toList();
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
              selectedValue: _selectedCard.description,
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
                    CardBoxHeader(
                      selectedCard: _selectedCard,
                      selectedInvoice: _selectedInvoice,
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
