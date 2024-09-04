import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../helper/API.dart';
import '../../utils/AppGlobal.dart';
import '../../utils/Constants.dart';
import '../model/APIResponse.dart';
import '../model/InsightData.dart';

class SearchByInsightController{

  // static Future<InsightDetails?> searchByInsightDetails(BuildContext context, String whatsapp) async {
  //   return API
  //       .callPostImage(SEARCH_NUMBER_INSIGHT+"dealerNumber=1&whatsappNumber=$whatsapp", null, "", isKeyByPass: true)
  //       .then((response) {
  //     AppGlobal.printLog("Search insight Details RESPONSE : " + response);
  //     APIResponse? apiResponse = APIResponse.fromJson(jsonDecode(response));
  //     if (apiResponse.success!) {
  //       return apiResponse.insightDetails;
  //     }
  //     if (apiResponse.message != "") {
  //       // AlertHelper.showToast(apiResponse.message!, context);
  //     }
  //     return null;
  //   }).catchError((onError) {
  //     AppGlobal.printLog("ERROR " + onError.toString());
  //     return null;
  //   });
  // }

}