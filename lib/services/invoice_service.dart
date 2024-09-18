import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/dto/account_transaction_dto.dart';
import 'package:cash_manager/models/dto/invoice_dto.dart';
import 'package:cash_manager/models/enum/invoice_status.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/services/account_transaction_service.dart';
import 'package:cash_manager/services/credit_card_service.dart';
import 'package:cash_manager/services/database/repositories/invoice_repository.dart';

class InvoiceService {
  static Future<void> createInvoice(InvoiceDTO invoiceDTO) async {
    if (invoiceDTO.status == InvoiceStatus.open.id) {
      List<Invoice> invoices =
          await findOverdueByCreditCardAndNotOpen(invoiceDTO.cardId);
      for (Invoice invoice in invoices) {
        invoice.status = InvoiceStatus.close;
        invoice.paid = invoice.amount == 0;
        await InvoiceRepository.update(invoice);
      }
    }
    await InvoiceRepository.create(invoiceDTO);
  }

  static Future<void> createInvoiceByCreditCardAndDate(
      CreditCard creditCard, DateTime date) async {
    InvoiceStatus status =
        _getStatus(DateTime(date.year, date.month, creditCard.closeDay));

    InvoiceDTO invoiceDTO = InvoiceDTO(
      openDate: _getOpenDate(creditCard, date),
      closeDate: _getCloseDate(creditCard, date),
      dueDate: _getDueDate(creditCard, date),
      amount: 0,
      status: status.id,
      cardId: creditCard.id,
      paid: status == InvoiceStatus.close,
    );

    await createInvoice(invoiceDTO);
  }

  static Future<List<Invoice>> findOverdueByCreditCardAndNotOpen(
      int creditCardId) async {
    List<Map<String, dynamic>> invoiceResponse =
        await InvoiceRepository.findOverdueByCreditCardAndNotOpen(creditCardId);

    List<Invoice> invoices = [];
    for (Map<String, dynamic> invoiceItem in invoiceResponse) {
      Invoice invoice = Invoice.fromMap(invoiceItem);
      invoice.creditCard =
          await CreditCardService.findById(invoiceItem['card_id']);
      invoices.add(invoice);
    }

    return invoices;
  }

  static Future<List<Invoice>> findOverdueByCreditCard(int creditCardId) async {
    List<Map<String, dynamic>> invoiceResponse =
        await InvoiceRepository.findOverdueByCreditCard(creditCardId);

    List<Invoice> invoices = [];
    for (Map<String, dynamic> invoiceItem in invoiceResponse) {
      Invoice invoice = Invoice.fromMap(invoiceItem);
      invoice.creditCard =
          await CreditCardService.findById(invoiceItem['card_id']);
      invoices.add(invoice);
    }

    return invoices;
  }

  static Future<List<Invoice>> findClosedAndUnpaid() async {
    List<Map<String, dynamic>> invoiceResponse =
        await InvoiceRepository.findStatusAndPaidStatus(
            InvoiceStatus.close.id, 0);

    List<Invoice> invoices = [];
    for (Map<String, dynamic> invoiceItem in invoiceResponse) {
      Invoice invoice = Invoice.fromMap(invoiceItem);
      invoice.creditCard =
          await CreditCardService.findById(invoiceItem['card_id']);
      invoices.add(invoice);
    }

    return invoices;
  }

  static Future<Invoice> findById(int invoiceId) async {
    Map<String, dynamic>? invoiceResponse =
        await InvoiceRepository.findById(invoiceId);

    if (invoiceResponse == null) {
      throw Exception("Invoice not found");
    }

    Invoice invoice = Invoice.fromMap(invoiceResponse);
    invoice.creditCard =
        await CreditCardService.findById(invoiceResponse['card_id']);

    return invoice;
  }

  static Future<Invoice> findOrCreateUnpaid(
      CreditCard creditCard, DateTime date, InvoiceStatus status) async {
    Map<String, dynamic>? invoiceResponse =
        await InvoiceRepository.findByCreditCardAndDate(
            creditCard.id, date.microsecondsSinceEpoch);

    if (invoiceResponse == null) {
      InvoiceDTO invoiceDTO = InvoiceDTO(
        openDate: _getOpenDate(creditCard, date),
        closeDate: _getCloseDate(creditCard, date),
        dueDate: _getDueDate(creditCard, date),
        amount: 0,
        status: status.id,
        cardId: creditCard.id,
        paid: false,
      );
      if (invoiceDTO.status == InvoiceStatus.open.id) {
        List<Invoice> invoices =
            await findOverdueByCreditCard(invoiceDTO.cardId);
        for (Invoice invoice in invoices) {
          invoice.status = InvoiceStatus.close;
          invoice.paid = invoice.amount == 0;
          await InvoiceRepository.update(invoice);
        }
      }
      await InvoiceRepository.create(invoiceDTO);
      return findByCreditCardAndDate(creditCard, date);
    }

    Invoice invoice = Invoice.fromMap(invoiceResponse);
    invoice.creditCard = creditCard;

    return invoice;
  }

  static Future<Invoice> findByCreditCardAndDate(
      CreditCard creditCard, DateTime date) async {
    Map<String, dynamic>? invoiceResponse =
        await InvoiceRepository.findByCreditCardAndDate(
            creditCard.id, date.microsecondsSinceEpoch);

    if (invoiceResponse == null) {
      await createInvoiceByCreditCardAndDate(creditCard, date);
      return findByCreditCardAndDate(creditCard, date);
    }

    Invoice invoice = Invoice.fromMap(invoiceResponse);
    invoice.creditCard = creditCard;

    if (_getStartOfTheDay(date)
            .isAtSameMomentAs(_getStartOfTheDay(DateTime.now())) &&
        invoice.status != InvoiceStatus.open) {
      invoice.status = InvoiceStatus.open;
      await InvoiceRepository.update(invoice);

      List<Invoice> invoices =
          await findOverdueByCreditCard(invoice.creditCard.id);
      for (Invoice invoice in invoices) {
        invoice.status = InvoiceStatus.close;
        invoice.paid = invoice.amount == 0;
        await InvoiceRepository.update(invoice);
      }
    }

    return invoice;
  }

  static Future<void> addBalance(int invoiceId, double amount) async {
    Invoice invoice = await findById(invoiceId);
    invoice.amount += amount;
    await InvoiceRepository.update(invoice);
  }

  static Future<void> payInvoice(
      Invoice invoice, AccountTransactionDTO paymentTransaction) async {
    invoice.paid = true;
    await InvoiceRepository.update(invoice);

    await AccountTransactionService.createTransaction(paymentTransaction);
  }

  static DateTime _getOpenDate(CreditCard creditCard, DateTime date) {
    return DateTime(date.year, date.month, creditCard.closeDay);
  }

  static DateTime _getCloseDate(CreditCard creditCard, DateTime date) {
    return DateTime(date.year, date.month + 1, creditCard.closeDay - 1);
  }

  static DateTime _getDueDate(CreditCard creditCard, DateTime date) {
    return DateTime(date.year, date.month + 1, creditCard.dueDay);
  }

  static InvoiceStatus _getStatus(DateTime date) {
    DateTime now = DateTime.now();
    if (date.month == now.month && date.year == now.year) {
      return InvoiceStatus.open;
    } else if (date.isBefore(now)) {
      return InvoiceStatus.close;
    }
    return InvoiceStatus.future;
  }

  static DateTime _getStartOfTheDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
