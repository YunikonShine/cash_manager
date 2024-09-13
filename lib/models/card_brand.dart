import 'package:cash_manager/models/enum/image_type.dart';
import 'package:cash_manager/models/image_data.dart';

class CardBrand {
  late int id;
  late String name;
  late ImageData image;

  CardBrand({
    required this.id,
    required this.name,
    required this.image,
  });

  CardBrand.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    image = ImageData(
      imagePath: "assets/card_brands/${data['image']}.png",
      type: ImageType.image,
    );
  }
}
