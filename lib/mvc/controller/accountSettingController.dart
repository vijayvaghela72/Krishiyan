import 'dart:convert';
import 'package:flutter/material.dart';
import '../../helper/API.dart';
import '../../helper/SharedPref.dart';
import '../../widgets/constant.dart';
import '../model/APIResponse.dart';
import '../model/GetAddressDetails.dart';
import '../model/GetBankDetails.dart';
import '../model/GetFRMProfileData.dart';
import '../model/GetOtherDetails.dart';
import '../model/GetProfileData.dart';

class AccountSettingController {
  static Future<GetFRMProfileDetails?> fetchFRMEditProfileDetails(
      BuildContext context, String contactNumber) async {
    return API
        .callPostImage(FRM_PROFILE_DETAILS + contactNumber, null, "",
            isKeyByPass: true)
        .then((response) {
      print("Edit FRM Profile Details RESPONSE : " + response);
      APIResponse? apiResponse = APIResponse.fromJson(jsonDecode(response));
      if (apiResponse.success!) {
        if (apiResponse.frmProfileData!.dateOfFpo != null) {
          String? date = apiResponse.frmProfileData!.dateOfFpo ?? "";
          String? typeOfOrgData = apiResponse.frmProfileData!.typeOfFpo ?? "";

          print("New Api Date : $date");
          print("New Api Organization : $typeOfOrgData");

          SharedPref.savePreferenceValue(dateOfOrganization, date);
          SharedPref.savePreferenceValue(typeOfOrg, typeOfOrgData);
        }
        return apiResponse.frmProfileData;
      }
      if (apiResponse.message != "") {
        // AlertHelper.showToast(apiResponse.message!, context);
      }
      return null;
    }).catchError((onError) {
      print("ERROR " + onError.toString());
      return null;
    });
  }

  static Future<GetProfileDetails?> fetchEditProfileDetails(
      BuildContext context, String id) async {
    return API
        .callPostImage(PROFILE_DETAILS + id, null, "", isKeyByPass: true)
        .then((response) {
      print("Trader Edit Profile Details RESPONSE : " + response);
      APIResponse? apiResponse = APIResponse.fromJson(jsonDecode(response));
      if (apiResponse.success!) {
        if (apiResponse.profileData!.incorporationDate != null) {
          String? incorporationDate =
              apiResponse.profileData!.incorporationDate ?? "";
          String? typeOfEntityData =
              apiResponse.profileData!.typeOfEntity ?? "";

          print("New Api incorporationDate : $incorporationDate");
          print("New Api typeOfEntityData : $typeOfEntityData");

          SharedPref.savePreferenceValue(
              dateOfIncorporation, incorporationDate);
          SharedPref.savePreferenceValue(typeOfEntity, typeOfEntityData);
        }
        return apiResponse.profileData;
      }
      if (apiResponse.message != "") {
        // AlertHelper.showToast(apiResponse.message!, context);
      }
      return null;
    }).catchError((onError) {
      print("ERROR " + onError.toString());
      return null;
    });
  }

  static Future<OtherData?> fetchAccountDetails(
      BuildContext context, String number) async {
    return API
        .callPostImage(OTHER_DETAILS + number, null, "", isKeyByPass: true)
        .then((response) {
      print("Other Details RESPONSE : " + response);
      APIResponse? apiResponse = APIResponse.fromJson(jsonDecode(response));
      if (apiResponse.success!) {
        return apiResponse.otherData;
      }
      if (apiResponse.message != "") {
        // AlertHelper.showToast(apiResponse.message!, context);
      }
      return null;
    }).catchError((onError) {
      print("ERROR " + onError.toString());
      return null;
    });
  }

  static Future<BankData?> fetchBankDetails(
      BuildContext context, String number) async {
    return API
        .callPostImage(BANK_DETAILS + number, null, "", isKeyByPass: true)
        .then((response) {
      print('BANK_DETAILS + number : ${BANK_DETAILS + number}');
      print("Bank Details RESPONSE : " + response);
      APIResponse? apiResponse = APIResponse.fromJson(jsonDecode(response));

      if (apiResponse.success!) {
        return apiResponse.bankData;
      }
      if (apiResponse.message != "") {
        // AlertHelper.showToast(apiResponse.message!, context);
      }
      return null;
    }).catchError((onError) {
      print("ERROR " + onError.toString());
      return null;
    });
  }

  static Future<Address?>? fetchAddressDetails(
      BuildContext context, String number) async {
    return API
        // .callPostImage(ADDRESS_DETAILS+number, null, "", isKeyByPass: true)
        .callPostImage("${baseUrl}address/" + number, null, "",
            isKeyByPass: true)
        .then((response) {
      print("Address RESPONSE : " + response.toString());
      APIResponse? apiResponse = APIResponse.fromJson(jsonDecode(response));
      if (apiResponse.success!) {
        print("Address Success : " + apiResponse.success.toString());
        return apiResponse.addressData;
      }
      if (apiResponse.message != "") {
        print("Address msg : ${apiResponse.message}");
      }
      return null;
    }).catchError((onError) {
      print("ERROR Address Get : " + onError.toString());
      return null;
    });
  }
}
