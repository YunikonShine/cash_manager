import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/card_brand.dart';
import 'package:cash_manager/models/dto/credit_card_dto.dart';
import 'package:cash_manager/models/dto/select_image_item.dart';
import 'package:cash_manager/services/account_service.dart';
import 'package:cash_manager/services/card_brand_service.dart';
import 'package:cash_manager/services/credit_card_service.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/calculator.dart';
import 'package:cash_manager/widgets/custom_toast.dart';
import 'package:cash_manager/widgets/header.dart';
import 'package:cash_manager/widgets/insert_date_field.dart';
import 'package:cash_manager/widgets/insert_select_image_field.dart';
import 'package:cash_manager/widgets/insert_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CreditCardScreen extends StatefulWidget {
  const CreditCardScreen({
    super.key,
    required this.onPop,
  });

  final Function onPop;

  @override
  CreditCardScreenState createState() => CreditCardScreenState();
}

class CreditCardScreenState extends State<CreditCardScreen> {
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  double _cardLimit = 0;
  Account? _selectedAccount;
  List<Account> _accounts = List.empty();
  final _descriptionController = TextEditingController();
  CardBrand? _selectedCardBrand;
  List<CardBrand> _cardBrands = List.empty();
  DateTime? _closeDate;
  DateTime? _dueDate;

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
    List<Account> tempAccounts = await AccountService.findAll();
    List<CardBrand> tempBrands = await CardBrandService.findAll();
    setState(() {
      _accounts = tempAccounts;
      _cardBrands = tempBrands;
    });
  }

  List<SelectImageItem> _convertAccountsToSelect() {
    return _accounts
        .map((account) => SelectImageItem(
              id: account.id,
              image: account.bank.image,
              text: account.description,
              object: account,
            ))
        .toList();
  }

  List<SelectImageItem> _convertCardBrandsToSelect() {
    return _cardBrands
        .map((cardBrand) => SelectImageItem(
              id: cardBrand.id,
              image: cardBrand.image,
              text: cardBrand.name,
              object: cardBrand,
            ))
        .toList();
  }

  _setCardLimit(double balance) {
    setState(() {
      _cardLimit = balance;
    });
    Navigator.pop(context);
  }

  _selectAccount(dynamic account) {
    setState(() {
      _selectedAccount = account;
    });
    Navigator.pop(context);
  }

  _selectCardBrand(dynamic cardBrad) {
    setState(() {
      _selectedCardBrand = cardBrad;
    });
    Navigator.pop(context);
  }

  _selectCloseDate(DateTime date) {
    setState(() {
      _closeDate = date;
    });
    Navigator.pop(context);
  }

  _selectDueDate(DateTime date) {
    setState(() {
      _dueDate = date;
    });
    Navigator.pop(context);
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

  _saveCreditCard() {
    if (_cardLimit == 0) {
      _showToast("Selecione o limite do cartão");
    } else if (_descriptionController.text.isEmpty) {
      _showToast("Preencha a descrição");
    } else if (_selectedAccount == null) {
      _showToast("Selecione uma conta");
    } else if (_selectedCardBrand == null) {
      _showToast("Selecione o tipo de conta");
    } else if (_closeDate == null) {
      _showToast("Selecione a melhor data para compra");
    } else if (_dueDate == null) {
      _showToast("Selecione a data de vencimento");
    } else {
      CreditCardDTO card = CreditCardDTO(
        description: _descriptionController.text,
        limit: _cardLimit,
        closeDay: _closeDate!.day,
        dueDay: _dueDate!.day,
        brandId: _selectedCardBrand!.id,
        accountId: _selectedAccount!.id,
      );
      CreditCardService.createCreditCard(card);
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
              text: "Novo Cartão",
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Calculator(
                    balance: _cardLimit,
                    onClick: _setCardLimit,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.only(
                  left: 25,
                ),
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Limite do cartão",
                      style: TextStyle(
                        color: Color(0xA69E9E9E),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatCurrency.format(_cardLimit),
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
                        InsertTextField(
                          icon: FontAwesomeIcons.pen,
                          hint: "Descrição",
                          controller: _descriptionController,
                        ),
                        InsertSelectImageField(
                          defaultIcon: FontAwesomeIcons.buildingColumns,
                          hint: _selectedAccount?.description ??
                              "Escolha uma conta",
                          image: _selectedAccount?.bank.image,
                          itemList: _convertAccountsToSelect(),
                          onClick: _selectAccount,
                        ),
                        InsertSelectImageField(
                          defaultIcon: FontAwesomeIcons.creditCard,
                          hint: _selectedCardBrand?.name ?? "Bandeira",
                          image: _selectedCardBrand?.image,
                          itemList: _convertCardBrandsToSelect(),
                          onClick: _selectCardBrand,
                        ),
                        InsertDateField(
                          icon: FontAwesomeIcons.calendarCheck,
                          hint: "Melhor data para compra",
                          date: _closeDate,
                          format: "dd",
                          selectDate: _selectCloseDate,
                        ),
                        InsertDateField(
                          icon: FontAwesomeIcons.calendarDay,
                          hint: "Melhor data de vencimento",
                          date: _dueDate,
                          format: "dd",
                          selectDate: _selectDueDate,
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
                          onPressed: () => _saveCreditCard(),
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
