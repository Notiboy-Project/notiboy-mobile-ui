import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notiboy/screen/home/select_network_screen.dart';
import 'package:notiboy/utils/shared_prefrences.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../service/notifier.dart';
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
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SelectNetworkScreen(),
          ));
    } else {
      if (loginData.isEmpty || loginData == '-1') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SelectNetworkScreen(),
            ));
      } else {
        try {
          List listData = json.decode(loginData);
          if(listData.isEmpty){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  // builder: (context) => SelectNetworkScreen(),
                  builder: (context) => SelectNetworkScreen(),
                ));
            return;
          }
          List data = listData
              .where((element) => element['currentlogin'] == 0)
              .toList();
          if (data.isNotEmpty) {
            Map dataQrcode = data.first;
            Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                    listen: false)
                .settoken = dataQrcode['accessKey'];
            Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                    listen: false)
                .setXUSERADDRESS = dataQrcode['address'];
            Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                    listen: false)
                .setchain = dataQrcode['chain'];
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  // builder: (context) => SelectNetworkScreen(),
                  builder: (context) => BottomBarScreen(),
                ));
          }
        } catch (e) {
          print(e);
          SharedPrefManager().clearAll();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                // builder: (context) => SelectNetworkScreen(),
                builder: (context) => SelectNetworkScreen(),
              ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/notiboy_logo.png"),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
