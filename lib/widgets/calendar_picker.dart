import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CalendarPicker extends StatefulWidget {
  const CalendarPicker({
    super.key,
    required this.onTap,
  });

  final Function(int i) onTap;

  @override
  CalendarPickerState createState() => CalendarPickerState();
}

class CalendarPickerState extends State<CalendarPicker>
    with SingleTickerProviderStateMixin {
  int _currentYear = DateTime.now().year;
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
  }

  _nextYear() {
    setState(() {
      _currentYear++;
    });
  }

  _previousYear() {
    setState(() {
      _currentYear--;
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
                            onTap: () => widget.onTap(i + 1),
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
                            onTap: () => widget.onTap(i + 1),
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
                              onTap: () => widget.onTap(DateTime.now().month),
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
                        ),
                        Material(
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
