
class NotificationReadingModel {
  NotificationReadingModel({
    this.data,
    this.message,
  });

  NotificationReadingModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(NotificationReadingDataModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  List<NotificationReadingDataModel>? data;
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

class NotificationReadingDataModel {
  NotificationReadingDataModel({
    this.message,
    this.link,
    this.appid,
    this.time,
    this.hash,
    this.uuid,
    this.kind,
    this.seen,
  });

  NotificationReadingDataModel.fromJson(dynamic json) {
    message = json['message'];
    link = json['link'];
    appid = json['appid'];
    time = json['time'];
    hash = json['hash'];
    uuid = json['uuid'];
    kind = json['kind'];
    seen = json['seen'];
  }

  String? message;
  String? link;
  String? appid;
  String? time;
  String? hash;
  String? uuid;
  String? kind;
  bool? seen;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['link'] = link;
    map['appid'] = appid;
    map['time'] = time;
    map['hash'] = hash;
    map['uuid'] = uuid;
    map['kind'] = kind;
    map['seen'] = seen;
    return map;
  }
}
