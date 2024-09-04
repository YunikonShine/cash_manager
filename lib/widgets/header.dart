import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 25,
        ),
        height: (MediaQuery.of(context).size.height * 10) / 100,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            const Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.grey,
              size: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 30,
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
