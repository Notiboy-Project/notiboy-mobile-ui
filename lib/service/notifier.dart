import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../../service/internet_service.dart';
import 'package:http/http.dart' as http;

class MyChangeNotifier extends ChangeNotifier {
  String _XUSERADDRESS = '';
  String get XUSERADDRESS => _XUSERADDRESS;

  String _token = '';
  String get token => _token;

  String _chain = '';
  String get chain => _chain;

  set setXUSERADDRESS(String value) {
    _XUSERADDRESS = value;
    notifyListeners();
  }
  set setchain(String value) {
    _chain = value;
    notifyListeners();
  }
  set settoken(String value) {
    _token = value;
    notifyListeners();
  }

}
