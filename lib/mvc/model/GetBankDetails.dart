class GetBankDetails {
  bool? success;
  String? message;
  BankData? data;

  GetBankDetails({this.success, this.message, this.data});

  GetBankDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? BankData.fromJson(json['data']) : null;
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

class BankData {
  String? sId;
  String? uid;
  int? iV;
  String? accountName;
  String? accountNumber;
  String? bankName;
  String? ifscCode;

  BankData(
      {this.sId,
        this.uid,
        this.iV,
        this.accountName,
        this.accountNumber,
        this.bankName,
        this.ifscCode});

  BankData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    uid = json['uid'];
    iV = json['__v'];
    accountName = json['accountName'];
    accountNumber = json['accountNumber'];
    bankName = json['bankName'];
    ifscCode = json['ifscCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['uid'] = this.uid;
    data['__v'] = this.iV;
    data['accountName'] = this.accountName;
    data['accountNumber'] = this.accountNumber;
    data['bankName'] = this.bankName;
    data['ifscCode'] = this.ifscCode;
    return data;
  }
}