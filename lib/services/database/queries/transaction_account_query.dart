import 'package:cash_manager/models/transaction_account.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:cash_manager/services/database/queries/account_query.dart';
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
    Database? db = await DatabaseConnection.instance.database;

    int firstDay = DateTime(date.year, date.month, 1).microsecondsSinceEpoch;
    int lastDay = DateTime(date.year, date.month + 1, 0).microsecondsSinceEpoch;

    List<Map<String, dynamic>>? result = await db?.query(_tableName,
        where: 'type = ? AND date >= ? AND date <= ?',
        whereArgs: [type, firstDay, lastDay]);

    double total = 0;
    result?.forEach((item) {
      total += item['amount'];
    });

    return total;
  }
}
