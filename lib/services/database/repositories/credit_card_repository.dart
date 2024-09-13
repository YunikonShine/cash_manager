import 'package:cash_manager/models/dto/credit_card_dto.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class CreditCardRepository {
  static const String _tableName = 'cards';

  static Future<void> create(CreditCardDTO creditCard) async {
    Database? db = await DatabaseConnection.instance.database;
    int? id = await db?.insert(_tableName, creditCard.toMap());
    if (id == null) {
      throw Exception("Can't create credit card");
    }
  }

  static Future<List<Map<String, dynamic>>> findAll() async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, dynamic>>? result = await db?.query(_tableName);
    if (result == null) {
      throw Exception("Database error");
    }
    return result;
  }

  static Future<Map<String, dynamic>?> findById(int creditCardId) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, dynamic>>? result = await db?.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [
        creditCardId,
      ],
    );

    return result?[0];
  }
}
