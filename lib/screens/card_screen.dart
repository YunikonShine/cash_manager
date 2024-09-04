import 'package:cash_manager/helpers/hex_color.dart';
import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/selection_item.dart';
import 'package:cash_manager/services/database/queries/account_query.dart';
import 'package:cash_manager/services/database/queries/bank_query.dart';
import 'package:cash_manager/services/database/queries/credit_card_query.dart';
import 'package:cash_manager/widgets/bank_color_picker.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/calculator.dart';
import 'package:cash_manager/widgets/calendar_picker.dart';
import 'package:cash_manager/widgets/custom_toast.dart';
import 'package:cash_manager/widgets/header.dart';
import 'package:cash_manager/widgets/insert_field.dart';
import 'package:cash_manager/widgets/selection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({
    super.key,
    required this.onPop,
  });

  final Function onPop;

  @override
  CardScreenState createState() => CardScreenState();
}

class CardScreenState extends State<CardScreen> {
  double limitTotal = 0;
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");
  final _descriptionController = TextEditingController();

  ImageProvider<Object>? _accountBankIcon;
  String? _accountName;
  int? _accountId;
  int? _cardBrandId;
  String? _cardBrandName;
  IconData? _cardBrandIcon = FontAwesomeIcons.creditCard;
  DateTime? _closeDate;
  DateTime? _dueDate;

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    widget.onPop();
    super.dispose();
  }

  _selectAccount(SelectionItem account) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _accountBankIcon = account.image;
      _accountName = account.name;
      _accountId = account.id;
    });
    Navigator.pop(context);
  }

  _selectCardBrand(SelectionItem cardBrand) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _cardBrandId = cardBrand.id;
      _cardBrandName = cardBrand.name;
      _cardBrandIcon = cardBrand.icon;
    });
    Navigator.pop(context);
  }

  _selectCloseDate(DateTime date) {
    setState(() {
      _closeDate = date;
    });
  }

  _selectDueDate(DateTime date) {
    setState(() {
      _dueDate = date;
    });
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

  _saveAccount() {
    if (_descriptionController.text.isEmpty) {
      _showToast("Preencha a descrição");
    } else if (_accountId == null) {
      _showToast("Selecione uma conta");
    } else if (_cardBrandId == null) {
      _showToast("Selecione o tipo de conta");
    } else if (_closeDate == null) {
      _showToast("Selecione o tipo de conta");
    } else if (_dueDate == null) {
      _showToast("Selecione o tipo de conta");
    } else {
      CreditCard card = CreditCard(
        description: _descriptionController.text,
        limit: limitTotal,
        closeDate: _closeDate!.day,
        dueDate: _dueDate!.day,
        brand: _cardBrandId!,
        accountId: _accountId!,
      );
      CreditCardQuery.createCreditCard(card);
      Navigator.pop(context);
    }
  }

  _setBalance(double balance) {
    setState(() {
      limitTotal = balance;
      Navigator.pop(context);
    });
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
              text: "Novo Cartão de Crédito",
            ),
            GestureDetector(
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => Calculator(
                  balance: limitTotal,
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
                      "Limite",
                      style: TextStyle(
                        color: Color(0xA69E9E9E),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatCurrency.format(limitTotal),
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
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: InsertField(
                          startIcon: FontAwesomeIcons.pen,
                          hint: "Descrição",
                          controller: _descriptionController,
                        ),
                      ),
                      InsertField(
                        startImage: _accountBankIcon,
                        startIcon: _accountBankIcon == null
                            ? FontAwesomeIcons.buildingColumns
                            : null,
                        startText: _accountName ?? "Escolha uma conta",
                        finalIcon: FontAwesomeIcons.chevronRight,
                        onClick: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Selection(
                            onClick: (bank) => _selectAccount(bank),
                            items: AccountQuery.selectSelectionItems(),
                            emptyList: "Crie uma conta para continuar",
                          ),
                        ),
                      ),
                      InsertField(
                        startIcon: _cardBrandIcon,
                        startText: _cardBrandName ?? "Bandeira",
                        finalIcon: FontAwesomeIcons.chevronRight,
                        onClick: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Selection(
                            onClick: (type) => _selectCardBrand(type),
                            items: Future.value(SelectionItem.fromCardBrands()),
                          ),
                        ),
                      ),
                      InsertField(
                        startIcon: FontAwesomeIcons.solidCalendarCheck,
                        startText: "Data de fechamento",
                        finalText: _closeDate != null
                            ? DateFormat('dd').format(_closeDate!)
                            : null,
                        finalIcon: FontAwesomeIcons.chevronRight,
                        onClick: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => CalendarPicker(
                            onTap: _selectCloseDate,
                            month: false,
                          ),
                        ),
                      ),
                      InsertField(
                        startIcon: FontAwesomeIcons.calendarDay,
                        startText: "Data de vencimento",
                        finalText: _dueDate != null
                            ? DateFormat('dd').format(_dueDate!)
                            : null,
                        finalIcon: FontAwesomeIcons.chevronRight,
                        onClick: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => CalendarPicker(
                            onTap: _selectDueDate,
                            month: false,
                          ),
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
                            Colors.blue,
                          ),
                          shape: WidgetStatePropertyAll(
                            CircleBorder(),
                          ),
                        ),
                        onPressed: () => _saveAccount(),
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
