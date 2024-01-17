import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:notiboy/Model/chat/Message.dart';
import 'package:notiboy/constant.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../../../Model/chat/enumaration.dart';
import '../../../../service/notifier.dart';

class MyChatNotifier extends ChangeNotifier {
  DateTime? _lastDeliveredTime;
  DateTime? _lastAckTime;

  DateTime? get lastDeliveredTime => _lastDeliveredTime;

  DateTime? get lastAckTime => _lastAckTime;

  set lastDeliveredTime(DateTime? value) {
    _lastDeliveredTime = value;
    notifyListeners();
  }

  set lastAckTime(DateTime? value) {
    _lastAckTime = value;
    notifyListeners();
  }

  checkLastMessages(userId, Function callback) async {
    if (Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                listen: false)
            .messagesList[userId]
            ?.where((element) => element.status == MessageStatus.delivered)
            .isNotEmpty ??
        false) {
      List<Message>? messages = Provider.of<MyChangeNotifier>(
              navigatorKey!.currentState!.context,
              listen: false)
          .messagesList[userId]
          ?.where((element) => element.status == MessageStatus.delivered)
          .toList();

      messages?.sort(
        (a, b) => (a.createdAt).compareTo(b.createdAt),
      );

      _lastDeliveredTime = DateTime.fromMillisecondsSinceEpoch(
              (int.parse(messages?.last.createdAt ?? '0')) * 1000)
          .toLocal();
    }
    if (Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                listen: false)
            .messagesList[userId]
            ?.where((element) => element.status == MessageStatus.ack)
            .isNotEmpty ??
        false) {
      List<Message>? ackMessages = Provider.of<MyChangeNotifier>(
              navigatorKey!.currentState!.context,
              listen: false)
          .messagesList[userId]
          ?.where((element) => element.status == MessageStatus.ack)
          .toList();
      ackMessages?.sort(
        (a, b) => (a.createdAt).compareTo(b.createdAt),
      );
      _lastAckTime = DateTime.fromMillisecondsSinceEpoch(
              (int.parse(ackMessages?.last.createdAt ?? '0')) * 1000)
          .toLocal();
    }
  }
}
