import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/const.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:notiboy/widget/drop_down.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SettingScreen extends StatefulWidget {
  final Function? functionCall;
  const SettingScreen({Key? key,this.functionCall}) : super(key: key);

  @override
  State<SettingScreen> createState() => _Setting_screenState();
}

class _Setting_screenState extends State<SettingScreen> {
  bool isOn = false;
  final List<String> items = [
    'Spouse',
    'Partner',
    'Friend',
    'Other',
  ];
  List lst = [
    "Enter Your Email ID",
    "Enter Your Discord Link",
    "Enter Your Telegram Number",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:isDark
          ? kIsWeb
          ? Clr.black
          : Clr.dark
          : kIsWeb
          ? Clr.white
          : Clr.blueBg,
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return _mainBody(sizingInformation.deviceScreenType);
        },
      ),
    );
  }

  Widget _mainBody(DeviceScreenType deviceScreenType) {
    switch (deviceScreenType) {
      case DeviceScreenType.desktop:
        return _buildDesktopBody();
      case DeviceScreenType.mobile:
      default:
        return _buildMobileBody();
    }
  }

  _buildMobileBody() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  selectImage(
                    image: "assets/algorand.png",
                    color: isDark ? Clr.mode : Clr.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    Str.setting,
                    style: TextStyle(
                      color: isDark ? Clr.white : Clr.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  changeMode(
                    () {
                      widget.functionCall?.call();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    cmnDropDown(title: Str.setting),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      itemCount: lst.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return notificationType(
                          title: lst[index],
                          boxColor:  isDark? Clr.black: Clr.white,
                          off1: isDark ? "assets/off1.png" : "assets/offWb1.png",
                          off2: isDark ? "assets/off2.png" : "assets/offWb2.png",
                          on1: isDark ? "assets/on1.png" : "assets/onWb1.png",
                          on2: isDark ? "assets/on2.png" : "assets/onWb2.png",
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildDesktopBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? Clr.bottomBg : Clr.blueBgWeb,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Text(
                    Str.setting,
                    style: TextStyle(
                      color: isDark ? Clr.white : Clr.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  changeMode(
                    () {
                      widget.functionCall?.call();
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  selectImage(image: "assets/algorand.png"),
                  SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 150,
                    child: DropDownWidgetScreen(title: "XL32...YJD"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: lst.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return notificationType(
                        title: lst[index],
                        boxColor: isDark ? Clr.black : Clr.white,
                        off1: isDark ? "assets/off1.png" : "assets/offWb1.png",
                        off2: isDark ? "assets/off2.png" : "assets/offWb2.png",
                        on1: isDark ? "assets/on1.png" : "assets/onWb1.png",
                        on2: isDark ? "assets/on2.png" : "assets/onWb2.png",
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget notificationType({
    required String title,
    required String on1,
    required String on2,
    required String off1,
    required String off2,
    Color? boxColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: boxColor ?? Clr.black,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: Clr.hint, fontSize: 15),
            ),
            InkWell(
              onTap: () {
                if (isOn == true) {
                  isOn = false;
                } else {
                  isOn = true;
                }

                setState(() {});
              },
              child: Stack(
                children: [
                  Image.asset(isOn ? on1 : off1, width: 30),
                  isOn
                      ? Positioned(
                          right: 0.3,
                          bottom: 0.3,
                          top: 0.3,
                          child: Image.asset(on2),
                        )
                      : Positioned(
                          left: 0.3,
                          bottom: 0.3,
                          top: 0.3,
                          child: Image.asset(off2),
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
