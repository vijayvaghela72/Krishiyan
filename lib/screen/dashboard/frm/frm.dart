import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../helper/app_global.dart';
import '../../language/select_language.dart';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/helper/constant.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/helper/snackbar.dart';
import '../../../localization/app_localizations.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:krishiyan/mvc/model/frm_insight_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishiyan/screen/dashboard/frm/frm_model.dart';
import 'package:krishiyan/screen/dashboard/frm/frm_provider.dart';
import '../../../mvc/controller/farmer_dashboard_controller.dart';
import 'package:krishiyan/screen/dashboard/enquiry/enquiry_model.dart';
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

  Future<FrmInsight?>? _futureFrminSight;
  setStateNow() {
    if (mounted) {
      setState(() {});
    }
  }

  int selectedTopData = 0;

  List<cropsCategory> search_crops = [
    cropsCategory(
      name: "Total Farmer",
      id: "1",
      icon: 'assets/images/crops1.png',
    ),
    cropsCategory(
        name: "Total Farmer Land(in HA)",
        id: "2",
        icon: 'assets/images/crops2.png'),
    cropsCategory(
        name: "Expected Yield(in Qtl)",
        id: "3",
        icon: 'assets/images/crops1.png'),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool searchCropsFlag = false;

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
                          backgroundColor: selectedTopData == index
                              ? Colors.green
                              : Colors.white,
                          padding: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: selectedTopData == index
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
                              color: selectedTopData == index
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
            selectedTopData == 0
                ? firstTabData(context, setStateNow)
                : selectedTopData == 1
                    ? secondTabData(context, setStateNow)
                    : selectedTopData == 2
                        ? thirdTabData(context, setStateNow)
                        : selectedTopData == 3
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, right: 20.0, left: 20.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(18))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          children: [
                                            // select crops
                                            Text(
                                              buildTranslate(
                                                  "searchByCrops/Villages")!,
                                              softWrap: true,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontFamily:
                                                      'poppins-semibold'),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    color: Colors.white,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child:
                                                        DropdownButtonFormField2<
                                                            String>(
                                                      dropdownStyleData:
                                                          const DropdownStyleData(
                                                              maxHeight: 200),
                                                      hint: Text(buildTranslate(
                                                          "selectCrops")!),
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.black,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                      buttonStyleData:
                                                          const ButtonStyleData(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8),
                                                      ),
                                                      iconStyleData:
                                                          const IconStyleData(
                                                        icon: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.black45,
                                                        ),
                                                        iconSize: 24,
                                                      ),
                                                      menuItemStyleData:
                                                          const MenuItemStyleData(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                      ),
                                                      value: frmProvider!
                                                          .selectedCrop,
                                                      items: frmProvider!.crops
                                                          .map((String crop) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: crop,
                                                          child: Text(crop,
                                                              style: const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'poppins-regular')),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          frmProvider!
                                                                  .selectedCrop =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 80,
                                                  height: 40,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  child: Center(
                                                    child: Text(
                                                      buildTranslate("crops")!,
                                                      textAlign:
                                                          TextAlign.center,
                                                      softWrap: true,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily:
                                                              'poppins-regular'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(
                                              height: 10,
                                            ),

                                            // select villages
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    color: Colors.white,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child:
                                                        DropdownButtonFormField2<
                                                            String>(
                                                      dropdownStyleData:
                                                          const DropdownStyleData(
                                                              maxHeight: 200),
                                                      hint: Text(buildTranslate(
                                                          "selectVillages")!),
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.black,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                      buttonStyleData:
                                                          const ButtonStyleData(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8),
                                                      ),
                                                      iconStyleData:
                                                          const IconStyleData(
                                                        icon: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.black45,
                                                        ),
                                                        iconSize: 24,
                                                      ),
                                                      menuItemStyleData:
                                                          const MenuItemStyleData(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                      ),
                                                      value: frmProvider!
                                                          .selectedVillageName,
                                                      items: frmProvider!
                                                          .villageNameData!
                                                          .data!
                                                          .map((String crop) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: crop,
                                                          child: Text(crop,
                                                              style: const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'poppins-regular')),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          frmProvider!
                                                                  .selectedVillageName =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 80,
                                                  height: 40,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  child: Center(
                                                    child: Text(
                                                      buildTranslate(
                                                          "villages")!,
                                                      textAlign:
                                                          TextAlign.center,
                                                      softWrap: true,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily:
                                                              'poppins-regular'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(
                                              height: 20,
                                            ),

                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      onSearchPressed();
                                                      searchCropsFlag = true;
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    textStyle: const TextStyle(
                                                        fontSize: 18),
                                                    backgroundColor:
                                                        const Color(0xFF3FC041),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10), // <-- Radius
                                                    ),
                                                  ),
                                                  child: Text(
                                                    buildTranslate('SEARCH')!,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontFamily:
                                                            'poppins-medium'),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Visibility(
                                    visible: searchCropsFlag,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, right: 20.0, left: 20.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              FutureBuilder<FrmInsight?>(
                                                future: _futureFrminSight,
                                                builder: (context, snapshot) {
                                                  // Log the connection state and snapshot data
                                                  print(
                                                      'Connection State: ${snapshot.connectionState}');
                                                  print(
                                                      'Has data: ${snapshot.hasData}');
                                                  print(
                                                      'Error:: ${snapshot.error}');
                                                  print(
                                                      'Data: ${snapshot.data}');

                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator()); // Loading state
                                                  } else if (snapshot
                                                      .hasError) {
                                                    // Handle the error case
                                                    return Center(
                                                        child: Text(
                                                            'Error: ${snapshot.error}'));
                                                  } else if (!snapshot
                                                      .hasData) {
                                                    // Handle the case where there's no data
                                                    return Center(
                                                        child: Text(
                                                            'No data available.'));
                                                  } else {
                                                    FrmInsight? frminSight =
                                                        snapshot.data;
                                                    if (frminSight == null) {
                                                      return Center(
                                                          child: Text(
                                                              'No data available.'));
                                                    }
                                                    print(
                                                        'Has data: ${frminSight.data}');
                                                    return listWidget(
                                                        frminSight); // Your list display widget
                                                  }
                                                },
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            : selectedTopData == 4
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
                                                  selectedTopData = 3;
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
                                                    future: _futureFrminSight,
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
                                        future:
                                            _futureFrminSight, // The future that fetches FrmInsight data
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

  Future<FrmInsight?> fetchInsightsData() async {
    String? number = await AppGlobal.getStringPreference('contactNumber');
    var num = number ?? "1";

    if (frmProvider!.selectedCrop == null ||
        frmProvider!.selectedVillageName == null) {
      print('Please select both crop and village');
      return null;
    }

    final url =
        '${baseUrl}appFarmer/farmers/insight?dealerNumber=$num&village=${frmProvider!.selectedVillageName}&crop=${frmProvider!.selectedCrop}&sort=highToLow';

    try {
      final response = await getAPICall(apiUrl: url);
      if (response.statusCode == 200) {
        print('API Response: ${response.body}');
        return FrmInsight.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        var data = json.decode(response.body);
        setSnackbar(' ${data['message']}');
        return null;
      } else {
        setSnackbar('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void onSearchPressed() {
    // Validate if both crop and village are selected
    if (frmProvider!.selectedCrop != null &&
        frmProvider!.selectedVillageName != null) {
      setState(() {
        // Initialize the future here, which will trigger the API request
        _futureFrminSight = fetchInsightsData();
      });
    } else {
      // Show an error or prompt to select both crop and village
      print('Please select both crop and village');
    }
  }

  void _onSelectedTopDataTapped(int index) {
    setState(() {
      selectedTopData = index;
    });
    if (selectedTopData == 0) {
      if (mounted) {
        setState(() {
          frmProvider!.futureFarmerProfiles =
              FarmerDashboardController.fetchFarmerDashboard(
                  context, widget.villageName, widget.typeName);
        });
      }
    }
    print("Selected Top Page : $selectedTopData");
  }

  Widget listWidget(FrmInsight frminSight) {
    // Extracting required data from the API response
    int totalfarmers = frminSight.data.numberOfFarmers;
    int totalLandInAcres = frminSight.data.totalAreaInAcres;
    int expectedYield = 0; // Default value, can be updated if needed

    // You may need to fetch the expected yield for each crop if it's provided in the data
    // For now, we assume it's a generic value across the crops.
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: search_crops.length,
      itemBuilder: (_, index) {
        String displayText = '';

        // Condition to decide which value to display based on index
        if (index == 0) {
          // First index, show total number of farmers
          displayText =
              '$totalfarmers Farmers\n${search_crops[index].name ?? ""}';
        } else if (index == 1) {
          // Second index, show total land in acres
          displayText =
              '$totalLandInAcres Acres\n${search_crops[index].name ?? ""}';
        } else if (index == 2) {
          // Third index, show expected yield
          displayText =
              '$expectedYield Expected Yield\n${search_crops[index].name ?? ""}';
        } else {
          // For other items, show just the crop name
          displayText = search_crops[index].name ?? "";
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFd3d3d3),
                  )
                ],
                border: Border.all(color: const Color(0xFFd3d3d3), width: 1.0),
                borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                // Only set selectedTopData to 4 if the index is 0
                if (index == 0) {
                  setState(() {
                    selectedTopData = 4;
                  });
                  onSearchPressed();
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    search_crops[index].icon ?? "",
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        displayText, // Display the dynamic text based on the index
                        textAlign: TextAlign.center,
                        softWrap: true,
                        maxLines: 2,
                        style: const TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 15,
                            fontFamily: 'poppins-regular'),
                      ),
                    ),
                  ),
                  index == 0
                      ? Image.asset(
                          "assets/images/right_arrow.png",
                          width: 25,
                          height: 25,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        );
      },
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    );
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

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final List<String> sideMenu = ["Villages", "Types"];

  final List<String> typeData = [
    "Organic",
    "InOrganic",
  ];

  int? selectedVillageIndex;
  int? selectedTypeIndex;

  String villageName = "", typeName = "";

  int selectedMenuData = 0;
  setStateNow() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSelectedVillageIndex();
    _loadSelectedTypeIndex();
    frmProvider!.getVillageData(setStateNow, true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: 800,
              decoration: const BoxDecoration(color: Color(0xFFC7BDBD)),
              child: ListView.builder(
                itemCount: sideMenu.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _onSelectedMenuDataTapped(index);
                        });
                      },
                      child: Container(
                        color: selectedMenuData == index
                            ? Colors.white
                            : const Color(0xFFC7BDBD),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              sideMenu[index].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "poppins-regular",
                                color: selectedMenuData == index
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: selectedMenuData == 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  frmProvider!.drawerVillageNameData == null ||
                                          frmProvider!.drawerVillageNameData!
                                                  .data ==
                                              null
                                      ? Center(
                                          child: Text(buildTranslate(
                                              "noDataAvailable")!))
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: SizedBox(
                                            height: 50,
                                            child: ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: frmProvider!
                                                  .drawerVillageNameData!
                                                  .data!
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return index.isEven
                                                    ? CardWidget(
                                                        frmProvider!
                                                            .drawerVillageNameData!
                                                            .data![index],
                                                        index)
                                                    : Container();
                                              },
                                            ),
                                          ),
                                        ),
                                  frmProvider!.drawerVillageNameData == null ||
                                          frmProvider!.drawerVillageNameData!
                                                  .data ==
                                              null
                                      ? Center(
                                          child: Text(buildTranslate(
                                              "noDataAvailable")!))
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: SizedBox(
                                            height: 50,
                                            child: ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: frmProvider!
                                                  .drawerVillageNameData!
                                                  .data!
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return index.isOdd
                                                    ? CardWidget(
                                                        frmProvider!
                                                            .drawerVillageNameData!
                                                            .data![index],
                                                        index)
                                                    : Container();
                                              },
                                            ),
                                          ),
                                        )
                                ],
                              )
                            : selectedMenuData == 1
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: SizedBox(
                                          height: 50,
                                          child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: typeData.length,
                                            itemBuilder: (context, index) {
                                              return CardTypeWidget(
                                                  typeData[index], index);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                      )),
                ),
                Container(
                  color: Color(0xFFe7e7e7),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 15.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  var route = ModalRoute.of(context);
                                  if (route != null) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                FRM(
                                                    aapbarVisibility: true,
                                                    villageName: villageName,
                                                    typeName: typeName)));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(10),
                                  textStyle: const TextStyle(fontSize: 15),
                                  backgroundColor: const Color(0xFFffffff),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10), // <-- Radius
                                  ),
                                ),
                                child: const Text(
                                  'Apply',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'poppins-medium',
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 15.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => const MyHomePage()),
                                  // );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(10),
                                  textStyle: const TextStyle(fontSize: 15),
                                  backgroundColor: const Color(0xFFffffff),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10), // <-- Radius
                                  ),
                                ),
                                child: const Text(
                                  'Save All',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'poppins-medium',
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget CardWidget(String villageName, int index) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        print("villageName : $villageName");
        _onSelectedVillageDataTapped(index, villageName);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: selectedVillageIndex == index ? Colors.green : Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(5),
        )),
        elevation: 1,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Text(villageName,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "poppins-regular",
                  color: selectedVillageIndex == index
                      ? Colors.white
                      : Colors.black,
                )),
          ),
        ),
      ),
    );
  }

  Widget CardTypeWidget(String typeName, int index) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        print("TypeName : $typeName");
        _onSelectedTypeDataTapped(index, typeName);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: selectedTypeIndex == index ? Colors.green : Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(5),
        )),
        elevation: 1,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Text(typeName,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "poppins-regular",
                  color:
                      selectedTypeIndex == index ? Colors.white : Colors.black,
                )),
          ),
        ),
      ),
    );
  }

  void _loadSelectedVillageIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedVillageIndex = prefs.getInt('selectedVillageIndex') ?? 0;
    });
  }

  void _loadSelectedTypeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTypeIndex = prefs.getInt('selectedTypeIndex') ?? 0;
    });
  }

  Future<void> _onSelectedVillageDataTapped(int index, String village) async {
    setState(() {
      selectedVillageIndex = index;
      villageName = village;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedVillageIndex', index);
    // print("Selected Village Page : $selectedVillageData");
  }

  Future<void> _onSelectedTypeDataTapped(int index, String type) async {
    setState(() {
      selectedTypeIndex = index;
      typeName = type;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedTypeIndex', index);
    // print("Selected Type Page : $selectedTypeData");
  }

  void _onSelectedMenuDataTapped(int index) {
    setState(() {
      selectedMenuData = index;
    });
    // print("Selected Menu Page : $selectedMenuData");
  }
}
