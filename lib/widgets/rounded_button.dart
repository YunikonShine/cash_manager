import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    this.onClick,
  });

  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      bottom: MediaQuery.of(context).viewInsets.bottom + 50,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  0.3,
                ),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(
                  0,
                  0,
                ),
              ),
            ],
          ),
          child: IconButton(
            style: const ButtonStyle(
              fixedSize: WidgetStatePropertyAll(
                Size(65, 65),
              ),
              backgroundColor: WidgetStatePropertyAll(
                Colors.blue,
              ),
              shape: WidgetStatePropertyAll(
                CircleBorder(),
              ),
            ),
            onPressed: onClick,
            icon: const Icon(
              FontAwesomeIcons.check,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
