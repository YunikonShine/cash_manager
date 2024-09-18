import 'package:cash_manager/models/card_transaction.dart';
import 'package:cash_manager/models/dto/card_transaction_dto.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/services/transaction_category_service.dart';
import 'package:cash_manager/services/database/repositories/card_transaction_repository.dart';
import 'package:cash_manager/services/invoice_service.dart';

class CardTransactionService {
  static Future<void> createTransaction(CardTransactionDTO transaction) async {
    await CardTransactionRepository.create(transaction);
    await InvoiceService.addBalance(transaction.invoiceId, transaction.amount);
  }

  static Future<List<CardTransaction>> getTransactionsByInvoice(
      Invoice invoice) async {
    List<Map<String, dynamic>> transactionResponse =
        await CardTransactionRepository.getTransactionsByInvoice(invoice.id);

    List<CardTransaction> transactions = [];
    for (Map<String, dynamic> transactionItem in transactionResponse) {
      CardTransaction transaction = CardTransaction.fromMap(transactionItem);
      transaction.category = await TransactionCategoryService.findById(
          transactionItem['category_id']);
      transaction.invoice =
          await InvoiceService.findById(transactionItem['invoice_id']);
      transactions.add(transaction);
    }

    return transactions;
  }

  static Future<List<CardTransaction>> findAll() async {
    List<Map<String, dynamic>> transactionResponse =
        await CardTransactionRepository.findAll();

    List<CardTransaction> transactions = [];
    for (Map<String, dynamic> transactionItem in transactionResponse) {
      CardTransaction transaction = CardTransaction.fromMap(transactionItem);
      transaction.category = await TransactionCategoryService.findById(
          transactionItem['category_id']);
      transaction.invoice =
          await InvoiceService.findById(transactionItem['invoice_id']);
      transactions.add(transaction);
    }

    return transactions;
  }
}
