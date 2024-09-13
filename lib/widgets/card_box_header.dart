import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/enum/invoice_status.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CardBoxHeader extends StatefulWidget {
  const CardBoxHeader({
    super.key,
    required this.selectedCard,
    required this.selectedInvoice,
  });

  final CreditCard selectedCard;
  final Invoice selectedInvoice;

  @override
  State<CardBoxHeader> createState() => _CardBoxHeaderState();
}

class _CardBoxHeaderState extends State<CardBoxHeader> {
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(bottom: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Image(
                alignment: Alignment.center,
                width: 75,
                height: 50,
                image: AssetImage(widget.selectedCard.brand.image.imagePath),
                fit: BoxFit.cover,
              ),
              Text(
                widget.selectedCard.description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 130,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 30,
                          child: FaIcon(
                            FontAwesomeIcons.calendarWeek,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Fechamento",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                DateFormat("dd/MMM").format(widget
                                    .selectedInvoice.closeDate
                                    .add(const Duration(days: 1))),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 30,
                          child: FaIcon(
                            FontAwesomeIcons.receipt,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Status",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                widget.selectedInvoice.status.description,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 130,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 30,
                          child: FaIcon(
                            FontAwesomeIcons.calendarCheck,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Vencimento",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                DateFormat("dd/MMM")
                                    .format(widget.selectedInvoice.dueDate),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 30,
                          child: FaIcon(
                            FontAwesomeIcons.moneyBill,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Valor",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _formatCurrency
                                    .format(widget.selectedInvoice.amount),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
