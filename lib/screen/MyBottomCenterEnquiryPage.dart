import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:chip_list/chip_list.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:page_transition/page_transition.dart';

import '../localization/AppLocalizations.dart';
import 'MyBottomOnePage.dart';
import 'MyBottomThreePage.dart';
import 'MyBottomTwoPage.dart';
import 'MyBuyCommodityPage.dart';
import 'MyDrawer.dart';
import 'MyEnquiryDashboardPage.dart';
import 'MyFarmerProfile.dart';
import 'MyProfilePage.dart';
import 'MySelectLanguagePage.dart';
import 'MySellCommodityPage.dart';

class MyBottomCenterEnquiryPage extends StatefulWidget {
  bool aapbarVisibility;

  MyBottomCenterEnquiryPage({super.key, required this.aapbarVisibility});

  @override
  State<MyBottomCenterEnquiryPage> createState() => _MyBottomCenterEnquiryPageState();
}

class _MyBottomCenterEnquiryPageState extends State<MyBottomCenterEnquiryPage> with TickerProviderStateMixin {

  final List<String> items = ['Maize', 'Coriander', 'Soya'];

  String? selectedItemValue;

  final List<String> topData = [
    buildTranslate("viewEnquiries")!,
    buildTranslate("postEnquiries")!,
    buildTranslate("myEnquiries")!,
  ];

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;
  var _bottomNavIndex = 1; //default index of a first screen

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

  TextEditingController? controller;
  int selectedTopData = 0;
  TextEditingController? naneController;
  bool otpVisible = false;

  final List<String> cropItems = [
    'All',
    'Maize',
    'Paddy',
  ];

  final List<String> villageItems = [
    'All',
    'Ganapathy',
  ];

  List<cropsCategory> search_crops = [
    cropsCategory(
        name: "Total Farmer 350", id: "1", icon: 'assets/images/crops1.png'),
    cropsCategory(
        name: "Total Farmer Land(in HA) 125400",
        id: "2",
        icon: 'assets/images/crops2.png'),
    cropsCategory(
        name: "Expected Yield(in Qtl)256300",
        id: "3",
        icon: 'assets/images/crops1.png'),
  ];

  String? selectedCropItemValue, selectedVillageItemValue;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Enquiry> postEnquiry = [
    Enquiry(
      name: buildTranslate("buy"),
      icon: "assets/images/buy.png",
      id: "1",
    ),
    Enquiry(
      name: buildTranslate("sell"),
      icon: "assets/images/sell.png",
      id: "2",
    ),
  ];
  bool showCommodity = false;

  final List<String> _chipNames = [
    buildTranslate("buy")!,
    buildTranslate("sell")!,
  ];
  int _currentIndex = 0;

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
                        builder: (context) => const MySelectLanguagePage()),
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
                      padding: const EdgeInsets.only(right: 5.0, top: 12.0),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/language.png',
                            width: 35, height: 35,
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
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Chip(
                            backgroundColor: selectedTopData == index
                                ? Colors.green
                                : Colors.white,
                            padding: const EdgeInsets.all(8),
                            shape: const
                            RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          buildTranslate("enquiryDashboard")!,
                          softWrap: true,
                          style: const TextStyle(
                              color: Color(0xFF3FC041),
                              fontSize: 20,
                              fontFamily: 'poppins-medium'),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text(
                          buildTranslate("selectYourCommodity")!,
                          softWrap: true,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontFamily: 'poppins-semibold'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 25.0, top: 10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xFFd3d3d3), width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            width: 240,
                            height: 50,
                            color: Colors.white,
                            child: Container(
                              color: Colors.white,
                              child: DropdownButtonFormField2<String>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none),
                                  // Add more decoration..
                                ),
                                hint: Text(
                                  buildTranslate("selectYourCommodity")!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                items: items
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: "poppins-regular",
                                                color: Colors.black),
                                          ),
                                        ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select type of Entity.';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  //Do something when selected item is changed.
                                },
                                onSaved: (value) {
                                  selectedItemValue = value.toString();
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 20,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                            ),
                          ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Container(
                          //       width: 240,
                          //       height: 50,
                          //       color: Colors.white,
                          //       child: Container(
                          //         color: Colors.white,
                          //         child: DropdownButtonFormField2<String>(
                          //           isExpanded: true,
                          //           decoration: InputDecoration(
                          //             contentPadding:
                          //                 const EdgeInsets.symmetric(
                          //                     vertical: 16),
                          //             border: OutlineInputBorder(
                          //                 borderRadius:
                          //                     BorderRadius.circular(8),
                          //                 borderSide: BorderSide.none),
                          //             // Add more decoration..
                          //           ),
                          //           hint: const Text(
                          //             'Select your commodity',
                          //             style: TextStyle(fontSize: 14),
                          //           ),
                          //           items: items
                          //               .map((item) => DropdownMenuItem<String>(
                          //                     value: item,
                          //                     child: Text(
                          //                       item,
                          //                       style: const TextStyle(
                          //                           fontSize: 14,
                          //                           fontFamily:
                          //                               "poppins-regular",
                          //                           color: Colors.black),
                          //                     ),
                          //                   ))
                          //               .toList(),
                          //           validator: (value) {
                          //             if (value == null) {
                          //               return 'Please select type of Entity.';
                          //             }
                          //             return null;
                          //           },
                          //           onChanged: (value) {
                          //             //Do something when selected item is changed.
                          //           },
                          //           onSaved: (value) {
                          //             selectedItemValue = value.toString();
                          //           },
                          //           buttonStyleData: const ButtonStyleData(
                          //             padding: EdgeInsets.only(right: 8),
                          //           ),
                          //           iconStyleData: const IconStyleData(
                          //             icon: Icon(
                          //               Icons.arrow_drop_down,
                          //               color: Colors.black45,
                          //             ),
                          //             iconSize: 0,
                          //           ),
                          //           menuItemStyleData: const MenuItemStyleData(
                          //             padding:
                          //                 EdgeInsets.symmetric(horizontal: 16),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     // const SizedBox(
                          //     //   width: 10,
                          //     // ),
                          //     // Padding(
                          //     //   padding: EdgeInsets.all(10.0),
                          //     //   child: InkWell(
                          //     //       highlightColor: Colors.transparent,
                          //     //       splashColor: Colors.transparent,
                          //     //       onTap: () {
                          //     //         // Navigator.push(
                          //     //         //   context,
                          //     //         //   PageTransition(
                          //     //         //     type: PageTransitionType.leftToRight,
                          //     //         //     child: MyDrawer(),
                          //     //         //   ),
                          //     //         // );
                          //     //       },
                          //     //       child: Image.asset(
                          //     //         'assets/images/filter.png',
                          //     //         height: 25,
                          //     //         width: 25,
                          //     //       )),
                          //     // ),
                          //   ],
                          // ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const MyEnquiryDashboardPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(12),
                              textStyle: const TextStyle(fontSize: 15),
                              backgroundColor: const Color(0xFF3FC041),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: Text(
                              buildTranslate('SUBMIT')!,
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'poppins-medium'),
                            ),
                          )),
                    ],
                  )
                : selectedTopData == 1
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              buildTranslate("postEnquiry")!,
                              softWrap: true,
                              style: const TextStyle(
                                  color: Color(0xFF3FC041),
                                  fontSize: 20,
                                  fontFamily: 'poppins-medium'),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          listPostWidget(),
                        ],
                      )
                    : selectedTopData == 2
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  buildTranslate("myEnquiry")!,
                                  softWrap: true,
                                  style: const TextStyle(
                                      color: Color(0xFF3FC041),
                                      fontSize: 20,
                                      fontFamily: 'poppins-medium'),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Text(
                                  buildTranslate("selectYourCommodity")!,
                                  softWrap: true,
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30.0, right: 25.0, top: 10.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color(0xFFd3d3d3),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Container(
                                    width: 240,
                                    height: 50,
                                    color: Colors.white,
                                    child: Container(
                                      color: Colors.white,
                                      child: DropdownButtonFormField2<String>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 16),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide.none),
                                        ),
                                        hint: Text(
                                          buildTranslate("selectYourCommodity")!,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        items: items
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            "poppins-regular",
                                                        color: Colors.black),
                                                  ),
                                                ))
                                            .toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select type of Entity.';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          //Do something when selected item is changed.
                                        },
                                        onSaved: (value) {
                                          selectedItemValue = value.toString();
                                        },
                                        buttonStyleData: const ButtonStyleData(
                                          padding: EdgeInsets.only(right: 8),
                                        ),
                                        iconStyleData: const IconStyleData(
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black45,
                                          ),
                                          iconSize: 20,
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Row(
                                  //   crossAxisAlignment: CrossAxisAlignment.center,
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     Container(
                                  //       width: 240,
                                  //       height: 50,
                                  //       color: Colors.white,
                                  //       child: Container(
                                  //         color: Colors.white,
                                  //         child: DropdownButtonFormField2<String>(
                                  //           isExpanded: true,
                                  //           decoration: InputDecoration(
                                  //             contentPadding:
                                  //                 const EdgeInsets.symmetric(
                                  //                     vertical: 16),
                                  //             border: OutlineInputBorder(
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(8),
                                  //                 borderSide: BorderSide.none),
                                  //             // Add more decoration..
                                  //           ),
                                  //           hint: const Text(
                                  //             'Select your commodity',
                                  //             style: TextStyle(fontSize: 14),
                                  //           ),
                                  //           items: items
                                  //               .map((item) => DropdownMenuItem<String>(
                                  //                     value: item,
                                  //                     child: Text(
                                  //                       item,
                                  //                       style: const TextStyle(
                                  //                           fontSize: 14,
                                  //                           fontFamily:
                                  //                               "poppins-regular",
                                  //                           color: Colors.black),
                                  //                     ),
                                  //                   ))
                                  //               .toList(),
                                  //           validator: (value) {
                                  //             if (value == null) {
                                  //               return 'Please select type of Entity.';
                                  //             }
                                  //             return null;
                                  //           },
                                  //           onChanged: (value) {
                                  //             //Do something when selected item is changed.
                                  //           },
                                  //           onSaved: (value) {
                                  //             selectedItemValue = value.toString();
                                  //           },
                                  //           buttonStyleData: const ButtonStyleData(
                                  //             padding: EdgeInsets.only(right: 8),
                                  //           ),
                                  //           iconStyleData: const IconStyleData(
                                  //             icon: Icon(
                                  //               Icons.arrow_drop_down,
                                  //               color: Colors.black45,
                                  //             ),
                                  //             iconSize: 0,
                                  //           ),
                                  //           menuItemStyleData: const MenuItemStyleData(
                                  //             padding:
                                  //                 EdgeInsets.symmetric(horizontal: 16),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     // const SizedBox(
                                  //     //   width: 10,
                                  //     // ),
                                  //     // Padding(
                                  //     //   padding: EdgeInsets.all(10.0),
                                  //     //   child: InkWell(
                                  //     //       highlightColor: Colors.transparent,
                                  //     //       splashColor: Colors.transparent,
                                  //     //       onTap: () {
                                  //     //         // Navigator.push(
                                  //     //         //   context,
                                  //     //         //   PageTransition(
                                  //     //         //     type: PageTransitionType.leftToRight,
                                  //     //         //     child: MyDrawer(),
                                  //     //         //   ),
                                  //     //         // );
                                  //     //       },
                                  //     //       child: Image.asset(
                                  //     //         'assets/images/filter.png',
                                  //     //         height: 25,
                                  //     //         width: 25,
                                  //     //       )),
                                  //     // ),
                                  //   ],
                                  // ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(
                                      left: 30.0, right: 30.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        showCommodity = true;
                                      });
                                      },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(12),
                                      textStyle: const TextStyle(fontSize: 15),
                                      backgroundColor: const Color(0xFF3FC041),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12), // <-- Radius
                                      ),
                                    ),
                                    child: Text(
                                      buildTranslate('SUBMIT')!,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'poppins-medium'),
                                    ),
                                  )),
                              const SizedBox(height: 20,),

                              Visibility(
                                visible: showCommodity,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                    child: Container(
                                      height: 45,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color(0xFFd3d3d3), width: 1),
                                          borderRadius: BorderRadius.circular(25)),
                                      child: ChipList(
                                        listOfChipNames: _chipNames,
                                        showCheckmark: false,
                                        extraOnToggle: (val) {
                                          _currentIndex = val;
                                          setState(() {});
                                          print("Chip index : $_currentIndex");
                                        },
                                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                        activeBgColorList: const [Color(0xFF2A9D8F)],
                                        inactiveBgColorList: const [Colors.white],
                                        activeTextColorList: const [Colors.white],
                                        inactiveTextColorList: const [Color(0xFF666666)],
                                        // borderColorList: [Theme.of(context).primaryColor],
                                        listOfChipIndicesCurrentlySelected: [_currentIndex],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Visibility(
                                visible: showCommodity && _currentIndex == 0,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 10.0, right: 30.0, left: 30.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(12))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Stack(children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: 180,
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                                  image: DecorationImage(
                                                      image:
                                                      AssetImage("assets/images/enquiryBG.png"),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 18.0, left: 18.0),
                                            child: IntrinsicWidth(
                                              child: Container(
                                                // constraints: const BoxConstraints(
                                                //   maxWidth: 120,
                                                // ),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF008000),
                                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                                ),
                                                child: const Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 5.0, bottom: 5.0),
                                                      child: Text(
                                                        'Price  Rs.25000',
                                                        style:
                                                        TextStyle(color: Colors.white, fontSize: 11,
                                                            fontFamily: "poppins-semibold"),
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            "Name :  Ankit",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Color(0xFF808080),
                                                fontSize: 15,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 20.0, top: 10.0),
                                          child: Text(
                                            "Purpose:  To Buy",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Color(0xFF808080),
                                                fontSize: 15,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 20.0, top: 10.0),
                                          child: Text(
                                            "Quantity :  10 Metric Ton (MT)",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Color(0xFF808080),
                                                fontSize: 15,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 20.0, top: 10.0),
                                          child: Text(
                                            "Location :  Latur, Maharastra",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Color(0xFF808080),
                                                fontSize: 15,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0, top: 20.0),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 40,
                                            child: Container(
                                                width: MediaQuery.of(context).size.width,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                            const MyBuyCommodityPage()));
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.all(3),
                                                    textStyle: const TextStyle(fontSize: 18),
                                                    backgroundColor: const Color(0xFF3FC041),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(
                                                          12), // <-- Radius
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      buildTranslate('Edit')!,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontFamily: 'poppins-medium'),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Visibility(
                                visible: showCommodity && _currentIndex == 1,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 10.0, right: 30.0, left: 30.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(12))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Stack(children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: 180,
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                                  image: DecorationImage(
                                                      image:
                                                      AssetImage("assets/images/enquiryBG.png"),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 18.0, left: 18.0),
                                            child: IntrinsicWidth(
                                              child: Container(
                                                // constraints: const BoxConstraints(
                                                //   maxWidth: 150,
                                                // ),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF008000),
                                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                                ),
                                                child: const Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 5.0, bottom: 5.0),
                                                      child: Text(
                                                        'Price  Rs.25000',
                                                        style:
                                                        TextStyle(color: Colors.white, fontSize: 11,
                                                            fontFamily: "poppins-semibold"),
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            "Name :  Ankit",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Color(0xFF808080),
                                                fontSize: 15,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 20.0, top: 10.0),
                                          child: Text(
                                            "Purpose:  To Sell",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Color(0xFF808080),
                                                fontSize: 15,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 20.0, top: 10.0),
                                          child: Text(
                                            "Quantity :  10 Metric Ton (MT)",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Color(0xFF808080),
                                                fontSize: 15,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 20.0, top: 10.0),
                                          child: Text(
                                            "Location :  Latur, Maharastra",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Color(0xFF808080),
                                                fontSize: 15,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0, top: 20.0),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 40,
                                            child: Container(
                                                width: MediaQuery.of(context).size.width,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                            const MySellCommodityPage()));
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.all(3),
                                                    textStyle: const TextStyle(fontSize: 18),
                                                    backgroundColor: const Color(0xFF3FC041),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(
                                                          12), // <-- Radius
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      buildTranslate('Edit')!,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontFamily: 'poppins-medium'),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 40,),
                            ],
                          )
                        : Container(),
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
              child: Image.asset(
                'assets/images/bottomCenter.png',
                // color: Colors.white,
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
      bottomNavigationBar: widget.aapbarVisibility
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
          : null,
      // drawer: MyDrawer(),
    );
  }

  Widget listPostWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: postEnquiry.length,
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () {
              if (postEnquiry[index].id == "1") {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyBuyCommodityPage()));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MySellCommodityPage()));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFd3d3d3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(22)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      postEnquiry[index].icon ?? "",
                      color: Colors.grey,
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      postEnquiry[index].name ?? "",
                      style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 15,
                          fontFamily: 'poppins-regular'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index != 3) {
      setState(() {
        _bottomNavIndex = index;
      });
      print("BottomTwoPage : $_bottomNavIndex");
      if (_bottomNavIndex == 0) {
        // Navigator.pop(context);
        var route = ModalRoute.of(context);
        if (route != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => MyBottomOnePage(
                    aapbarVisibility: true,
                  )));
        }
      } else if (_bottomNavIndex == 1) {
        // Navigator.pop(context);
        var route = ModalRoute.of(context);
        if (route != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => MyBottomTwoPage(
                    aapbarVisibility: true,
                  )));
        }
      } else if (_bottomNavIndex == 2) {
        // Navigator.pop(context);
        var route = ModalRoute.of(context);
        if (route != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => MyBottomThreePage(
                    aapbarVisibility: true,
                  )));
        }
      }
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MyProfilePage()),
      );
    }
  }

  void _onSelectedTopDataTapped(int index) {
    setState(() {
      selectedTopData = index;
    });
    print("Selected Top Page : $selectedTopData");
  }

  Widget listWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: search_crops.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFd3d3d3),
                    )
                  ],
                  border:
                      Border.all(color: const Color(0xFFd3d3d3), width: 1.0),
                  borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      search_crops[index].icon ?? "",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          search_crops[index].name ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 15,
                              fontFamily: 'poppins-regular'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      ),
    );
  }
}

class Enquiry {
  String? name;
  String? id;
  String? icon;

  Enquiry({
    required this.name,
    required this.id,
    required this.icon,
  });
}

class cropsCategory {
  String? name;
  String? icon;
  String? id;

  cropsCategory({
    required this.name,
    required this.icon,
    required this.id,
  });
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
