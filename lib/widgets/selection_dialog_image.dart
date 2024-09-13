import 'package:cash_manager/models/dto/select_image_item.dart';
import 'package:cash_manager/models/enum/image_type.dart';
import 'package:cash_manager/models/image_data.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectionDialogImage extends StatefulWidget {
  const SelectionDialogImage({
    super.key,
    required this.items,
    required this.onClick,
  });

  final List<SelectImageItem> items;
  final Function(dynamic item) onClick;

  @override
  SelectionDialogImageState createState() => SelectionDialogImageState();
}

class SelectionDialogImageState extends State<SelectionDialogImage> {
  Widget _getImage(ImageData image) {
    if (image.type == ImageType.icon) {
      return Padding(
        padding: const EdgeInsets.only(right: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 40,
            width: 40,
            color: Colors.blue,
            padding: const EdgeInsets.all(8),
            child: Image(
              image: AssetImage(image.imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image(
          width: 40,
          height: 40,
          image: AssetImage(image.imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.bottomCenter,
      child: Box(
        width: 100,
        height: 500,
        bottom: false,
        top: true,
        child: Material(
          color: Colors.transparent,
          child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              SelectImageItem selectionItem = widget.items[index];
              return GestureDetector(
                onTap: () => widget.onClick(selectionItem.object),
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0x32A3A3A3),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _getImage(selectionItem.image),
                              Text(
                                selectionItem.text,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: const FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
