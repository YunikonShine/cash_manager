import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CalendarPicker extends StatefulWidget {
  const CalendarPicker({
    super.key,
    required this.onTap,
    this.selectedDate,
    this.month = true,
  });

  final Function(DateTime dateTime) onTap;
  final DateTime? selectedDate;
  final bool month;

  @override
  CalendarPickerState createState() => CalendarPickerState();
}

class CalendarPickerState extends State<CalendarPicker>
    with SingleTickerProviderStateMixin {
  late int? _currentYear;
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 150,
      ),
    );
    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();

    _currentYear = widget.selectedDate?.year;
  }

  _selectDate(int month, [bool current = false]) {
    int year = DateTime.now().year;
    if (!current && _currentYear != null) {
      year = _currentYear!;
    }
    widget.onTap(DateTime(year, month));
    Navigator.pop(context);
  }

  _selectDay(int day) {
    DateTime date = DateTime.now();
    widget.onTap(DateTime(date.year, 1, day));
    Navigator.pop(context);
  }

  _nextYear() {
    setState(() {
      _currentYear = _currentYear! + 1;
    });
  }

  _previousYear() {
    setState(() {
      _currentYear = _currentYear! - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 100,
        left: 30,
        right: 30,
      ),
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Column(
          children: [
            if (widget.month)
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.purple,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: _previousYear,
                      icon: const Icon(
                        FontAwesomeIcons.chevronLeft,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Text(
                      _currentYear.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: _nextYear,
                      icon: const Icon(
                        FontAwesomeIcons.chevronRight,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.month)
              Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Color(0xFF4C4C4C),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int i = 0; i < 6; i++)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25),
                              ),
                              onTap: () => _selectDate(i + 1),
                              child: Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  DateFormat('MMM').format(DateTime(0, i + 1)),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int i = 6; i < 12; i++)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25),
                              ),
                              onTap: () => _selectDate(i + 1),
                              child: Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  DateFormat('MMM').format(DateTime(0, i + 1)),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        right: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 15,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Cancelar",
                                    style: TextStyle(
                                      color: Color(0xFFE75DFF),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25),
                              ),
                              onTap: () =>
                                  _selectDate(DateTime.now().month, true),
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: const Text(
                                  "Mês atual",
                                  style: TextStyle(
                                    color: Color(0xFFE75DFF),
                                    fontSize: 18,
                                  ),
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
            if (!widget.month)
              Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xFF4C4C4C),
                ),
                child: Column(
                  children: [
                    for (int r = 0; r < 5; r++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (int i = 1; i < 8; i++)
                            (r == 4 && i > 3)
                                ? const SizedBox(
                                    width: 40,
                                    height: 40,
                                  )
                                : Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                      onTap: () => _selectDay(i + (r * 7)),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: Text(
                                          DateFormat('dd').format(
                                              DateTime(0, 1, (i + (r * 7)))),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        right: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 15,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Cancelar",
                                    style: TextStyle(
                                      color: Color(0xFFE75DFF),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25),
                              ),
                              onTap: () =>
                                  _selectDate(DateTime.now().month, true),
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: const Text(
                                  "Dia atual",
                                  style: TextStyle(
                                    color: Color(0xFFE75DFF),
                                    fontSize: 18,
                                  ),
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
          ],
        ),
      ),
    );
  }
}
