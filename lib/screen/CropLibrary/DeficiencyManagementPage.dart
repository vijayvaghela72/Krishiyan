import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../mvc/model/CropLibraryData.dart';
import '../../utils/DriveImage.dart';
import '../Enquiry/BottomCenterEnquiryPage.dart';
import '../HomeScreen/BottomOnePage.dart';
import 'BottomThreePage.dart';
import '../FRM/BottomTwoPage.dart';
import '../AccountSettings/ProfilePage.dart';
import '../Language/SelectLanguagePage.dart';

class DeficiencyManagementPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<List<CropLibraryData>?> cropData;
  String? selectedcrop;

  DeficiencyManagementPage({super.key, required this.aapbarVisibility,  required this.cropData, required this.selectedcrop});

  @override
  State<DeficiencyManagementPage> createState() => _DeficiencyManagementPageState();
}

class _DeficiencyManagementPageState extends State<DeficiencyManagementPage>
    with TickerProviderStateMixin {

  var _bottomNavIndex = 2; //default index of a first screen

  // late AnimationController _fabAnimationController;
  // late AnimationController _borderRadiusAnimationController;
  // late Animation<double> fabAnimation;
  // late Animation<double> borderRadiusAnimation;
  // late CurvedAnimation fabCurve;
  // late CurvedAnimation borderRadiusCurve;
  // late AnimationController _hideBottomBarAnimationController;

  // List<bottomCategory> iconList = [
  //   bottomCategory(name: "Home", id: "1", icon: 'assets/images/bottom1.png'),
  //   bottomCategory(name: "FRM", id: "2", icon: 'assets/images/bottom2.png'),
  //   bottomCategory(name: "Crop", id: "3", icon: 'assets/images/bottom3.png'),
  //   bottomCategory(name: "Profile", id: "4", icon: 'assets/images/bottom4.png'),
  // ];

  List<Entity> ORG_Entity = [
    Entity(
        name: "Symptoms:The leaves turn uniformly pale green in colour. The oldest leaves on the "
            "bottom show yellow discolouration and subsequent necrosis proceeding from the "
            "leaf tip to mid rib.",
        id: "1",
        image: "assets/images/deficiency1.png",
        description: "Solution:Used nitrogenous fertilizer listed below, 1. Foliar"
            " spray of 0.5% urea (5 gm /lit) for twice at 10 days intervals."
    ),
    Entity(
        name: "Symptoms:The leaves turn uniformly pale green in colour. The oldest leaves on the "
            "bottom show yellow discolouration and subsequent necrosis proceeding from the "
            "leaf tip to mid rib.",
        id: "2",
        image: "assets/images/deficiency2.png",
        description: "Solution: Apply Phosphorus containing fertilizers like,"
            " 1.Superphosphate, 2. Single Super Phosphate 3. Triple Super Phosphate, "
            "DAP etc recommendation onion (24 kg P/acre) dose according to soil "
            "testing report. or Foliar spray of DAP 2%."
    ),
    Entity(
        name: "Symptoms:White to pale yellow bands in the lower half of the leaf which advance to "
            "pale brown or grey necrosis.",
        id: "3",
        image: "assets/images/deficiency3.png",
        description: "Solution: Soil application of Zinc sulfate 10 Kg/acre or foliar"
            "spray of Zinc sulfate 0.5%."
    ),
    Entity(
        name: "Symptoms:Dark green plants with chlorosis along the leaf margins develop to "
            "brown striping and necrosis. The cobs become narrowed and peaked.",
        id: "4",
        image: "assets/images/deficiency4.png",
        description: "Solution: Give a potassium-containing fertilizer on their soil form of Murate of "
            "potash (16 kg K/acre). or Foliar spray of Potassium chloride 1%."
    ),
    Entity(
        name: "Symptoms: Symptoms start from the younger leaves. Leaf tips show light green "
            "or whitish spots or streaky lesions and are often hooked back.",
        id: "5",
        image: "assets/images/deficiency5.png",
        description: "Solution: Give a potassium-containing fertilizer on their soil form of "
            "Murate of potash (16 kg K/acre). or Foliar spray of Potassium chloride 1%."
    ),
    Entity(
        name: "Symptoms:Leaves show advanced interveinal chlorosis and necrotic edges. "
            "In severe cases, it leads to the shortening of the internodes.",
        id: "6",
        image: "assets/images/deficiency6.png",
        description: "Solution: Micronutrients require less quantity so we can "
            "apply zinc magnesium 3-5 ml/lit. or Foliar spray of Magnesium sulfate 2%."
    ),
    Entity(
        name: "Symptoms:The plant shows stunted, erect growth. Seen from a distance, younger "
            "leaves are colored uniformly pale, but when you look at them closely, "
            "it�s rather an interveinal chlorosis.",
        id: "7",
        image: "assets/images/deficiency7.png",
        description: "Solution: Sulfate sulfur should be applied, as it is readily available for plant uptake. "
            "Foliar spray of Magnesium sulfate 1%"
    ),
    Entity(
        name: "Symptoms:Symptoms expressed as shortening of internodal and results in "
            "transparent necrotic spots. Lack of boron will results in smaller cobs.",
        id: "8",
        image: "assets/images/deficiency8.png",
        description: "Solution:Foliar spray of Borax 0.5 % at fortnightly intervals."
    ),
    Entity(
        name: "Symptoms:Plants show chlorotic leaves with interveinal stripes. When the becomes "
            "severe the veins also become chlorotic and the plant growth is stunted.",
        id: "9",
        image: "assets/images/deficiency9.png",
        description: "Solution: Soil application of 10 Kg/acre Ferrous sulfate or"
            " foliar spray 1% at weekly interval"
    ),
    Entity(
        name: "Symptoms:Necrosis occurs on the older or younger leaves. Cob "
            "development will be irregular, often showing empty tips or diverse kernel sizes, as well as bent cobs",
        id: "10",
        image: "assets/images/deficiency10.png",
        description: "Solution: Foliar spray of Manganese sulfate @ 2%"
    ),
  ];

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
                "Deficiency Symptoms",
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
     List<CropLibraryData>? filteredData = snapshot.data?.where((data) {
        return data.localName == widget.selectedcrop; // Filter by selected crop
      }).toList();

      // Check if filteredData has any results
      if (filteredData == null || filteredData.isEmpty) {
        return const Text('No data available for the selected crop.');
      }

       // Filter nutrients with images in deficiency
        filteredData.forEach((cropData) {
          cropData.nutrient?.removeWhere((nutrient) {
            var deficiency = nutrient.deficiency;
            return deficiency?.images == null || deficiency!.images!.isEmpty;
          });
        });

                return ListView.builder(
                itemCount: filteredData.length,
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
          itemCount: filteredData[parentIndex].nutrient!.length,
          itemBuilder: (context, deficiencyIndex) {
             var nutrient = filteredData[parentIndex].nutrient![deficiencyIndex];
                  var deficiency = nutrient.deficiency;
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
                      Center(
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            child:  deficiency?.images?.isNotEmpty == true
                                    ? DriveImage(imageUrlData: deficiency!.images!.first)
                                    : Container(),
                                    ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              nutrient.name ?? "No Name",
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
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                          child: Text(
                            textAlign: TextAlign.left,
                            "Notable Symptoms: ${deficiency!.notableSymptoms ?? "N/A"}",
                            softWrap: true,
                            style: const TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 10,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                      ),
                       const SizedBox(height: 15,),
                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0,),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showSolutionAlertDialog(context,
                                                deficiency.solution ?? "No Solution Available");
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
                                  
                      const SizedBox(height: 15,)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );});
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
