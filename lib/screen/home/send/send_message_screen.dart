import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notiboy/Model/notification/NotificationCreateModel.dart';
import 'package:notiboy/controller/common_provider.dart';
import 'package:notiboy/service/internet_service.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/const.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:notiboy/widget/button.dart';
import 'package:notiboy/widget/drop_down.dart';
import 'package:notiboy/widget/loader.dart';
import 'package:notiboy/widget/textfields.dart';
import 'package:notiboy/widget/toast.dart';
import 'package:responsive_builder/responsive_builder.dart';

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

  @override
  Widget build(BuildContext context) {
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
      case DeviceScreenType.desktop:
        return _buildDesktopBody();
      case DeviceScreenType.mobile:
      default:
        return _buildMobileBody();
    }
  }

  _buildMobileBody() {}

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
                  selectImage(image: "assets/algorand.png"),
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
                  setting(context),
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
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: tabWidget(),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      selectChannel(title: "Select Channel"),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  selectedIndex == 0
                      ? SizedBox()
                      : MyTextField(
                          controller: addC,
                          hintText: selectedIndex == 1 ? Str.inputAdd : Str.uploadCsv,
                          fillColor: isDark ? Clr.black : Clr.white,
                          validate: "name",
                          keyboardType: TextInputType.text,
                          textFieldType: "name",
                          isDense: false,
                          inputTextStyle: TextStyle(
                            color: isDark ? Clr.white : Clr.black,
                          ),
                          suffixIcon: selectedIndex == 2
                              ? Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Image.asset("assets/document_upload.png"),
                                )
                              : SizedBox(),
                          suffixIconConstraints: BoxConstraints(maxWidth: 30, maxHeight: 30),
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
                    maxLength: 240,
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
                    controller: addC,
                    hintText: Str.uploadLink,
                    fillColor: isDark ? Clr.black : Clr.white,
                    validate: "name",
                    keyboardType: TextInputType.text,
                    textFieldType: "name",
                    isDense: false,
                    inputTextStyle: TextStyle(
                      color: isDark ? Clr.white : Clr.black,
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Image.asset("assets/link.png"),
                    ),
                    suffixIconConstraints: BoxConstraints(maxWidth: 30, maxHeight: 30),
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
                    onClick: () {},
                  ),
                ],
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

  sendPublicMessage() async {
    final hasInternet = await checkInternets();
    try {
      Loader.sw();
      final url = baseUrl + "";

      Map body = {
        "user": ["John Doe"],
        "message": "description",
        "link": "0x4f4e205041525420494d414745",
      };

      String jsonString = json.encode(body);
      dynamic response = await AllProvider().apiProvider(
        url: url,
        bodyData: jsonString,
        method: Method.post,
      );
      notificationCreateModel = await NotificationCreateModel.fromJson(response);

      if (notificationCreateModel != null) {
        MyToast().succesToast(toast: notificationCreateModel?.message.toString());
        //Navigate screen here
      } else {
        if (hasInternet == true) {
          MyToast().errorToast(toast: Validate.somethingWrong);
        }
      }
      Loader.hd();
      setState(() {});
    } catch (error) {
      Loader.hd();
      print("error == ${error.toString()}");
      if (hasInternet == true) {
        MyToast().errorToast(toast: Validate.somethingWrong);
      }
    }
  }
}
