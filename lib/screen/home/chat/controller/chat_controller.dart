import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:notiboy/Model/chat/enumaration.dart';
import 'package:notiboy/constant.dart';
import 'package:notiboy/utils/response.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/contracts.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../../../Model/chat/Message.dart';
import '../../../../Model/chat/messages_list_model.dart';
import '../../../../service/internet_service.dart';
import '../../../../service/notifier.dart';
import '../messages_screens.dart';
import 'chat_service.dart';

class ChatApiController {
  String XUSERADDRESS = Provider.of<MyChangeNotifier>(
          navigatorKey!.currentState!.context,
          listen: false)
      .XUSERADDRESS;
  String chain = Provider.of<MyChangeNotifier>(
          navigatorKey!.currentState!.context,
          listen: false)
      .chain;
  String token = Provider.of<MyChangeNotifier>(
          navigatorKey!.currentState!.context,
          listen: false)
      .token;


  MessagesListModel? _messagesListModel;

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  getMessageData(userId, context,Function callback) {

    checkInternets().then((internet) async {
      if (internet) {
        await ChatApiController()
            .callPaginatedUrl(
            _messagesListModel?.paginationMetaData?.next ?? '', userId)
            .then((response) async {
          _messagesListModel =
              MessagesListModel.fromJson(json.decode(response.body));
          for (var element in _messagesListModel!.data!) {
            Message message = Message(
                id: element.uuid ?? '',
                status: getStatus(element.status ?? ''),
                message: element.message ?? '',
                createdAt: element.sentTime.toString(),
                sendBy: element.sender ?? '',
                receiver: element.userB ?? '',
                timeIsVisible: false);
            if (Provider.of<MyChangeNotifier>(context, listen: false)
                .messagesList
                .isEmpty) {
              Provider.of<MyChangeNotifier>(context, listen: false)
                  .messagesListAdd(userId, message);
            } else {
              if (!(Provider.of<MyChangeNotifier>(context, listen: false)
                      .messagesList[userId]
                      ?.any((element) => element.id == message.id) ??
                  false)) {
                try {
                  if (DateTime.fromMillisecondsSinceEpoch((int.parse(
                              Provider.of<MyChangeNotifier>(context,
                                          listen: false)
                                      .messagesList[userId]
                                      ?.first
                                      .createdAt ??
                                  '0') *
                          1000))
                      .isBefore(DateTime.fromMillisecondsSinceEpoch(
                          (int.parse(message.createdAt) * 1000)))) {
                    Provider.of<MyChangeNotifier>(context, listen: false)
                        .messagesListInsert(userId, message);
                  } else {
                    Provider.of<MyChangeNotifier>(context, listen: false)
                        .messagesListAdd(userId, message);
                  }
                } catch (e) {
                  print(e);
                }
              }
            }
          }
        }).catchError((onError) {});

        // Provider.of<MyChangeNotifier>(context, listen: false)
        //     .controller
        //     .jumpTo(
        //   Provider.of<MyChangeNotifier>(context, listen: false)
        //       .messagesList[widget.userId]
        //       ?.indexWhere((element) {
        //     return element.id ==
        //         (Provider.of<MyChangeNotifier>(context, listen: false)
        //             .messagesList[widget.userId]
        //             ?.where((element) =>
        //         element.status == MessageStatus.unread)
        //             .toList()
        //             .last
        //             .id);
        //   }).toDouble() ??
        //       0.0,
        // );
        if ((_messagesListModel?.paginationMetaData?.next?.isNotEmpty ??
            false)) {
          getMessageData(userId, context,callback);
        }
      }
    });
    Provider.of<MyChatNotifier>(
        navigatorKey!.currentState!.context,
        listen: false).checkLastMessages(userId,callback);
  }

  checkInternet() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (event) async {
        if (!(event == ConnectivityResult.none)) {
          connectSocket();
          if (Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                  listen: false)
              .isUserInMessagingScreen) {
            getMessageData(
                Provider.of<MyChangeNotifier>(
                        navigatorKey!.currentState!.context,
                        listen: false)
                    .currentUserAddress,
                navigatorKey!.currentState!.context,(){});
          }
        }
      },
    );
  }

  Future connectSocket() {
    Uri wsUrl = Uri.parse(
        'wss://testnet.notiboy.com/api/stage/v1/ws/chat?chain=${chain}&address=${XUSERADDRESS}&token=${token}');
    Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
            listen: false)
        .socket = WebSocket(
      wsUrl,
      pingInterval: Duration(seconds: 30),
    );
    return Future(() => true);
  }

  Future<http.Response> getListOfChats() async {
    var response = await client.get(
      Uri.parse('$url/chains/${chain}/chat/messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );
    return responses(response);
  }

  Future<http.Response> callPaginatedUrl(String pageState, String user) async {
    var response = await client.get(
      Uri.parse(
          '$url/chains/${chain}/chat/user/${user}/messages?page_size=40&page_state=$pageState'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );
    return responses(response);
  }

  Future<http.Response> blockUser(String user) async {
    var response = await client.post(
      Uri.parse('$url/chains/${chain}/chat/${user}/block'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );

    return responses(response);
  }

  Future<http.Response> unBlockUser(String user) async {
    var response = await client.post(
      Uri.parse('$url/chains/${chain}/chat/${user}/unblock'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );
    return responses(response);
  }

  Future<http.Response> checkUserIsBlockedOrNot(String user) async {
    var response = await client.get(
      Uri.parse('$url/chains/${chain}/chat/${user}/block'),
      headers: {
        'Authorization': 'Bearer $token',
        'X-USER-ADDRESS': '${XUSERADDRESS}',
      },
    );
    return responses(response);
  }
}
