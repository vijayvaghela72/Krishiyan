import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:krishiyan/mvc/model/PriceData.dart';

class PriceHistoryPage extends StatefulWidget {
  final String? commodityId;

  PriceHistoryPage({required this.commodityId});

  @override
  _PriceHistoryPageState createState() => _PriceHistoryPageState();
}

class _PriceHistoryPageState extends State<PriceHistoryPage> {
  List<PriceData> prices = [];
  List<FlSpot> chartData = [];
  String selectedTimeInterval = '1 year'; // Default to 1 year

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Fetch the data when the page loads
  fetchData() async {
    final data = await fetchPriceHistory(widget.commodityId);
    setState(() {
      prices = data;
      updateChartData('1 year'); // Initialize with 1-year data
    });
  }

void updateChartData(String timeInterval) {
  List<FlSpot> updatedChartData = [];

  // Slice the topmost prices based on the selected time interval
  List<PriceData> selectedPrices = [];
  if (timeInterval == '1 month') {
    selectedPrices = prices.take(30).toList(); // Take the topmost 30 prices
  } else if (timeInterval == '3 months') {
    selectedPrices = prices.take(90).toList(); // Take the topmost 90 prices
  } else if (timeInterval == '6 months') {
    selectedPrices = prices.take(180).toList(); // Take the topmost 180 prices
  } else if (timeInterval == '1 year') {
    selectedPrices = prices; // No slicing for 1 year
  }

  // Prepare the chart data for the selected prices
  updatedChartData = prepareChartDataForYear(selectedPrices);

  setState(() {
    chartData = updatedChartData;
    selectedTimeInterval = timeInterval;
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Price History")),
    body: Column(
      children: [
        // Time interval buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => updateChartData('1 month'),
              child: Text('1 Month'),
            ),
            ElevatedButton(
              onPressed: () => updateChartData('3 months'),
              child: Text('3 Months'),
            ),
            ElevatedButton(
              onPressed: () => updateChartData('6 months'),
              child: Text('6 Months'),
            ),
            ElevatedButton(
              onPressed: () => updateChartData('1 year'),
              child: Text('1 Year'),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder<List<PriceData>>(
            future: fetchPriceHistory(widget.commodityId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, TitleMeta meta) {
                              // Set custom Y-axis labels with interval of 2000
                              if (value % 2000 == 0 && value <= 12000) {
                                return Text(value.toString(),
                                    style: TextStyle(fontSize: 10));
                              }
                              return Container();
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, TitleMeta meta) {
                              if (selectedTimeInterval == '1 year') {
                                // Show the date in format yyyy-MM-dd
                                return Text(DateTime.fromMillisecondsSinceEpoch(value.toInt()).toString().substring(0, 10));
                              }
                              return Container();
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: chartData,
                          isCurved: true,
                          color: Colors.blue, // Line color
                          barWidth: 4,
                          belowBarData: BarAreaData(show: false), // Optional: remove shaded area
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: Text("No data available"));
              }
            },
          ),
        ),
      ],
    ),
  );
}
}
