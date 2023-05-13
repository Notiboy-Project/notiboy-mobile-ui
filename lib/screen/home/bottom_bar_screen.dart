import 'package:flutter/material.dart';
import 'package:notiboy/screen/home/channel/channel_screen.dart';
import 'package:notiboy/screen/home/notification/notification_screen.dart';
import 'package:notiboy/screen/home/statistic/statistic_screen.dart';
import 'package:notiboy/screen/home/support/support_screen.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/const.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = [];

  // <Widget>[
  //   NotificationScreen(),
  //   ChannelScreen(),
  //   StatisticScreen(),
  //   SupportScreen(),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _widgetOptions = [
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
      StatisticScreen(
        functionCall: () {
          setState(() {});
        },
      ),
      SupportScreen(
        functionCall: () {
          setState(() {});
        },
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "",
            icon: Image.asset(
              "assets/notification.png",
              color: _selectedIndex == 0 ? Clr.blue : Clr.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Image.asset(
              "assets/share.png",
              color: _selectedIndex == 1 ? Clr.blue : Clr.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Image.asset(
              "assets/home_bottom.png",
              color: _selectedIndex == 2 ? Clr.blue : Clr.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Image.asset(
              "assets/message_question.png",
              color: _selectedIndex == 3 ? Clr.blue : Clr.grey,
            ),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: isDark ? Clr.dark : Clr.white,
        iconSize: 20,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: _onItemTapped,
        elevation: 5,
      ),
    );
  }
}
