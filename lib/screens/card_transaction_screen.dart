import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cash_manager/models/card_transaction.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/models/selection_item.dart';
import 'package:cash_manager/services/database/queries/card_transaction_query.dart';
import 'package:cash_manager/services/database/queries/category_query.dart';
import 'package:cash_manager/services/database/queries/credit_card_query.dart';
import 'package:cash_manager/services/database/queries/invoice_query.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/calculator.dart';
import 'package:cash_manager/widgets/custom_toast.dart';
import 'package:cash_manager/widgets/header.dart';
import 'package:cash_manager/widgets/insert_field.dart';
import 'package:cash_manager/widgets/selection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CardTransactionScreen extends StatefulWidget {
  const CardTransactionScreen({
    super.key,
    required this.onPop,
  });

  final Function onPop;

  @override
  CardTransactionScreenState createState() => CardTransactionScreenState();
}

class CardTransactionScreenState extends State<CardTransactionScreen> {
  double accountTotal = 0;
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  DateTime _selectedDate = DateTime.now();

  final _descriptionController = TextEditingController();

  int? _cardId;
  String? _cardName;
  ImageProvider<Object>? _cardBankIcon;

  int? _categoryId;
  ImageProvider<Object>? _categoryImage;
  String? _categoryName = "Categoria";

  var _reccurence = false;

  late Future<List<SelectionItem>> _cards;

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    _getAccounts();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    widget.onPop();
    super.dispose();
  }

  _getAccounts() async {
    _cards = CreditCardQuery.selectSelectionItems();
    List<SelectionItem> cards = await _cards;
    if (cards.isNotEmpty) {
      setState(() {
        _cardBankIcon = cards[0].image;
        _cardName = cards[0].name;
        _cardId = cards[0].id;
      });
    }
  }

  _selectAccount(SelectionItem card) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _cardBankIcon = card.image;
      _cardName = card.name;
      _cardId = card.id;
    });
    Navigator.pop(context);
  }

  _setBalance(double balance) {
    setState(() {
      accountTotal = balance;
      Navigator.pop(context);
    });
  }

  _selectDate() async {
    List<DateTime?>? results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(),
      dialogSize: const Size(325, 400),
      value: [_selectedDate],
      borderRadius: BorderRadius.circular(15),
    );
    if (results != null) {
      setState(() {
        _selectedDate = results[0]!;
      });
    }
  }

  _selectCategory(SelectionItem accountType) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _categoryId = accountType.id;
      _categoryImage = accountType.image;
      _categoryName = accountType.name;
    });
    Navigator.pop(context);
  }

  _showToast(String message) {
    FocusScope.of(context).requestFocus(FocusNode());
    fToast.showToast(
      child: CustomToast(
        message: message,
      ),
      toastDuration: const Duration(seconds: 2),
      positionedToastBuilder: (context, child) {
        return Positioned(
          bottom: 130.0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                child,
              ],
            ),
          ),
        );
      },
    );
  }

  _setReccurence(bool recurrence) {
    setState(() {
      _reccurence = recurrence;
    });
  }

  _saveTransaction() async {
    if (_cardId == null) {
      _showToast("Selecione o cartão");
    } else if (_descriptionController.text.isEmpty) {
      _showToast("Preencha a descrição");
    } else if (_categoryId == null) {
      _showToast("Selecione a categoria");
    } else {
      Invoice invoice =
          await InvoiceQuery.getByCardIdAndDate(_cardId!, _selectedDate);
      CardTransaction cardTransaction = CardTransaction(
        description: _descriptionController.text.trim(),
        amount: accountTotal,
        categoryId: _categoryId!,
        recurrence: _reccurence,
        invoice: invoice,
        date: DateTime(
            _selectedDate.year, _selectedDate.month, _selectedDate.day),
      );
      CardTransactionQuery.createTransaction(cardTransaction);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(
              text: "Nova Transação",
            ),
            GestureDetector(
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => Calculator(
                  balance: accountTotal,
                  onClick: _setBalance,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 25,
                ),
                height: (MediaQuery.of(context).size.height * 10) / 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Valor total",
                      style: TextStyle(
                        color: Color(0xA69E9E9E),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatCurrency.format(accountTotal),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                Box(
                  width: 100,
                  height: (MediaQuery.of(context).size.height * 80) / 100,
                  bottom: false,
                  top: true,
                  child: Column(
                    children: [
                      InsertField(
                        startIcon: FontAwesomeIcons.calendarCheck,
                        startText:
                            DateFormat("dd MMM yyyy").format(_selectedDate),
                        finalIcon: FontAwesomeIcons.chevronRight,
                        onClick: _selectDate,
                      ),
                      InsertField(
                        startIcon: FontAwesomeIcons.pen,
                        hint: "Descrição",
                        controller: _descriptionController,
                      ),
                      InsertField(
                        startImage: _cardBankIcon,
                        startIcon: _cardBankIcon == null
                            ? FontAwesomeIcons.buildingColumns
                            : null,
                        startText: _cardName ?? "Escolha uma conta",
                        finalIcon: FontAwesomeIcons.chevronRight,
                        onClick: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Selection(
                            onClick: (bank) => _selectAccount(bank),
                            items: _cards,
                            emptyList: "Crie uma conta para continuar",
                          ),
                        ),
                      ),
                      InsertField(
                        startImageIcon: _categoryImage,
                        startIcon: _categoryImage == null
                            ? FontAwesomeIcons.buildingColumns
                            : null,
                        startText: _categoryName ?? "Categoria",
                        finalIcon: FontAwesomeIcons.chevronRight,
                        onClick: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Selection(
                            onClick: (type) => _selectCategory(type),
                            items: CategoryQuery.selectSelectionItems(false),
                          ),
                        ),
                      ),
                      InsertField(
                        startIcon: FontAwesomeIcons.calendarDay,
                        startText: "Transação recorrente",
                        finalIcon: FontAwesomeIcons.chevronRight,
                        finalWidget: CustomAnimatedToggleSwitch<bool>(
                          current: _reccurence,
                          values: const [false, true],
                          spacing: 0.0,
                          indicatorSize: const Size.square(22.0),
                          animationDuration: const Duration(milliseconds: 200),
                          animationCurve: Curves.linear,
                          onChanged: _setReccurence,
                          iconBuilder: (context, local, global) {
                            return const SizedBox();
                          },
                          onTap: (_) => _setReccurence(!_reccurence),
                          wrapperBuilder: (context, global, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: 10.0,
                                  right: 10.0,
                                  height: 20.0,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.lerp(
                                        Colors.red,
                                        Colors.green,
                                        global.position,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50.0)),
                                    ),
                                  ),
                                ),
                                child,
                              ],
                            );
                          },
                          foregroundIndicatorBuilder: (context, global) {
                            return SizedBox.fromSize(
                              size: global.indicatorSize,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color.lerp(
                                    Colors.white,
                                    Colors.white,
                                    global.position,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                ),
                                child: _reccurence
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: FaIcon(
                                            FontAwesomeIcons.check,
                                            color: Colors.green,
                                            size: 16,
                                          ),
                                        ),
                                      )
                                    : const Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: FaIcon(
                                            FontAwesomeIcons.xmark,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 50,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.3,
                            ),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(
                              0,
                              0,
                            ),
                          ),
                        ],
                      ),
                      child: IconButton(
                        style: const ButtonStyle(
                          fixedSize: WidgetStatePropertyAll(
                            Size(65, 65),
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.purple,
                          ),
                          shape: WidgetStatePropertyAll(
                            CircleBorder(),
                          ),
                        ),
                        onPressed: _saveTransaction,
                        icon: const Icon(
                          FontAwesomeIcons.check,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
