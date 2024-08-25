class LoginData {
  bool? success;
  String? message;
  Data? data;

  LoginData({this.success, this.message, this.data});

  LoginData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  FpoOrganization? fpoOrganization;
  String? token;

  Data({this.fpoOrganization, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    fpoOrganization = json['fpoOrganization'] != null
        ? FpoOrganization.fromJson(json['fpoOrganization'])
        : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.fpoOrganization != null) {
      data['fpoOrganization'] = this.fpoOrganization!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class FpoOrganization {
  String? typeOfOrganization;
  String? nameOfFpo;
  String? typeOfFpo;
  String? dateOfFpo;
  String? organizationalEmail;
  String? contactNumber;
  String? promoterName;
  String? password;
  String? sId;
  int? iV;

  FpoOrganization(
      {this.typeOfOrganization,
        this.nameOfFpo,
        this.typeOfFpo,
        this.dateOfFpo,
        this.organizationalEmail,
        this.contactNumber,
        this.promoterName,
        this.password,
        this.sId,
        this.iV});

  FpoOrganization.fromJson(Map<String, dynamic> json) {
    typeOfOrganization = json['typeOfOrganization'];
    nameOfFpo = json['nameOfFpo'];
    typeOfFpo = json['typeOfFpo'];
    dateOfFpo = json['dateOfFpo'];
    organizationalEmail = json['organizationalEmail'];
    contactNumber = json['contactNumber'];
    promoterName = json['promoterName'];
    password = json['password'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['typeOfOrganization'] = this.typeOfOrganization;
    data['nameOfFpo'] = this.nameOfFpo;
    data['typeOfFpo'] = this.typeOfFpo;
    data['dateOfFpo'] = this.dateOfFpo;
    data['organizationalEmail'] = this.organizationalEmail;
    data['contactNumber'] = this.contactNumber;
    data['promoterName'] = this.promoterName;
    data['password'] = this.password;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}