import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:page_transition/page_transition.dart';

import '../localization/AppLocalizations.dart';
import 'MyBottomCenterEnquiryPage.dart';
import 'MyBottomOnePage.dart';
import 'MyBottomThreePage.dart';
import 'MyCropCultivationPage.dart';
import 'MyDrawer.dart';
import 'MyFarmerProfile.dart';
import 'MyProfilePage.dart';
import 'MySelectLanguagePage.dart';

class MyBottomTwoPage extends StatefulWidget {
  bool aapbarVisibility;

  MyBottomTwoPage({super.key, required this.aapbarVisibility});

  @override
  State<MyBottomTwoPage> createState() => _MyBottomTwoPageState();
}

class _MyBottomTwoPageState extends State<MyBottomTwoPage>
    with TickerProviderStateMixin {
  final List<String> topData = [
    buildTranslate("farmerDashboard")!,
    buildTranslate("farmerRegistration")!,
    buildTranslate("cropCultivation")!,
    buildTranslate("insights")!
  ];

  var _bottomNavIndex = 1; //default index of a first screen

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

  TextEditingController? controller;
  int selectedTopData = 0;
  TextEditingController? naneController;
  bool otpVisible = false;

  final List<String> cropItems = [
    buildTranslate("all")!,
    buildTranslate("maize")!,
    buildTranslate("paddy")!,
  ];

  final List<String> villageItems = [
    buildTranslate("all")!,
    buildTranslate('ganapathy')!,
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
  bool showCropDataFlag1 = false;
  bool showCropDataFlag2 = false;
  bool searchCropsFlag = false;
  final List<String> items = [
    buildTranslate('organic')!,
    buildTranslate('inOrganic')!,
  ];
  String? selectedItemValue;

  final List<String> sortItems = [
    buildTranslate("highExpYield")!,
    buildTranslate("lowExpYield")!,
  ];

  String? selectedSortItemsValue;

  @override
  void initState() {
    super.initState();
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xFFd3d3d3), width: 1),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  buildTranslate("searchBy")!,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'poppins-regular'),
                                ),
                              ),
                              Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        alignLabelWithHint: true,
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFd3d3d3),
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        hintText: buildTranslate('mobileNumberOrCrop'),
                                        hintStyle: const TextStyle(color: Colors.black),
                                      ),
                                      validator: (value) => value!.isEmpty
                                          ? 'Please, fill this field.'
                                          : null,
                                      controller: controller,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              buildTranslate("allFarmers(300)")!,
                              softWrap: true,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                  fontFamily: 'poppins-semibold'),
                            ),
                            const Spacer(),
                            InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.leftToRight,
                                      child: const MyDrawer(),
                                    ),
                                  );
                                },
                                child: Image.asset('assets/images/filter.png')),
                          ],
                        ),
                      ),

                      // user card
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, right: 20.0, left: 20.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFFe7e7e7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, right: 15.0, left: 15.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      height: 50.0,
                                      width: 50.0,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/profile_image.png"),
                                              fit: BoxFit.cover)),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    const Flexible(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Shaikh Hamid",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Color(0xFF808080),
                                                fontSize: 15,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                          Text(
                                            "Shelter Apartment Ahmadabad India",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Color(0xFF959595),
                                                fontSize: 11,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                          Text(
                                            "+91-9856325698",
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 8.0,
                                    bottom: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          showCropDataFlag1 = true;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            buildTranslate("showCropData")!,
                                            softWrap: true,
                                            style: const TextStyle(
                                              color: Color(0XFF008000),
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  Color(0XFF008000),
                                            ),
                                          ),
                                          Image.asset(
                                              'assets/images/dropdown_arrow.png'),
                                        ],
                                      ),
                                    )),
                                    const VerticalDivider(width: 1.0),
                                    Expanded(
                                        child: Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MyFarmerProfilePage()),
                                          );
                                        },
                                        child: Text(
                                          buildTranslate("editProfile")!,
                                          softWrap: true,
                                          style: const TextStyle(
                                            color: Color(0XFF008000),
                                            fontSize: 15,
                                            fontFamily: 'poppins-semibold',
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Color(0XFF008000),
                                          ),
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: showCropDataFlag1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 20.0,
                                      bottom: 12.0),
                                  child: Text(
                                    buildTranslate("cropCultivations")!,
                                    softWrap: true,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontFamily: 'poppins-semibold',
                                      decorationColor: Color(0XFF008000),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showCropDataFlag1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 15.0, bottom: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Expanded(
                                          child: Row(
                                        children: [
                                          Text(
                                            "1:Maze",
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Stage: \nFlowering",
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                        ],
                                      )),
                                      const VerticalDivider(width: 1.0),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyCropCultivationPage()));
                                          },
                                          child: Text(
                                            buildTranslate("editCropData")!,
                                            softWrap: true,
                                            style: const TextStyle(
                                              color: Color(0XFF008000),
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showCropDataFlag1,
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Divider(
                                    color: Colors.black,
                                    thickness: 1,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showCropDataFlag1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 15.0, bottom: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Expanded(
                                          child: Row(
                                        children: [
                                          Text(
                                            "2:Maze",
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Stage: \nFlowering",
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                        ],
                                      )),
                                      const VerticalDivider(width: 1.0),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyCropCultivationPage()));
                                          },
                                          child: Text(
                                            buildTranslate("editCropData")!,
                                            softWrap: true,
                                            style: const TextStyle(
                                              color: Color(0XFF008000),
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showCropDataFlag1,
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Divider(
                                    color: Colors.black,
                                    thickness: 1,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showCropDataFlag1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 15.0, bottom: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Expanded(
                                          child: Row(
                                        children: [
                                          Text(
                                            "3:Maze",
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Stage: \nFlowering",
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                        ],
                                      )),
                                      const VerticalDivider(width: 1.0),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyCropCultivationPage()));
                                          },
                                          child: Text(
                                            buildTranslate("editCropData")!,
                                            softWrap: true,
                                            style: const TextStyle(
                                              color: Color(0XFF008000),
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              showCropDataFlag1
                                  ? const SizedBox(
                                      height: 10,
                                    )
                                  : Container(),
                              Visibility(
                                visible: showCropDataFlag1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 8.0,
                                      bottom: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: InkWell(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0XFF3FC041),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0XFF3FC041),
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18)),
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                buildTranslate(
                                                    "showMoreCrops")!,
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'poppins-regular'),
                                              ),
                                            ),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              highlightColor:
                                                  Colors.transparent,
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MyCropCultivationPage()));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0XFF3FC041),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0XFF3FC041),
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18)),
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  buildTranslate(
                                                      "addNewCultivations")!,
                                                  softWrap: true,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontFamily:
                                                        'poppins-regular',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, right: 20.0, left: 20.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFFe7e7e7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, right: 15.0, left: 15.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      height: 50.0,
                                      width: 50.0,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/profile_image.png"),
                                              fit: BoxFit.cover)),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    const Flexible(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Shaikh Hamid",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Color(0xFF808080),
                                                fontSize: 15,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                          Text(
                                            "Shelter Apartment Ahmadabad India",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: Color(0xFF959595),
                                                fontSize: 11,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                          Text(
                                            "+91-9856325698",
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 8.0,
                                    bottom: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          showCropDataFlag2 = true;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            buildTranslate("showCropData")!,
                                            softWrap: true,
                                            style: const TextStyle(
                                              color: Color(0XFF008000),
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  Color(0XFF008000),
                                            ),
                                          ),
                                          Image.asset(
                                              'assets/images/dropdown_arrow.png'),
                                        ],
                                      ),
                                    )),
                                    const VerticalDivider(width: 1.0),
                                    Expanded(
                                        child: Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MyFarmerProfilePage()),
                                          );
                                        },
                                        child: Text(
                                          buildTranslate("editProfile")!,
                                          softWrap: true,
                                          style: const TextStyle(
                                            color: Color(0XFF008000),
                                            fontSize: 15,
                                            fontFamily: 'poppins-semibold',
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Color(0XFF008000),
                                          ),
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: showCropDataFlag2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 20.0,
                                      bottom: 12.0),
                                  child: Text(
                                    buildTranslate("cropCultivations")!,
                                    softWrap: true,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontFamily: 'poppins-semibold',
                                      decorationColor: Color(0XFF008000),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showCropDataFlag2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 15.0, bottom: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Expanded(
                                          child: Row(
                                        children: [
                                          Text(
                                            "1:Maze",
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Stage: \nFlowering",
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                        ],
                                      )),
                                      const VerticalDivider(width: 1.0),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyCropCultivationPage()));
                                          },
                                          child: Text(
                                            buildTranslate("editCropData")!,
                                            softWrap: true,
                                            style: const TextStyle(
                                              color: Color(0XFF008000),
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showCropDataFlag2,
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Divider(
                                    color: Colors.black,
                                    thickness: 1,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showCropDataFlag2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 15.0, bottom: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Expanded(
                                          child: Row(
                                        children: [
                                          Text(
                                            "2:Maze",
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Stage: \nFlowering",
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                        ],
                                      )),
                                      const VerticalDivider(width: 1.0),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyCropCultivationPage()));
                                          },
                                          child: Text(
                                            buildTranslate("editCropData")!,
                                            softWrap: true,
                                            style: const TextStyle(
                                              color: Color(0XFF008000),
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showCropDataFlag2,
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Divider(
                                    color: Colors.black,
                                    thickness: 1,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: showCropDataFlag2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 15.0, bottom: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Expanded(
                                          child: Row(
                                        children: [
                                          Text(
                                            "3:Maze",
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Stage: \nFlowering",
                                            softWrap: true,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                        ],
                                      )),
                                      const VerticalDivider(width: 1.0),
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyCropCultivationPage()));
                                          },
                                          child: Text(
                                            buildTranslate("editCropData")!,
                                            softWrap: true,
                                            style: const TextStyle(
                                              color: Color(0XFF008000),
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold',
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              showCropDataFlag2
                                  ? const SizedBox(
                                      height: 10,
                                    )
                                  : Container(),
                              Visibility(
                                visible: showCropDataFlag2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 8.0,
                                      bottom: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: InkWell(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0XFF3FC041),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0XFF3FC041),
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18)),
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                buildTranslate(
                                                    "showMoreCrops")!,
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'poppins-regular'),
                                              ),
                                            ),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              highlightColor:
                                                  Colors.transparent,
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MyCropCultivationPage()));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0XFF3FC041),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0XFF3FC041),
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18)),
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  buildTranslate(
                                                      "addNewCultivations")!,
                                                  softWrap: true,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontFamily:
                                                        'poppins-regular',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : selectedTopData == 1
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              buildTranslate("farmerRegistration")!,
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

                          // name
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("name")!,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF666666),
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  fillColor: Colors.white,
                                  filled: true,
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  hintText: buildTranslate("enterName")!,
                                  hintStyle:
                                      const TextStyle(color: Color(0xFFe7e7e7)),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 0.5),
                                  )),
                              validator: (value) => value!.isEmpty
                                  ? 'Please, fill this field.'
                                  : null,
                              controller: naneController,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // whats app number
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("whatsappNumber")!,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF666666),
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                enabled: true,
                                alignLabelWithHint: true,
                                fillColor: Colors.white,
                                filled: true,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                hintText: buildTranslate('enterMobileNumber')!,
                                hintStyle:
                                    const TextStyle(color: Color(0xFFe7e7e7)),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                                suffixIcon: Container(
                                  margin: const EdgeInsets.all(5),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(80, 40),
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(fontSize: 18),
                                      backgroundColor: const Color(0xFF3FC041),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    child: Text(
                                      buildTranslate("getOTP")!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: "poppins-regular",
                                          fontSize: 15.0),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        otpVisible = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? 'Please, fill this field.'
                                  : null,
                              controller: controller,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // verify otp
                          otpVisible
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0),
                                  child: Text(
                                    buildTranslate("verifyOtp")!,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF666666),
                                        fontFamily: 'poppins-semibold'),
                                  ),
                                )
                              : Container(),
                          otpVisible
                              ? const SizedBox(
                                  height: 20,
                                )
                              : Container(),
                          otpVisible
                              ? OtpTextField(
                                  numberOfFields: 4,
                                  borderColor: const Color(0xFF3dc33b),
                                  //set to true to show as box or false to show as dash
                                  showFieldAsBox: true,
                                  filled: true,
                                  fieldWidth: 60,
                                  //runs when a code is typed in
                                  onCodeChanged: (String code) {
                                    //handle validation or checks here
                                  },
                                  //runs when every textfield is filled
                                  onSubmit: (String verificationCode) {
                                    // showDialog(
                                    //     context: context,
                                    //     builder: (context){
                                    //       return AlertDialog(
                                    //         title: Text("Verification Code"),
                                    //         content: Text('Code entered is $verificationCode'),
                                    //       );
                                    //     }
                                    // );
                                  }, // end onSubmit
                                )
                              : Container(),

                          const SizedBox(
                            height: 25,
                          ),

                          Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const MyFarmerProfilePage()));
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(12),
                                  textStyle: const TextStyle(fontSize: 18),
                                  backgroundColor: const Color(0xFF3FC041),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12), // <-- Radius
                                  ),
                                ),
                                child: Text(
                                  buildTranslate('SUBMIT')!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'poppins-medium'),
                                ),
                              )),
                        ],
                      )
                    : selectedTopData == 2
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  buildTranslate("cropCultivation")!,
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

                              // crops
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("crops")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      fillColor: Colors.white,
                                      filled: true,
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
                                      hintText:
                                          buildTranslate("enterCropsName")!,
                                      hintStyle: const TextStyle(
                                          color: Color(0xFFe7e7e7)),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 0.5),
                                      )),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please, fill this field.'
                                      : null,
                                  controller: naneController,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // varity
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("variety")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      fillColor: Colors.white,
                                      filled: true,
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
                                      hintText: buildTranslate("enterVariety")!,
                                      hintStyle: const TextStyle(
                                          color: Color(0xFFe7e7e7)),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 0.5),
                                      )),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please, fill this field.'
                                      : null,
                                  controller: naneController,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // date
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("dateOfSowing")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      alignLabelWithHint: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      hintText: 'dd/mm/yyyy',
                                      hintStyle:
                                          TextStyle(color: Color(0xFFe7e7e7)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 0.5),
                                      )),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please, fill this field.'
                                      : null,
                                  controller: naneController,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // goe location
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("geoLocation")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      alignLabelWithHint: true,
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      hintText: '----',
                                      hintStyle:
                                          TextStyle(color: Color(0xFFe7e7e7)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 0.5),
                                      )),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please, fill this field.'
                                      : null,
                                  controller: naneController,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // type of cultivation practice
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("typeofCultivationPractice")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Container(
                                  color: Colors.white,
                                  child: DropdownButtonFormField2<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      // Add more decoration..
                                    ),
                                    hint: const Text(
                                      '--',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    items: items
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey),
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
                                      iconSize: 24,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // area in arcs
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("areaInAcres")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      alignLabelWithHint: true,
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      hintText: 'Enter area in acres',
                                      hintStyle:
                                          TextStyle(color: Color(0xFFe7e7e7)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 0.5),
                                      )),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please, fill this field.'
                                      : null,
                                  controller: naneController,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // geo link in area
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("geoLinkAreaOnMap")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      alignLabelWithHint: true,
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      hintText: '----',
                                      hintStyle:
                                          TextStyle(color: Color(0xFFe7e7e7)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 0.5),
                                      )),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please, fill this field.'
                                      : null,
                                  controller: naneController,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              SizedBox(
                                height: 40,
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 25.0,
                                      ),
                                      label: Text(buildTranslate("addCrop")!),
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            const Color(0xFF3FC041),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    )
                                    // ElevatedButton(
                                    //   onPressed: () {
                                    //
                                    //   },
                                    //   style: ElevatedButton.styleFrom(
                                    //     foregroundColor: Colors.white,
                                    //     padding: const EdgeInsets.all(22),
                                    //     textStyle: const TextStyle(fontSize: 18),
                                    //     backgroundColor: const Color(0xFF3FC041),
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.circular(12), // <-- Radius
                                    //     ),
                                    //   ),
                                    //   child: const Text('Add Crop', style: TextStyle(fontSize: 18,
                                    //       fontFamily: 'poppins-medium'),),
                                    // ),
                                    ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0),
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(12),
                                      textStyle: const TextStyle(fontSize: 18),
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
                                height: 40,
                              ),
                            ],
                          )
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
                                                      isExpanded: true,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        // Add more decoration..
                                                      ),
                                                      hint: Text(
                                                        buildTranslate(
                                                            "selectCrops")!,
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      items: cropItems
                                                          .map((item) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value: item,
                                                                child: Text(
                                                                  item,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
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
                                                        selectedCropItemValue =
                                                            value.toString();
                                                      },
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
                                                      isExpanded: true,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        // Add more decoration..
                                                      ),
                                                      hint: Text(
                                                        buildTranslate(
                                                            'selectVillages')!,
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      items: villageItems
                                                          .map((item) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value: item,
                                                                child: Text(
                                                                  item,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
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
                                                        selectedVillageItemValue =
                                                            value.toString();
                                                      },
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
                                              listWidget(),
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
                                                child: Text(
                                                  buildTranslate(
                                                      "Farmers(300)")!,
                                                  softWrap: true,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily:
                                                          'poppins-semibold'),
                                                ),
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
                                                    // Add more decoration..
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
                                                  // customButton: Align(
                                                  //     alignment: Alignment.centerRight,
                                                  //     child: Image.asset('assets/images/sortBy.png', height: 20, width: 20,)),
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
                                                  // iconStyleData: IconStyleData(
                                                  //   openMenuIcon: Image.asset('assets/images/sortBy.png', height: 20, width: 20,),
                                                  //   // icon: Icon(
                                                  //   //   Icons.arrow_drop_down,
                                                  //   //   color: Colors.black45,
                                                  //   // ),
                                                  //   iconSize: 0,
                                                  // ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // InkWell(
                                            //     onTap: () {
                                            //       // Navigator.of(context).push(
                                            //       //   MaterialPageRoute(builder: (context) => MyDrawer()),
                                            //       // );
                                            //     },
                                            //     child: Container(
                                            //       decoration: BoxDecoration(
                                            //         borderRadius: BorderRadius.circular(5),
                                            //         color: Colors.white,
                                            //         border: Border.all(
                                            //             color: Colors.grey,
                                            //             width: 1,
                                            //         ),
                                            //       ),
                                            //       child: Padding(
                                            //         padding: const EdgeInsets.all(8.0),
                                            //         child: Row(
                                            //           children: [
                                            //             const Text("sort by", style: TextStyle(fontSize: 17.0,
                                            //             fontFamily: "poppins-regular", color: Color(0xFF666666)),),
                                            //             Image.asset('assets/images/sortBy.png', height: 20, width: 20,),
                                            //           ],
                                            //         ),
                                            //       ),
                                            //     )),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      // buildTable(context)
                                      _buildHeaderTable(),
                                      buildTable(context)
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
              onPressed: () {},
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
                      width: 30,
                      height: 30,
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
            )
          : null,
      // drawer: MyDrawer(),
    );
  }

  void _onItemTapped(int index) {
    // if (index != 3) {
    //   setState(() {
    //     _bottomNavIndex = index;
    //   });
    //   print("BottomTwoPage : $_bottomNavIndex");
    //   if (_bottomNavIndex == 0) {
    //     // Navigator.pop(context);
    //     var route = ModalRoute.of(context);
    //     if (route != null) {
    //       Navigator.of(context).pushReplacement(MaterialPageRoute(
    //           builder: (BuildContext context) => MyBottomOnePage(
    //                 aapbarVisibility: true,
    //               )));
    //     }
    //   } else if (_bottomNavIndex == 1) {
    //     // Navigator.pop(context);
    //     var route = ModalRoute.of(context);
    //     if (route != null) {
    //       Navigator.of(context).pushReplacement(MaterialPageRoute(
    //           builder: (BuildContext context) => MyBottomTwoPage(
    //                 aapbarVisibility: true,
    //               )));
    //     }
    //   } else if (_bottomNavIndex == 2) {
    //     // Navigator.pop(context);
    //     var route = ModalRoute.of(context);
    //     if (route != null) {
    //       Navigator.of(context).pushReplacement(MaterialPageRoute(
    //           builder: (BuildContext context) => MyBottomThreePage(
    //                 aapbarVisibility: true,
    //               )));
    //     }
    //   }
    // }
    // else if(index == 3){
    //   Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => const MyProfilePage()),
    //   );
    // }
    // else{
    //   var route = ModalRoute.of(context);
    //   if (route != null) {
    //     Navigator
    //         .of(context)
    //         .pushReplacement(
    //         MaterialPageRoute(builder: (BuildContext context) =>
    //             MyBottomCenterEnquiryPage(aapbarVisibility: true,)));
    //   }
    // }

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
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MyProfilePage()),
      );
    } else if (index == 4) {
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => MyBottomCenterEnquiryPage(
                  aapbarVisibility: true,
                )));
      }
    } else {
      setState(() {
        _bottomNavIndex = index;
      });
      print("Two : bottomNavIndex : $_bottomNavIndex");
    }
  }

  void _onSelectedTopDataTapped(int index) {
    setState(() {
      selectedTopData = index;
    });
    print("Selected Top Page : $selectedTopData");
  }

  Widget listWidget() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: search_crops.length,
      itemBuilder: (_, index) {
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
                setState(() {
                  selectedTopData = 4;
                });
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
                        search_crops[index].name ?? "",
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

  Widget buildTable(BuildContext context) {
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
            // Allows to add a border decoration around your table
            children: const [
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Raju',
                    style: TextStyle(
                        fontFamily: "poppins-semibold", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '123456789',
                    style: TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '25930',
                    style: TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Ankit',
                    style: TextStyle(
                        fontFamily: "poppins-semibold", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '123456789',
                    style: TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '25930',
                    style: TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Mohedin',
                    style: TextStyle(
                        fontFamily: "poppins-semibold", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '123456789',
                    style: TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '25930',
                    style: TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'jhon',
                    style: TextStyle(
                        fontFamily: "poppins-semibold", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '123456789',
                    style: TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '25930',
                    style: TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'jemisom',
                    style: TextStyle(
                        fontFamily: "poppins-semibold", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '123456789',
                    style: TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '25930',
                    style: TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
              ]),
            ]),
      ),
      // DataTable(
      //   decoration: BoxDecoration(
      //       border: Border.all(
      //         width: 1,
      //         color: Colors.black,
      //       )
      //   ),
      //   columns: const <DataColumn>[
      //     DataColumn(label: Text("Name", textAlign: TextAlign.center)),
      //     DataColumn(label: VerticalDivider()),
      //     DataColumn(label: Text("Mobile \nNumber", textAlign: TextAlign.center)),
      //     DataColumn(label: VerticalDivider()),
      //     DataColumn(label: Text("Expected \nYield(in Qut)", textAlign: TextAlign.center)),
      //   ],
      //   rows: const <DataRow>[
      //     DataRow(
      //       cells: <DataCell>[
      //         DataCell(Text('Soccer')),
      //         DataCell(VerticalDivider()),
      //         DataCell(Text("11")),
      //         DataCell(VerticalDivider()),
      //         DataCell(Text("11")),
      //       ],
      //     ),
      //     DataRow(
      //       cells: <DataCell>[
      //         DataCell(Text('Soccer')),
      //         DataCell(VerticalDivider()),
      //         DataCell(Text("11")),
      //         DataCell(VerticalDivider()),
      //         DataCell(Text("11")),
      //       ],
      //     ),
      //   ],
      // ),
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
