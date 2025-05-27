import 'dart:async';
import 'package:krishiyan/helper/color.dart';
import '../../helper/constant.dart';
import '../../helper/shared_pref.dart';
import 'package:flutter/material.dart';
import 'crop/crop.dart';
import 'profile/profile.dart';
import '../language/select_language.dart';
import 'enquiry/enquiry.dart';
import '../../localization/app_localizations.dart';
import 'package:krishiyan/screen/dashboard/home/home.dart';
import 'package:krishiyan/screen/dashboard/frm/frm.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  final String typeOfOrganization;
  int selectedIndex;

  HomePage(
      {super.key,
      required this.selectedIndex,
      required this.typeOfOrganization});

  static void setLocale(BuildContext context, Locale newLocale) async {
    print("setLocal : $newLocale");
    _HomePageState? state = context.findAncestorStateOfType<_HomePageState>();
    state?.changeLanguage(newLocale);
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var _bottomNavIndex = 0;

  List<bottomCategory> iconList1 = [
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

  List<bottomCategory> iconList2 = [
    bottomCategory(
        name: buildTranslate("home")!,
        id: "1",
        icon: 'assets/images/bottom1.png'),
    bottomCategory(
        name: buildTranslate("profile")!,
        id: "2",
        icon: 'assets/images/bottom4.png'),
  ];

  final List<Widget> _screens1 = [
    HomeScreen(aapbarVisibility: false),
    FRM(
      aapbarVisibility: false,
    ),
    CropLibraryScreen(
      aapbarVisibility: false,
    ),
    const Profile(),
    EnquiryScreen(
      aapbarVisibility: false,
    ),
  ];

  final List<Widget> _screens2 = [
    HomeScreen(aapbarVisibility: false),
    const Profile(),
    EnquiryScreen(
      aapbarVisibility: false,
    ),
  ];

  String typeOfOrganizationData = "";

  changeLanguage(Locale locale) {
    setState(() {
      locale;
    });
  }

  @override
  void initState() {
    super.initState();
    _bottomNavIndex = widget.selectedIndex;
    typeOfOrganizationData = widget.typeOfOrganization;
    print(_bottomNavIndex);
    getPrefValue();
  }

  @override
  Widget build(BuildContext context) {
    // Print the current bottomNavIndex before returning the body
    print(typeOfOrganizationData);
    bool isFarmerGroup = typeOfOrganizationData == "Farmer groups";
    print("Current _bottomNavIndex: $_bottomNavIndex");
    return Scaffold(
        extendBody: true,
        backgroundColor: AppColor.backgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: typeOfOrganizationData == "Trader"
            ? _bottomNavIndex == 1
                ? null
                : AppBar(
                    automaticallyImplyLeading: false,
                    title: InkWell(
                      highlightColor: AppColor.transparentColor,
                      splashColor: AppColor.transparentColor,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SelectLanguagePage())).then((value) {
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
                          Image.asset(
                            'assets/images/loginLogo.png',
                            width: 150,
                            height: 60,
                          ),
                          const Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 5.0, top: 12.0),
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
            : _bottomNavIndex != 3
                ? AppBar(
                    automaticallyImplyLeading: false,
                    title: InkWell(
                      highlightColor: AppColor.transparentColor,
                      splashColor: AppColor.transparentColor,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SelectLanguagePage())).then((value) {
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
                          Image.asset(
                            'assets/images/loginLogo.png',
                            width: 150,
                            height: 60,
                          ),
                          const Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 5.0, top: 12.0),
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
        body: typeOfOrganizationData == "Farmer groups"
            ? _screens1[_bottomNavIndex]
            : _screens2[_bottomNavIndex],
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.whiteColor.withAlpha(0), // add this line.
          elevation: 0, // also important, removes the shadow
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
            highlightColor: AppColor.transparentColor,
            splashColor: AppColor.transparentColor,
            onTap: () {
              print("Center dock");
              setState(() {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => EnquiryScreen(
                          aapbarVisibility: true,
                          typeOfOrganization: typeOfOrganizationData,
                        )));
              });
            },
            child: Image.asset(
              'assets/images/bottomCenter.png',
            ),
          ),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: () {
          print(typeOfOrganizationData);
          print("printing farmergroup");
          print(isFarmerGroup);
          return isFarmerGroup;
        }()
            ? Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0), // Top-left corner
                      topRight: Radius.circular(30.0), // Top-right corner
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        blurRadius: 2,
                        spreadRadius: 0.8,
                        color: AppColor.whiteColor,
                      ),
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        30.0), // Matches the Container's border radius
                    topRight: Radius.circular(
                        30.0), // Matches the Container's border radius
                  ),
                  child: BottomNavigationBar(
                    currentIndex: _bottomNavIndex,
                    onTap: (index) {
                      setState(() {
                        _bottomNavIndex =
                            index; // Set the current index when tapped
                        print("This is the set state index");
                        print("BBBBBBBBBBBBBBBBBBBBBB");
                        print(_bottomNavIndex);
                      });
                      print("_bottomNavIndex 1 home: $_bottomNavIndex");
                    },
                    selectedItemColor: Colors.grey,
                    unselectedItemColor: Colors.grey,
                    items: iconList1.map((category) {
                      return BottomNavigationBarItem(
                        icon: Image.asset(
                          category.icon ?? "",
                          width: 25,
                          height: 25,
                          color: _bottomNavIndex == iconList1.indexOf(category)
                              ? Colors.green
                              : Colors.grey,
                        ),
                        label: category.name,
                      );
                    }).toList(),
                    type: BottomNavigationBarType
                        .fixed, // Keeps the icons in a fixed position
                  ),
                ),
              )
            : Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0), // Top-left corner
                      topRight: Radius.circular(30.0), // Top-right corner
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        spreadRadius: 0.8,
                        color: AppColor.whiteColor,
                      ),
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        30.0), // Matches the Container's border radius
                    topRight: Radius.circular(
                        30.0), // Matches the Container's border radius
                  ),
                  child: BottomNavigationBar(
                    currentIndex: _bottomNavIndex,
                    onTap: (index) {
                      setState(() {
                        _bottomNavIndex =
                            index; // Set the current index when tapped
                        print("This is the set state index");

                        print(_bottomNavIndex);
                      });
                      print("_bottomNavIndex 2: $_bottomNavIndex");
                    },
                    selectedItemColor: Colors.grey,
                    unselectedItemColor: Colors.grey,
                    items: iconList2.map((category) {
                      return BottomNavigationBarItem(
                        icon: Image.asset(
                          category.icon ?? "",
                          width: 25,
                          height: 25,
                          color: _bottomNavIndex == iconList2.indexOf(category)
                              ? Colors.green
                              : Colors.grey,
                        ),
                        label: category.name,
                      );
                    }).toList(),
                    type: BottomNavigationBarType
                        .fixed, // Keeps the icons in a fixed position
                  ),
                ),
              ));
  }

  Future<void> getPrefValue() async {
    typeOfOrganizationData = await SharedPref.readPreferenceValue(
        typeOfOrganization, PrefEnum.STRING);
    print("Home TypeOfOrganizationData : $typeOfOrganizationData");
    setState(() {
      typeOfOrganizationData = typeOfOrganizationData;
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
