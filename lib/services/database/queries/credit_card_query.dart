import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/selection_item.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:cash_manager/services/database/queries/account_query.dart';
import 'package:cash_manager/services/database/queries/invoice_query.dart';
import 'package:sqflite/sqflite.dart';

class CreditCardQuery {
  static const String _tableName = 'cards';

  static Future<void> createCreditCard(CreditCard creditCard) async {
    Database? db = await DatabaseConnection.instance.database;
    Map<String, Object?> values = {
      "description": creditCard.description,
      "amount_limit": creditCard.limit,
      "close_date": creditCard.closeDate,
      "due_date": creditCard.dueDate,
      "brand": creditCard.brand,
      "account_id": creditCard.accountId,
    };
    creditCard.id = await db?.insert(_tableName, values);
    await InvoiceQuery.createInvoiceByCard(creditCard);
  }

  static Future<List<CreditCard>> findAll() async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result = await db?.query(_tableName);

    List<CreditCard> cards = [];
    for (Map<String, Object?> item in result!) {
      cards.add(CreditCard.fromMap(item));
    }
    return cards;
  }

  static Future<List<CreditCard>> selectCreditCards(bool open) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result = await db?.query(_tableName);

    List<CreditCard> cards = [];
    for (Map<String, Object?> item in result!) {
      CreditCard creditCard = CreditCard.fromMap(item);
      creditCard.account = await AccountQuery.getAccount(creditCard.accountId);
      if (open) {
        creditCard.currentInvoice =
            await InvoiceQuery.getOpenByCard(creditCard);
      } else {
        creditCard.currentInvoice =
            await InvoiceQuery.getClosedByCard(creditCard);
      }
      cards.add(creditCard);
    }
    return cards;
  }

  static Future<List<SelectionItem>> selectSelectionItems() async {
    List<CreditCard> cards = await selectCreditCards(true);
    return SelectionItem.fromCreditCards(cards);
  }

  static Future<CreditCard> getCreditCard(int id) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result =
        await db?.query(_tableName, where: 'id = ?', whereArgs: [id]);

    return CreditCard.fromMap(result![0]);
  }
}
