class AccountTransactionDTO {
  String description;
  double amount;
  bool type;
  DateTime date;
  int categoryId;
  int accountId;

  AccountTransactionDTO({
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    required this.categoryId,
    required this.accountId,
  });

  Map<String, Object?> toMap() {
    return {
      'description': description,
      'amount': amount,
      'type': type ? 1 : 0,
      'date': date.microsecondsSinceEpoch,
      'category_id': categoryId,
      'account_id': accountId,
    };
  }
}
