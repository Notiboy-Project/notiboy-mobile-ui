import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notiboy/main.dart';
import 'package:notiboy/service/internet_service.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:notiboy/widget/button.dart';
import 'package:notiboy/widget/drop_down.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../Model/user/get_user_model.dart';
import '../../../constant.dart';
import '../../../utils/shared_prefrences.dart';
import '../bottom_bar_screen.dart';
import '../channel/controllers/api_controller.dart';
import 'controllers/api_controller.dart';

class SettingScreen extends StatefulWidget {
  final Function? functionCall;

  const SettingScreen({Key? key, this.functionCall}) : super(key: key);

  @override
  State<SettingScreen> createState() => _Setting_screenState();
}

class _Setting_screenState extends State<SettingScreen> {
  List<VerifyModel> verifyModel = [];
  List<String> notify = [];
  bool isDone = false;

  @override
  void initState() {
    // TODO: implement initState
    getUserDetails();
    super.initState();
    EasyLoading.show(status: 'loading...');
  }

  getTheme() async {
    isDark = await pref?.getBool("mode") ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getTheme();
    return Scaffold(
      backgroundColor: isDark
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
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      BottomNavigationBar navigationBar =
                          bottomWidgetKey.currentWidget as BottomNavigationBar;
                      navigationBar.onTap!(0);
                    },
                    child: selectImage(
                        image: "assets/nb.png",
                        color: isDark ? Clr.mode : Clr.white),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cmnDropDown(title: Str.setting),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      itemCount: verifyModel.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return notificationType(
                          title: verifyModel[index].isVerify
                              ? '${index == 1 ? 'Discord ID: ' : 'Email: '}' +
                                  verifyModel[index].ID
                              : verifyModel[index].text,
                          isVerify: verifyModel[index].isVerify,
                          isOn: notify.contains(verifyModel[index]
                                  .text
                                  .split(" ")
                                  .first
                                  .toLowerCase()) ??
                              false,
                          boxColor: isDark ? Clr.black : Clr.white,
                          off1:
                              isDark ? "assets/off1.png" : "assets/offWb1.png",
                          off2:
                              isDark ? "assets/off2.png" : "assets/offWb2.png",
                          on1: isDark ? "assets/on1.png" : "assets/onWb1.png",
                          on2: isDark ? "assets/on2.png" : "assets/onWb2.png",
                          index: index,
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: MyButton(
                        title: "Go Back",
                        width: 200,
                        height: 50,
                        onClick: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Note: Register using web app ',
                          children: [
                            TextSpan(
                                text: 'app.notiboy.com',
                                style: TextStyle(color: Clr.blue, fontSize: 19),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrls('app.notiboy.com');
                                  }),
                          ],
                          style: TextStyle(
                              color: !isDark ? Clr.black : Clr.white,
                              fontSize: 19)),
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

  Widget notificationType({
    required String title,
    required bool isVerify,
    required bool isOn,
    required String on1,
    required String on2,
    required String off1,
    required String off2,
    required int index,
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
            Visibility(
              visible: isVerify,
              child: InkWell(
                onTap: () async {
                  if (isOn == true) {
                    notify.removeWhere((element) =>
                        element ==
                        verifyModel[index].text.split(" ").first.toLowerCase());
                    isOn = false;
                    SettingApiController().notification(notify.toList());
                    setState(() {});
                  } else {
                    isOn = true;
                    notify.add(
                        verifyModel[index].text.split(" ").first.toLowerCase());
                    SettingApiController().notification(notify);
                    setState(() {});
                  }
                },
                child: Container(
                  width: 50.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: isOn ? Colors.blue : Colors.grey,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Container(
                      alignment:
                          isOn ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 20.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getUserDetails() {
    notify.clear();
    verifyModel.clear();
    checkInternets().then((internet) async {
      if (internet) {
        ChannelApiController().getUser().then((response) async {
          EasyLoading.dismiss();
          getUserModel = GetUserModel.fromJson(json.decode(response.body));
          Map<String, dynamic> userdata = jsonDecode(response.body);
          Map mediumData = (userdata['data']['medium_metadata'] as Map);
          mediumData.keys.forEach((element) {
            verifyModel.add(VerifyModel(
                mediumData[element]['ID'],
                mediumData[element]['Verified'],
                '${element} is ${mediumData[element]['Verified'] ? 'Verified' : 'Not Verified'}'));
          });

          getUserModel.data?.allowed_mediums?.forEach((element) {
            notify.add(element.toString().toLowerCase());
          });

          setState(() {});
        });
      } else {
        EasyLoading.showError('Internet Required');
      }
    });
  }
}

class VerifyModel {
  String ID = '';
  bool isVerify = false;
  String text = '';

  VerifyModel(this.ID, this.isVerify, this.text);
}
