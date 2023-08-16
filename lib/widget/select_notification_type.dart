import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notiboy/constant.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/widget.dart';

import '../screen/home/bottom_bar_screen.dart';
import '../screen/home/select_network_screen.dart';
import '../screen/home/setting/controllers/api_controller.dart';
import '../service/internet_service.dart';
import '../utils/shared_prefrences.dart';

class SelectNotificationTypeDropDown extends StatefulWidget {
  final Function? callback;
  final String? title;

  SelectNotificationTypeDropDown({Key? key, this.callback, this.title}) : super(key: key);

  @override
  State<SelectNotificationTypeDropDown> createState() => _SelectNotificationTypeDropDownState();
}

class _SelectNotificationTypeDropDownState extends State<SelectNotificationTypeDropDown> {
  List<MenuItem> firstItems = [public];
  List<MenuItem> secondItems = [private];

  static MenuItem public = MenuItem(text: "Public Message");
  static MenuItem private = MenuItem(
    text: 'Personal Message',
  );

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        style: TextStyle(color: Clr.white),
        customButton: dpDown2(title: widget.title ?? ''),
        items: [
          ...firstItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: buildItem(item),
            ),
          ),
          DropdownMenuItem<Divider>(enabled: false, child: Divider()),
          ...secondItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          onChanged(context, value as MenuItem);
          // MenuItems.onChanged(context, value as MenuItem);
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
            ...List<double>.filled(firstItems.length, 48),
            8,
            ...List<double>.filled(secondItems.length, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }

  Widget buildItem(MenuItem item) {
    return Text(
      item.text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Clr.white,
      ),
    );
  }

  onChanged(BuildContext context, MenuItem item) {
    if (item == public) {
      widget.callback?.call(true);
      setState(() {});
      Clipboard.setData(
        ClipboardData(text: public.text),
      );
    } else if (item == private) {
      widget.callback?.call(false);
      setState(() {});
      ClipboardData(text: private.text);

      // checkInternets().then((internet) async {
      //   if (internet) {
      //     SettingApiController().logout().then((response) async {
      //       EasyLoading.dismiss();
      //       await SharedPrefManager().clearAll();
      //       navigatorKey?.currentState!.pushAndRemoveUntil(
      //           MaterialPageRoute(
      //             builder: (context) => SelectNetworkScreen(),
      //           ),
      //           (route) => false);
      //     }).catchError((onError) {
      //       EasyLoading.showError(onError.toString());
      //     });
      //   } else {
      //     EasyLoading.showError('Internet Required');
      //   }
      // });
    }
  }
}

class MenuItem {
  final String text;

  const MenuItem({
    required this.text,
  });
}
