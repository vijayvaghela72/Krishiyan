class GetAddressDetails {

  bool? success;
  String? message;
  Address? data;

  GetAddressDetails({this.success, this.message, this.data});

  GetAddressDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Address.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Address {
  String? sId;
  String? uid;
  int? iV;
  String? address;
  String? createdAt;
  String? district;
  String? pincode;
  String? state;
  String? updatedAt;
  String? village;

  Address(
      {this.sId,
        this.uid,
        this.iV,
        this.address,
        this.createdAt,
        this.district,
        this.pincode,
        this.state,
        this.updatedAt,
        this.village});

  Address.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    uid = json['uid'];
    iV = json['__v'];
    address = json['address'];
    createdAt = json['createdAt'];
    district = json['district'];
    pincode = json['pincode'];
    state = json['state'];
    updatedAt = json['updatedAt'];
    village = json['village'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['uid'] = this.uid;
    data['__v'] = this.iV;
    data['address'] = this.address;
    data['createdAt'] = this.createdAt;
    data['district'] = this.district;
    data['pincode'] = this.pincode;
    data['state'] = this.state;
    data['updatedAt'] = this.updatedAt;
    data['village'] = this.village;
    return data;
  }
}