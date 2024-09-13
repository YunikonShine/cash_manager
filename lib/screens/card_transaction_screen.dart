import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/dto/card_transaction_dto.dart';
import 'package:cash_manager/models/dto/select_image_item.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/models/transaction_category.dart';
import 'package:cash_manager/services/card_transaction_service.dart';
import 'package:cash_manager/services/credit_card_service.dart';
import 'package:cash_manager/services/invoice_service.dart';
import 'package:cash_manager/services/transaction_category_service.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/calculator.dart';
import 'package:cash_manager/widgets/custom_toast.dart';
import 'package:cash_manager/widgets/header.dart';
import 'package:cash_manager/widgets/insert_field.dart';
import 'package:cash_manager/widgets/insert_select_image_field.dart';
import 'package:cash_manager/widgets/insert_slide_field.dart';
import 'package:cash_manager/widgets/insert_text_field.dart';
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
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  double _transactionAmount = 0;
  DateTime _selectedDate = DateTime.now();
  final _descriptionController = TextEditingController();
  CreditCard? _selectedCard;
  List<CreditCard> _cards = [];
  TransactionCategory? _selectedCategory;
  List<TransactionCategory> _categories = [];
  bool _reccurence = false;

  late FToast _fToast;

  @override
  void initState() {
    super.initState();
    _initData();
    _fToast = FToast();
    _fToast.init(context);
  }

  @override
  void dispose() {
    widget.onPop();
    super.dispose();
  }

  _initData() async {
    List<CreditCard> tempCards = await CreditCardService.findAll();
    List<TransactionCategory> tempCategories =
        await TransactionCategoryService.findByType(false);
    setState(() {
      _cards = tempCards;
      _categories = tempCategories;
    });
  }

  List<SelectImageItem> _convertCardsToSelect() {
    return _cards
        .map((card) => SelectImageItem(
              id: card.id,
              image: card.brand.image,
              text: card.description,
              object: card,
            ))
        .toList();
  }

  List<SelectImageItem> _convertCategoriesToSelect() {
    return _categories
        .map((category) => SelectImageItem(
              id: category.id,
              image: category.image,
              text: category.name,
              object: category,
            ))
        .toList();
  }

  _setTransactionAmount(double balance) {
    setState(() {
      _transactionAmount = balance;
    });
    Navigator.pop(context);
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

  _selectCard(dynamic card) {
    setState(() {
      _selectedCard = card;
    });
    Navigator.pop(context);
  }

  _selectCategory(dynamic category) {
    setState(() {
      _selectedCategory = category;
    });
    Navigator.pop(context);
  }

  _setReccurence(bool reccurence) {
    setState(() {
      _reccurence = reccurence;
    });
  }

  _showToast(String message) {
    FocusScope.of(context).requestFocus(FocusNode());
    _fToast.showToast(
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

  _saveTransaction() async {
    if (_transactionAmount == 0) {
      _showToast("Selecione o valor da transação");
    } else if (_descriptionController.text.isEmpty) {
      _showToast("Preencha a descrição");
    } else if (_selectedCard == null) {
      _showToast("Selecione o cartão");
    } else if (_selectedCategory == null) {
      _showToast("Selecione a categoria");
    } else {
      Invoice invoice = await InvoiceService.findByCreditCardAndDate(
          _selectedCard!, _selectedDate);
      CardTransactionDTO cardTransaction = CardTransactionDTO(
        description: _descriptionController.text.trim(),
        date: _selectedDate,
        amount: _transactionAmount,
        categoryId: _selectedCategory!.id,
        invoiceId: invoice.id,
        recurrence: _reccurence,
      );
      CardTransactionService.createTransaction(cardTransaction);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Header(
              text: "Nova transação",
            ),
            GestureDetector(
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => Calculator(
                  balance: _transactionAmount,
                  onClick: _setTransactionAmount,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 25,
                ),
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Valor da transação",
                      style: TextStyle(
                        color: Color(0xA69E9E9E),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatCurrency.format(_transactionAmount),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Box(
                    width: 100,
                    bottom: false,
                    top: true,
                    child: Column(
                      children: [
                        InsertField(
                          icon: FontAwesomeIcons.calendarCheck,
                          hint: DateFormat("dd MMM yyyy").format(_selectedDate),
                          onClick: _selectDate,
                        ),
                        InsertTextField(
                          icon: FontAwesomeIcons.pen,
                          hint: "Descrição",
                          controller: _descriptionController,
                        ),
                        InsertSelectImageField(
                          defaultIcon: FontAwesomeIcons.buildingColumns,
                          hint:
                              _selectedCard?.description ?? "Escolha um cartão",
                          image: _selectedCard?.brand.image,
                          itemList: _convertCardsToSelect(),
                          onClick: _selectCard,
                        ),
                        InsertSelectImageField(
                          defaultIcon: FontAwesomeIcons.list,
                          hint: _selectedCategory?.name ??
                              "Escolha uma categoria",
                          image: _selectedCategory?.image,
                          itemList: _convertCategoriesToSelect(),
                          onClick: _selectCategory,
                        ),
                        InsertSlideField(
                          icon: FontAwesomeIcons.receipt,
                          hint: "Criar recorrência",
                          value: _reccurence,
                          onClick: _setReccurence,
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    bottom: 50,
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
                              Colors.blue,
                            ),
                            shape: WidgetStatePropertyAll(
                              CircleBorder(),
                            ),
                          ),
                          onPressed: () => _saveTransaction(),
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
            ),
          ],
        ),
      ),
    );
  }
}
