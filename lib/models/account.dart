class Account {
  int? id;
  late String desciption;
  late String color;
  late int type;
  late int bankId;
  late double balance;

  Account({
    this.id,
    required this.desciption,
    required this.color,
    required this.type,
    required this.bankId,
    required this.balance,
  });

  Account.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    desciption = data['desciption'];
    color = data['color'];
    type = data['type'];
    bankId = data['bank_id'];
    balance = data['balance'];
  }
}
