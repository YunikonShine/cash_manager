import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InsertField extends StatefulWidget {
  const InsertField({
    super.key,
    required this.icon,
    required this.hint,
    required this.onClick,
  });

  final IconData icon;
  final String hint;
  final VoidCallback onClick;

  @override
  InsertFieldState createState() => InsertFieldState();
}

class InsertFieldState extends State<InsertField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        widget.onClick();
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
                        widget.icon,
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
