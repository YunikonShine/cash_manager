import 'package:cash_manager/models/bank.dart';

class Account {
  int? id;
  late String description;
  late String color;
  late int type;
  late int bankId;
  late Bank? bank;
  late double balance;
  late double initialBalance;

  Account({
    this.id,
    required this.description,
    required this.color,
    required this.type,
    required this.bankId,
    required this.balance,
    required this.initialBalance,
    this.bank,
  });

  Account.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    description = data['description'];
    color = data['color'];
    type = data['type'];
    bankId = data['bank_id'];
    balance = data['balance'];
    initialBalance = data['initial_balance'];
  }
}
