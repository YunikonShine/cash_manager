import 'package:sqflite/sqflite.dart';

class DBVersion4 {
  static Future<void> dbUpdatesVersion(Database db) async {
    await db.execute(
        "INSERT INTO card_brands ( name, image ) VALUES ('Visa', 'visa')");
    await db.execute(
        "INSERT INTO card_brands ( name, image ) VALUES ('MasterCard', 'mastercard')");
  }
}
