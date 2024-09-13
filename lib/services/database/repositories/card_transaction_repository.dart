import 'package:cash_manager/models/dto/card_transaction_dto.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class CardTransactionRepository {
  static const String _tableName = 'card_transactions';

  static Future<void> create(CardTransactionDTO transaction) async {
    Database? db = await DatabaseConnection.instance.database;
    int? id = await db?.insert(_tableName, transaction.toMap());
    if (id == null) {
      throw Exception("Can't create card transaction");
    }
  }

  static Future<List<Map<String, dynamic>>> getTransactionsByInvoice(
      int invoiceId) async {
    Database? db = await DatabaseConnection.instance.database;

    List<Map<String, dynamic>>? result = await db?.query(
      _tableName,
      where: 'invoice_id = ?',
      whereArgs: [
        invoiceId,
      ],
    );

    if (result == null) {
      throw Exception("Database error");
    }

    return result;
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
