import 'package:cash_manager/models/bank.dart';
import 'package:cash_manager/models/selection_item.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class BankQuery {
  static const String _tableName = 'banks';

  static Future<List<SelectionItem>> selectSelectionItems() async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result = await db?.query(_tableName);

    List<Bank> banks = [];
    result?.forEach((item) {
      banks.add(Bank.fromMap(item));
    });

    return SelectionItem.fromBanks(banks);
  }
}
