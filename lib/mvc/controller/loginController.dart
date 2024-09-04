import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../helper/AlertHelper.dart';
import '../../utils/Constants.dart';
import '../model/APIResponse.dart';
import '../model/LoginData.dart';

class LoginController {
  static Future<Data?> login(dynamic data,
      {required BuildContext context}) async {
    var headers = {
      'name': 'Content-Type',
      'value': 'application/json',
      'Content-Type': 'application/json'
    };

    var dio = Dio();
    var response = await dio.request(
      LOGIN,
      options: Options(
        method: 'POST',
        headers: headers,
        validateStatus: (_) => true,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      print("Login Response : " + json.encode(response.data));

      APIResponse? apiResponse = APIResponse.fromJson(response.data);
      if (apiResponse.success!) {
        return apiResponse.data!;
      }
      if (apiResponse.message != "") {
        AlertHelper.showToast(apiResponse.message!, context);
      }
      return null;
    } else {
      print("Error : " + response.statusMessage.toString());
    }
  }
}
