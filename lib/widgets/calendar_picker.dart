import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarPicker extends StatefulWidget {
  const CalendarPicker({super.key});

  @override
  CalendarPickerState createState() => CalendarPickerState();
}

class CalendarPickerState extends State<CalendarPicker> {
  int _currentYear = DateTime.now().year;

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
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: const Color(0xFF4C4C4C),
            ),
            width: (MediaQuery.of(context).size.width * 80) / 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: _previousYear,
                  icon: Icon(
                    CupertinoIcons.left_chevron,
                  ),
                ),
                Text(_currentYear.toString()),
                IconButton(
                  onPressed: _nextYear,
                  icon: Icon(
                    CupertinoIcons.right_chevron,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: (MediaQuery.of(context).size.width * 80) / 100,
            color: Colors.red,
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      color: Colors.red,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(50),
                            bottomRight: const Radius.circular(50),
                          ),
                          color: const Color(0xFF4C4C4C),
                        ),
                        child: InkWell(
                          onTap: () => {},
                          child: Text("JAN"),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.red,
                      child: InkWell(
                        onTap: () => {},
                        child: Text("JAN"),
                      ),
                    ),
                    Material(
                      color: Colors.red,
                      child: InkWell(
                        onTap: () => {},
                        child: Text("JAN"),
                      ),
                    ),
                    Material(
                      color: Colors.red,
                      child: InkWell(
                        onTap: () => {},
                        child: Text("JAN"),
                      ),
                    ),
                    Material(
                      color: Colors.red,
                      child: InkWell(
                        onTap: () => {},
                        child: Text("JAN"),
                      ),
                    ),
                    Material(
                      color: Colors.red,
                      child: InkWell(
                        onTap: () => {},
                        child: Text("JAN"),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Text("JAN"),
                //     Text("JAN"),
                //     Text("JAN"),
                //     Text("JAN"),
                //     Text("JAN"),
                //     Text("JAN"),
                //   ],
                // ),
              ],
            ),
          ),
          Container(
            width: (MediaQuery.of(context).size.width * 80) / 100,
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("JAN"),
                Text("JAN"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
