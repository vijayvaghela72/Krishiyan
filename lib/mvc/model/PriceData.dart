import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Model class to represent the price data
class PriceData {
  final double price;
  final DateTime date;

  PriceData({required this.price, required this.date});

  factory PriceData.fromJson(Map<String, dynamic> json) {
    return PriceData(
      price: json['price'].toDouble(),
      date: DateTime.parse(json['date']), // Parsing the ISO date string
    );
  }
}

Future<List<PriceData>> fetchPriceHistory(String? primaryKey) async {
  final response = await http.get(Uri.parse('https://krishiyanback.vercel.app/api/market/$primaryKey'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data['success']) {
      final List<dynamic> prices = data['data']['prices'];
      // Sort prices by date in ascending order
      List<PriceData> priceList = prices
          .map((priceJson) => PriceData.fromJson(priceJson))
          .toList();
      priceList.sort((a, b) => a.date.compareTo(b.date)); // Sort by date

      return priceList;
    } else {
      throw Exception('Failed to load price data');
    }
  } else {
    throw Exception('Failed to load data from the API');
  }
}

// Prepare chart data for plotting all the data points (without averaging)
List<FlSpot> prepareChartData(List<PriceData> prices) {
  List<FlSpot> spots = [];

  // Iterate through the list of prices and create a FlSpot for each price with its corresponding date
  for (int i = 0; i < prices.length; i++) {
    // We use the index as the X-value (this will be the position in the line chart)
    // The Y-value is the price for that particular date
    spots.add(FlSpot(i.toDouble(), prices[i].price));
  }

  return spots;
}
