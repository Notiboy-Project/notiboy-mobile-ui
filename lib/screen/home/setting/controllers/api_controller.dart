import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notiboy/constant.dart';
import 'package:notiboy/utils/response.dart';
import 'package:uuid/uuid.dart';

class SettingApiController {
  Future<http.Response> logout() async {
    var uuid = Uuid();
    var response = await http.delete(
      Uri.parse('$url/chains/$chain/users/$XUSERADDRESS/pat/kind/mobile/$uuid'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );

    return responses(response);
  }

  Future<http.Response> notification(List<String> notify) async {
    var response = await http.put(Uri.parse('$url/chains/$chain/users/$XUSERADDRESS'),
        headers: {
          'Authorization': 'Bearer $token',
          'X-USER-ADDRESS': '${XUSERADDRESS}',
        },
        body: jsonEncode({
          "allowed_mediums": notify,
        }));

    return responses(response);
  }
}
