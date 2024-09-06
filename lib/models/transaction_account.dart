import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/category.dart';

class TransactionAccount {
  int? id;
  late String description;
  late double amount;
  late int type;
  late int categoryId;
  late Category? category;
  late int accountId;
  late Account? account;

  TransactionAccount({
    this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.categoryId,
    this.category,
    required this.accountId,
    this.account,
  });

  TransactionAccount.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    description = data['description'];
    amount = data['amount'];
    type = data['type'];
    categoryId = data['category_id'];
    categoryId = data['account_id'];
  }
}
