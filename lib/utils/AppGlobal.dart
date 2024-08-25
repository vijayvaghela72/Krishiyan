import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../mvc/model/LoginData.dart';
import 'Constants.dart';

class AppGlobal{

  static FpoOrganization? user;
  static bool isUserLogin = false;
  static String? token = "";

  static printLog(dynamic val) {
    if (DEVELOPER_MODE) {
      if (kDebugMode) log(val.toString());
    }
  }

}