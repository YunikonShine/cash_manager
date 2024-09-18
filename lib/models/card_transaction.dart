import 'package:cash_manager/models/transaction_category.dart';
import 'package:cash_manager/models/invoice.dart';

class CardTransaction {
  late int id;
  late String description;
  late DateTime date;
  late double amount;
  late TransactionCategory category;
  late Invoice invoice;

  CardTransaction({
    required this.id,
    required this.description,
    required this.date,
    required this.amount,
    required this.category,
    required this.invoice,
  });

  CardTransaction.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    description = data['description'];
    date = DateTime.fromMicrosecondsSinceEpoch(data['date']);
    amount = data['amount'];
  }
}
