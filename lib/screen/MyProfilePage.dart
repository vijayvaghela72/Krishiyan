import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/SharedPref.dart';
import '../localization/AppLocalizations.dart';
import '../utils/AppGlobal.dart';
import '../utils/Constants.dart';
import 'MyBottomCenterEnquiryPage.dart';
import 'MyBottomOnePage.dart';
import 'MyBottomThreePage.dart';
import 'MyBottomTwoPage.dart';
import 'MyEditAddressPage.dart';
import 'MyEditBankDetailPage.dart';
import 'MyEditOtherProfilePage.dart';
import 'MyOtherDetailPage.dart';
import 'MyEditProfilePage.dart';
import 'MyForgotPasswordPage.dart';
import 'MyHomePage.dart';
import 'MyLoginPage.dart';

class MyProfilePage extends StatefulWidget {

  const MyProfilePage({super.key,});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> with TickerProviderStateMixin{

  var _bottomNavIndex = 3; //default index of a first screen

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
        name: buildTranslate("home")!,
        id: "1", icon: 'assets/images/bottom1.png'),
    bottomCategory(
        name: buildTranslate("profile")!,
        id: "2",
        icon: 'assets/images/bottom4.png'),
  ];

  String name = "", email = "", contactNumber = "";
  String typeOfOrganizationData = "";

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

    getDetails();
    getPrefValue();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose(); // Dispose the controller
    _borderRadiusAnimationController.dispose(); // Dispose the controller
    _hideBottomBarAnimationController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Text(
          buildTranslate("myProfile")!,
          style: const TextStyle(color: Colors.white, fontFamily: 'poppins-semibold', fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 40.0, bottom: 18.0, right: 18.0, left: 18.0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage("assets/images/user_profile.png"),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name ?? "", softWrap: true,
                        style: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'poppins-semibold'),),
                      Text(email ?? "", softWrap: true,
                        style: const TextStyle(color: Color(0xFF888888), fontSize: 14, fontFamily: 'poppins-regular'),),
                      Text(contactNumber ?? "", softWrap: true,
                        style: const TextStyle(color: Color(0xFF888888), fontSize: 14, fontFamily: 'poppins-regular'),),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Text(buildTranslate("updateYourProfile")!, softWrap: true,
                style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'poppins-semibold'),),
            ),

            // edit profile
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                typeOfOrganizationData == "Farmer groups" ?
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyEditProfilePage()),
                ) :
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyEditOtherProfilePage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 30.0, bottom: 20.0, right: 18.0, left: 18.0),
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/images/edit_profile.png', height: 20, width: 20,),
                    const SizedBox(width: 10,),
                    Text(buildTranslate("editProfile")!, softWrap: true,
                      style: const TextStyle(color: Colors.black, fontSize: 17, fontFamily: 'poppins-regular'),),
                  ],
                ),
              ),
            ),

            // edit address
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyEditAddressPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 20.0, right: 18.0, left: 18.0),
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/images/other_details.png', height: 20, width: 20,),
                    const SizedBox(width: 10,),
                    Text(buildTranslate("editAddress")!, softWrap: true,
                      style: const TextStyle(color: Colors.black, fontSize: 17, fontFamily: 'poppins-regular'),),
                  ],
                ),
              ),
            ),

            // edit bank details
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyEditBankDetailPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 20.0, right: 18.0, left: 18.0),
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/images/edit_bankDetails.png', height: 20, width: 20,),
                    const SizedBox(width: 10,),
                    Text(buildTranslate("editBankDetails")!, softWrap: true,
                      style: const TextStyle(color: Colors.black,
                          fontSize: 17, fontFamily: 'poppins-regular'),),
                  ],
                ),
              ),
            ),

            // other details
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyOtherDetailPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 20.0, right: 18.0, left: 18.0),
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/images/other_details.png', height: 20, width: 20,),
                    const SizedBox(width: 10,),
                    Text(buildTranslate("otherDetails")!, softWrap: true,
                      style: const TextStyle(color: Colors.black,
                          fontSize: 17, fontFamily: 'poppins-regular'),),
                  ],
                ),
              ),
            ),

            // reset password
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyForgotPasswordPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 20.0, right: 18.0, left: 18.0),
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/images/reset_password.png', height: 20, width: 20,),
                    const SizedBox(width: 10,),
                    Text(buildTranslate("resetPassword")!, softWrap: true,
                      style: const TextStyle(color: Colors.black, fontSize: 17, fontFamily: 'poppins-regular'),),
                  ],
                ),
              ),
            ),

            // logout
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear user data

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MyLoginPage()),
                      (Route<dynamic> route) => false,
                );

                // Navigator.pushReplacement(
                //   context, MaterialPageRoute(builder: (context) => const MyLoginPage()),);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 20.0, right: 18.0, left: 18.0),
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/images/logout.png', height: 20, width: 20,),
                    const SizedBox(width: 10,),
                    Text(buildTranslate("logout")!, softWrap: true,
                      style: const TextStyle(color: Colors.black,
                          fontSize: 17, fontFamily: 'poppins-regular'),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withAlpha(0), // add this line.
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
      bottomNavigationBar:
      // AnimatedBottomNavigationBar.builder(
      //   height: 70,
      //   itemCount: iconList1.length,
      //   tabBuilder: (int index, bool isActive) {
      //     final color = isActive
      //         ? Colors.green
      //         : Colors.grey;
      //     return Column(
      //       mainAxisSize: MainAxisSize.min,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Image.asset(
      //           iconList1[index].icon ?? "",
      //           color: color,
      //           width: 25, height: 25,
      //         ),
      //         const SizedBox(height: 5),
      //         Text(
      //           iconList1[index].name ?? "",
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
      //   hideAnimationController: _hideBottomBarAnimationController,
      //   shadow: const BoxShadow(
      //     offset: Offset(0, 1),
      //     blurRadius: 2,
      //     spreadRadius: 0.2,
      //     color: Colors.white,
      //   ),
      // )
      typeOfOrganizationData == "Farmer groups" ?
      AnimatedBottomNavigationBar.builder(
        height: 70,
        itemCount: iconList1.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive
              ? Colors.green
              : Colors.grey;
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
        hideAnimationController: _hideBottomBarAnimationController,
        shadow: const BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          spreadRadius: 0.2,
          color: Colors.white,
        ),
      ) :
      AnimatedBottomNavigationBar.builder(
        height: 70,
        itemCount: iconList2.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive
              ? Colors.green
              : Colors.grey;
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

    print("Profile index : $index");

    if (index == 0) {
      Navigator.pop(context);
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
      // if (typeOfOrganization == "Farmer groups") {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MyProfilePage()),
      );
      // }
    }
    else if(index == 4){
      // if (typeOfOrganization == "Farmer groups") {
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator
            .of(context)
            .pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) =>
                MyBottomCenterEnquiryPage(aapbarVisibility: true,)));
      }
      // }
    }

    else {
      setState(() {
        _bottomNavIndex = index;
      });
      print("Profile : bottomNavIndex : $_bottomNavIndex");
    }

  }
  // void _onItemTapped(int index) {
  //
  //   print("Profile index : $index");
  //
  //    if (index == 0) {
  //      if (typeOfOrganization == "Farmer groups") {
  //        // Navigator.pop(context);
  //        var route = ModalRoute.of(context);
  //        if (route != null) {
  //          Navigator
  //              .of(context)
  //              .pushReplacement(
  //              MaterialPageRoute(builder: (BuildContext context) =>
  //                  MyBottomOnePage(aapbarVisibility: true,)));
  //        }
  //      } else{
  //        Navigator.pop(context);
  //        Navigator
  //            .of(context)
  //            .pushReplacement(
  //            MaterialPageRoute(builder: (BuildContext context) =>
  //                MyHomePage(selectedIndex: 0,)));
  //      }
  //    }
  //    else if(index ==1) {
  //      // Navigator.pop(context);
  //      if (typeOfOrganization == "Farmer groups") {
  //        var route = ModalRoute.of(context);
  //        if (route != null) {
  //          Navigator
  //              .of(context)
  //              .pushReplacement(
  //              MaterialPageRoute(builder: (BuildContext context) =>
  //                  MyBottomTwoPage(aapbarVisibility: true,)));
  //        }
  //      }
  //    }
  //    else if(index ==2) {
  //      if (typeOfOrganization == "Farmer groups") {
  //        // Navigator.pop(context);
  //        var route = ModalRoute.of(context);
  //        if (route != null) {
  //          Navigator
  //              .of(context)
  //              .pushReplacement(
  //              MaterialPageRoute(builder: (BuildContext context) =>
  //                  MyBottomThreePage(aapbarVisibility: true,)));
  //        }
  //      }
  //      else{
  //        var route = ModalRoute.of(context);
  //        if (route != null) {
  //          Navigator
  //              .of(context)
  //              .pushReplacement(
  //              MaterialPageRoute(builder: (BuildContext context) =>
  //                  MyBottomCenterEnquiryPage(aapbarVisibility: true,)));
  //        }
  //      }
  //    }
  //    else if(index == 3){
  //      if (typeOfOrganization == "Farmer groups") {
  //        Navigator.of(context).push(
  //          MaterialPageRoute(builder: (context) => MyProfilePage()),
  //        );
  //      }
  //    }
  //    else if(index == 4){
  //      if (typeOfOrganization == "Farmer groups") {
  //        var route = ModalRoute.of(context);
  //        if (route != null) {
  //          Navigator
  //              .of(context)
  //              .pushReplacement(
  //              MaterialPageRoute(builder: (BuildContext context) =>
  //                  MyBottomCenterEnquiryPage(aapbarVisibility: true,)));
  //        }
  //      }
  //    }
  //
  //   else {
  //      setState(() {
  //        _bottomNavIndex = index;
  //      });
  //      print("Profile : bottomNavIndex : $_bottomNavIndex");
  //   }
  //
  // }

  Future<void> getDetails() async {
    name = (await AppGlobal.getStringPreference('name'))!;
    email = (await AppGlobal.getStringPreference('email'))!;
    contactNumber = (await AppGlobal.getStringPreference('contactNumber'))!;

    setState(() {
      name = name;
      email = email;
      contactNumber = contactNumber;
    });
  }

  Future<void> getPrefValue() async {
    typeOfOrganizationData = await SharedPref.readPreferenceValue(typeOfOrganization, PrefEnum.STRING);
    print("Profile TypeOfOrganizationData : $typeOfOrganizationData");
    if(typeOfOrganizationData == "Farmer groups" ) {
      _bottomNavIndex = 3;
    }
    else{
      _bottomNavIndex = 1;
    }
    setState(() {
      typeOfOrganizationData = typeOfOrganizationData;
      _bottomNavIndex = _bottomNavIndex;
    });
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