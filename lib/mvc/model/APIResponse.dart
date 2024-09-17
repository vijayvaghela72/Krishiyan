import 'CreateBuyCommodityData.dart';
import 'FarmerDashboardData.dart';
import 'FarmerRegistrationData.dart';
import 'FarmersNameData.dart';
import 'GetAddressDetails.dart';
import 'GetAllEnquiryData.dart';
import 'GetBankDetails.dart';
import 'GetFRMProfileData.dart';
import 'GetOtherDetails.dart';
import 'GetProfileData.dart';
import 'InsightData.dart';
import 'LoginData.dart';
import 'PincodeToStateData.dart';

class APIResponse {
  String? message;
  bool? success;
  String? token;
  FRMRegistrationData? frmRegistrationData;
  Data? data;
  PostOffice? postOfficeData;
  BuyCommodityData? buyCommodityData;
  FarmersNameData? farmerData;
  OtherData? otherData;
  GetProfileDetails? profileData;
  GetFRMProfileDetails? frmProfileData;
  InsightDetails? insightDetails;
  BankData? bankData;
  Address? addressData;

  APIResponse({this.data, this.message, this.success, this.token, this.buyCommodityData, this.farmerData,
    this.otherData, this.bankData, this.addressData,
    this.frmRegistrationData, this.postOfficeData, this.profileData, this.frmProfileData, this.insightDetails});

  factory APIResponse.fromJson(Map<String, dynamic> json) {
    return APIResponse(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      buyCommodityData: json['data'] != null ? BuyCommodityData.fromJson(json['data']) : null,
      farmerData: json['data'] != null ? FarmersNameData.fromJson(json['data']) : null,
      frmRegistrationData: json['data'] != null ? FRMRegistrationData.fromJson(json['data']) : null,
      otherData: json['data'] != null ? OtherData.fromJson(json['data']) : null,
      bankData: json['data'] != null ? BankData.fromJson(json['data']) : null,
      postOfficeData: json['data'] != null ? PostOffice.fromJson(json['data']) : null,
      addressData: json['data'] != null ? Address.fromJson(json['data']) : null,
      profileData: json['data'] != null ? GetProfileDetails.fromJson(json['data']) : null,
      frmProfileData: json['data'] != null ? GetFRMProfileDetails.fromJson(json['data']) : null,
      insightDetails: json['data'] != null ? InsightDetails.fromJson(json['data']) : null,
      message: json['message'] ?? "",
      success: json['success'] ?? false,
      token: json['token'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.buyCommodityData != null) {
      data['data'] = this.buyCommodityData!.toJson();
    }
    if (this.farmerData != null) {
      data['data'] = this.farmerData!.toJson();
    }
    if (this.frmRegistrationData != null) {
      data['data'] = this.frmRegistrationData!.toJson();
    }
    if (this.otherData != null) {
      data['data'] = this.otherData!.toJson();
    }
    if (this.bankData != null) {
      data['data'] = this.bankData!.toJson();
    }
    if (this.addressData != null) {
      data['data'] = this.addressData!.toJson();
    }
    if (this.postOfficeData != null) {
      data['data'] = this.postOfficeData!.toJson();
    }
    if (this.profileData != null) {
      data['data'] = this.profileData!.toJson();
    }
    if (this.frmProfileData != null) {
      data['data'] = this.frmProfileData!.toJson();
    }
    if (this.insightDetails != null) {
      data['data'] = this.insightDetails!.toJson();
    }
    return data;
  }
}