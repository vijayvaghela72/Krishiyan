import 'dart:convert';

import '../utils/AppGlobal.dart';
import 'AlertHelper.dart';
import 'package:http/http.dart' as http;

import 'SharedPref.dart';

class API {

  static Future<String> callPostImage(
      String url, file, String fileKey,
      {bool? isKeyByPass}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json'
    };
    var request = http.get(Uri.parse(url), headers: headers);

    AppGlobal.printLog("Url = " + url.toString());

    return request.then((response) async {
      final int statusCode = response.statusCode;
      AppGlobal.printLog("statusCode:==== " + statusCode.toString());
      return response.body;
    }).catchError((onError) {
      AppGlobal.printLog("=========@@@@===========");
      AppGlobal.printLog("onError " + onError.toString());
    }).whenComplete(
            () => {AppGlobal.printLog("=========@@@@==whenComplete=========")});
  }
}

enum MethodType { GET, POST, PUT, DELETE }
