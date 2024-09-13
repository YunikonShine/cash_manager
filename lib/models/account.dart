import 'package:cash_manager/models/enum/account_type.dart';
import 'package:cash_manager/models/bank.dart';

class Account {
  late int id;
  late String description;
  late String color;
  late AccountType type;
  late Bank bank;
  late double balance;
  late double initialBalance;

  Account({
    required this.id,
    required this.description,
    required this.color,
    required this.type,
    required this.bank,
    required this.balance,
    required this.initialBalance,
  });

  Account.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    description = data['description'];
    color = data['color'];
    type = AccountTypeHelper.fromId(data['type']);
    balance = data['balance'];
    initialBalance = data['initial_balance'];
  }

  Map<String, Object?> toMap() {
    return {
      'description': description,
      'color': color,
      'type': type.id,
      'bank_id': bank.id,
      'balance': balance,
      'initial_balance': initialBalance,
    };
  }
}
