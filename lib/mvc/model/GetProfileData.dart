class GetProfileData {
  bool? success;
  String? message;
  GetProfileDetails? getProfileDetails;

  GetProfileData({this.success, this.message, this.getProfileDetails});

  GetProfileData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    getProfileDetails = json['data'] != null
        ? new GetProfileDetails.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.getProfileDetails != null) {
      data['data'] = this.getProfileDetails!.toJson();
    }
    return data;
  }
}

class GetProfileDetails {
  String? nameOfEntity;
  String? typeOfEntity;
  String? incorporationDate;
  String? incorporationNumber;
  String? businessLocation;
  String? contactPersonName;
  String? yourDesignation;
  String? uRL;
  String? contactNumber;

  GetProfileDetails(
      {this.nameOfEntity,
        this.typeOfEntity,
        this.incorporationDate,
        this.incorporationNumber,
        this.businessLocation,
        this.contactPersonName,
        this.yourDesignation,
        this.uRL,
        this.contactNumber});

  GetProfileDetails.fromJson(Map<String, dynamic> json) {
    nameOfEntity = json['nameOfEntity'];
    typeOfEntity = json['typeOfEntity'];
    incorporationDate = json['incorporationDate'];
    incorporationNumber = json['incorporationNumber'];
    businessLocation = json['businessLocation'];
    contactPersonName = json['contactPersonName'];
    yourDesignation = json['yourDesignation'];
    uRL = json['URL'];
    contactNumber = json['contactNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nameOfEntity'] = this.nameOfEntity;
    data['typeOfEntity'] = this.typeOfEntity;
    data['incorporationDate'] = this.incorporationDate;
    data['incorporationNumber'] = this.incorporationNumber;
    data['businessLocation'] = this.businessLocation;
    data['contactPersonName'] = this.contactPersonName;
    data['yourDesignation'] = this.yourDesignation;
    data['URL'] = this.uRL;
    data['contactNumber'] = this.contactNumber;
    return data;
  }
}