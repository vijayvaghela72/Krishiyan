import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/helper/snackbar.dart';
import 'package:krishiyan/mvc/model/DailyNewsDetails.dart';
import 'package:krishiyan/utils/Constants.dart';
import 'package:krishiyan/helper/AlertHelper.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:krishiyan/mvc/model/MarketInsight.dart';
import '../../../mvc/model/MandiPriceDistrictData.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';
import 'package:krishiyan/mvc/model/MandiPriceCommodityData.dart';
import 'package:krishiyan/screen/home_screen/home/home_model.dart';
import 'package:krishiyan/mvc/controller/homeDashboardController.dart';

class HomeProvider extends ChangeNotifier {
  // common data
  final List<String> topData = [
    buildTranslate("dailyMarket")!,
    buildTranslate("mandiPrice")!,
    buildTranslate("marketInsight")!
  ];

  List<bottomCategory> iconList = [
    bottomCategory(
        name: buildTranslate("home")!,
        id: "1",
        icon: 'assets/images/bottom1.png'),
    bottomCategory(
        name: buildTranslate("frm")!,
        id: "2",
        icon: 'assets/images/bottom2.png'),
    bottomCategory(
        name: buildTranslate("crop")!,
        id: "3",
        icon: 'assets/images/bottom3.png'),
    bottomCategory(
        name: buildTranslate("profile")!,
        id: "4",
        icon: 'assets/images/bottom4.png'),
  ];

  final imageSliders = [
    Image.asset("assets/images/home_banner.png"),
    Image.asset("assets/images/home_banner.png")
  ];

  List<bottomCategory> iconList2 = [
    bottomCategory(
        name: buildTranslate("home")!,
        id: "1",
        icon: 'assets/images/bottom1.png'),
    bottomCategory(
        name: buildTranslate("profile")!,
        id: "2",
        icon: 'assets/images/bottom4.png'),
  ];

  final List<String> sortItems = [
    buildTranslate('lowToHighPrice')!,
    buildTranslate('highToLowPrice')!,
  ];

  // for selected state insite marketing
  String? selectedMarketStateItemValue;

  // for selected district inside markting
  String? selectedMarketDistrictItemValue;

  MandiPriceCommodityData? commodityItems;
  MandiPriceCommodityData? commodityMarketItems;

  MandiPriceDistrictData? districtItems;
  MandiPriceDistrictData? districtMarketItems;

  String selectedMarketCommodityItemValue = "";

  Future<List<MarketInsight>>? futureMarketInsight;

//*************************************************************************** */

// News
  List<NewsData> newsListData = [];

  Future<void> getNewsDetails() async {
    var response = await getAPICall(apiUrl: NEWS_LIST);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      print("News response : ${data}");
      newsListData = data.map((item) => NewsData.fromJson(item)).toList();
    } else {
      newsListData = [];
      setSnackbar('Fail to load news data');
    }
  }

//*************************************************************************** */

  Future<void> fetchMarketDistrictData(Function update) async {
    try {
      showLoading();
      // Replace with your actual API endpoint
      var response = await getAPICall(
          apiUrl: "${baseUrlEnd}"
              "api/mandi/filter?stateName=${homeProvider!.selectedMarketStateItemValue}");
      stopLoading();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        print("fetchDistrictData response : $response");
        districtMarketItems = MandiPriceDistrictData.fromJson(data);
        update();
      } else {
        throw Exception('Failed to load state');
      }
    } catch (e) {
      print('HomePage Mandi Price : Error fetching state data: $e');
    }
  }

  Future<void> fetchMarketCommodityData(Function update) async {
    try {
      var response = await getAPICall(
          apiUrl: "${baseUrlEnd}"
              "api/mandi/filter?stateName=${homeProvider!.selectedMarketStateItemValue}&districtName=${homeProvider!.selectedMarketDistrictItemValue}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        print("fetchCommodityData response : $response");

        commodityMarketItems = MandiPriceCommodityData.fromJson(data);
        update();
      } else {
        throw Exception('Failed to load state');
      }
    } catch (e) {
      print('HomePage Mandi Price : Error fetching state data: $e');
    }
  }

  void getMarketInsight(Function update, BuildContext context) {
    print("object");
    if (homeProvider!.selectedMarketStateItemValue.toString().isNotEmpty &&
        selectedMarketDistrictItemValue.toString().isNotEmpty &&
        selectedMarketCommodityItemValue.toString().isNotEmpty) {
      futureMarketInsight = HomeDashboardController.getMarketInsightDetails(
          selectedMarketStateItemValue.toString(),
          selectedMarketDistrictItemValue.toString(),
          selectedMarketCommodityItemValue.toString());

      futureMarketInsight = futureMarketInsight;
      print("DATA");
      print(homeProvider!.futureMarketInsight);

      update();
    } else {
      AlertHelper.showToast("Please enter details.", context);
    }
  }

//*************************************************************************** */
  // state listing
  List<String> mandiStateList = [];
  Future<void> fetchStateData(Function update) async {
    try {
      var response = await getAPICall(apiUrl: MANDI_PRICE_STATE);
      // Replace with your actual API endpoint

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print("fetchStateData response : $response");
        mandiStateList = List<String>.from(jsonData['data'] ?? []);
        print(' data:');
      } else {
        mandiStateList = [];
        setSnackbar('Failed to load state');
      }
      update();
    } catch (e) {
      setSnackbar('Mandi Price : Error fetching state data: $e');
    }
  }

//*************************************************************************** */
}
