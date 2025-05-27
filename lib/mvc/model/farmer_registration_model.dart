class FarmerRegistrationData {
  bool? success;
  String? message;
  FRMRegistrationData? data;

  FarmerRegistrationData({this.success, this.message, this.data});

  FarmerRegistrationData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? FRMRegistrationData.fromJson(json['data'])
        : null;
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

class FRMRegistrationData {
  Farmer? farmer;

  FRMRegistrationData({this.farmer});

  FRMRegistrationData.fromJson(Map<String, dynamic> json) {
    farmer = json['farmer'] != null ? Farmer.fromJson(json['farmer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.farmer != null) {
      data['farmer'] = this.farmer!.toJson();
    }
    return data;
  }
}

class Farmer {
  String? dealerNumber;
  String? name;
  String? whatsappNumber;
  int? totalOwnedFarm;
  String? geoLocationOwnedFarm;
  int? totalLeaseFarm;
  String? geoLocationLeaseFarm;
  String? pincode;
  String? village;
  String? district;
  String? state;
  String? address;
  String? typeOfCultivationPractice;
  String? bankName;
  String? accountName;
  String? accountNumber;
  String? ifscCode;
  String? pan;
  String? aadhaarNumber;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Farmer(
      {this.dealerNumber,
      this.name,
      this.whatsappNumber,
      this.totalOwnedFarm,
      this.geoLocationOwnedFarm,
      this.totalLeaseFarm,
      this.geoLocationLeaseFarm,
      this.pincode,
      this.village,
      this.district,
      this.state,
      this.address,
      this.typeOfCultivationPractice,
      this.bankName,
      this.accountName,
      this.accountNumber,
      this.ifscCode,
      this.pan,
      this.aadhaarNumber,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Farmer.fromJson(Map<String, dynamic> json) {
    dealerNumber = json['dealerNumber'];
    name = json['name'];
    whatsappNumber = json['whatsappNumber'];
    totalOwnedFarm = json['totalOwnedFarm'];
    geoLocationOwnedFarm = json['geoLocationOwnedFarm'];
    totalLeaseFarm = json['totalLeaseFarm'];
    geoLocationLeaseFarm = json['geoLocationLeaseFarm'];
    pincode = json['pincode'];
    village = json['village'];
    district = json['district'];
    state = json['state'];
    address = json['address'];
    typeOfCultivationPractice = json['typeOfCultivationPractice'];
    bankName = json['bankName'];
    accountName = json['accountName'];
    accountNumber = json['accountNumber'];
    ifscCode = json['ifscCode'];
    pan = json['pan'];
    aadhaarNumber = json['aadhaarNumber'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dealerNumber'] = this.dealerNumber;
    data['name'] = this.name;
    data['whatsappNumber'] = this.whatsappNumber;
    data['totalOwnedFarm'] = this.totalOwnedFarm;
    data['geoLocationOwnedFarm'] = this.geoLocationOwnedFarm;
    data['totalLeaseFarm'] = this.totalLeaseFarm;
    data['geoLocationLeaseFarm'] = this.geoLocationLeaseFarm;
    data['pincode'] = this.pincode;
    data['village'] = this.village;
    data['district'] = this.district;
    data['state'] = this.state;
    data['address'] = this.address;
    data['typeOfCultivationPractice'] = this.typeOfCultivationPractice;
    data['bankName'] = this.bankName;
    data['accountName'] = this.accountName;
    data['accountNumber'] = this.accountNumber;
    data['ifscCode'] = this.ifscCode;
    data['pan'] = this.pan;
    data['aadhaarNumber'] = this.aadhaarNumber;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
