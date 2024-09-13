import 'package:cash_manager/helpers/hex_color.dart';
import 'package:cash_manager/models/bank.dart';
import 'package:cash_manager/models/dto/account_dto.dart';
import 'package:cash_manager/models/dto/select_icon_item.dart';
import 'package:cash_manager/models/dto/select_image_item.dart';
import 'package:cash_manager/models/enum/account_type.dart';
import 'package:cash_manager/models/enum/calculator_type.dart';
import 'package:cash_manager/services/account_service.dart';
import 'package:cash_manager/services/bank_service.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/calculator.dart';
import 'package:cash_manager/widgets/custom_toast.dart';
import 'package:cash_manager/widgets/header.dart';
import 'package:cash_manager/widgets/insert_color_field.dart';
import 'package:cash_manager/widgets/insert_select_icon_field.dart';
import 'package:cash_manager/widgets/insert_select_image_field.dart';
import 'package:cash_manager/widgets/insert_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
    required this.onPop,
  });

  final Function onPop;

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");
  late FToast _fToast;

  double _accountTotal = 0;

  Bank? _selectedBank;
  List<Bank> _banks = List.empty();

  final _descriptionController = TextEditingController();

  AccountType? _selectedAccountType;

  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _fToast = FToast();
    _fToast.init(context);
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    widget.onPop();
  }

  _initData() async {
    List<Bank> banksTemp = await BankService.findAll();
    setState(() {
      _banks = banksTemp;
    });
  }

  List<SelectImageItem> _convertBanksToSelect() {
    return _banks
        .map((bank) => SelectImageItem(
              id: bank.id,
              image: bank.image,
              text: bank.name,
              object: bank,
            ))
        .toList();
  }

  List<SelectIconItem> _convertAccountTypeToSelect() {
    return AccountType.values
        .map((accountType) => SelectIconItem(
              id: accountType.id,
              icon: accountType.icon,
              text: accountType.name,
              object: accountType,
            ))
        .toList();
  }

  _setBalance(double balance) {
    setState(() {
      _accountTotal = balance;
    });
    Navigator.pop(context);
  }

  _selectBank(dynamic bank) {
    setState(() {
      _selectedBank = bank;
      _selectedColor = HexColor.fromHex(_selectedBank!.color);
    });
    Navigator.pop(context);
  }

  _selectAccountType(dynamic accountType) {
    setState(() {
      _selectedAccountType = accountType;
    });
    Navigator.pop(context);
  }

  _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
    Navigator.pop(context);
  }

  _showToast(String message) {
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

  _saveAccount() {
    if (_selectedBank == null) {
      _showToast("Selecione o banco");
    } else if (_descriptionController.text.isEmpty) {
      _showToast("Preencha a descrição");
    } else if (_selectedAccountType == null) {
      _showToast("Selecione o tipo de conta");
    } else if (_selectedColor == null) {
      _showToast("Selecione a cor");
    } else {
      AccountDTO account = AccountDTO(
        description: _descriptionController.text.trim(),
        color: _selectedColor!.toHex(),
        type: _selectedAccountType!.id,
        bankId: _selectedBank!.id,
        initialBalance: _accountTotal,
      );
      AccountService.createAccount(account);
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
              text: "Nova Conta",
            ),
            GestureDetector(
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => Calculator(
                  balance: _accountTotal,
                  onClick: _setBalance,
                  type: CalculatorType.normal,
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
                      "Saldo atual",
                      style: TextStyle(
                        color: Color(0xA69E9E9E),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _formatCurrency.format(_accountTotal),
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
                        InsertSelectImageField(
                          defaultIcon: FontAwesomeIcons.buildingColumns,
                          hint: _selectedBank?.name ?? "Escolha um banco",
                          image: _selectedBank?.image,
                          itemList: _convertBanksToSelect(),
                          onClick: _selectBank,
                        ),
                        InsertTextField(
                          icon: FontAwesomeIcons.pen,
                          hint: "Descrição",
                          controller: _descriptionController,
                        ),
                        InsertSelectIconField(
                          defaultIcon: FontAwesomeIcons.wallet,
                          hint: _selectedAccountType?.name ?? "Tipo de conta",
                          icon: _selectedAccountType?.icon,
                          itemList: _convertAccountTypeToSelect(),
                          onClick: _selectAccountType,
                        ),
                        InsertColorField(
                          icon: FontAwesomeIcons.swatchbook,
                          hint: "Cor",
                          color: _selectedColor,
                          selectColor: _selectColor,
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
            ),
          ],
        ),
      ),
    );
  }
}
