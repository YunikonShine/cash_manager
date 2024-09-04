import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/account_type.dart';
import 'package:cash_manager/models/bank.dart';
import 'package:cash_manager/models/card_brand.dart';
import 'package:cash_manager/models/credit_card.dart';
import 'package:flutter/material.dart';

class SelectionItem {
  int? id;
  String? name;
  IconData? icon;
  ImageProvider<Object>? image;
  String? color;
  double? amount;

  SelectionItem(
      {this.id, this.name, this.icon, this.image, this.color, this.amount});

  static List<SelectionItem> fromAccountTypes() {
    List<SelectionItem> item = [];
    for (AccountType i in AccountType.values) {
      item.add(SelectionItem(id: i.id, name: i.name, icon: i.icon));
    }
    return item;
  }

  static List<SelectionItem> fromCardBrands() {
    List<SelectionItem> item = [];
    for (CardBrand i in CardBrand.values) {
      item.add(SelectionItem(id: i.id, name: i.name, icon: i.icon));
    }
    return item;
  }

  static List<SelectionItem> fromBanks(List<Bank> banks) {
    List<SelectionItem> item = [];
    for (Bank bank in banks) {
      item.add(
        SelectionItem(
          id: bank.id,
          name: bank.name,
          image: AssetImage("assets/banks/${bank.icon}.png"),
          color: bank.color,
        ),
      );
    }
    return item;
  }

  static List<SelectionItem> fromAccounts(List<Account> accounts) {
    List<SelectionItem> item = [];
    for (Account account in accounts) {
      item.add(
        SelectionItem(
          id: account.id,
          name: account.description,
          image: AssetImage("assets/banks/${account.bank?.icon}.png"),
          amount: account.balance,
        ),
      );
    }
    return item;
  }

  static List<SelectionItem> fromCreditCards(List<CreditCard> cards) {
    List<SelectionItem> item = [];
    for (CreditCard card in cards) {
      item.add(
        SelectionItem(
          id: card.id,
          name: card.description,
          image: AssetImage(
              "assets/card_brands/${CardBrandHelper.fromId(card.brand).image}.png"),
          amount: card.limit,
        ),
      );
    }
    return item;
  }
}
