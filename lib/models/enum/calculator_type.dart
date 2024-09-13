import 'package:flutter/material.dart';

enum CalculatorType {
  normal,
  income,
  expense;
}

extension CalculatorTypeExtension on CalculatorType {
  Color get color {
    switch (this) {
      case CalculatorType.normal:
        return Colors.purple;
      case CalculatorType.income:
        return Colors.green;
      case CalculatorType.expense:
        return Colors.red;
    }
  }
}
