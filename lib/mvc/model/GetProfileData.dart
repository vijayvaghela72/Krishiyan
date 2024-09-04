class GetProfileData {
  bool? success;
  String? message;
  GetProfileDetails? data;

  GetProfileData({this.success, this.message, this.data});

  GetProfileData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? GetProfileDetails.fromJson(json['data']) : null;
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

class GetProfileDetails {
  String? sId;
  String? typeOfOrganization;
  String? nameOfFpo;
  String? typeOfFpo;
  String? dateOfFpo;
  String? organizationalEmail;
  String? contactNumber;
  String? promoterName;
  String? password;
  int? iV;

  GetProfileDetails(
      {this.sId,
        this.typeOfOrganization,
        this.nameOfFpo,
        this.typeOfFpo,
        this.dateOfFpo,
        this.organizationalEmail,
        this.contactNumber,
        this.promoterName,
        this.password,
        this.iV});

  GetProfileDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    typeOfOrganization = json['typeOfOrganization'];
    nameOfFpo = json['nameOfFpo'];
    typeOfFpo = json['typeOfFpo'];
    dateOfFpo = json['dateOfFpo'];
    organizationalEmail = json['organizationalEmail'];
    contactNumber = json['contactNumber'];
    promoterName = json['promoterName'];
    password = json['password'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['typeOfOrganization'] = this.typeOfOrganization;
    data['nameOfFpo'] = this.nameOfFpo;
    data['typeOfFpo'] = this.typeOfFpo;
    data['dateOfFpo'] = this.dateOfFpo;
    data['organizationalEmail'] = this.organizationalEmail;
    data['contactNumber'] = this.contactNumber;
    data['promoterName'] = this.promoterName;
    data['password'] = this.password;
    data['__v'] = this.iV;
    return data;
  }
}