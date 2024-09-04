import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum AccountType {
  checkingAccount,
  wallet,
  saving,
  investment,
  other,
}

extension AccountTypeExtension on AccountType {
  String get name {
    switch (this) {
      case AccountType.checkingAccount:
        return 'Conta corrente';
      case AccountType.wallet:
        return 'Carteira';
      case AccountType.saving:
        return 'Poupança';
      case AccountType.investment:
        return 'Investimento';
      case AccountType.other:
      default:
        return 'Outro';
    }
  }

  int get id {
    switch (this) {
      case AccountType.checkingAccount:
        return 1;
      case AccountType.wallet:
        return 2;
      case AccountType.saving:
        return 3;
      case AccountType.investment:
        return 4;
      case AccountType.other:
      default:
        return 5;
    }
  }

  IconData get icon {
    switch (this) {
      case AccountType.checkingAccount:
        return FontAwesomeIcons.buildingColumns;
      case AccountType.wallet:
        return FontAwesomeIcons.wallet;
      case AccountType.saving:
        return FontAwesomeIcons.piggyBank;
      case AccountType.investment:
        return FontAwesomeIcons.arrowTrendUp;
      case AccountType.other:
      default:
        return FontAwesomeIcons.ellipsis;
    }
  }
}
