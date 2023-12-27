import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:notiboy/Model/notification/NotificationCreateModel.dart';
import 'package:notiboy/main.dart';
import 'package:notiboy/screen/home/notification/controllers/channels_dropdown.dart';
import 'package:notiboy/service/internet_service.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:notiboy/widget/button.dart';
import 'package:notiboy/widget/textfields.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../constant.dart';
import '../../../widget/select_notification_type.dart';
import '../channel/model/channel_model.dart';
import '../notification/controllers/api_controller.dart';
import '../notification/notification_screen.dart';

class SendMessageScreen extends StatefulWidget {
  final Function? functionCall;

  const SendMessageScreen({Key? key, this.functionCall}) : super(key: key);

  @override
  State<SendMessageScreen> createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  int selectedIndex = 0;
  NotificationCreateModel? notificationCreateModel;
  TextEditingController addC = TextEditingController();
  TextEditingController messC = TextEditingController();
  TextEditingController linkC = TextEditingController();
  bool isPublic = true;
  String title = "true";

  Data? channelData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheme();
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
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
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
                        BottomNavigationBar navigationBar = bottomWidgetKey
                            .currentWidget as BottomNavigationBar;
                        navigationBar.onTap!(0);
                      },
                      child: selectImage(
                        image: "assets/nb.png",
                        color: isDark ? Clr.mode : Clr.white,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      Str.notification,
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
                    setting(context,(){
                      setState(() {

                      });
                    }),
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
                      cmnDropDown(title: "Send"),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SelectNotificationTypeDropDown(
                                title: isPublic
                                    ? "Public Message"
                                    : "Personal Message",
                                callback: (value) {
                                  isPublic = value;
                                  setState(() {});
                                }),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: SelectChannelDropDown(
                              callback: (data) {
                                channelData = data;
                                setState(() {});
                              },
                              title: channelData?.name,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      isPublic
                          ? SizedBox()
                          : MyTextField(
                              controller: addC,
                              hintText: Str.inputAdd,
                              fillColor: isDark ? Clr.black : Clr.white,
                              validate: "name",
                              keyboardType: TextInputType.text,
                              textFieldType: "name",
                              isDense: false,
                              inputTextStyle: TextStyle(
                                color: isDark ? Clr.white : Clr.black,
                              ),
                              suffixIconConstraints:
                                  BoxConstraints(maxWidth: 30, maxHeight: 30),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                      MyTextField(
                        controller: messC,
                        hintText: Str.inputMes,
                        fillColor: isDark ? Clr.black : Clr.white,
                        validate: "name",
                        keyboardType: TextInputType.text,
                        textFieldType: "name",
                        isDense: false,
                        inputTextStyle: TextStyle(
                          color: isDark ? Clr.white : Clr.black,
                        ),
                        maxLength: getUserModel
                                ?.data?.privileges?.notificationCharCount ??
                            5,
                        isCounter: true,
                        maxLines: 10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      MyTextField(
                        controller: linkC,
                        hintText: Str.uploadLink,
                        fillColor: isDark ? Clr.black : Clr.white,
                        validate: "link",
                        keyboardType: TextInputType.url,
                        textFieldType: "link",
                        isDense: false,
                        inputTextStyle: TextStyle(
                          color: isDark ? Clr.white : Clr.black,
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Image.asset("assets/link.png"),
                        ),
                        suffixIconConstraints:
                            BoxConstraints(maxWidth: 30, maxHeight: 30),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      MyButton(
                        title: "Send",
                        width: 200,
                        onClick: () {
                          EasyLoading.show(status: 'loading...');

                          checkInternets().then((internet) async {
                            Map data = {
                              'message': messC.text,
                              'link': linkC.text,
                            };
                            if (!isPublic) {
                              data['receivers'] = addC.text.split(',');
                            }
                            if (internet) {
                              await NotificationApiContorller()
                                  .sendNotification(
                                      isPublic ? 'public' : 'private',
                                      channelData?.app_id,
                                      data)
                                  .then((Response value) {
                                EasyLoading.showSuccess(
                                    json.decode(value.body)['message']);
                                addC.clear();
                                linkC.clear();
                                messC.clear();
                              }).catchError((onError) {
                                EasyLoading.showError(onError.toString());
                              });
                              NotificationScreen().createState().initState();
                            } else {
                              EasyLoading.showError('Internet Required');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabWidget() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isDark ? Clr.black : Clr.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          cmnCnt(
            title: Str.publicMessage,
            index: 0,
          ),
          SizedBox(
            width: 10,
          ),
          cmnCnt(
            title: Str.personalMessage,
            index: 1,
          ),
          SizedBox(
            width: 10,
          ),
          cmnCnt(
            title: Str.bulkMessage,
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget cmnCnt({required String title, required int index}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          selectedIndex = index;
          setState(() {});
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          // width: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            color: selectedIndex == index
                ? isDark
                    ? Color(0xFF353948)
                    : Clr.blue
                : isDark
                    ? Clr.black
                    : Clr.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selectedIndex == index
                  ? Clr.white
                  : isDark
                      ? Clr.grey
                      : Clr.black,
            ),
          ),
        ),
      ),
    );
  }
}
