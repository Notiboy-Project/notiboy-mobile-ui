class NotificationCreateModel {
  NotificationCreateModel({
    this.status,
    this.message,
    this.data,
  });

  NotificationCreateModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? NotificationCreateDataModel.fromJson(json['data']) : null;
  }

  String? status;
  String? message;
  NotificationCreateDataModel? data;

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

class NotificationCreateDataModel {
  NotificationCreateDataModel({
    this.uuid,
    this.hash,
  });

  NotificationCreateDataModel.fromJson(dynamic json) {
    uuid = json['uuid'];
    hash = json['hash'];
  }

  String? uuid;
  String? hash;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = uuid;
    map['hash'] = hash;
    return map;
  }
}
