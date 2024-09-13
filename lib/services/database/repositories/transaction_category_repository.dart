import 'package:cash_manager/services/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class TransactionCategoryRepository {
  static const String _tableName = 'categories';

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

  static Future<List<Map<String, dynamic>>> findByType(
      bool categoryType) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, dynamic>>? result = await db?.query(
      _tableName,
      where: 'type = ?',
      whereArgs: [
        categoryType,
      ],
    );

    if (result == null) {
      throw Exception("Database error");
    }

    return result;
  }
}
