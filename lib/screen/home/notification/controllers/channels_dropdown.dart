import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notiboy/constant.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/widget.dart';

import '../../../../service/internet_service.dart';
import '../../channel/controllers/api_controller.dart';
import '../../channel/model/channel_model.dart';

class SelectChannelDropDown extends StatefulWidget {
  final Function? callback;
  final String? title;
  SelectChannelDropDown({Key? key, this.callback, this.title}) : super(key: key);

  @override
  State<SelectChannelDropDown> createState() => _SelectChannelDropDownState();
}

class _SelectChannelDropDownState extends State<SelectChannelDropDown> {
  GetChannelList? channelListModel;
  List<Data>? channelList;

  @override
  void initState() {
    // TODO: implement initState
    getChannels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        style: TextStyle(color: Clr.white),
        customButton: dpDown2(title:widget.title?? 'Select Channel'),
        items: channelList
            ?.map((e) => DropdownMenuItem(
                value: e, child: buildItem(MenuItem(text: e.name ?? ''))))
            .toList(),
        onChanged: (value) {
          onChanged(context, value);
          // MenuItems.onChanged(context, value as MenuItem);
        },
        dropdownStyleData: DropdownStyleData(
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

  Widget buildItem(MenuItem item) {
    return Text(
      item.text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Clr.white,
      ),
    );
  }

  onChanged(BuildContext context,  item) {
    widget.callback?.call(item);
  }

  getChannels() {

    checkInternets().then((internet) async {
      if (internet) {
        ChannelApiController().getownedAllChannels().then((response) async {
          if (mounted) {
            setState(() {
              channelListModel =
                  GetChannelList.fromJson(json.decode(response.body));
              channelList = channelListModel?.data ?? ([] as List<Data>);
              if(channelList?.isNotEmpty ?? false){
                widget.callback?.call(channelList?.first);
              }
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
}

class MenuItem {
  final String text;

  const MenuItem({
    required this.text,
  });
}
