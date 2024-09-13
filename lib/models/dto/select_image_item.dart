import 'package:cash_manager/models/image_data.dart';

class SelectImageItem {
  int id;
  ImageData image;
  String text;
  dynamic object;

  SelectImageItem({
    required this.id,
    required this.image,
    required this.text,
    required this.object,
  });
}
