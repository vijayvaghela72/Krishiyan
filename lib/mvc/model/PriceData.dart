import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

// Model class to represent the price data
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
  final response = await http.get(Uri.parse('https://krishiyanback.vercel.app/api/market/$primaryKey'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data['success']) {
      final List<dynamic> prices = data['data']['prices'];

      // Convert the raw data into PriceData objects and sort them by date
      List<PriceData> priceDataList = prices.map((priceJson) => PriceData.fromJson(priceJson)).toList();
      
      // Sort the price data by date (ascending order)
      priceDataList.sort((a, b) => a.date.compareTo(b.date));

      return priceDataList;
    } else {
      throw Exception('Failed to load price data');
    }
  } else {
    throw Exception('Failed to load data from the API');
  }
}


Map<int, List<PriceData>> groupPricesByMonth(List<PriceData> prices) {
  Map<int, List<PriceData>> groupedPrices = {};
  for (var price in prices) {
    int month = price.date.month; // Group by month
    if (!groupedPrices.containsKey(month)) {
      groupedPrices[month] = [];
    }
    groupedPrices[month]?.add(price);
  }
  return groupedPrices;
}


Map<int, List<PriceData>> groupPricesByDay(List<PriceData> prices) {
  Map<int, List<PriceData>> groupedPrices = {};
  for (var price in prices) {
    int day = price.date.day; // Group by day of the month
    if (!groupedPrices.containsKey(day)) {
      groupedPrices[day] = [];
    }
    groupedPrices[day]?.add(price);
  }
  return groupedPrices;
}

List<FlSpot> prepareChartData(Map<int, List<PriceData>> groupedPrices, String timeInterval) {
  List<FlSpot> spots = [];

  // Depending on the time interval, adjust the chart generation logic
  switch (timeInterval) {
    case '1 month':
      // For 1 month, group by day and show the average for each day
      groupedPrices.forEach((day, prices) {
        double avgPrice = prices.fold(0.0, (sum, price) => sum + price.price) / prices.length;
        // X-axis value will be day, and Y-axis will be the average price
        spots.add(FlSpot(day.toDouble(), avgPrice));
      });
      break;
    
    case '3 months':
    case '6 months':
    case '1 year':
      // For 3 months, 6 months, and 1 year, group by month
      List<int> sortedMonths = groupedPrices.keys.toList()..sort(); // Sort months in ascending order
      for (int month in sortedMonths) {
        double avgPrice = groupedPrices[month]!.fold(0.0, (sum, price) => sum + price.price) / groupedPrices[month]!.length;
        // X-axis value will be month (adjusted for proper labels), and Y-axis will be the average price
        spots.add(FlSpot(month.toDouble() - 1, avgPrice)); // Subtract 1 to make months zero-indexed
      }
      break;
    
    default:
      // Default behavior, can be omitted or customized for other intervals
      break;
  }

  return spots;
}
