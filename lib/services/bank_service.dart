import 'package:cash_manager/models/bank.dart';
import 'package:cash_manager/services/database/repositories/bank_repository.dart';

class BankService {
  static Future<Bank> findById(int bankId) async {
    Map<String, dynamic>? bankResponse = await BankRepository.findById(bankId);
    if (bankResponse == null) {
      throw Exception("Bank not found");
    }
    return Bank.fromMap(bankResponse);
  }

  static Future<List<Bank>> findAll() async {
    List<Map<String, dynamic>> bankResponse = await BankRepository.findAll();

    List<Bank> banks = [];
    for (Map<String, dynamic> bankItem in bankResponse) {
      banks.add(Bank.fromMap(bankItem));
    }

    return banks;
  }
}
