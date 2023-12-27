import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notiboy/screen/home/channel/channel_screen.dart';
import 'package:notiboy/screen/home/notification/notification_screen.dart';
import 'package:notiboy/screen/home/send/send_message_screen.dart';
import 'package:notiboy/screen/home/statistic/statistic_screen.dart';
import 'package:notiboy/screen/home/support/support_screen.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/shared_prefrences.dart';

import '../../Model/user/get_user_model.dart';
import '../../constant.dart';
import '../../main.dart';
import '../../service/internet_service.dart';
import 'channel/controllers/api_controller.dart';

int selectedIndex = 0;
ScrollController notificationScrollController = ScrollController();
ScrollController channelScrollController = ScrollController();

class BottomBarScreen extends StatefulWidget {
  final Function? callback;

  const BottomBarScreen({Key? key, this.callback}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  void _onItemTapped(int index) {
    if (selectedIndex == index) {
      if (selectedIndex == 0)
        notificationScrollController.animateTo(
          notificationScrollController.position.minScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      if (selectedIndex == 1)
        channelScrollController.animateTo(
          channelScrollController.position.minScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
    }
    setState(() {
      selectedIndex = index;
      getTheme();
    });
  }

  @override
  void initState() {
    wait();
    super.initState();
  }

  wait() async {
    await getTheme();
    await getUser();
    FirebaseMessaging.instance.getToken().then((token) {
      ChannelApiController().storeFCM(token ?? '');
    }).catchError((onError) {});
  }

  getTheme() async {
    isDark = await pref?.getBool("mode") ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: [
          NotificationScreen(
            functionCall: () {
              setState(() {});
            },
          ),
          ChannelScreen(
            functionCall: () {
              setState(() {});
            },
          ),
          SendMessageScreen(
            functionCall: () {
              setState(() {});
            },
          ),
          SupportScreen(
            functionCall: () {
              setState(() {});
            },
          ),
        ],
        index: selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: bottomWidgetKey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "",
            icon: Image.asset(
              "assets/notification_1.png",
              width: 30,
              color: selectedIndex == 0 ? Clr.blue : Clr.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Image.asset(
              "assets/channel_1.png",
              width: 30,
              color: selectedIndex == 1 ? Clr.blue : Clr.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Image.asset(
              "assets/home_bottom.png",
              color: selectedIndex == 2 ? Clr.blue : Clr.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Image.asset(
              "assets/message_question.png",
              color: selectedIndex == 3 ? Clr.blue : Clr.grey,
            ),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        backgroundColor: isDark ? Clr.dark : Clr.white,
        iconSize: 20,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: _onItemTapped,
        elevation: 5,
      ),
    );
  }

  getUser() {
    checkInternets().then((internet) async {
      if (internet) {
        ChannelApiController().getUser().then((response) async {
          if (mounted) {
            setState(() {
              getUserModel = GetUserModel.fromJson(json.decode(response.body));
            });
          }
        }).catchError((onError) {
          EasyLoading.showError(onError.toString());
        });
      } else {
        EasyLoading.showError('Internet Required');
      }
    });
  }
}
