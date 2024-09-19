import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../mvc/model/CropLibraryData.dart';
import '../Enquiry/BottomCenterEnquiryPage.dart';
import '../HomeScreen/BottomOnePage.dart';
import 'BottomThreePage.dart';
import '../FRM/BottomTwoPage.dart';
import '../AccountSettings/EditBankDetailPage.dart';
import '../AccountSettings/OtherDetailPage.dart';
import '../AccountSettings/EditProfilePage.dart';
import '../AccountSettings/ForgotPasswordPage.dart';
import '../HomeScreen/HomePage.dart';
import '../Login/LoginPage.dart';
import '../AccountSettings/ProfilePage.dart';
import '../Language/SelectLanguagePage.dart';

class DiseaseManagementPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<List<CropLibraryData>?> cropData;

  DiseaseManagementPage({super.key, required this.aapbarVisibility, required this.cropData});

  @override
  State<DiseaseManagementPage> createState() => _DiseaseManagementPageState();
}

class _DiseaseManagementPageState extends State<DiseaseManagementPage>
    with TickerProviderStateMixin {

  var _bottomNavIndex = 2; //default index of a first screen

  // late AnimationController _fabAnimationController;
  // late AnimationController _borderRadiusAnimationController;
  // late Animation<double> fabAnimation;
  // late Animation<double> borderRadiusAnimation;
  // late CurvedAnimation fabCurve;
  // late CurvedAnimation borderRadiusCurve;
  // late AnimationController _hideBottomBarAnimationController;
  //
  // List<bottomCategory> iconList = [
  //   bottomCategory(name: "Home", id: "1", icon: 'assets/images/bottom1.png'),
  //   bottomCategory(name: "FRM", id: "2", icon: 'assets/images/bottom2.png'),
  //   bottomCategory(name: "Crop", id: "3", icon: 'assets/images/bottom3.png'),
  //   bottomCategory(name: "Profile", id: "4", icon: 'assets/images/bottom4.png'),
  // ];

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
                  builder: (context) => const SelectLanguagePage()),
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
                "Disease Management",
                softWrap: true,
                style: TextStyle(
                    color: Color(0xFF3FC041),
                    fontSize: 22,
                    fontFamily: 'poppins-medium'),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            listWidget(),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
      // floatingActionButton: widget.aapbarVisibility
      //     ? FloatingActionButton(
      //   backgroundColor: Colors.white.withAlpha(0),
      //   // add this line.
      //   elevation: 0,
      //   // also important, removes the shadow
      //   heroTag: "floatingActionBtn",
      //   shape: const RoundedRectangleBorder(
      //     // <= Change BeveledRectangleBorder to RoundedRectangularBorder
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(30.0),
      //       topRight: Radius.circular(30.0),
      //       bottomLeft: Radius.circular(30.0),
      //       bottomRight: Radius.circular(30.0),
      //     ),
      //   ),
      //   child: InkWell(
      //     highlightColor: Colors.transparent,
      //     splashColor: Colors.transparent,
      //     onTap: () {
      //       setState(() {
      //         _onItemTapped(4);
      //       });
      //     },
      //     child: Image.asset(
      //       'assets/images/bottomCenter.png',
      //       // color: Colors.white,
      //     ),
      //   ),
      //   onPressed: () {
      //     _fabAnimationController.reset();
      //     _borderRadiusAnimationController.reset();
      //     _borderRadiusAnimationController.forward();
      //     _fabAnimationController.forward();
      //   },
      // )
      //     : null,
      // floatingActionButtonLocation: widget.aapbarVisibility
      //     ? FloatingActionButtonLocation.centerDocked
      //     : null,
      // bottomNavigationBar: widget.aapbarVisibility
      //     ? AnimatedBottomNavigationBar.builder(
      //   height: 70,
      //   itemCount: iconList.length,
      //   tabBuilder: (int index, bool isActive) {
      //     final color = isActive ? Colors.green : Colors.grey;
      //     return Column(
      //       mainAxisSize: MainAxisSize.min,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Image.asset(
      //           iconList[index].icon ?? "",
      //           color: color,
      //           width: 25,
      //           height: 25,
      //         ),
      //         const SizedBox(height: 5),
      //         Text(
      //           iconList[index].name ?? "",
      //           textAlign: TextAlign.center,
      //           style: const TextStyle(
      //               color: Color(0xFF666666),
      //               fontSize: 13,
      //               fontFamily: 'poppins-regular'),
      //         ),
      //       ],
      //     );
      //   },
      //   // backgroundColor: Colors.white,
      //   activeIndex: _bottomNavIndex,
      //   // splashColor: Colors.green,
      //   notchAndCornersAnimation: borderRadiusAnimation,
      //   splashSpeedInMilliseconds: 300,
      //   notchSmoothness: NotchSmoothness.defaultEdge,
      //   gapLocation: GapLocation.center,
      //   leftCornerRadius: 32,
      //   rightCornerRadius: 32,
      //   notchMargin: 7,
      //   onTap: (index) {
      //     setState(() {
      //       _onItemTapped(index);
      //     });
      //   },
      //   // setState(() => _bottomNavIndex = index),
      //   hideAnimationController: _hideBottomBarAnimationController,
      //   shadow: const BoxShadow(
      //     offset: Offset(0, 1),
      //     blurRadius: 2,
      //     spreadRadius: 0.2,
      //     color: Colors.white,
      //   ),
      // )
      //     : null,
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
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data![parentIndex].diseaseManagement!.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                      child: Image.asset(snapshot.data![parentIndex].diseaseManagement![index].images![0] ?? "",
                                        width: MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,)),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          snapshot.data![parentIndex].diseaseManagement![index].name ?? "",
                                          softWrap: true,
                                          style: const TextStyle(
                                              color: Color(0xFF111111),
                                              fontSize: 14,
                                              fontFamily: 'poppins-semibold'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                                      child: Center(
                                        child: Text(
                                          textAlign: TextAlign.justify,
                                          snapshot.data![parentIndex].diseaseManagement![index].solutions ?? "",
                                          softWrap: true,
                                          style: const TextStyle(
                                              color: Color(0xFF808080),
                                              fontSize: 11,
                                              fontFamily: 'poppins-semibold'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                showSymptomsAlertDialog(context);
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
                                                'SYMPTOMS',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'poppins-regular'),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                showSolutionAlertDialog(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                minimumSize: Size.zero,
                                                textStyle: const TextStyle(fontSize: 14),
                                                padding: const EdgeInsets.all(5),
                                                backgroundColor: const Color(0xFF3FC041),
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
                                            ),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(height: 10,)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                });
            // Padding(
            //   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         border: Border.all(color: const Color(0xFFd3d3d3), width: 1),
            //         boxShadow: const [BoxShadow(color: Color(0xFFd3d3d3),)],
            //         borderRadius: BorderRadius.circular(15)),
            //     child: InkWell(
            //       highlightColor: Colors.transparent,
            //       splashColor: Colors.transparent,
            //       onTap: () {
            //
            //       },
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         mainAxisSize: MainAxisSize.min,
            //         children: <Widget>[
            //           Container(
            //               width: MediaQuery.of(context).size.width,
            //               padding: const EdgeInsets.only(
            //                   left: 15.0, right: 15.0, top: 20.0),
            //               child: ElevatedButton(
            //                 onPressed: () {},
            //                 style: ElevatedButton.styleFrom(
            //                   foregroundColor: Colors.white,
            //                   padding: const EdgeInsets.all(12),
            //                   textStyle: const TextStyle(fontSize: 18),
            //                   backgroundColor: const Color(0xFF1E8E27),
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(10),
            //                   ),
            //                 ),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   crossAxisAlignment: CrossAxisAlignment.center,
            //                   children: [
            //                     Image.asset("assets/images/clock.png", width: 20, height: 20,),
            //                     const SizedBox(width: 10,),
            //                     Text(
            //                       snapshot.data![0].irrigation![0].age ?? "",
            //                       style: const TextStyle(
            //                           fontSize: 14,
            //                           fontFamily: 'poppins-medium'),
            //                     ),
            //                   ],
            //                 ),
            //               )),
            //
            //           const SizedBox(height: 10,),
            //
            //           Flexible(
            //             child: Padding(
            //               padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
            //               child: Center(
            //                 child: Text(
            //                   snapshot.data![0].irrigation![0].criticalStage ?? "",
            //                   textAlign: TextAlign.center,
            //                   softWrap: true,
            //                   style: const TextStyle(
            //                     // color: Color(0xFF666666),
            //                       color: Colors.black,
            //                       fontSize: 14,
            //                       fontFamily: 'poppins-semibold'),
            //                 ),
            //               ),
            //             ),
            //           ),
            //
            //           const SizedBox(height: 10,),
            //
            //           Container(
            //               width: MediaQuery.of(context).size.width,
            //               padding: const EdgeInsets.only(
            //                   left: 15.0, right: 15.0, top: 20.0),
            //               child: ElevatedButton(
            //                 onPressed: () {},
            //                 style: ElevatedButton.styleFrom(
            //                   foregroundColor: Colors.white,
            //                   padding: const EdgeInsets.all(12),
            //                   textStyle: const TextStyle(fontSize: 18),
            //                   backgroundColor: const Color(0xFF1E8E27),
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(10),
            //                   ),
            //                 ),
            //                 child: Column(
            //                   children: [
            //                     const Align(
            //                       alignment: Alignment.topLeft,
            //                       child: Text(
            //                         'Methodology',
            //                         textAlign: TextAlign.start,
            //                         style: TextStyle(
            //                             fontSize: 17,
            //                             fontFamily: 'poppins-regular'),
            //                       ),
            //                     ),
            //                     const SizedBox(height: 10,),
            //                     Align(
            //                       alignment: Alignment.topLeft,
            //                       child: Text(
            //                         snapshot.data![0].irrigation![0].methodology ?? "",
            //                         textAlign: TextAlign.start,
            //                         style: const TextStyle(
            //                             fontSize: 11,
            //                             fontFamily: 'poppins-medium'),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               )),
            //
            //           const SizedBox(height: 20.0,),
            //           const Flexible(
            //             child: Padding(
            //               padding: EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
            //               child: Text(
            //                 "Operations:",
            //                 softWrap: true,
            //                 style: TextStyle(
            //                   // color: Color(0xFF666666),
            //                     color: Colors.black,
            //                     fontSize: 15,
            //                     fontFamily: 'poppins-semibold'),
            //               ),
            //             ),
            //           ),
            //
            //           const SizedBox(height: 10.0,),
            //           Flexible(
            //             child: Padding(
            //               padding: const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
            //               child: Text(snapshot.data![0].irrigation![0].operations ?? "",
            //                 textAlign: TextAlign.justify,
            //                 softWrap: true,
            //                 style: const TextStyle(
            //                   // color: Color(0xFF666666),
            //                     color: Colors.black,
            //                     fontSize: 13,
            //                     fontFamily: 'poppins-regular'),
            //               ),
            //             ),
            //           ),
            //           const SizedBox(
            //             height: 20,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      );
  }

  showSolutionAlertDialog(BuildContext context) {
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

          const Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0,),
            child: Text("To control the disease: - Apply P. fluorescens or T. viride"
                " @ 2.5 kg/ha + 50 kg well-decomposed Farm Yard Manure (mix 10 days before) or sand 30 days"
                "after sowing. - Spray Metalaxyl 1000 g / Mancozeb 2 g/liter at 10-day"
                " intervals after the disease appears.", softWrap: true,
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

  showSymptomsAlertDialog(BuildContext context) {
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
                  child: Text("Symptoms", softWrap: true,
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

          const Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0,),
            child: Text("Turcicum Leaf Blight: Initial signs: oval water-soaked leaf spots."
                " Later, cigar-shaped tan lesions form, 3-15 cm long. Dark areas "
                "develop with fungal infection. Maydis Leaf Blight: At first, oval "
                "water-soaked leaf spots. Later, small round/oval yellowish spots grow elliptical,"
                " with straw-colored centers, and reddish-brown edges.", softWrap: true,
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
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } else if (index == 4) {
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => BottomCenterEnquiryPage(
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
