import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:cash_manager/services/database/queries/account_query.dart';
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
    await db?.insert(_tableName, values);
  }

  static Future<List<CreditCard>> selectCreditCards() async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result = await db?.query(_tableName);

    List<CreditCard> cards = [];
    for (Map<String, Object?> item in result!) {
      CreditCard creditCard = CreditCard.fromMap(item);
      creditCard.account = await AccountQuery.getAccount(creditCard.accountId);
      cards.add(creditCard);
    }
    return cards;
  }
}
