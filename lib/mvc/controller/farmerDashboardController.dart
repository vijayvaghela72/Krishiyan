import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../helper/AlertHelper.dart';
import '../../helper/SharedPref.dart';
import '../../utils/Constants.dart';
import '../model/APIResponse.dart';
import '../model/FarmerDashboardData.dart';
import '../model/FarmerRegistrationData.dart';

class FarmerDashboardController{

  static Future<FarmerDashboardData?> fetchFarmerDashboard(BuildContext context) async {
    var headers = {
      'Content-Type': 'application/json'
    };

    var dio = Dio();
    var response = await dio.get(
      FARMER_DASHBOARD,
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      print("Response : "+json.encode(response.data));
      return json.decode(response.data);
    }
    else {
      print("Error : "+response.statusMessage.toString());
    }
  }

  static Future<FRMRegistrationData?> farmerRegistration(dynamic data,{required BuildContext context}) async {

    var headers = {
      'Content-Type': 'application/json'
    };

    var dio = Dio();
    var response = await dio.request(
      FARMER_REGISTRATION,
      options: Options(
        method: 'POST',
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 201) {
      print("FRM Registration Response : "+json.encode(response.data));

      APIResponse? apiResponse = APIResponse.fromJson(response.data);
      if (apiResponse.success!) {
        if(apiResponse.frmRegistrationData !=null) {
          return apiResponse.frmRegistrationData;
        }
        else{
          AlertHelper.showToast(apiResponse.message!,context);
        }
      }
      if (apiResponse.message != "") {
        AlertHelper.showToast(apiResponse.message!,context);
      }
      return null;
    }
    else {
      print("Error : "+response.statusMessage.toString());
    }
  }

  static Future<String?> farmerGroupRegistration(dynamic data,{required BuildContext context}) async {

    var headers = {
      'Content-Type': 'application/json'
    };

    var dio = Dio();
    var response = await dio.request(
      SIGNUP,
      options: Options(
        method: 'POST',
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 201) {
      print("Farmer group registration Response : "+json.encode(response.data));

      APIResponse? apiResponse = APIResponse.fromJson(response.data);
      if (apiResponse.success!) {
        return apiResponse.message.toString();
      }
      if (apiResponse.message != "") {
        AlertHelper.showToast(apiResponse.message!,context);
      }
      return "";
    }
    else {
      print("Error : "+response.statusMessage.toString());
    }
  }

  static Future<String?> cropCultivationRegister(dynamic data,{required BuildContext context}) async {

    var headers = {
      'Content-Type': 'application/json'
    };

    var dio = Dio();
    var response = await dio.request(
      CROP_CULTIVATION_REGISTR,
      options: Options(
        method: 'POST',
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 201) {
      print("Crop cultivation registr response : "+json.encode(response.data));

      APIResponse? apiResponse = APIResponse.fromJson(response.data);
      if (apiResponse.success!) {
        return apiResponse.message.toString();
      }
      if (apiResponse.message != "") {
        AlertHelper.showToast(apiResponse.message!,context);
      }
      return "";
    }
    else {
      print("Error : "+response.statusMessage.toString());
    }
  }

}