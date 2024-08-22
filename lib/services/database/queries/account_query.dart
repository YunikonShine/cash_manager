import 'package:cash_manager/services/database/database_connection.dart';

class AccountQuery {
  static const String _tableName = 'accounts';

  static Future<void> createAccount(
      String name, num balance, String icon) async {
    var db = await DatabaseConnection.getDatabase();
    Map<String, Object?> values = {
      "name": name,
      "balance": balance,
      "icon": icon
    };
    await db?.insert(_tableName, values);
  }
}
