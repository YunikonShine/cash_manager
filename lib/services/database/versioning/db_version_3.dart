import 'package:sqflite/sqflite.dart';

class DBVersion3 {
  static Future<void> dbUpdatesVersion(Database db) async {
    await db.execute(
        "INSERT INTO categories ( name, icon, type ) VALUES ('Salário', 'money-bill-wave', 1)");
    await db.execute(
        "INSERT INTO categories ( name, icon, type ) VALUES ('Streaming', 'tv', 0)");
  }
}
