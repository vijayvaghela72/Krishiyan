import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../language/select_language.dart';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/helper/provider.dart';
import '../../../localization/app_localizations.dart';
import 'package:krishiyan/mvc/model/frm_insight_model.dart';
import 'package:krishiyan/screen/dashboard/frm/frm_model.dart';
import 'package:krishiyan/screen/dashboard/frm/frm_provider.dart';
import '../../../mvc/controller/farmer_dashboard_controller.dart';
import 'package:krishiyan/screen/dashboard/frm/farmer_dashboard/insight/insight.dart';
import 'package:krishiyan/screen/dashboard/frm/farmer_dashboard/farmer_dashboard.dart';
import 'package:krishiyan/screen/dashboard/frm/farmer_dashboard/farmer_registration.dart';
import 'package:krishiyan/screen/dashboard/frm/farmer_dashboard/crop_cultivation/crop_cultivator.dart';
import 'package:krishiyan/screen/dashboard/frm/farmer_dashboard/insight/farmer_listing/farmer_listing.dart';

// ignore: must_be_immutable
class FRM extends StatefulWidget {
  bool aapbarVisibility;
  String? villageName, typeName;

  FRM({
    super.key,
    required this.aapbarVisibility,
    this.villageName,
    this.typeName,
  });

  @override
  State<FRM> createState() => _FRMState();
}

class _FRMState extends State<FRM> with TickerProviderStateMixin {
  final List<String> topData = [
    buildTranslate("farmerDashboard")!,
    buildTranslate("farmerRegistration")!,
    buildTranslate("cropCultivation")!,
    buildTranslate("insights")!
  ];
  setStateNow() {
    if (mounted) {
      setState(() {});
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Farmer> sortedFarmers = []; // To hold the sorted farmers list

  var farmerDashboardList;
  // SelectCropNamesData? _cropData;

  String number = "";

  Future<InsightDetails?>? futureSearchInsightDetails;
  String dealerNumberData = "";
  @override
  void dispose() {
    // Always cancel the timer when the widget is disposed
    frmProvider!.otpCooldownTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    frmProvider = Provider.of<FRMProvider>(context, listen: false);
    frmProvider!.villageName = widget.villageName;
    frmProvider!.typeName = widget.typeName;
    frmProvider!.futureFarmerProfiles =
        FarmerDashboardController.fetchFarmerDashboard(
            context, widget.villageName, widget.typeName);
    getAllData();
    frmProvider!.initializeCrop();
  }

  getAllData() async {
    showLoading();
    await frmProvider!.fetchCrops(setStateNow);
    await frmProvider!.fetchFarmerNameData();
    await frmProvider!.getVillageData(setStateNow, false);
    frmProvider!.futureFrminSight = frmProvider!.fetchInsightsData(true);
    stopLoading();
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
                        frmProvider!.selectedTopData = index;
                        if (frmProvider!.selectedTopData == 0) {
                          if (mounted) {
                            frmProvider!.futureFarmerProfiles =
                                FarmerDashboardController.fetchFarmerDashboard(
                                    context,
                                    widget.villageName,
                                    widget.typeName);
                          }
                        }
                        print(
                            "Selected Top Page : ${frmProvider!.selectedTopData}");
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Chip(
                          backgroundColor: frmProvider!.selectedTopData == index
                              ? Colors.green
                              : Colors.white,
                          padding: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: frmProvider!.selectedTopData == index
                                      ? Colors.green
                                      : Colors.black),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              )),
                          label: Text(
                            topData[index].toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "poppins-regular",
                              color: frmProvider!.selectedTopData == index
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
            frmProvider!.selectedTopData == 0
                ? firstTabData(context, setStateNow)
                : frmProvider!.selectedTopData == 1
                    ? secondTabData(context, setStateNow)
                    : frmProvider!.selectedTopData == 2
                        ? thirdTabData(context, setStateNow)
                        : frmProvider!.selectedTopData == 3
                            ? FourthTab()
                            : frmProvider!.selectedTopData == 4
                                ? getFarmerListing(context, setStateNow)
                                : Container(),
          ],
        ),
      ),
    );
  }
}
