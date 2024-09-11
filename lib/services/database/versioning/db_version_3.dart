import 'package:sqflite/sqflite.dart';

class DBVersion3 {
  static Future<void> dbUpdatesVersion(Database db) async {
    await db.execute(
        "INSERT INTO categories ( name, icon, type ) VALUES ('Salário', 'money-bill-wave', 1)");
    await db.execute(
        "INSERT INTO categories ( name, icon, type ) VALUES ('Streaming', 'tv', 0)");

    await db.execute(
        "INSERT INTO accounts ( description, balance, initial_balance, type, color, bank_id ) VALUES ('Nubank', 100, 100, 1, '#ff8a05be', 1)");
  }
}
