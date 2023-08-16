import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notiboy/constant.dart';
import 'package:notiboy/utils/shared_prefrences.dart';
import '../screen/home/bottom_bar_screen.dart';
import '../screen/home/select_network_screen.dart';
import 'CustomException.dart';

responses(http.Response response) {
  switch (response.statusCode) {
    case 200:
      return response;
    case 400:
      throw InvalidInputException(
          'Error occured while Communication with Server with StatusCode :${response.body}');
    case 401:
      SharedPrefManager().clearAll().then((value) {
        navigatorKey?.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => SelectNetworkScreen(),
            ),
            (route) => false);
      });

      throw UnauthorisedException(response.body.toString());
    case 403:
    case 500:
    default:
      SharedPrefManager().clearAll();

      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode :${response.statusCode}');
  }
}
