import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notiboy/main.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:notiboy/widget/drop_down.dart';
import 'package:notiboy/widget/textfields.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../constant.dart';

class SupportScreen extends StatefulWidget {
  final Function? functionCall;

  const SupportScreen({Key? key, this.functionCall}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController searchC = TextEditingController();

  List<SupportModel> queList = [
    SupportModel(
        question: "What is the cost of creating a channel?",
        answer: "Channel creation and verification is free of cost.",
        isClick: false),
    SupportModel(
        question: "How much does it cost to send notifications?",
        answer:
            "Sending notifications is free of cost. But in free tier there will be restrictions in the number of notifications that can be sent.",
        isClick: false),
    SupportModel(
        question: "How can I start receiving notifications ?",
        answer:
            "You can start receiving notifications by opting-in to a channel. When you opt-out of a channel you will stop receiving notifications. It is free to opt-in and opt-out of a channel.",
        isClick: false),
    SupportModel(
        question: "Can i get notifications via email and discord?",
        answer:
            "Yes, you can start getting notifications via discord & email by verifying via settings page in web app.",
        isClick: false),
    SupportModel(
        question: "Are there any premium plans?",
        answer:
            "There are premium plans for a channel creator. Visit our web app for more details.",
        isClick: false),
  ];

  List<SupportModel> currentFilteredList = [];
  bool isFiltered = false;

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
                      Str.support,
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
                    setting(context, () {
                      setState(() {});
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
                      cmnDropDown(title: ''),
                      SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        padding: EdgeInsets.zero,
                        controller: searchC,
                        hintText: Str.findHint,
                        validate: "name",
                        inputTextStyle: TextStyle(
                          color: isDark ? Clr.white : Clr.black,
                        ),
                        keyboardType: TextInputType.text,
                        textFieldType: "name",
                        fillColor: isDark ? Clr.black : Clr.white,
                        prefixIcon: Image.asset("assets/search.png"),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            isFiltered = true;
                            currentFilteredList = queList
                                .where((x) => x.question
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          } else {
                            isFiltered = false;
                          }
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: isFiltered
                            ? currentFilteredList.length
                            : queList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return supportList(
                            question: isFiltered
                                ? currentFilteredList[index].question
                                : queList[index].question,
                            isClick: isFiltered
                                ? currentFilteredList[index].isClick
                                : queList[index].isClick,
                            answer: isFiltered
                                ? currentFilteredList[index].answer
                                : queList[index].answer,
                            boxColor: isDark ? Clr.black : Clr.white,
                            textStyle: TextStyle(
                              color: isDark ? Clr.white : Clr.black,
                              fontSize: 15,
                            ),
                            onTap: () {
                              if (isFiltered) {
                                if (currentFilteredList[index].isClick ==
                                    true) {
                                  currentFilteredList[index].isClick = false;
                                } else {
                                  currentFilteredList[index].isClick = true;
                                }
                              } else {
                                if (queList[index].isClick == true) {
                                  queList[index].isClick = false;
                                } else {
                                  queList[index].isClick = true;
                                }
                              }
                              setState(() {});
                            },
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
                  selectImage(
                    image: "assets/algorand.png",
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "notiboy.xyz@gmail.com",
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
                  setting(context, () {
                    setState(() {});
                  }),
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
                  MyTextField(
                    padding: EdgeInsets.zero,
                    controller: searchC,
                    hintText: Str.findHint,
                    validate: "name",
                    keyboardType: TextInputType.text,
                    inputTextStyle: TextStyle(
                      color: isDark ? Clr.white : Clr.black,
                    ),
                    textFieldType: "name",
                    fillColor: isDark ? Clr.black : Clr.white,
                    prefixIcon: Image.asset("assets/search.png"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: queList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return supportList(
                        textStyle: TextStyle(
                          color: isDark ? Clr.white : Clr.black,
                          fontSize: 15,
                        ),
                        boxColor: isDark ? Clr.black : Clr.white,
                        question: queList[index].question,
                        isClick: queList[index].isClick,
                        answer: queList[index].answer,
                        onTap: () {
                          if (queList[index].isClick == true) {
                            queList[index].isClick = false;
                          } else {
                            queList[index].isClick = true;
                          }
                          setState(() {});
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget supportList({
    required String question,
    required bool isClick,
    required String answer,
    required Function() onTap,
    required TextStyle textStyle,
    required Color boxColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: InkWell(
        splashColor: Clr.trans,
        highlightColor: Clr.trans,
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: textStyle,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: Image.asset(
                      isClick ? "assets/arrow_up.png" : "assets/arrow_down.png",
                      width: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: isClick ? 10 : 0,
              ),
              isClick
                  ? Text(
                      answer,
                      style: ansTS,
                    )
                  : SizedBox(
                      height: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle queTSDark = TextStyle(
    color: Clr.white,
    fontSize: 15,
  );
  TextStyle queTSLight = TextStyle(
    color: isDark ? Clr.white : Clr.black,
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  TextStyle ansTS = TextStyle(
    color: Clr.hint,
    fontSize: 13,
  );
}

class SupportModel {
  String question;
  String answer;
  bool isClick;

  SupportModel(
      {required this.question, required this.answer, required this.isClick});
}
