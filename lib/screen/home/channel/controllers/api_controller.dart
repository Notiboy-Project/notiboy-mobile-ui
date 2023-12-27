import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notiboy/constant.dart';
import 'package:notiboy/utils/response.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/contracts.dart';

import '../../../../service/notifier.dart';

class ChannelApiController {
  String XUSERADDRESS = Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context, listen: false).XUSERADDRESS;
  String chain = Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context, listen: false).chain;
  String token = Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context, listen: false).token;

  Future<http.Response> getAllChannels(isVerifiedChannel) async {
    var response = await client.get(
      Uri.parse('$url/chains/$chain/channels?logo=true'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );
    return responses(response);
  }

  Future<http.Response> getAllUnverifiedChannels() async {
    var response = await client.get(
      Uri.parse('$url/chains/$chain/channels?logo=true&verified=false'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );

    return responses(response);
  }

  Future<http.Response> getownedAllChannels() async {
    var response = await client.get(
      Uri.parse(
          '$url/chains/$chain/channels/users/$XUSERADDRESS/owned?logo=true'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );

    return responses(response);
  }

  Future<http.Response> getUser() async {
    var response = await client.get(
      Uri.parse('$url/chains/$chain/users/${XUSERADDRESS}'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );

    return responses(response);
  }

  Future<http.Response> optinChannel(String appId, isVerifiedChannel) async {
    var response = await client.post(
      Uri.parse(
          '$url/chains/$chain/channels/$appId/users/${XUSERADDRESS}/optin?logo=true'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );
    return responses(response);
  }

  Future<http.Response> optoutChannel(String appId, isVerifiedChannel) async {
    var response = await client.delete(
      Uri.parse(
          '$url/chains/$chain/channels/$appId/users/${XUSERADDRESS}/optout?logo=true'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );
    return responses(response);
  }

  Future<http.Response> callPaginatedUrl(String url) async {
    var response = await client.get(
      Uri.parse('$url'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );
    return responses(response);
  }

  Future<http.Response> storeFCM(String fcmToken) async {
    var response = await client.post(
        Uri.parse('$url/chains/$chain/users/$XUSERADDRESS/fcm'),
        headers: {
          'Authorization': 'Bearer $token',
          'X-USER-ADDRESS': '${XUSERADDRESS}',
        },
        body: json.encode({'device_id': fcmToken}));

    return responses(response);
  }
}
