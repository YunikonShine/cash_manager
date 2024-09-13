import 'package:cash_manager/widgets/calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class InsertDateField extends StatefulWidget {
  const InsertDateField({
    super.key,
    required this.icon,
    required this.hint,
    this.date,
    required this.format,
    required this.selectDate,
  });

  final IconData icon;
  final String hint;
  final DateTime? date;
  final String format;
  final Function(DateTime date) selectDate;

  @override
  InsertDateFieldState createState() => InsertDateFieldState();
}

class InsertDateFieldState extends State<InsertDateField> {
  Widget _getDateBox() {
    if (widget.date != null) {
      return SizedBox(
        width: 25,
        height: 25,
        child: Text(
          DateFormat(widget.format).format(widget.date!),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 18,
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
          builder: (BuildContext context) => CalendarPicker(
            selectDate: widget.selectDate,
            month: false,
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
                    _getDateBox(),
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
