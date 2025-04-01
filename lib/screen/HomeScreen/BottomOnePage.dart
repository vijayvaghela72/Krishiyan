import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:krishiyan/mvc/model/GetMandiPriceData.dart';
import 'package:krishiyan/mvc/model/MarketInsight.dart';
import 'package:krishiyan/screen/HomeScreen/PriceHistoryPage.dart';
import 'package:krishiyan/utils/AppGlobal.dart';
import 'package:krishiyan/utils/Constants.dart';
import '../../helper/AlertHelper.dart';
import '../../helper/SharedPref.dart';
import '../../localization/AppLocalizations.dart';
import '../../mvc/controller/homeDashboardController.dart';
import '../../mvc/model/DailyNewsDetails.dart';
import '../../mvc/model/MandiPriceCommodityData.dart';
import '../../mvc/model/MandiPriceDistrictData.dart';
import '../../mvc/model/MandiPriceStateData.dart';
import '../Enquiry/BottomCenterEnquiryPage.dart';
import '../CropLibrary/BottomThreePage.dart';
import '../FRM/BottomTwoPage.dart';
import '../DailyMarket/DetailNewsPage.dart';
import 'HomePage.dart';
import '../AccountSettings/ProfilePage.dart';
import '../Language/SelectLanguagePage.dart';
import 'package:intl/intl.dart'; // Required for date formatting

class BottomOnePage extends StatefulWidget {
  bool aapbarVisibility;

  BottomOnePage({super.key, required this.aapbarVisibility});

  @override
  State<BottomOnePage> createState() => _BottomOnePageState();
}

class _BottomOnePageState extends State<BottomOnePage>
    with TickerProviderStateMixin {
  final List<String> topData = [
    buildTranslate("dailyMarket")!,
    buildTranslate("mandiPrice")!,
    buildTranslate("marketInsight")!
  ];

  final imageSliders = [
    Image.asset("assets/images/home_banner.png"),
    Image.asset("assets/images/home_banner.png")
  ];

  // late AnimationController _fabAnimationController;
  // late AnimationController _borderRadiusAnimationController;
  // late Animation<double> fabAnimation;
  // late Animation<double> borderRadiusAnimation;
  // late CurvedAnimation fabCurve;
  // late CurvedAnimation borderRadiusCurve;
  // late AnimationController _hideBottomBarAnimationController;
  var _bottomNavIndex = 0; //default index of a first screen
  int currentIndex = 0;
  int selectedTopData = 0;

  String? selectedStateItemValue;
  MandiPriceStateData? stateItems;
  MandiPriceStateData? stateMarketItems;
  String? selectedMarketStateItemValue;

  MandiPriceDistrictData? districtItems;
  MandiPriceDistrictData? districtMarketItems;
  String? selectedDistrictItemValue;
  String? selectedMarketDistrictItemValue;

  MandiPriceCommodityData? commodityItems;
  MandiPriceCommodityData? commodityMarketItems;
  String selectedCommodityItemValue = "";
  String selectedMarketCommodityItemValue = "";

  List<bottomCategory> iconList = [
    bottomCategory(
        name: buildTranslate("home")!,
        id: "1",
        icon: 'assets/images/bottom1.png'),
    bottomCategory(
        name: buildTranslate("frm")!,
        id: "2",
        icon: 'assets/images/bottom2.png'),
    bottomCategory(
        name: buildTranslate("crop")!,
        id: "3",
        icon: 'assets/images/bottom3.png'),
    bottomCategory(
        name: buildTranslate("profile")!,
        id: "4",
        icon: 'assets/images/bottom4.png'),
  ];

  List<bottomCategory> iconList2 = [
    bottomCategory(
        name: buildTranslate("home")!,
        id: "1",
        icon: 'assets/images/bottom1.png'),
    bottomCategory(
        name: buildTranslate("profile")!,
        id: "2",
        icon: 'assets/images/bottom4.png'),
  ];

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  String dateOfFromValue = "", dateOfToValue = "";

  final List<String> sortItems = [
    buildTranslate('lowToHighPrice')!,
    buildTranslate('highToLowPrice')!,
  ];
  String selectedSortItemsValue = "";
  late Future<List<NewsData>> futureHomeNewsData;
  String typeOfOrganizationData = "";

  bool _isClickAllowed = true; // Flag to prevent double-clicks
  DateTime? selectedDate;

  Future<List<MandiPriceData>>? futureMandiPrice;
  Future<List<MarketInsight>>? futureMarketInsight;

  @override
  void initState() {
    super.initState();

    // _fabAnimationController = AnimationController(
    //   duration: const Duration(milliseconds: 500),
    //   vsync: this,
    // );
    // _borderRadiusAnimationController = AnimationController(
    //   duration: const Duration(milliseconds: 500),
    //   vsync: this,
    // );
    // fabCurve = CurvedAnimation(
    //   parent: _fabAnimationController,
    //   curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    // );
    // borderRadiusCurve = CurvedAnimation(
    //   parent: _borderRadiusAnimationController,
    //   curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    // );
    //
    // fabAnimation = Tween<double>(begin: 1, end: 1).animate(fabCurve);
    // borderRadiusAnimation = Tween<double>(begin: 1, end: 1).animate(
    //   borderRadiusCurve,
    // );
    //
    // _hideBottomBarAnimationController = AnimationController(
    //   duration: const Duration(milliseconds: 200),
    //   vsync: this,
    // );
    //
    // Future.delayed(
    //   const Duration(seconds: 1),
    //       () => _fabAnimationController.forward(),
    // );
    // Future.delayed(
    //   const Duration(seconds: 1),
    //       () => _borderRadiusAnimationController.forward(),
    // );

    futureHomeNewsData = HomeDashboardController.getNewsDetails();
    getPrefValue();
    _fetchStateData();
    _fetchMarketStateData();
  }

  Future<void> getPrefValue() async {
    typeOfOrganizationData = await SharedPref.readPreferenceValue(
        typeOfOrganization, PrefEnum.STRING);
    print("BottomOnePage TypeOfOrganizationData : $typeOfOrganizationData");
    setState(() {
      typeOfOrganizationData = typeOfOrganizationData;
    });
  }

  Future<void> _fetchStateData() async {
    try {
      // Replace with your actual API endpoint
      var response = await Dio().get(MANDI_PRICE_STATE);

      if (response.statusCode == 200) {
        print("fetchStateData response : $response");
        setState(() {
          stateItems = MandiPriceStateData.fromJson(response.data);
        });
      } else {
        throw Exception('Failed to load state');
      }
    } catch (e) {
      print('HomePage Mandi Price : Error fetching state data: $e');
    }
  }

  Future<void> _fetchMarketStateData() async {
    try {
      // Replace with your actual API endpoint
      var response = await Dio().get(MANDI_PRICE_STATE);

      if (response.statusCode == 200) {
        print("fetchStateData response : $response");
        setState(() {
          stateMarketItems = MandiPriceStateData.fromJson(response.data);
        });
      } else {
        throw Exception('Failed to load state');
      }
    } catch (e) {
      print('HomePage Mandi Price : Error fetching state data: $e');
    }
  }

  String convertToDirectImageUrl(String fileUrl) {
    // Extract the file ID from the Google Drive URL
    RegExp regExp = RegExp(r"file/d/([a-zA-Z0-9-_]+)");
    Match? match = regExp.firstMatch(fileUrl);

    if (match != null) {
      String fileId = match.group(1)!;
      return "https://drive.google.com/uc?id=$fileId"; // Construct the direct image URL
    }
    return fileUrl; // Return the original URL if it doesn't match the expected format
  }

  Future<void> _fetchDistrictData() async {
    try {
      // Replace with your actual API endpoint
      var response = await Dio().get("${baseUrlEnd}"
          "api/mandi/filter?stateName=$selectedStateItemValue");

      if (response.statusCode == 200) {
        print("fetchDistrictData response : $response");
        setState(() {
          districtItems = MandiPriceDistrictData.fromJson(response.data);
        });
      } else {
        throw Exception('Failed to load state');
      }
    } catch (e) {
      print('HomePage Mandi Price : Error fetching state data: $e');
    }
  }

  Future<void> _fetchMarketDistrictData() async {
    try {
      // Replace with your actual API endpoint
      var response = await Dio().get("${baseUrlEnd}"
          "api/mandi/filter?stateName=$selectedMarketStateItemValue");

      if (response.statusCode == 200) {
        print("fetchDistrictData response : $response");
        setState(() {
          districtMarketItems = MandiPriceDistrictData.fromJson(response.data);
        });
      } else {
        throw Exception('Failed to load state');
      }
    } catch (e) {
      print('HomePage Mandi Price : Error fetching state data: $e');
    }
  }

  Future<void> _fetchCommodityData() async {
    try {
      // Replace with your actual API endpoint
      var response = await Dio().get("${baseUrlEnd}"
          "api/mandi/filter?stateName=$selectedStateItemValue&districtName=$selectedDistrictItemValue");

      if (response.statusCode == 200) {
        print("fetchCommodityData response : $response");
        setState(() {
          commodityItems = MandiPriceCommodityData.fromJson(response.data);
        });
      } else {
        throw Exception('Failed to load state');
      }
    } catch (e) {
      print('HomePage Mandi Price : Error fetching state data: $e');
    }
  }

  Future<void> _fetchMarketCommodityData() async {
    try {
      // Replace with your actual API endpoint
      var response = await Dio().get("${baseUrlEnd}"
          "api/mandi/filter?stateName=$selectedMarketStateItemValue&districtName=$selectedMarketDistrictItemValue");

      if (response.statusCode == 200) {
        print("fetchCommodityData response : $response");
        setState(() {
          commodityMarketItems =
              MandiPriceCommodityData.fromJson(response.data);
        });
      } else {
        throw Exception('Failed to load state');
      }
    } catch (e) {
      print('HomePage Mandi Price : Error fetching state data: $e');
    }
  }

  // @override
  // void dispose() {
  //   _fabAnimationController.dispose(); // Dispose the controller
  //   _borderRadiusAnimationController.dispose(); // Dispose the controller
  //   _hideBottomBarAnimationController.dispose(); // Dispose the controller
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // Check if stateItems or stateItems.data is null
    if (stateItems == null || stateItems!.data == null) {
      // Show a loading indicator or placeholder if stateItems is null
      return Center(
        child:
            CircularProgressIndicator(), // Or any other widget you'd like to show while loading
      );
    }

    // Ensure the list has unique items
    List<String> uniqueStateItems = stateItems!.data!.toSet().toList();
    List<String> uniqueMarketStateItems =
        stateMarketItems!.data!.toSet().toList();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      appBar: widget.aapbarVisibility
          ? AppBar(
              automaticallyImplyLeading: false,
              title: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectLanguagePage()))
                      .then((value) {
                    setState(() {
                      // refresh state
                      MyLocalizations.load(Locale(localLang, ''));
                      print("BottomOnePage Lang : $localLang");
                    });
                  });
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
                      padding: const EdgeInsets.only(right: 5.0, top: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/language.png',
                            width: 35,
                            height: 35,
                          ),
                          // const Text(
                          //   "Select Language",
                          //   style: TextStyle(color: Colors.black, fontFamily: 'poppins-semibold', fontSize: 15),
                          // ),
                          // const SizedBox(width: 10,),
                          // Image.asset(
                          //   'assets/images/appbar_down.png',
                          //   // color: Colors.white,
                          // ),
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
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20.0),
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
                          padding: const EdgeInsets.only(left: 10.0),
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
                                  Radius.circular(12),
                                )),
                            label: Text(topData[index].toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "poppins-regular",
                                  color: selectedTopData == index
                                      ? Colors.white
                                      : Colors.black,
                                )),
                          )),
                    );
                  },
                ),
              ),
            ),
            selectedTopData == 0
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(
                        child: DotsIndicator(
                          dotsCount: imageSliders.length,
                          position: currentIndex.toInt(),
                        ),
                      ),
                      FutureBuilder<List<NewsData>>(
                        future: futureHomeNewsData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final List<NewsData> news = snapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFFC4C4C4)
                                        .withOpacity(0.4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: 10.0,
                                          bottom: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            buildTranslate("latestNews")!,
                                            softWrap: true,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'poppins-medium'),
                                          )),
                                          const VerticalDivider(width: 1.0),
                                          // Expanded(
                                          //     child: Align(
                                          //       alignment: Alignment.centerRight,
                                          //       child: Text(
                                          //         buildTranslate("showMore")!,
                                          //         softWrap: true,
                                          //         style: const TextStyle(
                                          //             color: Colors.grey,
                                          //             fontSize: 15,
                                          //             fontFamily: 'poppins-regular'),
                                          //       ),
                                          //     )),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: news.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets
                                          .zero, // This removes the default padding
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        final newsData = news[index];
                                        // Truncate the title and add "Read more" link if it's too long
                                        String truncatedTitle =
                                            newsData.title ?? '';
                                        bool isLongTitle =
                                            truncatedTitle.length >
                                                50; // Truncate at 50 characters
                                        if (isLongTitle) {
                                          truncatedTitle =
                                              truncatedTitle.substring(0, 50) +
                                                  '...';
                                        }

                                        // Truncate the description and add "Read more" link if it's too long
                                        String truncatedDescription =
                                            newsData.description ?? '';
                                        bool isLongDescription =
                                            truncatedDescription.length > 60;
                                        if (isLongDescription) {
                                          truncatedDescription =
                                              truncatedDescription.substring(
                                                      0, 60) +
                                                  '.....';
                                        }
                                        return InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => DetailNewsPage(
                                                      title: newsData.title,
                                                      description:
                                                          newsData.description,
                                                      imageLink:
                                                          convertToDirectImageUrl(
                                                              newsData.imageURL
                                                                  .toString()))),
                                            );
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Title with truncation and "Read more" link
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 20.0),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "poppins-medium",
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        truncatedTitle),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 20.0,
                                                                  right: 10.0),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontFamily:
                                                                    "poppins-regular",
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        truncatedDescription),
                                                                if (isLongDescription)
                                                                  TextSpan(
                                                                    text:
                                                                        " Read more",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .green
                                                                          .shade300,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    recognizer:
                                                                        TapGestureRecognizer()
                                                                          ..onTap =
                                                                              () {
                                                                            // Navigate to the detail page with full description
                                                                            Navigator.of(context).push(
                                                                              MaterialPageRoute(
                                                                                builder: (context) => DetailNewsPage(
                                                                                  title: newsData.title,
                                                                                  description: newsData.description,
                                                                                  imageLink: newsData.imageURL,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      // child: Image.asset(
                                                      //   'assets/images/homeItem.png',
                                                      //   width: 50,
                                                      //   height: 50,
                                                      // ),
                                                      child: Container(
                                                        width:
                                                            50, // Set the width of the container
                                                        height:
                                                            100, // Set the height of the container
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  12), // Set border radius for rounded corners
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  12), // Apply the same border radius here
                                                          child: Image.network(
                                                            convertToDirectImageUrl(
                                                                newsData
                                                                    .imageURL
                                                                    .toString()), // Use the converted URL
                                                            width: double
                                                                .infinity, // Ensure the image takes up the entire width
                                                            height: double
                                                                .infinity, // Ensure the image takes up the entire height
                                                            fit: BoxFit
                                                                .cover, // Makes the image cover the container, cropping if needed
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child; // When image is fully loaded, show it
                                                              } else {
                                                                return Center(
                                                                    child:
                                                                        CircularProgressIndicator()); // Show loading indicator while image loads
                                                              }
                                                            },
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return Column(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .error,
                                                                      color: Colors
                                                                          .red),
                                                                  Text(
                                                                      'Image not found',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red)),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20.0, right: 20.0),
                                                child: Text(
                                                  AppGlobal
                                                      .convertToCustomDateFormat(
                                                          newsData.createdAt
                                                              .toString()),
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontFamily:
                                                          'poppins-medium'),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20.0, right: 20.0),
                                                child: Divider(
                                                  color: Colors.black,
                                                  thickness: 2,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Center(
                                child:
                                    Text(buildTranslate("noDataAvailable")!));
                          }
                        },
                      ),
                      SizedBox(
                        height: 80,
                      ),
                    ],
                  )
                : selectedTopData == 1
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, right: 20.0, left: 20.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // select state
                                    Text(
                                      buildTranslate("selectState")!,
                                      softWrap: true,
                                      style: const TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize: 13,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    stateItems == null ||
                                            stateItems!.data == null
                                        ? Center(
                                            child: Text(buildTranslate(
                                                "noDataAvailable")!))
                                        : Container(
                                            color: Colors.white,
                                            child: DropdownButtonFormField2<
                                                String>(
                                              isExpanded: true,
                                              dropdownStyleData:
                                                  const DropdownStyleData(
                                                      maxHeight: 200),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                // Add more decoration..
                                              ),
                                              hint: Text(
                                                buildTranslate("selectState")!,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontFamily:
                                                        "poppins-regular"),
                                              ),
                                              items: uniqueStateItems
                                                  .map((String crop) {
                                                return DropdownMenuItem<String>(
                                                  value: crop,
                                                  child: Text(crop,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'poppins-regular')),
                                                );
                                              }).toList(),
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Please select type of state.';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedStateItemValue =
                                                      value;
                                                });
                                                if (selectedStateItemValue !=
                                                    null) {
                                                  print(
                                                      "SelectedStateItemValue : $selectedStateItemValue");
                                                  _fetchDistrictData();
                                                }
                                              },
                                              onSaved: (value) {
                                                selectedStateItemValue =
                                                    value.toString();
                                              },
                                              buttonStyleData:
                                                  const ButtonStyleData(
                                                padding:
                                                    EdgeInsets.only(right: 8),
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
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    // select district
                                    Text(
                                      buildTranslate("selectDistrict")!,
                                      softWrap: true,
                                      style: const TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize: 13,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    districtItems == null ||
                                            districtItems!.data == null
                                        ? Container(
                                            color: Colors.white,
                                            child: DropdownButtonFormField2<
                                                String>(
                                              isExpanded: true,
                                              dropdownStyleData:
                                                  const DropdownStyleData(
                                                      maxHeight: 200),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                // Add more decoration..
                                              ),
                                              hint: Text(
                                                buildTranslate(
                                                    "selectDistrict")!,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontFamily:
                                                        "poppins-regular"),
                                              ),
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Please select type of district.';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {},
                                              onSaved: (value) {},
                                              buttonStyleData:
                                                  const ButtonStyleData(
                                                padding:
                                                    EdgeInsets.only(right: 8),
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
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                              ),
                                              items: [],
                                            ),
                                          )
                                        : Container(
                                            color: Colors.white,
                                            child: DropdownButtonFormField2<
                                                String>(
                                              isExpanded: true,
                                              dropdownStyleData:
                                                  const DropdownStyleData(
                                                      maxHeight: 200),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                // Add more decoration..
                                              ),
                                              hint: Text(
                                                buildTranslate(
                                                    "selectDistrict")!,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontFamily:
                                                        "poppins-regular"),
                                              ),
                                              items: districtItems!.data!
                                                  .map((String crop) {
                                                return DropdownMenuItem<String>(
                                                  value: crop,
                                                  child: Text(crop,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'poppins-regular')),
                                                );
                                              }).toList(),
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Please select type of district.';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedDistrictItemValue =
                                                      value;
                                                });
                                                print(
                                                    "selectedDistrictItemValue : $selectedDistrictItemValue");
                                                _fetchCommodityData();
                                              },
                                              onSaved: (value) {
                                                selectedDistrictItemValue =
                                                    value.toString();
                                              },
                                              buttonStyleData:
                                                  const ButtonStyleData(
                                                padding:
                                                    EdgeInsets.only(right: 8),
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
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    // select commodity
                                    Text(
                                      buildTranslate("selectCommodity")!,
                                      softWrap: true,
                                      style: const TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize: 13,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    commodityItems == null ||
                                            commodityItems!.data == null
                                        ? Container(
                                            color: Colors.white,
                                            child: DropdownButtonFormField2<
                                                String>(
                                              isExpanded: true,
                                              dropdownStyleData:
                                                  const DropdownStyleData(
                                                      maxHeight: 200),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                // Add more decoration..
                                              ),
                                              hint: Text(
                                                buildTranslate(
                                                    "selectCommodity")!,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontFamily:
                                                        "poppins-regular"),
                                              ),
                                              items: [],
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Please select type of district.';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {},
                                              onSaved: (value) {},
                                              buttonStyleData:
                                                  const ButtonStyleData(
                                                padding:
                                                    EdgeInsets.only(right: 8),
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
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            color: Colors.white,
                                            child: DropdownButtonFormField2<
                                                String>(
                                              isExpanded: true,
                                              dropdownStyleData:
                                                  const DropdownStyleData(
                                                      maxHeight: 200),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                // Add more decoration..
                                              ),
                                              hint: Text(
                                                buildTranslate(
                                                    "selectCommodity")!,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontFamily:
                                                        "poppins-regular"),
                                              ),
                                              items: commodityItems!.data!
                                                  .map((String crop) {
                                                return DropdownMenuItem<String>(
                                                  value: crop,
                                                  child: Text(crop,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'poppins-regular')),
                                                );
                                              }).toList(),
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Please select type of district.';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedCommodityItemValue =
                                                      value!;
                                                });
                                                print(
                                                    "selectedCommodityItemValue : $selectedCommodityItemValue");
                                              },
                                              onSaved: (value) {
                                                selectedCommodityItemValue =
                                                    value.toString();
                                              },
                                              buttonStyleData:
                                                  const ButtonStyleData(
                                                padding:
                                                    EdgeInsets.only(right: 8),
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
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    // Search By Date Range
                                    Text(
                                      buildTranslate("searchByDateRange")!,
                                      softWrap: true,
                                      style: const TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize: 13,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            color: Colors.white,
                                            alignment: Alignment.bottomCenter,
                                            child: GestureDetector(
                                              onTap: () {
                                                _selectFromDate(context);
                                              },
                                              child: AbsorbPointer(
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      suffixIcon: IconButton(
                                                        icon: const Icon(
                                                          Icons.calendar_month,
                                                          size: 20.0,
                                                          color: Colors.grey,
                                                        ),
                                                        onPressed: () {
                                                          // _selectFromDate(context);
                                                        },
                                                      ),
                                                      alignLabelWithHint: true,
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      border:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.grey,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8.0)),
                                                      ),
                                                      hintText: buildTranslate(
                                                          "from"),
                                                      hintStyle: const TextStyle(
                                                          color:
                                                              Color(0xFF757575),
                                                          fontFamily:
                                                              "poppins-regular",
                                                          fontSize: 13.0),
                                                      focusedBorder:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.green,
                                                            width: 0.5),
                                                      )),
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? 'Please, fill this field.'
                                                      : null,
                                                  controller:
                                                      fromDateController,
                                                  readOnly: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const VerticalDivider(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Container(
                                            color: Colors.white,
                                            alignment: Alignment.bottomCenter,
                                            child: GestureDetector(
                                              onTap: () {
                                                _selectToDate(context);
                                              },
                                              child: AbsorbPointer(
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      suffixIcon: IconButton(
                                                        icon: const Icon(
                                                          Icons.calendar_month,
                                                          size: 20.0,
                                                          color: Colors.grey,
                                                        ),
                                                        onPressed: () {
                                                          // _selectToDate(context);
                                                        },
                                                      ),
                                                      alignLabelWithHint: true,
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      border:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.grey,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8.0)),
                                                      ),
                                                      hintText:
                                                          buildTranslate("to"),
                                                      hintStyle: const TextStyle(
                                                          color:
                                                              Color(0xFF757575),
                                                          fontFamily:
                                                              "poppins-regular",
                                                          fontSize: 13.0),
                                                      focusedBorder:
                                                          const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.green,
                                                            width: 0.5),
                                                      )),
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? 'Please, fill this field.'
                                                      : null,
                                                  controller: toDateController,
                                                  readOnly: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            getValue();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.all(12),
                                            textStyle:
                                                const TextStyle(fontSize: 18),
                                            backgroundColor:
                                                const Color(0xFF3FC041),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12), // <-- Radius
                                            ),
                                          ),
                                          child: Text(
                                            buildTranslate('SUBMIT')!,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'poppins-regular'),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  width: 130,
                                  height: 40,
                                  color: Colors.white,
                                  child: DropdownButtonFormField2<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF666666),
                                          width: 1.0,
                                        ),
                                      ),
                                      // Add more decoration..
                                    ),
                                    hint: Text(
                                      buildTranslate('sortBy')!,
                                      style: const TextStyle(
                                          fontSize: 9,
                                          color: Color(0xFF666666),
                                          fontFamily: "poppins-regular"),
                                    ),
                                    // Bind the selected value to the widget
                                    value: selectedSortItemsValue.isNotEmpty
                                        ? selectedSortItemsValue
                                        : null,
                                    items: sortItems
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                    fontSize: 9,
                                                    color: Color(0xFF666666)),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      //Do something when selected item is changed.
                                      setState(() {
                                        selectedSortItemsValue =
                                            value.toString();
                                      });
                                      print(
                                          "Selected value: $selectedSortItemsValue");
                                    },
                                    onSaved: (value) {
                                      selectedSortItemsValue = value.toString();
                                      print(selectedSortItemsValue);
                                    },
                                    // customButton: Align(
                                    //     alignment: Alignment.centerRight,
                                    //     child: Image.asset('assets/images/sortBy.png', height: 20, width: 20,)),
                                    buttonStyleData: const ButtonStyleData(
                                      padding: EdgeInsets.only(right: 10),
                                    ),
                                    iconStyleData: const IconStyleData(
                                      icon: ImageIcon(AssetImage(
                                          'assets/images/sortBy.png')),
                                      iconSize: 18,
                                      iconEnabledColor: Colors.black,
                                    ),
                                    // iconStyleData: IconStyleData(
                                    //   openMenuIcon: Image.asset('assets/images/sortBy.png', height: 20, width: 20,),
                                    //   // icon: Icon(
                                    //   //   Icons.arrow_drop_down,
                                    //   //   color: Colors.black45,
                                    //   // ),
                                    //   iconSize: 0,
                                    // ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/location.png",
                                  width: 15,
                                  height: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  selectedStateItemValue?.toString() ?? '',
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Color(0xFF808080),
                                      fontSize: 11,
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ],
                            ),
                          ),
                          futureMandiPrice.toString().isEmpty
                              ? Center(
                                  child:
                                      Text(buildTranslate("noDataAvailable")!))
                              : FutureBuilder<List<MandiPriceData>>(
                                  future: futureMandiPrice,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      // return Center(child: Text('Error: ${snapshot.error}'));
                                      return Center(
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 40.0),
                                              child: Text(
                                                buildTranslate(
                                                    "noDataAvailable")!,
                                              )));
                                    } else if (snapshot.hasData) {
                                      final List<MandiPriceData> mandiPrice =
                                          snapshot.data!;
                                      // Sort the data based on selected criteria
                                      // Print the unsorted data for debugging
                                      print(
                                          "Before sorting: ${mandiPrice.map((e) => e.modalPrice)}");
                                      print(selectedSortItemsValue.trim());

                                      if (selectedSortItemsValue.trim() ==
                                          'Low To High Price') {
                                        print(selectedSortItemsValue);
                                        mandiPrice.sort((a, b) {
                                          final priceA =
                                              a.modalPrice ?? double.infinity;
                                          final priceB =
                                              b.modalPrice ?? double.infinity;
                                          print('aaaaaaaaaaaa');
                                          print(priceA.compareTo(priceB));
                                          return priceA.compareTo(priceB);
                                        });
                                      } else {
                                        mandiPrice.sort((a, b) {
                                          final priceA =
                                              a.modalPrice ?? -double.infinity;
                                          final priceB =
                                              b.modalPrice ?? -double.infinity;
                                          return priceB.compareTo(priceA);
                                        });
                                      }
                                      // Print the sorted data for debugging
                                      print(
                                          "After sorting: ${mandiPrice.map((e) => e.modalPrice)}");
                                      return ListView.builder(
                                        itemCount: mandiPrice.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10.0,
                                              right: 20.0,
                                              left: 20.0,
                                            ),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(18))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0,
                                                            right: 15.0,
                                                            top: 15.0),
                                                    child: Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/location.png",
                                                              width: 15,
                                                              height: 15,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              mandiPrice[index]
                                                                      .market ??
                                                                  "",
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF959595),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'poppins-semibold'),
                                                            ),
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Image.asset(
                                                                "assets/images/calendar.png",
                                                                width: 15,
                                                                height: 15,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                mandiPrice[index]
                                                                        .arrivalDate ??
                                                                    "",
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF959595),
                                                                    fontSize:
                                                                        11,
                                                                    fontFamily:
                                                                        'poppins-semibold'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 15.0,
                                                      right: 15.0,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/mandiBG.png",
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          mandiPrice[index]
                                                                  .commodity ??
                                                              "",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF808080),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'poppins-semibold'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  const Center(
                                                    child: Text(
                                                      "Price Per Quintal",
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF808080),
                                                          fontSize: 17,
                                                          fontFamily:
                                                              'poppins-semibold'),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 50,
                                                    decoration: const BoxDecoration(
                                                        color:
                                                            Color(0xFF116B38),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10))),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Min ₹:",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'poppins-regular'),
                                                              ),
                                                              Text(
                                                                mandiPrice[index]
                                                                        .minPrice
                                                                        .toString() ??
                                                                    "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'poppins-regular'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Average ₹:",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'poppins-regular'),
                                                              ),
                                                              Text(
                                                                mandiPrice[index]
                                                                        .modalPrice
                                                                        .toString() ??
                                                                    "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'poppins-regular'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Max ₹:",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'poppins-regular'),
                                                              ),
                                                              Text(
                                                                mandiPrice[index]
                                                                        .maxPrice
                                                                        .toString() ??
                                                                    "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'poppins-regular'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // const SizedBox(
                                                  //   height: 20,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return Center(
                                          child: Padding(
                                        padding: EdgeInsets.only(bottom: 40.0),
                                        child: Text(
                                            buildTranslate("noDataAvailable")!),
                                      ));
                                    }
                                  },
                                ),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      )
                    : selectedTopData == 2
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // select state
                                        Text(
                                          buildTranslate("selectState")!,
                                          softWrap: true,
                                          style: const TextStyle(
                                              color: Color(0xFF666666),
                                              fontSize: 13,
                                              fontFamily: 'poppins-semibold'),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        stateMarketItems == null ||
                                                stateMarketItems!.data == null
                                            ? Center(
                                                child: Text(buildTranslate(
                                                    "noDataAvailable")!))
                                            : Container(
                                                color: Colors.white,
                                                child: DropdownButtonFormField2<
                                                    String>(
                                                  isExpanded: true,
                                                  dropdownStyleData:
                                                      const DropdownStyleData(
                                                          maxHeight: 200),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    // Add more decoration..
                                                  ),
                                                  hint: Text(
                                                    buildTranslate(
                                                        "selectState")!,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontFamily:
                                                            "poppins-regular"),
                                                  ),
                                                  items: uniqueMarketStateItems
                                                      .map((String crop1) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: crop1,
                                                      child: Text(crop1,
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'poppins-regular')),
                                                    );
                                                  }).toList(),
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Please select type of state.';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedMarketStateItemValue =
                                                          value;
                                                    });
                                                    if (selectedMarketStateItemValue !=
                                                        null) {
                                                      print(
                                                          "selectedMarketStateItemValue : $selectedMarketStateItemValue");
                                                      _fetchMarketDistrictData();
                                                    }
                                                  },
                                                  onSaved: (value) {
                                                    selectedMarketStateItemValue =
                                                        value.toString();
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding: EdgeInsets.only(
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                  ),
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 20,
                                        ),

                                        // select district
                                        Text(
                                          buildTranslate("selectDistrict")!,
                                          softWrap: true,
                                          style: const TextStyle(
                                              color: Color(0xFF666666),
                                              fontSize: 13,
                                              fontFamily: 'poppins-semibold'),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        districtMarketItems == null ||
                                                districtMarketItems!.data ==
                                                    null
                                            ? Container(
                                                color: Colors.white,
                                                child: DropdownButtonFormField2<
                                                    String>(
                                                  isExpanded: true,
                                                  dropdownStyleData:
                                                      const DropdownStyleData(
                                                          maxHeight: 200),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    // Add more decoration..
                                                  ),
                                                  hint: Text(
                                                    buildTranslate(
                                                        "selectDistrict")!,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontFamily:
                                                            "poppins-regular"),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Please select type of district.';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {},
                                                  onSaved: (value) {},
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding: EdgeInsets.only(
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                  ),
                                                  items: [],
                                                ),
                                              )
                                            : Container(
                                                color: Colors.white,
                                                child: DropdownButtonFormField2<
                                                    String>(
                                                  isExpanded: true,
                                                  dropdownStyleData:
                                                      const DropdownStyleData(
                                                          maxHeight: 200),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    // Add more decoration..
                                                  ),
                                                  hint: Text(
                                                    buildTranslate(
                                                        "selectDistrict")!,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontFamily:
                                                            "poppins-regular"),
                                                  ),
                                                  items: districtMarketItems!
                                                      .data!
                                                      .map((String crop) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: crop,
                                                      child: Text(crop,
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'poppins-regular')),
                                                    );
                                                  }).toList(),
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Please select type of district.';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedMarketDistrictItemValue =
                                                          value;
                                                    });
                                                    print(
                                                        "selectedMarketDistrictItemValue : $selectedMarketDistrictItemValue");
                                                    _fetchMarketCommodityData();
                                                  },
                                                  onSaved: (value) {
                                                    selectedMarketDistrictItemValue =
                                                        value.toString();
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding: EdgeInsets.only(
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                  ),
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 20,
                                        ),

                                        // select commodity
                                        Text(
                                          buildTranslate("selectCommodity")!,
                                          softWrap: true,
                                          style: const TextStyle(
                                              color: Color(0xFF666666),
                                              fontSize: 13,
                                              fontFamily: 'poppins-semibold'),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        commodityMarketItems == null ||
                                                commodityMarketItems!.data ==
                                                    null
                                            ? Container(
                                                color: Colors.white,
                                                child: DropdownButtonFormField2<
                                                    String>(
                                                  isExpanded: true,
                                                  dropdownStyleData:
                                                      const DropdownStyleData(
                                                          maxHeight: 200),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    // Add more decoration..
                                                  ),
                                                  hint: Text(
                                                    buildTranslate(
                                                        "selectCommodity")!,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontFamily:
                                                            "poppins-regular"),
                                                  ),
                                                  items: [],
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Please select type of district.';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {},
                                                  onSaved: (value) {},
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding: EdgeInsets.only(
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                color: Colors.white,
                                                child: DropdownButtonFormField2<
                                                    String>(
                                                  isExpanded: true,
                                                  dropdownStyleData:
                                                      const DropdownStyleData(
                                                          maxHeight: 200),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    // Add more decoration..
                                                  ),
                                                  hint: Text(
                                                    buildTranslate(
                                                        "selectCommodity")!,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontFamily:
                                                            "poppins-regular"),
                                                  ),
                                                  items: commodityMarketItems!
                                                      .data!
                                                      .map((String crop) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: crop,
                                                      child: Text(crop,
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'poppins-regular')),
                                                    );
                                                  }).toList(),
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Please select type of district.';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedMarketCommodityItemValue =
                                                          value!;
                                                    });
                                                    print(
                                                        "selectedMarketCommodityItemValue : $selectedMarketCommodityItemValue");
                                                  },
                                                  onSaved: (value) {
                                                    selectedMarketCommodityItemValue =
                                                        value.toString();
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding: EdgeInsets.only(
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                  ),
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 20,
                                        ),

                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                getMarketInsight();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.all(12),
                                                textStyle: const TextStyle(
                                                    fontSize: 18),
                                                backgroundColor:
                                                    const Color(0xFF3FC041),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // <-- Radius
                                                ),
                                              ),
                                              child: Text(
                                                buildTranslate('SUBMIT')!,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        'poppins-regular'),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              futureMarketInsight.toString().isEmpty
                                  ? Center(
                                      child: Text(
                                          buildTranslate("noDataAvailable")!))
                                  : FutureBuilder<List<MarketInsight>>(
                                      future: futureMarketInsight,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                          // return Center(child: Padding(
                                          //   padding: EdgeInsets.only(bottom: 40.0),
                                          //   child: Text(buildTranslate("noDataAvailable")!,
                                          // )));
                                        } else if (snapshot.hasData) {
                                          final List<MarketInsight>
                                              marketInsight = snapshot.data!;

                                          return ListView.builder(
                                            itemCount: marketInsight.length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10.0,
                                                  right: 20.0,
                                                  left: 20.0,
                                                ),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          18))),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 15.0,
                                                                right: 15.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  marketInsight[
                                                                              index]
                                                                          .state ??
                                                                      "Not Available",
                                                                  softWrap:
                                                                      true,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'poppins-semibold'),
                                                                ),
                                                                Container(
                                                                  width:
                                                                      80, // Set the specific width here
                                                                  child: Text(
                                                                    marketInsight[index]
                                                                            .market ??
                                                                        "",
                                                                    softWrap:
                                                                        true,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'poppins-semibold',
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Text(
                                                              marketInsight[
                                                                          index]
                                                                      .commodity ??
                                                                  "Not Available",
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'poppins-semibold'),
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  "Today",
                                                                  softWrap:
                                                                      true,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'poppins-semibold'),
                                                                ),
                                                                Text(
                                                                  marketInsight[
                                                                              index]
                                                                          .todaysPrice
                                                                          .toString() ??
                                                                      "",
                                                                  softWrap:
                                                                      true,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'poppins-semibold'),
                                                                ),
                                                                Text(
                                                                  marketInsight[
                                                                              index]
                                                                          .todaysPriceChange
                                                                          .toString() ??
                                                                      "",
                                                                  softWrap:
                                                                      true,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'poppins-semibold'),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  "Yesterday",
                                                                  softWrap:
                                                                      true,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'poppins-semibold'),
                                                                ),
                                                                Text(
                                                                  marketInsight[
                                                                              index]
                                                                          .yesterdaysPrice
                                                                          .toString() ??
                                                                      "",
                                                                  softWrap:
                                                                      true,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'poppins-semibold'),
                                                                ),
                                                                Text(
                                                                  marketInsight[
                                                                              index]
                                                                          .yesterdaysPriceChange
                                                                          .toString() ??
                                                                      "",
                                                                  softWrap:
                                                                      true,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'poppins-semibold'),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 15.0,
                                                                right: 15.0,
                                                                top: 15.0),
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PriceHistoryPage(
                                                                  commodityId:
                                                                      marketInsight[
                                                                              index]
                                                                          .primaryKey, // Pass the primary key here
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                const Color(
                                                                    0xFF959595), // Keep the text color the same
                                                            overlayColor: Colors
                                                                .transparent, // Remove the hover effect
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Image.asset(
                                                                "assets/images/right_arrow.png",
                                                                width: 10,
                                                                height: 10,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "View More",
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF959595),
                                                                    fontSize:
                                                                        11,
                                                                    fontFamily:
                                                                        'poppins-regular'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          return Center(
                                              child: Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 40.0),
                                            child: Text(buildTranslate(
                                                "noDataAvailable")!),
                                          ));
                                        }
                                      },
                                    ),
                              const SizedBox(
                                height: 60,
                              ),
                            ],
                          )
                        : Container(),
            Container(),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    // Show the date picker dialog
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate != null ? selectedDate : DateTime.now(),
      // Default date is the current date
      firstDate: DateTime(2000),
      // Earliest selectable date
      lastDate: DateTime(2101),
      // Latest selectable date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      print("pickedDate : $pickedDate");
      setState(() {
        // Format the selected date and display it in the TextFormField
        fromDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        dateOfFromValue = "${pickedDate}Z";

        // Validate To Date
        if (toDateController.text.isNotEmpty) {
          DateTime toDate =
              DateFormat('dd-MM-yyyy').parse(toDateController.text);
          if (pickedDate.isAfter(toDate)) {
            // Show error message using AlertHelper.showToast
            AlertHelper.showToast(
                'To Date cannot be earlier than From Date', context);

            toDateController.clear();
          }
        }
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    // Show the date picker dialog
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate != null ? selectedDate : DateTime.now(),
      // Default date is the current date
      firstDate: DateTime(2000),
      // Earliest selectable date
      lastDate: DateTime(2101),
      // Latest selectable date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      print("pickedDate : $pickedDate");
      setState(() {
        // Format the selected date and display it in the TextFormField
        toDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        dateOfToValue = "${pickedDate}Z";

        // Validate From Date
        if (fromDateController.text.isNotEmpty) {
          DateTime fromDate =
              DateFormat('dd-MM-yyyy').parse(fromDateController.text);
          if (pickedDate.isBefore(fromDate)) {
            // Show error message
            // Show error message using AlertHelper.showToast
            AlertHelper.showToast(
                'To Date cannot be earlier than From Date', context);

            fromDateController.clear();
          }
        }
      });
    }
  }

  void _onSelectedTopDataTapped(int index) {
    setState(() {
      selectedTopData = index;
    });
    print("Selected Top Page : $selectedTopData");
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigator.pop(context);
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => BottomOnePage(
                  aapbarVisibility: true,
                )));
      }
    } else if (index == 1) {
      // Navigator.pop(context);
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => BottomTwoPage(
                  aapbarVisibility: true,
                )));
      }
    } else if (index == 2) {
      // Navigator.pop(context);
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => BottomThreePage(
                  aapbarVisibility: true,
                )));
      }
    } else if (index == 3) {
      if (_isClickAllowed) {
        _isClickAllowed = false;
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        // Re-enable clicks after a short delay (e.g., 500ms)
        Timer(Duration(seconds: 1), () {
          _isClickAllowed = true;
        });
      }
    } else if (index == 4) {
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => BottomCenterEnquiryPage(
                  aapbarVisibility: true,
                )));
      }
    } else {
      setState(() {
        _bottomNavIndex = index;
      });
      print("One : bottomNavIndex : $_bottomNavIndex");
    }
  }

  void getValue() {
    if (selectedStateItemValue.toString().isNotEmpty &&
        selectedDistrictItemValue.toString().isNotEmpty &&
        selectedCommodityItemValue.toString().isNotEmpty &&
        dateOfFromValue.isNotEmpty &&
        dateOfToValue.isNotEmpty) {
      futureMandiPrice = HomeDashboardController.getMandiPriceDetails(
          selectedStateItemValue.toString(),
          selectedDistrictItemValue.toString(),
          selectedCommodityItemValue.toString(),
          dateOfFromValue,
          dateOfToValue);

      setState(() {
        futureMandiPrice = futureMandiPrice;
        print(futureMandiPrice);
      });
    } else {
      AlertHelper.showToast("Please enter details.", context);
    }
  }

  void getMarketInsight() {
    print("object");
    if (selectedMarketStateItemValue.toString().isNotEmpty &&
        selectedMarketDistrictItemValue.toString().isNotEmpty &&
        selectedMarketCommodityItemValue.toString().isNotEmpty) {
      futureMarketInsight = HomeDashboardController.getMarketInsightDetails(
          selectedMarketStateItemValue.toString(),
          selectedMarketDistrictItemValue.toString(),
          selectedMarketCommodityItemValue.toString());

      setState(() {
        futureMarketInsight = futureMarketInsight;
        print("DATA");
        print(futureMarketInsight);
      });
    } else {
      AlertHelper.showToast("Please enter details.", context);
    }
  }
}

class bottomCategory {
  String? name;
  String? icon;
  String? id;

  bottomCategory({
    required this.name,
    required this.icon,
    required this.id,
  });
}
