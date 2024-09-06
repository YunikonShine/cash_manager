import 'package:cash_manager/models/selection_item.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/insert_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Selection extends StatefulWidget {
  const Selection({
    super.key,
    required this.onClick,
    required this.items,
    this.emptyList = "",
  });

  final Function(dynamic) onClick;
  final Future<List<SelectionItem>> items;
  final String emptyList;

  @override
  SelectionState createState() => SelectionState();
}

class SelectionState extends State<Selection> {
  late List<SelectionItem> banks;

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
          child: FutureBuilder<List<SelectionItem>>(
            future: widget.items,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          SelectionItem selectionItem = snapshot.data![index];
                          return InsertField(
                            startImage: selectionItem.imageType
                                ? selectionItem.image
                                : null,
                            startImageIcon: !selectionItem.imageType
                                ? selectionItem.image
                                : null,
                            startIcon: selectionItem.icon,
                            startText: selectionItem.name,
                            finalIcon: FontAwesomeIcons.chevronRight,
                            onClick: () => widget.onClick(selectionItem),
                          );
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Text(
                          widget.emptyList,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
