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
  String selectedYear = '2024'; // Default year selected
  String selectedMonth = '01 2024'; // Default selected month in MM YYYY format
  String selectedTimeFrame = '1 Year'; // Default time frame (could be 1 Year or 1 Month)

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
      updateChartData(); // Initialize with all data points
    });
  }

  // Function to filter the data based on the selected year
  List<PriceData> filterDataByYear(String year) {
    return prices.where((priceData) {
      return priceData.date.year.toString() == year;
    }).toList();
  }

  // Function to filter the data based on the selected month
  List<PriceData> filterDataByMonth(String monthYear) {
    return prices.where((priceData) {
      String monthYearLabel = '${priceData.date.month.toString().padLeft(2, '0')} ${priceData.date.year}';
      return monthYearLabel == monthYear;
    }).toList();
  }

  // Prepare chart data with all data points for the selected year or month
  void updateChartData() {
    List<PriceData> filteredPrices = [];
    
    if (selectedTimeFrame == '1 Year') {
      filteredPrices = filterDataByYear(selectedYear);
    } else if (selectedTimeFrame == '1 Month') {
      filteredPrices = filterDataByMonth(selectedMonth);
    }

    List<FlSpot> spots = [];
    int index = 0; // To keep track of X-axis values for each data point

    for (var price in filteredPrices) {
      spots.add(FlSpot(index.toDouble(), price.price));
      index++;
    }

    setState(() {
      chartData = spots; // Update the chart data with filtered data
    });
  }

  // Function to extract the month and year from the date
  String getMonthYearLabel(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String getMonthAbbreviationFromDate(DateTime date) {
  final months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[date.month - 1]; // Get the month abbreviation based on the month number (1-12)
}


  // Track the last displayed month-year to prevent repeated labels
  String? lastDisplayedMonthYear;

  @override
  Widget build(BuildContext context) {
    // Getting screen width for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 400; // Adjust threshold based on your design needs

    return Scaffold(
      appBar: AppBar(title: Text("Price History")),
      body: Column(
        children: [
          // Time frame selection dropdown (Year or Month)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Select Time Frame: '),
              DropdownButton<String>(
                value: selectedTimeFrame,
                onChanged: (String? newTimeFrame) {
                  setState(() {
                    selectedTimeFrame = newTimeFrame!;
                    // Reset selectedMonth to default when changing to Year
                    if (selectedTimeFrame == '1 Year') {
                      selectedMonth = '01 2024'; // Set a default value for Month
                    }
                    updateChartData(); // Update chart when time frame is changed
                  });
                },
                items: <String>['1 Year', '1 Month']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),

          // If "1 Year" is selected, show the year dropdown
          if (selectedTimeFrame == '1 Year') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Select Year: '),
                DropdownButton<String>(
                  value: selectedYear,
                  onChanged: (String? newYear) {
                    setState(() {
                      selectedYear = newYear!;
                      updateChartData(); // Update chart when year is changed
                    });
                  },
                  items: <String>['2024', '2025']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],

          // If "1 Month" is selected, show the month-year dropdown
          if (selectedTimeFrame == '1 Month') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Select Month: '),
                DropdownButton<String>(
                  value: selectedMonth,
                  onChanged: (String? newMonth) {
                    setState(() {
                      selectedMonth = newMonth!;
                      updateChartData(); // Update chart when month is changed
                    });
                  },
                  items: <String>[
                    '01 2024', '02 2024', '03 2024', '04 2024', '05 2024', '06 2024',
                    '07 2024', '08 2024', '09 2024', '10 2024', '11 2024', '12 2024',
                    '01 2025', '02 2025', '03 2025' // Add more as necessary
                  ]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],

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
                    padding: const EdgeInsets.all(40.0),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32, // Adjust space for Y-axis labels
                              interval: 2000, // Set interval between Y-axis ticks (1000, 2000, 3000, etc.)
                              getTitlesWidget: (value, meta) {
                                // Format the Y-axis label
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                        bottomTitles: AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    getTitlesWidget: (value, TitleMeta meta) {
      if (selectedTimeFrame == '1 Month') {
        // If "1 Month" is selected, show only the selected month as the x-axis label
        return Text(
          getMonthAbbreviationFromDate(prices[value.toInt()].date), // Show month abbreviation like Jan, Feb
          style: TextStyle(
            fontSize: isSmallScreen ? 8 : 12, // Adjust font size based on screen size
          ),
        );
      } else {
        // If a year is selected, show all months (Jan, Feb, Mar, etc.)
        DateTime date = prices[value.toInt()].date;
        String monthAbbreviation = getMonthAbbreviationFromDate(date);

        // Only show the label if it's different from the last one to prevent repetition
        if (lastDisplayedMonthYear != monthAbbreviation) {
          lastDisplayedMonthYear = monthAbbreviation;
          return Text(
            monthAbbreviation, // Show the month abbreviation (e.g., Jan, Feb)
            style: TextStyle(
              fontSize: isSmallScreen ? 8 : 12, // Adjust font size for small screens
            ),
          );
        } else {
          return Container(); // Return an empty container to avoid duplicate labels
        }
      }
    },
  ),
),

                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: chartData,
                            isCurved: true, // Smooth line
                            color: Colors.blue, // Line color
                            barWidth: 2, // Thinner line
                            belowBarData: BarAreaData(show: false), // Remove shaded area
                            dotData: FlDotData(show: false), // Hide the circular dots on data points
                          ),
                        ],
                        minY: 0, // Ensure the Y-axis starts from 0
                        maxY: 12000, // Set the maximum Y-axis value to 12000
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
