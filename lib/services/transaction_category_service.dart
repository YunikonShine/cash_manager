import 'package:cash_manager/models/transaction_category.dart';
import 'package:cash_manager/services/database/repositories/transaction_category_repository.dart';

class TransactionCategoryService {
  static Future<TransactionCategory> findById(int categoryId) async {
    Map<String, dynamic>? categoryResponse =
        await TransactionCategoryRepository.findById(categoryId);
    if (categoryResponse == null) {
      throw Exception("Category not found");
    }
    return TransactionCategory.fromMap(categoryResponse);
  }

  static Future<List<TransactionCategory>> findByType(bool type) async {
    List<Map<String, dynamic>> categoryResponse =
        await TransactionCategoryRepository.findByType(type);

    List<TransactionCategory> categories = [];
    for (Map<String, dynamic> categoryItem in categoryResponse) {
      categories.add(TransactionCategory.fromMap(categoryItem));
    }

    return categories;
  }
}
