import 'package:cash_manager/services/database/versioning/db_version_2.dart';

import 'versioning/db_version_1.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  static DatabaseConnection? _instance;

  static Database? _database;
  static const int _databaseVersion = 2;
  static const String _databaseName = 'cash_manager.db';

  Future<Database?> get database async {
    //TODO Remover
    // databaseFactory.deleteDatabase(_databaseName);
    _database = null;

    _database ??= await openDatabase(
      _databaseName,
      version: _databaseVersion,
      onUpgrade: (db, oldVersion, newVersion) async {
        for (int version = oldVersion; version < newVersion; version++) {
          await _performDBUpgrade(db, version + 1);
        }
      },
      onCreate: (db, newVersion) async {
        for (int version = 0; version < newVersion; version++) {
          await _performDBUpgrade(db, version + 1);
        }
      },
    );

    return _database;
  }

  static Future<void> _performDBUpgrade(
      Database db, int upgradeToVersion) async {
    switch (upgradeToVersion) {
      case 1:
        await DBVersion1.dbUpdatesVersion(db);
        break;
      case 2:
        await DBVersion2.dbUpdatesVersion(db);
        break;
    }
  }

  DatabaseConnection._();

  static DatabaseConnection get instance {
    return _instance ??= DatabaseConnection._();
  }
}
