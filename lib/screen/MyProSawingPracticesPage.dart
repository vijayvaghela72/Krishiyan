import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../mvc/model/CropLibraryData.dart';
import 'MyBottomCenterEnquiryPage.dart';
import 'MyBottomOnePage.dart';
import 'MyBottomThreePage.dart';
import 'MyBottomTwoPage.dart';
import 'MyEditBankDetailPage.dart';
import 'MyOtherDetailPage.dart';
import 'MyEditProfilePage.dart';
import 'MyForgotPasswordPage.dart';
import 'MyHomePage.dart';
import 'MyLoginPage.dart';
import 'MyProfilePage.dart';
import 'MySelectLanguagePage.dart';

class MyProSawingPracticesPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<List<CropLibraryData>> cropData;

  MyProSawingPracticesPage({super.key, required this.aapbarVisibility, required this.cropData});

  @override
  State<MyProSawingPracticesPage> createState() => _MyProSawingPracticesPageState();
}

class _MyProSawingPracticesPageState extends State<MyProSawingPracticesPage>
    with TickerProviderStateMixin {
  var _bottomNavIndex = 2; //default index of a first screen

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  List<bottomCategory> iconList = [
    bottomCategory(name: "Home", id: "1", icon: 'assets/images/bottom1.png'),
    bottomCategory(name: "FRM", id: "2", icon: 'assets/images/bottom2.png'),
    bottomCategory(name: "Crop", id: "3", icon: 'assets/images/bottom3.png'),
    bottomCategory(name: "Profile", id: "4", icon: 'assets/images/bottom4.png'),
  ];

  bool firstCardVisible = false;
  bool secondCardVisible = false;
  bool thirdCardVisible = false;
  bool fourthCardVisible = false;

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
      backgroundColor: Colors.white,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
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
                  const Text(
                    "Go Back",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'poppins-medium',
                        fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            const Center(
              child: Text(
                "Pre-sowing practices",
                softWrap: true,
                style: TextStyle(
                    color: Color(0xFF3FC041),
                    fontSize: 20,
                    fontFamily: 'poppins-medium'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //1st
            FutureBuilder<List<CropLibraryData>>(
              future: widget.cropData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (firstCardVisible) {
                                  firstCardVisible = false;
                                } else {
                                  firstCardVisible = true;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.all(17),
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor: const Color(0xFF02792A),
                              shape:
                              firstCardVisible ?
                              const RoundedRectangleBorder(borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(17), topRight: Radius.circular(17),
                              )) :
                              const RoundedRectangleBorder(borderRadius:
                              BorderRadius.all(Radius.circular(17),)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Land Preparation',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'poppins-medium'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Image.asset(
                                          'assets/images/down_arrow_white.png',
                                          height: 20, width: 20,
                                          // color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      firstCardVisible ?
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF02792A),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(17.0), bottomRight: Radius.circular(17.0))
                          ),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 20.0),
                                        child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xFFd3d3d3),
                                                        width: 1),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Color(0xFFd3d3d3),
                                                      )
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                top: 20.0,
                                                                right: 10.0,
                                                                left: 10.0),
                                                        child: Text(
                                                          snapshot
                                                                  .data![index]
                                                                  .presowingPractices!
                                                                  .landPreparation ??
                                                              "",
                                                          softWrap: true,
                                                          style: const TextStyle(
                                                              // color: Color(0xFF666666),
                                                              color: Colors.black,
                                                              fontSize: 11,
                                                              fontFamily:
                                                                  'poppins-regular'),
                                                        ),
                                                      ),
                                                    ),
                                                    // SizedBox(
                                                    //   height: 10.0,
                                                    // ),
                                                    // Flexible(
                                                    //   child: Padding(
                                                    //     padding: EdgeInsets.only(right: 10.0, left: 10.0),
                                                    //     child: Text(
                                                    //       "2. 4-5 deep plaughing is recommended before sowing.",
                                                    //       softWrap: true,
                                                    //       style: TextStyle(
                                                    //         // color: Color(0xFF666666),
                                                    //           color: Colors.black,
                                                    //           fontSize: 11,
                                                    //           fontFamily: 'poppins-regular'),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    // Flexible(
                                                    //   child: Padding(
                                                    //     padding: EdgeInsets.only(
                                                    //         top: 10.0, right: 10.0, left: 10.0),
                                                    //     child: Text(
                                                    //       "3. Apply Farmyard Manure @ 6-7 q/acre 1 day Prior to Showing",
                                                    //       softWrap: true,
                                                    //       style: TextStyle(
                                                    //         // color: Color(0xFF666666),
                                                    //           color: Colors.black,
                                                    //           fontSize: 11,
                                                    //           fontFamily: 'poppins-regular'),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    // Flexible(
                                                    //   child: Padding(
                                                    //     padding: EdgeInsets.only(
                                                    //         top: 10.0, right: 10.0, left: 10.0),
                                                    //     child: Text(
                                                    //       "4. Apply NPK- 50-25-20 in ratio and zinc 10kg/acre",
                                                    //       softWrap: true,
                                                    //       style: TextStyle(
                                                    //         // color: Color(0xFF666666),
                                                    //           color: Colors.black,
                                                    //           fontSize: 11,
                                                    //           fontFamily: 'poppins-regular'),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    SizedBox(
                                                      height: 20.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      )),
                                );
                              }),
                        ),
                      ) : Container(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(
              height: 5,
            ),

            //2nd
            FutureBuilder<List<CropLibraryData>>(
              future: widget.cropData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (secondCardVisible) {
                                  secondCardVisible = false;
                                } else {
                                  secondCardVisible = true;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.all(17),
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor: const Color(0xFF02792A),
                              shape:
                              secondCardVisible ?
                              const RoundedRectangleBorder(borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(17), topRight: Radius.circular(17),
                              )) :
                              const RoundedRectangleBorder(borderRadius:
                              BorderRadius.all(Radius.circular(17),)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Seed Treatment',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'poppins-medium'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Image.asset(
                                          'assets/images/down_arrow_white.png',
                                          height: 20, width: 20,
                                          // color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      secondCardVisible ?
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF02792A),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(17.0), bottomRight: Radius.circular(17.0))
                          ),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 20.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: const Color(
                                                      0xFFd3d3d3),
                                                  width: 1),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xFFd3d3d3),
                                                )
                                              ],
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15)),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              const Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20.0, right: 10.0, left: 10.0),
                                                  child: Text(
                                                    "Name of the Chemical and Methodology",
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      // color: Color(0xFF666666),
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontFamily: 'poppins-semibold'),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                                  child: Text(
                                                    snapshot.data![index].presowingPractices!.
                                                    seedTreatment!.nameOfChemical ?? "",
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                      // color: Color(0xFF666666),
                                                        color: Colors.black,
                                                        fontSize: 11,
                                                        fontFamily: 'poppins-regular'),
                                                  ),
                                                ),
                                              ),
                                              const Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0, right: 10.0, left: 10.0),
                                                  child: Text(
                                                    "Dosage",
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      // color: Color(0xFF666666),
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontFamily: 'poppins-semibold'),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 10.0, right: 10.0, left: 10.0),
                                                  child: Text(
                                                    snapshot.data![index].presowingPractices!.
                                                    seedTreatment!.dosage ?? "",
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                      // color: Color(0xFF666666),
                                                        color: Colors.black,
                                                        fontSize: 11,
                                                        fontFamily: 'poppins-regular'),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10,)
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                              }),
                        ),
                      ) : Container(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(
              height: 5,
            ),

            //3rd
            FutureBuilder<List<CropLibraryData>>(
              future: widget.cropData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (thirdCardVisible) {
                                  thirdCardVisible = false;
                                } else {
                                  thirdCardVisible = true;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.all(17),
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor: const Color(0xFF02792A),
                              shape:
                              thirdCardVisible ?
                              const RoundedRectangleBorder(borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(17), topRight: Radius.circular(17),
                              )) :
                              const RoundedRectangleBorder(borderRadius:
                              BorderRadius.all(Radius.circular(17),)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Intercultural Operation',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'poppins-medium'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Image.asset(
                                          'assets/images/down_arrow_white.png',
                                          height: 20, width: 20,
                                          // color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      thirdCardVisible ?
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF02792A),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(17.0), bottomRight: Radius.circular(17.0))
                          ),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                String interculturalOperations =  snapshot.data![index].presowingPractices!.
                                interculturalOperations.toString();

                                return Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 20.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: const Color(
                                                      0xFFd3d3d3),
                                                  width: 1),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xFFd3d3d3),
                                                )
                                              ],
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15)),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 20.0, right: 10.0, left: 10.0),
                                                  child: Text(
                                                    interculturalOperations.substring(1, interculturalOperations.length-1) ?? "",
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                      // color: Color(0xFF666666),
                                                        color: Colors.black,
                                                        fontSize: 11,
                                                        fontFamily: 'poppins-regular'),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                              }),
                        ),
                      ) : Container(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(
              height: 5,
            ),

            //4th
            FutureBuilder<List<CropLibraryData>>(
              future: widget.cropData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (fourthCardVisible) {
                                  fourthCardVisible = false;
                                } else {
                                  fourthCardVisible = true;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.all(17),
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor: const Color(0xFF02792A),
                              shape:
                              fourthCardVisible ?
                              const RoundedRectangleBorder(borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(17), topRight: Radius.circular(17),
                              )) :
                              const RoundedRectangleBorder(borderRadius:
                              BorderRadius.all(Radius.circular(17),)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Soil Condition',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'poppins-medium'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Image.asset(
                                          'assets/images/down_arrow_white.png',
                                          height: 20, width: 20,
                                          // color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      fourthCardVisible ?
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF02792A),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(17.0), bottomRight: Radius.circular(17.0))
                          ),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0,),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 20.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: const Color(
                                                      0xFFd3d3d3),
                                                  width: 1),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xFFd3d3d3),
                                                )
                                              ],
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15)),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 20.0, right: 10.0, left: 10.0),
                                                  child: Text(
                                                      snapshot.data![index].presowingPractices!.
                                                      soilConditions ?? "",
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                      // color: Color(0xFF666666),
                                                        color: Colors.black,
                                                        fontSize: 11,
                                                        fontFamily: 'poppins-regular'),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                              }),
                        ),
                      ) : Container(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
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
      ),
    );
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
      print("Profile : bottomNavIndex : $_bottomNavIndex");
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
