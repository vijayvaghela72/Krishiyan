import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../mvc/model/CropLibraryData.dart';
import 'MyBottomCenterEnquiryPage.dart';
import 'MyBottomOnePage.dart';
import 'MyBottomThreePage.dart';
import 'MyBottomTwoPage.dart';
import 'MyDeficiencyManagementPage.dart';
import 'MyDiseaseManagementPage.dart';
import 'MyGeneralInformationPage.dart';
import 'MyHarvestPage.dart';
import 'MyNutrientManagmentPage.dart';
import 'MyPestManagementPage.dart';
import 'MyProfilePage.dart';
import 'MySelectLanguagePage.dart';
import 'MyVeritiesPage.dart';
import 'MyWeatherInjuriesPage.dart';
import 'MyWeedManagementPage.dart';

class MyCropProtectionPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<List<CropLibraryData>?> cropData;

  MyCropProtectionPage({super.key, required this.aapbarVisibility , required this.cropData});

  @override
  State<MyCropProtectionPage> createState() => _MyCropProtectionPageState();
}

class _MyCropProtectionPageState extends State<MyCropProtectionPage>
    with TickerProviderStateMixin {

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;
  var _bottomNavIndex = 2; //default index of a first screen

  List<bottomCategory> iconList = [
    bottomCategory(
        name: "Home", id: "1", icon: 'assets/images/bottom1.png'),
    bottomCategory(
        name: "FRM",
        id: "2",
        icon: 'assets/images/bottom2.png'),
    bottomCategory(
        name: "Crop",
        id: "3",
        icon: 'assets/images/bottom3.png'),
    bottomCategory(
        name: "Profile",
        id: "4",
        icon: 'assets/images/bottom4.png'),
  ];

  final List<String> items = [
    'Maize',
    'Coriander',
    'Soya',
  ];

  String? selectedItemValue;

  List<Entity> ORG_Entity = [
    Entity(
      name: "Pest \nManagement",
      id: "1",
    ),
    Entity(
      name: "Disease \nManagement",
      id: "2",
    ),
    Entity(
      name: "Deficiency \nSymptoms",
      id: "3",
    ),
    Entity(
      name: "Weed \nManagement",
      id: "4",
    ),
    Entity(
      name: "Weather \nInjuries",
      id: "5",
    ),
  ];
  bool showSelectedItemValue = false;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 15,
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
                  const SizedBox(width: 10,),
                  const Text(
                    "Go Back",
                    style: TextStyle(color: Colors.black, fontFamily: 'poppins-medium',
                        fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),

            const Center(
              child: Text("Crop Protection",
                softWrap: true,
                style: TextStyle(
                    color: Color(0xFF3FC041),
                    fontSize: 20,
                    fontFamily: 'poppins-medium'),
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            listWidget(),
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
          final color = isActive
              ? Colors.green
              : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconList[index].icon ?? "",
                color: color,
                width: 25, height: 25,
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
    // if (index != 3) {
    //   setState(() {
    //     _bottomNavIndex = index;
    //   });
    //   print("BottomTwoPage : $_bottomNavIndex");
    //   if (_bottomNavIndex == 0) {
    //     Navigator.pop(context);
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
        Navigator
            .of(context)
            .pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) =>
                MyBottomOnePage(aapbarVisibility: true,)));
      }
    }
    else if(index ==1) {
      // Navigator.pop(context);
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator
            .of(context)
            .pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) =>
                MyBottomTwoPage(aapbarVisibility: true,)));
      }
    }
    else if(index ==2) {
      // Navigator.pop(context);
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator
            .of(context)
            .pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) =>
                MyBottomThreePage(aapbarVisibility: true,)));
      }
    }
    else if(index == 3){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MyProfilePage()),
      );
    }
    else if(index == 4){
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator
            .of(context)
            .pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) =>
                MyBottomCenterEnquiryPage(aapbarVisibility: true,)));
      }
    }

    else {
      setState(() {
        _bottomNavIndex = index;
      });
      print("Three : bottomNavIndex : $_bottomNavIndex");
    }
  }

  Widget listWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ORG_Entity.length,
        itemBuilder: (_, index) {
          return
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color(0xFFd3d3d3), width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFd3d3d3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    if(ORG_Entity[index].name == "Pest \nManagement"){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>
                            MyPestManagementPage(aapbarVisibility: true,
                                cropData : widget.cropData)),
                      );
                    }
                    else if(ORG_Entity[index].name == "Disease \nManagement"){
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (context) =>
                      //       MyDiseaseManagementPage(aapbarVisibility: true, cropData : widget.cropData)),
                      // );
                    }
                    else if(ORG_Entity[index].name == "Deficiency \nSymptoms"){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>
                            MyDeficiencyManagementPage(aapbarVisibility: true, cropData : widget.cropData)),
                      );
                    }
                    else if(ORG_Entity[index].name == "Weed \nManagement"){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>
                            MyWeedManagementPage(aapbarVisibility: true, cropData : widget.cropData)),
                      );
                    }
                    else if(ORG_Entity[index].name == "Weather \nInjuries"){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyWeatherInjuriesPage(aapbarVisibility: true,)),
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            ORG_Entity[index].name ?? "",
                            maxLines: 3,
                            softWrap: true,
                            style: const TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 14,
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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 3),
        ),
      ),
    );
  }
}

class Entity {
  String? name;
  String? id;

  Entity({
    required this.name,
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