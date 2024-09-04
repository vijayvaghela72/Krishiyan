import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../mvc/model/CropLibraryData.dart';
import 'MyBottomCenterEnquiryPage.dart';
import 'MyBottomOnePage.dart';
import 'MyBottomThreePage.dart';
import 'MyBottomTwoPage.dart';
import 'MyProfilePage.dart';
import 'MySelectLanguagePage.dart';

class MyNutrientManagmentPage extends StatefulWidget {

  bool aapbarVisibility;
  Future<List<CropLibraryData>?> cropData;

  MyNutrientManagmentPage({super.key, required this.aapbarVisibility, required this.cropData});

  @override
  State<MyNutrientManagmentPage> createState() => _MyNutrientManagmentPageState();
}

class _MyNutrientManagmentPageState extends State<MyNutrientManagmentPage> with TickerProviderStateMixin {

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

  List<Nutrient> ORG_Nutrient = [
    Nutrient(
        id: "1",
        name: "NITROGEN",
        dosage: "Dosage: 60-70 kg/acre",
        description: "Applied in 3 Stages: \n1. At Sowing \n2. At Knee-high \n3. At Tasselling",
        methodOfApplication: "    Applied in furrow at different stages Neem oil coated urea (NOCU) recommended for highly yield.return and nitrogen use efficiency in kharif maize."
    ),
    Nutrient(
        id: "2",
        name: "PHOSPHORUS",
        dosage: "Dosage: 24-25 kg/acre",
        description: "100% basal at the time of sowing",
        methodOfApplication: "    Entire dosage is applied at root zone."
    ),
    Nutrient(
        id: "3",
        name: "POTASH",
        dosage: "Dosage: 16-17 kg/acre",
        description: "100% basal at the time of sowing",
        methodOfApplication: "    Entire dosage is applied at root zone."
    ),
    Nutrient(
        id: "4",
        name: "ZINC",
        dosage: "Dosage: 12-13 kg/acre",
        description: "100% basal at the time of sowing",
        methodOfApplication: "    Entire dosage is applied at root zone."
    ),
  ];

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
                "Nutrient-Management",
                softWrap: true,
                style: TextStyle(
                    color: Color(0xFF3FC041),
                    fontSize: 20,
                    fontFamily: 'poppins-medium'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // FutureBuilder<List<CropLibraryData>>(
            //   future: widget.cropData,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return ListView.builder(
            //           shrinkWrap: true,
            //           physics: const NeverScrollableScrollPhysics(),
            //           itemBuilder: (context, index) {
            //             return ListView.builder(
            //               itemCount: snapshot.data![index].nutrient!.length,
            //               shrinkWrap: true,
            //               physics: const NeverScrollableScrollPhysics(),
            //               itemBuilder: (context, index) {
            //                 return Padding(
            //                   padding: const EdgeInsets.only(
            //                       left: 15.0, right: 15.0, bottom: 15.0),
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                         color: Colors.white,
            //                         border: Border.all(
            //                             color: const Color(0xFFd3d3d3),
            //                             width: 1),
            //                         boxShadow: const [
            //                           BoxShadow(
            //                             color: Color(0xFFd3d3d3),
            //                           )
            //                         ],
            //                         borderRadius: BorderRadius.circular(15)),
            //                     child: InkWell(
            //                       highlightColor: Colors.transparent,
            //                       splashColor: Colors.transparent,
            //                       onTap: () {},
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         mainAxisSize: MainAxisSize.min,
            //                         children: <Widget>[
            //                           Container(
            //                               width:
            //                                   MediaQuery.of(context).size.width,
            //                               padding: const EdgeInsets.only(
            //                                 left: 15.0,
            //                                 right: 15.0,
            //                                 top: 20.0,
            //                               ),
            //                               child: ElevatedButton(
            //                                 onPressed: () {},
            //                                 style: ElevatedButton.styleFrom(
            //                                   foregroundColor: Colors.white,
            //                                   padding: const EdgeInsets.all(12),
            //                                   textStyle:
            //                                       const TextStyle(fontSize: 18),
            //                                   backgroundColor:
            //                                       const Color(0xFF1E8E27),
            //                                   shape: RoundedRectangleBorder(
            //                                     borderRadius:
            //                                         BorderRadius.circular(10),
            //                                   ),
            //                                 ),
            //                                 child: Row(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment.center,
            //                                   crossAxisAlignment:
            //                                       CrossAxisAlignment.center,
            //                                   children: [
            //                                     Image.asset(
            //                                       "assets/images/growing_seed.png",
            //                                       width: 20,
            //                                       height: 20,
            //                                     ),
            //                                     const SizedBox(
            //                                       width: 10,
            //                                     ),
            //                                     Text(
            //                                       snapshot
            //                                               .data![index]
            //                                               .nutrient![index]
            //                                               .name ??
            //                                           "",
            //                                       style: const TextStyle(
            //                                           fontSize: 14,
            //                                           fontFamily:
            //                                               'poppins-regular'),
            //                                     ),
            //                                   ],
            //                                 ),
            //                               )),
            //                           Flexible(
            //                             child: Padding(
            //                               padding: const EdgeInsets.only(
            //                                 top: 20.0,
            //                               ),
            //                               child: Center(
            //                                 child: Text(
            //                                   snapshot
            //                                           .data![index]
            //                                           .nutrient![index]
            //                                           .dosage ??
            //                                       "",
            //                                   textAlign: TextAlign.center,
            //                                   softWrap: true,
            //                                   style: const TextStyle(
            //                                       // color: Color(0xFF666666),
            //                                       color: Colors.black,
            //                                       fontSize: 14,
            //                                       fontFamily:
            //                                           'poppins-semibold'),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           Container(
            //                               width:
            //                                   MediaQuery.of(context).size.width,
            //                               padding: const EdgeInsets.only(
            //                                   left: 15.0,
            //                                   right: 15.0,
            //                                   top: 20.0),
            //                               child: ElevatedButton(
            //                                 onPressed: () {},
            //                                 style: ElevatedButton.styleFrom(
            //                                   foregroundColor: Colors.white,
            //                                   padding: const EdgeInsets.all(12),
            //                                   textStyle:
            //                                       const TextStyle(fontSize: 18),
            //                                   backgroundColor:
            //                                       const Color(0xFF1E8E27),
            //                                   shape: RoundedRectangleBorder(
            //                                     borderRadius:
            //                                         BorderRadius.circular(10),
            //                                   ),
            //                                 ),
            //                                 child: Column(
            //                                   children: [
            //                                     Align(
            //                                       alignment: Alignment.topLeft,
            //                                       child: Row(
            //                                         children: [
            //                                           Image.asset(
            //                                             "assets/images/age.png",
            //                                             width: 20,
            //                                             height: 20,
            //                                           ),
            //                                           const SizedBox(
            //                                             width: 5,
            //                                           ),
            //                                           const Text(
            //                                             'Age of Crops ',
            //                                             textAlign:
            //                                                 TextAlign.start,
            //                                             style: TextStyle(
            //                                                 fontSize: 14,
            //                                                 fontFamily:
            //                                                     'poppins-regular'),
            //                                           ),
            //                                         ],
            //                                       ),
            //                                     ),
            //                                     const SizedBox(
            //                                       height: 10,
            //                                     ),
            //                                     Align(
            //                                       alignment: Alignment.topLeft,
            //                                       child: Text(
            //                                         snapshot
            //                                                 .data![index]
            //                                                 .nutrient![index]
            //                                                 .age ??
            //                                             "",
            //                                         textAlign: TextAlign.start,
            //                                         style: const TextStyle(
            //                                             fontSize: 10,
            //                                             fontFamily:
            //                                                 'poppins-regular'),
            //                                       ),
            //                                     ),
            //                                     const SizedBox(
            //                                       height: 5,
            //                                     ),
            //                                   ],
            //                                 ),
            //                               )),
            //                           const SizedBox(
            //                             height: 20.0,
            //                           ),
            //                           const Flexible(
            //                             child: Padding(
            //                               padding: EdgeInsets.only(
            //                                   top: 10.0,
            //                                   right: 15.0,
            //                                   left: 15.0),
            //                               child: Text(
            //                                 "Method of Application",
            //                                 softWrap: true,
            //                                 style: TextStyle(
            //                                     // color: Color(0xFF666666),
            //                                     color: Colors.black,
            //                                     fontSize: 14,
            //                                     fontFamily: 'poppins-semibold'),
            //                               ),
            //                             ),
            //                           ),
            //                           Flexible(
            //                             child: Padding(
            //                               padding: const EdgeInsets.only(
            //                                   top: 10.0,
            //                                   right: 15.0,
            //                                   left: 15.0),
            //                               child: Text(
            //                                 snapshot
            //                                         .data![index]
            //                                         .nutrient![index]
            //                                         .methodApplication ??
            //                                     "",
            //                                 textAlign: TextAlign.justify,
            //                                 softWrap: true,
            //                                 style: const TextStyle(
            //                                     // color: Color(0xFF666666),
            //                                     color: Colors.black,
            //                                     fontSize: 13,
            //                                     fontFamily: 'poppins-regular'),
            //                               ),
            //                             ),
            //                           ),
            //                           const SizedBox(
            //                             height: 20,
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 );
            //               },
            //             );
            //           });
            //     } else if (snapshot.hasError) {
            //       return Text('${snapshot.error}');
            //     }
            //
            //     // By default, show a loading spinner.
            //     return const CircularProgressIndicator();
            //   },
            // ),
            ListView.builder(
              itemCount: ORG_Nutrient.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFd3d3d3), width: 1),
                          boxShadow: const [BoxShadow(color: Color(0xFFd3d3d3),)],
                          borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {

                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 20.0, ),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(12),
                                    textStyle: const TextStyle(fontSize: 18),
                                    backgroundColor: const Color(0xFF1E8E27),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/images/growing_seed.png", width: 20, height: 20,),
                                      const SizedBox(width: 10,),
                                      Text(
                                        ORG_Nutrient[index].name ?? "",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'poppins-regular'),
                                      ),
                                    ],
                                  ),
                                )),

                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0,),
                                child: Center(
                                  child: Text(
                                    ORG_Nutrient[index].dosage ?? "",
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: const TextStyle(
                                      // color: Color(0xFF666666),
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: 'poppins-semibold'),
                                  ),
                                ),
                              ),
                            ),

                            Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, top: 20.0),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(12),
                                    textStyle: const TextStyle(fontSize: 18),
                                    backgroundColor: const Color(0xFF1E8E27),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          children: [
                                            Image.asset("assets/images/age.png", width: 20, height: 20,),
                                            const SizedBox(width: 5,),
                                            const Text(
                                              'Age of Crops ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'poppins-regular'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          ORG_Nutrient[index].description ?? "",
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'poppins-regular'),
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                    ],
                                  ),
                                )),

                            const SizedBox(height: 20.0,),
                            const Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
                                child: Text(
                                  "Method of Application",
                                  softWrap: true,
                                  style: TextStyle(
                                    // color: Color(0xFF666666),
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                            ),

                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
                                child: Text(
                                  ORG_Nutrient[index].methodOfApplication ?? "",
                                  textAlign: TextAlign.justify,
                                  softWrap: true,
                                  style: const TextStyle(
                                    // color: Color(0xFF666666),
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontFamily: 'poppins-regular'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
              },
            ),
            const SizedBox(
              height: 25,
            ),
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

class Nutrient {

  String? name;
  String? id;
  String? dosage;
  String? description;
  String? methodOfApplication;

  Nutrient({
    required this.id,
    required this.name,
    required this.dosage,
    required this.description,
    required this.methodOfApplication,
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