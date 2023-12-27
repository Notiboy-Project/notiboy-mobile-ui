/// status_code : 200
/// message : "User profile retrieved successfully"
/// data : {"medium_metadata":{"Email":{"ID":"","Verified":false},"Discord":{"ID":"","DMChannelID":"","Verified":false}},"status":"ACTIVE","channels":["1246f5e6-1d3d-4f4d-8be2-76db572688b4"],"chain":"algorand","address":"K2H67YFEH5JA5JWZQ5CVP5EZO3MXIN6AC5RZNEU6JRPZZMTP5LJRAFQEJE"}

class GetUserModel {
  GetUserModel({
    int? statusCode,
    String? message,
    UserData? data,
  }) {
    _statusCode = statusCode;
    _message = message;
    _data = data;
  }

  GetUserModel.fromJson(dynamic json) {
    _statusCode = json['status_code'];
    _message = json['message'];
    _data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  int? _statusCode;
  String? _message;
  UserData? _data;

  int? get statusCode => _statusCode;

  String? get message => _message;

  UserData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = _statusCode;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

/// medium_metadata : {"Email":{"ID":"","Verified":false},"Discord":{"ID":"","DMChannelID":"","Verified":false}}
/// status : "ACTIVE"
/// channels : ["1246f5e6-1d3d-4f4d-8be2-76db572688b4"]
/// chain : "algorand"
/// address : "K2H67YFEH5JA5JWZQ5CVP5EZO3MXIN6AC5RZNEU6JRPZZMTP5LJRAFQEJE"

class UserData {
  UserData({
    MediumMetadata? mediumMetadata,
    String? status,
    List<String>? channels,
    List<String>? optins,
    List<String>? allowed_mediums,
    String? chain,
    String? address,
    Privileges? privileges,
  }) {
    _mediumMetadata = mediumMetadata;
    _status = status;
    _channels = channels;
    _chain = chain;
    _address = address;
    _optins = optins;
    _allowed_mediums = allowed_mediums;
    _privileges = privileges;
  }

  UserData.fromJson(dynamic json) {
    _mediumMetadata = json['medium_metadata'] != null
        ? MediumMetadata.fromJson(json['medium_metadata'])
        : null;

    _privileges = json['privileges'] != null
        ? Privileges.fromJson(json['privileges'])
        : null;
    _status = json['status'];
    _channels = json['channels'] != null ? json['channels'].cast<String>() : [];
    _optins = json['optins'] != null ? json['optins'].cast<String>() : [];
    _allowed_mediums = json['allowed_mediums'] != null
        ? json['allowed_mediums'].cast<String>()
        : [];
    _chain = json['chain'];
    _address = json['address'];
  }

  MediumMetadata? _mediumMetadata;
  Privileges? _privileges;
  String? _status;
  List<String>? _channels;
  List<String>? _optins;
  List<String>? _allowed_mediums;
  String? _chain;
  String? _address;

  MediumMetadata? get mediumMetadata => _mediumMetadata;

  Privileges? get privileges => _privileges;

  String? get status => _status;

  List<String>? get channels => _channels;

  List<String>? get allowed_mediums => _allowed_mediums;

  List<String>? get optins => _optins;

  String? get chain => _chain;

  String? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_mediumMetadata != null) {
      map['medium_metadata'] = _mediumMetadata?.toJson();
    }
    if (_privileges != null) {
      map['privileges'] = _privileges?.toJson();
    }
    map['status'] = _status;
    map['channels'] = _channels;
    map['optins'] = _optins;
    map['chain'] = _chain;
    map['address'] = _address;
    return map;
  }
}

/// Email : {"ID":"","Verified":false}
/// Discord : {"ID":"","DMChannelID":"","Verified":false}

class MediumMetadata {
  MediumMetadata({
    Email? email,
    Discord? discord,
  }) {
    _email = email;
    _discord = discord;
  }

  MediumMetadata.fromJson(dynamic json) {
    _email = json['Email'] != null ? Email.fromJson(json['Email']) : null;
    _discord =
        json['Discord'] != null ? Discord.fromJson(json['Discord']) : null;
  }

  Email? _email;
  Discord? _discord;

  Email? get email => _email;

  Discord? get discord => _discord;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_email != null) {
      map['Email'] = _email?.toJson();
    }
    if (_discord != null) {
      map['Discord'] = _discord?.toJson();
    }
    return map;
  }
}

/// ID : ""
/// DMChannelID : ""
/// Verified : false

class Discord {
  Discord({
    String? id,
    String? dMChannelID,
    bool? verified,
  }) {
    _id = id;
    _dMChannelID = dMChannelID;
    _verified = verified;
  }

  Discord.fromJson(dynamic json) {
    _id = json['ID'];
    _dMChannelID = json['DMChannelID'];
    _verified = json['Verified'];
  }

  String? _id;
  String? _dMChannelID;
  bool? _verified;

  String? get id => _id;

  String? get dMChannelID => _dMChannelID;

  bool? get verified => _verified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = _id;
    map['DMChannelID'] = _dMChannelID;
    map['Verified'] = _verified;
    return map;
  }
}

/// ID : ""
/// Verified : false

class Email {
  Email({
    String? id,
    bool? verified,
  }) {
    _id = id;
    _verified = verified;
  }

  Email.fromJson(dynamic json) {
    _id = json['ID'];
    _verified = json['Verified'];
  }

  String? _id;
  bool? _verified;

  String? get id => _id;

  bool? get verified => _verified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = _id;
    map['Verified'] = _verified;
    return map;
  }
}

class Privileges {
  Privileges({
    int? notificationCharCount,
  }) {
    _notificationCharCount = notificationCharCount;
  }

  Privileges.fromJson(dynamic json) {
    _notificationCharCount = json['notification_char_count'];
  }

  int? _notificationCharCount;

  int? get notificationCharCount => _notificationCharCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notification_char_count'] = _notificationCharCount;
    return map;
  }
}
