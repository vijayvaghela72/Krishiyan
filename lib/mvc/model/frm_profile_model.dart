class GetFRMProfileData {
  bool? success;
  String? message;
  GetFRMProfileDetails? data;

  GetFRMProfileData({this.success, this.message, this.data});

  GetFRMProfileData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? GetFRMProfileDetails.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GetFRMProfileDetails {
  String? sId;
  String? typeOfOrganization;
  String? nameOfFpo;
  String? typeOfFpo;
  String? dateOfFpo;
  String? organizationalEmail;
  String? contactNumber;
  String? promoterName;
  int? iV;
  String? cBBOName;
  String? registrationNumber;
  String? yourDesignation;

  GetFRMProfileDetails(
      {this.sId,
      this.typeOfOrganization,
      this.nameOfFpo,
      this.typeOfFpo,
      this.dateOfFpo,
      this.organizationalEmail,
      this.contactNumber,
      this.promoterName,
      this.iV,
      this.cBBOName,
      this.registrationNumber,
      this.yourDesignation});

  GetFRMProfileDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    typeOfOrganization = json['typeOfOrganization'];
    nameOfFpo = json['nameOfFpo'];
    typeOfFpo = json['typeOfFpo'];
    dateOfFpo = json['dateOfFpo'];
    organizationalEmail = json['organizationalEmail'];
    contactNumber = json['contactNumber'];
    promoterName = json['promoterName'];
    iV = json['__v'];
    cBBOName = json['CBBOName'];
    registrationNumber = json['RegistrationNumber'];
    yourDesignation = json['yourDesignation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['typeOfOrganization'] = this.typeOfOrganization;
    data['nameOfFpo'] = this.nameOfFpo;
    data['typeOfFpo'] = this.typeOfFpo;
    data['dateOfFpo'] = this.dateOfFpo;
    data['organizationalEmail'] = this.organizationalEmail;
    data['contactNumber'] = this.contactNumber;
    data['promoterName'] = this.promoterName;
    data['__v'] = this.iV;
    data['CBBOName'] = this.cBBOName;
    data['RegistrationNumber'] = this.registrationNumber;
    data['yourDesignation'] = this.yourDesignation;
    return data;
  }
}
