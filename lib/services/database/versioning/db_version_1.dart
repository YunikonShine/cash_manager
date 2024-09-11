import 'package:sqflite/sqflite.dart';

class DBVersion1 {
  static Future<void> dbUpdatesVersion(Database db) async {
    await db.execute(
        "CREATE TABLE banks ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, icon TEXT NOT NULL, color TEXT NOT NULL )");
    await db.execute(
        "CREATE TABLE accounts ( id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT NOT NULL, balance REAL NOT NULL, initial_balance REAL NOT NULL, type INTEGER NOT NULL, color TEXT NOT NULL, bank_id INTEGER NOT NULL, FOREIGN KEY (bank_id) REFERENCES banks (id) )");
    await db.execute(
        "CREATE TABLE account_transactions ( id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT NOT NULL, date INTEGER NOT NULL, amount REAL NOT NULL, type INTEGER NOT NULL, category_id INTEGER NOT NULL, account_id INTEGER NOT NULL, created_at INTEGER NOT NULL, FOREIGN KEY (category_id) REFERENCES categories (id), FOREIGN KEY (account_id) REFERENCES accounts (id) )");
    await db.execute(
        "CREATE TABLE card_transactions ( id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT NOT NULL, date INTEGER NOT NULL, amount REAL NOT NULL, category_id INTEGER NOT NULL, invoice_id INTEGER NOT NULL, recurrence INTEGER NOT NULL, created_at INTEGER NOT NULL, FOREIGN KEY (category_id) REFERENCES categories (id), FOREIGN KEY (invoice_id) REFERENCES invoices (id) )");
    await db.execute(
        "CREATE TABLE cards ( id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT NOT NULL, amount_limit REAL NOT NULL, close_date INTEGER NOT NULL, due_date INTEGER NOT NULL, brand INTEGER NOT NULL, account_id INTEGER NOT NULL, FOREIGN KEY (account_id) REFERENCES accounts (id) )");
    await db.execute(
        "CREATE TABLE categories ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, icon TEXT NOT NULL, type INTEGER NOT NULL )");
    await db.execute(
        "CREATE TABLE invoices ( id INTEGER PRIMARY KEY AUTOINCREMENT, open_date INTEGER NOT NULL, close_date INTEGER NOT NULL, due_date INTEGER NOT NULL, amount REAL NOT NULL, status INTEGER NOT NULL, card_id INTEGER NOT NULL, FOREIGN KEY (card_id) REFERENCES cards (id) )");

    // await db.execute(
    //     "CREATE TABLE card_transaction ( card_id INTEGER NOT NULL, transaction_id INTEGER NOT NULL, FOREIGN KEY (card_id) REFERENCES cards (id), FOREIGN KEY (transaction_id) REFERENCES transactions (id) )");
    // await db.execute(
    //     "CREATE TABLE account_transaction ( account_id INTEGER NOT NULL, transaction_id INTEGER NOT NULL, FOREIGN KEY (account_id) REFERENCES transactions (id), FOREIGN KEY (transaction_id) REFERENCES accounts (id) )");
  }
}
