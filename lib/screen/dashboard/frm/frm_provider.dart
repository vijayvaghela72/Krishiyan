import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:krishiyan/helper/app_global.dart';
import 'package:krishiyan/helper/constant.dart';

class FRMProvider extends ChangeNotifier {
  // farmer selection
  String? selectedFarmersName;
  List<String> dropdownItems = [];

  Future<void> fetchFarmerNameData() async {
    try {
      String? number = await AppGlobal.getStringPreference('contactNumber');
      var num = number ?? "1";
      var response = await getAPICall(apiUrl: FARMER_NAME + num);
      print(num);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        dropdownItems = jsonData['data']
            .map<String>((item) => item['name'].toString())
            .toList();
      } else {
        throw Exception('Failed to load farmers name');
      }
    } catch (e) {
      print('Error fetching farmer name data: $e');
    }
  }
  // for crops selection

  String? selectedCrop;

  List<String> crops = [];
}
