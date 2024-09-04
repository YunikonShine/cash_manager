import 'package:cash_manager/helpers/hex_color.dart';
import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/selection_item.dart';
import 'package:cash_manager/services/database/queries/account_query.dart';
import 'package:cash_manager/services/database/queries/bank_query.dart';
import 'package:cash_manager/widgets/bank_color_picker.dart';
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
  double accountTotal = 0;
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");
  final _descriptionController = TextEditingController();

  ImageProvider<Object>? _bankIcon;
  String? _bankName;
  int? _bankId;
  int? _accountId;
  String? _accountName;
  IconData? _accountIcon = FontAwesomeIcons.wallet;
  Color? _bankColor;

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _selectBank(SelectionItem bank) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _bankIcon = bank.image;
      _bankName = bank.name;
      _bankId = bank.id;
      _bankColor = HexColor.fromHex(bank.color!);
    });
    Navigator.pop(context);
  }

  _selectColor(Color color) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _bankColor = color;
    });
    Navigator.pop(context);
  }

  _selectType(SelectionItem accountType) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _accountId = accountType.id;
      _accountName = accountType.name;
      _accountIcon = accountType.icon;
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

  _saveAccount() {
    if (_bankId == null) {
      _showToast("Selecione o banco");
    } else if (_descriptionController.text.isEmpty) {
      _showToast("Preencha a descrição");
    } else if (_accountId == null) {
      _showToast("Selecione o tipo de conta");
    } else if (_bankColor == null) {
      _showToast("Selecione a cor");
    } else {
      Account account = Account(
        bankId: _bankId!,
        color: _bankColor!.toHex(),
        desciption: _descriptionController.text,
        type: _accountId!,
        balance: accountTotal,
      );
      AccountQuery.createAccount(account);
      Navigator.pop(context);
      widget.onPop();
    }
  }

  _setBalance(double balance) {
    setState(() {
      accountTotal = balance;
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
              text: "Nova Conta",
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
                      "Saldo atual",
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
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: InsertField(
                          startImage: _bankIcon,
                          startIcon: _bankIcon == null
                              ? FontAwesomeIcons.buildingColumns
                              : null,
                          startText: _bankName ?? "Escolha um banco",
                          finalIcon: FontAwesomeIcons.chevronRight,
                          onClick: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Selection(
                              onClick: (bank) => _selectBank(bank),
                              items: BankQuery.selectSelectionItems(),
                            ),
                          ),
                        ),
                      ),
                      InsertField(
                        startIcon: FontAwesomeIcons.pen,
                        hint: "Descrição",
                        controller: _descriptionController,
                      ),
                      InsertField(
                        startIcon: _accountIcon,
                        startText: _accountName ?? "Tipo de conta",
                        finalIcon: FontAwesomeIcons.chevronRight,
                        onClick: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Selection(
                            onClick: (type) => _selectType(type),
                            items: SelectionItem.fromAccountTypes(),
                          ),
                        ),
                      ),
                      InsertField(
                        startIcon: FontAwesomeIcons.swatchbook,
                        startText: "Cor",
                        color: _bankColor,
                        finalIcon: FontAwesomeIcons.chevronRight,
                        onClick: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => BankColorPicker(
                            color: _bankColor,
                            onChange: (color) => _selectColor(color),
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
