import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/screens/account_screen.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/empty_box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AccountItemBox extends StatefulWidget {
  const AccountItemBox({
    super.key,
    required this.accounts,
    required this.onPop,
  });

  final List<Account> accounts;
  final Function onPop;

  @override
  AccountItemBoxState createState() => AccountItemBoxState();
}

class AccountItemBoxState extends State<AccountItemBox> {
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  @override
  Widget build(BuildContext context) {
    List<Account> accounts = widget.accounts;
    if (accounts.isEmpty) {
      return EmptyBox(
        name: "Contas",
        icon: FontAwesomeIcons.buildingColumns,
        emptyText: "Você não tem contas cadastradas",
        buttonText: "Cadastrar contas",
        onClick: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountScreen(
                onPop: widget.onPop,
              ),
            ),
          );
        },
      );
    }

    double total = widget.accounts
        .map((account) => account.balance)
        .reduce((value1, value2) => value1 + value2);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 25,
            bottom: 15,
          ),
          width: (MediaQuery.of(context).size.width * 90) / 100,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                child: const Text(
                  "Contas",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              const FaIcon(
                FontAwesomeIcons.buildingColumns,
                color: Colors.grey,
                size: 18,
              ),
            ],
          ),
        ),
        Box(
          internalPadding: const EdgeInsets.only(
            top: 15,
            left: 25,
            right: 25,
            bottom: 25,
          ),
          width: 90,
          top: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (Account item in accounts)
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0x32A3A3A3),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image(
                                width: 40,
                                height: 40,
                                image: AssetImage(item.bank.image.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: 175,
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    _formatCurrency.format(item.balance),
                                    style: TextStyle(
                                      color: item.balance >= 0
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => {},
                          icon: const Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.purple,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountScreen(
                          onPop: widget.onPop,
                        ),
                      ),
                    );
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.purple,
                    ),
                  ),
                  child: const Text(
                    "Cadastrar conta",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    _formatCurrency.format(total),
                    style: TextStyle(
                      color: total >= 0 ? Colors.white : Colors.red,
                      fontSize: 18,
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
