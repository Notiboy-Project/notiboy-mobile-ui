/// status_code : 200
/// message : "Successfully fetched notifications"
/// pagination_meta_data : {"size":1,"page_size":1000,"next":"","prev":""}
/// data : [{"message":"We would like to congratulate Algorand for completing 4 years on mainnet. ✅ 1 billion transactions ✅ 31M+ wallets ✅ 29M+ blocks ✅ Zero downtime ","seen":true,"created_time":"2023-06-20T10:10:45.454Z","app_id":"e94e711a-e3be-4829-804f-b9ccfc8264cb","channel_name":"Notiboy","hash":"0df396ed38049d04564a4c1f606dd083a7c0a729b834715781f4ee2a06ead8aab091993a7954c731aa0d322dbe0f2d0520ab8b59691a965eaccd3bfd424844c6","uuid":"a84c318a-a68d-43a9-afa3-dde9e99f4ade","kind":"private"}]

class NotificationReadingModel {
  NotificationReadingModel({
      num? statusCode, 
      String? message, 
      PaginationMetaData? paginationMetaData, 
      List<NotificationData>? data,}){
    _statusCode = statusCode;
    _message = message;
    _paginationMetaData = paginationMetaData;
    _data = data;
}

  NotificationReadingModel.fromJson(dynamic json) {
    _statusCode = json['status_code'];
    _message = json['message'];
    _paginationMetaData = json['pagination_meta_data'] != null ? PaginationMetaData.fromJson(json['pagination_meta_data']) : null;
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(NotificationData.fromJson(v));
      });
    }
  }
  num? _statusCode;
  String? _message;
  PaginationMetaData? _paginationMetaData;
  List<NotificationData>? _data;

  num? get statusCode => _statusCode;
  String? get message => _message;
  PaginationMetaData? get paginationMetaData => _paginationMetaData;
  List<NotificationData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = _statusCode;
    map['message'] = _message;
    if (_paginationMetaData != null) {
      map['pagination_meta_data'] = _paginationMetaData?.toJson();
    }
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// message : "We would like to congratulate Algorand for completing 4 years on mainnet. ✅ 1 billion transactions ✅ 31M+ wallets ✅ 29M+ blocks ✅ Zero downtime "
/// seen : true
/// created_time : "2023-06-20T10:10:45.454Z"
/// app_id : "e94e711a-e3be-4829-804f-b9ccfc8264cb"
/// channel_name : "Notiboy"
/// hash : "0df396ed38049d04564a4c1f606dd083a7c0a729b834715781f4ee2a06ead8aab091993a7954c731aa0d322dbe0f2d0520ab8b59691a965eaccd3bfd424844c6"
/// uuid : "a84c318a-a68d-43a9-afa3-dde9e99f4ade"
/// kind : "private"

class NotificationData {
  NotificationData({
      String? message, 
      bool? seen, 
      bool? isVerify,
      String? createdTime,
      String? appId, 
      String? channelName, 
      String? hash, 
      String? uuid, 
      String? kind,
      String? logo,
      String? link,}){
    _message = message;
    _seen = seen;
    _createdTime = createdTime;
    _appId = appId;
    _channelName = channelName;
    _hash = hash;
    _uuid = uuid;
    _kind = kind;
    _link = link;
    _logo = logo;
    _isVerify = isVerify;
}

  NotificationData.fromJson(dynamic json) {
    _message = json['message'];
    _seen = json['seen'];
    _createdTime = json['created_time'];
    _appId = json['app_id'];
    _channelName = json['channel_name'];
    _hash = json['hash'];
    _uuid = json['uuid'];
    _kind = json['kind'];
    _link = json['link'];
    _logo = json['logo'];
    _isVerify = json['verified'];
  }
  String? _message;
  bool? _seen;
  bool? _isVerify;
  String? _createdTime;
  String? _appId;
  String? _channelName;
  String? _link;
  String? _logo;
  String? _hash;
  String? _uuid;
  String? _kind;

  String? get message => _message;
  bool? get seen => _seen;
  String? get createdTime => _createdTime;
  String? get appId => _appId;
  String? get channelName => _channelName;
  String? get link => _link;
  String? get hash => _hash;
  String? get uuid => _uuid;
  String? get kind => _kind;
  String? get logo => _logo;
  bool? get isVerify => _isVerify;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['seen'] = _seen;
    map['created_time'] = _createdTime;
    map['app_id'] = _appId;
    map['channel_name'] = _channelName;
    map['hash'] = _hash;
    map['uuid'] = _uuid;
    map['kind'] = _kind;
    map['link'] = _link;
    map['logo'] = _logo;
    map['verified'] = _isVerify;
    return map;
  }

}

/// size : 1
/// page_size : 1000
/// next : ""
/// prev : ""

class PaginationMetaData {
  PaginationMetaData({
      num? size, 
      num? pageSize, 
      String? next, 
      String? prev,}){
    _size = size;
    _pageSize = pageSize;
    _next = next;
    _prev = prev;
}

  PaginationMetaData.fromJson(dynamic json) {
    _size = json['size'];
    _pageSize = json['page_size'];
    _next = json['next'];
    _prev = json['prev'];
  }
  num? _size;
  num? _pageSize;
  String? _next;
  String? _prev;

  num? get size => _size;
  num? get pageSize => _pageSize;
  String? get next => _next;
  String? get prev => _prev;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['size'] = _size;
    map['page_size'] = _pageSize;
    map['next'] = _next;
    map['prev'] = _prev;
    return map;
  }

}