import 'dart:convert';
import '../model/APIResponse.dart';
import '../../helper/constant.dart';
import '../../helper/AlertHelper.dart';
import 'package:flutter/cupertino.dart';
import '../model/GetAllEnquiryData.dart';
import '../model/GetEnquiryByFilterData.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnquiryDashboardController {
  static Future<List<EnquiryData>> getEnquiryDetails() async {
    final response = await getAPICall(apiUrl: ENQUIRY_LIST);

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
    final response = await getAPICall(apiUrl: ENQUIRY_LIST_BY_ID);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("GetEnquiryDetailsByID : ${jsonResponse.toString()}");
      final List<dynamic> data = jsonResponse['data'];
      return data.map((item) => EnquiryData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<EnquiryData>> getEnquiryDetailsByCommodity(
      String commodity) async {
    final response =
        await getAPICall(apiUrl: "${baseUrl}commodities/$commodity");

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

    final response = await getAPICall(
        apiUrl: "${baseUrl}commodities/"
            "$dealerNumberData/$commodity?operation=$operation");

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      print("Get Enquiry Details By Filter Commodity : $jsonResponse");
      return data.map((item) => EnquiryByFilterData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<String?> buySellCommodityData(dynamic data,
      {required BuildContext context}) async {
    var response =
        await postAPICall(apiUrl: BUY_COMMODITY, parameter: json.encode(data));

    if (response.statusCode == 201) {
      print("Commodity Response : " + response.body);

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
      print("Error : " + response.reasonPhrase.toString());
      return "";
    }
  }
}
