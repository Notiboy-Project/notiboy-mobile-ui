import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notiboy/Model/channel/ChannelCreateModel.dart';
import 'package:notiboy/Model/channel/ChannelListModel.dart';
import 'package:notiboy/Model/channel/UserListModel.dart';
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

class ChannelScreen extends StatefulWidget {
  final Function? functionCall;

  const ChannelScreen({Key? key, this.functionCall}) : super(key: key);

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  TextEditingController searchC = TextEditingController();
  ChannelCreateModel? channelCreateModel;
  ChannelListModel? channelListModel;
  UserListModel? userListModel;
  final List<String> items = [
    'Spouse',
    'Partner',
    'Friend',
    'Other',
  ];

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
                    selectImage(image: "assets/algorand.png", color: isDark ? Clr.mode : Clr.white),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      Str.channel,
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
                    setting(context),
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
                      cmnDropDown(title: Str.channel),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 12,
                            child: MyTextField(
                              padding: EdgeInsets.zero,
                              controller: searchC,
                              hintText: Str.searchHint,
                              validate: "name",
                              keyboardType: TextInputType.text,
                              textFieldType: "name",
                              inputTextStyle: TextStyle(
                                color: isDark ? Clr.white : Clr.black,
                              ),
                              fillColor: isDark ? Clr.black : Clr.white,
                              prefixIcon: Image.asset("assets/search.png"),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: selectImage(
                              image: "assets/filter.png",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: 3,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return joinChannel(
                            logo: "assets/algorand.png",
                            message:
                                "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
                            cmpName: "Artificial Intelligen..",
                            isVerify: true,
                            btnTitle: "Exit Channel",
                            btnColor: Clr.joinBtnCLr,
                            onTap: () {},
                            textColor: isDark ? Clr.white : Clr.black,
                            logoColor: isDark ? Clr.white : Clr.blueBg,
                            boxColor: isDark ? Clr.black : Clr.white,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 13,
                        child: MyTextField(
                          padding: EdgeInsets.zero,
                          controller: searchC,
                          hintText: Str.searchHint,
                          isDense: false,
                          validate: "name",
                          inputTextStyle: TextStyle(
                            color: isDark ? Clr.white : Clr.black,
                          ),
                          keyboardType: TextInputType.text,
                          textFieldType: "name",
                          fillColor: isDark ? Clr.black : Clr.white,
                          prefixIcon: Image.asset("assets/search.png"),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          createChannel();
                        },
                        child: selectImage(image: "assets/add.png", color: Clr.blue),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      selectImage(image: "assets/filter.png"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return joinChannel(
                        logo: "assets/algorand.png",
                        message:
                            "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
                        cmpName: "Artificial Intelligence Channel",
                        isVerify: true,
                        btnTitle: "Exit Channel",
                        btnColor: Clr.joinBtnCLr,
                        boxColor: isDark ? Clr.black : Clr.white,
                        logoColor: isDark ? Clr.white : Clr.blueBgWeb,
                        textColor: isDark ? Clr.white : Clr.blue,
                        onTap: () {},
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

  createChannel() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              color: isDark ? Clr.dark : Clr.blueBgWeb,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Text(
                        Str.createChannel,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Clr.white : Clr.black,
                        ),
                      ),
                      InkWell(
                        splashColor: Clr.trans,
                        highlightColor: Clr.trans,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          "assets/close_circle.png",
                          width: 25,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? Clr.black : Clr.white,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(isDark ? "line_dark.png" : "assets/line.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset("assets/add_logo.png", width: 30),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          Str.uploadChannelLogo,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Clr.white : Clr.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    controller: searchC,
                    hintText: Str.enterChannelName,
                    validate: "name",
                    keyboardType: TextInputType.text,
                    textFieldType: "name",
                    fillColor: isDark ? Clr.black : Clr.white,
                    inputTextStyle: TextStyle(
                      color: isDark ? Clr.white : Clr.black,
                    ),
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
                    height: 20,
                  ),
                  MyTextField(
                    controller: searchC,
                    hintText: Str.enterChannelDisc,
                    validate: "name",
                    maxLines: 5,
                    keyboardType: TextInputType.text,
                    textFieldType: "name",
                    fillColor: isDark ? Clr.black : Clr.white,
                    inputTextStyle: TextStyle(
                      color: isDark ? Clr.white : Clr.black,
                    ),
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
                    height: 20,
                  ),
                  MyButton(
                    title: Str.createChannel,
                    width: 200,
                    fontSize: 12,
                    onClick: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget joinChannel({
    required String logo,
    required String message,
    required String cmpName,
    required String btnTitle,
    required Function() onTap,
    required Color btnColor,
    required bool isVerify,
    required Color boxColor,
    required Color textColor,
    required Color logoColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                selectImage(
                  image: logo,
                  color: logoColor,
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: SizedBox(
                    child: Text(
                      cmpName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                isVerify ? Image.asset("assets/verify.png") : SizedBox(),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 17,
                ),
              ),
            ),
            Center(
              child: MyButton(
                title: btnTitle,
                onClick: onTap,
                buttonClr: btnColor,
                width: 150,
              ),
            )
          ],
        ),
      ),
    );
  }

  channelCreate() async {
    final hasInternet = await checkInternets();
    try {
      Loader.sw();
      final url = baseUrl + "";

      Map body = {"name": "John Doe", "description": "description", "logo": "0x4f4e205041525420494d414745"};

      String jsonString = json.encode(body);
      dynamic response = await AllProvider().apiProvider(
        url: url,
        bodyData: jsonString,
        method: Method.post,
      );
      channelCreateModel = await ChannelCreateModel.fromJson(response);

      if (channelCreateModel != null) {
        MyToast().succesToast(toast: channelCreateModel?.message.toString());
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

  channelList() async {
    final hasInternet = await checkInternets();
    try {
      Loader.sw();
      final url = baseUrl + "";

      dynamic response = await AllProvider().apiProvider(
        url: url,
        method: Method.get,
      );
      channelListModel = await ChannelListModel.fromJson(response);

      if (channelListModel != null) {
        MyToast().succesToast(toast: channelListModel?.message.toString());
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

  userList() async {
    final hasInternet = await checkInternets();
    try {
      Loader.sw();
      final url = baseUrl + "";

      dynamic response = await AllProvider().apiProvider(
        url: url,
        method: Method.get,
      );
      userListModel = await UserListModel.fromJson(response);

      if (userListModel != null) {
        MyToast().succesToast(toast: userListModel?.message.toString());
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
