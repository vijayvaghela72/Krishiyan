class FrmInsight {
  final bool success;
  final String message;
  final FrmInsightData data;

  FrmInsight({
    required this.success,
    required this.message,
    required this.data,
  });

  // Factory method to create a FrminSight instance from JSON data
  factory FrmInsight.fromJson(Map<String, dynamic> json) {
    return FrmInsight(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: FrmInsightData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  // Method to convert FrminSight instance to JSON format
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class FrmInsightData {
  final List<Farmer> farmers;
  final int totalAreaInAcres;
  final int numberOfFarmers;

  FrmInsightData({
    required this.farmers,
    required this.totalAreaInAcres,
    required this.numberOfFarmers,
  });

  // Factory method to create FrminSightData from JSON
  factory FrmInsightData.fromJson(Map<String, dynamic> json) {
    var farmersList = json['farmers'] as List;
    List<Farmer> farmers = farmersList.map((e) => Farmer.fromJson(e)).toList();

    return FrmInsightData(
      farmers: farmers,
      totalAreaInAcres: json['totalAreaInAcres'] as int,
      numberOfFarmers: json['numberOfFarmers'] as int,
    );
  }

  // Method to convert FrminSightData instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'farmers': farmers.map((e) => e.toJson()).toList(),
      'totalAreaInAcres': totalAreaInAcres,
      'numberOfFarmers': numberOfFarmers,
    };
  }
}

class Farmer {
  final String name;
  final String whatsappNumber;
  final int expectedYield;

  Farmer({
    required this.name,
    required this.whatsappNumber,
    required this.expectedYield,
  });

  // Factory method to create Farmer from JSON
  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      name: json['name'] as String,
      whatsappNumber: json['whatsappNumber'] as String,
      expectedYield: json['expectedYield'] as int,
    );
  }

  // Method to convert Farmer instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'whatsappNumber': whatsappNumber,
      'expectedYield': expectedYield,
    };
  }
}
