import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/AlertHelper.dart';
import '../../utils/Constants.dart';
import '../model/APIResponse.dart';
import '../model/CreateBuyCommodityData.dart';
import '../model/GetAllEnquiryData.dart';
import 'package:http/http.dart' as http;

import '../model/GetEnquiryByFilterData.dart';

class EnquiryDashboardController{

  static Future<List<EnquiryData>> getEnquiryDetails() async {
    final response = await http.get(Uri.parse(ENQUIRY_LIST));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("GetEnquiryDetails : ${jsonResponse.toString()}");
      final List<dynamic> data = jsonResponse['data'];
      return data.map((item) => EnquiryData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<EnquiryData>> getEnquiryDetailsByID() async {
    final response = await http.get(Uri.parse(ENQUIRY_LIST_BY_ID));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("GetEnquiryDetailsByID : ${jsonResponse.toString()}");
      final List<dynamic> data = jsonResponse['data'];
      return data.map((item) => EnquiryData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<EnquiryData>> getEnquiryDetailsByCommodity(String commodity) async {
    final response = await http.get(Uri.parse("https://krishiyanback.vercel.app/api/commodities/$commodity"));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      print("Get Enquiry Details By Commodity : $data");
      return data.map((item) => EnquiryData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<EnquiryByFilterData>> getEnquiryDetailsByFilterCommodity(
      String commodity, String operation) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dealerNumberData = await prefs.getString(contactNo) ?? '1';

    final response = await http.get(Uri.parse("https://krishiyanback.vercel.app/api/commodities/"
        "$dealerNumberData/$commodity?operation=$operation"));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      print("Get Enquiry Details By Filter Commodity : $jsonResponse");
      return data.map((item) => EnquiryByFilterData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<String?> buySellCommodityData(dynamic data,{required BuildContext context}) async {

    var headers = {
      'Content-Type': 'application/json'
    };

    var dio = Dio();
    var response = await dio.request(
      BUY_COMMODITY,
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
      print("Commodity Response : "+json.encode(response.data));

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