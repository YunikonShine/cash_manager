import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/models/dto/account_transaction_dto.dart';
import 'package:cash_manager/models/dto/select_image_item.dart';
import 'package:cash_manager/models/invoice.dart';
import 'package:cash_manager/models/transaction_category.dart';
import 'package:cash_manager/services/account_service.dart';
import 'package:cash_manager/services/invoice_service.dart';
import 'package:cash_manager/services/transaction_category_service.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/insert_field.dart';
import 'package:cash_manager/widgets/insert_select_image_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class PayInvoice extends StatefulWidget {
  const PayInvoice({
    super.key,
    required this.onPop,
    required this.selectedInvoice,
  });

  final Function onPop;
  final Invoice selectedInvoice;

  @override
  PayInvoiceState createState() => PayInvoiceState();
}

class PayInvoiceState extends State<PayInvoice> {
  final _formatCurrency = NumberFormat.simpleCurrency(locale: "pt_BR");

  DateTime _selectedDate = DateTime.now();
  Account? _selectedAccount;
  List<Account> _accounts = List.empty();

  late Invoice _selectedInvoice;
  late TransactionCategory _category;

  late FToast _fToast;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedInvoice = widget.selectedInvoice;
      _selectedAccount = widget.selectedInvoice.creditCard.account;
    });
    _initData();
    _fToast = FToast();
    _fToast.init(context);
  }

  @override
  void dispose() {
    widget.onPop();
    super.dispose();
  }

  _initData() async {
    List<Account> tempAccounts = await AccountService.findAll();
    TransactionCategory tempCategory =
        await TransactionCategoryService.findByName('Contas');
    setState(() {
      _accounts = tempAccounts;
      _category = tempCategory;
    });
  }

  _payInvoice() {
    AccountTransactionDTO accountTransaction = AccountTransactionDTO(
      description: 'Pagamento de fatura',
      amount: _selectedInvoice.amount,
      type: false,
      categoryId: _category.id,
      accountId: _selectedAccount!.id,
      date: _selectedDate,
    );
    InvoiceService.payInvoice(_selectedInvoice, accountTransaction);
    Navigator.pop(context);
  }

  _selectAccount(dynamic account) {
    setState(() {
      _selectedAccount = account;
    });
    Navigator.pop(context);
  }

  _selectDate() async {
    List<DateTime?>? results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(),
      dialogSize: const Size(325, 400),
      value: [_selectedDate],
      borderRadius: BorderRadius.circular(15),
    );
    if (results != null) {
      setState(() {
        _selectedDate = results[0]!;
      });
    }
  }

  List<SelectImageItem> _convertAccountsToSelect() {
    return _accounts
        .map((account) => SelectImageItem(
              id: account.id,
              image: account.bank.image,
              text: account.description,
              object: account,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      alignment: Alignment.bottomCenter,
      content: Box(
        bottom: false,
        width: 100,
        height: 350,
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  "Confirmação de pagamento",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: FaIcon(
                          FontAwesomeIcons.coins,
                          color: Colors.grey,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Valor da fatura",
                            style: TextStyle(
                              color: Color(0xA69E9E9E),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _formatCurrency.format(_selectedInvoice.amount),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: FaIcon(
                          FontAwesomeIcons.fileInvoice,
                          color: Colors.grey,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Vencimento",
                            style: TextStyle(
                              color: Color(0xA69E9E9E),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            DateFormat('dd MMM yy')
                                .format(_selectedInvoice.dueDate),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            InsertField(
              icon: FontAwesomeIcons.calendarCheck,
              hint: DateFormat("dd MMM yyyy").format(_selectedDate),
              onClick: _selectDate,
            ),
            InsertSelectImageField(
              defaultIcon: FontAwesomeIcons.buildingColumns,
              hint: _selectedAccount?.description ?? "Escolha uma conta",
              image: _selectedAccount?.bank.image,
              itemList: _convertAccountsToSelect(),
              onClick: _selectAccount,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 150,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          width: 2.0,
                          color: Colors.blue,
                        ),
                      ),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      onPressed: _payInvoice,
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue),
                      ),
                      child: const Text(
                        "Confirmar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
