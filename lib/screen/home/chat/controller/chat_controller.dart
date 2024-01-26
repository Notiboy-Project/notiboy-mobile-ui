import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:notiboy/Model/chat/enumaration.dart';
import 'package:notiboy/constant.dart';
import 'package:notiboy/utils/color.dart';
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
import 'package:web_socket_client/src/connection_state.dart' as status;

class ChatApiController {
  static ChatApiController _instance = ChatApiController._();

  ChatApiController._();

  static ChatApiController get instance => _instance;

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

  MessagesListModel? messagesListModel;

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  getMessageData(String userId, context, {bool isFromIInternet = false}) {
    if (userId.isNotEmpty) {
      checkInternets().then((internet) async {
        if (internet) {
          await callPaginatedUrl(
                  isFromIInternet
                      ? ''
                      : (messagesListModel?.paginationMetaData?.next ?? ''),
                  userId)
              .then((response) async {
            messagesListModel =
                MessagesListModel.fromJson(json.decode(response.body));
            messagesListModel!.data
                ?.sort((a, b) => (a.sentTime).compareTo(b.sentTime));
            for (var element in messagesListModel!.data!) {
              Message message = Message(
                  id: element.uuid ?? '',
                  status: getStatus(element.status ?? ''),
                  message: element.message ?? '',
                  createdAt: element.sentTime.toString(),
                  sendBy: element.sender ?? '',
                  receiver: element.userB ?? '',
                  timeIsVisible: false);
              if (Provider.of<MyChangeNotifier>(context, listen: false)
                      .messagesList[userId]
                      ?.isEmpty ??
                  true) {
                Provider.of<MyChangeNotifier>(context, listen: false)
                    .messagesListAdd(userId, message);
              } else {
                if (!(Provider.of<MyChangeNotifier>(context, listen: false)
                        .messagesList[userId]
                        ?.any((element) => element.id == message.id) ??
                    true)) {
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
        }
      });
    }
  }

  checkInternet() {
    bool isDialogOpen = false;
    bool isFirstTime = true;
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (event) async {
        if (!(event == ConnectivityResult.none)) {
          if (isDialogOpen) {
            isDialogOpen = false;
            navigatorKey?.currentState?.pop();
          }
          if (!isFirstTime) {
            isFirstTime = false;
            await connectSocket();
          }


          if (Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                  listen: false)
              .isUserInMessagingScreen) {
            Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                    listen: false)
                .socket
                ?.connection
                .listen((status.ConnectionState events) {
              if (event == ConnectivityResult.none ) {
                EasyLoading.dismiss();
              } else if (events is status.Connected ||
                  events is status.Reconnected) {
                EasyLoading.dismiss();
              } else if (events is status.Connected ||
                  events is status.Reconnecting) {
                EasyLoading.show();
              }
            });
            getMessageData(
                Provider.of<MyChangeNotifier>(
                        navigatorKey!.currentState!.context,
                        listen: false)
                    .currentUserAddress,
                navigatorKey!.currentState!.context,
                isFromIInternet: true);
          }
          Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                  listen: false)
              .getChatList();
        } else {
            EasyLoading.dismiss();
          isDialogOpen = true;
          isDialogOpen = (await showDialogs()) ?? false;
        }
      },
    );
  }

  showDialogs() {
    return showDialog(
      context: navigatorKey!.currentState!.context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark
              ? kIsWeb
                  ? Clr.black
                  : Clr.dark
              : kIsWeb
                  ? Clr.white
                  : Clr.blueBg,
          content: Text(
            'It seems you are not connected to internet.',
            style: TextStyle(color: isDark ? Clr.white : Clr.black),
          ),
        );
      },
    );
  }

  Future connectSocket() {
    if (Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                listen: false)
            .socket
            ?.connection
            .state is Connected ||
        (Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                listen: false)
            .socket
            ?.connection
            .state is Reconnected)) {
      return Future(() => true);
    }
    Uri wsUrl = Uri.parse(
        'wss://$domainUrl/ws/chat?chain=${chain}&address=${XUSERADDRESS}&token=${token}');
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
