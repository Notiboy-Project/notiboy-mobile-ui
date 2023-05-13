import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:notiboy/utils/color.dart';

class DropDown2 extends StatefulWidget {
  List<String> items;
  String hintTitle;
  TextStyle? style;
  EdgeInsetsGeometry? padding;
  BoxBorder? border;
  Color? color;
  Color? iconColor;

  DropDown2({
    Key? key,
    required this.items,
    required this.hintTitle,
    this.style,
    this.padding,
    this.border,
    this.color,
    this.iconColor,
  }) : super(key: key);

  @override
  State<DropDown2> createState() => _DropDown2State();
}

class _DropDown2State extends State<DropDown2> {
  String? selectedValue;

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Clr.white,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            DropdownMenuItem<String>(
              enabled: false,
              child: Divider(
                color: Color(0xFFE8EFFF),
                thickness: 2,
              ),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<double> _getCustomItemsHeights() {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (widget.items.length * 2) - 1; i++) {
      if (i.isEven) {
        _itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _itemsHeights.add(4);
      }
    }
    return _itemsHeights;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.all(5),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              widget.hintTitle,
              textAlign: TextAlign.center,
              style: widget.style ??
                  TextStyle(
                    color: Clr.white,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          items: _addDividersAfterItems(widget.items),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value as String;
            });
          },
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: widget.color ?? Clr.mode,
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Image.asset(
                "assets/arrow_down.png",
                color: widget.iconColor ?? Clr.blue,
              ),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            elevation: 0,
            decoration: BoxDecoration(
              color: Clr.black,
              border: Border.all(
                width: 2,
                color: Color(0xFFE8EFFF),
              ),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            customHeights: _getCustomItemsHeights(),
          ),
        ),
      ),
    );
  }
}
