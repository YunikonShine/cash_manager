import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/enum/invoice_status.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/screens/card_transaction_list_screen.dart';
import 'package:cash_manager/screens/card_transaction_screen.dart';
import 'package:cash_manager/screens/credit_card_screen.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/empty_box.dart';
import 'package:cash_manager/widgets/pay_invoice.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CardItemBox extends StatefulWidget {
  const CardItemBox({
    super.key,
    required this.invoiceType,
    required this.cards,
    required this.onPop,
    required this.selectType,
  });

  final bool invoiceType;
  final Map<CreditCard, Invoice> cards;
  final Function onPop;
  final Function(bool type) selectType;

  @override
  CardItemBoxState createState() => CardItemBoxState();
}

class CardItemBoxState extends State<CardItemBox> {
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  @override
  void initState() {
    super.initState();
  }

  Widget _getCardLine(CreditCard card, Invoice invoice) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardTransactionListScreen(
              selectedCard: card,
              selectedInvoice: invoice,
            ),
          ),
        ),
      },
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
                    image: AssetImage(card.brand.image.imagePath),
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
                        card.description,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        _formatCurrency.format(invoice.amount),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Text(
              DateFormat('dd/MMM')
                  .format(invoice.closeDate.add(const Duration(days: 1))),
              style: const TextStyle(
                color: Color(0xA69E9E9E),
                fontSize: 16,
              ),
            ),
            _getFinalButton(card, invoice),
          ],
        ),
      ),
    );
  }

  Widget _getFinalButton(CreditCard card, Invoice invoice) {
    if (invoice.status == InvoiceStatus.close) {
      if (invoice.paid) {
        return IconButton(
          onPressed: () => {},
          icon: const FaIcon(
            FontAwesomeIcons.check,
            color: Colors.green,
            size: 22,
          ),
        );
      }

      return IconButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => PayInvoice(
            onPop: widget.onPop,
            selectedInvoice: invoice,
          ),
        ),
        icon: const FaIcon(
          FontAwesomeIcons.moneyBillTransfer,
          color: Colors.red,
          size: 22,
        ),
      );
    }
    return IconButton(
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardTransactionScreen(
              selectedCard: card,
              onPop: widget.onPop,
            ),
          ),
        )
      },
      icon: const FaIcon(
        FontAwesomeIcons.plus,
        color: Colors.purple,
        size: 22,
      ),
    );
  }

  _getTotal() {
    double total = 0;
    for (CreditCard card in widget.cards.keys) {
      Invoice invoice = widget.cards[card]!;
      total += invoice.amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    Map<CreditCard, Invoice> cards = widget.cards;
    if (cards.isEmpty) {
      return EmptyBox(
        name: "Contas",
        icon: FontAwesomeIcons.creditCard,
        emptyText: "Você não tem cartões cadastrados",
        buttonText: "Cadastrar cartão",
        onClick: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreditCardScreen(
                onPop: widget.onPop,
              ),
            ),
          );
        },
      );
    }

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
                    onTap: () => {widget.selectType(true)},
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.invoiceType ? Colors.green : Colors.grey,
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
                    onTap: () => {widget.selectType(false)},
                    child: Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              widget.invoiceType ? Colors.grey : Colors.green,
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
              for (CreditCard card in widget.cards.keys)
                _getCardLine(card, widget.cards[card]!),
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
                        builder: (context) => CreditCardScreen(
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
                    _formatCurrency.format(_getTotal()),
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
