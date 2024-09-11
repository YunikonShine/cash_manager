import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/header_dropdown_item.dart';
import 'package:cash_manager/models/selection_item.dart';
import 'package:cash_manager/screens/card_screen.dart';
import 'package:cash_manager/screens/card_transaction_list_screen.dart';
import 'package:cash_manager/services/database/queries/credit_card_query.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CardItemBox extends StatefulWidget {
  const CardItemBox({
    super.key,
    required this.onPop,
  });

  final Function onPop;

  @override
  CardItemBoxState createState() => CardItemBoxState();
}

class CardItemBoxState extends State<CardItemBox> {
  final formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  late List<CreditCard> _cards = [];
  late List<SelectionItem> _listItems = [];

  double _total = 0;
  bool _incomeStatus = true;

  @override
  void initState() {
    super.initState();
    _updateInitialStatus();
  }

  _updateInitialStatus() async {
    List<CreditCard> freshCards =
        await CreditCardQuery.selectCreditCards(_incomeStatus);

    double cardBalance = 0;
    for (CreditCard card in freshCards) {
      cardBalance += card.currentInvoice!.amount;
    }

    setState(() {
      _cards = freshCards;
      _listItems = SelectionItem.fromCreditCards(_cards);
      _total = cardBalance;
    });
  }

  _setIncomeStatus(bool status) {
    setState(() {
      _incomeStatus = status;
    });
    _updateInitialStatus();
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
                child: const Text(
                  "Cartões",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              const FaIcon(
                FontAwesomeIcons.creditCard,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _setIncomeStatus(true),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _incomeStatus ? Colors.green : Colors.grey,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Fatura aberta",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _setIncomeStatus(false),
                    child: Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _incomeStatus ? Colors.grey : Colors.green,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "Fatura fechada",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              for (SelectionItem item in _listItems)
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardTransactionListScreen(
                        creditCards: _cards,
                        selectedItem: item.name!,
                      ),
                    ),
                  ),
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
                                image: item.image!,
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
                                    item.name!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    formatCurrency.format(item.amount!.abs()),
                                    style: TextStyle(
                                      color: item.amount! >= 0
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
                        if (item.closeDate != null)
                          Text(
                            DateFormat('dd/MMM').format(item.closeDate!),
                            style: const TextStyle(
                              color: Color(0xA69E9E9E),
                              fontSize: 16,
                            ),
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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardScreen(
                        onPop: widget.onPop,
                      ),
                    ),
                  ),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.purple,
                    ),
                  ),
                  child: const Text(
                    "Cadastrar cartão",
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
                    formatCurrency.format(_total),
                    style: const TextStyle(
                      color: Colors.white,
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
