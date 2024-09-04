import 'package:cash_manager/models/account.dart';

class CreditCard {
  int? id;
  late String description;
  late double limit;
  late int closeDate;
  late int dueDate;
  late int brand;
  late int accountId;
  late Account? account;

  CreditCard({
    this.id,
    required this.description,
    required this.limit,
    required this.closeDate,
    required this.dueDate,
    required this.brand,
    required this.accountId,
    this.account,
  });

  CreditCard.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    description = data['description'];
    limit = data['amount_limit'];
    closeDate = data['close_date'];
    dueDate = data['due_date'];
    brand = data['brand'];
    accountId = data['account_id'];
  }
}
