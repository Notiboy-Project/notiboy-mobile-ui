import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/const.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:notiboy/widget/drop_down.dart';
import 'package:notiboy/widget/textfields.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SupportScreen extends StatefulWidget {
  final Function? functionCall;

  const SupportScreen({Key? key, this.functionCall}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController searchC = TextEditingController();
  final List<String> items = [
    'Spouse',
    'Partner',
    'Friend',
    'Other',
  ];
  List<SupportModel> queList = [
    SupportModel(
        question: "It is a long established fact that a reader will be distracted by the readable content?",
        answer:
            "The point of using Lorem Ipsum is that it has a normal distribution? The point of using Lorem Ipsum is that it has a normal distribution? The point of using Lorem Ipsum is that it has a normal distribution? The point of using Lorem Ipsum is that it has a normal distribution? The point of using Lorem Ipsum. The point of using Lorem Ipsum is that it has a normal distribution?",
        isClick: false),
    SupportModel(
        question: "The point of using Lorem Ipsum is that it has a normal distribution?",
        answer:
            "The point of using Lorem Ipsum is that it has a normal distribution? The point of using Lorem Ipsum is that it has a normal distribution? The point of using Lorem Ipsum is that it has a normal distribution? The point of using Lorem Ipsum is that it has a normal distribution? The point of using Lorem Ipsum. The point of using Lorem Ipsum is that it has a normal distribution?",
        isClick: false),
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
                      cmnDropDown(title: "notiboy.xyz@gmail.com"),
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
                            question: queList[index].question,
                            isClick: queList[index].isClick,
                            answer: queList[index].answer,
                            boxColor: isDark ? Clr.black : Clr.white,
                            textStyle: TextStyle(
                              color: isDark ? Clr.white : Clr.black,
                              fontSize: 15,
                            ),
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

  SupportModel({required this.question, required this.answer, required this.isClick});
}
