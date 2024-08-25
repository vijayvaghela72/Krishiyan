import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../localization/AppLocalizations.dart';
import '../mvc/controller/cropController.dart';
import '../mvc/model/CropLibraryData.dart';
import 'MyBottomCenterEnquiryPage.dart';
import 'MyBottomOnePage.dart';
import 'MyBottomTwoPage.dart';
import 'MyCropProtectionPage.dart';
import 'MyFaqPage.dart';
import 'MyGeneralInformationPage.dart';
import 'MyHarvestPage.dart';
import 'MyIrrigationManagementPage.dart';
import 'MyNutrientManagmentPage.dart';
import 'MyProSawingPracticesPage.dart';
import 'MyProfilePage.dart';
import 'MySelectLanguagePage.dart';
import 'MyVeritiesPage.dart';

class MyBottomThreePage extends StatefulWidget {
  bool aapbarVisibility;

  MyBottomThreePage({super.key, required this.aapbarVisibility});

  @override
  State<MyBottomThreePage> createState() => _MyBottomThreePageState();
}

class _MyBottomThreePageState extends State<MyBottomThreePage>
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
  final List<String> items = [
    'Maize',
    'Coriander',
    'Soya',
  ];

  String? selectedItemValue;
  List<Entity> ORG_Entity = [
    Entity(
      name: buildTranslate("generalInformation")!,
      id: "1",
    ),
    Entity(
      name: buildTranslate("varieties")!,
      id: "2",
    ),
    Entity(
      name: buildTranslate("preSowingPractices")!,
      id: "3",
    ),
    Entity(
      name: buildTranslate("nutrientManagement")!,
      id: "4",
    ),
    Entity(
      name: buildTranslate("cropProtection")!,
      id: "5",
    ),
    Entity(
      name: buildTranslate("irrigationManagement")!,
      id: "6",
    ),
    Entity(
      name: buildTranslate("harvest")!,
      id: "7",
    ),
    Entity(
      name: buildTranslate("FAQs")!,
      id: "8",
    ),
  ];

  bool showSelectedItemValue = false;
  late Future<List<CropLibraryData>> futureCropData;

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

    futureCropData = CropController.fetchCrop();
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
              height: 20,
            ),

            Center(
              child: Text(
                buildTranslate("cropLibrary")!,
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

            // type of entity
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("selectTheCrop")!,
                style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                    fontFamily: 'poppins-semibold'),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Container(
                color: Colors.white,
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                    // the menu padding when button's width is not specified.
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                    // Add more decoration..
                  ),
                  hint: Text(
                    buildTranslate('selectTypeOfCrop')!,
                    style: const TextStyle(
                        fontSize: 14, fontFamily: "poppins-regular"),
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: "poppins-regular"),
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
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: ElevatedButton(
                  onPressed: () {
                    // if(selectedItemValue.isNotEmpty){
                    setState(() {
                      showSelectedItemValue = true;
                    });
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                    textStyle: const TextStyle(fontSize: 15),
                    backgroundColor: const Color(0xFF3FC041),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  child: Text(
                    buildTranslate('SUBMIT')!,
                    style: const TextStyle(
                        fontSize: 18, fontFamily: 'poppins-medium'),
                  ),
                )),
            const SizedBox(
              height: 25,
            ),
            showSelectedItemValue ? listWidget() : Container(),
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFd3d3d3), width: 1),
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
                  if (ORG_Entity[index].id == "1") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MyGeneralInformationPage(
                              aapbarVisibility: true,
                              cropData: futureCropData)),
                    );
                  } else if (ORG_Entity[index].id == "2") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MyVeritiesPage(
                                aapbarVisibility: true,
                              )),
                    );
                  } else if (ORG_Entity[index].id == "3") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MyProSawingPracticesPage(
                              aapbarVisibility: true,
                              cropData: futureCropData)),
                    );
                  } else if (ORG_Entity[index].id == "4") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MyNutrientManagmentPage(
                              aapbarVisibility: true,
                              cropData: futureCropData)),
                    );
                  } else if (ORG_Entity[index].id == "5") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MyHarvestPage(
                                aapbarVisibility: true,
                              )),
                    );
                  } else if (ORG_Entity[index].id == "6") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MyCropProtectionPage(
                                aapbarVisibility: true,
                              )),
                    );
                  } else if (ORG_Entity[index].id == "7") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MyIrrigationManagementPage(
                                aapbarVisibility: true,
                              )),
                    );
                  } else if (ORG_Entity[index].id == "8") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MyFaqPage(
                              aapbarVisibility: true,
                              cropData: futureCropData)),
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
