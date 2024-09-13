import 'package:cash_manager/models/enum/image_type.dart';
import 'package:cash_manager/models/image_data.dart';

class Bank {
  late int id;
  late String name;
  late ImageData image;
  late String color;

  Bank({
    required this.id,
    required this.name,
    required this.image,
    required this.color,
  });

  Bank.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    image = ImageData(
      imagePath: "assets/banks/${data['image']}.png",
      type: ImageType.image,
    );
    color = data['color'];
  }
}
