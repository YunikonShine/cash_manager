import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/dto/account_dto.dart';
import 'package:cash_manager/services/bank_service.dart';
import 'package:cash_manager/services/database/repositories/account_repository.dart';

class AccountService {
  static Future<void> createAccount(AccountDTO account) async {
    await AccountRepository.create(account);
  }

  static Future<Account> findById(int accountId) async {
    Map<String, dynamic>? accountResponse =
        await AccountRepository.findById(accountId);

    if (accountResponse == null) {
      throw Exception("Account not found");
    }
    Account account = Account.fromMap(accountResponse);
    account.bank = await BankService.findById(accountResponse['bank_id']);

    return account;
  }

  static Future<List<Account>> findAll() async {
    List<Map<String, dynamic>> accountResponse =
        await AccountRepository.findAll();

    List<Account> accounts = [];
    for (Map<String, dynamic> accountItem in accountResponse) {
      Account account = Account.fromMap(accountItem);
      account.bank = await BankService.findById(accountItem['bank_id']);
      accounts.add(account);
    }

    return accounts;
  }

  static Future<void> addBalance(int accountId, double amount) async {
    Account account = await findById(accountId);
    account.balance += amount;
    await AccountRepository.update(account);
  }

  static Future<void> removeBalance(int accountId, double amount) async {
    Account account = await findById(accountId);
    account.balance -= amount;
    await AccountRepository.update(account);
  }
}
