import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/services/database/queries/account_query.dart';

class BalanceHelper {
  void getBalanceUpToDate(DateTime date) async {
    double totalAccount = 0;

    List<Account> accounts = await AccountQuery.selectAccounts();
    for (Account account in accounts) {
      totalAccount += account.balance;
    }
  }
}
