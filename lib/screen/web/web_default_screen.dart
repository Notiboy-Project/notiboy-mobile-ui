import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:notiboy/screen/home/channel/channel_screen.dart';
import 'package:notiboy/screen/home/notification/notification_screen.dart';
import 'package:notiboy/screen/home/send/send_message_screen.dart';
import 'package:notiboy/screen/home/setting/setting_screen.dart';
import 'package:notiboy/screen/home/statistic/statistic_screen.dart';
import 'package:notiboy/screen/home/support/support_screen.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/const.dart';
import 'package:notiboy/utils/string.dart';

class WebDefaultScreen extends StatefulWidget {
  const WebDefaultScreen({Key? key}) : super(key: key);

  @override
  State<WebDefaultScreen> createState() => _WebDefaultScreenState();
}

class _WebDefaultScreenState extends State<WebDefaultScreen> {
  int selectedInd = 0;
  bool isClick = false;
  List srnList = [
    Str.notification,
    Str.channel,
    Str.send,
    Str.statistic,
    Str.support,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Clr.black : Clr.white,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Image.asset("assets/notiboy.png", width: 200),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ListView.builder(
                      itemCount: srnList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          focusColor: Clr.trans,
                          hoverColor: Clr.trans,
                          highlightColor: Clr.trans,
                          splashColor: Clr.trans,
                          onTap: () {
                            selectedInd = index;
                            setState(() {});
                          },
                          child: cmnCnt(
                            title: srnList[index].toString(),
                            index: index,
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Image.asset("assets/play_store.png", width: 200),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Image.asset("assets/app_store.png", width: 200),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: selectedInd == 0
                  ? NotificationScreen(
                      functionCall: () {
                        setState(() {});
                      },
                    )
                  : selectedInd == 1
                      ? ChannelScreen(
                          functionCall: () {
                            setState(() {});
                          },
                        )
                      : selectedInd == 2
                          ? SendMessageScreen(
                              functionCall: () {
                                setState(() {});
                              },
                            )
                          : selectedInd == 3
                              ? StatisticScreen(
                                  functionCall: () {
                                    setState(() {});
                                  },
                                )
                              : selectedInd == 4
                                  ? SupportScreen(
                                      functionCall: () {
                                        setState(() {});
                                      },
                                    )
                                  : SettingScreen(
                                      functionCall: () {
                                        setState(() {});
                                      },
                                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cmnCnt({required String title, required int index}) {
    return Container(
      alignment: Alignment.center,
      height: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: index == selectedInd
            ? DecorationImage(
                image: AssetImage(
                  isDark ? "assets/list_dark.png" : "assets/list.png",
                ),
              )
            : null,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(100),
          bottomLeft: Radius.circular(100),
        ),
      ),
      child: AutoSizeText(
        minFontSize: 10,
        stepGranularity: 10,
        maxLines: 1,
        title,
        style: TextStyle(
          color: isDark ? Clr.white : Clr.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
