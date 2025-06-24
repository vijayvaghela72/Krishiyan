import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/screen/dashboard/frm/frm_model.dart';
import '../../helper/alert_helper.dart';
import '../model/api_reaponse_model.dart';
import '../model/farmer_dashboard_model.dart';
import 'package:krishiyan/helper/constant.dart';
import '../model/farmer_registration_model.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmerDashboardController {
  static Future<List<FarmerDetails>> fetchFarmerDashboard(
      BuildContext context, String? villageName, String? typeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dealerNumberData = await prefs.getString(contactNo) ?? '1';

    final String endUrl = "${baseUrl}appFarmer/data/$dealerNumberData";
    try {
      var response;
      if (villageName != null && typeName != null) {
        var queryString =
            "$endUrl?village=$villageName&typeOfCultivationPractice=$typeName";
        response = await getAPICall(apiUrl: queryString);
        print("Farmer Response If: ${response.body}");
      } else if (villageName != null && villageName.isNotEmpty) {
        var queryString = "$endUrl?village=$villageName";
        response = await getAPICall(apiUrl: queryString);
        print("Farmer Response Else If 1 : ${response.body}");
      } else if (typeName != null && typeName.isNotEmpty) {
        var queryString = "$endUrl?typeOfCultivationPractice=$typeName";
        response = await getAPICall(apiUrl: queryString);
        print("Farmer Response Else If 1 : ${response.body}");
      } else {
        response = await getAPICall(apiUrl: endUrl);
      }
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        FarmerResponse farmerResponse = FarmerResponse.fromJson(jsonData);
        // Store the data in farmerDataList
        frmProvider!.farmerDataList = farmerResponse.data;
        print('farmerDataList : ${frmProvider!.farmerDataList.length}');
        print('farmerDataList : ${frmProvider!.farmerDataList.length}');
        List jsonResponse = json.decode(response.body)['data'];
        print("Farmer Dashboard Response : ${jsonResponse}");

        return jsonResponse
            .map((data) => FarmerDetails.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load farmers');
      }
    } catch (e) {
      throw Exception('Failed to load farmers: $e');
    }
  }

  static Future<List<FarmerDetails>> fetchSearchFarmerDashboard(
      BuildContext context, String? whatsappNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dealerNumberData = await prefs.getString(contactNo) ?? '1';

    final String endUrl = "${baseUrl}appFarmer/data/$dealerNumberData"
        "?whatsappNumber=$whatsappNumber";

    try {
      var response = await getAPICall(apiUrl: endUrl);

      print("fetchSearchFarmerDashboard If: ${response.body}");

      print("fetchSearchFarmerDashboard response : $response");
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['data'];
        print("Farmer Dashboard Search Response : ${jsonResponse}");
        return jsonResponse
            .map((data) => FarmerDetails.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load farmers');
      }
    } catch (e) {
      throw Exception('Failed to load farmers: $e');
    }
  }

  static Future<FRMRegistrationData?> farmerRegistration(dynamic data,
      {required BuildContext context}) async {
    try {
      var response = await postAPICall(
        apiUrl: FARMER_REGISTRATION,
        parameter: data,
      );

      if (response.statusCode == 201) {
        print("FRM Registration Response : " + response.body);

        APIResponse? apiResponse =
            APIResponse.fromJson(json.decode(response.body));
        if (apiResponse.success!) {
          if (apiResponse.frmRegistrationData != null) {
            return apiResponse.frmRegistrationData;
          } else {
            AlertHelper.showToast(apiResponse.message!, context);
          }
        }
        if (apiResponse.message != "") {
          AlertHelper.showToast(apiResponse.message!, context);
        }
        return null;
      } else {
        print("Error : " + response.statusCode.toString());
        return null;
      }
    } catch (e) {
      print("Error : $e");
      return null;
    }
  }

  static Future<String?> farmerGroupRegistration(dynamic data,
      {required BuildContext context}) async {
    try {
      var response = await postAPICall(
        apiUrl: SIGNUP,
        parameter: data,
      );

      if (response.statusCode == 201) {
        print("Farmer group registration Response : " + response.body);

        APIResponse? apiResponse =
            APIResponse.fromJson(json.decode(response.body));
        if (apiResponse.success!) {
          return apiResponse.message.toString();
        }
        if (apiResponse.message != "") {
          AlertHelper.showToast(apiResponse.message!, context);
        }
        return "";
      } else {
        print("Error : " + response.statusCode.toString());
        return null;
      }
    } catch (e) {
      print("Error : $e");
      return null;
    }
  }

  static Future<String?> cropCultivationRegister(dynamic data,
      {required BuildContext context}) async {
    try {
      var response = await postAPICall(
        apiUrl: CROP_CULTIVATION_REGISTR,
        parameter: data,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Crop cultivation register response : " + response.body);

        APIResponse? apiResponse =
            APIResponse.fromJson(json.decode(response.body));
        if (apiResponse.success!) {
          return apiResponse.message.toString();
        }
        if (apiResponse.message != "") {
          AlertHelper.showToast(apiResponse.message!, context);
        }
        return "";
      } else {
        print("Error : " + response.statusCode.toString());
        return null;
      }
    } catch (e) {
      print("Error : $e");
      return null;
    }
  }
}
