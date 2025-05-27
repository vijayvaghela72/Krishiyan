import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:krishiyan/helper/constant.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/helper/snackbar.dart';
import '../../../mvc/model/mandi_price_model.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:krishiyan/mvc/model/market_insight_model.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/screen/dashboard/home/home_model.dart';

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

  String selectedSortItemsValue = "";

//*************************************************************************** */

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  String dateOfFromValue = "", dateOfToValue = "";

  DateTime? selectedDate;

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

  void getMarketInsight(Function update, BuildContext context) async {
    if (homeProvider!.selectedMandiStateList != null &&
        selectedPriceMandiCoodityData != null &&
        selectedPriceMandiCoodityData != null) {
      await getMarketInsideDetail(
        selectedMandiStateList.toString(),
        selectedDistrictMasterList.toString(),
        selectedPriceMandiCoodityData.toString(),
      );
      update();
    } else {
      setSnackbar("Please enter details.");
    }
  }

//*************************************************************************** */
  // state listing
  List<String> mandiStateList = [];
  String? selectedMandiStateList;
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
// for price mandi
  List<String> districtMasterList = [];
  String? selectedDistrictMasterList;
  Future<void> fetchDistrictData(Function update) async {
    try {
      var response = await getAPICall(
          apiUrl: "${baseUrlEnd}"
              "api/mandi/filter?stateName=${homeProvider!.selectedMandiStateList}");

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print("fetchDistrictData response : $response");

        districtMasterList = List<String>.from(jsonData['data'] ?? []);
        update();
      } else {
        districtMasterList = [];
        setSnackbar('Failed to load state');
      }
    } catch (e) {
      setSnackbar(' Mandi Price : Error fetching state data: $e');
    }
  }

//*************************************************************************** */
  List<MarketInsight> marketInsightList = [];
// market inside detail
  getMarketInsideDetail(String state, String district, String commodity) async {
    final response = await getAPICall(
        apiUrl: "${baseUrl}appData/price"
            "?state=$state&district=$district&commodity=$commodity");

    if (response.statusCode == 200) {
      print("200");
      final List<dynamic> jsonResponse = json.decode(response.body);
      print("Get Market Price Details: $jsonResponse");
      marketInsightList =
          jsonResponse.map((item) => MarketInsight.fromJson(item)).toList();
    } else {
      marketInsightList = [];
      setSnackbar('Failed to load data');
    }
  }

//*************************************************************************** */
// get mandi price detail
  List<MandiPriceData> mandiPriceData = [];
  Future<void> getMandiPriceDetails(String state, String district,
      String commodity, String initialDate, String finalDate) async {
    print('initialDate :|${initialDate}|');
    // print('?state=$state&district=$district&commodity=$commodity');
    // print(' "&initialDate=&finalDate="');
    print('finalDate :|${finalDate}|');

    // Parse date in dd-MM-yyyy format
    List<String> initialParts = initialDate.split('-');
    DateTime initialDateTime = DateTime(
        int.parse(initialParts[2]), // year
        int.parse(initialParts[1]), // month
        int.parse(initialParts[0]) // day
        );
    String initialFormattedDate =
        DateFormat('dd/MM/yyyy').format(initialDateTime);

    List<String> finalParts = finalDate.split('-');
    DateTime finalDateTime = DateTime(
        int.parse(finalParts[2]), // year
        int.parse(finalParts[1]), // month
        int.parse(finalParts[0]) // day
        );
    String finalFormattedDate = DateFormat('dd/MM/yyyy').format(finalDateTime);

    final response = await getAPICall(
        apiUrl: "${baseUrl}mandi/mandiPrices"
            "?state=$state&district=$district&commodity=$commodity"
            "&initialDate=$initialFormattedDate&finalDate=$finalFormattedDate");

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      print("Get Mandi Price Details : $data");
      mandiPriceData =
          data.map((item) => MandiPriceData.fromJson(item)).toList();
    } else {
      mandiPriceData = [];
      setSnackbar('Failed to load data');
    }
  }

//*************************************************************************** */
  List<String> priceMandiCoodityData = [];
  String? selectedPriceMandiCoodityData;
  Future<void> fetchCommodityData(Function update) async {
    try {
      var response = await getAPICall(
          apiUrl: "${baseUrlEnd}"
              "api/mandi/filter?stateName=${homeProvider!.selectedMandiStateList}&districtName=${homeProvider!.selectedDistrictMasterList}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print("fetchCommodityData response : $response");
        priceMandiCoodityData = List<String>.from(data['data'] ?? []);
      } else {
        priceMandiCoodityData = [];
        setSnackbar('Failed to load state');
      }
      update();
    } catch (e) {
      setSnackbar(' Mandi Price : Error fetching state data: $e');
    }
  } //*************************************************************************** */
}
