import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ItemBox extends StatefulWidget {
  const ItemBox({
    super.key,
    required this.name,
    required this.accounts,
    required this.onClick,
  });

  final String name;
  final List<Account> accounts;
  final VoidCallback onClick;

  @override
  ItemBoxState createState() => ItemBoxState();
}

class ItemBoxState extends State<ItemBox> {
  final formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");
  double totalAccount = 0;

  @override
  void initState() {
    super.initState();
    for (Account a in widget.accounts) {
      totalAccount += a.balance;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              Icon(
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
            children: [
              for (Account account in widget.accounts)
                Container(
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
                              image: AssetImage("assets/banks/nubank.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: 100,
                            padding: EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  account.desciption,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  formatCurrency.format(account.balance),
                                  style: TextStyle(
                                    color: account.balance >= 0
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
                      Container(
                        child: IconButton(
                          onPressed: () => {},
                          icon: Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.purple,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: ElevatedButton(
                  onPressed: widget.onClick,
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.purple,
                    ),
                  ),
                  child: Text(
                    "Cadastar conta",
                    style: const TextStyle(
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
                    formatCurrency.format(totalAccount),
                    style: TextStyle(
                      color: totalAccount >= 0 ? Colors.green : Colors.red,
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
