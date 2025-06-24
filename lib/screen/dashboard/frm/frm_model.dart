class InsightData {
  bool? success;
  String? message;
  List<InsightDetails>? data;

  InsightData({this.success, this.message, this.data});

  InsightData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InsightDetails>[];
      json['data'].forEach((v) {
        data!.add(InsightDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InsightDetails {
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

  InsightDetails(
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

  InsightDetails.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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

// ******************************************************************************

class InsightDataModel {
  bool? success;
  String? message;
  List<InsightDetails>? data;

  InsightDataModel({this.success, this.message, this.data});

  InsightDataModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    success = json['success'] as bool?;
    message = json['message'] as String?;
    if (json['data'] != null && json['data'] is List) {
      data = <InsightDetails>[];
      for (var v in json['data']) {
        if (v is Map<String, dynamic>) {
          data!.add(InsightDetails.fromJson(v));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InsightDetailsModel {
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

  InsightDetailsModel({
    this.sId,
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
    this.iV,
  });

  InsightDetailsModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    sId = json['_id'] as String?;
    dealerNumber = json['dealerNumber'] as String?;
    name = json['name'] as String?;
    whatsappNumber = json['whatsappNumber'] as String?;
    totalOwnedFarm = json['totalOwnedFarm'] is num
        ? (json['totalOwnedFarm'] as num).toInt()
        : null;
    geoLocationOwnedFarm = json['geoLocationOwnedFarm'] as String?;
    totalLeaseFarm = json['totalLeaseFarm'] is num
        ? (json['totalLeaseFarm'] as num).toInt()
        : null;
    geoLocationLeaseFarm = json['geoLocationLeaseFarm'] as String?;
    pincode = json['pincode'] as String?;
    village = json['village'] as String?;
    district = json['district'] as String?;
    state = json['state'] as String?;
    address = json['address'] as String?;
    typeOfCultivationPractice = json['typeOfCultivationPractice'] as String?;
    bankName = json['bankName'] as String?;
    accountName = json['accountName'] as String?;
    accountNumber = json['accountNumber'] as String?;
    ifscCode = json['ifscCode'] as String?;
    pan = json['pan'] as String?;
    aadhaarNumber = json['aadhaarNumber'] as String?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
    iV = json['__v'] is num ? (json['__v'] as num).toInt() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['dealerNumber'] = dealerNumber;
    data['name'] = name;
    data['whatsappNumber'] = whatsappNumber;
    data['totalOwnedFarm'] = totalOwnedFarm;
    data['geoLocationOwnedFarm'] = geoLocationOwnedFarm;
    data['totalLeaseFarm'] = totalLeaseFarm;
    data['geoLocationLeaseFarm'] = geoLocationLeaseFarm;
    data['pincode'] = pincode;
    data['village'] = village;
    data['district'] = district;
    data['state'] = state;
    data['address'] = address;
    data['typeOfCultivationPractice'] = typeOfCultivationPractice;
    data['bankName'] = bankName;
    data['accountName'] = accountName;
    data['accountNumber'] = accountNumber;
    data['ifscCode'] = ifscCode;
    data['pan'] = pan;
    data['aadhaarNumber'] = aadhaarNumber;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

// FarmerDetailsModel with null safety
class FarmerDetailsModel {
  final String id;
  final String dealerNumber;
  final String name;
  final String whatsappNumber;
  final double totalOwnedFarm;
  final String geoLocationOwnedFarm;
  final double totalLeaseFarm;
  final String geoLocationLeaseFarm;
  final String pincode;
  final String village;
  final String district;
  final String state;
  final String address;
  final String typeOfCultivationPractice;
  final String bankName;
  final String accountName;
  final String accountNumber;
  final String ifscCode;
  final String pan;
  final String aadhaarNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  FarmerDetailsModel({
    required this.id,
    required this.dealerNumber,
    required this.name,
    required this.whatsappNumber,
    required this.totalOwnedFarm,
    required this.geoLocationOwnedFarm,
    required this.totalLeaseFarm,
    required this.geoLocationLeaseFarm,
    required this.pincode,
    required this.village,
    required this.district,
    required this.state,
    required this.address,
    required this.typeOfCultivationPractice,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.ifscCode,
    required this.pan,
    required this.aadhaarNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FarmerDetailsModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return FarmerDetailsModel(
      id: json['_id'] as String? ?? '',
      dealerNumber: json['dealerNumber'] as String? ?? '',
      name: json['name'] as String? ?? '',
      whatsappNumber: json['whatsappNumber'] as String? ?? '',
      totalOwnedFarm: (json['totalOwnedFarm'] is num
          ? (json['totalOwnedFarm'] as num).toDouble()
          : 0.0),
      geoLocationOwnedFarm: json['geoLocationOwnedFarm'] as String? ?? '',
      totalLeaseFarm: (json['totalLeaseFarm'] is num
          ? (json['totalLeaseFarm'] as num).toDouble()
          : 0.0),
      geoLocationLeaseFarm: json['geoLocationLeaseFarm'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      village: json['village'] as String? ?? '',
      district: json['district'] as String? ?? '',
      state: json['state'] as String? ?? '',
      address: json['address'] as String? ?? '',
      typeOfCultivationPractice:
          json['typeOfCultivationPractice'] as String? ?? '',
      bankName: json['bankName'] as String? ?? '',
      accountName: json['accountName'] as String? ?? '',
      accountNumber: json['accountNumber'] as String? ?? '',
      ifscCode: json['ifsc gotCode'] as String? ?? '',
      pan: json['pan'] as String? ?? '',
      aadhaarNumber: json['aadhaarNumber'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

// CropCultivationDetails with null safety
class CropCultivationDetails {
  final String id;
  final String dealerNumber;
  final String fid;
  final String farmerName;
  final String crops;
  final String variety;
  final DateTime dateOfSowing;
  final String geolocation;
  final String typeOfCultivationPractice;
  final double areaInAcres;
  final String geoLinkAreaOnMap;

  CropCultivationDetails({
    required this.id,
    required this.dealerNumber,
    required this.fid,
    required this.farmerName,
    required this.crops,
    required this.variety,
    required this.dateOfSowing,
    required this.geolocation,
    required this.typeOfCultivationPractice,
    required this.areaInAcres,
    required this.geoLinkAreaOnMap,
  });

  factory CropCultivationDetails.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return CropCultivationDetails(
      id: json['_id'] as String? ?? '',
      dealerNumber: json['dealerNumber'] as String? ?? '',
      fid: json['fid'] as String? ?? '',
      farmerName: json['farmerName'] as String? ?? '',
      crops: json['crops'] as String? ?? '',
      variety: json['variety'] as String? ?? '',
      dateOfSowing: DateTime.tryParse(json['dateOfSowing'] as String? ?? '') ??
          DateTime.now(),
      geolocation: json['geolocation'] as String? ?? '',
      typeOfCultivationPractice:
          json['typeOfCultivationPractice'] as String? ?? '',
      areaInAcres: (json['areaInAcres'] is num
          ? (json['areaInAcres'] as num).toDouble()
          : 0.0),
      geoLinkAreaOnMap: json['geoLinkAreaOnMap'] as String? ?? '',
    );
  }
}

// FarmerDataModel with null safety and proper cropCultivationDetails handling
class FarmerDataModel {
  final FarmerDetailsModel farmerDetails;
  final List<CropCultivationDetails>? cropCultivationDetails;

  FarmerDataModel({
    required this.farmerDetails,
    this.cropCultivationDetails,
  });

  factory FarmerDataModel.fromJson(Map<String, dynamic>? json) {
    print('json[cropCultivationDetails] :${json}');
    json ??= {};
    var cropDetails = json['cropCultivationDetails'];
    print('json[cropCultivationDetails] :${json['cropCultivationDetails']}');
    List<CropCultivationDetails>? crops;

    if (cropDetails is List &&
        cropDetails.isNotEmpty &&
        cropDetails.every((item) => item is Map<String, dynamic>)) {
      crops = cropDetails
          .map((crop) =>
              CropCultivationDetails.fromJson(crop as Map<String, dynamic>?))
          .toList();
    } else {
      crops = null; // Set to null if it's a string or invalid list
    }

    return FarmerDataModel(
      farmerDetails: FarmerDetailsModel.fromJson(
          json['farmerDetails'] as Map<String, dynamic>?),
      cropCultivationDetails: crops,
    );
  }
}

// FarmerResponse with null safety
class FarmerResponse {
  final bool success;
  final String message;
  final List<FarmerDataModel> data;

  FarmerResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FarmerResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    var dataList = json['data'] as List? ?? [];
    return FarmerResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: dataList
          .where((item) => item is Map<String, dynamic>)
          .map(
              (item) => FarmerDataModel.fromJson(item as Map<String, dynamic>?))
          .toList(),
    );
  }
}
