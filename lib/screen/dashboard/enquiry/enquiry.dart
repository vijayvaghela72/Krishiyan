import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../helper/shared_pref.dart';
import '../../language/select_language.dart';
import 'package:krishiyan/helper/color.dart';
import 'package:krishiyan/helper/constant.dart';
import 'package:krishiyan/helper/provider.dart';
import '../../../mvc/model/crop_name_model.dart';
import '../../../localization/app_localizations.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:krishiyan/screen/dashboard/dashborad.dart';
import 'package:krishiyan/screen/dashboard/enquiry/enquiry_model.dart';
import 'package:krishiyan/screen/dashboard/enquiry/enquiry_provider.dart';
import 'package:krishiyan/screen/dashboard/enquiry/my_enquiry/my_enquiry.dart';
import 'package:krishiyan/screen/dashboard/enquiry/post_enquiry/post_enquiry.dart';
import 'package:krishiyan/screen/dashboard/enquiry/view_enquiry/view_enquiry.dart';

// ignore: must_be_immutable
class EnquiryScreen extends StatefulWidget {
  bool aapbarVisibility;
  final String? typeOfOrganization;

  EnquiryScreen(
      {super.key, required this.aapbarVisibility, this.typeOfOrganization});

  @override
  State<EnquiryScreen> createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen>
    with TickerProviderStateMixin {
  String? selectedItemValue;

  final List<String> topData = [
    buildTranslate("viewEnquiries")!,
    buildTranslate("postEnquiries")!,
    buildTranslate("myEnquiries")!,
  ];

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

  String typeOfOrganizationData = "";

  List<cropsCategory> search_crops = [
    cropsCategory(
        name: "Total Farmer 350", id: "1", icon: 'assets/images/crops1.png'),
    cropsCategory(
        name: "Total Farmer Land(in HA) 125400",
        id: "2",
        icon: 'assets/images/crops2.png'),
    cropsCategory(
        name: "Expected Yield(in Qtl)256300",
        id: "3",
        icon: 'assets/images/crops1.png'),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  setStateNow() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    enquiryProvider = Provider.of<EnquiryProvider>(context, listen: false);
    enquiryProvider!.initalizeVarible(setStateNow);
    _fetchCropData();
    getPrefValue();
  }

  Future<void> getPrefValue() async {
    typeOfOrganizationData = await SharedPref.readPreferenceValue(
        typeOfOrganization, PrefEnum.STRING);
    print(
        "BottomCenterEnquiry TypeOfOrganizationData : $typeOfOrganizationData");
    setState(() {
      typeOfOrganizationData = typeOfOrganizationData;
      print(typeOfOrganizationData);
    });
  }

  Future<void> _fetchCropData() async {
    try {
      final response = await getAPICall(apiUrl: CROPS_NAMES);

      if (response.statusCode == 200) {
        setState(() {
          enquiryProvider!.cropData =
              SelectCropNamesData.fromJson(jsonDecode(response.body));
        });
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (e) {
      print('My BottomCenterEnquiry : Error fetching crop data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),
      extendBody: false,
      key: _scaffoldKey,
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
                      padding: const EdgeInsets.only(right: 5, top: 12),
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
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 20),
              child: Container(
                height: 80,
                child: ListView.builder(
                  itemCount: topData.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        enquiryProvider!.selectedTopData = index;
                        setState(() {});
                        print(
                            "Selected Top Page : ${enquiryProvider!.selectedTopData}");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Chip(
                          backgroundColor:
                              enquiryProvider!.selectedTopData == index
                                  ? Colors.green
                                  : Colors.white,
                          padding: const EdgeInsets.all(8),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                            Radius.circular(17),
                          )),
                          label: Text(
                            topData[index].toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "poppins-regular",
                              color: enquiryProvider!.selectedTopData == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            enquiryProvider!.selectedTopData == 0
                ? viewEnquery(context, setStateNow)
                : enquiryProvider!.selectedTopData == 1
                    ? postEnquiryWidget(context)
                    : enquiryProvider!.selectedTopData == 2
                        ? myEnquiryWidget(context, setStateNow)
                        : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.whiteColor.withAlpha(0), // add this line.
        elevation: 0, // also important, removes the shadow
        heroTag: "floatingActionBtn",
        shape: const RoundedRectangleBorder(
          // <= Change BeveledRectangleBorder to RoundedRectangularBorder
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Image.asset(
          'assets/images/bottomCenter.png',
        ),
        onPressed: () {
          print("Center dock");
          setState(() {
            typeOfOrganizationData == "Farmer groups"
                ? Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => EnquiryScreen(
                          aapbarVisibility: true,
                        )))
                : Container();
            // _onItemTapped(4);
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: typeOfOrganizationData == "Farmer groups"
          ? Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30), // Top-left corner
                    topRight: Radius.circular(30), // Top-right corner
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: 0.2,
                      color: AppColor.whiteColor,
                    ),
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: BottomNavigationBar(
                  currentIndex: enquiryProvider!.bottomNavIndex,
                  onTap: (index) {
                    setState(() {
                      enquiryProvider!.bottomNavIndex = index;
                    });
                    _onItemTapped(enquiryProvider!.bottomNavIndex);
                    print(
                        "_bottomNavIndex 1: ${enquiryProvider!.bottomNavIndex}");
                  },
                  selectedLabelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  items: iconList1.map((category) {
                    return BottomNavigationBarItem(
                      icon: Image.asset(
                        category.icon ?? "",
                        width: 25,
                        height: 25,
                        color: enquiryProvider!.bottomNavIndex ==
                                iconList1.indexOf(category)
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
                    topLeft: Radius.circular(30), // Top-left corner
                    topRight: Radius.circular(30), // Top-right corner
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
                      30), // Matches the Container's border radius
                  topRight: Radius.circular(
                      30), // Matches the Container's border radius
                ),
                child: BottomNavigationBar(
                  currentIndex: enquiryProvider!.bottomNavIndex,
                  onTap: (index) {
                    setState(() {
                      enquiryProvider!.bottomNavIndex =
                          index; // Set the current index when tapped
                      _onItemTappedData(enquiryProvider!.bottomNavIndex);
                    });
                    print(
                        "_bottomNavIndex 2: ${enquiryProvider!.bottomNavIndex}");
                  },
                  selectedItemColor: Colors.grey,
                  unselectedItemColor: Colors.grey,
                  items: iconList2.map((category) {
                    return BottomNavigationBarItem(
                      icon: Image.asset(
                        category.icon ?? "",
                        width: 25,
                        height: 25,
                        color: enquiryProvider!.bottomNavIndex ==
                                iconList2.indexOf(category)
                            ? Colors.green
                            : Colors.grey,
                      ),
                      label: category.name,
                    );
                  }).toList(),
                  type: BottomNavigationBarType.fixed,
                ),
              ),
            ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      enquiryProvider!.bottomNavIndex = index;
      print(enquiryProvider!.bottomNavIndex);
    });
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => HomePage(
            selectedIndex: enquiryProvider!.bottomNavIndex,
            typeOfOrganization: typeOfOrganizationData)));
  }

  void _onItemTappedData(int index) {
    setState(() {
      enquiryProvider!.bottomNavIndex = index;
      print(enquiryProvider!.bottomNavIndex);
    });
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => HomePage(
          selectedIndex: enquiryProvider!.bottomNavIndex,
          typeOfOrganization: typeOfOrganizationData,
        ),
      ),
    );
  }
}
