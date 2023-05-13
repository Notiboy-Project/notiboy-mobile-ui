class UserListModel {
  UserListModel({
    this.data,
    this.message,
  });

  UserListModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(UserListData.fromJson(v));
      });
    }
    message = json['message'];
  }

  List<UserListData>? data;
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

class UserListData {
  UserListData({
    this.address,
    this.logo,
    this.status,
  });

  UserListData.fromJson(dynamic json) {
    address = json['address'];
    logo = json['logo'];
    status = json['status'];
  }

  String? address;
  String? logo;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = address;
    map['logo'] = logo;
    map['status'] = status;
    return map;
  }
}
