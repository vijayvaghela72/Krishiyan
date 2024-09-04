import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../helper/AlertHelper.dart';
import '../../utils/Constants.dart';
import '../model/APIResponse.dart';
import '../model/FarmersNameData.dart';
import 'package:http/http.dart' as http;

class CropCultivationController{


  // static Future<FarmerData?> fetchFarmerName(BuildContext context) async {
  //
  //   var headers = {
  //     'name': 'Content-Type',
  //     'value': 'application/json',
  //     'Content-Type': 'application/json'
  //   };
  //
  //   var dio = Dio();
  //   var response = await dio.request(
  //     FARMER_DATA_BY_DEALER,
  //     options: Options(
  //       method: 'GET',
  //       headers: headers,
  //       validateStatus: (_) => true,
  //     ),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print("Farmer Name Response : "+json.encode(response.data));
  //
  //     APIResponse? apiResponse = APIResponse.fromJson(response.data);
  //     if (apiResponse.success!) {
  //       return apiResponse.farmerData!;
  //     }
  //     if (apiResponse.message != "") {
  //       AlertHelper.showToast(apiResponse.message!,context);
  //     }
  //     return null;
  //   }
  //   else {
  //     print("Error : "+response.statusMessage.toString());
  //   }
  // }
}