import 'package:cash_manager/models/account_transaction.dart';
import 'package:cash_manager/models/dto/account_transaction_dto.dart';
import 'package:cash_manager/services/account_service.dart';
import 'package:cash_manager/services/transaction_category_service.dart';
import 'package:cash_manager/services/database/repositories/account_transaction_repository.dart';

class AccountTransactionService {
  static Future<void> createTransaction(
      AccountTransactionDTO transaction) async {
    await AccountTransactionRepository.create(transaction);
    if (transaction.type) {
      AccountService.addBalance(transaction.accountId, transaction.amount);
    } else {
      AccountService.removeBalance(transaction.accountId, transaction.amount);
    }
  }

  static Future<List<AccountTransaction>> getMonthTransactionsByType(
      DateTime date, bool type) async {
    List<Map<String, dynamic>> transactionResponse =
        await AccountTransactionRepository.getMonthTransactionsByType(
            date, type);

    List<AccountTransaction> transactions = [];
    for (Map<String, dynamic> transactionItem in transactionResponse) {
      AccountTransaction transaction =
          AccountTransaction.fromMap(transactionItem);
      transaction.category = await TransactionCategoryService.findById(
          transactionItem['category_id']);
      transaction.account =
          await AccountService.findById(transactionItem['account_id']);
      transactions.add(transaction);
    }

    return transactions;
  }

  static Future<List<AccountTransaction>> getMonthTransactions(
      DateTime date) async {
    List<Map<String, dynamic>> transactionResponse =
        await AccountTransactionRepository.getMonthTransactions(date);

    List<AccountTransaction> transactions = [];
    for (Map<String, dynamic> transactionItem in transactionResponse) {
      AccountTransaction transaction =
          AccountTransaction.fromMap(transactionItem);
      transaction.category = await TransactionCategoryService.findById(
          transactionItem['category_id']);
      transaction.account =
          await AccountService.findById(transactionItem['account_id']);
      transactions.add(transaction);
    }

    return transactions;
  }
}
