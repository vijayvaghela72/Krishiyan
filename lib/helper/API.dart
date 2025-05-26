import 'package:krishiyan/helper/api_base_helper.dart';

class API {
  static Future<String> callPostImage(String url, file, String fileKey,
      {bool? isKeyByPass}) async {
    var request = getAPICall(apiUrl: url);

    print("Url = " + url.toString());

    return request.then((response) async {
      final int statusCode = response.statusCode;
      print("statusCode:==== " + statusCode.toString());
      return response.body;
    }).catchError((onError) {
      print("=========@@@@===========");
      print("onError " + onError.toString());
      return '';
    });
  }
}

enum MethodType { GET, POST, PUT, DELETE }
