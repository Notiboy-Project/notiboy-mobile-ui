import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notiboy/Model/channel/ChannelCreateModel.dart';
import 'package:notiboy/Model/channel/UserListModel.dart';
import 'package:notiboy/constant.dart';
import 'package:notiboy/main.dart';
import 'package:notiboy/screen/home/bottom_bar_screen.dart';
import 'package:notiboy/service/internet_service.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:notiboy/widget/button.dart';
import 'package:notiboy/widget/textfields.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../Model/user/get_user_model.dart';
import 'controllers/api_controller.dart';
import 'model/channel_model.dart';

class ChannelScreen extends StatefulWidget {
  final Function? functionCall;

  const ChannelScreen({Key? key, this.functionCall}) : super(key: key);

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  TextEditingController searchC = TextEditingController();
  ChannelCreateModel? channelCreateModel;
  UserListModel? userListModel;
  GetChannelList? channelListModel;
  List<Data>? channelList;
  List<Data> currentFilteredList = [];
  bool isFiltered = false;
  int channelType = 0;
  bool isVerifiedChannel = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wait();
  }

  @override
  void reassemble() {
    getTheme();
    super.reassemble();
  }

  wait() async {
    getChannels();
    await getTheme();
  }

  getTheme() async {
    isDark = pref?.getBool("mode") ?? false;
    if (mounted) setState(() {});
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
        return _buildMobileBody();
    }
  }

  Widget joinChannel({
    required String logo,
    required String message,
    required String cmpName,
    required String btnTitle,
    required Function() onTap,
    required Color btnColor,
    required bool isVerify,
    required Color boxColor,
    required Color textColor,
    required Color logoColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                selectImage(
                  isChannel: true,
                  channelName: cmpName.characters.first,
                  image: logo,
                  color: logoColor,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: SizedBox(
                    child: Text(
                      cmpName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                isVerify ? Image.asset("assets/verify.png") : SizedBox(),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 17,
                ),
              ),
            ),
            Center(
              child: MyButton(
                title: btnTitle,
                onClick: onTap,
                buttonClr: btnColor,
                width: 150,
              ),
            )
          ],
        ),
      ),
    );
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
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            BottomNavigationBar navigationBar = bottomWidgetKey
                                .currentWidget as BottomNavigationBar;
                            navigationBar.onTap!(0);
                          },
                          child: selectImage(
                            image: "assets/nb.png",
                            color: isDark ? Clr.mode : Clr.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          Str.channel,
                          style: TextStyle(
                            color: isDark ? Clr.white : Clr.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
                      if (isVerifiedChannel) {
                        getChannels(isFromDropDown: true);
                      } else {
                        getAllUnverifiedChannels();
                      }
                    }),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: RefreshIndicator(
                onRefresh: () {
                  if (isVerifiedChannel) {
                    getChannels(isFromDropDown: true);
                  } else {
                    getAllUnverifiedChannels();
                  }
                  return Future(() => false);
                },
                child: SingleChildScrollView(
                  controller: channelScrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        cmnDropDown(
                          title: Str.channel,
                          dropdown: Visibility(
                            visible: channelType == 0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                verifieddropdown(),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  !isVerifiedChannel
                                      ? 'Unverified'
                                      : 'Verified',
                                  style: TextStyle(
                                      color: isDark ? Clr.white : Clr.mode,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 10,
                              child: MyTextField(
                                padding: EdgeInsets.zero,
                                controller: searchC,
                                hintText: Str.searchHint,
                                validate: "name",
                                keyboardType: TextInputType.text,
                                textFieldType: "name",
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    isFiltered = true;
                                    currentFilteredList = channelList
                                            ?.where((x) =>
                                                x.name?.toLowerCase().contains(
                                                    value.toLowerCase()) ??
                                                false)
                                            .toList() ??
                                        [];
                                  } else {
                                    isFiltered = false;
                                  }
                                  setState(() {});
                                },
                                inputTextStyle: TextStyle(
                                  color: isDark ? Clr.white : Clr.black,
                                ),
                                fillColor: isDark ? Clr.black : Clr.white,
                                prefixIcon: Image.asset("assets/search.png"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(flex: 5, child: cmnDropDownForFilter()),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        (isFiltered
                                    ? currentFilteredList.length
                                    : channelList?.length ?? 0) ==
                                0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 30, bottom: 30),
                                    child: Text(
                                      'No Channels are Verified at the Moment',
                                      style: TextStyle(
                                        color: isDark ? Clr.white : Clr.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: isFiltered
                                    ? currentFilteredList.length
                                    : channelList?.length ?? 0,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (!isFiltered) if ((channelListModel
                                              ?.pagination_meta_data?.next ??
                                          '')
                                      .isNotEmpty) {
                                    if (index ==
                                        (channelList?.length ?? 0) - 6) {
                                      getChannelsPagination();
                                    }
                                  }
                                  if (channelType == 1) {
                                    if (!((getUserModel?.data?.channels ?? [])
                                        .contains(isFiltered
                                            ? currentFilteredList[index]
                                                    .app_id ??
                                                ''
                                            : channelList?[index].app_id ??
                                                ''))) {
                                      return Container();
                                    }
                                  }
                                  if (channelType == 2) {
                                    if (!((getUserModel?.data?.optins ?? [])
                                        .contains(isFiltered
                                            ? currentFilteredList[index]
                                                    .app_id ??
                                                ''
                                            : channelList?[index].app_id ??
                                                ''))) {
                                      return Container();
                                    }
                                  }
                                  return joinChannel(
                                    logo: isFiltered
                                        ? currentFilteredList[index].logo ?? ''
                                        : channelList?[index].logo ?? '',
                                    message: isFiltered
                                        ? currentFilteredList[index]
                                                .description ??
                                            ''
                                        : channelList?[index].description ?? '',
                                    cmpName: isFiltered
                                        ? currentFilteredList[index].name ?? ''
                                        : channelList?[index].name ?? '',
                                    isVerify: isFiltered
                                        ? currentFilteredList[index].verified ??
                                            false
                                        : channelList?[index].verified ?? false,
                                    btnTitle: (getUserModel?.data?.optins ?? [])
                                            .contains(isFiltered
                                                ? currentFilteredList[index]
                                                        .app_id ??
                                                    ''
                                                : channelList?[index].app_id ??
                                                    '')
                                        ? 'Opt-out'
                                        : "Opt-in",
                                    btnColor: (getUserModel?.data?.optins ?? [])
                                            .contains(isFiltered
                                                ? currentFilteredList[index]
                                                        .app_id ??
                                                    ''
                                                : channelList?[index].app_id ??
                                                    '')
                                        ? Clr.joinBtnCLr
                                        : Clr.mode,
                                    onTap: () {
                                      if ((getUserModel?.data?.optins ?? [])
                                          .contains(isFiltered
                                              ? currentFilteredList[index]
                                                      .app_id ??
                                                  ''
                                              : channelList?[index].app_id ??
                                                  '')) {
                                        optoutChannel(isFiltered
                                            ? currentFilteredList[index]
                                                    .app_id ??
                                                ''
                                            : channelList?[index].app_id ?? '');
                                        return;
                                      } else {
                                        optinChannels(isFiltered
                                            ? currentFilteredList[index]
                                                    .app_id ??
                                                ''
                                            : channelList?[index].app_id ?? '');
                                        return;
                                      }
                                    },
                                    textColor: isDark ? Clr.white : Clr.black,
                                    logoColor: isDark ? Clr.white : Clr.blueBg,
                                    boxColor: isDark ? Clr.black : Clr.white,
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

  getChannels({isFromDropDown = false}) {
    if (isFromDropDown) {
      EasyLoading.show(status: 'Loading');
    }
    checkInternets().then((internet) async {
      if (internet) {
        ChannelApiController()
            .getAllChannels(isVerifiedChannel)
            .then((response) async {
          if (mounted) {
            setState(() {
              channelListModel =
                  GetChannelList.fromJson(json.decode(response.body));
              channelList = channelListModel?.data ?? ([] as List<Data>);
              channelList?.toSet().toList();
            });
            if (isFromDropDown) {
              EasyLoading.dismiss();
            }
          }
        }).catchError((onError) {
          EasyLoading.showError(onError.toString());
        });
      } else {
        EasyLoading.showError('Internet Required');
      }
    });
  }

  getAllUnverifiedChannels() {
    EasyLoading.show(status: 'Loading');
    checkInternets().then((internet) async {
      if (internet) {
        ChannelApiController()
            .getAllUnverifiedChannels()
            .then((response) async {
          if (mounted) {
            setState(() {
              channelListModel =
                  GetChannelList.fromJson(json.decode(response.body));
              channelList = channelListModel?.data ?? ([] as List<Data>);
            });
            EasyLoading.dismiss();
          }
        }).catchError((onError) {
          EasyLoading.showError(onError.toString());
        });
      } else {
        EasyLoading.showError('Internet Required');
      }
    });
  }

  getChannelsPagination() {
    checkInternets().then((internet) async {
      if (internet) {
        ChannelApiController()
            .callPaginatedUrl(
                channelListModel?.pagination_meta_data?.next ?? '')
            .then((response) async {
          if (!mounted) {
            setState(() {
              channelListModel =
                  GetChannelList.fromJson(json.decode(response.body));
              channelList?.addAll(channelListModel?.data ?? ([] as List<Data>));
              channelList?.toSet().toList();
            });
          }
        }).catchError((onError) {});
      }
    });
  }

  optinChannels(appId) {
    checkInternets().then((internet) async {
      if (internet) {
        ChannelApiController()
            .optinChannel(appId, isVerifiedChannel)
            .then((response) async {
          if (mounted) {
            ChannelApiController().getUser().then((response) async {
              if (mounted) {
                setState(() {
                  getUserModel =
                      GetUserModel.fromJson(json.decode(response.body));
                });
              }
              setState(() {});
            });
          }
        }).catchError((onError) {
          EasyLoading.showError(onError.toString());
        });
      } else {
        EasyLoading.showError('Internet Required');
      }
    });
  }

  optoutChannel(appId) {
    checkInternets().then((internet) async {
      if (internet) {
        ChannelApiController()
            .optoutChannel(appId, isVerifiedChannel)
            .then((response) async {
          if (mounted) {
            ChannelApiController().getUser().then((response) async {
              if (mounted) {
                setState(() {
                  getUserModel =
                      GetUserModel.fromJson(json.decode(response.body));
                });
              }
              setState(() {});
            });
          }
        }).catchError((onError) {
          EasyLoading.showError(onError.toString());
        });
      } else {
        EasyLoading.showError('Internet Required');
      }
    });
  }

  getOwnChannel() {
    EasyLoading.show(status: 'Loading');
    checkInternets().then((internet) async {
      if (internet) {
        ChannelApiController().getownedAllChannels().then((response) async {
          if (mounted) {
            setState(() {
              channelListModel =
                  GetChannelList.fromJson(json.decode(response.body));
              channelList = channelListModel?.data ?? ([] as List<Data>);
            });
            EasyLoading.dismiss();
          }
        }).catchError((onError) {
          EasyLoading.showError(onError.toString());
        });
      } else {
        EasyLoading.showError('Internet Required');
      }
    });
  }

  Widget cmnDropDownForFilter() {
    return dropdown();
  }

  Widget dropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: dpDown(
          title: channelType == 0
              ? "All"
              : channelType == 1
                  ? 'Owned'
                  : 'Opted In',
        ),
        items: [
          DropdownMenuItem(
              child: Text('All', style: TextStyle(color: Clr.white)),
              value: 'All'),
          DropdownMenuItem(
              child: Text('Owned', style: TextStyle(color: Clr.white)),
              value: 'Owned'),
          DropdownMenuItem(
              child: Text('Opted In', style: TextStyle(color: Clr.white)),
              value: 'Opt-in'),
        ],
        onChanged: (value) {
          if (value == 'All') {
            channelType = 0;
            getChannels(isFromDropDown: true);
          } else if (value == 'Owned') {
            channelType = 1;
            getOwnChannel();
          } else if (value == 'Opt-in') {
            channelType = 2;
            getChannels(isFromDropDown: true);
          }
          setState(() {});
        },
        dropdownStyleData: DropdownStyleData(
          width: MediaQuery.of(context).size.width / 2,
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Clr.mode,
          ),
          elevation: 8,
          offset: Offset(0, -5),
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }

  Widget verifieddropdown() {
    return InkWell(
      onTap: () {
        isVerifiedChannel = !isVerifiedChannel;
        setState(() {});
        if (isVerifiedChannel) {
          getChannels(isFromDropDown: true);
        } else if (!isVerifiedChannel) {
          getAllUnverifiedChannels();
        }
      },
      child: Container(
        alignment:
            isVerifiedChannel ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.all(3.0),
        width: 50.0,
        height: 30.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: isVerifiedChannel ? Clr.mode : Clr.mode,
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: selectImage(
          image: "assets/filter.png",
        ),
        items: [
          DropdownMenuItem(
              child: Text('Verified', style: TextStyle(color: Clr.white)),
              value: 'Verified'),
          DropdownMenuItem(
              child: Text('Unverified', style: TextStyle(color: Clr.white)),
              value: 'Unverified'),
        ],
        onChanged: (value) {
          if (value == 'Verified') {
            getChannels();
          } else if (value == 'Unverified') {
            getAllUnverifiedChannels();
          }
          setState(() {});
        },
        dropdownStyleData: DropdownStyleData(
          width: MediaQuery.of(context).size.width / 2,
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Clr.mode,
          ),
          elevation: 8,
          offset: Offset(0, -5),
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}
