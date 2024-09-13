import 'package:cash_manager/services/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class CardBrandRepository {
  static const String _tableName = 'card_brands';

  static Future<Map<String, dynamic>?> findById(int categoryId) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, dynamic>>? result = await db?.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [
        categoryId,
      ],
    );

    return result?[0];
  }

  static Future<List<Map<String, dynamic>>> findAll() async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, dynamic>>? result = await db?.query(_tableName);
    if (result == null) {
      throw Exception("Database error");
    }
    return result;
  }
}
