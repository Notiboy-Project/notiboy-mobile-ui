import 'package:flutter/material.dart';
import 'package:notiboy/screen/home/setting/setting_screen.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/const.dart';
import 'package:notiboy/widget/dropDown2.dart';
import 'package:notiboy/widget/drop_down.dart';

import '../screen/web/web_default_screen.dart';

Widget networkCnt({required String title, required String image, required Color color, required Function() onTap}) {
  return InkWell(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Image.asset(image),
          SizedBox(
            height: 30,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Clr.white : Clr.black,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget changeMode(Function? functionCall) {
  return InkWell(
    highlightColor: Clr.trans,
    splashColor: Clr.trans,
    onTap: () {
      if (isDark == true) {
        isDark = false;
      } else {
        isDark = true;
      }
      if (functionCall != null) functionCall.call();
    },
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Clr.mode,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isDark ? Clr.mode : Clr.blue,
            radius: 15,
            child: Image.asset(
              "assets/sun.png",
              width: 18,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          CircleAvatar(
            backgroundColor: isDark ? Clr.blue : Clr.mode,
            radius: 15,
            child: Image.asset(
              "assets/moon.png",
              width: 18,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget setting(BuildContext context) {
  return InkWell(
    highlightColor: Clr.trans,
    splashColor: Clr.trans,
    onTap: () {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return SettingScreen();
        },
      ));
    },
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Clr.blue,
      ),
      child: Image.asset(
        "assets/setting.png",
        width: 30,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget selectChannel({required String title}) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
    // width: MediaQuery.of(context).size.width * 0.1,
    decoration: BoxDecoration(
      color: Clr.blue,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(color: Clr.white),
        ),
        SizedBox(
          width: 50,
        ),
        Image.asset(
          "assets/arrow_down.png",
          color: Clr.white,
        )
      ],
    ),
  );
}

Widget selectImage({required String image, Color? color, double? size}) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color ?? Clr.mode,
    ),
    child: Image.asset(
      image,
      width: size ?? 30,
      fit: BoxFit.cover,
    ),
  );
}

Widget cmnDropDown({
  required String title,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        flex: 6,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? Clr.white : Clr.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: DropDownWidgetScreen(title: "XL32...YJD"),
      ),
    ],
  );
}

Widget dpDown({required String title}) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    decoration: BoxDecoration(
      color: Clr.mode,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Clr.white),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Image.asset(
          "assets/arrow_down.png",
          color: Clr.blue,
        )
      ],
    ),
  );
}

Widget walletCnt({
  required String title,
  required String image,
  required int color1,
  required int color2,
  required Function() onTap,
  double? width,
  EdgeInsets? padding,
}) {
  return Padding(
    padding: padding ?? EdgeInsets.all(10),
    child: InkWell(
      onTap: onTap,
      splashColor: Clr.trans,
      highlightColor: Clr.trans,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 15),
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment(0.8, 1),
            colors: [
              Color(color1),
              Color(color2),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Clr.white,
              ),
            ),
            Image.asset(image)
          ],
        ),
      ),
    ),
  );
}
