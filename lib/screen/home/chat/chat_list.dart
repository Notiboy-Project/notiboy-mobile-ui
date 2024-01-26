import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notiboy/Model/chat/enumaration.dart';
import 'package:notiboy/main.dart';
import 'package:notiboy/screen/home/chat/messages_screens.dart';
import 'package:notiboy/service/notifier.dart';
import 'package:notiboy/service/pushnotification.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:notiboy/widget/textfields.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../Model/chat/Message.dart';
import '../../../Model/chat/chatListModel.dart';
import '../../../constant.dart';
import '../../../service/internet_service.dart';
import '../../../utils/color.dart';
import 'controller/chat_controller.dart';

class ChatListScreen extends StatefulWidget {
  final Function? functionCall;

  const ChatListScreen({super.key, this.functionCall});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  TextEditingController searchC = TextEditingController();

  wait() async {
    getTheme();
  }

  getTheme() async {
    isDark = await pref?.getBool("mode") ?? false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    wait();
    Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
            listen: false)
        .getChatList();

    super.initState();
    ChatApiController.instance.checkInternet();
    ChatApiController.instance.connectSocket().then((value) {
      Provider.of<MyChangeNotifier>(context, listen: false)
          .socket
          ?.messages
          .listen((message) {
        data(message);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Color(0xFF302E38) : Clr.blueBg,
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return _mainBody(sizingInformation.deviceScreenType);
        },
      ),
    );
  }

  Widget _mainBody(DeviceScreenType deviceScreenType) {
    switch (deviceScreenType) {
      case DeviceScreenType.mobile:
      default:
        return _buildMobileBody();
    }
  }

  _buildMobileBody() {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  selectImage(
                    image: "assets/nb.png",
                    color: isDark ? Clr.mode : Clr.white,
                  ),
                  Spacer(),
                  changeMode(
                    () {
                      widget.functionCall?.call();
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  setting(context, () {
                    wait();
                  }),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chats',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Clr.white : Clr.black,
                      fontFamily: 'sf-semi-midium',
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        _displayTextInputDialog(context);
                      },
                      child: Icon(
                        Icons.add,
                        color: isDark ? Clr.white : Clr.black,
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              MyTextField(
                padding: EdgeInsets.zero,
                controller: searchC,
                hintText: Str.searchAddress,
                validate: "name",
                keyboardType: TextInputType.text,
                textFieldType: "name",
                inputTextStyle:
                    TextStyle(color: isDark ? Clr.white : Clr.black),
                fillColor: isDark ? Clr.black : Clr.white,
                prefixIcon: Image.asset("assets/search.png"),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              Expanded(
                child:
                    Consumer<MyChangeNotifier>(builder: (context, data, index) {
                  data.chatList?.sort(
                    (a, b) => DateTime.fromMillisecondsSinceEpoch(
                            (int.parse(b.sentTime.toString())) * 1000)
                        .compareTo(DateTime.fromMillisecondsSinceEpoch(
                            (int.parse(a.sentTime.toString())) * 1000)),
                  );
                  List<Data>? chatData = data.chatList;
                  return (searchC.text.trim().isEmpty
                              ? (chatData?.length ?? 0)
                              : chatData?.where((element) {
                                  return (element.userB ?? '')
                                      .toLowerCase()
                                      .contains(
                                          searchC.text.trim().toLowerCase());
                                }).length) ==
                          0
                      ? Center(
                          child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Image.asset('assets/no_chatlist.png'),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'No chats to show',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDark ? Clr.white : Clr.black,
                                fontFamily: 'sf-semi-midium',
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ))
                      : ListView.builder(
                          itemCount: searchC.text.trim().isEmpty
                              ? chatData?.length ?? 0
                              : chatData
                                  ?.where((element) {
                                    return (element.userB ?? '')
                                        .toLowerCase()
                                        .contains(
                                            searchC.text.trim().toLowerCase());
                                  })
                                  .toList()
                                  .length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            bool isSeen = true;
                            Data? data = chatData?.where((element) {
                              return (element.userB ?? '')
                                  .toLowerCase()
                                  .contains(searchC.text.trim().toLowerCase());
                            }).toList()[index];

                            return InkWell(
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MessagesListScreen(
                                          userId: data?.userB ?? ' '),
                                    ));
                                searchC.clear();
                                Provider.of<MyChangeNotifier>(
                                        navigatorKey!.currentState!.context,
                                        listen: false)
                                    .getChatList();
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 15),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    selectImage(
                                      isChannel: true,
                                      channelName: (data?.userB ?? '')[0],
                                      image: '',
                                      color: isDark ? Clr.white : Clr.blueBg,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Tooltip(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        onTriggered: () {
                                          Clipboard.setData(ClipboardData(
                                              text: data?.userB ?? ''));
                                          showToast('Address is copied',
                                              position: ToastPosition.bottom);
                                        },
                                        message: data?.userB ?? '',
                                        triggerMode:
                                            TooltipTriggerMode.longPress,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              convertUserID(data?.userB ?? ''),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'sf-semi-midium',
                                                color: isDark
                                                    ? Clr.white
                                                    : Color(0xFF333333),
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              (data?.message ?? ''),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'midium',
                                                  color: isDark
                                                      ? Color(0xFF666666)
                                                      : Color(0xFF666666),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          timeAgoSinceDate(
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                          (data?.sentTime
                                                                      ?.toInt() ??
                                                                  0) *
                                                              1000)
                                                      .toLocal(),
                                                  numericDates: true)
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF666666)),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Builder(builder: (context) {
                                          List<Data>? userMessageData = chatData
                                              ?.where((element) =>
                                                  (element.sender ==
                                                      data?.sender) &&
                                                  (element.sender !=
                                                      Provider.of<MyChangeNotifier>(
                                                              context,
                                                              listen: false)
                                                          .XUSERADDRESS))
                                              .toList();

                                          if (userMessageData?.isEmpty ??
                                              true) {
                                            return Container();
                                          }
                                          if (userMessageData?.last.status == 'submitted' ||
                                              userMessageData?.last.status ==
                                                  'delivered' ||
                                              userMessageData?.last.status ==
                                                  'unread')
                                            return Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isDark
                                                      ? Color(0xFFe0f2f1)
                                                      : Clr.black
                                                          .withOpacity(0.5)),
                                            );
                                          return Container();
                                        })
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    final TextEditingController _textFieldController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: isDark ? Color(0xFF302E38) : Clr.blueBg,
              title: Text(
                'New Chat',
                style: TextStyle(color: isDark ? Clr.white : null),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _textFieldController,
                    style: TextStyle(color: isDark ? Clr.white : null),
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: "Enter User Address",
                        border: isDark
                            ? OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))
                            : null,
                        enabledBorder: isDark
                            ? OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))
                            : null,
                        focusedBorder: isDark
                            ? OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))
                            : null,
                        hintStyle: TextStyle(color: isDark ? Clr.white : null)),
                  ),
                  Visibility(
                    visible: _textFieldController.text.trim() ==
                        Provider.of<MyChangeNotifier>(context, listen: false)
                            .XUSERADDRESS,
                    child: Text(
                      'You can not do enter your own address.',
                      style: TextStyle(color: Clr.red),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                MaterialButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: const Text('Chat'),
                  onPressed: () {
                    if (_textFieldController.text.trim() !=
                        Provider.of<MyChangeNotifier>(context, listen: false)
                            .XUSERADDRESS) {
                      if (_textFieldController.text.trim().isNotEmpty &&
                          _textFieldController.text.trim().length > 10) {
                        Future.delayed(Duration(milliseconds: 10), () async {
                          await Navigator.push(
                              navigatorKey!.currentState!.context,
                              MaterialPageRoute(
                                  builder: (context) => MessagesListScreen(
                                        userId: _textFieldController.text,
                                      )));
                          Provider.of<MyChangeNotifier>(
                                  navigatorKey!.currentState!.context,
                                  listen: false)
                              .getChatList();
                        });
                        Navigator.pop(context);
                      }
                    } else {}
                  },
                ),
              ],
            );
          });
        });
  }

  data(message) {
    Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
            listen: false)
        .getChatList();
    if (jsonDecode(message)['status'] == 'blocked') {
      Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
              listen: false)
          .messagesList[(jsonDecode(message) as Map)['user_a']]
          ?.removeAt(0);
      showDialog(
        context: context,
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
              'You have been blocked',
              style: TextStyle(color: isDark ? Clr.white : Clr.black),
            ),
          );
        },
      );
    }

    if (((jsonDecode(message) as Map)['status'] == 'submitted') ||
        (jsonDecode(message) as Map)['status'] == 'delivered') {
      if (Provider.of<MyChangeNotifier>(context, listen: false)
          .isUserInMessagingScreen)
        Provider.of<MyChangeNotifier>(context, listen: false)
            .messagesList[Provider.of<MyChangeNotifier>(context, listen: false)
                .currentUserAddress]
            ?.first
            .setid = (jsonDecode(message) as Map)['uuid'];

      Provider.of<MyChangeNotifier>(context, listen: false)
          .messagesList[Provider.of<MyChangeNotifier>(context, listen: false)
              .currentUserAddress]
          ?.first
          .setStatus = getStatus((jsonDecode(message) as Map)['status']);
    }
    if ((jsonDecode(message) as Map).containsKey('sender') &&
        (jsonDecode(message) as Map)['status'] != 'ack') {
      if ((jsonDecode(message) as Map)['sender'].toString().isNotEmpty) {
        List<Message> messageQuery = Provider.of<MyChangeNotifier>(
                    navigatorKey!.currentState!.context,
                    listen: false)
                .messagesList[(jsonDecode(message) as Map)['user_a']]
                ?.where((element) =>
                    element.id == (jsonDecode(message) as Map)['uuid'])
                .toList() ??
            [];
        if (messageQuery.isEmpty) {
          Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                  listen: false)
              .messagesListInsert(
            (jsonDecode(message) as Map)['user_a'],
            Message(
                id: (jsonDecode(message) as Map)['uuid'],
                status: !(jsonDecode(message) as Map).containsKey('status')
                    ? MessageStatus.ack
                    : getStatus(jsonDecode(message)['status'].toString() ?? ''),
                message: jsonDecode(message)['message'],
                createdAt: jsonDecode(message)['sent_time'].toString(),
                sendBy: jsonDecode(message)['sender'],
                receiver: jsonDecode(message)['user_b']),
          );
        } else {
          Provider.of<MyChangeNotifier>(context, listen: false)
              .messagesList[(jsonDecode(message) as Map)['user_a']]
              ?.where((element) => element.id == messageQuery.first.id)
              .first
              .setStatus = MessageStatus.delivered;
        }
      }
    }

    if ((jsonDecode(message) as Map)['status'] == 'ack') {
      List<Message> messageQuery = Provider.of<MyChangeNotifier>(
                  navigatorKey!.currentState!.context,
                  listen: false)
              .messagesList[(jsonDecode(message) as Map)['sender']]
              ?.where((element) =>
                  element.id == (jsonDecode(message) as Map)['uuid'])
              .toList() ??
          [];
      if (messageQuery.isNotEmpty) {
        messageQuery.first.setStatus = MessageStatus.ack;
        Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                listen: false)
            .updateList();
      }
    }
    Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
            listen: false)
        .updateList();
  }
}
