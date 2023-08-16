class OptinChannels {
  OptinChannels({
      num? statusCode, 
      String? message, 
      List<Data>? data,}){
    _statusCode = statusCode;
    _message = message;
    _data = data;
}

  OptinChannels.fromJson(dynamic json) {
    _statusCode = json['status_code'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  num? _statusCode;
  String? _message;
  List<Data>? _data;

  num? get statusCode => _statusCode;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = _statusCode;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  Data({
      String? name, 
      String? description, 
      String? logo, 
      String? chain, 
      String? appId, 
      String? address, 
      bool? verified,}){
    _name = name;
    _description = description;
    _logo = logo;
    _chain = chain;
    _appId = appId;
    _address = address;
    _verified = verified;
}

  Data.fromJson(dynamic json) {
    _name = json['name'];
    _description = json['description'];
    _logo = json['logo'];
    _chain = json['chain'];
    _appId = json['app_id'];
    _address = json['address'];
    _verified = json['verified'];
  }
  String? _name;
  String? _description;
  String? _logo;
  String? _chain;
  String? _appId;
  String? _address;
  bool? _verified;

  String? get name => _name;
  String? get description => _description;
  String? get logo => _logo;
  String? get chain => _chain;
  String? get appId => _appId;
  String? get address => _address;
  bool? get verified => _verified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['description'] = _description;
    map['logo'] = _logo;
    map['chain'] = _chain;
    map['app_id'] = _appId;
    map['address'] = _address;
    map['verified'] = _verified;
    return map;
  }

}