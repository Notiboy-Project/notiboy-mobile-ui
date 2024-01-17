import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notiboy/Model/chat/enumaration.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'Model/user/get_user_model.dart';

bool isDark = false;
const version = 'v1';
GlobalKey<NavigatorState>? navigatorKey = GlobalKey();
const url = '${'https://testnet.notiboy.com/api/stage'}/$version';
// const url = '${'https://app.notiboy.com/api'}/$version';
GetUserModel? getUserModel;

var bottomWidgetKey = GlobalKey<State<BottomNavigationBar>>();
var client = new http.Client();

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

String timeAgoSinceDate(DateTime date,{bool numericDates = true}) {
  final date2 = DateTime.now().toLocal();
  final difference = date2.difference(date);
  final aDate = DateTime(date.year, date.month, date.day);
  final today = DateTime(date2.year, date2.month, date2.day);

  if (difference.inSeconds < 5) {
    return 'Just now';
  } else if (difference.inSeconds <= 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes <= 1) {
    return (numericDates) ? '1 minute ago' : 'A minute ago';
  } else if (difference.inMinutes <= 60) {
    return '${difference.inMinutes} minutes ago';
  }else if(aDate == today) {
    return 'today';
  }
  return DateFormat("dd/MM/yyyy").format(date.toLocal());
}
extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == day &&
        now.month == month &&
        now.year == year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }
}
String convertUserID(String XUserId) {
  String first4 = XUserId.substring(0, 5); //<-- this string will be abcde
  String last4 = XUserId.substring(
      XUserId.length - 5, XUserId.length); //<-- this string will be abcde

  return first4 + '....' + last4;
}
