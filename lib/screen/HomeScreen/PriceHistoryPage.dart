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
  int intSelectedType =
      3; // 0 - "month" , 1 - "3 months" , 2 - "6 months", 3 - "1 year"
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
      updateChartData(3); // Initialize with 1-year data
    });
  }

  void updateChartData(int timeInterval) {
    List<FlSpot> updatedChartData = [];

    // Filter data based on the selected time interval
    DateTime now = DateTime.now();
    List<PriceData> selectedPrices = prices.where((price) {
      DateTime priceDate = price.date;
      Duration difference = now.difference(priceDate);

      if (timeInterval == 0) {
        return difference.inDays <= 30; // 1 month
      } else if (timeInterval == 1) {
        return difference.inDays <= 90; // 3 months
      } else if (timeInterval == 2) {
        return difference.inDays <= 180; // 6 months
      } else if (timeInterval == 3) {
        return true; // 1 year (no filtering)
      }
      return false;
    }).toList();

    // Prepare the chart data for the selected prices
    updatedChartData = prepareChartData(selectedPrices);

    setState(() {
      chartData = updatedChartData;
      intSelectedType = timeInterval;
    });
  }

  List<FlSpot> prepareChartData(List<PriceData> prices) {
    if (intSelectedType == 2) {
      // 6-month interval
      List<FlSpot> filteredData = [];
      DateTime? lastAddedDate;

      for (var price in prices) {
        if (lastAddedDate == null ||
            price.date.difference(lastAddedDate).inDays >= 18) {
          filteredData.add(FlSpot(
            price.date.millisecondsSinceEpoch.toDouble(),
            price.price.toDouble(),
          ));
          lastAddedDate = price.date;
        }
      }

      return filteredData;
    }

    // For other intervals, return all data points
    return prices.map((price) {
      // Convert the date to a timestamp for the X-axis
      double timestamp = price.date.millisecondsSinceEpoch.toDouble();
      return FlSpot(timestamp, price.price.toDouble());
    }).toList();
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  double calculateMinY(List<FlSpot> chartData) {
    if (chartData.isEmpty) return 0;

    double minY =
        chartData.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);

    // Ensure the minimum value is at least 20 units below the smallest data point
    double dynamicMinY = minY -
        chartData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.1;

    // Ensure the dynamicMinY is not less than 0
    dynamicMinY = dynamicMinY > 0 ? dynamicMinY : 0;

    // Print the dynamicMinY for debugging
    print('dynamicMinY : $dynamicMinY');

    // Return the dynamicMinY directly without any further adjustments
    return dynamicMinY;
  }

  double calculateMaxY(List<FlSpot> chartData) {
    if (chartData.isEmpty) return 100; // Default max value if no data
    return chartData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) *
        1.1; // 10% padding
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
                onPressed: () => updateChartData(0),
                child: Text('1 Month'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: intSelectedType == 0 ? Colors.grey : null,
                ),
              ),
              ElevatedButton(
                onPressed: () => updateChartData(1),
                child: Text('3 Months'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: intSelectedType == 1 ? Colors.grey : null,
                ),
              ),
              ElevatedButton(
                onPressed: () => updateChartData(2),
                child: Text('6 Months'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: intSelectedType == 2 ? Colors.grey : null,
                ),
              ),
              ElevatedButton(
                onPressed: () => updateChartData(3),
                child: Text('1 Year'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: intSelectedType == 3 ? Colors.grey : null,
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
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
                        minY: calculateMinY(chartData), // Set minY dynamically
                        maxY: calculateMaxY(chartData), // Set maxY dynamically
                        gridData: FlGridData(show: true),
                        // lineTouchData: ,

                        titlesData: FlTitlesData(
                          // y axis
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, TitleMeta meta) {
                                // Set custom Y-axis labels with interval of 2000
                                if (value % 2000 == 0 &&
                                    value <= calculateMaxY(chartData)) {
                                  return Text(value.round().toString(),
                                      style: TextStyle(fontSize: 10));
                                }
                                return Container();
                              },
                            ),
                          ),
                          // x axis
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, TitleMeta meta) {
                                DateTime date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        value.toInt());
                                // Format the date based on the selected time interval
                                if (intSelectedType == 0) {
                                  return Text(
                                    '${date.day} \n${_getMonthName(date.month)}',
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                  );
                                } else if (intSelectedType == 1 ||
                                    intSelectedType == 2) {
                                  return Text(
                                    '${date.day} \n${_getMonthName(date.month)}',
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                  );
                                } else if (intSelectedType == 3) {
                                  return Text(
                                    '${date.day} \n${_getMonthName(date.month)}',
                                    style: TextStyle(fontSize: 10),
                                    textAlign: TextAlign.center,
                                  );
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
                            belowBarData: BarAreaData(
                                show: false), // Optional: remove shaded area
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
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
