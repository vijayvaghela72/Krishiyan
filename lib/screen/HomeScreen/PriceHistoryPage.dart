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
  String selectedTimeInterval = '1 year'; // Fixed to 1 year

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
      updateChartData(); // Initialize with 1 year data
    });
  }

  // Update the chart data based on the fixed time interval ('1 year')
  void updateChartData() {
    Map<int, List<PriceData>> groupedPrices = groupPricesByMonth(prices);

    setState(() {
      chartData = prepareChartData(groupedPrices, '1 year');
      selectedTimeInterval = '1 year';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Price History")),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adding padding
        child: Column(
          children: [
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
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 1000,  // Adjust Y-axis interval
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              getTitlesWidget: (value, TitleMeta meta) {
                                // Display price values on Y-axis
                                return Text('${value.toInt()}');
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              getTitlesWidget: (value, TitleMeta meta) {
                                final months = [
                                  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                                ];
                                return Text(months[value.toInt() % 12]);
                              },
                            ),
                          ),
                          // Hide right and top titles
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
  spots: chartData,
  isCurved: true,
  color: Colors.blue, // Line color
  barWidth: 2, // Thinner line (adjusted to 2)
  belowBarData: BarAreaData(show: false), // Optional: remove shaded area
  isStrokeCapRound: false, // Ensure no circular data points
  dotData: FlDotData(show: false), // Hide the circular dots
),

                        ],
                        minY: 0, // Min Y value
                        maxY: 10000, // Max Y value (prices from 0 to 10,000)
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
      ),
    );
  }
}
