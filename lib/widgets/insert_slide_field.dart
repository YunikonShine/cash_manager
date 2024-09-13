import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InsertSlideField extends StatefulWidget {
  const InsertSlideField({
    super.key,
    required this.icon,
    required this.hint,
    required this.onClick,
    required this.value,
  });

  final IconData icon;
  final String hint;
  final bool value;
  final Function(bool value) onClick;

  @override
  InsertSlideFieldState createState() => InsertSlideFieldState();
}

class InsertSlideFieldState extends State<InsertSlideField> {
  Widget _getToggle() {
    if (widget.value) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 2),
          child: FaIcon(
            FontAwesomeIcons.check,
            color: Colors.green,
            size: 16,
          ),
        ),
      );
    }
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 2),
        child: FaIcon(
          FontAwesomeIcons.xmark,
          color: Colors.red,
          size: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        widget.onClick(!widget.value);
      },
      child: Container(
        height: 60,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0x32A3A3A3),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: FaIcon(
                        widget.icon,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      widget.hint,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                CustomAnimatedToggleSwitch<bool>(
                  current: widget.value,
                  values: const [false, true],
                  spacing: 0.0,
                  indicatorSize: const Size.square(22.0),
                  animationDuration: const Duration(milliseconds: 200),
                  animationCurve: Curves.linear,
                  onChanged: widget.onClick,
                  iconBuilder: (context, local, global) {
                    return const SizedBox();
                  },
                  onTap: (_) => widget.onClick(!widget.value),
                  wrapperBuilder: (context, global, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 10.0,
                          right: 10.0,
                          height: 20.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color.lerp(
                                Colors.red,
                                Colors.green,
                                global.position,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50.0)),
                            ),
                          ),
                        ),
                        child,
                      ],
                    );
                  },
                  foregroundIndicatorBuilder: (context, global) {
                    return SizedBox.fromSize(
                      size: global.indicatorSize,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color.lerp(
                              Colors.white,
                              Colors.white,
                              global.position,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                          ),
                          child: _getToggle()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
