import 'package:cash_manager/models/account.dart';
import 'package:cash_manager/screens/account_screen.dart';
import 'package:cash_manager/services/database/queries/account_query.dart';
import 'package:cash_manager/widgets/balance.dart';
import 'package:cash_manager/widgets/empty_box.dart';
import 'package:cash_manager/widgets/item_box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<String> cards = [];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Balance(),
          FutureBuilder<List<Account>>(
            future: AccountQuery.selectAccounts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ItemBox(
                  name: "Contas",
                  accounts: snapshot.data!,
                  onClick: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountScreen(),
                    ),
                  ),
                );
              } else {
                return EmptyBox(
                  name: "Contas",
                  icon: FontAwesomeIcons.buildingColumns,
                  emptyText: "Você não tem contas cadastradas",
                  buttonText: "Cadastrar contas",
                  onClick: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountScreen(),
                    ),
                  ),
                );
              }
            },
          ),
          cards.isEmpty
              ? EmptyBox(
                  name: "Cartões",
                  icon: FontAwesomeIcons.creditCard,
                  emptyText: "Você não tem cartões cadastrados",
                  buttonText: "Cadastrar cartão",
                  onClick: () => {},
                )
              : Container()
        ],
      ),
    );
  }
}
