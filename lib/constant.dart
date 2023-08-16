import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Model/user/get_user_model.dart';

bool isDark = false;
const version = 'v1';
String token = '';
String XUSERADDRESS = '';
String chain = '';
GlobalKey<NavigatorState>? navigatorKey = GlobalKey();
const url = '${'https://app.notiboy.com/api'}/$version';
late GetUserModel getUserModel;
var bottomWidgetKey = new GlobalKey<State<BottomNavigationBar>>();

Future<void> launchUrls(url) async {
  if (!url.toString().contains('http')) {
    url = 'https://' + url;
  } else if (!url.toString().contains('https')) {
    url = 'https://' + url;
  }
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
