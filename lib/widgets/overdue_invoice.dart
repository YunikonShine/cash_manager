import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/services/invoice_service.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/pay_invoice.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class OverdueInvoice extends StatefulWidget {
  const OverdueInvoice({
    super.key,
    required this.invoices,
    required this.onPop,
  });

  final List<Invoice> invoices;
  final Function onPop;

  @override
  OverdueInvoiceState createState() => OverdueInvoiceState();
}

class OverdueInvoiceState extends State<OverdueInvoice> {
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  @override
  void initState() {
    super.initState();
  }

  Widget _overdueInvoicesBox(Invoice invoice) {
    return Box(
      padding: const EdgeInsets.only(
        right: 15,
      ),
      internalPadding: const EdgeInsets.all(10),
      top: true,
      width: 40,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image(
              width: 40,
              height: 40,
              image: AssetImage(invoice.creditCard.brand.image.imagePath),
              fit: BoxFit.cover,
            ),
          ),
          Text(
            invoice.creditCard.description,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
          Text(
            DateFormat('dd/MMM/yy').format(invoice.dueDate),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const Text(
            'Valor da fatura',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
          Text(
            _formatCurrency.format(invoice.amount),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => PayInvoice(
                  onPop: widget.onPop,
                  selectedInvoice: invoice,
                ),
              ),
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Colors.purple,
                ),
              ),
              child: const Text(
                "Pagar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.invoices.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: (MediaQuery.of(context).size.width * 90) / 100,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 25,
              bottom: 15,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: const Text(
                    "Faturas fechadas",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ),
                const FaIcon(
                  FontAwesomeIcons.receipt,
                  color: Colors.grey,
                  size: 18,
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (Invoice invoice in widget.invoices)
                    _overdueInvoicesBox(invoice),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
