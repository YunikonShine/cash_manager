import 'package:cash_manager/models/category.dart';
import 'package:cash_manager/models/selection_item.dart';
import 'package:cash_manager/services/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class CategoryQuery {
  static const String _tableName = 'categories';

  static Future<Category> getCategory(int id) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result =
        await db?.query(_tableName, where: 'id = ?', whereArgs: [id]);

    return Category.fromMap(result![0]);
  }

  static Future<List<SelectionItem>> selectSelectionItems(bool type) async {
    Database? db = await DatabaseConnection.instance.database;
    List<Map<String, Object?>>? result =
        await db?.query(_tableName, where: 'type = ?', whereArgs: [type]);

    List<Category> categories = [];
    result?.forEach((item) {
      categories.add(Category.fromMap(item));
    });

    return SelectionItem.fromCategories(categories);
  }
}
