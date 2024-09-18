import 'package:cash_manager/models/dto/account_transaction_dto.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class AccountTransactionRepository {
  static const String _tableName = 'account_transactions';

  static Future<void> create(AccountTransactionDTO transaction) async {
    Database? db = await DatabaseConnection.instance.database;
    int? id = await db?.insert(_tableName, transaction.toMap());
    if (id == null) {
      throw Exception("Can't create account transaction");
    }
  }

  static Future<List<Map<String, dynamic>>> getMonthTransactionsByType(
      DateTime date, int type) async {
    Database? db = await DatabaseConnection.instance.database;

    int firstDay = DateTime(date.year, date.month, 1).microsecondsSinceEpoch;
    int lastDay = DateTime(date.year, date.month + 1, 0).microsecondsSinceEpoch;

    List<Map<String, dynamic>>? result = await db?.query(
      _tableName,
      where: 'type = ? AND date >= ? AND date <= ?',
      whereArgs: [
        type,
        firstDay,
        lastDay,
      ],
    );

    if (result == null) {
      throw Exception("Database error");
    }

    return result;
  }

  static Future<List<Map<String, dynamic>>> getMonthTransactions(
      DateTime date) async {
    Database? db = await DatabaseConnection.instance.database;

    int firstDay = DateTime(date.year, date.month, 1).microsecondsSinceEpoch;
    int lastDay = DateTime(date.year, date.month + 1, 0).microsecondsSinceEpoch;

    List<Map<String, dynamic>>? result = await db?.query(
      _tableName,
      where: 'date >= ? AND date <= ?',
      whereArgs: [
        firstDay,
        lastDay,
      ],
    );

    if (result == null) {
      throw Exception("Database error");
    }

    return result;
  }
}
