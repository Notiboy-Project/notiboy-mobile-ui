import 'dart:convert';
import 'package:enhanced_paginated_view/enhanced_paginated_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:notiboy/Model/chat/Message.dart';
import 'package:notiboy/Model/chat/enumaration.dart';
import 'package:notiboy/screen/home/chat/controller/chat_controller.dart';
import 'package:notiboy/utils/color.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_client/web_socket_client.dart';
import '../../../constant.dart';
import '../../../service/internet_service.dart';
import '../../../service/notifier.dart';
import '../../../utils/widget.dart';
import 'controller/chat_service.dart';

DateFormat MMMMddyyyy = DateFormat('MMMM dd, yyyy');
DateFormat MMMMddyyyyHH = DateFormat('MMMM dd, yyyy HH:mm');
String dummyId = '';

class MessagesListScreen extends StatefulWidget {
  final String userId;

  const MessagesListScreen({super.key, required this.userId});

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  TextEditingController _messageController = TextEditingController();
  String data = '';
  String? xUserAddress;
  String? chain;
  Uri? wsUrl;
  bool userIsBlocked = false;

  List<String> list = [];

  @override
  void initState() {

    super.initState();
    xUserAddress =
        Provider.of<MyChangeNotifier>(context, listen: false).XUSERADDRESS;

    chain = Provider.of<MyChangeNotifier>(context, listen: false).chain;

    checkUserIsBlockedOrNot();
    if (widget.userId !=
        Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                listen: false)
            .currentUserAddress) {
      ChatApiController.instance.messagesListModel = null;
    }
    Provider.of<MyChangeNotifier>(context, listen: false)
        .setUserInMessagingScreen = true;
    Provider.of<MyChangeNotifier>(context, listen: false)
        .setCurrentUserAddress = widget.userId;
    getMessagesPagination(0);
  }

  bool isLoading = false;
  bool isMaxReached = false;
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 30),
      backgroundColor: isDark ? Color(0xFF302E38) : Clr.blueBg,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Provider.of<MyChangeNotifier>(context, listen: false)
                        .setUserInMessagingScreen = false;

                    Provider.of<MyChangeNotifier>(context, listen: false)
                        .setCurrentUserAddress = '';
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: isDark ? Colors.white : null,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                selectImage(
                  isChannel: true,
                  channelName: widget.userId[0],
                  image: '',
                  color: isDark ? Clr.white : Clr.blueBg,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Tooltip(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  onTriggered: () {
                    Clipboard.setData(ClipboardData(text: widget.userId));
                    showToast('Address is copied',
                        position: ToastPosition.bottom);
                  },
                  message: widget.userId,
                  triggerMode: TooltipTriggerMode.longPress,
                  child: Text(
                    convertUserID(widget.userId),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'sf-semi-midium',
                      color: isDark ? Clr.white : Color(0xFF333333),
                      fontSize: 14,
                    ),
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: popupMenu(),
                  ),
                )
              ],
            ),
          ),
          Divider(thickness: 2),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<MyChangeNotifier>(builder: (context, data, i) {
                var messagesList = data.messagesList;
                return EnhancedPaginatedView<Message>(
                    showError: showError,
                    showLoading: isLoading,
                    isMaxReached: isMaxReached,
                    onLoadMore: (p0) {
                      if ((ChatApiController.instance.messagesListModel
                                  ?.paginationMetaData?.next ??
                              '')
                          .isNotEmpty) {
                        getMessagesPagination(p0);
                      }
                    },
                    itemsPerPage: 40,
                    reverse: true,
                    errorWidget: (page) => Center(
                          child: Column(
                            children: [],
                          ),
                        ),
                    listOfData: messagesList[widget.userId] ?? [],
                    builder: (physics, items, shrinkWrap, reverse) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => Container(),
                        controller: Provider.of<MyChangeNotifier>(context,
                                listen: false)
                            .controller,
                        shrinkWrap: shrinkWrap,
                        reverse: reverse,
                        scrollDirection: Axis.vertical,
                        addAutomaticKeepAlives: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // executes after build
                            if (index == 0) {
                              Provider.of<MyChatNotifier>(context,
                                      listen: false)
                                  .checkLastMessages(widget.userId);
                            }
                          });

                          Message message = items[index];

                          if (message.sendBy == xUserAddress) {
                            return outgoingMessages(message);
                          } else {
                            if (message.id ==
                                (items
                                    .where((element) =>
                                        element.sendBy != xUserAddress)
                                    .toList()
                                    .first
                                    .id)) {
                              if (!list.contains(message.id)) {
                                list.add(message.id);
                                Provider.of<MyChangeNotifier>(
                                        navigatorKey!.currentState!.context,
                                        listen: false)
                                    .socket
                                    ?.send(json.encode({
                                      "kind": "ack",
                                      "uuid": message.id,
                                      "receiver": message.sendBy,
                                      "chain": chain,
                                      "time":
                                          int.parse(message.createdAt ?? '0')
                                    }));
                              }
                            }
                            return incomingMessages(message);
                          }
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [],
                          );
                        },
                      );
                    });
              }),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: _messageController,
              style: TextStyle(
                fontFamily: 'midium',
                color: isDark ? Clr.white : Colors.black,
                fontSize: 16,
              ),
              onChanged: (value) {
                data = value;
              },
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 20, top: 15, bottom: 15),
                  filled: true,
                  fillColor: isDark ? Color(0xFF181B28) : Clr.white,
                  suffixIcon: InkWell(
                    hoverColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                    onTap: () async {
                      checkInternets().then((internet) async {
                        if (internet) {
                          if (widget.userId == xUserAddress) {
                            return;
                          } else if (_messageController.text
                              .trim()
                              .isNotEmpty) {
                            _messageController.clear();
                            dummyId = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();

                            Provider.of<MyChangeNotifier>(context,
                                    listen: false)
                                .messagesListInsert(
                              widget.userId,
                              Message(
                                  id: dummyId,
                                  status: MessageStatus.submitted,
                                  message: data,
                                  receiver: widget.userId,
                                  createdAt: (DateTime.timestamp()
                                          .microsecondsSinceEpoch)
                                      .toString()
                                      .substring(0, 10),
                                  sendBy: xUserAddress ?? ''),
                            );
                            Provider.of<MyChangeNotifier>(context,
                                    listen: false)
                                .socket
                                ?.send(json.encode({
                                  "kind": "chat",
                                  "receiver": widget.userId,
                                  "chain": chain,
                                  "data": data
                                }));
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                    'It seems you are not connected to internet'),
                              );
                            },
                          );
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF0B8BE6),
                      ),
                      child: Image.asset('assets/send_icon.png', height: 20),
                    ),
                  ),
                  hintText: 'Type Something...',
                  hintStyle: TextStyle(
                    fontFamily: 'midium',
                    color: Color(0xFF666666),
                    fontSize: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(
                        color: Color(0xFF0B8BE6),
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: Color(0xFF0B8BE6))),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: Color(0xFF0B8BE6)))),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget outgoingMessages(Message message) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              hoverColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: message.message))
                    .then((result) {
                  showToast('copied', position: ToastPosition.bottom);
                });
              },
              onTap: () {
                message.timeIsVisible.value = !message.timeIsVisible.value;
                for (int i = 0;
                    i <
                        (Provider.of<MyChangeNotifier>(context, listen: false)
                                .messagesList[widget.userId]
                                ?.length ??
                            0);
                    i++) {
                  if (Provider.of<MyChangeNotifier>(context, listen: false)
                          .messagesList[widget.userId]?[i]
                          .id !=
                      message.id)
                    Provider.of<MyChangeNotifier>(context, listen: false)
                        .messagesList[widget.userId]?[i]
                        .timeIsVisible
                        .value = false;
                }
                setState(() {});
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: (MediaQuery.of(context).size.width - 30) * 0.5,
                ),
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Color(0xFF0B8BE6),
                ),
                child: Text(
                  message.message,
                  style: TextStyle(
                    fontFamily: 'sf-semi-midium',
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: message.timeIsVisible.value,
              child: Consumer<MyChatNotifier>(builder: (context, data, index) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // executes after build
                });
                return Row(
                  children: [
                    data.lastAckTime != null &&
                            DateTime.fromMillisecondsSinceEpoch(
                                    (int.parse(message.createdAt)) * 1000)
                                .isBefore(data.lastAckTime!)
                        ? Image.asset(
                            "assets/read_notification.png",
                            width: 15,
                            color: Colors.blue,
                          )
                        : MessageStatus.ack != message.status &&
                                data.lastDeliveredTime != null &&
                                DateTime.fromMillisecondsSinceEpoch(
                                        (int.parse(message.createdAt)) * 1000)
                                    .isBefore(data.lastDeliveredTime!)
                            ? Image.asset(
                                "assets/read_notification.png",
                                width: 15,
                                color: Colors.grey,
                              )
                            : message.status == MessageStatus.submitted
                                ? Icon(
                                    Icons.check_sharp,
                                    size: 15,
                                  )
                                : Image.asset(
                                    "assets/read_notification.png",
                                    width: 15,
                                    color: message.status == MessageStatus.ack
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(
                                  (int.parse(message.createdAt)) * 1000)
                              .toLocal()
                              .isToday()
                          ? DateFormat.Hm().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                      (int.parse(message.createdAt)) * 1000)
                                  .toLocal())
                          : MMMMddyyyyHH.format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                          (int.parse(message.createdAt)) * 1000)
                                      .toLocal())
                              .toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color:
                              isDark ? Color(0xFFAAAAAA) : Color(0xFF666666)),
                    ),
                  ],
                );
              }),
            )
          ],
        ),
      ],
    );
  }

  Widget incomingMessages(Message message) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              hoverColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: message.message))
                    .then((result) {
                  showToast('copied', position: ToastPosition.bottom);
                });
              },
              onTap: () {
                message.timeIsVisible.value = !message.timeIsVisible.value;
                for (int i = 0;
                    i <
                        (Provider.of<MyChangeNotifier>(context, listen: false)
                                .messagesList[widget.userId]
                                ?.length ??
                            0);
                    i++) {
                  if (Provider.of<MyChangeNotifier>(context, listen: false)
                          .messagesList[widget.userId]?[i]
                          .id !=
                      message.id)
                    Provider.of<MyChangeNotifier>(context, listen: false)
                        .messagesList[widget.userId]?[i]
                        .timeIsVisible
                        .value = false;
                }
                setState(() {});
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: (MediaQuery.of(context).size.width - 30) * 0.5,
                ),
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: isDark ? Color(0xFF181B28) : Colors.white,
                ),
                child: Text(
                  message.message,
                  style: TextStyle(
                    fontFamily: 'sf-semi-midium',
                    color: isDark ? Colors.white : Color(0xFF333333),
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: message.timeIsVisible.value,
              child: Row(
                children: [
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(
                                (int.parse(message.createdAt)) * 1000)
                            .toLocal()
                            .isToday()
                        ? DateFormat.Hm().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                    (int.parse(message.createdAt)) * 1000)
                                .toLocal())
                        : MMMMddyyyyHH.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                        (int.parse(message.createdAt)) * 1000)
                                    .toLocal())
                            .toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: isDark ? Color(0xFFAAAAAA) : Color(0xFF666666)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  getMessagesPagination(int page) async {
    await ChatApiController.instance.getMessageData(
      widget.userId,
      context,
    );
  }

  popupMenu() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return InkWell(
        onTap: () {
          if (userIsBlocked) {
            ChatApiController.instance
                .unBlockUser(widget.userId)
                .then((response) {
              ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                  content: Text(jsonDecode(response.body)['message'])));

              checkUserIsBlockedOrNot();
            });
          } else {
            ChatApiController.instance
                .blockUser(widget.userId)
                .then((response) {
              ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                  content: Text(jsonDecode(response.body)['message'])));
              checkUserIsBlockedOrNot();
            });
          }
        },
        child: Text(
          userIsBlocked ? 'Unblock' : "Block",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'sf-semi-midium',
            color: isDark ? Clr.white : Color(0xFF333333),
            fontSize: 14,
          ),
        ),
      );
    });
  }

  checkUserIsBlockedOrNot() async {
    ChatApiController.instance
        .checkUserIsBlockedOrNot(widget.userId)
        .then((response) {
      Map data = jsonDecode(response.body);
      userIsBlocked = data['data'] ?? false;
      setState(() {});
    });
  }
}

MessageStatus getStatus(String status) {
  return status == 'unread'
      ? MessageStatus.unread
      : status == 'delivered'
          ? MessageStatus.delivered
          : status == 'submitted'
              ? MessageStatus.submitted
              : status == 'ack'
                  ? MessageStatus.ack
                  : MessageStatus.submitted;
}
