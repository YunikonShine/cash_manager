import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/transaction_category.dart';

class AccountTransaction {
  late int id;
  late String description;
  late double amount;
  late bool type;
  late DateTime date;
  late TransactionCategory category;
  late Account account;

  AccountTransaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
    required this.account,
  });

  AccountTransaction.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    description = data['description'];
    amount = data['amount'];
    type = data['type'] == 1;
    date = DateTime.fromMicrosecondsSinceEpoch(data['date']);
  }
}
