import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:krishiyan/helper/app_global.dart';
import 'package:krishiyan/helper/constant.dart';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/mvc/model/farmer_dashboard_model.dart';
import 'package:krishiyan/mvc/model/villages_model.dart';

class FRMProvider extends ChangeNotifier {
  // widget data
  String? villageName, typeName;
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
  Future<void> fetchCrops(Function update) async {
    try {
      final response = await getAPICall(apiUrl: "${baseUrl}/all/crops");
      if (response.statusCode == 200) {
        crops = List<String>.from(jsonDecode(response.body)['data']);
        update();
      } else {
        print('Failed to retrieve crops');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // fetch village data
  String? selectedVillageName;
  SelectVillagesNameData? villageNameData;
  SelectVillagesNameData? drawerVillageNameData;
  Future<void> getVillageData(Function update, bool fromDrawer) async {
    try {
      // Retrieve the dealer number first
      String? number = await AppGlobal.getStringPreference('contactNumber');
      var dealerNumber = number ?? "1"; // Default to "1" if no number found
      showLoading();
      var response = await getAPICall(apiUrl: VILLAGES_NAMES + dealerNumber);
      stopLoading();
      if (response.statusCode == 200) {
        if (fromDrawer) {
          drawerVillageNameData =
              SelectVillagesNameData.fromJson(jsonDecode(response.body));
        } else {
          villageNameData =
              SelectVillagesNameData.fromJson(jsonDecode(response.body));
        }
        update();
      } else {
        throw Exception('Failed to load villages');
      }
    } catch (e) {
      print('Error fetching _village name data: $e');
    }
  }

  // First Tab - Farmer Dashboard
  TextEditingController searchByNaneController = TextEditingController();
  String searchText = '';
  late Future<List<FarmerDetails>> futureFarmerProfiles;
  String WhatsappNumberData = '';
  int? showCropDataVisible;
}
