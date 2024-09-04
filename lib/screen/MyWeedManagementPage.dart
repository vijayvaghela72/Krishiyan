import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
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

class MyWeedManagementPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<List<CropLibraryData>?> cropData;

  MyWeedManagementPage({super.key, required this.aapbarVisibility, required this.cropData});

  @override
  State<MyWeedManagementPage> createState() => _MyWeedManagementPageState();
}

class _MyWeedManagementPageState extends State<MyWeedManagementPage>
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

  // List<Entity> ORG_Entity = [
  //   Entity(
  //     name: "Type of weed : Grass",
  //     id: "1",
  //     image: "assets/images/weed1.png",
  //     description: "Weed Name (Local) : Bermuda grass"
  //   ),
  //   Entity(
  //     name: "Type of weed : Grass",
  //     description: "Weed Name (Local) : Swollen finger-grass",
  //     id: "2",
  //       image: "assets/images/weed2.png"
  //   ),
  //   Entity(
  //     name: "Type of weed : Grass",
  //     description: "Weed Name (Local) : Egyptian Crowfoot Grass",
  //     id: "3",
  //       image: "assets/images/weed3.png"
  //   ),
  //   Entity(
  //     name: "Type of weed : Grass",
  //     description: "Weed Name (Local) : Fountain grasses",
  //     id: "4",
  //       image: "assets/images/weed4.png"
  //   ),
  //   Entity(
  //     name: "Type of weed : Broad leaves",
  //     description: "Weed Name (Local) : Congress grass",
  //     id: "5",
  //       image: "assets/images/weed5.png"
  //   ),
  //   Entity(
  //     name: "Type of weed : Broad leaves",
  //     id: "6",
  //       description: "Weed Name (Local) : Black Pigweed",
  //       image: "assets/images/weed6.png"
  //   ),
  //   Entity(
  //     name: "Type of weed : Broad leaves",
  //     description: "Weed Name (Local) : Prostrate spurge",
  //     id: "7",
  //       image: "assets/images/weed7.png"
  //   ),
  //   Entity(
  //     name: "Type of weed : Broad leaves",
  //     description: "Weed Name (Local) : Green amaranth",
  //     id: "8",
  //       image: "assets/images/weed8.png"
  //   ),
  //   Entity(
  //     name: "Type of weed : Broad leaves",
  //     description: "Weed Name (Local) : Vaichikato, Dadaro",
  //     id: "9",
  //       image: "assets/images/weed9.png"
  //   ),
  //   Entity(
  //     name: "Type of weed : Broad leaves",
  //     description: "Weed Name (Local) : Egyptian spinach",
  //     id: "10",
  //       image: "assets/images/weed10.png"
  //   ),
  //   Entity(
  //     name: "Type of weed : Sedges",
  //     description: "Weed Name (Local) :Tiger nut",
  //     id: "11",
  //       image: "assets/images/weed11.png"
  //   ),
  //   Entity(
  //     name: "Type of weed : Sedges",
  //     description: "Weed Name (Local) : Coco-grass, Java grass",
  //     id: "12",
  //       image: "assets/images/weed12.png"
  //   ),
  // ];
  TextEditingController? controller;

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
              child: Text(
                "Weed Management",
                softWrap: true,
                style: TextStyle(
                    color: Color(0xFF3FC041),
                    fontSize: 22,
                    fontFamily: 'poppins-medium'),
              ),
            ),
            const SizedBox(
              height: 25,
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

  Widget listWidget() {
    return
      FutureBuilder<List<CropLibraryData>?>(
        future: widget.cropData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, parentIndex) {
                  return
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data![parentIndex].weedManagement!.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
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
                                onTap: () {},
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15)),
                                        child: Image.asset("",
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover,)),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Center(
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            snapshot.data![parentIndex].weedManagement![index].name ?? "",
                                            softWrap: true,
                                            style: const TextStyle(
                                                color: Color(0xFF111111),
                                                fontSize: 10,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Center(
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            snapshot.data![parentIndex].weedManagement![index].category ?? "",
                                            softWrap: true,
                                            style: const TextStyle(
                                                color: Color(0xFF111111),
                                                fontSize: 10,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0,),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showSolutionAlertDialog(context,
                                                snapshot.data![parentIndex].weedManagement![index].solutions!);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            minimumSize: Size.zero,
                                            textStyle: const TextStyle(fontSize: 14),
                                            padding: const EdgeInsets.all(5),
                                            backgroundColor: const Color(0xFF278115),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(17),
                                            ),
                                          ),
                                          child: const Text(
                                            'SOLUTION',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'poppins-regular'),
                                          ),
                                        )),
                                    const SizedBox(height: 5,)
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      );
    //   Padding(
    //   padding: const EdgeInsets.only(left: 12.0, right: 12.0),
    //   child: ListView.builder(
    //     shrinkWrap: true,
    //     scrollDirection: Axis.vertical,
    //     physics: const NeverScrollableScrollPhysics(),
    //     itemCount: ORG_Entity.length,
    //     itemBuilder: (_, index) {
    //       return Padding(
    //         padding: const EdgeInsets.all(5.0),
    //         child: Container(
    //           decoration: BoxDecoration(
    //               color: Colors.white,
    //               border: Border.all(color: const Color(0xFFd3d3d3), width: 1),
    //               boxShadow: const [
    //                 BoxShadow(
    //                   color: Color(0xFFd3d3d3),
    //                 )
    //               ],
    //               borderRadius: BorderRadius.circular(15)),
    //           child: InkWell(
    //             highlightColor: Colors.transparent,
    //             splashColor: Colors.transparent,
    //             onTap: () {},
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisSize: MainAxisSize.min,
    //               children: <Widget>[
    //                 Container(
    //                     padding: const EdgeInsets.all(8.0),
    //                     decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(15)),
    //                     child: Image.asset(ORG_Entity[index].image ?? "",
    //                       width: MediaQuery.of(context).size.width,
    //                       fit: BoxFit.cover,)),
    //                 Flexible(
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(3.0),
    //                     child: Center(
    //                       child: Text(
    //                         textAlign: TextAlign.center,
    //                         ORG_Entity[index].name ?? "",
    //                         softWrap: true,
    //                         style: const TextStyle(
    //                             color: Color(0xFF111111),
    //                             fontSize: 10,
    //                             fontFamily: 'poppins-semibold'),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Flexible(
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(3.0),
    //                     child: Center(
    //                       child: Text(
    //                         textAlign: TextAlign.center,
    //                         ORG_Entity[index].description ?? "",
    //                         softWrap: true,
    //                         style: const TextStyle(
    //                             color: Color(0xFF111111),
    //                             fontSize: 10,
    //                             fontFamily: 'poppins-semibold'),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                     width: MediaQuery.of(context).size.width,
    //                     padding: const EdgeInsets.only(
    //                         left: 10.0, right: 10.0,),
    //                     child: ElevatedButton(
    //                       onPressed: () {
    //                         showSolutionAlertDialog(context);
    //                       },
    //                       style: ElevatedButton.styleFrom(
    //                         foregroundColor: Colors.white,
    //                         minimumSize: Size.zero,
    //                         textStyle: const TextStyle(fontSize: 14),
    //                         padding: const EdgeInsets.all(5),
    //                         backgroundColor: const Color(0xFF278115),
    //                         shape: RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(17),
    //                         ),
    //                       ),
    //                       child: const Text(
    //                         'SOLUTION',
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(
    //                             fontSize: 14,
    //                             fontFamily: 'poppins-regular'),
    //                       ),
    //                     )),
    //                 const SizedBox(height: 5,)
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
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

  showSolutionAlertDialog(BuildContext context, String solution) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      title:
      Column(
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
            child: Row(
              children: [
                const Expanded(
                  child: Text("Solution", softWrap: true,
                    style: TextStyle(fontFamily: "poppins-semibold", fontSize: 15.0, color: Colors.black),),
                ),
                Expanded(
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5,),
          const Divider(
              color: Colors.grey
          ),
          const SizedBox(height: 5,),

          Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0,),
            child: Text(solution, softWrap: true,
              textAlign: TextAlign.justify,
              style: TextStyle(fontFamily: "poppins-regular", fontSize: 13.0, color: Color(0xFF666666)),),
          ),

          const SizedBox(height: 20,),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

class Entity {
  String? name;
  String? id;
  String? image;
  String? description;

  Entity({
    required this.name,
    required this.id,
    required this.image,
    required this.description,
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