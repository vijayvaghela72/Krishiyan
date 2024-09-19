import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../helper/AlertHelper.dart';
import '../../utils/Constants.dart';
import '../model/APIResponse.dart';
import '../model/GetOtpDetails.dart';
import '../model/LoginData.dart';

class OtpController {

  static Future<GetOtpData?> getOtp(dynamic data, {required BuildContext context}) async {
    var headers = {
      'Content-Type': 'application/json'
    };

    var dio = Dio();

    var response = await dio.request(
      GET_OTP,
      options: Options(
        method: 'POST',
        headers: headers,
        validateStatus: (_) => true,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      print("Otp Response : " + json.encode(response.data));

      APIResponse? apiResponse = APIResponse.fromJson(response.data);
      if (apiResponse.success!) {
        return apiResponse.getOtpData;
      }
      if (apiResponse.message != "") {
        AlertHelper.showToast(apiResponse.message!, context);
      }
      return null;
    } else {
      print("Get Otp Error : " + response.statusMessage.toString());
    }
  }
}
