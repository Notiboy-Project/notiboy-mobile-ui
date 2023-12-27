import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notiboy/constant.dart';
import 'package:notiboy/utils/response.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../service/notifier.dart';

class SettingApiController {
  String XUSERADDRESS = Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context, listen: false).XUSERADDRESS;
  String chain = Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context, listen: false).chain;
  String token = Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context, listen: false).token;
  Future<http.Response> logout() async {
    var uuid = Uuid();
    var response = await client.delete(
      Uri.parse('$url/chains/$chain/users/$XUSERADDRESS/pat/kind/mobile/$uuid'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );

    return responses(response);
  }

  Future<http.Response> notification(List<String> notify) async {
    var response = await client.put(Uri.parse('$url/chains/$chain/users/$XUSERADDRESS'),
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
