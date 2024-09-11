import 'package:cash_manager/models/header_dropdown_item.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    this.text = "",
    this.dropdown = false,
    this.selectedValue,
    this.selectValue,
    this.hideBack = false,
    this.dropdownItems,
  });

  final String text;
  final bool dropdown;
  final String? selectedValue;
  final Function(String? value)? selectValue;
  final bool hideBack;
  final List<HeaderDropdownItem>? dropdownItems;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!hideBack) {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 25,
        ),
        height: (MediaQuery.of(context).size.height * 10) / 100,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            if (!hideBack)
              const Icon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.grey,
                size: 20,
              ),
            if (!dropdown)
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            if (dropdown && dropdownItems != null && dropdownItems!.isNotEmpty)
              SizedBox(
                width: 150,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    iconStyleData: const IconStyleData(
                      iconEnabledColor: Colors.purple,
                      iconDisabledColor: Colors.purple,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0x55FFFFFF),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 15, right: 15),
                    ),
                    selectedItemBuilder: (context) {
                      return dropdownItems!.map(
                        (item) {
                          return Container(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              selectedValue!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          );
                        },
                      ).toList();
                    },
                    items: dropdownItems!
                        .map((HeaderDropdownItem item) =>
                            DropdownMenuItem<String>(
                              value: item.name,
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 5),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: item.color,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (String? value) {
                      selectValue!(value);
                    },
                    buttonStyleData: const ButtonStyleData(
                      height: 40,
                      width: 140,
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
