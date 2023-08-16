class GetChannelList {
  List<Data>? data;
  String? message;
  PaginationMetaData? pagination_meta_data;
  int? status_code;

  GetChannelList(
      {this.data, this.message, this.pagination_meta_data, this.status_code});

  factory GetChannelList.fromJson(Map<String, dynamic> json) {
    return GetChannelList(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => Data.fromJson(i)).toList()
          : null,
      message: json['message'],
      pagination_meta_data: json['pagination_meta_data'] != null
          ? PaginationMetaData.fromJson(json['pagination_meta_data'])
          : null,
      status_code: json['status_code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status_code'] = this.status_code;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    final pagination_meta_data = this.pagination_meta_data;
    if (pagination_meta_data != null) {
      data['pagination_meta_data'] = pagination_meta_data.toJson();
    }
    return data;
  }
}

class Data {
  String? address;
  String? app_id;
  String? chain;
  String? description;
  String? logo;
  String? name;
  bool? verified;

  Data(
      {this.address,
      this.app_id,
      this.chain,
      this.description,
      this.logo,
      this.name,
      this.verified});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      address: json['address'],
      app_id: json['app_id'],
      chain: json['chain'],
      description: json['description'],
      logo: json['logo'],
      name: json['name'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['app_id'] = this.app_id;
    data['chain'] = this.chain;
    data['description'] = this.description;
    data['logo'] = this.logo;
    data['name'] = this.name;
    data['verified'] = this.verified;
    return data;
  }
}

class PaginationMetaData {
  String? next;
  int? page_size;
  String? prev;
  int? size;

  PaginationMetaData({this.next, this.page_size, this.prev, this.size});

  factory PaginationMetaData.fromJson(Map<String, dynamic> json) {
    return PaginationMetaData(
      next: json['next'],
      page_size: json['page_size'],
      prev: json['prev'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next'] = this.next;
    data['page_size'] = this.page_size;
    data['prev'] = this.prev;
    data['size'] = this.size;
    return data;
  }
}
