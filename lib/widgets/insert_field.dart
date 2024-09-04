import 'package:flutter/material.dart';

class InsertField extends StatefulWidget {
  const InsertField({
    super.key,
    this.startIcon,
    this.startImage,
    this.startText,
    this.finalIcon,
    this.hint,
    this.controller,
    this.onClick,
    this.height = 60,
    this.color,
  });

  final IconData? startIcon;
  final ImageProvider<Object>? startImage;
  final String? startText;
  final IconData? finalIcon;
  final String? hint;
  final TextEditingController? controller;
  final VoidCallback? onClick;
  final double height;
  final Color? color;

  @override
  InsertFieldState createState() => InsertFieldState();
}

class InsertFieldState extends State<InsertField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        height: widget.height,
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
                Container(
                  child: Row(
                    children: [
                      if (widget.startImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image(
                            width: 40,
                            height: 40,
                            image: widget.startImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: widget.startImage == null ? 40 : 0,
                        ),
                        child: Icon(
                          widget.startIcon,
                          color: Colors.grey,
                        ),
                      ),
                      widget.startText != null
                          ? Text(
                              widget.startText ?? "",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            )
                          : Container(
                              width: 100,
                              child: TextField(
                                controller: widget.controller,
                                decoration: new InputDecoration.collapsed(
                                  hintText: widget.hint,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                cursorColor: Colors.deepPurple,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    if (widget.color != null)
                      Container(
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
                      ),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Icon(
                        widget.finalIcon,
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
