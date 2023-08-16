import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notiboy/screen/home/select_network_screen.dart';
import 'package:notiboy/utils/shared_prefrences.dart';

import '../../constant.dart';
import 'bottom_bar_screen.dart';
import 'channel/controllers/api_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCredentials();
  }

  getCredentials() async {
    String? loginData = await SharedPrefManager().getString('Login');
    if (loginData == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectNetworkScreen(),
          ));
    } else {
      if (loginData.isEmpty || loginData == '-1') {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectNetworkScreen(),
            ));
      } else {
        Map dataQrcode = json.decode(loginData);
        token = dataQrcode['accessKey'];
        XUSERADDRESS = dataQrcode['address'];
        chain = dataQrcode['chain'];
        Navigator.push(
            context,
            MaterialPageRoute(
              // builder: (context) => SelectNetworkScreen(),
              builder: (context) => BottomBarScreen(),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
