import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/transaction_category.dart';

class CardRecurrenceTransaction {
  late int id;
  late String description;
  late int day;
  late double amount;
  late DateTime lastDateCreated;
  late TransactionCategory category;
  late CreditCard creditCard;

  CardRecurrenceTransaction({
    required this.id,
    required this.description,
    required this.day,
    required this.amount,
    required this.lastDateCreated,
    required this.category,
    required this.creditCard,
  });

  CardRecurrenceTransaction.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    description = data['description'];
    day = data['day'];
    amount = data['amount'];
    lastDateCreated =
        DateTime.fromMicrosecondsSinceEpoch(data['last_date_created']);
  }

  Map<String, Object?> toMap() {
    return {
      'description': description,
      'day': day,
      'amount': amount,
      'category_id': category.id,
      'card_id': creditCard.id,
      'last_date_created': lastDateCreated.microsecondsSinceEpoch,
    };
  }
}
