import 'package:cash_manager/widgets/bank_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InsertColorField extends StatefulWidget {
  const InsertColorField({
    super.key,
    required this.icon,
    required this.hint,
    this.color,
    required this.selectColor,
  });

  final IconData icon;
  final String hint;
  final Color? color;
  final Function(Color color) selectColor;

  @override
  InsertColorFieldState createState() => InsertColorFieldState();
}

class InsertColorFieldState extends State<InsertColorField> {
  Widget _getColorBox() {
    if (widget.color != null) {
      return Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            width: 2,
            color: Colors.grey,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => BankColorPicker(
            color: widget.color,
            onChange: widget.selectColor,
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
                    )
                  ],
                ),
                Row(
                  children: [
                    _getColorBox(),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
