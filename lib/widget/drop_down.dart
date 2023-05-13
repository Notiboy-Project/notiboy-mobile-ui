import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/widget.dart';

class DropDownWidgetScreen extends StatefulWidget {
  String title;
   DropDownWidgetScreen({Key? key,required this.title}) : super(key: key);

  @override
  State<DropDownWidgetScreen> createState() => _DropDownWidgetScreenState();
}

class _DropDownWidgetScreenState extends State<DropDownWidgetScreen> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: dpDown(title: widget.title),
        items: [
          ...MenuItems.firstItems.map(
                (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
          const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
          ...MenuItems.secondItems.map(
                (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value as MenuItem);
        },
        dropdownStyleData: DropdownStyleData(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Clr.mode,
          ),
          elevation: 8,
          offset: Offset(0, -5),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 48),
            8,
            ...List<double>.filled(MenuItems.secondItems.length, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}


class MenuItem {
  final String text;
  final String image;

  const MenuItem({
    required this.text,
    required this.image,
  });
}

class MenuItems {

  static const List<MenuItem> firstItems = [home];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: "XL32...YJD", image: "assets/copy.png");
  static const logout = MenuItem(text: 'Log Out', image: "assets/logout.png");

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Image.asset(
          item.image,
          color: Colors.blue,
          width: 20,
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            item.text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
        Clipboard.setData(
          ClipboardData(text: home.text),
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("data")));
        break;
      case MenuItems.logout:
      //Do something
        break;
    }
  }
}