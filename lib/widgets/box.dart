import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  const Box({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.top = false,
    this.padding = EdgeInsets.zero,
  });

  final int width;
  final double height;
  final Widget child;
  final bool top;
  final EdgeInsets padding;

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
              bottomLeft: const Radius.circular(50),
              bottomRight: const Radius.circular(50),
              topLeft: Radius.circular(top ? 50 : 0),
              topRight: Radius.circular(top ? 50 : 0),
            ),
            color: const Color(0xFF4C4C4C),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: child,
          ),
        ),
      ),
    );
  }
}
