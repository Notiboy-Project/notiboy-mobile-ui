import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notiboy/constant.dart';
import 'package:notiboy/screen/home/notification/notification_screen.dart';

import '../../../../utils/response.dart';
import '../../channel/controllers/api_controller.dart';

class NotificationApiContorller {
  Future<http.Response> getAllNotification() async {
    var response = await http.get(
      Uri.parse('$url/chains/$chain/notifications'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );

    return responses(response);
  }

  Future<http.Response> getOptinChannels() async {
    var response = await http.get(
      Uri.parse(
          '$url/chains/$chain/channels/users/${XUSERADDRESS}/optins?logo=true'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );

    return responses(response);
  }

  Future<http.Response> sendNotification(kind, appId, data) async {
    var response = await http.post(
        Uri.parse('$url/chains/$chain/channels/${appId}/notifications/$kind'),
        headers: {
          'Authorization': 'Bearer $token',
          'X-USER-ADDRESS': '${XUSERADDRESS}',
        },
        body: json.encode(data));

    return responses(response);
  }
}
