import 'package:cash_manager/widgets/box.dart';
import 'package:flutter/material.dart';

class EmptyBox extends StatefulWidget {
  const EmptyBox({
    super.key,
    required this.name,
    required this.icon,
    required this.emptyText,
    required this.buttonText,
    required this.onClick,
  });

  final String name;
  final IconData icon;
  final String emptyText;
  final String buttonText;
  final VoidCallback onClick;

  @override
  EmptyBoxState createState() => EmptyBoxState();
}

class EmptyBoxState extends State<EmptyBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 25,
            bottom: 15,
          ),
          width: (MediaQuery.of(context).size.width * 90) / 100,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              Icon(
                widget.icon,
                color: Colors.grey,
                size: 18,
              ),
            ],
          ),
        ),
        Box(
          width: 90,
          top: true,
          child: Column(
            children: [
              Icon(
                widget.icon,
                color: Colors.grey,
                size: 26,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 20,
                ),
                child: Text(
                  widget.emptyText,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: widget.onClick,
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.purple,
                  ),
                ),
                child: Text(
                  widget.buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
