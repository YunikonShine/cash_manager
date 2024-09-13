import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BankColorPicker extends StatefulWidget {
  const BankColorPicker({
    super.key,
    required this.color,
    required this.onChange,
  });

  final Color? color;
  final Function(Color) onChange;

  @override
  BankColorPickerState createState() => BankColorPickerState();
}

class BankColorPickerState extends State<BankColorPicker> {
  late Color _selectionTemp;

  @override
  void initState() {
    super.initState();
    _selectionTemp = widget.color ?? Colors.purple;
  }

  _onChangeTemp(Color color) {
    setState(() {
      _selectionTemp = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF4C4C4C),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: MediaQuery.of(context).orientation == Orientation.portrait
            ? const BorderRadius.vertical(
                top: Radius.circular(500),
                bottom: Radius.circular(100),
              )
            : const BorderRadius.horizontal(right: Radius.circular(500)),
      ),
      content: SingleChildScrollView(
        child: HueRingPicker(
          pickerColor: _selectionTemp,
          onColorChanged: _onChangeTemp,
          enableAlpha: true,
          displayThumbColor: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => widget.onChange(_selectionTemp),
          child: const Text(
            "Confirmar",
            style: TextStyle(
              color: Color(0xFFE75DFF),
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
