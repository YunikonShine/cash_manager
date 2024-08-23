import 'package:cash_manager/widgets/balance.dart';
import 'package:cash_manager/widgets/box.dart';
import 'package:cash_manager/widgets/calendar_picker.dart';
import 'package:cash_manager/widgets/icon_filled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Balance(),
          Box(
            width: 90,
            top: true,
            padding: const EdgeInsets.only(
              top: 30,
            ),
            child: Container(),
          )
        ],
      ),
    );
  }
}
