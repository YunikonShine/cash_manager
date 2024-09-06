import 'package:flutter/material.dart';

class IconFilled extends StatelessWidget {
  const IconFilled({
    super.key,
    required this.backgroundColor,
    required this.color,
    required this.icon,
  });

  final Color backgroundColor;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Icon(
              icon,
              color: color,
              size: 40,
            ),
          )
        ],
      ),
    );
  }
}
