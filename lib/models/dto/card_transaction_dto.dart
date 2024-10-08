class CardTransactionDTO {
  String description;
  DateTime date;
  double amount;
  int categoryId;
  int invoiceId;
  int creditCardId;

  CardTransactionDTO({
    required this.description,
    required this.date,
    required this.amount,
    required this.categoryId,
    required this.invoiceId,
    required this.creditCardId,
  });

  Map<String, Object?> toMap() {
    return {
      'description': description,
      'date': date.microsecondsSinceEpoch,
      'amount': amount,
      'category_id': categoryId,
      'invoice_id': invoiceId,
    };
  }
}
