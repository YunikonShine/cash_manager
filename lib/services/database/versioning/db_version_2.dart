import 'package:sqflite/sqflite.dart';

class DBVersion2 {
  static Future<void> dbUpdatesVersion(Database db) async {
    await db.execute(
        "INSERT INTO banks ( name, icon, color ) VALUES ('Nubank', 'nubank', '#8A05BE')");
    await db.execute(
        "INSERT INTO banks ( name, icon, color ) VALUES ('Itaú', 'itau', '#FF7200')");
  }
}
