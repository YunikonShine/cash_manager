import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/enum/invoice_status.dart';

class Invoice {
  int? id;
  late DateTime openDate;
  late DateTime closeDate;
  late DateTime dueDate;
  late double amount;
  late int cardId;
  late InvoiceStatus status;
  CreditCard? card;

  Invoice({
    this.id,
    required this.openDate,
    required this.closeDate,
    required this.dueDate,
    required this.amount,
    required this.cardId,
    required this.status,
    this.card,
  });

  Invoice.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    openDate = DateTime.fromMicrosecondsSinceEpoch(data['open_date']);
    closeDate = DateTime.fromMicrosecondsSinceEpoch(data['close_date']);
    dueDate = DateTime.fromMicrosecondsSinceEpoch(data['due_date']);
    amount = data['amount'];
    cardId = data['card_id'];
    status = InvoiceStatusHelper.fromId(data['status']);
  }
}
