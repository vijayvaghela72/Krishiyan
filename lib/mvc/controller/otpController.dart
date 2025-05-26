import 'dart:convert';
import '../model/APIResponse.dart';
import '../../widgets/constant.dart';
import '../model/GetOtpDetails.dart';
import '../../helper/AlertHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:krishiyan/helper/api_base_helper.dart';

class OtpController {
  static Future<GetOtpData?> getOtp(dynamic data,
      {required BuildContext context}) async {
    var response = await postAPICall(
      apiUrl: GET_OTP,
      parameter: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("Otp Response : " + response.body);

      APIResponse? apiResponse =
          APIResponse.fromJson(jsonDecode(response.body));
      if (apiResponse.success!) {
        return apiResponse.getOtpData;
      }
      if (apiResponse.message != "") {
        AlertHelper.showToast(apiResponse.message!, context);
      }
      return null;
    } else {
      print("Get Otp Error : " + response.reasonPhrase.toString());
      return null;
    }
  }
}
