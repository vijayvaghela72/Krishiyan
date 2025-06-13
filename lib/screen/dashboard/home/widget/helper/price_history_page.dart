import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:krishiyan/mvc/model/price_data_model.dart';

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

    chartData = updatedChartData;
    intSelectedType = timeInterval;
    setState(() {});
  }

  List<FlSpot> prepareChartData(List<PriceData> prices) {
    List<FlSpot> filteredData = [];
    DateTime? lastAddedDate;

    // Sort prices by date to ensure chronological order
    prices.sort((a, b) => a.date.compareTo(b.date));

    for (var price in prices) {
      if (intSelectedType == 3) {
        // For 1-year interval, filter data to reduce density (one data point every 10 days)
        if (lastAddedDate == null ||
            price.date.difference(lastAddedDate).inDays >= 10) {
          filteredData.add(FlSpot(
            price.date.millisecondsSinceEpoch.toDouble(),
            price.price.toDouble(),
          ));
          lastAddedDate = price.date; // Update the last added date
        }
      } else if (intSelectedType == 2) {
        // For 6-month interval, filter data to reduce density (one data point per week)
        if (lastAddedDate == null ||
            price.date.difference(lastAddedDate).inDays >= 7) {
          filteredData.add(FlSpot(
            price.date.millisecondsSinceEpoch.toDouble(),
            price.price.toDouble(),
          ));
          lastAddedDate = price.date; // Update the last added date
        }
      } else {
        // For other intervals (1 month, 3 months), include all data points
        filteredData.add(FlSpot(
          price.date.millisecondsSinceEpoch.toDouble(),
          price.price.toDouble(),
        ));
      }
    }

    print('filteredData length: ${filteredData.length}');
    return filteredData;
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

  double calculateMinX(int timeInterval) {
    DateTime now = DateTime.now();
    if (timeInterval == 0) {
      return now.subtract(Duration(days: 30)).millisecondsSinceEpoch.toDouble();
    } else if (timeInterval == 1) {
      return now.subtract(Duration(days: 90)).millisecondsSinceEpoch.toDouble();
    } else if (timeInterval == 2) {
      return now
          .subtract(Duration(days: 180))
          .millisecondsSinceEpoch
          .toDouble();
    } else if (timeInterval == 3) {
      return now
          .subtract(Duration(days: 365))
          .millisecondsSinceEpoch
          .toDouble();
    }
    return 0;
  }

  double calculateMaxX() {
    return DateTime.now().millisecondsSinceEpoch.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Price History"),
      ),
      body: Column(
        children: [
          // Time interval buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => updateChartData(0),
                  child: Text('1 Month'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: intSelectedType == 0 ? Colors.grey : null,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => updateChartData(1),
                  child: Text('3 Months'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: intSelectedType == 1 ? Colors.grey : null,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => updateChartData(2),
                  child: Text('6 Months'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: intSelectedType == 2 ? Colors.grey : null,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => updateChartData(3),
                  child: Text('1 Year'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: intSelectedType == 3 ? Colors.grey : null,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
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
                    padding: const EdgeInsets.all(25),
                    child: LineChart(
                      LineChartData(
                        minY: calculateMinY(chartData), // Set minY dynamically
                        maxY: calculateMaxY(chartData), // Set maxY dynamically
                        minX: calculateMinX(
                            intSelectedType), // Set minX dynamically
                        maxX: calculateMaxX(), // Set maxX dynamically
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                        ),
                        // y axis
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, TitleMeta meta) {
                                // Set custom Y-axis labels with interval of 2000
                                if (value % 2000 == 0 &&
                                    value <= calculateMaxY(chartData)) {
                                  return Text(
                                    value.round().toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  );
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
                            isCurved: true, //  need to manage
                            dotData: const FlDotData(
                              show: false,
                            ),
                            color: Colors.blue, // Line color
                            barWidth: 2,
                            belowBarData: BarAreaData(
                                show: false), // Optional: remove shaded area
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            maxContentWidth: 100,
                            getTooltipColor: (touchedSpot) => Colors.black,
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map(
                                (LineBarSpot touchedSpot) {
                                  // Convert the x value (milliseconds since epoch) to a DateTime object
                                  DateTime date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          touchedSpot.x.toInt());
                                  // Format the date as desired (e.g., "dd MMM yyyy" or any other format)
                                  String formattedDate =
                                      "${date.day} ${_getMonthName(date.month)}";
                                  final textStyle = TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  );
                                  // Display the formatted date and the y value in the tooltip
                                  return LineTooltipItem(
                                    '$formattedDate : ${touchedSpot.y.toStringAsFixed(2)}',
                                    textStyle,
                                  );
                                },
                              ).toList();
                            },
                          ),
                          getTouchedSpotIndicator: (LineChartBarData barData,
                              List<int> spotIndexes) {
                            return spotIndexes.map(
                              (spotIndex) {
                                return TouchedSpotIndicatorData(
                                  FlLine(color: Colors.green, strokeWidth: 2),
                                  FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                      radius: 5,
                                      color: Colors.green,
                                      strokeWidth: 2,
                                      strokeColor: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ).toList();
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text("No data available"),
                  );
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
