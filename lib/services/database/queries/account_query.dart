import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class AccountQuery {
  static const String _tableName = 'accounts';

  static Future<void> createAccount(Account account) async {
    Database? db = await DatabaseConnection.instance.database;
    Map<String, Object?> values = {
      "inital_balance": account.balance,
      "balance": account.balance,
      "bank_id": account.bankId,
      "color": account.color,
      "desciption": account.desciption,
      "type": account.type,
    };
    await db?.insert(_tableName, values);
  }

  static Future<List<Account>> selectAccounts() async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result = await db?.query(_tableName);

    List<Account> accounts = [];
    result?.forEach((item) {
      accounts.add(Account.fromMap(item));
    });

    return accounts;
  }
}
