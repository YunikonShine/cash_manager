import 'package:cash_manager/models/card_recurrence_transaction.dart';
import 'package:cash_manager/models/dto/card_recurrence_transaction_dto.dart';
import 'package:cash_manager/models/dto/card_transaction_dto.dart';
import 'package:cash_manager/models/enum/invoice_status.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/services/card_transaction_service.dart';
import 'package:cash_manager/services/credit_card_service.dart';
import 'package:cash_manager/services/database/repositories/card_recurrence_transaction_repository.dart';
import 'package:cash_manager/services/invoice_service.dart';
import 'package:cash_manager/services/transaction_category_service.dart';
import 'package:intl/intl.dart';

class CardRecurrenceTransactionService {
  static Future<void> createTransaction(CardTransactionDTO transaction) async {
    CardRecurrenceTransactionDTO transactionDTO = CardRecurrenceTransactionDTO(
      description: transaction.description,
      amount: transaction.amount,
      day: transaction.date.day,
      categoryId: transaction.categoryId,
      lastDateCreated: _getStartOfTheDay(transaction.date),
      creditCardId: transaction.creditCardId,
    );

    await CardRecurrenceTransactionRepository.create(transactionDTO);
  }

  static Future<List<CardRecurrenceTransaction>> findAll() async {
    List<Map<String, dynamic>> transactionResponse =
        await CardRecurrenceTransactionRepository.findAll();

    List<CardRecurrenceTransaction> transactions = [];
    for (Map<String, dynamic> transactionItem in transactionResponse) {
      CardRecurrenceTransaction transaction =
          CardRecurrenceTransaction.fromMap(transactionItem);
      transaction.category = await TransactionCategoryService.findById(
          transactionItem['category_id']);
      transaction.creditCard =
          await CreditCardService.findById(transactionItem['card_id']);
      transactions.add(transaction);
    }

    return transactions;
  }

  static Future<void> createMonthlyRecurrence() async {
    DateTime now = _getStartOfTheDay(DateTime.now());

    List<CardRecurrenceTransaction> recurrences = await findAll();

    for (CardRecurrenceTransaction recurrence in recurrences) {
      DateTime lastDateCreated = recurrence.lastDateCreated;
      DateTime nextDate = DateTime(
          lastDateCreated.year, lastDateCreated.month + 1, lastDateCreated.day);

      while (nextDate.isBefore(now) || nextDate.isAtSameMomentAs(now)) {
        InvoiceStatus status =
            nextDate.isAtSameMomentAs(now) || nextDate.isAfter(now)
                ? InvoiceStatus.open
                : InvoiceStatus.close;

        Invoice activeInvoice = await InvoiceService.findOrCreateUnpaid(
            recurrence.creditCard, nextDate, status);

        DateTime date = DateTime(nextDate.year, nextDate.month, recurrence.day);

        CardTransactionDTO cardTransaction = CardTransactionDTO(
          description: recurrence.description,
          date: date,
          amount: recurrence.amount,
          categoryId: recurrence.category.id,
          invoiceId: activeInvoice.id,
          creditCardId: recurrence.creditCard.id,
        );

        await CardTransactionService.createTransaction(cardTransaction);

        recurrence.lastDateCreated = nextDate;
        nextDate = DateTime(nextDate.year, nextDate.month + 1, nextDate.day);
      }

      await CardRecurrenceTransactionRepository.update(recurrence);
    }
  }

  static DateTime _getStartOfTheDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
