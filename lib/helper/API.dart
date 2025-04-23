import 'package:krishiyan/helper/api_base_helper.dart';
import '../utils/AppGlobal.dart';

class API {
  static Future<String> callPostImage(String url, file, String fileKey,
      {bool? isKeyByPass}) async {
    var request = getAPICall(apiUrl: url);

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
