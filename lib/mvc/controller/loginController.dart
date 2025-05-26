import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:flutter/cupertino.dart';
import '../../helper/AlertHelper.dart';
import '../../widgets/constant.dart';
import '../model/APIResponse.dart';
import '../model/LoginData.dart';
import 'dart:convert';

class LoginController {
  static Future<Data?> login(dynamic data,
      {required BuildContext context}) async {
    var response = await postAPICall(apiUrl: LOGIN, parameter: data);

    if (response.statusCode == 200) {
      print("Login Response : " + response.body);

      APIResponse? apiResponse =
          APIResponse.fromJson(json.decode(response.body));
      if (apiResponse.success!) {
        return apiResponse.data!;
      }
      if (apiResponse.message != "") {
        AlertHelper.showToast(apiResponse.message!, context);
      }
      return null;
    } else {
      print("Error : " + response.reasonPhrase.toString());
    }
  }
}
