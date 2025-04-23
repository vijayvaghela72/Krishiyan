import 'dart:convert';
import '../../utils/Constants.dart';
import 'package:krishiyan/mvc/model/PriceData.dart';
import 'package:krishiyan/helper/api_base_helper.dart';

class HomeDashboardController {
  // Function to fetch price history from the API
  static Future<List<PriceData>> fetchPriceHistory(String primaryKey) async {
    final response = await getAPICall(apiUrl: '${baseUrl}market/$primaryKey');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['success']) {
        final List<dynamic> prices = data['data']['prices'];
        return prices
            .map((priceJson) => PriceData.fromJson(priceJson))
            .toList();
      } else {
        throw Exception('Failed to load price data');
      }
    } else {
      throw Exception('No price data found');
    }
  }
}
