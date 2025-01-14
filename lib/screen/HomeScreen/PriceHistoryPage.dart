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
  String selectedTimeInterval = '1 month'; // Default to 1 month

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
      updateChartData('1 month'); // Initialize with 1 month data
    });
  }

  // Update the chart data based on the selected time interval
  void updateChartData(String timeInterval) {
    Map<int, List<PriceData>> groupedPrices;

    // Filter prices based on the selected interval
    switch (timeInterval) {
      case '1 month':
        groupedPrices = groupPricesByDay(prices);
        break;
      case '3 months':
        groupedPrices = groupPricesByMonth(prices);
        break;
      case '6 months':
        groupedPrices = groupPricesByMonth(prices);
        break;
      case '1 year':
        groupedPrices = groupPricesByMonth(prices);
        break;
      default:
        groupedPrices = groupPricesByMonth(prices);
    }

    setState(() {
      chartData = prepareChartData(groupedPrices, timeInterval);
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
                  return LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, TitleMeta meta) {
                              if (selectedTimeInterval == '1 month') {
                                return Text('${(value * 5).toInt()}'); // Show days in 5-day intervals
                              } else if (selectedTimeInterval == '3 months' ||
                                         selectedTimeInterval == '6 months' ||
                                         selectedTimeInterval == '1 year') {
                                final months = [
                                  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                                ];
                                return Text(months[value.toInt() % 12]);
                              }
                              return Container(); 
                            },
                          ),
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
