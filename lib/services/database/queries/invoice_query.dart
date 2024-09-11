import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/enum/invoice_status.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:cash_manager/services/database/queries/credit_card_query.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceQuery {
  static const String _tableName = 'invoices';

  static createInvoiceByCard(CreditCard creditCard) async {
    Database? db = await DatabaseConnection.instance.database;
    Map<String, Object?> values = {
      "open_date": _getOpenDate(creditCard.closeDate).microsecondsSinceEpoch,
      "close_date": _getDate(creditCard.closeDate).microsecondsSinceEpoch,
      "due_date": _getDate(creditCard.dueDate).microsecondsSinceEpoch,
      "amount": 0,
      "status": InvoiceStatus.open.id,
      "card_id": creditCard.id!,
    };
    await db?.insert(_tableName, values);
  }

  static Future<Invoice> createInvoice(Invoice invoice) async {
    Database? db = await DatabaseConnection.instance.database;
    Map<String, Object?> values = {
      "open_date": invoice.openDate.microsecondsSinceEpoch,
      "close_date": invoice.closeDate.microsecondsSinceEpoch,
      "due_date": invoice.dueDate.microsecondsSinceEpoch,
      "amount": 0,
      "status": invoice.status.id,
      "card_id": invoice.cardId,
    };
    invoice.id = await db?.insert(_tableName, values);
    return invoice;
  }

  static DateTime _getOpenDate(int day) {
    DateTime openDate = _getDate(day);
    return DateTime(openDate.year, openDate.month - 1, openDate.day);
  }

  static DateTime _getDate(int day) {
    DateTime date = DateTime.now();
    return DateTime(date.year, date.month + 1, day - 1);
  }

  static Future<Invoice> getOpenByCard(CreditCard creditCard) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result = await db?.query(
      _tableName,
      where: 'card_id = ? AND status = ?',
      whereArgs: [creditCard.id, InvoiceStatus.open.id],
    );

    Invoice invoice = Invoice.fromMap(result![0]);
    invoice.card = creditCard;
    return invoice;
  }

  static Future<Invoice> getClosedByCard(CreditCard creditCard) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result = await db?.query(
      _tableName,
      where: 'card_id = ? AND status = ?',
      whereArgs: [creditCard.id, InvoiceStatus.close.id],
    );

    if (result == null || result.isEmpty) {
      DateTime date = DateTime.now();
      DateTime closeDate =
          DateTime(date.year, date.month, creditCard.closeDate - 1);
      DateTime openDate =
          DateTime(closeDate.year, closeDate.month - 1, closeDate.day);

      DateTime dueDate =
          DateTime(closeDate.year, closeDate.month, creditCard.dueDate);

      return Invoice(
        openDate: openDate,
        closeDate: closeDate,
        dueDate: dueDate,
        amount: 0,
        cardId: creditCard.id!,
        card: creditCard,
        status: InvoiceStatus.close,
      );
    }

    Invoice invoice = Invoice.fromMap(result[0]);
    invoice.card = creditCard;
    return invoice;
  }

  static Future<Invoice> getByCardIdAndDate(
      int creditCardId, DateTime date) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result = await db?.query(
      _tableName,
      where: 'card_id = ? AND open_date <= ? AND close_date >= ?',
      whereArgs: [
        creditCardId,
        date.microsecondsSinceEpoch,
        date.microsecondsSinceEpoch,
      ],
    );

    if (result == null || result.isEmpty) {
      CreditCard creditCard = await CreditCardQuery.getCreditCard(creditCardId);

      DateTime closeDate =
          DateTime(date.year, date.month + 1, creditCard.closeDate - 1);
      DateTime openDate =
          DateTime(closeDate.year, closeDate.month, closeDate.day);

      DateTime dueDate =
          DateTime(closeDate.year, closeDate.month, creditCard.dueDate);

      InvoiceStatus status = date.isAfter(DateTime.now())
          ? InvoiceStatus.future
          : InvoiceStatus.close;

      Invoice invoice = Invoice(
        openDate: openDate,
        closeDate: closeDate,
        dueDate: dueDate,
        amount: 0,
        cardId: creditCard.id!,
        status: status,
      );
      return await createInvoice(invoice);
    }

    return Invoice.fromMap(result![0]);
  }

  static Future<Invoice> getByCardAndDate(
      CreditCard creditCard, DateTime date) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result = await db?.query(
      _tableName,
      where: 'card_id = ? AND open_date <= ? AND close_date >= ?',
      whereArgs: [
        creditCard.id,
        date.microsecondsSinceEpoch,
        date.microsecondsSinceEpoch,
      ],
    );

    if (result == null || result.isEmpty) {
      DateTime closeDate =
          DateTime(date.year, date.month + 1, creditCard.closeDate - 1);
      DateTime openDate =
          DateTime(closeDate.year, closeDate.month, closeDate.day);

      DateTime dueDate =
          DateTime(closeDate.year, closeDate.month, creditCard.dueDate);

      InvoiceStatus status = date.isAfter(DateTime.now())
          ? InvoiceStatus.future
          : InvoiceStatus.close;

      return Invoice(
        openDate: openDate,
        closeDate: closeDate,
        dueDate: dueDate,
        amount: 0,
        cardId: creditCard.id!,
        card: creditCard,
        status: status,
      );
    }

    return Invoice.fromMap(result[0]);
  }

  static addAmount(Invoice invoice, double amount) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result = await db?.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [invoice.id],
    );

    invoice = Invoice.fromMap(result![0]);

    Map<String, Object?> values = {
      "amount": invoice.amount + amount,
    };

    await db?.update(
      _tableName,
      values,
      where: 'id = ?',
      whereArgs: [invoice.id],
    );
  }
}
