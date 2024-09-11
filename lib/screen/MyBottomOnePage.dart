import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:krishiyan/utils/AppGlobal.dart';
import 'package:krishiyan/utils/Constants.dart';
import '../helper/SharedPref.dart';
import '../localization/AppLocalizations.dart';
import '../mvc/controller/homeDashboardController.dart';
import '../mvc/model/DailyNewsDetails.dart';
import '../mvc/model/MandiPriceCommodityData.dart';
import '../mvc/model/MandiPriceDistrictData.dart';
import '../mvc/model/MandiPriceStateData.dart';
import 'MyBottomCenterEnquiryPage.dart';
import 'MyBottomThreePage.dart';
import 'MyBottomTwoPage.dart';
import 'MyDetailNewsPage.dart';
import 'MyHomePage.dart';
import 'MyProfilePage.dart';
import 'MySelectLanguagePage.dart';
import 'package:intl/intl.dart'; // Required for date formatting

class MyBottomOnePage extends StatefulWidget {
  bool aapbarVisibility;

  MyBottomOnePage({super.key, required this.aapbarVisibility});

  @override
  State<MyBottomOnePage> createState() => _MyBottomOnePageState();
}

class _MyBottomOnePageState extends State<MyBottomOnePage> with TickerProviderStateMixin {

  final List<String> topData = [
    buildTranslate("dailyMarket")!,
    buildTranslate("mandiPrice")!,
    buildTranslate("marketInsight")!
  ];

  final imageSliders = [
    Image.asset("assets/images/home_banner.png"),
    Image.asset("assets/images/home_banner.png")
  ];

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;
  var _bottomNavIndex = 0; //default index of a first screen
  int currentIndex = 0;
  int selectedTopData = 0;

  String? selectedStateItemValue;
  MandiPriceStateData? stateItems;

  MandiPriceDistrictData? districtItems;
  String? selectedDistrictItemValue;

  MandiPriceCommodityData? commodityItems;
  String selectedCommodityItemValue = "";

  List<bottomCategory> iconList = [
    bottomCategory(
        name: buildTranslate("home")!, id: "1", icon: 'assets/images/bottom1.png'),
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
        name: buildTranslate("home")!, id: "1", icon: 'assets/images/bottom1.png'),
    bottomCategory(
        name: buildTranslate("profile")!,
        id: "2",
        icon: 'assets/images/bottom4.png'),
  ];

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  String dateOfIncorporationNumberValue = "", dateOfToValue = "";

  final List<String> sortItems = [
    buildTranslate('lowToHighPrice')!,
    buildTranslate('highToLowPrice')!,
  ];
  String selectedSortItemsValue = "";
  late Future<List<NewsData>> futureHomeNewsData;
  String typeOfOrganizationData = "";

  bool _isClickAllowed = true; // Flag to prevent double-clicks
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 1, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 1, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(
      const Duration(seconds: 1),
          () => _fabAnimationController.forward(),
    );
    Future.delayed(
      const Duration(seconds: 1),
          () => _borderRadiusAnimationController.forward(),
    );

    futureHomeNewsData = HomeDashboardController.getNewsDetails();
    getPrefValue();
    _fetchStateData();
  }

  Future<void> getPrefValue() async {
    typeOfOrganizationData = await SharedPref.readPreferenceValue(typeOfOrganization, PrefEnum.STRING);
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
        setState(() {
          stateItems = MandiPriceStateData.fromJson(response.data);
        });
        print("StateItems : $stateItems");
      } else {
        throw Exception('Failed to load state');
      }
    } catch (e) {
      print('HomePage Mandi Price : Error fetching state data: $e');
    }
  }

  Future<void> _fetchDistrictData() async {
    try {
      // Replace with your actual API endpoint
      var response = await Dio().get("https://krishiyanback.vercel.app"
          "/api/mandi/filter?stateName=$selectedStateItemValue");

      if (response.statusCode == 200) {
        setState(() {
          districtItems = MandiPriceDistrictData.fromJson(response.data);
        });
        print("DistrictItems : $districtItems");
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
      var response = await Dio().get("https://krishiyanback.vercel.app"
          "/api/mandi/filter?stateName=$selectedStateItemValue&districtName=$selectedCommodityItemValue");

      if (response.statusCode == 200) {
        setState(() {
          commodityItems = MandiPriceCommodityData.fromJson(response.data);
        });
        print("DistrictItems : $districtItems");
      } else {
        throw Exception('Failed to load state');
      }
    } catch (e) {
      print('HomePage Mandi Price : Error fetching state data: $e');
    }
  }

  @override
  void dispose() {
    _fabAnimationController.dispose(); // Dispose the controller
    _borderRadiusAnimationController.dispose(); // Dispose the controller
    _hideBottomBarAnimationController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MySelectLanguagePage()))
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
                // Padding(
                //   padding: const EdgeInsets.only(right: 5.0, top: 20.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       const Text(
                //         "Select Language",
                //         style: TextStyle(
                //             color: Colors.black,
                //             fontFamily: 'poppins-semibold',
                //             fontSize: 15),
                //       ),
                //       const SizedBox(
                //         width: 10,
                //       ),
                //       Image.asset(
                //         'assets/images/appbar_down.png',
                //         // color: Colors.white,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        )
            : null,
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
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
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 150,
                            aspectRatio: 2.0,
                            viewportFraction: 0.9,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 4),
                            autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.linearToEaseOut,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.7,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: imageSliders,
                        ),
                        Center(
                          child: DotsIndicator(
                            dotsCount: imageSliders.length,
                            position: currentIndex.toInt(),
                          ),
                        ),
                        FutureBuilder<List<NewsData>>(
                        future: futureHomeNewsData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final List<NewsData> news = snapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFFC4C4C4).withOpacity(0.4),
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(10))
                                ),
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                          Expanded(
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  buildTranslate("showMore")!,
                                                  softWrap: true,
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15,
                                                      fontFamily: 'poppins-regular'),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: news.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero, // This removes the default padding
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        final newsData = news[index];
                                        return InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyDetailNewsPage(title : newsData.title,
                                                        description: newsData.description,
                                                        imageLink: newsData.imageURL)),
                                          );
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 20.0),
                                                        child: Text(
                                                          newsData.title.toString() ?? "",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors.black,
                                                              fontFamily:
                                                              "poppins-medium"),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                                                        child: Text(
                                                          newsData.description.toString() ?? "",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "poppins-regular",
                                                              color: Colors.grey),
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
                                                  child:
                                                  Image.network(newsData.imageURL.toString() ?? "",
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Text('Image not found'); // Custom message for 404
                                                      },
                                                      width: 50,
                                                      height: 50),
                                                )
                                              ],
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                              child:  Text(
                                                AppGlobal.convertToCustomDateFormat(newsData.createdAt.toString()),
                                                softWrap: true,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontFamily: 'poppins-medium'),
                                              ),
                                              // child: Row(
                                              //   mainAxisAlignment: MainAxisAlignment.start,
                                              //   crossAxisAlignment: CrossAxisAlignment.start,
                                              //   children: [
                                              //     // Text(
                                              //     //   "5min Read",
                                              //     //   softWrap: true,
                                              //     //   style: TextStyle(
                                              //     //       color:
                                              //     //       Colors.black,
                                              //     //       fontSize: 13,
                                              //     //       fontFamily:
                                              //     //       'poppins-medium'),
                                              //     // ),
                                              //     // SizedBox(width: 10.0),
                                              //     // Text(
                                              //     //   "17 hours ago",
                                              //     //   softWrap: true,
                                              //     //   style: TextStyle(
                                              //     //       color: Colors
                                              //     //           .black,
                                              //     //       fontSize: 13,
                                              //     //       fontFamily:
                                              //     //       'poppins-medium'),
                                              //     // ),
                                              //   ],
                                              // ),
                                            ),
                                            // Wrap(
                                            //   // mainAxisAlignment: MainAxisAlignment.center,
                                            //   // crossAxisAlignment: CrossAxisAlignment.center,
                                            //   children: <Widget>[
                                            //     Image.asset(
                                            //       'assets/images/homeItem.png',
                                            //       width: 100,
                                            //       height: 90,
                                            //     )
                                            //     // Icon(Icons.close),
                                            //   ],
                                            // ),
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
                                  ),],
                                ),
                              ),
                          );
                      }
                          else {
                            return const Center(child: Text('No data available'));
                      }
                    },
                  ), SizedBox(height: 80,),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color: const Color(0xFFC4C4C4).withOpacity(0.4),
                        //         borderRadius:
                        //             const BorderRadius.all(Radius.circular(10))),
                        //     child: LimitedBox(
                        //       maxHeight: 250,
                        //       child: Column(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.only(
                        //                 left: 20.0,
                        //                 right: 20.0,
                        //                 top: 8.0,
                        //                 bottom: 8.0),
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.start,
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: [
                        //                 Expanded(
                        //                     child: Text(
                        //                   buildTranslate("latestNews")!,
                        //                   softWrap: true,
                        //                   style: const TextStyle(
                        //                       color: Colors.black,
                        //                       fontSize: 20,
                        //                       fontFamily: 'poppins-medium'),
                        //                 )),
                        //                 const VerticalDivider(width: 1.0),
                        //                 Expanded(
                        //                     child: Align(
                        //                   alignment: Alignment.centerRight,
                        //                   child: Text(
                        //                     buildTranslate("showMore")!,
                        //                     softWrap: true,
                        //                     style: const TextStyle(
                        //                         color: Colors.grey,
                        //                         fontSize: 15,
                        //                         fontFamily: 'poppins-regular'),
                        //                   ),
                        //                 )),
                        //               ],
                        //             ),
                        //           ),
                        //           Flexible(
                        //             child: ListView.builder(
                        //               itemCount: 1,
                        //               physics:
                        //                   const NeverScrollableScrollPhysics(),
                        //               scrollDirection: Axis.vertical,
                        //               itemBuilder: (context, index) {
                        //                 return InkWell(
                        //                   highlightColor: Colors.transparent,
                        //                   splashColor: Colors.transparent,
                        //                   onTap: () {
                        //                     Navigator.of(context).push(
                        //                       MaterialPageRoute(
                        //                           builder: (context) =>
                        //                               const MyDetailNewsPage()),
                        //                     );
                        //                   },
                        //                   child: Column(
                        //                     mainAxisSize: MainAxisSize.min,
                        //                     children: [
                        //                       ListTile(
                        //                         contentPadding:
                        //                             EdgeInsets.all(10),
                        //                         title: const Row(
                        //                           children: [
                        //                             // Icon(Icons.location_on,size: 20,),
                        //                             SizedBox(
                        //                               width: 10,
                        //                             ),
                        //                             Flexible(
                        //                                 child: Text(
                        //                               "Lorem ipsum dolor sit amet.",
                        //                               style: TextStyle(
                        //                                   fontSize: 16,
                        //                                   fontWeight:
                        //                                       FontWeight.bold,
                        //                                   color: Colors.black,
                        //                                   fontFamily:
                        //                                       "poppins-medium"),
                        //                             )),
                        //                           ],
                        //                         ),
                        //                         isThreeLine: true,
                        //                         subtitle: const Column(
                        //                           children: [
                        //                             Row(
                        //                               children: [
                        //                                 SizedBox(
                        //                                   width: 10,
                        //                                 ),
                        //                                 Flexible(
                        //                                   child: Text(
                        //                                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        //                                     style: TextStyle(
                        //                                         fontSize: 13,
                        //                                         fontWeight:
                        //                                             FontWeight
                        //                                                 .w700,
                        //                                         fontFamily:
                        //                                             "poppins-regular",
                        //                                         color:
                        //                                             Colors.grey),
                        //                                   ),
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                             SizedBox(
                        //                               height: 5.0,
                        //                             ),
                        //                             Padding(
                        //                               padding: EdgeInsets.only(
                        //                                   left: 12.0),
                        //                               child: Row(
                        //                                 mainAxisAlignment:
                        //                                     MainAxisAlignment
                        //                                         .start,
                        //                                 crossAxisAlignment:
                        //                                     CrossAxisAlignment
                        //                                         .start,
                        //                                 children: [
                        //                                   Text(
                        //                                     "5min Read",
                        //                                     softWrap: true,
                        //                                     style: TextStyle(
                        //                                         color:
                        //                                             Colors.black,
                        //                                         fontSize: 13,
                        //                                         fontFamily:
                        //                                             'poppins-medium'),
                        //                                   ),
                        //                                   SizedBox(width: 10.0),
                        //                                   Flexible(
                        //                                     child: Align(
                        //                                       alignment: Alignment
                        //                                           .centerRight,
                        //                                       child: Text(
                        //                                         "17 hours ago",
                        //                                         softWrap: true,
                        //                                         style: TextStyle(
                        //                                             color: Colors
                        //                                                 .black,
                        //                                             fontSize: 13,
                        //                                             fontFamily:
                        //                                                 'poppins-medium'),
                        //                                       ),
                        //                                     ),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                         trailing: Wrap(
                        //                           // mainAxisAlignment: MainAxisAlignment.center,
                        //                           // crossAxisAlignment: CrossAxisAlignment.center,
                        //                           children: <Widget>[
                        //                             Image.asset(
                        //                               'assets/images/homeItem.png',
                        //                               width: 100,
                        //                               height: 90,
                        //                             )
                        //                             // Icon(Icons.close),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                       const Padding(
                        //                         padding: EdgeInsets.only(
                        //                             left: 20.0, right: 20.0),
                        //                         child: Divider(
                        //                           color: Colors.black,
                        //                           thickness: 2,
                        //                         ),
                        //                       )
                        //                     ],
                        //                   ),
                        //                 );
                        //               },
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                    ],
                  )
                  : selectedTopData == 1
                  ? Column(
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
                                ? const Center(child: Text('No data available'))
                                :
                            Container(
                              color: Colors.white,
                              child: DropdownButtonFormField2<String>(
                                isExpanded: true,
                                dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                                decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // Add more decoration..
                                ),
                                hint: Text(
                                  buildTranslate("selectState")!,
                                  style: const TextStyle(fontSize: 13, fontFamily: "poppins-regular"),
                                ),
                                items: stateItems!.data!.map((String crop) {
                                  return DropdownMenuItem<String>(
                                    value: crop,
                                    child: Text(crop, style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontFamily: 'poppins-regular')),
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
                                    selectedStateItemValue = value;
                                  });
                                  print("SelectedStateItemValue : $selectedStateItemValue");
                                  _fetchDistrictData();
                                },
                                onSaved: (value) {
                                  selectedStateItemValue = value.toString();
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 24,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                            ),
                            // Container(
                            //   color: Colors.white,
                            //   alignment: Alignment.bottomCenter,
                            //   child:
                            //   DropdownButtonFormField2<String>(
                            //     isExpanded: true,
                            //     decoration: InputDecoration(
                            //       contentPadding:
                            //       const EdgeInsets.symmetric(
                            //           vertical: 10),
                            //       border: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(8),
                            //       ),
                            //       // Add more decoration..
                            //     ),
                            //     hint: Text(
                            //       buildTranslate("selectState")!,
                            //       style: const TextStyle(fontSize: 13, fontFamily: "poppins-regular"),
                            //     ),
                            //     items: stateItems
                            //         .map((item) => DropdownMenuItem<String>(
                            //       value: item,
                            //       child: Text(
                            //         item,
                            //         style: const TextStyle(
                            //           color: Color(0xFF666666),
                            //           fontSize: 13,
                            //           fontFamily: "poppins-regular",
                            //         ),
                            //       ),
                            //     ))
                            //         .toList(),
                            //     validator: (value) {
                            //       if (value == null) {
                            //         return 'Please select type of Entity.';
                            //       }
                            //       return null;
                            //     },
                            //     onChanged: (value) {
                            //       //Do something when selected item is changed.
                            //     },
                            //     onSaved: (value) {
                            //       selectedStateItemValue = value.toString();
                            //     },
                            //     buttonStyleData: const ButtonStyleData(
                            //       padding: EdgeInsets.only(right: 8),
                            //     ),
                            //     iconStyleData: const IconStyleData(
                            //       icon: Icon(
                            //         Icons.arrow_drop_down,
                            //         color: Colors.black45,
                            //       ),
                            //       iconSize: 24,
                            //     ),
                            //     menuItemStyleData: const MenuItemStyleData(
                            //       padding:
                            //       EdgeInsets.symmetric(horizontal: 16),
                            //     ),
                            //   ),
                            // ),

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
                                ? const Center(child: Text('No data available'))
                                :
                            Container(
                              color: Colors.white,
                              child: DropdownButtonFormField2<String>(
                                isExpanded: true,
                                dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                                decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // Add more decoration..
                                ),
                                hint: Text(
                                  buildTranslate("selectDistrict")!,
                                  style: const TextStyle(fontSize: 13, fontFamily: "poppins-regular"),
                                ),
                                items: districtItems!.data!.map((String crop) {
                                  return DropdownMenuItem<String>(
                                    value: crop,
                                    child: Text(crop, style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontFamily: 'poppins-regular')),
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
                                    selectedDistrictItemValue = value;
                                  });
                                  print("selectedDistrictItemValue : $selectedDistrictItemValue");
                                  _fetchCommodityData();
                                },
                                onSaved: (value) {
                                  selectedDistrictItemValue = value.toString();
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 24,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                            ),
                            // Container(
                            //   color: Colors.white,
                            //   alignment: Alignment.bottomCenter,
                            //   child: DropdownButtonFormField2<String>(
                            //     isExpanded: true,
                            //     decoration: InputDecoration(
                            //       contentPadding:
                            //       const EdgeInsets.symmetric(
                            //           vertical: 10),
                            //       border: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(8),
                            //       ),
                            //       // Add more decoration..
                            //     ),
                            //     hint: Text(
                            //       buildTranslate("selectDistrict")!,
                            //       style: const TextStyle(fontSize: 13, fontFamily: "poppins-regular"),
                            //     ),
                            //     items: districtItems
                            //         .map((item) => DropdownMenuItem<String>(
                            //       value: item,
                            //       child: Text(
                            //         item,
                            //         style: const TextStyle(
                            //           color: Color(0xFF666666),
                            //           fontFamily: "poppins-regular",
                            //           fontSize: 13,
                            //         ),
                            //       ),
                            //     ))
                            //         .toList(),
                            //     validator: (value) {
                            //       if (value == null) {
                            //         return 'Please select type of Entity.';
                            //       }
                            //       return null;
                            //     },
                            //     onChanged: (value) {
                            //       //Do something when selected item is changed.
                            //     },
                            //     onSaved: (value) {
                            //       selectedDistrictItemValue =
                            //           value.toString();
                            //     },
                            //     buttonStyleData: const ButtonStyleData(
                            //       padding: EdgeInsets.only(right: 8),
                            //     ),
                            //     iconStyleData: const IconStyleData(
                            //       icon: Icon(
                            //         Icons.arrow_drop_down,
                            //         color: Colors.black45,
                            //       ),
                            //       iconSize: 24,
                            //     ),
                            //     menuItemStyleData: const MenuItemStyleData(
                            //       padding:
                            //       EdgeInsets.symmetric(horizontal: 16),
                            //     ),
                            //   ),
                            // ),
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
                                ? const Center(child: Text('No data available'))
                                :
                            Container(
                              color: Colors.white,
                              child: DropdownButtonFormField2<String>(
                                isExpanded: true,
                                dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                                decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // Add more decoration..
                                ),
                                hint: Text(
                                  buildTranslate("selectCommodity")!,
                                  style: const TextStyle(fontSize: 13, fontFamily: "poppins-regular"),
                                ),
                                items: commodityItems!.data!.map((String crop) {
                                  return DropdownMenuItem<String>(
                                    value: crop,
                                    child: Text(crop, style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontFamily: 'poppins-regular')),
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
                                    selectedCommodityItemValue = value!;
                                  });
                                  print("selectedCommodityItemValue : $selectedCommodityItemValue");
                                },
                                onSaved: (value) {
                                  selectedCommodityItemValue = value.toString();
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 24,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 16),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    alignment: Alignment.bottomCenter,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                              Icons.calendar_month,
                                              size: 20.0,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              _selectFromDate(context);
                                            },
                                          ),
                                          alignLabelWithHint: true,
                                          fillColor: Colors.white,
                                          filled: true,
                                          contentPadding:
                                          const EdgeInsets.all(10.0),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                          ),
                                          hintText: buildTranslate("from"),
                                          hintStyle: const TextStyle(
                                              color: Color(0xFF757575),
                                              fontFamily: "poppins-regular",
                                              fontSize: 13.0),
                                          focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                            borderSide: BorderSide(
                                                color: Colors.green,
                                                width: 0.5),
                                          )),
                                      validator: (value) => value!.isEmpty
                                          ? 'Please, fill this field.'
                                          : null,
                                      controller: fromDateController,
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
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                              Icons.calendar_month,
                                              size: 20.0,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              _selectToDate(context);
                                            },
                                          ),
                                          alignLabelWithHint: true,
                                          fillColor: Colors.white,
                                          filled: true,
                                          contentPadding:
                                          const EdgeInsets.all(10.0),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                          ),
                                          hintText: buildTranslate("to"),
                                          hintStyle: const TextStyle(
                                              color: Color(0xFF757575),
                                              fontFamily: "poppins-regular",
                                              fontSize: 13.0),
                                          focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                            borderSide: BorderSide(
                                                color: Colors.green,
                                                width: 0.5),
                                          )),
                                      validator: (value) => value!.isEmpty
                                          ? 'Please, fill this field.'
                                          : null,
                                      controller: toDateController,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(12),
                                    textStyle:
                                    const TextStyle(fontSize: 18),
                                    backgroundColor:
                                    const Color(0xFF3FC041),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
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
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
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
                              contentPadding: const EdgeInsets.symmetric(vertical: 5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF666666),
                                  width: 1.0,
                                ),),
                              // Add more decoration..
                            ),
                            hint: Text(
                              buildTranslate('sortBy')!,
                              style: const TextStyle(fontSize: 9, color:
                              Color(0xFF666666), fontFamily: "poppins-regular"),
                            ),
                            items: sortItems
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF666666)
                                ),
                              ),
                            ))
                                .toList(),
                            onChanged: (value) {
                              //Do something when selected item is changed.
                            },
                            onSaved: (value) {
                              selectedSortItemsValue = value.toString();
                            },
                            // customButton: Align(
                            //     alignment: Alignment.centerRight,
                            //     child: Image.asset('assets/images/sortBy.png', height: 20, width: 20,)),
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.only(right: 10),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: ImageIcon(AssetImage('assets/images/sortBy.png')),
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
                              padding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 20.0, left: 20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.all(Radius.circular(18))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Image.asset("assets/images/location.png", width: 15, height: 15,),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        "COIMBATORE",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Color(0xFF959595),
                                            fontSize: 11,
                                            fontFamily: 'poppins-semibold'),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Image.asset("assets/images/calendar.png", width: 15, height: 15,),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        "30-07-2024",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Color(0xFF959595),
                                            fontSize: 11,
                                            fontFamily: 'poppins-semibold'),
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
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                            child: Row(
                              children: [
                                Image.asset("assets/images/mandiBG.png",),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "COCONUT",
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Color(0xFF808080),
                                      fontSize: 14,
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Center(
                            child: Text(
                              "Price Per Quintal",
                              softWrap: true,
                              style: TextStyle(
                                  color: Color(0xFF808080),
                                  fontSize: 17,
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: const BoxDecoration(
                                color: Color(0xFF116B38),
                                borderRadius:
                                BorderRadius.only(bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Min ₹: \n3850",
                                    textAlign:
                                    TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily:
                                        'poppins-regular'),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Average ₹: \n3950",
                                    textAlign:
                                    TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily:
                                        'poppins-regular'),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Max ₹: \n4000",
                                    textAlign:
                                    TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily:
                                        'poppins-regular'),
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
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              )
                  : selectedTopData == 2
                  ? const Padding(
                padding: EdgeInsets.only(top: 200.0),
                child: Center(child: Text("This screen is Locked !", softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'poppins-semibold'),)),
              )
                  : Container(),
                    Container(),
            ],
          ),
        ),
        floatingActionButton: widget.aapbarVisibility
            ? FloatingActionButton(
          backgroundColor: Colors.white.withAlpha(0),
          // add this line.
          elevation: 0,
          // also important, removes the shadow
          heroTag: "floatingActionBtn",
          shape: const RoundedRectangleBorder(
            // <= Change BeveledRectangleBorder to RoundedRectangularBorder
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                _onItemTapped(4);
              });
            },
            child: Image.asset(
              'assets/images/bottomCenter.png',
              // color: Colors.white,
            ),
          ),
          onPressed: () {
            _fabAnimationController.reset();
            _borderRadiusAnimationController.reset();
            _borderRadiusAnimationController.forward();
            _fabAnimationController.forward();
          },
        )
            : null,
        floatingActionButtonLocation: widget.aapbarVisibility
            ? FloatingActionButtonLocation.centerDocked
            : null,
        bottomNavigationBar: widget.aapbarVisibility && typeOfOrganizationData == "Farmer groups"
            ? AnimatedBottomNavigationBar.builder(
          height: 70,
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? Colors.green : Colors.grey;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconList[index].icon ?? "",
                  color: color,
                  width: 25,
                  height: 25,
                ),
                const SizedBox(height: 5),
                Text(
                  iconList[index].name ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 13,
                      fontFamily: 'poppins-regular'),
                ),
              ],
            );
          },
          // backgroundColor: Colors.white,
          activeIndex: _bottomNavIndex,
          // splashColor: Colors.green,
          notchAndCornersAnimation: borderRadiusAnimation,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.defaultEdge,
          gapLocation: GapLocation.center,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          notchMargin: 7,
          onTap: (index) {
            setState(() {
              _onItemTapped(index);
            });
          },
          // setState(() => _bottomNavIndex = index),
          hideAnimationController: _hideBottomBarAnimationController,
          shadow: const BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0.2,
            color: Colors.white,
          ),
        )
            : widget.aapbarVisibility && typeOfOrganizationData != "Farmer groups" ?
        AnimatedBottomNavigationBar.builder(
          height: 70,
          itemCount: iconList2.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive
                ? Colors.green
                : Colors.grey;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconList2[index].icon ?? "",
                  color: color,
                  width: 25, height: 25,
                ),
                const SizedBox(height: 5),
                Text(
                  iconList2[index].name ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 13,
                      fontFamily: 'poppins-regular'),
                ),
              ],
            );
          },
          // backgroundColor: Colors.white,
          activeIndex: _bottomNavIndex,
          // splashColor: Colors.green,
          notchAndCornersAnimation: borderRadiusAnimation,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.defaultEdge,
          gapLocation: GapLocation.center,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          notchMargin: 7,
          onTap: (index) {
            setState(() {
              print("Type 2 BottomOnePage: $index");
              typeOfOrganizationData == "Farmer groups" ? _onItemTapped(index) : index == 0 ?_onItemTapped(index)
                  : _onItemTapped(3);
            });
          },
          hideAnimationController: _hideBottomBarAnimationController,
          shadow: const BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0.2,
            color: Colors.white,
          ),
        )
            : null
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
        fromDateController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
        dateOfIncorporationNumberValue = "${pickedDate}Z";
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
        toDateController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
        dateOfToValue = "${pickedDate}Z";
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
            builder: (BuildContext context) => MyBottomOnePage(
              aapbarVisibility: true,
            )));
      }
    } else if (index == 1) {
      // Navigator.pop(context);
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => MyBottomTwoPage(
              aapbarVisibility: true,
            )));
      }
    } else if (index == 2) {
      // Navigator.pop(context);
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => MyBottomThreePage(
              aapbarVisibility: true,
            )));
      }
    } else if (index == 3) {
      if (_isClickAllowed) {
        _isClickAllowed = false;
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MyProfilePage()),
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
            builder: (BuildContext context) => MyBottomCenterEnquiryPage(
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