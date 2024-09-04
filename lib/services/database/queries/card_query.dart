import 'package:cash_manager/services/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class AccountQuery {
  static const String _tableName = 'cards';

  static Future<void> createCard(
      String name, num balance, String icon, int account) async {
    Database? db = await DatabaseConnection.instance.database;
    Map<String, Object?> values = {
      "name": name,
      "limit": balance,
      "icon": icon,
      "account": account,
    };
    await db?.insert(_tableName, values);
  }
}
