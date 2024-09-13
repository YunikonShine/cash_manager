import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/card_brand.dart';

class CreditCard {
  late int id;
  late String description;
  late double limit;
  late int closeDay;
  late int dueDay;
  late CardBrand brand;
  late Account account;

  CreditCard({
    required this.id,
    required this.description,
    required this.limit,
    required this.closeDay,
    required this.dueDay,
    required this.brand,
    required this.account,
  });

  CreditCard.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    description = data['description'];
    limit = data['amount_limit'];
    closeDay = data['close_day'];
    dueDay = data['due_day'];
  }
}
