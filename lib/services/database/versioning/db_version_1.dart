import 'package:sqflite/sqflite.dart';

class DBVersion1 {
  static Future<void> dbUpdatesVersion(Database db) async {
    await db.execute(
        'CREATE TABLE accounts ( id INT NOT NULL, name TEXT NOT NULL, balance REAL NOT NULL, icon TEXT NOT NULL, PRIMARY KEY (id) )');
    await db.execute(
        'CREATE TABLE transactions ( id INT NOT NULL, amount REAL NOT NULL, type REAL NOT NULL, PRIMARY KEY (id) )');
    await db.execute(
        'CREATE TABLE cards ( id INT NOT NULL, name TEXT NOT NULL, limit REAL NOT NULL, icon TEXT NOT NULL, account_id INT NOT NULL, PRIMARY KEY (id), FOREIGN KEY (account_id) REFERENCES accounts (id) )');

    await db.execute(
        'CREATE TABLE card_transaction ( id INT NOT NULL, id INT NOT NULL FOREIGN KEY (id) REFERENCES cards (id), FOREIGN KEY (id) REFERENCES transactions (id) )');
    await db.execute(
        'CREATE TABLE account_transaction ( id INT NOT NULL, id INT NOT NULL FOREIGN KEY (id) REFERENCES transactions (id), FOREIGN KEY (id) REFERENCES accounts (id) )');
  }
}
