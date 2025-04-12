import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/utils/Constants.dart';
import 'package:krishiyan/helper/AlertHelper.dart';
import 'package:krishiyan/mvc/model/MarketInsight.dart';
import '../../../mvc/model/MandiPriceDistrictData.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';
import 'package:krishiyan/mvc/model/MandiPriceStateData.dart';
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

  MandiPriceStateData? stateMarketItems;

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

  Future<void> fetchMarketDistrictData(Function update) async {
    try {
      showLoading();
      // Replace with your actual API endpoint
      var response = await Dio().get("${baseUrlEnd}"
          "api/mandi/filter?stateName=${homeProvider!.selectedMarketStateItemValue}");
      stopLoading();
      if (response.statusCode == 200) {
        print("fetchDistrictData response : $response");
        homeProvider!.districtMarketItems =
            MandiPriceDistrictData.fromJson(response.data);
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
      // Replace with your actual API endpoint
      var response = await Dio().get("${baseUrlEnd}"
          "api/mandi/filter?stateName=${homeProvider!.selectedMarketStateItemValue}&districtName=${homeProvider!.selectedMarketDistrictItemValue}");

      if (response.statusCode == 200) {
        print("fetchCommodityData response : $response");

        homeProvider!.commodityMarketItems =
            MandiPriceCommodityData.fromJson(response.data);
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
        homeProvider!.selectedMarketDistrictItemValue.toString().isNotEmpty &&
        homeProvider!.selectedMarketCommodityItemValue.toString().isNotEmpty) {
      homeProvider!.futureMarketInsight =
          HomeDashboardController.getMarketInsightDetails(
              homeProvider!.selectedMarketStateItemValue.toString(),
              homeProvider!.selectedMarketDistrictItemValue.toString(),
              homeProvider!.selectedMarketCommodityItemValue.toString());

      homeProvider!.futureMarketInsight = homeProvider!.futureMarketInsight;
      print("DATA");
      print(homeProvider!.futureMarketInsight);

      update();
    } else {
      AlertHelper.showToast("Please enter details.", context);
    }
  }
}
