import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:krishiyan/utils/Constants.dart';
import 'package:krishiyan/helper/api_base_helper.dart';

class PriceData {
  final double price;
  final DateTime date;

  PriceData({required this.price, required this.date});

  factory PriceData.fromJson(Map<String, dynamic> json) {
    return PriceData(
      price: json['price'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }
}

// Function to fetch price history from the API
Future<List<PriceData>> fetchPriceHistory(String? primaryKey) async {
  final response = await getAPICall(apiUrl: '${baseUrl}market/$primaryKey');
  print('${baseUrl}market/$primaryKey');
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    print('data : $data');
    if (data['success']) {
      final List<dynamic> prices = data['data']['prices'];
      return prices.map((priceJson) => PriceData.fromJson(priceJson)).toList();
    } else {
      throw Exception('Failed to load price data');
    }
  } else {
    throw Exception('Failed to load data from the API');
  }
}

// Function to plot all data points for 1 year interval
List<FlSpot> prepareChartDataForYear(List<PriceData> prices) {
  List<FlSpot> spots = [];

  // Plot all data points with their actual date and price
  for (var price in prices) {
    // X-axis is the date in milliseconds since epoch (to create a continuous range)
    spots
        .add(FlSpot(price.date.millisecondsSinceEpoch.toDouble(), price.price));
  }

  return spots;
}
