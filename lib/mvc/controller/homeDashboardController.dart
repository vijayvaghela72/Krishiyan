import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:krishiyan/mvc/model/MarketInsight.dart';
import '../../utils/Constants.dart';
import '../model/DailyNewsDetails.dart';
import 'package:http/http.dart' as http;

import '../model/GetMandiPriceData.dart';

class HomeDashboardController{

  static Future<List<NewsData>> getNewsDetails() async {
    final response = await http.get(Uri.parse(NEWS_LIST));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      print("News response : ${data}");
      return data.map((item) => NewsData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<MandiPriceData>> getMandiPriceDetails(String state, String district, String commodity,
      String initialDate, String finalDate) async {

    DateTime initialDateTime = DateTime.parse(initialDate);
    String initialFormattedDate = DateFormat('dd/MM/yyyy').format(initialDateTime);

    DateTime finalDateTime = DateTime.parse(finalDate);
    String finalFormattedDate = DateFormat('dd/MM/yyyy').format(finalDateTime);

    final response = await http.get(Uri.parse("https://krishiyanback.vercel.app/api/mandi/mandiPrices"
        "?state=$state&district=$district&commodity=$commodity"
        "&initialDate=$initialFormattedDate&finalDate=$finalFormattedDate"));

    print("state : $state");
    print("district : $district");
    print("commodity : $commodity");
    print("initialDate : $initialFormattedDate");
    print("finalDate : $finalFormattedDate");

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      print("Get Mandi Price Details : $data");
      return data.map((item) => MandiPriceData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<MarketInsight>> getMarketInsightDetails(String state, String district, String commodity) async {


    final response = await http.get(Uri.parse("https://krishiyanback.vercel.app/api/appData/price"
        "?state=$state&district=$district&commodity=$commodity"
        ));

    print("state : $state");
    print("district : $district");
    print("commodity : $commodity");
    

    if (response.statusCode == 200) {
      print("200");
      final List<dynamic> jsonResponse = json.decode(response.body);
    print("Get Market Price Details: $jsonResponse");
      return jsonResponse.map((item) => MarketInsight.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}