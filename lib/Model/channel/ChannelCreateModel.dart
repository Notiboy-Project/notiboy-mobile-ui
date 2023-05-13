class ChannelCreateModel {
  ChannelCreateModel({
    this.status,
    this.message,
    this.data,
  });

  ChannelCreateModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CreateChannelDataModel.fromJson(json['data']) : null;
  }

  String? status;
  String? message;
  CreateChannelDataModel? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class CreateChannelDataModel {
  CreateChannelDataModel({
    this.appId,
  });

  CreateChannelDataModel.fromJson(dynamic json) {
    appId = json['app_id'];
  }

  String? appId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['app_id'] = appId;
    return map;
  }
}
