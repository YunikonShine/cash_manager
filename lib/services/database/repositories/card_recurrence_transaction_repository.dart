import 'package:cash_manager/models/card_recurrence_transaction.dart';
import 'package:cash_manager/models/dto/card_recurrence_transaction_dto.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class CardRecurrenceTransactionRepository {
  static const String _tableName = 'card_recurrence_transactions';

  static Future<void> create(CardRecurrenceTransactionDTO transaction) async {
    Database? db = await DatabaseConnection.instance.database;
    int? id = await db?.insert(_tableName, transaction.toMap());
    if (id == null) {
      throw Exception("Can't create card reccurence transaction");
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

  static Future<void> update(CardRecurrenceTransaction trasaction) async {
    Database? db = await DatabaseConnection.instance.database;
    int? id = await db?.update(
      _tableName,
      trasaction.toMap(),
      where: 'id = ?',
      whereArgs: [
        trasaction.id,
      ],
    );
    if (id == null) {
      throw Exception("Can't update invoice");
    }
  }
}
