import 'package:cash_manager/widgets/floating_menu_items.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FloatingMenuButton extends StatelessWidget {
  const FloatingMenuButton({
    super.key,
    required this.onPop,
  });

  final Function onPop;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => FloatingMenuItems(onPop: onPop),
      ),
      child: const FaIcon(
        FontAwesomeIcons.plus,
      ),
    );
  }
}
