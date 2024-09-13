import 'package:cash_manager/models/dto/select_icon_item.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectionDialogIcon extends StatefulWidget {
  const SelectionDialogIcon({
    super.key,
    required this.items,
    required this.onClick,
  });

  final List<SelectIconItem> items;
  final Function(dynamic item) onClick;

  @override
  SelectionDialogIconState createState() => SelectionDialogIconState();
}

class SelectionDialogIconState extends State<SelectionDialogIcon> {
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
              SelectIconItem selectionItem = widget.items[index];
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
                              Padding(
                                padding: const EdgeInsets.only(right: 40),
                                child: FaIcon(
                                  selectionItem.icon,
                                  color: Colors.grey,
                                ),
                              ),
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
