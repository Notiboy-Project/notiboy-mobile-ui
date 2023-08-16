import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:notiboy/Model/notification/NotificationReadingModel.dart';
import 'package:notiboy/constant.dart';
import 'package:notiboy/main.dart';
import 'package:notiboy/screen/home/bottom_bar_screen.dart';
import 'package:notiboy/screen/home/channel/channel_screen.dart';
import 'package:notiboy/screen/home/notification/controllers/api_controller.dart';
import 'package:notiboy/service/internet_service.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:notiboy/widget/dropDown2.dart';
import 'package:notiboy/widget/drop_down.dart';
import 'package:notiboy/widget/loader.dart';
import 'package:notiboy/widget/textfields.dart';
import 'package:notiboy/widget/toast.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../Model/notification/optin_channels.dart';
import '../channel/controllers/api_controller.dart';

List<NotificationData>? notificationData;

class NotificationScreen extends StatefulWidget {
  final Function? functionCall;

  const NotificationScreen({Key? key, this.functionCall}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver {
  bool noNotification = false;
  NotificationReadingModel? notificationReadingModel;
  OptinChannels? optinChannels;
  TextEditingController searchC = TextEditingController();
  List<NotificationData> currentFilteredList = [];
  bool isFiltered = false;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      message.data.clear();
      getOptinChannels(); // send to full screen of meeting
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    wait();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('LifeCycleState= $state');
    if (state == AppLifecycleState.detached) {
      // SystemNavigator.pop();
    }
    if (state == AppLifecycleState.resumed) {}
    if (state == AppLifecycleState.paused) {
      print('LifeCycleState= $state');

      // send to full screen of meeting
    }
  }

  wait() async {
    getTheme();
    getOptinChannels();
  }

  getTheme() async {
    isDark = await pref?.getBool("mode") ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark
          ? kIsWeb
              ? Clr.black
              : Clr.dark
          : kIsWeb
              ? Clr.white
              : Clr.blueBg,
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
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
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
                    setting(context),
                  ],
                ),
              ),
            ),
            noNotification
                ? Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Image.asset("assets/no_notification.png"),
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 30),
                          child: Text(
                            Str.noNotification,
                            style: TextStyle(
                              color: isDark ? Clr.white : Clr.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    flex: 9,
                    child: RefreshIndicator(
                      onRefresh: () {
                        return getOptinChannels();
                      },
                      child: SingleChildScrollView(
                        controller: notificationScrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              cmnDropDown(title: Str.notification),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 12,
                                    child: MyTextField(
                                      padding: EdgeInsets.zero,
                                      controller: searchC,
                                      hintText: Str.searchHint,
                                      validate: "name",
                                      keyboardType: TextInputType.text,
                                      textFieldType: "name",
                                      inputTextStyle: TextStyle(
                                          color:
                                              isDark ? Clr.white : Clr.black),
                                      fillColor: isDark ? Clr.black : Clr.white,
                                      prefixIcon:
                                          Image.asset("assets/search.png"),
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          isFiltered = true;
                                          currentFilteredList = notificationData
                                                  ?.where((x) =>
                                                      x.message
                                                          ?.toLowerCase()
                                                          .contains(value
                                                              .toLowerCase()) ??
                                                      false)
                                                  .toList() ??
                                              [];
                                        } else {
                                          isFiltered = false;
                                        }
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  // Expanded(
                                  //   flex: 2,
                                  //   child:
                                  //       selectImage(image: "assets/filter.png"),
                                  // ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: isFiltered
                                    ? currentFilteredList.length
                                    : notificationData?.length ?? 0,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (!isFiltered) if ((notificationReadingModel
                                              ?.paginationMetaData?.next ??
                                          '')
                                      .isNotEmpty) {
                                    if (index ==
                                        (notificationData?.length ?? 0) - 6) {
                                      getNotificationPagination();
                                    }
                                  }
                                  return notificationText(
                                    logo: optinChannels?.data
                                            ?.where((element) =>
                                                element.appId ==
                                                notificationData?[index].appId)
                                            .first
                                            .logo ??
                                        '',
                                    message: isFiltered
                                        ? currentFilteredList[index].message ??
                                            ''
                                        : notificationData?[index].message ??
                                            '',
                                    link: isFiltered
                                        ? currentFilteredList[index].link ?? ''
                                        : notificationData?[index].link ?? '',
                                    cmpName: isFiltered
                                        ? currentFilteredList[index]
                                                .channelName ??
                                            ''
                                        : notificationData?[index]
                                                .channelName ??
                                            '',
                                    title: ((notificationData?[index].kind ??
                                                        '')
                                                    .toLowerCase() ==
                                                'public'
                                            ? 'announcement'
                                            : (notificationData?[index].kind ??
                                                ''))
                                        .capitalize(),
                                    seenImage: "assets/read_notification.png",
                                    isVerify: optinChannels?.data
                                            ?.where((element) =>
                                                element.appId ==
                                                (isFiltered
                                                    ? currentFilteredList[index]
                                                            .appId ??
                                                        ''
                                                    : notificationData?[index]
                                                        .appId))
                                            .first
                                            .verified ??
                                        false,
                                    seenColor: (isFiltered
                                            ? (currentFilteredList[index]
                                                    .seen ??
                                                false)
                                            : (notificationData?[index].seen ??
                                                false))
                                        ? null
                                        : Clr.grey,
                                    boxColor: isDark ? Clr.black : Clr.white,
                                    logoColor: isDark ? Clr.white : Clr.blueBg,
                                    titleColor: isDark ? Clr.white : Clr.black,
                                    textColor: isDark ? Clr.white : Clr.black,
                                    dateTime: isFiltered
                                        ? currentFilteredList[index]
                                                .createdTime ??
                                            ''
                                        : notificationData?[index]
                                                .createdTime ??
                                            '',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  TextStyle hintTS = TextStyle(
    color: Clr.hint,
    fontSize: 15,
  );

  Widget notificationText({
    required String logo,
    required String message,
    required String cmpName,
    required String dateTime,
    required String title,
    required String link,
    required String seenImage,
    required bool isVerify,
    required Color boxColor,
    required Color textColor,
    required Color titleColor,
    required Color logoColor,
    required Color? seenColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          link.isNotEmpty ? launchUrls(link) : null;
        },
        child: Container(
          padding: EdgeInsets.all(15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        selectImage(
                          image: logo,
                          color: logoColor,
                          size: 30,
                          isChannel: true,
                          channelName: cmpName.characters.first,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            cmpName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: titleColor,
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Visibility(
                            visible: isVerify,
                            child: Image.asset("assets/verify.png")),
                        // Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(title,
                            overflow: TextOverflow.ellipsis, style: hintTS),
                        SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: link.isNotEmpty,
                          child: Icon(
                            Icons.link,
                            color: isDark ? Clr.white : Clr.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  message,
                  style: TextStyle(color: textColor, fontSize: 17),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Text(DateFormat.yMEd().add_jms().format(DateTime.parse(dateTime)), style: hintTS),
                  Text(
                      DateFormat.yMMMMd()
                          .add_jm()
                          .format(DateTime.parse(dateTime).toLocal()),
                      style: hintTS),
                  // SizedBox(
                  //   width: 5,
                  // ),
                  // Image.asset(
                  //   seenImage,
                  //   width: 15,
                  //   color: seenColor,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  notificationReading() async {
    checkInternets().then((internet) async {
      if (internet) {
        NotificationApiContorller().getAllNotification().then((response) async {
          notificationReadingModel =
              NotificationReadingModel.fromJson(json.decode(response.body));
          notificationData = notificationReadingModel?.data ?? ([]);
          if (mounted) setState(() {});
          EasyLoading.dismiss();
        }).catchError((onError) {
          EasyLoading.showError(onError.toString());
        });
      } else {
        EasyLoading.showError('Internet Required');
      }
    });
  }

  Future<void> getOptinChannels() async {
    EasyLoading.show(status: 'loading...');
    checkInternets().then((internet) async {
      if (internet) {
        NotificationApiContorller().getOptinChannels().then((response) async {
          optinChannels = OptinChannels.fromJson(json.decode(response.body));
          notificationReading();
        }).catchError((onError) {
          EasyLoading.showError(onError.toString());
        });
      } else {
        EasyLoading.showError('Internet Required');
      }
    });
  }

  getNotificationPagination() {
    checkInternets().then((internet) async {
      if (internet) {
        ChannelApiController()
            .callPaginatedUrl(
                notificationReadingModel?.paginationMetaData?.next ?? '')
            .then((response) async {
          if (mounted) {
            setState(() {
              notificationReadingModel =
                  NotificationReadingModel.fromJson(json.decode(response.body));
              notificationData?.addAll(notificationReadingModel?.data ??
                  ([] as List<NotificationData>));
            });
          }
        }).catchError((onError) {});
      }
    });
  }
}
