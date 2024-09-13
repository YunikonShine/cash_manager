import 'package:cash_manager/models/credit_card.dart';
import 'package:cash_manager/models/dto/invoice_dto.dart';
import 'package:cash_manager/models/enum/invoice_status.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/services/credit_card_service.dart';
import 'package:cash_manager/services/database/repositories/invoice_repository.dart';

class InvoiceService {
  static Future<void> createInvoice(InvoiceDTO invoiceDTO) async {
    await InvoiceRepository.create(invoiceDTO);
  }

  static Future<void> createInvoiceByCreditCardAndDate(
      CreditCard creditCard, DateTime date) async {
    InvoiceDTO invoiceDTO = InvoiceDTO(
      openDate: _getOpenDate(creditCard, date),
      closeDate: _getCloseDate(creditCard, date),
      dueDate: _getDueDate(creditCard, date),
      amount: 0,
      status: _getStatus(date).id,
      cardId: creditCard.id,
    );

    await InvoiceRepository.create(invoiceDTO);
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

    return invoice;
  }

  static Future<void> addBalance(int invoiceId, double amount) async {
    Invoice invoice = await findById(invoiceId);
    invoice.amount += amount;
    await InvoiceRepository.update(invoice);
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
    if (date.month < now.month) {
      return InvoiceStatus.close;
    } else if (date.month > now.month) {
      return InvoiceStatus.future;
    }
    return InvoiceStatus.open;
  }
}
