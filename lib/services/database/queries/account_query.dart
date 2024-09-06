import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/selection_item.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:cash_manager/services/database/queries/bank_query.dart';
import 'package:sqflite/sqflite.dart';

class AccountQuery {
  static const String _tableName = 'accounts';

  static Future<void> createAccount(Account account) async {
    Database? db = await DatabaseConnection.instance.database;
    Map<String, Object?> values = {
      "initial_balance": account.balance,
      "balance": account.balance,
      "bank_id": account.bankId,
      "color": account.color,
      "description": account.description,
      "type": account.type,
    };
    await db?.insert(_tableName, values);
  }

  static Future<List<Account>> selectAccounts() async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result = await db?.query(_tableName);

    List<Account> accounts = [];
    for (Map<String, Object?> item in result!) {
      Account account = Account.fromMap(item);
      account.bank = await BankQuery.getBank(account.bankId);
      accounts.add(account);
    }
    return accounts;
  }

  static Future<List<SelectionItem>> selectSelectionItems() async {
    List<Account> accounts = await selectAccounts();
    return SelectionItem.fromAccounts(accounts);
  }

  static Future<Account> getAccount(int id) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result =
        await db?.query(_tableName, where: 'id = ?', whereArgs: [id]);

    return Account.fromMap(result![0]);
  }

  static Future<void> addBalance(int id, double amount) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result =
        await db?.query(_tableName, where: 'id = ?', whereArgs: [id]);

    Account account = Account.fromMap(result![0]);
    account.balance += amount;

    Map<String, Object?> values = {
      "balance": account.balance,
    };
    await db?.update(_tableName, values, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> removeBalance(int id, double amount) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result =
        await db?.query(_tableName, where: 'id = ?', whereArgs: [id]);

    Account account = Account.fromMap(result![0]);
    account.balance -= amount;

    Map<String, Object?> values = {
      "balance": account.balance,
    };
    await db?.update(_tableName, values, where: 'id = ?', whereArgs: [id]);
  }
}
