import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notiboy/main.dart';
import 'package:notiboy/screen/home/SplashScreen.dart';
import 'package:notiboy/screen/home/select_network_screen.dart';
import 'package:notiboy/service/internet_service.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:notiboy/widget/button.dart';
import 'package:notiboy/widget/drop_down.dart';
import 'package:notiboy/widget/loader.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../Model/user/get_user_model.dart';
import '../../../constant.dart';
import '../../../service/notifier.dart';
import '../../../utils/shared_prefrences.dart';
import '../bottom_bar_screen.dart';
import '../channel/controllers/api_controller.dart';
import 'controllers/api_controller.dart';

class SettingScreen extends StatefulWidget {
  final Function? functionCall;

  const SettingScreen({Key? key, this.functionCall}) : super(key: key);

  @override
  State<SettingScreen> createState() => _Setting_screenState();
}

class _Setting_screenState extends State<SettingScreen> {
  List<VerifyModel> verifyModel = [];
  List<String> notify = [];
  bool isDone = false;

  @override
  void initState() {
    // TODO: implement initState
    getUserDetails();
    super.initState();
    EasyLoading.show(status: 'loading...');
  }

  getTheme() async {
    isDark = await pref?.getBool("mode") ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getTheme();
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
        return _buildMobileBody(context);
    }
  }

  _buildMobileBody(context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      BottomNavigationBar navigationBar =
                          bottomWidgetKey.currentWidget as BottomNavigationBar;
                      navigationBar.onTap!(0);
                    },
                    child: selectImage(
                        image: "assets/nb.png",
                        color: isDark ? Clr.mode : Clr.white),
                  ),
                  Spacer(),
                  // changeMode(
                  //   () {
                  //     widget.functionCall?.call();
                  //     setState(() {});
                  //   },
                  // ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cmnDropDown(title: Str.setting),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? Clr.black : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          settingWidget(
                            title: "Toggle Medium",
                            icon: Icons.data_saver_on,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (___) {
                                    return AlertDialog(
                                        backgroundColor: isDark
                                            ? kIsWeb
                                                ? Clr.black
                                                : Clr.dark
                                            : kIsWeb
                                                ? Clr.white
                                                : Clr.blueBg,
                                        scrollable: true,
                                        title: Text(
                                          'Mediums',
                                          style: TextStyle(
                                              color: isDark
                                                  ? Clr.white
                                                  : Clr.black),
                                        ),
                                        content: StatefulBuilder(builder:
                                            (thisLowerContext, innerSetState) {
                                          return Column(
                                            children: [
                                              Container(
                                                height: 200,
                                                // Change as per your requirement
                                                width: 300.0,
                                                // Change as per your requirement
                                                child: ListView.builder(
                                                  itemCount: verifyModel.length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return notificationType(
                                                      callback: () {
                                                        innerSetState(
                                                          () {},
                                                        );
                                                      },
                                                      title: verifyModel[index]
                                                              .isVerify
                                                          ? '${index == 1 ? 'Discord ID: ' : 'Email: '}' +
                                                              verifyModel[index]
                                                                  .ID
                                                          : verifyModel[index]
                                                              .text,
                                                      isVerify:
                                                          verifyModel[index]
                                                              .isVerify,
                                                      isDark: isDark,
                                                      isOn: notify.contains(
                                                              verifyModel[index]
                                                                  .text
                                                                  .split(" ")
                                                                  .first
                                                                  .toLowerCase()) ??
                                                          false,
                                                      off1: isDark
                                                          ? "assets/off1.png"
                                                          : "assets/offWb1.png",
                                                      off2: isDark
                                                          ? "assets/off2.png"
                                                          : "assets/offWb2.png",
                                                      on1: isDark
                                                          ? "assets/on1.png"
                                                          : "assets/onWb1.png",
                                                      on2: isDark
                                                          ? "assets/on2.png"
                                                          : "assets/onWb2.png",
                                                      index: index,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        }));
                                  });
                            },
                          ),
                          Divider(
                            color: Clr.grey,
                            thickness: 1,
                          ),
                          settingWidget(
                            title: "Switch Network",
                            icon: Icons.swipe,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (___) {
                                    return AlertDialog(
                                      backgroundColor: isDark
                                          ? kIsWeb
                                              ? Clr.black
                                              : Clr.dark
                                          : kIsWeb
                                              ? Clr.white
                                              : Clr.blueBg,
                                      scrollable: true,
                                      title: Text(
                                        'Accounts',
                                        style: TextStyle(
                                            color:
                                                isDark ? Clr.white : Clr.black),
                                      ),
                                      content: Column(
                                        children: [
                                          FutureBuilder(
                                            future: SharedPrefManager()
                                                .getString('Login'),
                                            builder: (__,
                                                AsyncSnapshot<String?>
                                                    snapshot) {
                                              if (snapshot.hasData &&
                                                  !snapshot.hasError) {
                                                List data = json.decode(
                                                    snapshot.data ?? '[{}]');
                                                return Container(
                                                  height: 300.0,
                                                  // Change as per your requirement
                                                  width: 300.0,
                                                  // Change as per your requirement
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: data.length,
                                                    itemBuilder:
                                                        (BuildContext _,
                                                            int index) {
                                                      return InkWell(
                                                        onTap: () async {
                                                          Navigator.pop(_);
                                                          await Future.delayed(
                                                              Duration(
                                                                  microseconds:
                                                                      254),
                                                              () async {
                                                            EasyLoading.show();
                                                            Provider.of<MyChangeNotifier>(
                                                                    navigatorKey!
                                                                        .currentState!
                                                                        .context,
                                                                    listen:
                                                                        false)
                                                                .settoken = data[
                                                                    index]
                                                                ['accessKey'];

                                                            Provider.of<MyChangeNotifier>(
                                                                    navigatorKey!
                                                                        .currentState!
                                                                        .context,
                                                                    listen:
                                                                        false)
                                                                .setXUSERADDRESS = data[
                                                                    index]
                                                                ['address'];
                                                            Provider.of<MyChangeNotifier>(
                                                                        navigatorKey!
                                                                            .currentState!
                                                                            .context,
                                                                        listen:
                                                                            false)
                                                                    .setchain =
                                                                data[index]
                                                                    ['chain'];
                                                            data[index][
                                                                'currentlogin'] = 0;
                                                            String?
                                                                loginOldData =
                                                                await SharedPrefManager()
                                                                    .getString(
                                                                        'Login');
                                                            List<dynamic>
                                                                updateData =
                                                                json.decode(
                                                                    loginOldData ??
                                                                        '[{}]');
                                                            updateData.forEach(
                                                                (element) {
                                                              element[
                                                                  'currentlogin'] = 1;
                                                            });
                                                            updateData
                                                                .where((element) =>
                                                                    element[
                                                                        'address'] ==
                                                                    data[index][
                                                                        'address'])
                                                                .toList()
                                                                .first['currentlogin'] = 0;
                                                            await SharedPrefManager()
                                                                .setString(
                                                                    'Login',
                                                                    jsonEncode(
                                                                        updateData));
                                                            EasyLoading
                                                                .dismiss();
                                                          });
                                                          Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    600),
                                                            () {
                                                              Navigator
                                                                  .pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        const BottomBarScreen()),
                                                                (route) =>
                                                                    false,
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              border: Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                                                                              listen:
                                                                                  false)
                                                                          .XUSERADDRESS ==
                                                                      data[index]
                                                                              [
                                                                              'address']
                                                                          .toString()
                                                                  ? Border.all(
                                                                      color: Colors
                                                                          .blue)
                                                                  : null),
                                                          child: Card(
                                                            color: isDark
                                                                ? kIsWeb
                                                                    ? Clr.black
                                                                    : Clr.dark
                                                                : kIsWeb
                                                                    ? Clr.white
                                                                    : Clr
                                                                        .blueBg,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          5),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    data[index][
                                                                            'chain']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: isDark
                                                                            ? Clr.white
                                                                            : Clr.black),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                      data[index]
                                                                              [
                                                                              'address']
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color: isDark
                                                                              ? Clr.white
                                                                              : Clr.black),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              }
                                              return CircularProgressIndicator();
                                            },
                                          ),
                                          Center(
                                            child: MyButton(
                                              title: "Add Network",
                                              width: 200,
                                              height: 50,
                                              onClick: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SelectNetworkScreen(),
                                                    ));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: MyButton(
                        title: "Go Back",
                        width: 200,
                        height: 50,
                        onClick: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Note: Register using web app ',
                          children: [
                            TextSpan(
                                text: 'app.notiboy.com',
                                style: TextStyle(color: Clr.blue, fontSize: 19),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrls('app.notiboy.com');
                                  }),
                          ],
                          style: TextStyle(
                              color: !isDark ? Clr.black : Clr.white,
                              fontSize: 19)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget settingWidget({
    required String title,
    required IconData icon,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isDark ? Clr.mode : Clr.light,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(icon, color: isDark ? Clr.white : Clr.black),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: TextStyle(
                color: isDark ? Clr.white : Clr.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Clr.grey, size: 15),
          ],
        ),
      ),
    );
  }

  Widget notificationType({
    required String title,
    required bool isVerify,
    required bool isOn,
    required String on1,
    required String on2,
    required String off1,
    required String off2,
    required int index,
    required bool isDark,
    required Function callback,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? Clr.blackBg : Clr.blueBg,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                    color: isDark ? Clr.blueBg : Clr.hint, fontSize: 15),
              ),
            ),
            Visibility(
              visible: isVerify,
              child: InkWell(
                onTap: () async {
                  if (isOn == true) {
                    notify.removeWhere((element) =>
                        element ==
                        verifyModel[index].text.split(" ").first.toLowerCase());
                    isOn = false;
                    SettingApiController().notification(notify.toList());
                    setState(() {});
                    callback.call();
                  } else {
                    isOn = true;
                    notify.add(
                        verifyModel[index].text.split(" ").first.toLowerCase());
                    SettingApiController().notification(notify);
                    setState(() {});
                    callback.call();
                  }
                },
                child: Container(
                  width: 50.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: isOn ? Colors.blue : Colors.grey,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Container(
                      alignment:
                          isOn ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 20.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
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

  getUserDetails() {
    notify.clear();
    verifyModel.clear();
    checkInternets().then((internet) async {
      if (internet) {
        ChannelApiController().getUser().then((response) async {
          EasyLoading.dismiss();
          getUserModel = GetUserModel.fromJson(json.decode(response.body));
          Map<String, dynamic> userdata = jsonDecode(response.body);
          Map mediumData = (userdata['data']['medium_metadata'] as Map);
          mediumData.keys.forEach((element) {
            verifyModel.add(VerifyModel(
                mediumData[element]['ID'],
                mediumData[element]['Verified'],
                '${element} is ${mediumData[element]['Verified'] ? 'Verified' : 'Not Verified'}'));
          });

          getUserModel?.data?.allowed_mediums?.forEach((element) {
            notify.add(element.toString().toLowerCase());
          });

          setState(() {});
        });
      } else {
        EasyLoading.showError('Internet Required');
      }
    });
  }
}

class VerifyModel {
  String ID = '';
  bool isVerify = false;
  String text = '';

  VerifyModel(this.ID, this.isVerify, this.text);
}
