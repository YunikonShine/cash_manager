import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cash_manager/models/transaction_account.dart';
import 'package:cash_manager/models/selection_item.dart';
import 'package:cash_manager/services/database/queries/account_query.dart';
import 'package:cash_manager/services/database/queries/category_query.dart';
import 'package:cash_manager/services/database/queries/transaction_account_query.dart';
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

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({
    super.key,
    required this.type,
    required this.onPop,
  });

  final bool type;
  final Function onPop;

  @override
  TransactionScreenState createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {
  double accountTotal = 0;
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  DateTime _selectedDate = DateTime.now();

  final _descriptionController = TextEditingController();

  int? _accountId;
  String? _accountName;
  ImageProvider<Object>? _accountBankIcon;

  int? _categoryId;
  ImageProvider<Object>? _categoryImage;
  String? _categoryName = "Categoria";

  late Future<List<SelectionItem>> _accounts;

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
    _accounts = AccountQuery.selectSelectionItems();
    List<SelectionItem> accounts = await _accounts;
    if (accounts.isNotEmpty) {
      setState(() {
        _accountBankIcon = accounts[0].image;
        _accountName = accounts[0].name;
        _accountId = accounts[0].id;
      });
    }
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

  _saveTransaction() {
    if (_accountId == null) {
      _showToast("Selecione o banco");
    } else if (_descriptionController.text.isEmpty) {
      _showToast("Preencha a descrição");
    } else if (_categoryId == null) {
      _showToast("Selecione a categoria");
    } else {
      TransactionAccount transactionAccount = TransactionAccount(
        description: _descriptionController.text.trim(),
        amount: accountTotal,
        type: widget.type ? 1 : 0,
        categoryId: _categoryId!,
        accountId: _accountId!,
        date: _selectedDate,
      );
      TransactionAccountQuery.createTransaction(transactionAccount);
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
            Header(
              text: widget.type ? "Nova Receita" : "Nova Despesa",
            ),
            GestureDetector(
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => Calculator(
                  balance: accountTotal,
                  onClick: _setBalance,
                  type: widget.type,
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
                            items: _accounts,
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
                            items:
                                CategoryQuery.selectSelectionItems(widget.type),
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
                        style: ButtonStyle(
                          fixedSize: const WidgetStatePropertyAll(
                            Size(65, 65),
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                            widget.type ? Colors.green : Colors.red,
                          ),
                          shape: const WidgetStatePropertyAll(
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
