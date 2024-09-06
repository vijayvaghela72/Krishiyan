import 'dart:convert';
import 'package:flutter/material.dart';
import '../../helper/API.dart';
import '../../helper/SharedPref.dart';
import '../../utils/AppGlobal.dart';
import '../../utils/Constants.dart';
import '../model/APIResponse.dart';
import '../model/GetAddressDetails.dart';
import '../model/GetBankDetails.dart';
import '../model/GetFRMProfileData.dart';
import '../model/GetOtherDetails.dart';
import '../model/GetProfileData.dart';

class AccountSettingController{

  static Future<GetFRMProfileDetails?> fetchFRMEditProfileDetails(BuildContext context, String contactNumber) async {
    return API
        .callPostImage(FRM_PROFILE_DETAILS+contactNumber, null, "", isKeyByPass: true)
        .then((response) {
      AppGlobal.printLog("Edit FRM Profile Details RESPONSE : " + response);
      APIResponse? apiResponse = APIResponse.fromJson(jsonDecode(response));
      if (apiResponse.success!) {
        if(apiResponse.frmProfileData!.dateOfFpo !=null) {

          String? date = apiResponse.frmProfileData!.dateOfFpo ?? "";
          String? typeOfOrgData = apiResponse.frmProfileData!.typeOfFpo ?? "";

          print("New Api Date : $date");
          print("New Api Organization : $typeOfOrgData");

          SharedPref.savePreferenceValue(dateOfOrganization, date ?? "");
          SharedPref.savePreferenceValue(typeOfOrg, typeOfOrgData ?? "");
        }
        return apiResponse.frmProfileData;
      }
      if (apiResponse.message != "") {
        // AlertHelper.showToast(apiResponse.message!, context);
      }
      return null;
    }).catchError((onError) {
      AppGlobal.printLog("ERROR " + onError.toString());
      return null;
    });
  }

  static Future<GetProfileDetails?> fetchEditProfileDetails(BuildContext context, String id) async {
    return API
        .callPostImage(PROFILE_DETAILS+id, null, "", isKeyByPass: true)
        .then((response) {
      AppGlobal.printLog("Edit Profile Details RESPONSE : " + response);
      APIResponse? apiResponse = APIResponse.fromJson(jsonDecode(response));
      if (apiResponse.success!) {
        return apiResponse.profileData;
      }
      if (apiResponse.message != "") {
        // AlertHelper.showToast(apiResponse.message!, context);
      }
      return null;
    }).catchError((onError) {
      AppGlobal.printLog("ERROR " + onError.toString());
      return null;
    });
  }

  static Future<OtherData?> fetchAccountDetails(BuildContext context, String number) async {
    return API
        .callPostImage(OTHER_DETAILS+number, null, "", isKeyByPass: true)
        .then((response) {
      AppGlobal.printLog("Other Details RESPONSE : " + response);
      APIResponse? apiResponse = APIResponse.fromJson(jsonDecode(response));
      if (apiResponse.success!) {
        return apiResponse.otherData;
      }
      if (apiResponse.message != "") {
        // AlertHelper.showToast(apiResponse.message!, context);
      }
      return null;
    }).catchError((onError) {
      AppGlobal.printLog("ERROR " + onError.toString());
      return null;
    });
  }

  static Future<BankData?> fetchBankDetails(BuildContext context, String number) async {
    return API
        .callPostImage(BANK_DETAILS+number, null, "", isKeyByPass: true)
        .then((response) {
      AppGlobal.printLog("Bank Details RESPONSE : " + response);
      APIResponse? apiResponse = APIResponse.fromJson(jsonDecode(response));
      if (apiResponse.success!) {
        return apiResponse.bankData;
      }
      if (apiResponse.message != "") {
        // AlertHelper.showToast(apiResponse.message!, context);
      }
      return null;
    }).catchError((onError) {
      AppGlobal.printLog("ERROR " + onError.toString());
      return null;
    });
  }

  static Future<Address?>? fetchAddressDetails(BuildContext context, String number) async {
    return API
    // .callPostImage(ADDRESS_DETAILS+number, null, "", isKeyByPass: true)
        .callPostImage("https://krishiyanback.vercel.app/api/address/"+number, null, "", isKeyByPass: true)
        .then((response) {
      AppGlobal.printLog("Address RESPONSE : " + response.toString());
      APIResponse? apiResponse = APIResponse.fromJson(jsonDecode(response));
      if (apiResponse.success!) {
        AppGlobal.printLog("Address Success : " + apiResponse.success.toString());
        return apiResponse.addressData;
      }
      if (apiResponse.message != "") {
        print("Address msg : ${apiResponse.message}");

      }
      return null;
    }).catchError((onError) {
      AppGlobal.printLog("ERROR Address Get : " + onError.toString());
      return null;
    });
  }

}