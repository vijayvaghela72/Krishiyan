import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/mvc/model/CropLibraryData.dart';
import '../../localization/AppLocalizations.dart';
import '../../utils/AppGlobal.dart';
import '../../utils/DriveImage.dart';
import '../Enquiry/BottomCenterEnquiryPage.dart';
import '../home_screen/home/home.dart';
import 'BottomThreePage.dart';
import '../FRM/BottomTwoPage.dart';
import '../AccountSettings/ProfilePage.dart';
import '../Language/SelectLanguagePage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GeneralInformationPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<List<CropLibraryData>?> cropData;
  String? selectedcrop;


  GeneralInformationPage({super.key, required this.aapbarVisibility, required this.cropData, required this.selectedcrop});

  @override
  State<GeneralInformationPage> createState() => _GeneralInformationPageState();
}

class _GeneralInformationPageState extends State<GeneralInformationPage>
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
  //   bottomCategory(
  //       name: buildTranslate("home")!, id: "1", icon: 'assets/images/bottom1.png'),
  //   bottomCategory(
  //       name: buildTranslate("frm")!,
  //       id: "2",
  //       icon: 'assets/images/bottom2.png'),
  //   bottomCategory(
  //       name: buildTranslate("crop")!,
  //       id: "3",
  //       icon: 'assets/images/bottom3.png'),
  //   bottomCategory(
  //       name: buildTranslate("profile")!,
  //       id: "4",
  //       icon: 'assets/images/bottom4.png'),
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
                  Text(
                    buildTranslate("goBack")!,
                    style: const TextStyle(color: Colors.black, fontFamily: 'poppins-medium', fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Center(
              child: Text(
                buildTranslate("generalInformations")!,
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
            listWidget(),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<List<CropLibraryData>?>(
  future: widget.cropData,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      // Filter the data based on selected crop (localName)
      List<CropLibraryData>? filteredData = snapshot.data?.where((data) {
        return data.localName == widget.selectedcrop; // Filter by selected crop
      }).toList();

      // Check if filteredData has any results
      if (filteredData == null || filteredData.isEmpty) {
        return const Text('No data available for the selected crop.');
      }

      // Continue with building the table with filtered data
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Table(
            border: TableBorder.all(),
            children: [
              // Table Header
              const TableRow(
                decoration: BoxDecoration(color: Color(0xFF73C187)),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text('Parameter',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontFamily: "poppins-semibold")),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text('Specifications',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontFamily: "poppins-semibold")),
                    ),
                  ),
                ],
              ),
              
              // Table Rows for filtered crop data
              TableRow(children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Kharif(Sowing Month)',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.black,
                      fontFamily: "poppins-semibold")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    filteredData[0].generalInformation!.kharif ?? "",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11.0,
                      color: Colors.black,
                      fontFamily: "poppins-regular")),
                ),
              ]),

              // Repeat for other parameters like Rabi, Zaid, etc.
              TableRow(children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Rabi(Sowing Month)',
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.black,
                      fontFamily: "poppins-semibold")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    filteredData[0].generalInformation!.rabi ?? "",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11.0,
                      color: Colors.black,
                      fontFamily: "poppins-regular")),
                ),
              ]),

              // 4th
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Zaid(Sowing Mouth)',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-semibold")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    filteredData[0].generalInformation!.zaid ?? "",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-regular")),
                              ),
                            ]),

                             // 5th
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Optimum temperature for growing',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-semibold")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text( filteredData[0].generalInformation!.optimumTemperature ?? "",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-regular")),
                              ),
                            ]),

                            // 6th
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Rainfall requirement',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-semibold")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text( filteredData[0].generalInformation!.rainfallRequirement ?? "",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-regular")),
                              ),
                            ]),

                            // 7th
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Recommended soil',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-semibold")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text( filteredData[0].generalInformation!.recommendedSoil ?? "",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-regular")),
                              ),
                            ]),

                            // 8th
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('pH of soil',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-semibold")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text( filteredData[0].generalInformation!.pHSoil ?? "",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-regular")),
                              ),
                            ]),

                            // 9th
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Spacing',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-semibold")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text( filteredData[0].generalInformation!.spacing ?? "",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-regular")),
                              ),
                            ]),

                            // 10th
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Seed Rate',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-semibold")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    filteredData[0].generalInformation!.seedRate ?? "",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-regular")),
                              ),
                            ]),

                            // 11th
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Average Yield',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-semibold")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text( filteredData[0].generalInformation!.averageYield ?? "",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-regular")),
                              ),
                            ]),

                            // 12th
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Intercrop details and pattern',
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-semibold")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text( filteredData[0].generalInformation!.intercrop ?? "",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontFamily: "poppins-regular")),
                              ),
                            ]),



              // Continue adding rows similarly for other fields...
            ],
          ),
        ),
      );
    } else if (snapshot.hasError) {
      return Text('${snapshot.error}');
    }

    // By default, show a loading spinner.
    return const CircularProgressIndicator();
  },
),
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
  return FutureBuilder<List<CropLibraryData>?>(
    future: widget.cropData,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        // Filter data based on selectedcrop (localName)
        List<CropLibraryData>? filteredData = snapshot.data?.where((data) {
          return data.localName == widget.selectedcrop; 
        }).toList();

        return Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: ListView.builder(
            itemCount: filteredData?.length ?? 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, parentIndex) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredData![parentIndex].stages!.length,
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {},
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: DriveImage(
                                  imageUrlData: filteredData[parentIndex].stages![index].images![0] ?? "",
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  filteredData[parentIndex].stages![index].name ?? "",
                                  maxLines: 3,
                                  softWrap: true,
                                  style: const TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 13,
                                    fontFamily: 'poppins-semibold',
                                  ),
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
                      (MediaQuery.of(context).size.height / 2),
                ),
              );
            },
          ),
        );
      } else if (snapshot.hasError) {
        return Text('${snapshot.error}');
      }
      // By default, show a loading spinner.
      return const CircularProgressIndicator();
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

  Entity({
    required this.name,
    required this.id,
    required this.image,
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
