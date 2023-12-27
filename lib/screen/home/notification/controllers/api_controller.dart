import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notiboy/constant.dart';
import 'package:provider/provider.dart';
import '../../../../service/notifier.dart';
import '../../../../utils/response.dart';

class NotificationApiContorller {
  String XUSERADDRESS = Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context, listen: false).XUSERADDRESS;
  String chain = Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context, listen: false).chain;
  String token = Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context, listen: false).token;
  Future<http.Response> getAllNotification() async {
    var response = await client.get(
      Uri.parse('$url/chains/$chain/notifications'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );
    return responses(response);
  }

  Future<http.Response> getOptinChannels() async {
    var response = await client.get(
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
    var response = await client.post(
        Uri.parse('$url/chains/$chain/channels/${appId}/notifications/$kind'),
        headers: {
          'Authorization': 'Bearer $token',
          'X-USER-ADDRESS': '${XUSERADDRESS}',
        },
        body: json.encode(data));

    return responses(response);
  }
}
