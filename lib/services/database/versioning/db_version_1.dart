import 'package:sqflite/sqflite.dart';

class DBVersion1 {
  static Future<void> dbUpdatesVersion(Database db) async {
    await db.execute(
        "CREATE TABLE banks ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, icon TEXT NOT NULL, color TEXT NOT NULL )");
    await db.execute(
        "CREATE TABLE accounts ( id INTEGER PRIMARY KEY AUTOINCREMENT, desciption TEXT NOT NULL, balance REAL NOT NULL, initial_balance REAL NOT NULL, type INT NOT NULL, color TEXT NOT NULL, bank_id INT NOT NULL, FOREIGN KEY (bank_id) REFERENCES banks (id) )");
    await db.execute(
        "CREATE TABLE transactions ( id INTEGER PRIMARY KEY AUTOINCREMENT, amount REAL NOT NULL, type REAL NOT NULL )");
    await db.execute(
        "CREATE TABLE cards ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, amount_limit REAL NOT NULL, icon TEXT NOT NULL, account_id INT NOT NULL, FOREIGN KEY (account_id) REFERENCES accounts (id) )");

    await db.execute(
        "CREATE TABLE card_transaction ( card_id INT NOT NULL, transaction_id INT NOT NULL, FOREIGN KEY (card_id) REFERENCES cards (id), FOREIGN KEY (transaction_id) REFERENCES transactions (id) )");
    await db.execute(
        "CREATE TABLE account_transaction ( account_id INT NOT NULL, transaction_id INT NOT NULL, FOREIGN KEY (account_id) REFERENCES transactions (id), FOREIGN KEY (transaction_id) REFERENCES accounts (id) )");
  }
}
