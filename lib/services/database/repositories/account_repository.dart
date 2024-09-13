import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/dto/account_dto.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class AccountRepository {
  static const String _tableName = 'accounts';

  static Future<void> create(AccountDTO account) async {
    Database? db = await DatabaseConnection.instance.database;
    int? id = await db?.insert(_tableName, account.toMap());
    if (id == null) {
      throw Exception("Can't create account");
    }
  }

  static Future<Map<String, dynamic>?> findById(int accountId) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, dynamic>>? result = await db?.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [
        accountId,
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

  static Future<void> update(Account account) async {
    Database? db = await DatabaseConnection.instance.database;
    int? id = await db?.update(_tableName, account.toMap(),
        where: 'id = ?', whereArgs: [account.id]);
    if (id == null) {
      throw Exception("Can't update account");
    }
  }
}
