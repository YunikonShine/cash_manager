class InvoiceDTO {
  DateTime openDate;
  DateTime closeDate;
  DateTime dueDate;
  double amount;
  int status;
  int cardId;
  bool paid;

  InvoiceDTO({
    required this.openDate,
    required this.closeDate,
    required this.dueDate,
    required this.amount,
    required this.status,
    required this.cardId,
    required this.paid,
  });

  Map<String, Object?> toMap() {
    return {
      'open_date': openDate.microsecondsSinceEpoch,
      'close_date': closeDate.microsecondsSinceEpoch,
      'due_date': dueDate.microsecondsSinceEpoch,
      'amount': amount,
      'status': status,
      'card_id': cardId,
      'paid': paid ? 1 : 0,
    };
  }
}
