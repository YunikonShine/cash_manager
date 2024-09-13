import 'package:cash_manager/models/dto/invoice_dto.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceRepository {
  static const String _tableName = 'invoices';

  static Future<void> create(InvoiceDTO invoice) async {
    Database? db = await DatabaseConnection.instance.database;
    int? id = await db?.insert(_tableName, invoice.toMap());
    if (id == null) {
      throw Exception("Can't create invoice");
    }
  }

  static Future<Map<String, dynamic>?> findById(int invoiceId) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, dynamic>>? result = await db?.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [
        invoiceId,
      ],
    );

    return result?[0];
  }

  static Future<Map<String, dynamic>?> findByCreditCardAndDate(
      int cardId, int date) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, dynamic>>? result = await db?.query(
      _tableName,
      where: 'card_id = ? AND open_date <= ? AND close_date >= ?',
      whereArgs: [
        cardId,
        date,
        date,
      ],
    );

    return result!.isEmpty ? null : result[0];
  }

  static Future<void> update(Invoice invoice) async {
    Database? db = await DatabaseConnection.instance.database;
    int? id = await db?.update(_tableName, invoice.toMap(),
        where: 'id = ?', whereArgs: [invoice.id]);
    if (id == null) {
      throw Exception("Can't update invoice");
    }
  }
}
