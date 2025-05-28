class FarmerDashboardData {
  bool success;
  String message;
  List<FarmerDetails> data;

  FarmerDashboardData({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FarmerDashboardData.fromJson(Map<String, dynamic> json) {
    return FarmerDashboardData(
      success: json['success'],
      message: json['message'],
      data: List<FarmerDetails>.from(
          json['data'].map((x) => FarmerDetails.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class FarmerDetails {
  FarmerDashboard farmerDetails;
  dynamic cropCultivationDetails; // Can be List<CropDetails>, String, or null

  FarmerDetails({
    required this.farmerDetails,
    required this.cropCultivationDetails,
  });

  factory FarmerDetails.fromJson(Map<String, dynamic> json) {
    return FarmerDetails(
      farmerDetails: FarmerDashboard.fromJson(json['farmerDetails'] ?? {}),
      cropCultivationDetails: json['cropCultivationDetails'] is List
          ? List<CropDetails>.from(json['cropCultivationDetails']
              .map((x) => CropDetails.fromJson(x)))
          : json['cropCultivationDetails'] ?? "No crop data available",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'farmerDetails': farmerDetails.toJson(),
      'cropCultivationDetails': cropCultivationDetails is List
          ? List<dynamic>.from(cropCultivationDetails.map((x) => x.toJson()))
          : cropCultivationDetails,
    };
  }
}

class FarmerDashboard {
  String id;
  String dealerNumber;
  String name;
  String whatsappNumber;
  int totalOwnedFarm;
  String geoLocationOwnedFarm;
  int totalLeaseFarm;
  String geoLocationLeaseFarm;
  String pincode;
  String village;
  String district;
  String state;
  String address;
  String typeOfCultivationPractice;
  String bankName;
  String accountName;
  String accountNumber;
  String ifscCode;
  String pan;
  String aadhaarNumber;
  String createdAt;
  String updatedAt;

  FarmerDashboard({
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

  factory FarmerDashboard.fromJson(Map<String, dynamic> json) {
    return FarmerDashboard(
      id: json['_id']?.toString() ?? '',
      dealerNumber: json['dealerNumber']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      whatsappNumber: json['whatsappNumber']?.toString() ?? '',
      totalOwnedFarm:
          (json['totalOwnedFarm'] is num) ? json['totalOwnedFarm'].toInt() : 0,
      geoLocationOwnedFarm: json['geoLocationOwnedFarm']?.toString() ?? '',
      totalLeaseFarm:
          (json['totalLeaseFarm'] is num) ? json['totalLeaseFarm'].toInt() : 0,
      geoLocationLeaseFarm: json['geoLocationLeaseFarm']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      village: json['village']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      typeOfCultivationPractice:
          json['typeOfCultivationPractice']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? '',
      accountName: json['accountName']?.toString() ?? '',
      accountNumber: json['accountNumber']?.toString() ?? '',
      ifscCode: json['ifscCode']?.toString() ?? '',
      pan: json['pan']?.toString() ?? '',
      aadhaarNumber: json['aadhaarNumber']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'dealerNumber': dealerNumber,
      'name': name,
      'whatsappNumber': whatsappNumber,
      'totalOwnedFarm': totalOwnedFarm,
      'geoLocationOwnedFarm': geoLocationOwnedFarm,
      'totalLeaseFarm': totalLeaseFarm,
      'geoLocationLeaseFarm': geoLocationLeaseFarm,
      'pincode': pincode,
      'village': village,
      'district': district,
      'state': state,
      'address': address,
      'typeOfCultivationPractice': typeOfCultivationPractice,
      'bankName': bankName,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'pan': pan,
      'aadhaarNumber': aadhaarNumber,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class CropDetails {
  String id;
  String dealerNumber;
  String fid;
  String farmerName;
  String crops;
  String variety;
  DateTime dateOfSowing;
  String geolocation;
  String typeOfCultivationPractice;
  int areaInAcres;
  String geoLinkAreaOnMap;

  CropDetails({
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

  factory CropDetails.fromJson(Map<String, dynamic> json) {
    return CropDetails(
      id: json['_id'],
      dealerNumber: json['dealerNumber'],
      fid: json['fid'],
      farmerName: json['farmerName'],
      crops: json['crops'],
      variety: json['variety'],
      dateOfSowing: DateTime.parse(json['dateOfSowing']),
      geolocation: json['geolocation'],
      typeOfCultivationPractice: json['typeOfCultivationPractice'],
      areaInAcres: json['areaInAcres'],
      geoLinkAreaOnMap: json['geoLinkAreaOnMap'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'dealerNumber': dealerNumber,
      'fid': fid,
      'farmerName': farmerName,
      'crops': crops,
      'variety': variety,
      'dateOfSowing': dateOfSowing.toIso8601String(),
      'geolocation': geolocation,
      'typeOfCultivationPractice': typeOfCultivationPractice,
      'areaInAcres': areaInAcres,
      'geoLinkAreaOnMap': geoLinkAreaOnMap,
    };
  }
}
