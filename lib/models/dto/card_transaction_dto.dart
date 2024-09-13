class CardTransactionDTO {
  String description;
  DateTime date;
  double amount;
  int categoryId;
  int invoiceId;
  bool recurrence;

  CardTransactionDTO({
    required this.description,
    required this.date,
    required this.amount,
    required this.categoryId,
    required this.invoiceId,
    required this.recurrence,
  });

  Map<String, Object?> toMap() {
    return {
      'description': description,
      'date': date.microsecondsSinceEpoch,
      'amount': amount,
      'category_id': categoryId,
      'invoice_id': invoiceId,
      'recurrence': recurrence,
    };
  }
}
