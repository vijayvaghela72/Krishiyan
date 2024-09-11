import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:chip_list/chip_list.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:krishiyan/screen/MyHomePage.dart';
import 'package:page_transition/page_transition.dart';

import '../helper/SharedPref.dart';
import '../localization/AppLocalizations.dart';
import '../mvc/controller/enquiryDashboardController.dart';
import '../mvc/model/GetEnquiryByFilterData.dart';
import '../mvc/model/SelectCropNamesData.dart';
import '../utils/Constants.dart';
import 'MyBottomOnePage.dart';
import 'MyBottomThreePage.dart';
import 'MyBottomTwoPage.dart';
import 'MyBuyCommodityPage.dart';
import 'MyEditBuyCommodityPage.dart';
import 'MyEditSellCommodityPage.dart';
import 'MyEnquiryDashboardPage.dart';
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

  String? _selectedCrop;
  SelectCropNamesData? _cropData;

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
        id: "1", icon: 'assets/images/bottom1.png'),
    bottomCategory(
        name: buildTranslate("profile")!,
        id: "2",
        icon: 'assets/images/bottom4.png'),
  ];

  TextEditingController? controller;
  int selectedTopData = 0;
  TextEditingController? naneController;
  bool otpVisible = false;

  String typeOfOrganizationData = "";

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

  final List<String> _chipNames = [
    buildTranslate("buy")!,
    buildTranslate("sell")!,
  ];
  int _currentIndex = 0;
  Future<List<EnquiryByFilterData>>? futureEnquiryFilterData;

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
    _fetchCropData();
    getPrefValue();
  }

  Future<void> getPrefValue() async {
    typeOfOrganizationData = await SharedPref.readPreferenceValue(typeOfOrganization, PrefEnum.STRING);
    print("BottomCenterEnquiry TypeOfOrganizationData : $typeOfOrganizationData");
    setState(() {
      typeOfOrganizationData = typeOfOrganizationData;
    });
  }

  Future<void> _fetchCropData() async {
    try {
      // Replace with your actual API endpoint
      var response = await Dio().get(CROPS_NAMES);

      if (response.statusCode == 200) {
        setState(() {
          _cropData = SelectCropNamesData.fromJson(response.data);
        });
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (e) {
      print('My BottomCenterEnquiry : Error fetching crop data: $e');
    }
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
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(17),
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
                        left: 25.0, right: 25.0, top: 10.0),
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
                          child: _cropData == null ||
                              _cropData!.data == null
                              ? const Center(
                              child: Text('No data available'))
                              : DropdownButtonFormField2<String>(
                            dropdownStyleData:
                            DropdownStyleData(maxHeight: 200),
                            hint: const Text('Select your Commodity'),
                            decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  vertical: 16),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              // Add more decoration..
                            ),
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
                            menuItemStyleData:
                            const MenuItemStyleData(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16),
                            ),
                            value: _selectedCrop,
                            items:
                            _cropData!.data!.map((String crop) {
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
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCrop = newValue;
                              });
                            },
                          ),
                        ),
                      ),
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
                          if (_selectedCrop !=null && _selectedCrop!.isNotEmpty) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyEnquiryDashboardPage(selectedCrop : _selectedCrop)));
                          }
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
                            left: 25.0, right: 25.0, top: 10.0),
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
                              child: _cropData == null ||
                                  _cropData!.data == null
                                  ? const Center(
                                  child: Text('No data available'))
                                  : DropdownButtonFormField2<String>(
                                dropdownStyleData:
                                DropdownStyleData(
                                    maxHeight: 200),
                                hint: const Text(
                                    'Select your Commodity'),
                                decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      vertical: 16),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  // Add more decoration..
                                ),
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
                                value: _selectedCrop,
                                items: _cropData!.data!
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
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCrop = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
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
                                if(_currentIndex == 0) {
                                  futureEnquiryFilterData =
                                      EnquiryDashboardController
                                          .getEnquiryDetailsByFilterCommodity(_selectedCrop.toString(), "Buy");
                                  setState(() {
                                    futureEnquiryFilterData = futureEnquiryFilterData;
                                  });
                                }
                                else{
                                  futureEnquiryFilterData =
                                      EnquiryDashboardController
                                          .getEnquiryDetailsByFilterCommodity(_selectedCrop.toString(), "Sell");
                                  setState(() {
                                    futureEnquiryFilterData = futureEnquiryFilterData;
                                  });
                                }
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
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0),
                          child: Container(
                            height: 45,
                            alignment: Alignment.center,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: const Color(0xFFd3d3d3),
                                    width: 1),
                                borderRadius:
                                BorderRadius.circular(25)),
                            child: ChipList(
                              listOfChipNames: _chipNames,
                              showCheckmark: false,
                              extraOnToggle: (val) {
                                _currentIndex = val;
                                if(_currentIndex == 0) {
                                  futureEnquiryFilterData =
                                      EnquiryDashboardController
                                          .getEnquiryDetailsByFilterCommodity(_selectedCrop.toString(), "Buy");
                                  setState(() {
                                    futureEnquiryFilterData = futureEnquiryFilterData;
                                  });
                                }
                                else{
                                  futureEnquiryFilterData =
                                      EnquiryDashboardController
                                          .getEnquiryDetailsByFilterCommodity(_selectedCrop.toString(), "Sell");
                                  setState(() {
                                    futureEnquiryFilterData = futureEnquiryFilterData;
                                  });
                                }
                                setState(() {
                                  futureEnquiryFilterData = futureEnquiryFilterData;
                                });
                                print("Chip index : $_currentIndex");
                              },
                              padding: const EdgeInsets.only(
                                  left: 30.0, right: 30.0),
                              activeBgColorList: const [
                                Color(0xFF2A9D8F)
                              ],
                              inactiveBgColorList: const [
                                Colors.white
                              ],
                              activeTextColorList: const [
                                Colors.white
                              ],
                              inactiveTextColorList: const [
                                Color(0xFF666666)
                              ],
                              // borderColorList: [Theme.of(context).primaryColor],
                              listOfChipIndicesCurrentlySelected: [_currentIndex],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      futureEnquiryFilterData.toString().isNotEmpty ?
                      FutureBuilder<List<EnquiryByFilterData>>(
                        future: futureEnquiryFilterData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('No Data Available'));
                            // return Center(child: Text(snapshot.hasError.toString()));
                          } else if (snapshot.hasData) {
                            final List<EnquiryByFilterData> enquiry = snapshot.data!;
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: enquiry.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final enquiryFilterData = enquiry[index];
                                return Column(
                                  children: [
                                    Visibility(
                                      visible: _currentIndex == 0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 30.0, left: 30.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12))),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Stack(children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(18.0),
                                                  child: Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    height: 180,
                                                    decoration: const BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(12)),
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/enquiryBG.png"),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 18.0, left: 18.0),
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xFF008000),
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(12)),
                                                      ),
                                                      child: Align(
                                                          alignment:
                                                          Alignment.topLeft,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 12.0,
                                                                right: 12.0,
                                                                top: 5.0,
                                                                bottom: 5.0),
                                                            child: Text(
                                                              'Price  Rs.${enquiryFilterData.price}',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                  "poppins-semibold"),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 20.0),
                                                child: Text(
                                                  "Name : ${enquiryFilterData.uid}",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Color(0xFF808080),
                                                      fontSize: 15,
                                                      fontFamily: 'poppins-semibold'),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20.0, top: 10.0),
                                                child: Text(
                                                  "Purpose:  To ${enquiryFilterData.operation}",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Color(0xFF808080),
                                                      fontSize: 15,
                                                      fontFamily: 'poppins-semibold'),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20.0, top: 10.0),
                                                child: Text(
                                                  "Quantity : ${enquiryFilterData.quantity.toString()}",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Color(0xFF808080),
                                                      fontSize: 15,
                                                      fontFamily: 'poppins-semibold'),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20.0, top: 10.0),
                                                child: Text(
                                                  "Location : ${enquiryFilterData.location}",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Color(0xFF808080),
                                                      fontSize: 15,
                                                      fontFamily: 'poppins-semibold'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0,
                                                    top: 20.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 40,
                                                  child: Container(
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      MyEditBuyCommodityPage(enquiryData : enquiryFilterData)));
                                                        },
                                                        style:
                                                        ElevatedButton.styleFrom(
                                                          foregroundColor:
                                                          Colors.white,
                                                          padding:
                                                          const EdgeInsets.all(3),
                                                          textStyle: const TextStyle(
                                                              fontSize: 18),
                                                          backgroundColor:
                                                          const Color(0xFF3FC041),
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                12), // <-- Radius
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            buildTranslate('edit')!,
                                                            textAlign:
                                                            TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                fontFamily:
                                                                'poppins-medium'),
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
                                      visible: _currentIndex == 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 30.0, left: 30.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12))),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Stack(children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(18.0),
                                                  child: Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    height: 180,
                                                    decoration: const BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(12)),
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/enquiryBG.png"),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 18.0, left: 18.0),
                                                  child: IntrinsicWidth(
                                                    child: Container(
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xFF008000),
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(12)),
                                                      ),
                                                      child: Align(
                                                          alignment:
                                                          Alignment.topLeft,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 12.0,
                                                                right: 12.0,
                                                                top: 5.0,
                                                                bottom: 5.0),
                                                            child: Text(
                                                              'Price  Rs.${enquiryFilterData.price}',
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                  "poppins-semibold"),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 20.0),
                                                child: Text(
                                                  "Name : ${enquiryFilterData.uid}",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Color(0xFF808080),
                                                      fontSize: 15,
                                                      fontFamily: 'poppins-semibold'),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20.0, top: 10.0),
                                                child: Text(
                                                  "Purpose:  To ${enquiryFilterData.operation}",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Color(0xFF808080),
                                                      fontSize: 15,
                                                      fontFamily: 'poppins-semibold'),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20.0, top: 10.0),
                                                child: Text(
                                                  "Quantity : ${enquiryFilterData.quantity.toString()}",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Color(0xFF808080),
                                                      fontSize: 15,
                                                      fontFamily: 'poppins-semibold'),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 20.0, top: 10.0),
                                                child: Text(
                                                  "Location : ${enquiryFilterData.location}",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Color(0xFF808080),
                                                      fontSize: 15,
                                                      fontFamily: 'poppins-semibold'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0,
                                                    top: 20.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 40,
                                                  child: Container(
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      MyEditSellCommodityPage(enquiryData : enquiryFilterData)));
                                                        },
                                                        style:
                                                        ElevatedButton.styleFrom(
                                                          foregroundColor:
                                                          Colors.white,
                                                          padding:
                                                          const EdgeInsets.all(3),
                                                          textStyle: const TextStyle(
                                                              fontSize: 18),
                                                          backgroundColor:
                                                          const Color(0xFF3FC041),
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                12), // <-- Radius
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            buildTranslate('edit')!,
                                                            textAlign:
                                                            TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                fontFamily:
                                                                'poppins-medium'),
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
                                  ],
                                ) ;
                              },
                            );
                          } else {
                            return const Center(child: Text('No data available'));
                          }
                        },
                      )
                          : Center(child: Text('No Data Available')),
                      // buy commodity

                      // Visibility(
                      //   visible: _currentIndex == 0,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(
                      //         top: 10.0, right: 30.0, left: 30.0),
                      //     child: Container(
                      //       decoration: const BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.all(
                      //               Radius.circular(12))),
                      //       child: Column(
                      //         crossAxisAlignment:
                      //         CrossAxisAlignment.start,
                      //         mainAxisAlignment:
                      //         MainAxisAlignment.start,
                      //         children: [
                      //           Stack(children: <Widget>[
                      //             Padding(
                      //               padding: const EdgeInsets.all(18.0),
                      //               child: Container(
                      //                 width: MediaQuery.of(context)
                      //                     .size
                      //                     .width,
                      //                 height: 180,
                      //                 decoration: const BoxDecoration(
                      //                     borderRadius:
                      //                     BorderRadius.all(
                      //                         Radius.circular(12)),
                      //                     image: DecorationImage(
                      //                         image: AssetImage(
                      //                             "assets/images/enquiryBG.png"),
                      //                         fit: BoxFit.cover)),
                      //               ),
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.only(
                      //                   top: 18.0, left: 18.0),
                      //               child: IntrinsicWidth(
                      //                 child: Container(
                      //                   // constraints: const BoxConstraints(
                      //                   //   maxWidth: 120,
                      //                   // ),
                      //                   decoration: const BoxDecoration(
                      //                     color: Color(0xFF008000),
                      //                     borderRadius:
                      //                     BorderRadius.all(
                      //                         Radius.circular(12)),
                      //                   ),
                      //                   child: const Align(
                      //                       alignment:
                      //                       Alignment.topLeft,
                      //                       child: Padding(
                      //                         padding: EdgeInsets.only(
                      //                             left: 12.0,
                      //                             right: 12.0,
                      //                             top: 5.0,
                      //                             bottom: 5.0),
                      //                         child: Text(
                      //                           'Price  Rs.25000',
                      //                           style: TextStyle(
                      //                               color: Colors.white,
                      //                               fontSize: 11,
                      //                               fontFamily:
                      //                               "poppins-semibold"),
                      //                         ),
                      //                       )),
                      //                 ),
                      //               ),
                      //             ),
                      //           ]),
                      //           const SizedBox(
                      //             height: 5.0,
                      //           ),
                      //           const Padding(
                      //             padding: EdgeInsets.only(left: 20.0),
                      //             child: Text(
                      //               "Name :  Ankit",
                      //               softWrap: true,
                      //               style: TextStyle(
                      //                   color: Color(0xFF808080),
                      //                   fontSize: 15,
                      //                   fontFamily: 'poppins-semibold'),
                      //             ),
                      //           ),
                      //           const Padding(
                      //             padding: EdgeInsets.only(
                      //                 left: 20.0, top: 10.0),
                      //             child: Text(
                      //               "Purpose:  To Buy",
                      //               softWrap: true,
                      //               style: TextStyle(
                      //                   color: Color(0xFF808080),
                      //                   fontSize: 15,
                      //                   fontFamily: 'poppins-semibold'),
                      //             ),
                      //           ),
                      //           const Padding(
                      //             padding: EdgeInsets.only(
                      //                 left: 20.0, top: 10.0),
                      //             child: Text(
                      //               "Quantity :  10 Metric Ton (MT)",
                      //               softWrap: true,
                      //               style: TextStyle(
                      //                   color: Color(0xFF808080),
                      //                   fontSize: 15,
                      //                   fontFamily: 'poppins-semibold'),
                      //             ),
                      //           ),
                      //           const Padding(
                      //             padding: EdgeInsets.only(
                      //                 left: 20.0, top: 10.0),
                      //             child: Text(
                      //               "Location :  Latur, Maharastra",
                      //               softWrap: true,
                      //               style: TextStyle(
                      //                   color: Color(0xFF808080),
                      //                   fontSize: 15,
                      //                   fontFamily: 'poppins-semibold'),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.only(
                      //                 left: 10.0,
                      //                 right: 10.0,
                      //                 top: 20.0),
                      //             child: Container(
                      //               width: MediaQuery.of(context)
                      //                   .size
                      //                   .width,
                      //               height: 40,
                      //               child: Container(
                      //                   width: MediaQuery.of(context)
                      //                       .size
                      //                       .width,
                      //                   child: ElevatedButton(
                      //                     onPressed: () {
                      //                       Navigator.of(context).push(
                      //                           MaterialPageRoute(
                      //                               builder: (context) =>
                      //                               const MyBuyCommodityPage()));
                      //                     },
                      //                     style:
                      //                     ElevatedButton.styleFrom(
                      //                       foregroundColor:
                      //                       Colors.white,
                      //                       padding:
                      //                       const EdgeInsets.all(3),
                      //                       textStyle: const TextStyle(
                      //                           fontSize: 18),
                      //                       backgroundColor:
                      //                       const Color(0xFF3FC041),
                      //                       shape:
                      //                       RoundedRectangleBorder(
                      //                         borderRadius:
                      //                         BorderRadius.circular(
                      //                             12), // <-- Radius
                      //                       ),
                      //                     ),
                      //                     child: Center(
                      //                       child: Text(
                      //                         buildTranslate('edit')!,
                      //                         textAlign:
                      //                         TextAlign.center,
                      //                         style: TextStyle(
                      //                             fontSize: 17,
                      //                             fontFamily:
                      //                             'poppins-medium'),
                      //                       ),
                      //                     ),
                      //                   )),
                      //             ),
                      //           ),
                      //           const SizedBox(
                      //             height: 15,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // sell commodity

                      // Visibility(
                      //   visible: _currentIndex == 1,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(
                      //         top: 10.0, right: 30.0, left: 30.0),
                      //     child: Container(
                      //       decoration: const BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.all(
                      //               Radius.circular(12))),
                      //       child: Column(
                      //         crossAxisAlignment:
                      //         CrossAxisAlignment.start,
                      //         mainAxisAlignment:
                      //         MainAxisAlignment.start,
                      //         children: [
                      //           Stack(children: <Widget>[
                      //             Padding(
                      //               padding: const EdgeInsets.all(18.0),
                      //               child: Container(
                      //                 width: MediaQuery.of(context)
                      //                     .size
                      //                     .width,
                      //                 height: 180,
                      //                 decoration: const BoxDecoration(
                      //                     borderRadius:
                      //                     BorderRadius.all(
                      //                         Radius.circular(12)),
                      //                     image: DecorationImage(
                      //                         image: AssetImage(
                      //                             "assets/images/enquiryBG.png"),
                      //                         fit: BoxFit.cover)),
                      //               ),
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.only(
                      //                   top: 18.0, left: 18.0),
                      //               child: IntrinsicWidth(
                      //                 child: Container(
                      //                   // constraints: const BoxConstraints(
                      //                   //   maxWidth: 150,
                      //                   // ),
                      //                   decoration: const BoxDecoration(
                      //                     color: Color(0xFF008000),
                      //                     borderRadius:
                      //                     BorderRadius.all(
                      //                         Radius.circular(12)),
                      //                   ),
                      //                   child: const Align(
                      //                       alignment:
                      //                       Alignment.topLeft,
                      //                       child: Padding(
                      //                         padding: EdgeInsets.only(
                      //                             left: 12.0,
                      //                             right: 12.0,
                      //                             top: 5.0,
                      //                             bottom: 5.0),
                      //                         child: Text(
                      //                           'Price  Rs.25000',
                      //                           style: TextStyle(
                      //                               color: Colors.white,
                      //                               fontSize: 11,
                      //                               fontFamily:
                      //                               "poppins-semibold"),
                      //                         ),
                      //                       )),
                      //                 ),
                      //               ),
                      //             ),
                      //           ]),
                      //           const SizedBox(
                      //             height: 5.0,
                      //           ),
                      //           const Padding(
                      //             padding: EdgeInsets.only(left: 20.0),
                      //             child: Text(
                      //               "Name :  Ankit",
                      //               softWrap: true,
                      //               style: TextStyle(
                      //                   color: Color(0xFF808080),
                      //                   fontSize: 15,
                      //                   fontFamily: 'poppins-semibold'),
                      //             ),
                      //           ),
                      //           const Padding(
                      //             padding: EdgeInsets.only(
                      //                 left: 20.0, top: 10.0),
                      //             child: Text(
                      //               "Purpose:  To Sell",
                      //               softWrap: true,
                      //               style: TextStyle(
                      //                   color: Color(0xFF808080),
                      //                   fontSize: 15,
                      //                   fontFamily: 'poppins-semibold'),
                      //             ),
                      //           ),
                      //           const Padding(
                      //             padding: EdgeInsets.only(
                      //                 left: 20.0, top: 10.0),
                      //             child: Text(
                      //               "Quantity :  10 Metric Ton (MT)",
                      //               softWrap: true,
                      //               style: TextStyle(
                      //                   color: Color(0xFF808080),
                      //                   fontSize: 15,
                      //                   fontFamily: 'poppins-semibold'),
                      //             ),
                      //           ),
                      //           const Padding(
                      //             padding: EdgeInsets.only(
                      //                 left: 20.0, top: 10.0),
                      //             child: Text(
                      //               "Location :  Latur, Maharastra",
                      //               softWrap: true,
                      //               style: TextStyle(
                      //                   color: Color(0xFF808080),
                      //                   fontSize: 15,
                      //                   fontFamily: 'poppins-semibold'),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.only(
                      //                 left: 10.0,
                      //                 right: 10.0,
                      //                 top: 20.0),
                      //             child: Container(
                      //               width: MediaQuery.of(context)
                      //                   .size
                      //                   .width,
                      //               height: 40,
                      //               child: Container(
                      //                   width: MediaQuery.of(context)
                      //                       .size
                      //                       .width,
                      //                   child: ElevatedButton(
                      //                     onPressed: () {
                      //                       Navigator.of(context).push(
                      //                           MaterialPageRoute(
                      //                               builder: (context) =>
                      //                               const MySellCommodityPage()));
                      //                     },
                      //                     style:
                      //                     ElevatedButton.styleFrom(
                      //                       foregroundColor:
                      //                       Colors.white,
                      //                       padding:
                      //                       const EdgeInsets.all(3),
                      //                       textStyle: const TextStyle(
                      //                           fontSize: 18),
                      //                       backgroundColor:
                      //                       const Color(0xFF3FC041),
                      //                       shape:
                      //                       RoundedRectangleBorder(
                      //                         borderRadius:
                      //                         BorderRadius.circular(
                      //                             12), // <-- Radius
                      //                       ),
                      //                     ),
                      //                     child: Center(
                      //                       child: Text(
                      //                         buildTranslate('edit')!,
                      //                         textAlign:
                      //                         TextAlign.center,
                      //                         style: TextStyle(
                      //                             fontSize: 17,
                      //                             fontFamily:
                      //                             'poppins-medium'),
                      //                       ),
                      //                     ),
                      //                   )),
                      //             ),
                      //           ),
                      //           const SizedBox(
                      //             height: 15,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 40,
                      ),
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
              print("Type 2 BottomCenterEnquiry: $index");
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
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      ),
    );
  }

  // void _onItemTapped(int index) {
  //   if (index != 3) {
  //     setState(() {
  //       _bottomNavIndex = index;
  //     });
  //     print("BottomCenterEnquiryPage : $_bottomNavIndex");
  //     if (_bottomNavIndex == 0) {
  //       // Navigator.pop(context);
  //         var route = ModalRoute.of(context);
  //         if (route != null) {
  //           Navigator.of(context).pushReplacement(MaterialPageRoute(
  //               builder: (BuildContext context) =>
  //                   MyBottomOnePage(
  //                     aapbarVisibility: true,
  //                   )));
  //         }
  //     } else if (_bottomNavIndex == 1) {
  //       // Navigator.pop(context);
  //       var route = ModalRoute.of(context);
  //       if (route != null) {
  //         Navigator.of(context).pushReplacement(MaterialPageRoute(
  //             builder: (BuildContext context) => MyBottomTwoPage(
  //                   aapbarVisibility: true,
  //                 )));
  //       }
  //     } else if (_bottomNavIndex == 2) {
  //       // Navigator.pop(context);
  //       var route = ModalRoute.of(context);
  //       if (route != null) {
  //         Navigator.of(context).pushReplacement(MaterialPageRoute(
  //             builder: (BuildContext context) => MyBottomThreePage(
  //                   aapbarVisibility: true,
  //                 )));
  //       }
  //     }
  //   } else {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => const MyProfilePage()),
  //     );
  //   }
  // }

  void _onItemTapped(int index) {
    if (index != 3) {
      setState(() {
        _bottomNavIndex = index;
      });
      print("BottomCenterEnquiryPage : $_bottomNavIndex");
      if (_bottomNavIndex == 0) {
        // Navigator.pop(context);
        if (typeOfOrganization == "Farmer groups") {
          var route = ModalRoute.of(context);
          if (route != null) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) =>
                    MyBottomOnePage(
                      aapbarVisibility: true,
                    )));
          }
        } else{
          Navigator.pop(context);
          var route = ModalRoute.of(context);
          if (route != null) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) =>
                    MyHomePage(selectedIndex: 0,)));
          }
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
