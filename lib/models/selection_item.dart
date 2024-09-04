import 'package:cash_manager/models/account_type.dart';
import 'package:cash_manager/models/bank.dart';
import 'package:flutter/material.dart';

class SelectionItem {
  int? id;
  String? name;
  IconData? icon;
  ImageProvider<Object>? image;
  String? color;

  SelectionItem({
    this.id,
    this.name,
    this.icon,
    this.image,
    this.color,
  });

  static Future<List<SelectionItem>> fromAccountTypes() async {
    List<SelectionItem> item = [];
    for (AccountType i in AccountType.values) {
      item.add(SelectionItem(id: i.id, name: i.name, icon: i.icon));
    }
    return item;
  }

  static Future<List<SelectionItem>> fromBanks(List<Bank> banks) async {
    List<SelectionItem> item = [];
    for (Bank bank in banks) {
      item.add(
        SelectionItem(
            id: bank.id,
            name: bank.name,
            image: AssetImage("assets/banks/${bank.icon}.png"),
            color: bank.color),
      );
    }
    return item;
  }
}
