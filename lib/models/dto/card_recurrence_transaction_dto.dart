class CardRecurrenceTransactionDTO {
  String description;
  int day;
  double amount;
  DateTime lastDateCreated;
  int categoryId;
  int creditCardId;

  CardRecurrenceTransactionDTO({
    required this.description,
    required this.day,
    required this.amount,
    required this.lastDateCreated,
    required this.categoryId,
    required this.creditCardId,
  });

  Map<String, Object?> toMap() {
    return {
      'description': description,
      'day': day,
      'amount': amount,
      'last_date_created': lastDateCreated.microsecondsSinceEpoch,
      'category_id': categoryId,
      'card_id': categoryId,
    };
  }
}
