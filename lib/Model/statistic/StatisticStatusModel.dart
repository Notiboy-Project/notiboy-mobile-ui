class StatisticStatusModel {
  StatisticStatusModel({
    this.data,
    this.message,
  });

  StatisticStatusModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(StatisticStatusDataModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  List<StatisticStatusDataModel>? data;
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

class StatisticStatusDataModel {
  StatisticStatusDataModel({
    this.users,
    this.notificationsSent,
    this.channels,
  });

  StatisticStatusDataModel.fromJson(dynamic json) {
    users = json['users'];
    notificationsSent = json['notifications_sent'];
    channels = json['channels'];
  }

  int? users;
  int? notificationsSent;
  int? channels;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['users'] = users;
    map['notifications_sent'] = notificationsSent;
    map['channels'] = channels;
    return map;
  }
}
