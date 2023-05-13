import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notiboy/Model/notification/NotificationReadingModel.dart';
import 'package:notiboy/controller/common_provider.dart';
import 'package:notiboy/service/internet_service.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/const.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:notiboy/widget/dropDown2.dart';
import 'package:notiboy/widget/drop_down.dart';
import 'package:notiboy/widget/loader.dart';
import 'package:notiboy/widget/textfields.dart';
import 'package:notiboy/widget/toast.dart';
import 'package:responsive_builder/responsive_builder.dart';

class NotificationScreen extends StatefulWidget {
  final Function? functionCall;

  const NotificationScreen({Key? key, this.functionCall}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool noNotification = false;
  NotificationReadingModel? notificationReadingModel;
  TextEditingController searchC = TextEditingController();
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
                    selectImage(
                      image: "assets/algorand.png",
                      color: isDark ? Clr.mode : Clr.white,
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
                    setting(context),
                  ],
                ),
              ),
            ),
            noNotification
                ? Expanded(
                    flex: 9,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Image.asset("assets/no_notification.png"),
                            Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 30),
                              child: Text(
                                Str.noNotification,
                                style: TextStyle(
                                  color: isDark ? Clr.white : Clr.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    flex: 9,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            cmnDropDown(title: Str.notification),
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
                                    inputTextStyle: TextStyle(color: isDark ? Clr.white : Clr.black),
                                    fillColor: isDark ? Clr.black : Clr.white,
                                    prefixIcon: Image.asset("assets/search.png"),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: selectImage(image: "assets/filter.png"),
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
                                return notificationText(
                                  logo: "assets/algorand.png",
                                  message:
                                      "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters.",
                                  cmpName: "Artificial Intelligen..",
                                  title: "Announcement",
                                  seenImage: "assets/read_notification.png",
                                  isVerify: true,
                                  boxColor: isDark ? Clr.black : Clr.white,
                                  logoColor: isDark ? Clr.white : Clr.blueBg,
                                  titleColor: isDark ? Clr.white : Clr.black,
                                  textColor: isDark ? Clr.white : Clr.black,
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
            noNotification
                ? Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Image.asset("assets/no_notification.png"),
                        Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            Str.noNotification,
                            style: TextStyle(
                              letterSpacing: 1,
                              color: isDark ? Clr.white : Clr.black,
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                validate: "name",
                                keyboardType: TextInputType.text,
                                textFieldType: "name",
                                inputTextStyle: TextStyle(
                                  color: isDark ? Clr.white : Clr.black,
                                ),
                                fillColor: isDark ? Clr.black : Clr.white,
                                isDense: false,
                                prefixIcon: Image.asset("assets/search.png"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            selectImage(image: "assets/filter.png"),
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
                            return notificationText(
                              logo: "assets/algorand.png",
                              message:
                                  "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters.",
                              cmpName: "Artificial Intelligence Channel",
                              title: "Announcement",
                              seenImage: "assets/read_notification.png",
                              isVerify: true,
                              textColor: isDark ? Clr.white : Clr.black,
                              boxColor: isDark ? Clr.black : Clr.white,
                              titleColor: isDark ? Clr.white : Clr.blue,
                              logoColor: isDark ? Clr.white : Clr.blueBgWeb,
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

  TextStyle hintTS = TextStyle(
    color: Clr.hint,
    fontSize: 15,
  );

  Widget notificationText({
    required String logo,
    required String message,
    required String cmpName,
    required String title,
    required String seenImage,
    required bool isVerify,
    required Color boxColor,
    required Color textColor,
    required Color titleColor,
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
                    // width: kIsWeb ? 250 : 150,
                    child: Text(
                      cmpName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                isVerify ? Image.asset("assets/verify.png") : SizedBox(),
                // Spacer(),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 150,
                  child: Text(title, overflow: TextOverflow.ellipsis, style: hintTS),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                message,
                style: TextStyle(color: textColor, fontSize: 17),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Yesterday, 12:06 P.M.", style: hintTS),
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  "assets/read_notification.png",
                  width: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  notificationReading() async {
    final hasInternet = await checkInternets();
    try {
      Loader.sw();
      final url = baseUrl + "";

      dynamic response = await AllProvider().apiProvider(
        url: url,
        method: Method.get,
      );
      notificationReadingModel = await NotificationReadingModel.fromJson(response);

      if (notificationReadingModel != null) {
        MyToast().succesToast(toast: notificationReadingModel?.message.toString());
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
