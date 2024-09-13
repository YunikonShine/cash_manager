import 'package:cash_manager/models/enum/calculator_type.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({
    super.key,
    required this.onClick,
    required this.balance,
    this.type = CalculatorType.normal,
  });

  final Function(double) onClick;
  final double balance;
  final CalculatorType type;

  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  late String _totalText;

  List<List<String>> actions = [
    ["7", "8", "9", "+"],
    ["4", "5", "6", "-"],
    ["1", "2", "3", "*"],
    [",", "0", "=", "/"],
  ];

  @override
  void initState() {
    super.initState();
    _totalText = widget.balance.toStringAsFixed(2);
    _totalText = _totalText.replaceAll(".", ",");
  }

  _addText(String text) {
    setState(() {
      int length = _totalText.length;
      String lastChar = _totalText.substring(length - 1);
      List<String> ex = ["+", "-", "*", "/"];

      if (text == "=") {
        Parser p = Parser();
        _totalText = _totalText.replaceAll(",", ".");
        _totalText = p
            .parse(_totalText)
            .evaluate(EvaluationType.REAL, ContextModel())
            .toStringAsFixed(2);
        _totalText = _totalText.replaceAll(".", ",");
      } else if (_totalText == "0,00") {
        _totalText = text;
      } else if (text == "," &&
          ex.where((element) => element == lastChar).isNotEmpty) {
        _totalText += "0$text";
      } else {
        _totalText += text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      alignment: Alignment.bottomCenter,
      content: Box(
        bottom: false,
        width: 100,
        height: 450,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0x32A3A3A3),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "R\$",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        _totalText,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 32,
                        ),
                      ),
                      IconButton(
                        onPressed: () => {},
                        icon: const Icon(
                          FontAwesomeIcons.deleteLeft,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            for (List<String> rows in actions)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (String item in rows)
                    InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                      onTap: () => _addText(item),
                      child: SizedBox(
                        height: 70,
                        width: (MediaQuery.of(context).size.width * 20) / 100,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 150,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          width: 2.0,
                          color: widget.type.color,
                        ),
                      ),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                          color: widget.type.color,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: () {
                        _addText("=");
                        widget.onClick(
                            double.parse(_totalText.replaceAll(",", ".")));
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(widget.type.color),
                      ),
                      child: const Text(
                        "Confirmar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
