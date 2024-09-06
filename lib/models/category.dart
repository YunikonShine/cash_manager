class Category {
  int? id;
  String? name;
  String? icon;
  int? type;

  Category({
    this.id,
    this.name,
    this.icon,
    this.type,
  });

  Category.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    icon = data['icon'];
    type = data['type'];
  }
}
