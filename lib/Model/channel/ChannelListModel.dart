class ChannelListModel {
  ChannelListModel({
    this.data,
    this.message,
  });

  ChannelListModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ChannelListData.fromJson(v));
      });
    }
    message = json['message'];
  }

  List<ChannelListData>? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }
}

class ChannelListData {
  ChannelListData({
    this.name,
    this.appId,
    this.verified,
    this.owner,
    this.description,
  });

  ChannelListData.fromJson(dynamic json) {
    name = json['name'];
    appId = json['app_id'];
    verified = json['verified'];
    owner = json['owner'];
    description = json['description'];
  }

  String? name;
  String? appId;
  String? verified;
  String? owner;
  String? description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['app_id'] = appId;
    map['verified'] = verified;
    map['owner'] = owner;
    map['description'] = description;
    return map;
  }
}
