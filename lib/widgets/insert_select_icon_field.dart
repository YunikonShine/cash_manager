import 'package:cash_manager/models/dto/select_icon_item.dart';
import 'package:cash_manager/widgets/selection_dialog_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InsertSelectIconField extends StatefulWidget {
  const InsertSelectIconField({
    super.key,
    required this.defaultIcon,
    required this.hint,
    this.icon,
    required this.onClick,
    required this.itemList,
  });

  final IconData defaultIcon;
  final String hint;
  final IconData? icon;
  final Function(dynamic item) onClick;
  final List<SelectIconItem> itemList;

  @override
  InsertSelectIconFieldState createState() => InsertSelectIconFieldState();
}

class InsertSelectIconFieldState extends State<InsertSelectIconField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => SelectionDialogIcon(
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
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: FaIcon(
                        widget.icon ?? widget.defaultIcon,
                        color: Colors.grey,
                      ),
                    ),
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
