import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  const Box({
    super.key,
    required this.width,
    this.height,
    required this.child,
    this.top = false,
    this.bottom = true,
    this.padding = EdgeInsets.zero,
    this.internalPadding = const EdgeInsets.all(25),
  });

  final int width;
  final double? height;
  final Widget child;
  final bool top;
  final bool bottom;
  final EdgeInsets padding;
  final EdgeInsets internalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: (MediaQuery.of(context).size.width * width) / 100,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(bottom ? 50 : 0),
              bottomRight: Radius.circular(bottom ? 50 : 0),
              topLeft: Radius.circular(top ? 50 : 0),
              topRight: Radius.circular(top ? 50 : 0),
            ),
            color: const Color(0xFF333333),
          ),
          child: Padding(
            padding: internalPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}
