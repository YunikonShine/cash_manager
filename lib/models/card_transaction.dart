import 'package:cash_manager/models/category.dart';
import 'package:cash_manager/models/invoice.dart';

class CardTransaction {
  int? id;
  late String description;
  late DateTime date;
  late double amount;
  late int categoryId;
  Category? category;
  int? invoiceId;
  Invoice? invoice;
  late bool recurrence;
  DateTime? createdAt;

  CardTransaction({
    this.id,
    required this.description,
    required this.date,
    required this.amount,
    required this.categoryId,
    this.invoiceId,
    this.invoice,
    required this.recurrence,
  });

  CardTransaction.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    description = data['description'];
    date = DateTime.fromMicrosecondsSinceEpoch(data['date']);
    amount = data['amount'];
    categoryId = data['category_id'];
    invoiceId = data['invoice_id'];
    recurrence = data['recurrence'] == 1;
    createdAt = DateTime.fromMicrosecondsSinceEpoch(data['created_at']);
  }
}
