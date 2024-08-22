import 'package:cash_manager/services/database/database_connection.dart';

class AccountQuery {
  static const String _tableName = 'cards';

  static Future<void> createCard(
      String name, num balance, String icon, int account) async {
    var db = await DatabaseConnection.getDatabase();
    Map<String, Object?> values = {
      "name": name,
      "limit": balance,
      "icon": icon,
      "account": account,
    };
    await db?.insert(_tableName, values);
  }
}
