import 'package:cash_manager/models/selection_item.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ItemBox extends StatefulWidget {
  const ItemBox({
    super.key,
    required this.name,
    required this.items,
    required this.onClick,
    required this.onLineClick,
    required this.buttonText,
    required this.icon,
    this.total = 0,
    this.isCard = false,
    this.selection = true,
    this.selectType,
  });

  final String name;
  final List<SelectionItem> items;
  final VoidCallback onClick;
  final VoidCallback onLineClick;
  final String buttonText;
  final IconData icon;
  final double total;
  final bool isCard;
  final bool selection;
  final Function(bool value)? selectType;

  @override
  ItemBoxState createState() => ItemBoxState();
}

class ItemBoxState extends State<ItemBox> {
  final formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 25,
            bottom: 15,
          ),
          width: (MediaQuery.of(context).size.width * 90) / 100,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              Icon(
                widget.icon,
                color: Colors.grey,
                size: 18,
              ),
            ],
          ),
        ),
        Box(
          internalPadding: const EdgeInsets.only(
            top: 15,
            left: 25,
            right: 25,
            bottom: 25,
          ),
          width: 90,
          top: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.isCard)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => widget.selectType!(true),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.selection ? Colors.green : Colors.grey,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "Fatura aberta",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.selectType!(false),
                      child: Container(
                        padding: const EdgeInsets.only(left: 15),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                widget.selection ? Colors.grey : Colors.green,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: const Text(
                            "Fatura fechada",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              for (SelectionItem item in widget.items)
                GestureDetector(
                  onTap: widget.onLineClick,
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0x32A3A3A3),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image(
                                width: 40,
                                height: 40,
                                image: item.image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: 175,
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.name!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    formatCurrency.format(item.amount!.abs()),
                                    style: TextStyle(
                                      color: item.amount! >= 0
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (item.closeDate != null)
                          Text(
                            DateFormat('dd/MMM').format(item.closeDate!),
                            style: const TextStyle(
                              color: Color(0xA69E9E9E),
                              fontSize: 16,
                            ),
                          ),
                        IconButton(
                          onPressed: () => {},
                          icon: const Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.purple,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: ElevatedButton(
                  onPressed: widget.onClick,
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.purple,
                    ),
                  ),
                  child: Text(
                    widget.buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    formatCurrency.format(widget.total.abs()),
                    style: TextStyle(
                      color: widget.total >= 0 ? Colors.white : Colors.red,
                      fontSize: 18,
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
