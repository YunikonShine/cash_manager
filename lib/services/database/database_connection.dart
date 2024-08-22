import 'versioning/db_version_1.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  static DatabaseConnection? _instance;

  static Database? _dbInstance;
  static const int _databaseVersion = 1;
  static const String _databaseName = 'cash_manager.db';

  static Future<Database?> getDatabase() async {
    if (_dbInstance == null) {
      _dbInstance = await openDatabase(_databaseName);

      _dbInstance = await openDatabase(
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
    }

    return _dbInstance;
  }

  static Future<void> _performDBUpgrade(
      Database db, int upgradeToVersion) async {
    switch (upgradeToVersion) {
      case 1:
        await DBVersion1.dbUpdatesVersion(db);
        break;
    }
  }

  DatabaseConnection._();

  static DatabaseConnection get instance {
    return _instance ??= DatabaseConnection._();
  }
}
