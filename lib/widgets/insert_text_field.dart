import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InsertTextField extends StatefulWidget {
  const InsertTextField({
    super.key,
    required this.icon,
    required this.hint,
    required this.controller,
  });

  final IconData icon;
  final String hint;
  final TextEditingController controller;

  @override
  InsertTextFieldState createState() => InsertTextFieldState();
}

class InsertTextFieldState extends State<InsertTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {_focusNode.requestFocus()},
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
                    SizedBox(
                      width: 250,
                      child: TextField(
                        focusNode: _focusNode,
                        controller: widget.controller,
                        decoration: InputDecoration.collapsed(
                          hintText: widget.hint,
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        cursorColor: Colors.deepPurple,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
