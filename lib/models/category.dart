class Category {
  int? id;
  late String name;
  late String icon;
  late int type;

  Category({
    this.id,
    required this.name,
    required this.icon,
    required this.type,
  });

  Category.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    icon = data['icon'];
    type = data['type'];
  }
}
