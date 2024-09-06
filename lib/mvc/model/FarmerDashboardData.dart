import 'dart:convert';

// class FarmerDashboardData {
//   bool? success;
//   String? message;
//   List<FarmerDashboard>? result;
//
//   FarmerDashboardData({this.success, this.message, this.result});
//
//   FarmerDashboardData.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     if (json['data'] != null) {
//       result = <FarmerDashboard>[];
//       json['data'].forEach((v) {
//         result!.add( FarmerDashboard.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.result != null) {
//       data['result'] = this.result!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class FarmerDashboard {
//   String? sId;
//   String? name;
//   String? whatsappNumber;
//   int? totalOwnedFarm;
//   String? geoLocationOwnedFarm;
//   int? totalLeaseFarm;
//   String? geoLocationLeaseFarm;
//   String? pincode;
//   String? village;
//   String? district;
//   String? state;
//   String? address;
//   String? typeOfCultivationPractice;
//   String? bankName;
//   String? accountName;
//   String? accountNumber;
//   String? ifscCode;
//   String? pan;
//   String? aadhaarNumber;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;
//   String? dealerNumber;
//
//   FarmerDashboard(
//       {this.sId,
//         this.name,
//         this.whatsappNumber,
//         this.totalOwnedFarm,
//         this.geoLocationOwnedFarm,
//         this.totalLeaseFarm,
//         this.geoLocationLeaseFarm,
//         this.pincode,
//         this.village,
//         this.district,
//         this.state,
//         this.address,
//         this.typeOfCultivationPractice,
//         this.bankName,
//         this.accountName,
//         this.accountNumber,
//         this.ifscCode,
//         this.pan,
//         this.aadhaarNumber,
//         this.createdAt,
//         this.updatedAt,
//         this.iV,
//         this.dealerNumber});
//
//   FarmerDashboard.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     whatsappNumber = json['whatsappNumber'];
//     totalOwnedFarm = json['totalOwnedFarm'];
//     geoLocationOwnedFarm = json['geoLocationOwnedFarm'];
//     totalLeaseFarm = json['totalLeaseFarm'];
//     geoLocationLeaseFarm = json['geoLocationLeaseFarm'];
//     pincode = json['pincode'];
//     village = json['village'];
//     district = json['district'];
//     state = json['state'];
//     address = json['address'];
//     typeOfCultivationPractice = json['typeOfCultivationPractice'];
//     bankName = json['bankName'];
//     accountName = json['accountName'];
//     accountNumber = json['accountNumber'];
//     ifscCode = json['ifscCode'];
//     pan = json['pan'];
//     aadhaarNumber = json['aadhaarNumber'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//     dealerNumber = json['dealerNumber'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['whatsappNumber'] = this.whatsappNumber;
//     data['totalOwnedFarm'] = this.totalOwnedFarm;
//     data['geoLocationOwnedFarm'] = this.geoLocationOwnedFarm;
//     data['totalLeaseFarm'] = this.totalLeaseFarm;
//     data['geoLocationLeaseFarm'] = this.geoLocationLeaseFarm;
//     data['pincode'] = this.pincode;
//     data['village'] = this.village;
//     data['district'] = this.district;
//     data['state'] = this.state;
//     data['address'] = this.address;
//     data['typeOfCultivationPractice'] = this.typeOfCultivationPractice;
//     data['bankName'] = this.bankName;
//     data['accountName'] = this.accountName;
//     data['accountNumber'] = this.accountNumber;
//     data['ifscCode'] = this.ifscCode;
//     data['pan'] = this.pan;
//     data['aadhaarNumber'] = this.aadhaarNumber;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     data['dealerNumber'] = this.dealerNumber;
//     return data;
//   }
// }

class FarmerDashboardData {
  bool? success;
  String? message;
  List<FarmerDashboard>? farmerDashboard;

  FarmerDashboardData({this.success, this.message, this.farmerDashboard});

  FarmerDashboardData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['FarmerDashboard'] != null) {
      farmerDashboard = <FarmerDashboard>[];
      json['FarmerDashboard'].forEach((v) {
        farmerDashboard!.add(new FarmerDashboard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.farmerDashboard != null) {
      data['FarmerDashboard'] =
          this.farmerDashboard!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FarmerDashboard {
  FarmerDetails? farmerDetails;
  List<CropCultivationDetails>? cropCultivationDetails;

  FarmerDashboard({required this.farmerDetails, required this.cropCultivationDetails});

  factory FarmerDashboard.fromJson(Map<String, dynamic> json) {
    var list = json['cropCultivationDetails'] as List;
    List<CropCultivationDetails> cropsList = list.map((i) => CropCultivationDetails.fromJson(i)).toList();
    return FarmerDashboard(
      farmerDetails: FarmerDetails.fromJson(json['farmerDetails']),
      cropCultivationDetails: cropsList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.farmerDetails != null) {
      data['farmerDetails'] = this.farmerDetails!.toJson();
    }
    if (this.cropCultivationDetails != null) {
      data['cropCultivationDetails'] =
          this.cropCultivationDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FarmerDetails {
  String? sId;
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
  String? createdAt;
  String? updatedAt;
  int? iV;

  FarmerDetails(
      {this.sId,
        this.dealerNumber,
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
        this.createdAt,
        this.updatedAt,
        this.iV});

  FarmerDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
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
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class CropCultivationDetails {
  String? sId;
  String? dealerNumber;
  String? fid;
  String? farmerName;
  String? crops;
  String? variety;
  String? dateOfSowing;
  String? geolocation;
  String? typeOfCultivationPractice;
  int? areaInAcres;
  String? geoLinkAreaOnMap;
  int? iV;

  CropCultivationDetails({this.sId,
    this.dealerNumber,
    this.fid,
    this.farmerName,
    this.crops,
    this.variety,
    this.dateOfSowing,
    this.geolocation,
    this.typeOfCultivationPractice,
    this.areaInAcres,
    this.geoLinkAreaOnMap,
    this.iV});

  CropCultivationDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    dealerNumber = json['dealerNumber'];
    fid = json['fid'];
    farmerName = json['farmerName'];
    crops = json['crops'];
    variety = json['variety'];
    dateOfSowing = json['dateOfSowing'];
    geolocation = json['geolocation'];
    typeOfCultivationPractice = json['typeOfCultivationPractice'];
    areaInAcres = json['areaInAcres'];
    geoLinkAreaOnMap = json['geoLinkAreaOnMap'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['dealerNumber'] = this.dealerNumber;
    data['fid'] = this.fid;
    data['farmerName'] = this.farmerName;
    data['crops'] = this.crops;
    data['variety'] = this.variety;
    data['dateOfSowing'] = this.dateOfSowing;
    data['geolocation'] = this.geolocation;
    data['typeOfCultivationPractice'] = this.typeOfCultivationPractice;
    data['areaInAcres'] = this.areaInAcres;
    data['geoLinkAreaOnMap'] = this.geoLinkAreaOnMap;
    data['__v'] = this.iV;
    return data;
  }
}