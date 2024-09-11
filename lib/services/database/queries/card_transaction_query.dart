import 'package:cash_manager/models/card_transaction.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:cash_manager/services/database/queries/category_query.dart';
import 'package:cash_manager/services/database/queries/invoice_query.dart';
import 'package:sqflite/sqflite.dart';

class CardTransactionQuery {
  static const String _tableName = 'card_transactions';

  static Future<void> createTransaction(CardTransaction transaction) async {
    Database? db = await DatabaseConnection.instance.database;
    Map<String, Object?> values = {
      "description": transaction.description,
      "amount": transaction.amount,
      "date": transaction.date.microsecondsSinceEpoch,
      "category_id": transaction.categoryId,
      "invoice_id": transaction.invoice!.id!,
      "recurrence": transaction.recurrence,
      "created_at": DateTime.now().microsecondsSinceEpoch
    };
    await db?.insert(_tableName, values);
    await InvoiceQuery.addAmount(transaction.invoice!, transaction.amount);
  }

  static Future<List<CardTransaction>> getTransactionByInvoice(
      int invoiceId) async {
    Database? db = await DatabaseConnection.instance.database;

    List<Map<String, dynamic>>? result = await db?.query(
      _tableName,
      where: 'invoice_id = ?',
      whereArgs: [invoiceId],
      orderBy: 'created_at',
    );

    List<CardTransaction> transactions = [];
    for (Map<String, Object?> item in result!) {
      CardTransaction transaction = CardTransaction.fromMap(item);
      transaction.category =
          await CategoryQuery.getCategory(transaction.categoryId);
      transactions.add(transaction);
    }

    return transactions;
  }
}
