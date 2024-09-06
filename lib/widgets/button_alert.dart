import 'package:cash_manager/screens/balance_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonAlert extends StatefulWidget {
  const ButtonAlert({
    super.key,
    required this.refresh,
  });

  final Function refresh;

  @override
  ButtonAlertState createState() => ButtonAlertState();
}

class ButtonAlertState extends State<ButtonAlert> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 115),
                      child: Column(
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey,
                              fixedSize: Size(60, 60),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BalanceScreen(
                                    type: true,
                                    onPop: widget.refresh,
                                  ),
                                ),
                              );
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.arrowTrendUp,
                              color: Colors.green,
                              size: 22,
                            ),
                          ),
                          const Material(
                            color: Colors.transparent,
                            child: Text(
                              "Receita",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey,
                            fixedSize: const Size(60, 60),
                          ),
                          onPressed: () => {},
                          icon: const FaIcon(
                            FontAwesomeIcons.moneyBillTransfer,
                            color: Colors.purple,
                            size: 22,
                          ),
                        ),
                        const Material(
                          color: Colors.transparent,
                          child: Text(
                            "Transferência",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 115),
                      child: Column(
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey,
                              fixedSize: const Size(60, 60),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BalanceScreen(
                                    type: false,
                                    onPop: widget.refresh,
                                  ),
                                ),
                              );
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.arrowTrendDown,
                              color: Colors.red,
                              size: 22,
                            ),
                          ),
                          const Material(
                            color: Colors.transparent,
                            child: Text(
                              "Despesa",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey,
                            fixedSize: const Size(60, 60),
                          ),
                          onPressed: () => {},
                          icon: const FaIcon(
                            FontAwesomeIcons.creditCard,
                            color: Colors.purple,
                            size: 22,
                          ),
                        ),
                        const Material(
                          color: Colors.transparent,
                          child: Text(
                            "Transações",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
