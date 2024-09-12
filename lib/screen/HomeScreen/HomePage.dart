import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:krishiyan/screen/HomeScreen/BottomOnePage.dart';
import 'package:krishiyan/screen/FRM/BottomTwoPage.dart';
import 'dart:async';
import '../../helper/SharedPref.dart';
import '../../localization/AppLocalizations.dart';
import '../../utils/AppColor.dart';
import '../../utils/Constants.dart';
import '../Enquiry/BottomCenterEnquiryPage.dart';
import '../CropLibrary/BottomThreePage.dart';
import '../AccountSettings/ProfilePage.dart';
import '../Language/SelectLanguagePage.dart';

class HomePage extends StatefulWidget {

  int selectedIndex;

  HomePage({super.key, required this.selectedIndex,});

  static void setLocale(BuildContext context, Locale newLocale) async {
    print("setLocal : $newLocale");
    _HomePageState? state = context.findAncestorStateOfType<_HomePageState>();
    state?.changeLanguage(newLocale);
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  var _bottomNavIndex;

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;

  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;

  late AnimationController _hideBottomBarAnimationController;

  List<bottomCategory> iconList1 = [
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

  List<bottomCategory> iconList2 = [
    bottomCategory(
        name: buildTranslate("home")!, id: "1", icon: 'assets/images/bottom1.png'),
    bottomCategory(
        name: buildTranslate("profile")!,
        id: "2",
        icon: 'assets/images/bottom4.png'),
  ];

  final List<Widget> _screens1 = [
    BottomOnePage(aapbarVisibility : false),
    BottomTwoPage(aapbarVisibility: false,),
    BottomThreePage(aapbarVisibility: false,),
    const ProfilePage(),
    BottomCenterEnquiryPage(aapbarVisibility: false,),
  ];

  final List<Widget> _screens2 = [
    BottomOnePage(aapbarVisibility : false),
    const ProfilePage(),
    BottomCenterEnquiryPage(aapbarVisibility: false,),
  ];

  Locale _locale = const Locale("en");
  String typeOfOrganizationData = "";

  bool _isClickAllowed = true; // Flag to prevent double-clicks

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();

    // _bottomNavIndex = widget.selectedIndex;
    _bottomNavIndex = 0;

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
    getPrefValue();
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          _fabAnimationController.forward(from: 0);
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          _fabAnimationController.reverse(from: 1);
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: InkWell(
          highlightColor: AppColor.transparentColor,
          splashColor: AppColor.transparentColor,
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (context) => const MySelectLanguagePage()),
            // );
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectLanguagePage()))
                .then((value) {
              setState(() {
                // refresh state
                MyLocalizations.load(Locale(localLang, ''));
                HomePage.setLocale(context, Locale(localLang, ''));
                print("HomePage Lang: $localLang");
              });
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/loginLogo.png', width: 150, height: 60,),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body : typeOfOrganizationData == "Farmer groups" ? _screens1[_bottomNavIndex] : _screens2[_bottomNavIndex],
      // body : _screens1[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.whiteColor.withAlpha(0), // add this line.
        elevation: 0, // also important, removes the shadow
        heroTag: "floatingActionBtn",
        shape: const RoundedRectangleBorder( // <= Change BeveledRectangleBorder to RoundedRectangularBorder
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        child: InkWell(
          highlightColor: AppColor.transparentColor,
          splashColor: AppColor.transparentColor,
          onTap: () {
            print("Center dock");
            setState(() {
              typeOfOrganizationData == "Farmer groups" ?  _onItemTapped(4) : _onItemTappedData(2);
              // _onItemTapped(4);
            });
          },
          child: Image.asset(
            'assets/images/bottomCenter.png',
          ),
        ),
        onPressed: () {
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
      typeOfOrganizationData == "Farmer groups" ?
      AnimatedBottomNavigationBar.builder(
        height: 70,
        itemCount: iconList1.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive
              ? AppColor.greenColor
              : AppColor.greyColor;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconList1[index].icon ?? "",
                color: color,
                width: 25, height: 25,
              ),
              const SizedBox(height: 5),
              Text(
                iconList1[index].name ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColor.iconColor,
                    fontSize: 13,
                    fontFamily: 'poppins-regular'),
              ),
            ],
          );
        },
        activeIndex: _bottomNavIndex,
        notchAndCornersAnimation: borderRadiusAnimation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        notchMargin: 7,
        onTap: (index) {
          print("Type 1 : $index");
          setState(() {
            _onItemTapped(index);
          });
        },
        hideAnimationController: _hideBottomBarAnimationController,
        shadow: const BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          spreadRadius: 0.2,
          color: AppColor.whiteColor,
        ),
      )
          : AnimatedBottomNavigationBar.builder(
        height: 70,
        itemCount: iconList2.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive
              ? AppColor.greenColor
              : AppColor.greyColor;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconList2[index].icon ?? "",
                color: color,
                width: 25, height: 25,
              ),
              const SizedBox(height: 5),
              Text(
                iconList2[index].name ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColor.iconColor,
                    fontSize: 13,
                    fontFamily: 'poppins-regular'),
              ),
            ],
          );
        },
        activeIndex: _bottomNavIndex,
        notchAndCornersAnimation: borderRadiusAnimation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        notchMargin: 7,
        onTap: (index) {
          setState(() {
            print("Type 2 HomePage: $index");
            typeOfOrganizationData == "Farmer groups" ? _onItemTapped(index) : index == 0 ?_onItemTapped(index)
                : _onItemTapped(3);
          });
        },
        hideAnimationController: _hideBottomBarAnimationController,
        shadow: const BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          spreadRadius: 0.2,
          color: AppColor.whiteColor,
        ),
      ),
    );
  }

  // void _onItemTapped(int index) {
  //
  //   print("Home index : $index");
  //   if (index != 3) {
  //     setState(() {
  //       _bottomNavIndex = index;
  //     });
  //     if(_bottomNavIndex == 0) {
  //       // Navigator.pop(context);
  //       var route = ModalRoute.of(context);
  //       if (route != null) {
  //         Navigator
  //             .of(context)
  //             .pushReplacement(
  //             MaterialPageRoute(builder: (BuildContext context) =>
  //                 MyBottomOnePage(aapbarVisibility: true,)));
  //       }
  //     }
  //     else if(_bottomNavIndex == 1) {
  //         var route = ModalRoute.of(context);
  //         if (route != null) {
  //           Navigator
  //               .of(context)
  //               .pushReplacement(
  //               MaterialPageRoute(builder: (BuildContext context) =>
  //                   MyBottomTwoPage(aapbarVisibility: true,)));
  //         }
  //     }
  //     else if(_bottomNavIndex == 2) {
  //       // Navigator.pop(context);
  //       var route = ModalRoute.of(context);
  //       if (route != null) {
  //         Navigator
  //             .of(context)
  //             .pushReplacement(
  //             MaterialPageRoute(builder: (BuildContext context) =>
  //                 MyBottomThreePage(aapbarVisibility: true,)));
  //       }
  //     }
  //   }
  //   else if(index == 3){
  //     Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => const MyProfilePage()),
  //     );
  //   }
  //   else if(index == 4 && typeOfOrganizationData != "Farmer groups"){
  //     var route = ModalRoute.of(context);
  //     if (route != null) {
  //       Navigator
  //           .of(context)
  //           .pushReplacement(
  //           MaterialPageRoute(builder: (BuildContext context) =>
  //               MyBottomCenterEnquiryPage(aapbarVisibility: true,)));
  //     }
  //   }
  //   else{
  //     var route = ModalRoute.of(context);
  //     if (route != null) {
  //       Navigator
  //           .of(context)
  //           .pushReplacement(
  //           MaterialPageRoute(builder: (BuildContext context) =>
  //               MyBottomCenterEnquiryPage(aapbarVisibility: true,)));
  //     }
  //   }
  // }

  Future<void> getPrefValue() async {
    typeOfOrganizationData = await SharedPref.readPreferenceValue(typeOfOrganization, PrefEnum.STRING);
    print("Home TypeOfOrganizationData : $typeOfOrganizationData");
    setState(() {
      typeOfOrganizationData = typeOfOrganizationData;
    });
  }

  Future<void> _onItemTapped(int index) async {

    print("Home index : $index");
    if (index != 3) {
      setState(() {
        _bottomNavIndex = index;
      });
      if(_bottomNavIndex == 0) {
        // Navigator.pop(context);
        var route = ModalRoute.of(context);
        if (route != null) {
          Navigator
              .of(context)
              .pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) =>
                  BottomOnePage(aapbarVisibility: true,)));
        }
      }
      else if(_bottomNavIndex == 1) {
        var route = ModalRoute.of(context);
        if (route != null) {
          Navigator
              .of(context)
              .pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) =>
                  BottomTwoPage(aapbarVisibility: true,)));
        }
      }
      else if(_bottomNavIndex == 2) {
        // Navigator.pop(context);
        var route = ModalRoute.of(context);
        if (route != null) {
          Navigator
              .of(context)
              .pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) =>
                  BottomThreePage(aapbarVisibility: true,)));
        }
      }
    }
    else if(index == 3){
      if (_isClickAllowed) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        _isClickAllowed = false;
        await Future.delayed(Duration(seconds: 2));
        _isClickAllowed = true;
      }
    }
    else{
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator
            .of(context)
            .push(
            MaterialPageRoute(builder: (BuildContext context) =>
                BottomCenterEnquiryPage(aapbarVisibility: true,)));
      }
    }
  }

  void _onItemTappedData(int index) {

    print("Home1 index : $index");
    if (index != 3) {
      setState(() {
        _bottomNavIndex = index;
      });
      if(_bottomNavIndex == 0) {
        var route = ModalRoute.of(context);
        if (route != null) {
          Navigator
              .of(context)
              .pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) =>
                  BottomOnePage(aapbarVisibility: true,)));
        }
      }
    }
    else if(index == 3){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
    else{
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator
            .of(context)
            .push(
            MaterialPageRoute(builder: (BuildContext context) =>
                BottomCenterEnquiryPage(aapbarVisibility: true,)));
      }
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