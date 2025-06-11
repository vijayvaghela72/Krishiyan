import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../language/select_language.dart';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/helper/provider.dart';
import '../../../localization/app_localizations.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:krishiyan/mvc/model/frm_insight_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishiyan/screen/dashboard/frm/frm_model.dart';
import 'package:krishiyan/screen/dashboard/frm/frm_provider.dart';
import '../../../mvc/controller/farmer_dashboard_controller.dart';
import 'package:krishiyan/screen/dashboard/frm/farmer_dashboard/insight.dart';
import 'package:krishiyan/screen/dashboard/frm/farmer_dashboard/crop_cultivator.dart';
import 'package:krishiyan/screen/dashboard/frm/farmer_dashboard/farmer_dashboard.dart';
import 'package:krishiyan/screen/dashboard/frm/farmer_dashboard/farmer_registration.dart';

// ignore: must_be_immutable
class FRM extends StatefulWidget {
  bool aapbarVisibility;
  String? villageName, typeName;

  FRM({
    super.key,
    required this.aapbarVisibility,
    this.villageName,
    this.typeName,
  });

  @override
  State<FRM> createState() => _FRMState();
}

class _FRMState extends State<FRM> with TickerProviderStateMixin {
  final List<String> topData = [
    buildTranslate("farmerDashboard")!,
    buildTranslate("farmerRegistration")!,
    buildTranslate("cropCultivation")!,
    buildTranslate("insights")!
  ];
  setStateNow() {
    if (mounted) {
      setState(() {});
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> sortItems = [
    buildTranslate("highExpYield")!,
    buildTranslate("lowExpYield")!,
  ];

  String? selectedSortItemsValue;
  List<Farmer> sortedFarmers = []; // To hold the sorted farmers list

  var farmerDashboardList;
  // SelectCropNamesData? _cropData;

  String number = "";

  Future<InsightDetails?>? futureSearchInsightDetails;
  String dealerNumberData = "";
  @override
  void dispose() {
    // Always cancel the timer when the widget is disposed
    frmProvider!.otpCooldownTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    frmProvider = Provider.of<FRMProvider>(context, listen: false);
    frmProvider!.villageName = widget.villageName;
    frmProvider!.typeName = widget.typeName;
    frmProvider!.futureFarmerProfiles =
        FarmerDashboardController.fetchFarmerDashboard(
            context, widget.villageName, widget.typeName);
    getAllData();
  }

  getAllData() async {
    showLoading();
    await frmProvider!.fetchCrops(setStateNow);
    await frmProvider!.fetchFarmerNameData();
    await frmProvider!.getVillageData(setStateNow, false);
    stopLoading();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),
      extendBody: false,
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      appBar: widget.aapbarVisibility
          ? AppBar(
              automaticallyImplyLeading: false,
              title: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const SelectLanguagePage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/loginLogo.png',
                      width: 150,
                      height: 60,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 5, top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/language.png',
                            width: 35,
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 20),
              child: Container(
                height: 80,
                child: ListView.builder(
                  itemCount: topData.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _onSelectedTopDataTapped(index);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Chip(
                          backgroundColor: frmProvider!.selectedTopData == index
                              ? Colors.green
                              : Colors.white,
                          padding: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: frmProvider!.selectedTopData == index
                                      ? Colors.green
                                      : Colors.black),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              )),
                          label: Text(
                            topData[index].toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "poppins-regular",
                              color: frmProvider!.selectedTopData == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            frmProvider!.selectedTopData == 0
                ? firstTabData(context, setStateNow)
                : frmProvider!.selectedTopData == 1
                    ? secondTabData(context, setStateNow)
                    : frmProvider!.selectedTopData == 2
                        ? thirdTabData(context, setStateNow)
                        : frmProvider!.selectedTopData == 3
                            ? fourthTabData(context, setStateNow)
                            : frmProvider!.selectedTopData == 4
                                ? Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              highlightColor:
                                                  Colors.transparent,
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                setState(() {
                                                  frmProvider!.selectedTopData =
                                                      3;
                                                });
                                              },
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color: Colors.black,
                                                size: 25.0,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              buildTranslate("goBack")!,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'poppins-medium',
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25.0, right: 20.0, top: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color(0xFF73C187),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: FutureBuilder<
                                                        FrmInsight?>(
                                                    future: frmProvider!
                                                        .futureFrminSight,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return Center(
                                                            child:
                                                                CircularProgressIndicator()); // Show loading spinner while waiting
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Center(
                                                            child: Text(
                                                                'Error: ${snapshot.error}')); // Show error message
                                                      } else if (!snapshot
                                                          .hasData) {
                                                        return Center(
                                                            child: Text(
                                                                'No data available.')); // Show message if no data
                                                      } else {
                                                        // Successfully fetched data
                                                        FrmInsight? frminSight =
                                                            snapshot.data;
                                                        int totalFarmers = frminSight
                                                                ?.data
                                                                .numberOfFarmers ??
                                                            0; // Get total farmers
                                                        print(totalFarmers);

                                                        return Column(
                                                          children: [
                                                            // Display total farmers inside brackets dynamically
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          20.0),
                                                              child: Text(
                                                                "Farmers($totalFarmers)", // Fallback to default if buildTranslate fails
                                                                softWrap: true,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'poppins-semibold'),
                                                              ),
                                                            ),
                                                            // Other UI elements here...
                                                          ],
                                                        );
                                                      }
                                                    }),
                                              ),
                                            ),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Container(
                                                width: 150,
                                                height: 40,
                                                color: Colors.white,
                                                child: DropdownButtonFormField2<
                                                    String>(
                                                  isExpanded: true,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 5),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  hint: Text(
                                                    buildTranslate('sortBy')!,
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  items: sortItems
                                                      .map((item) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                            value: item,
                                                            child: Text(
                                                              item,
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    //Do something when selected item is changed.
                                                  },
                                                  onSaved: (value) {
                                                    selectedSortItemsValue =
                                                        value.toString();
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                  ),
                                                  iconStyleData:
                                                      const IconStyleData(
                                                    icon: ImageIcon(AssetImage(
                                                        'assets/images/sortBy.png')),
                                                    iconSize: 20,
                                                    iconEnabledColor:
                                                        Colors.black,
                                                  ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      _buildHeaderTable(),
                                      FutureBuilder<FrmInsight?>(
                                        future: frmProvider!
                                            .futureFrminSight, // The future that fetches FrmInsight data
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator()); // Loading state
                                          } else if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}')); // Error handling
                                          } else if (!snapshot.hasData) {
                                            return Center(
                                                child:
                                                    Text('No data available.'));
                                          } else {
                                            FrmInsight? frminSight =
                                                snapshot.data;
                                            if (frminSight == null ||
                                                frminSight
                                                    .data.farmers.isEmpty) {
                                              return Center(
                                                  child: Text(
                                                      'No farmers data available.'));
                                            }
                                            // Get the farmers data
                                            var farmers =
                                                snapshot.data?.data.farmers ??
                                                    [];
                                            // Sort the farmers based on the selected sorting option
                                            if (selectedSortItemsValue ==
                                                buildTranslate(
                                                    "highExpYield")) {
                                              // Sort in descending order by expectedYield (high to low)
                                              farmers.sort((a, b) => b
                                                  .expectedYield
                                                  .compareTo(a.expectedYield));
                                            } else if (selectedSortItemsValue ==
                                                buildTranslate("lowExpYield")) {
                                              // Sort in ascending order by expectedYield (low to high)
                                              farmers.sort((a, b) => a
                                                  .expectedYield
                                                  .compareTo(b.expectedYield));
                                            }

                                            // Pass the fetched FrmInsight data to the table widget
                                            return Column(
                                              children: [
                                                // The header row of the table
                                                buildTable(context,
                                                    frminSight), // The table with farmer data
                                              ],
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  )
                                : Container(),
          ],
        ),
      ),
    );
  }

  void _onSelectedTopDataTapped(int index) {
    setState(() {
      frmProvider!.selectedTopData = index;
    });
    if (frmProvider!.selectedTopData == 0) {
      if (mounted) {
        setState(() {
          frmProvider!.futureFarmerProfiles =
              FarmerDashboardController.fetchFarmerDashboard(
                  context, widget.villageName, widget.typeName);
        });
      }
    }
    print("Selected Top Page : ${frmProvider!.selectedTopData}");
  }

  Widget buildTable(BuildContext context, FrmInsight frminSight) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.black),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(4),
            1: FlexColumnWidth(5),
            2: FlexColumnWidth(5),
          },
          border: TableBorder.all(),
          children: [
            // Data rows: loop over the list of farmers in FrmInsight
            for (var farmer in frminSight.data.farmers)
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    farmer.name,
                    style: const TextStyle(
                        fontFamily: "poppins-semibold", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    farmer.whatsappNumber, // Use 'N/A' if number is null
                    style: const TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    farmer.expectedYield.toString(),
                    style: const TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTable() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Container(
        width: double.maxFinite,
        height: 70,
        padding: const EdgeInsets.fromLTRB(
          10,
          16,
          45,
          16,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF73C187),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _titleHeaderTable('Name', 3),
              _titleHeaderTable('Mobile \nNumber', 4),
              _titleHeaderTable('Expected Yield \n(in Qtl)', 2),
            ]),
      ),
    );
  }

  Widget _titleHeaderTable(String title, int flexNum) {
    return Expanded(
      flex: flexNum,
      child: Container(
        child: Text(
          title,
          textAlign: TextAlign.left,
          maxLines: 2,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 11.0,
              fontFamily: "poppins-semibold"),
        ),
      ),
    );
  }
}
