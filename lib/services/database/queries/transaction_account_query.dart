import 'package:cash_manager/models/transaction_account.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:cash_manager/services/database/queries/account_query.dart';
import 'package:cash_manager/services/database/queries/category_query.dart';
import 'package:sqflite/sqflite.dart';

class TransactionAccountQuery {
  static const String _tableName = 'account_transactions';

  static Future<void> createTransaction(TransactionAccount transaction) async {
    Database? db = await DatabaseConnection.instance.database;
    Map<String, Object?> values = {
      "description": transaction.description,
      "amount": transaction.amount,
      "type": transaction.type,
      "date": transaction.date.microsecondsSinceEpoch,
      "category_id": transaction.categoryId,
      "account_id": transaction.accountId,
      "created_at": DateTime.now().microsecondsSinceEpoch
    };
    await db?.insert(_tableName, values);
    if (transaction.type == 1) {
      await AccountQuery.addBalance(transaction.accountId, transaction.amount);
    } else {
      await AccountQuery.removeBalance(
          transaction.accountId, transaction.amount);
    }
  }

  static Future<double> getTransactionAmountUpToDate(
      DateTime date, bool type) async {
    List<TransactionAccount> result =
        await getTransactionUpToDateWithType(date, type);

    double total = 0;
    for (TransactionAccount item in result) {
      total += item.amount;
    }

    return total;
  }

  static Future<List<TransactionAccount>> getTransactionUpToDateWithType(
      DateTime date, bool type) async {
    Database? db = await DatabaseConnection.instance.database;

    int firstDay = DateTime(date.year, date.month, 1).microsecondsSinceEpoch;
    int lastDay = DateTime(date.year, date.month + 1, 0).microsecondsSinceEpoch;

    List<Map<String, dynamic>>? result = await db?.query(_tableName,
        where: 'type = ? AND date >= ? AND date <= ?',
        whereArgs: [type, firstDay, lastDay],
        orderBy: 'created_at');

    List<TransactionAccount> transactions = [];
    for (Map<String, Object?> item in result!) {
      TransactionAccount transaction = TransactionAccount.fromMap(item);
      transaction.category =
          await CategoryQuery.getCategory(transaction.categoryId);
      transaction.account =
          await AccountQuery.getAccount(transaction.accountId);
      transactions.add(transaction);
    }

    return transactions;
  }

  static Future<List<TransactionAccount>> getTransactionUpToDate(
      DateTime date) async {
    Database? db = await DatabaseConnection.instance.database;

    int firstDay = DateTime(date.year, date.month, 1).microsecondsSinceEpoch;
    int lastDay = DateTime(date.year, date.month + 1, 0).microsecondsSinceEpoch;

    List<Map<String, dynamic>>? result = await db?.query(_tableName,
        where: 'date >= ? AND date <= ?',
        whereArgs: [firstDay, lastDay],
        orderBy: 'created_at');

    List<TransactionAccount> transactions = [];
    for (Map<String, Object?> item in result!) {
      TransactionAccount transaction = TransactionAccount.fromMap(item);
      transaction.category =
          await CategoryQuery.getCategory(transaction.categoryId);
      transaction.account =
          await AccountQuery.getAccount(transaction.accountId);
      transactions.add(transaction);
    }

    return transactions;
  }
}
