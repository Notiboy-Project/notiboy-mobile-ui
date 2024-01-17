import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:notiboy/Model/chat/Message.dart';
import 'package:web_socket_client/web_socket_client.dart';
import '../../../Model/chat/chatListModel.dart';
import '../Model/chat/enumaration.dart';
import '../screen/home/chat/controller/chat_controller.dart';
import '../screen/home/chat/messages_screens.dart';

class MyChangeNotifier extends ChangeNotifier {
  bool _isUserInMessagingScreen = false;
  String _currentUserAddress = '';
  final ScrollController _controller = ScrollController();

  WebSocket? socket;
  String _XUSERADDRESS =
      'F43T47RRMITUVVHLR7ICKP5VA7FGX7UFQBA7DHRK6WX74DRJYGUT3P5PV4';
  Map<String, List<Message>> _messagesList = {};

  List<Data> _chatList = [];

  String get XUSERADDRESS => _XUSERADDRESS;

  Map<String, List<Message>> get messagesList => _messagesList;

  ScrollController get controller => _controller;

  List<Data>? get chatList => _chatList;

  String _token =
      'eyJhbGciOiJSUzI1NiIsImtpZCI6InNpZy0xNjg2MzgxNzU4In0.eyJjaGFpbiI6ImFsZ29yYW5kIiwiYWRkcmVzcyI6IkY0M1Q0N1JSTUlUVVZWSExSN0lDS1A1VkE3RkdYN1VGUUJBN0RIUks2V1g3NERSSllHVVQzUDVQVjQiLCJraW5kIjoiIiwidXVpZCI6IiIsImF1ZCI6IkY0M1Q0N1JSTUlUVVZWSExSN0lDS1A1VkE3RkdYN1VGUUJBN0RIUks2V1g3NERSSllHVVQzUDVQVjQiLCJleHAiOjE3MDU2NTY3MTQsImlhdCI6MTcwNTA1MTkxNCwiaXNzIjoibm90aWJveSIsInN1YiI6InN0YWdlIn0.Bw1_DKiTemTJInlrIajDZ9bcH47iWceLMB7JB3kmvqC3_tCYRCbJjyeFnkQH2Rburibc9zfQSaOi4IfgnQeUaEq-omSx3IVH1eCFLiC3ZtZtvsOYF9Xs-flxqZMzYiFhTm6-HLYNxEYy9aoqM1oiDvmmunjkutSxYDHv1Ps8W358jopCDNgVQnTNOAf6SS84QBBqu_I6icbmyA95G-HhaLo_eoKNodRWMR3vQt00ptJ_vMHyL1URP4kPTUBFxoObfXkYiOb7rVdXHR7IV9hWdyqvdGqgIcf2PFgE-ZlONhfI4w0lRvClDk61gxy9rzoetmUDd7mRCz8t0XB1R8wSJQ';

  String get token => _token;

  String _chain = 'algorand';

  String get chain => _chain;

  bool get isUserInMessagingScreen => _isUserInMessagingScreen;

  String get currentUserAddress => _currentUserAddress;

  set setUserInMessagingScreen(bool value) {
    _isUserInMessagingScreen = value;
  }

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

  set setCurrentUserAddress(String value) {
    _currentUserAddress = value;
  }

  updateList() {
    notifyListeners();
  }

  void messagesListAdd(String user, Message value) {
    if (!_messagesList.containsKey(user)) {
      _messagesList[user] = [value];
    } else {
      _messagesList[user]?.add(value);
    }
    notifyListeners();
  }

  void updateChatMessages(String user, Message value) {
    _messagesList[user]
        ?.where((element) => element.id == value.id)
        .first
        .setStatus = value.status;
    notifyListeners();
  }

  void messagesListInsert(String user, Message message) {
    if (_messagesList.containsKey(user)) {
      _messagesList[user]?.insert(0, message);
    } else {
      _messagesList = {
        user: [message]
      };
    }
    notifyListeners();
  }

  getChatList() async {
    await ChatApiController().getListOfChats().then((response) async {
      ChatListModel chatListModel =
          ChatListModel.fromJson(json.decode(response.body));
      if (_chatList.isEmpty) {
        chatListModel.data?.forEach((data) {
          if (_chatList
              .where((element) => element.userB == data.userB)
              .isEmpty) {
            _chatList.add(data);
          }
        });
      } else {
        List<Data>? chatData = chatListModel.data?.reversed.toList();
        chatData?.forEach((data) {
          if (chatList
                  ?.where((element) => element.userB == data.userB)
                  .toList()
                  .isNotEmpty ??
              false) {
            _chatList.removeWhere((element) => element.userB == data.userB);
            if (_chatList
                .where((element) => element.userB == data.userB)
                .isEmpty) {
              _chatList.add(data);
              notifyListeners();
            }
          } else {
            _chatList.add(data);
            notifyListeners();
          }
        });
      }
    });
    notifyListeners();
  }
}
