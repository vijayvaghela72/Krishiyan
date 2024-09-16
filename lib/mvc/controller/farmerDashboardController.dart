import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/AlertHelper.dart';
import '../../helper/SharedPref.dart';
import '../../utils/Constants.dart';
import '../model/APIResponse.dart';
import '../model/FarmerDashboardData.dart';
import '../model/FarmerRegistrationData.dart';

class FarmerDashboardController{

  static Future<List<FarmerDetails>> fetchFarmerDashboard(BuildContext context,
      String? villageName,String? typeName) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dealerNumberData = await prefs.getString(contactNo) ?? '1';

    final String baseUrl = "https://krishiyanback.vercel.app/api/appFarmer/data/$dealerNumberData";

    try {
      final Dio dio = Dio();
      var response;
      if(villageName !=null && typeName !=null) {
        response = await dio.get(baseUrl, queryParameters: {
          'village': villageName,
          'typeOfCultivationPractice': typeName,
        });
        print("Farmer Response If: ${response}");
      }
      else if(villageName !=null && villageName.isNotEmpty){
        response = await dio.get(baseUrl, queryParameters: {
          'village': villageName,
        });
        print("Farmer Response Else If 1 : ${response}");
      }
      else if(typeName !=null && typeName.isNotEmpty){
        response = await dio.get(baseUrl, queryParameters: {
        'typeOfCultivationPractice': typeName,
        });
        print("Farmer Response Else If 1 : ${response}");
      }
      else{
        response = await dio.get(baseUrl);
      }

      if (response.statusCode == 200) {
        List jsonResponse = response.data['data'];
        print("Farmer Dashboard Response : ${jsonResponse}");
        return jsonResponse.map((data) => FarmerDetails.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load farmers');
      }
    } catch (e) {
      throw Exception('Failed to load farmers: $e');
    }
  }

  static Future<List<FarmerDetails>> fetchSearchFarmerDashboard(BuildContext context,
      String? whatsappNumber) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dealerNumberData = await prefs.getString(contactNo) ?? '1';

    final String baseUrl = "https://krishiyanback.vercel.app/api/appFarmer/data/$dealerNumberData"
        "?whatsappNumber=$whatsappNumber";

    try {
      final Dio dio = Dio();
      var response = await dio.get(baseUrl);
      // response = await dio.get(baseUrl, queryParameters: {
      //   'whatsappNumber': whatsappNumber
      // });
      print("fetchSearchFarmerDashboard If: ${response.toString()}");

      print("fetchSearchFarmerDashboard response : $response");
      if (response.statusCode == 200) {
        List jsonResponse = response.data['data'];
        print("Farmer Dashboard Search Response : ${jsonResponse}");
        return jsonResponse.map((data) => FarmerDetails.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load farmers');
      }
    } catch (e) {
      throw Exception('Failed to load farmers: $e');
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

  // static Future<List<SearchFarmerData>> fetchSearchFarmerDashboard(BuildContext context, String? whatsappNumber) async {
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String dealerNumberData = await prefs.getString(contactNo) ?? '1';
  //
  //   final String baseUrl = "https://d1dv04h56lh39n.cloudfront.net/api/appFarmer/farmer/"
  //       "search?dealerNumber=$dealerNumberData&whatsappNumber=$whatsappNumber";
  //
  //   try {
  //     final Dio dio = Dio();
  //     var response;
  //     if(dealerNumberData !=null && whatsappNumber !=null) {
  //       response = await dio.get(baseUrl, queryParameters: {
  //         'dealerNumber': dealerNumberData,
  //         'whatsappNumber': whatsappNumber,
  //       });
  //       print("Farmer Search Response : ${response}");
  //     }
  //     else{
  //       response = await dio.get(baseUrl);
  //     }
  //
  //     if (response.statusCode == 200) {
  //       List jsonResponse = response.data['data'];
  //       return jsonResponse.map((data) => SearchFarmerData.fromJson(data)).toList();
  //     } else {
  //       throw Exception('Failed to load farmers');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load farmers: $e');
  //   }
  // }
}