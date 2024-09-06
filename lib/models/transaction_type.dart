import 'package:flutter/material.dart';

enum TransactionType {
  income,
  expense,
  transaction;
}

extension TransactionTypeExtension on TransactionType {
  String get name {
    switch (this) {
      case TransactionType.income:
        return 'Receitas';
      case TransactionType.expense:
        return 'Despesas';
      case TransactionType.transaction:
        return 'Transações';
    }
  }

  Color get color {
    switch (this) {
      case TransactionType.income:
        return Colors.green;
      case TransactionType.expense:
        return Colors.red;
      case TransactionType.transaction:
        return Colors.purple;
    }
  }
}

class TransactionTypeHelper {
  static TransactionType fromString(String? value) {
    for (TransactionType type in TransactionType.values) {
      if (type.toString() == value) {
        return type;
      }
    }
    return TransactionType.income;
  }
}
