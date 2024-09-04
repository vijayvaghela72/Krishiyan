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

  static Map<String, String> getHeader() {
    Map<String, String> requestHeadersWithToken = {
      'Content-type': 'application/json'
    };
    return requestHeadersWithToken;
  }

  static Future<String> call(
      String url,
      MethodType method, {
        Map<String, dynamic>? body,
        bool? showLoading,
        bool? formData,
      }) async {
    Map<String, String> requestHeaders = getHeader();

    bool isFormData = formData ?? false;

    var responseJson;
    try {
      AppGlobal.printLog("req url :: " + url);
      AppGlobal.printLog("req header :: " + requestHeaders.toString());
      AppGlobal.printLog("req header :: " + requestHeaders.toString());
      AppGlobal.printLog("req body :: " + body.toString());

      http.Response response;
      switch (method) {
        case MethodType.GET:
          response = await http.get(Uri.parse(url),
              headers: requestHeaders != null ? requestHeaders : Map());
          break;
        case MethodType.POST:
          response = await http.post(Uri.parse(url),
              headers: requestHeaders != null
                  ? isFormData
                  ? Map()
                  : requestHeaders
                  : Map(),
              body: body != null
                  ? isFormData
                  ? body
                  : json.encode(body)
                  : json.encode({}));
          break;
        case MethodType.PUT:
          response = await http.put(Uri.parse(url),
              headers: requestHeaders != null ? requestHeaders : Map(),
              body: body != null ? json.encode(body) : json.encode({}));
          break;
        case MethodType.DELETE:
          response = await http.delete(Uri.parse(url),
              headers: requestHeaders != null ? requestHeaders : new Map());
          break;
      }
      AppGlobal.printLog("response code :: ${response.statusCode}");
      AppGlobal.printLog("response :: ${response.body}");
      switch (response.statusCode) {
        case 200:
        //AppGlobal.printLog("makeCall ~ apiResponse 200 :: " + response.body.toString());
          return response.body;

        default:
          AlertHelper.showToast(
              "${response.statusCode} Something went wrong!", "");
          return responseJson;
      }
      //AppGlobal.printLog("makeCall ~ apiResponse :: " + responseJson.toString());
    } on Exception catch (e) {
      AppGlobal.printLog("makeCall ~ Exception :: " + e.toString());
    }
    return responseJson;
  }
}

enum MethodType { GET, POST, PUT, DELETE }
