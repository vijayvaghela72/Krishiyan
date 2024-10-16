class VarietyData {
  final String id;
  final String nameOfVariety;
  final String areaOfAdoption;
  final String productCondition;
  final String salientFeatures;
  final String cropCycle;

  VarietyData({
    required this.id,
    required this.nameOfVariety,
    required this.areaOfAdoption,
    required this.productCondition,
    required this.salientFeatures,
    required this.cropCycle,
  });

  factory VarietyData.fromJson(Map<String, dynamic> json) {
    return VarietyData(
      id: json['_id'],
      nameOfVariety: json['nameOfvariety'],
      areaOfAdoption: json['areaOfadadoption'],
      productCondition: json['productCondition'],
      salientFeatures: json['salientFeatures'],
      cropCycle: json['cropCycle'],
    );
  }
}
