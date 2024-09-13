import 'package:cash_manager/models/dto/select_image_item.dart';
import 'package:cash_manager/models/enum/image_type.dart';
import 'package:cash_manager/models/image_data.dart';
import 'package:cash_manager/widgets/selection_dialog_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InsertSelectImageField extends StatefulWidget {
  const InsertSelectImageField({
    super.key,
    required this.defaultIcon,
    required this.hint,
    this.image,
    required this.onClick,
    required this.itemList,
  });

  final IconData defaultIcon;
  final String hint;
  final ImageData? image;
  final Function(dynamic item) onClick;
  final List<SelectImageItem> itemList;

  @override
  InsertSelectImageFieldState createState() => InsertSelectImageFieldState();
}

class InsertSelectImageFieldState extends State<InsertSelectImageField> {
  Widget _getStartIcon() {
    if (widget.image == null) {
      return Padding(
        padding: const EdgeInsets.only(right: 40),
        child: FaIcon(
          widget.defaultIcon,
          color: Colors.grey,
        ),
      );
    }
    if (widget.image!.type == ImageType.icon) {
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
              image: AssetImage(widget.image!.imagePath),
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
          image: AssetImage(widget.image!.imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => SelectionDialogImage(
            onClick: (item) => widget.onClick(item),
            items: widget.itemList,
          ),
        );
      },
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
                    _getStartIcon(),
                    Text(
                      widget.hint,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
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
  }
}
