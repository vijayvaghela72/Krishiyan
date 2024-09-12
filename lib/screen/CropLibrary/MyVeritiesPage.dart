import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../localization/AppLocalizations.dart';
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

class MyVeritiesPage extends StatefulWidget {
  bool aapbarVisibility;

  MyVeritiesPage({super.key, required this.aapbarVisibility});

  @override
  State<MyVeritiesPage> createState() => _MyVeritiesPageState();
}

class _MyVeritiesPageState extends State<MyVeritiesPage>
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
    bottomCategory(
        name: buildTranslate("home")!, id: "1", icon: 'assets/images/bottom1.png'),
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

  List<Verities> ORG_Verities = [
    Verities(
        id: "1",
        name: "Name of the variety/hybrid: MM 9344 (DMH192)",
        productCondition: "Product Condition: 35-37 qtl/acre",
        area: "Area of adoption: Maharashtra",
        cropCycle: "Crop Cycle: Suitable for Kharif season",
        spaciality: "1. Drought tolerant.\n2.Resistant to Common rust and Charcoal rot"),
    Verities(
        id: "2",
        name: "Name of variety/Hybrid: CP. 999 Hybrid",
        productCondition: "Product Condition: 34-35 qtl/acre",
        area: "Area of adoption: Karnataka, Tamilnadu, Telangana and Maharashtra",
        cropCycle: "Crop Cycle: 1. Suitable for irrigated and rainfed areas "
            "2.Suitable for rabi season under irrigated areas",
        spaciality: "Moderately resistant to common diseases"),
    Verities(
        id: "3",
        name: "Name of variety/Hybrid: ADV-756 (ADV 0990296) Hybrid",
        productCondition: "Product Condition: 30-35 qtl/acre",
        area:
        "Area of adoption: Karnataka, Maharashtra, Andra Pradesh, Tamilnadu, Telangana, Rajasthan,"
            " Gujarat, MP and Chhattisgarh",
        cropCycle: "Crop Cycle: 1. Suitable for irrigated and rainfed "
            "areas 2.Suitable for rabi season under irrigated",
        spaciality: "1. Multiple disease resistance 2. Resistant to Curvularia leaf spot"),
    Verities(
        id: "4",
        name:
        "Name of variety/Hybrid: Gujarat An and White Maize Hybrid-2 (GAWMH-2)",
        productCondition: "Product Condition: 15-18 qtl/acre",
        area: "Area of adoption: Gujarat",
        cropCycle: "Crop Cycle: Suitable for Kharif season",
        spaciality: "White flint grain"),
    Verities(
        id: "5",
        name: "Name of variety/Hybrid: HTMH 5108 Hybrid",
        productCondition: "Product Condition: 35 qtl/acre",
        area:
        "Area of adoption: Karnataka, Maharashtra, Andhra Pradesh, Tamilnadu and Telangana",
        cropCycle: "Crop Cycle: Suitable for rainfed and irrigated areas",
        spaciality: "Resistant to lodging"),
    Verities(
        id: "6",
        name:
        "Name of variety/Hybrid: Gujarat Anand Yellow Maize Hybrid 3 (GAYMH 3)",
        productCondition: "Product Condition: 25-28 qtl/acre",
        area: "Area of adoption: Middle Gujarat",
        cropCycle: "Crop Cycle: Suitable for rabi season",
        spaciality: "1. Moderately resistant to Turcicum leaf blight "
            "\n2. Moderately resistant to Downy mildew \n3. Resistant to common rust and stem borer"),
    Verities(
        id: "7",
        name: "Name of variety/Hybrid: Gujarat Yellow Hybrid (GYH 0363)",
        productCondition: "Product Condition: 25-28 qtl/acre",
        area: "Area of adoption: Middle Gujarat",
        cropCycle: "Crop Cycle: Suitable for rabi season",
        spaciality: "1. Moderately resistant to Turcicum leaf blight "
            "\n2. Moderately resistant to Downy mildew \n3. Resistant to common rust and stem borer"),
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
              height: 10,
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
                    style: const TextStyle(color: Colors.black, fontFamily: 'poppins-medium',
                        fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Center(
              child: Text(
                buildTranslate("varieties")!,
                softWrap: true,
                style: const TextStyle(
                    color: Color(0xFF3FC041),
                    fontSize: 20,
                    fontFamily: 'poppins-medium'),
              ),
            ),
            const SizedBox(
              height: 25,
            ),

            ListView.builder(
              itemCount: ORG_Verities.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15.0),
                  child: Container(
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
                              ORG_Verities[index].name ?? "",
                              softWrap: true,
                              style: const TextStyle(
                                // color: Color(0xFF666666),
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, right: 10.0, left: 10.0),
                            child: Text(
                              ORG_Verities[index].productCondition ?? "",
                              softWrap: true,
                              style: const TextStyle(
                                // color: Color(0xFF666666),
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, right: 10.0, left: 10.0),
                            child: Text(
                              ORG_Verities[index].area ?? "",
                              softWrap: true,
                              style: const TextStyle(
                                // color: Color(0xFF666666),
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, right: 10.0, left: 10.0),
                            child: Text(
                              ORG_Verities[index].cropCycle ?? "",
                              softWrap: true,
                              style: const TextStyle(
                                // color: Color(0xFF666666),
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'poppins-semibold'),
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
                              child: Column(children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Speciality:',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins-regular'),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    ORG_Verities[index].spaciality ?? "",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'poppins-regular'),
                                  ),
                                ),
                              ]),
                            )),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(
              height: 20,
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

class Verities {
  String? name;
  String? id;
  String? productCondition;
  String? area;
  String? cropCycle;
  String? spaciality;

  Verities({
    required this.id,
    required this.name,
    required this.productCondition,
    required this.area,
    required this.cropCycle,
    required this.spaciality,
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
