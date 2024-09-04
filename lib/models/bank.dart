class Bank {
  int? id;
  String? name;
  String? icon;
  String? color;

  Bank({
    this.id,
    this.name,
    this.icon,
    this.color,
  });

  Bank.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    icon = data['icon'];
    color = data['color'];
  }
}
