import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/enum/invoice_status.dart';

class Invoice {
  late int id;
  late DateTime openDate;
  late DateTime closeDate;
  late DateTime dueDate;
  late double amount;
  late InvoiceStatus status;
  late CreditCard creditCard;

  Invoice({
    required this.id,
    required this.openDate,
    required this.closeDate,
    required this.dueDate,
    required this.amount,
    required this.status,
    required this.creditCard,
  });

  Invoice.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    openDate = DateTime.fromMicrosecondsSinceEpoch(data['open_date']);
    closeDate = DateTime.fromMicrosecondsSinceEpoch(data['close_date']);
    dueDate = DateTime.fromMicrosecondsSinceEpoch(data['due_date']);
    amount = data['amount'];
    status = InvoiceStatusHelper.fromId(data['status']);
  }

  Map<String, Object?> toMap() {
    return {
      'open_date': openDate.microsecondsSinceEpoch,
      'close_date': closeDate.microsecondsSinceEpoch,
      'due_date': dueDate.microsecondsSinceEpoch,
      'amount': amount,
      'status': status.id,
      'card_id': creditCard.id,
    };
  }
}
