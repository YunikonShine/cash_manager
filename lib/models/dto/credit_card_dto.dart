class CreditCardDTO {
  String description;
  double limit;
  int closeDay;
  int dueDay;
  int brandId;
  int accountId;

  CreditCardDTO({
    required this.description,
    required this.limit,
    required this.closeDay,
    required this.dueDay,
    required this.brandId,
    required this.accountId,
  });

  Map<String, Object?> toMap() {
    return {
      'description': description,
      'amount_limit': limit,
      'close_day': closeDay,
      'due_day': dueDay,
      'brand_id': brandId,
      'account_id': accountId,
    };
  }
}
