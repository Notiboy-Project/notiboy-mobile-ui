import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notiboy/constant.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:provider/provider.dart';

import '../screen/home/SplashScreen.dart';
import '../screen/home/bottom_bar_screen.dart';
import '../screen/home/select_network_screen.dart';
import '../screen/home/setting/controllers/api_controller.dart';
import '../service/internet_service.dart';
import '../service/notifier.dart';
import '../utils/shared_prefrences.dart';

class DropDownWidgetScreen extends StatefulWidget {
  String title;

  DropDownWidgetScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<DropDownWidgetScreen> createState() => _DropDownWidgetScreenState();
}

class _DropDownWidgetScreenState extends State<DropDownWidgetScreen> {
  List<MenuItem> firstItems = [home];
  List<MenuItem> secondItems = [logout];

  static MenuItem home = MenuItem(
      text: Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
              listen: false)
          .XUSERADDRESS,
      image: "assets/copy.png");
  static MenuItem logout =
      MenuItem(text: 'Log Out', image: "assets/logout.png");

  @override
  Widget build(BuildContext context) {
    firstItems = [MenuItem(text: widget.title, image: "assets/copy.png")];
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: dpDown(title: widget.title),
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
          padding: EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }

  Widget buildItem(MenuItem item) {
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

  onChanged(BuildContext context, MenuItem item) {
    if (item.text == home.text) {
      Clipboard.setData(
        ClipboardData(text: item.text),
      );
    } else if (item == logout) {
      EasyLoading.show(status: 'loading...');

      checkInternets().then((internet) async {
        if (internet) {
          SettingApiController().logout().then((response) async {
            EasyLoading.dismiss();
            List listData = await SharedPrefManager().getAllNetworkData();
            List data = listData
                .where((element) => element['currentlogin'] == 0)
                .toList();

            if (data.isNotEmpty) {
              data.removeAt(0);
            }
            List datas = listData
                .where((element) => element['currentlogin'] == 1)
                .toList();
            if (datas.isNotEmpty) {
              datas.first['currentlogin'] = 0;
            }
            await SharedPrefManager().setString('Login', jsonEncode(datas));

            navigatorKey?.currentState!.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => SplashScreen(),
                ),
                (route) => false);
          }).catchError((onError) {
            EasyLoading.showError(onError.toString());
          });
        } else {
          EasyLoading.showError('Internet Required');
        }
      });
    }
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
