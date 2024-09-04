class GetOtherDetails {
  bool? success;
  String? message;
  OtherData? otherData;

  GetOtherDetails({this.success, this.message, this.otherData});

  GetOtherDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    otherData = json['data'] != null ? OtherData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.otherData != null) {
      data['data'] = this.otherData!.toJson();
    }
    return data;
  }
}

class OtherData {
  String? sId;
  String? uid;
  int? iV;
  String? aadhaarNumber;
  String? gstNumber;
  String? panCardNumber;
  String? udyamNumber;

  OtherData(
      {this.sId,
        this.uid,
        this.iV,
        this.aadhaarNumber,
        this.gstNumber,
        this.panCardNumber,
        this.udyamNumber});

  OtherData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    uid = json['uid'];
    iV = json['__v'];
    aadhaarNumber = json['aadhaarNumber'];
    gstNumber = json['gstNumber'];
    panCardNumber = json['panCardNumber'];
    udyamNumber = json['udyamNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['uid'] = this.uid;
    data['__v'] = this.iV;
    data['aadhaarNumber'] = this.aadhaarNumber;
    data['gstNumber'] = this.gstNumber;
    data['panCardNumber'] = this.panCardNumber;
    data['udyamNumber'] = this.udyamNumber;
    return data;
  }
}