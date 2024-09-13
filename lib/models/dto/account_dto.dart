class AccountDTO {
  String description;
  String color;
  int type;
  int bankId;
  double initialBalance;

  AccountDTO({
    required this.description,
    required this.color,
    required this.type,
    required this.bankId,
    required this.initialBalance,
  });

  Map<String, Object?> toMap() {
    return {
      'initial_balance': initialBalance,
      'balance': initialBalance,
      'bank_id': bankId,
      'color': color,
      'description': description,
      'type': type,
    };
  }
}
