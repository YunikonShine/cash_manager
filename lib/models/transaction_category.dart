import 'package:cash_manager/models/enum/image_type.dart';
import 'package:cash_manager/models/image_data.dart';

class TransactionCategory {
  late int id;
  late String name;
  late ImageData image;
  late int type;

  TransactionCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
  });

  TransactionCategory.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    image = ImageData(
      imagePath: "assets/categories/${data['image']}.png",
      type: ImageType.icon,
    );
    type = data['type'];
  }
}
