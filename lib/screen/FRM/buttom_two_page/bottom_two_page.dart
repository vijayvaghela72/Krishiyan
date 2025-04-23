import 'dart:async';
import 'dart:convert';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/helper/snackbar.dart';
import '../FarmerProfile.dart';
import 'package:intl/intl.dart';
import '../CropCultivationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/AppGlobal.dart';
import '../../../utils/Constants.dart';
import '../EditCropCultivationPage.dart';
import '../../../helper/AlertHelper.dart';
import 'package:otp_text_field/style.dart';
import 'package:otp_text_field/otp_field.dart';
import '../../Language/SelectLanguagePage.dart';
import '../../../mvc/controller/otpController.dart';
import '../../../localization/AppLocalizations.dart';
import 'package:krishiyan/mvc/model/FrmInsight.dart';
import 'package:krishiyan/mvc/model/InsightData.dart';
import 'package:page_transition/page_transition.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:krishiyan/mvc/model/GetOtpDetails.dart';
import '../../../mvc/model/SelectVillagesNameData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishiyan/mvc/model/FarmerDashboardData.dart';
import '../../../mvc/controller/farmerDashboardController.dart';
import 'package:krishiyan/screen/AccountSettings/FarmerEditProfilePage.dart';

// ignore: must_be_immutable
class BottomTwoPage extends StatefulWidget {
  bool aapbarVisibility;
  String? villageName, typeName;

  BottomTwoPage(
      {super.key,
      required this.aapbarVisibility,
      this.villageName,
      this.typeName});

  @override
  State<BottomTwoPage> createState() => _BottomTwoPageState();
}

class _BottomTwoPageState extends State<BottomTwoPage>
    with TickerProviderStateMixin {
  final List<String> topData = [
    buildTranslate("farmerDashboard")!,
    buildTranslate("farmerRegistration")!,
    buildTranslate("cropCultivation")!,
    buildTranslate("insights")!
  ];

  Future<FrmInsight?>? _futureFrminSight;
  List<bottomCategory> iconList = [
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

  int selectedTopData = 0;
  bool otpVisible = false;

  List<cropsCategory> search_crops = [
    cropsCategory(
        name: "Total Farmer", id: "1", icon: 'assets/images/crops1.png'),
    cropsCategory(
        name: "Total Farmer Land(in HA)",
        id: "2",
        icon: 'assets/images/crops2.png'),
    cropsCategory(
        name: "Expected Yield(in Qtl)",
        id: "3",
        icon: 'assets/images/crops1.png'),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool searchCropsFlag = false;
  int? showCropDataVisible;

  final List<String> items = [
    buildTranslate('organic')!,
    buildTranslate('inOrganic')!,
  ];

  String? selectedItemValue;

  final List<String> sortItems = [
    buildTranslate("highExpYield")!,
    buildTranslate("lowExpYield")!,
  ];

  String? selectedSortItemsValue;
  List<Farmer> sortedFarmers = []; // To hold the sorted farmers list

  var farmerDashboardList;

  TextEditingController searchByNaneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController whatsAppNumberController = TextEditingController();

  TextEditingController varietyController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController geoLocationController = TextEditingController();
  TextEditingController areaInArcesController = TextEditingController();
  TextEditingController geoLinkAreaOnMapController = TextEditingController();
  late OtpFieldController otpController = OtpFieldController();
  String enteredOtp = '';
  String otpData = "";

  String? _selectedCrop;

  // SelectCropNamesData? _cropData;

  List<String> crops = [];

  SelectVillagesNameData? _villageNameData;
  String? _selectedVillageName;

  String? _selectedFarmersName;
  List<DropdownMenuItem<String>>? dropdownItems;
  String number = "";

  Future<InsightDetails?>? futureSearchInsightDetails;
  String dealerNumberData = "";

  late Future<List<FarmerDetails>> futureFarmerProfiles;
  String _searchText = '';
  String WhatsappNumberData = '';

  bool isOtpButtonEnabled = true; // Track OTP button status
  String countdownText = ''; // To show countdown text (e.g., "Wait 1:45")
  Timer? otpCooldownTimer; // Timer to track cooldown

  void startOtpCooldown() {
    setState(() {
      isOtpButtonEnabled = false; // Disable the OTP button
    });

    // Set the initial cooldown time (2 minutes = 120 seconds)
    int cooldownTime = 120; // 2 minutes in seconds

    // Update the countdown text every second
    otpCooldownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Calculate minutes and seconds
        int minutes = cooldownTime ~/ 60; // Integer division to get minutes
        int seconds = cooldownTime % 60; // Modulo operation to get seconds

        // Format as MM:SS, ensuring two digits for minutes and seconds
        countdownText =
            "Please wait ${_formatTime(minutes)}:${_formatTime(seconds)} before trying again.";
      });

      if (cooldownTime == 0) {
        timer.cancel(); // Stop the timer when the cooldown is over
        setState(() {
          isOtpButtonEnabled = true; // Re-enable the OTP button
          countdownText = ""; // Clear the countdown text
        });
      } else {
        cooldownTime--; // Decrease the cooldown time by 1 second
      }
    });
  }

// Helper function to format time as two digits
  String _formatTime(int time) {
    return time < 10 ? "0$time" : "$time";
  }

  @override
  void dispose() {
    // Always cancel the timer when the widget is disposed
    otpCooldownTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureFarmerProfiles = FarmerDashboardController.fetchFarmerDashboard(
        context, widget.villageName, widget.typeName);
    getAllData();
  }

  getAllData() async {
    showLoading();
    await fetchCrops();
    await _fetchFarmerNameData();
    await _fetchVillageData();
    stopLoading();
  }

  // onTextChanged function to call the API
  void _onSearchTextChanged(String text) {
    if (mounted) {
      setState(() {
        _searchText = text;
      });
    }
    if (_searchText.isNotEmpty) {
      if (mounted) {
        setState(() {
          futureFarmerProfiles =
              FarmerDashboardController.fetchSearchFarmerDashboard(
                  context, _searchText);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          futureFarmerProfiles = FarmerDashboardController.fetchFarmerDashboard(
              context, widget.villageName, widget.typeName);
        });
      }
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
              padding: const EdgeInsets.only(left: 10.0, right: 20.0),
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
                        setState(() {
                          _onSelectedTopDataTapped(index);
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Chip(
                            backgroundColor: selectedTopData == index
                                ? Colors.green
                                : Colors.white,
                            padding: const EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: selectedTopData == index
                                        ? Colors.green
                                        : Colors.black),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                )),
                            label: Text(topData[index].toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "poppins-regular",
                                  color: selectedTopData == index
                                      ? Colors.white
                                      : Colors.black,
                                )),
                          )),
                    );
                  },
                ),
              ),
            ),
            selectedTopData == 0
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xFFd3d3d3), width: 1),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  buildTranslate("searchBy")!,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'poppins-regular'),
                                ),
                              ),
                              Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: TextFormField(
                                      maxLength: 10,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9]')),
                                        //To remove first '0'
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'^0+')),
                                        //To remove first '94' or your country code
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'^94+')),
                                      ],
                                      decoration: InputDecoration(
                                        // alignLabelWithHint: true,
                                        counterText: '',
                                        // This hides the "1/10" counter label
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFd3d3d3),
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        hintText: buildTranslate(
                                            'mobileNumberOrCrop'),
                                        hintStyle: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      validator: (value) => value!.isEmpty
                                          ? 'Please, fill this field.'
                                          : null,
                                      controller: searchByNaneController,
                                      onChanged: _onSearchTextChanged,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              buildTranslate("allFarmers")!,
                              softWrap: true,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 17,
                                  fontFamily: 'poppins-semibold'),
                            ),
                            const Spacer(),
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.leftToRight,
                                    child: const MyDrawer(),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'assets/images/filter.png',
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<List<FarmerDetails>>(
                          future: futureFarmerProfiles,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child:
                                      Text(buildTranslate("noDataAvailable")!));
                            } else if (snapshot.hasData) {
                              List<FarmerDetails> farmers = snapshot.data!;

                              return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final dealerNo = farmers[index]
                                        .farmerDetails
                                        .dealerNumber;
                                    final Name =
                                        farmers[index].farmerDetails.name;
                                    final Address =
                                        farmers[index].farmerDetails.village;
                                    WhatsappNumberData = farmers[index]
                                        .farmerDetails
                                        .whatsappNumber;
                                    final GeoLocationOwnedFarm = farmers[index]
                                        .farmerDetails
                                        .geoLocationOwnedFarm;
                                    final TotalOwnedFarm = farmers[index]
                                        .farmerDetails
                                        .totalOwnedFarm
                                        .toString();
                                    final TotalLeaseFarm = farmers[index]
                                        .farmerDetails
                                        .totalLeaseFarm
                                        .toString();
                                    final GeoLocationLeaseFarm = farmers[index]
                                        .farmerDetails
                                        .geoLocationLeaseFarm;
                                    final Pincode =
                                        farmers[index].farmerDetails.pincode;
                                    final State =
                                        farmers[index].farmerDetails.state;
                                    final Village =
                                        farmers[index].farmerDetails.village;
                                    final District =
                                        farmers[index].farmerDetails.district;
                                    final BankName =
                                        farmers[index].farmerDetails.bankName;
                                    final AccountName = farmers[index]
                                        .farmerDetails
                                        .accountName;
                                    final AccountNumber = farmers[index]
                                        .farmerDetails
                                        .accountNumber;
                                    final IfscCode =
                                        farmers[index].farmerDetails.ifscCode;
                                    final PanNumber =
                                        farmers[index].farmerDetails.pan;
                                    final AadhaarNumber = farmers[index]
                                        .farmerDetails
                                        .aadhaarNumber;
                                    final TypeOfCultivationPractice =
                                        farmers[index]
                                            .farmerDetails
                                            .typeOfCultivationPractice;

                                    final cropDetails =
                                        farmers[index].cropCultivationDetails;
                                    return
                                        // user card
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                right: 20.0,
                                                left: 20.0),
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Color(0xFFe7e7e7),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12))),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10.0,
                                                                right: 15.0,
                                                                left: 15.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              height: 50.0,
                                                              width: 50.0,
                                                              decoration: const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: DecorationImage(
                                                                      image: AssetImage(
                                                                          "assets/images/profile_image.png"),
                                                                      fit: BoxFit
                                                                          .cover)),
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            Flexible(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    Name,
                                                                    softWrap:
                                                                        true,
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xFF808080),
                                                                        fontSize:
                                                                            15,
                                                                        fontFamily:
                                                                            'poppins-semibold'),
                                                                  ),
                                                                  Text(
                                                                    Address,
                                                                    softWrap:
                                                                        true,
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xFF959595),
                                                                        fontSize:
                                                                            11,
                                                                        fontFamily:
                                                                            'poppins-semibold'),
                                                                  ),
                                                                  Text(
                                                                    WhatsappNumberData,
                                                                    softWrap:
                                                                        true,
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xFF959595),
                                                                        fontSize:
                                                                            11,
                                                                        fontFamily:
                                                                            'poppins-semibold'),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 20.0,
                                                                right: 20.0,
                                                                top: 8.0,
                                                                bottom: 12.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                                child: InkWell(
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              splashColor: Colors
                                                                  .transparent,
                                                              onTap: () {
                                                                setState(() {
                                                                  if (showCropDataVisible ==
                                                                      index) {
                                                                    showCropDataVisible =
                                                                        null; // Deselect if tapped again
                                                                  } else {
                                                                    showCropDataVisible =
                                                                        index; // Select the item
                                                                  }
                                                                });
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    buildTranslate(
                                                                        "showCropData")!,
                                                                    softWrap:
                                                                        true,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color(
                                                                          0XFF008000),
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          'poppins-semibold',
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline,
                                                                      decorationColor:
                                                                          Color(
                                                                              0XFF008000),
                                                                    ),
                                                                  ),
                                                                  Image.asset(
                                                                      'assets/images/dropdown_arrow.png'),
                                                                ],
                                                              ),
                                                            )),
                                                            const VerticalDivider(
                                                                width: 1.0),
                                                            Expanded(
                                                                child: Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: InkWell(
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                splashColor: Colors
                                                                    .transparent,
                                                                onTap:
                                                                    () async {
                                                                  print(
                                                                      "Name : $Name");
                                                                  print(
                                                                      "WhatsappNumber : $WhatsappNumberData");
                                                                  print(
                                                                      "dealerNo : $dealerNo");
                                                                  // Navigate to ScreenB and wait for result
                                                                  final result =
                                                                      await Navigator.of(
                                                                              context)
                                                                          .push(
                                                                    MaterialPageRoute(
                                                                        builder: (context) => FarmerEditProfilePage(
                                                                            dealerNumber:
                                                                                dealerNo,
                                                                            name:
                                                                                Name,
                                                                            whatsappNumber:
                                                                                WhatsappNumberData,
                                                                            address:
                                                                                Address,
                                                                            geoLocationOwnedFarm:
                                                                                GeoLocationOwnedFarm,
                                                                            totalOwnedFarm:
                                                                                TotalOwnedFarm,
                                                                            totalLeaseFarm:
                                                                                TotalLeaseFarm,
                                                                            geoLocationLeaseFarm:
                                                                                GeoLocationLeaseFarm,
                                                                            pincode:
                                                                                Pincode,
                                                                            state:
                                                                                State,
                                                                            district:
                                                                                District,
                                                                            village:
                                                                                Village,
                                                                            bankName:
                                                                                BankName,
                                                                            accountName:
                                                                                AccountName,
                                                                            accountNumber:
                                                                                AccountNumber,
                                                                            ifscCode:
                                                                                IfscCode,
                                                                            panNumber:
                                                                                PanNumber,
                                                                            aadhaarNumber:
                                                                                AadhaarNumber,
                                                                            typeOfCultivationPractice:
                                                                                TypeOfCultivationPractice)),
                                                                  );

                                                                  // When ScreenB is popped, update data with result
                                                                  if (result !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      futureFarmerProfiles = FarmerDashboardController.fetchFarmerDashboard(
                                                                          context,
                                                                          widget
                                                                              .villageName,
                                                                          widget
                                                                              .typeName);
                                                                    });
                                                                  }
                                                                },
                                                                child: Text(
                                                                  buildTranslate(
                                                                      "editProfile")!,
                                                                  softWrap:
                                                                      true,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Color(
                                                                        0XFF008000),
                                                                    fontSize:
                                                                        15,
                                                                    fontFamily:
                                                                        'poppins-semibold',
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                    decorationColor:
                                                                        Color(
                                                                            0XFF008000),
                                                                  ),
                                                                ),
                                                              ),
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      showCropDataVisible ==
                                                              index
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 20.0,
                                                                right: 20.0,
                                                              ),
                                                              child: Text(
                                                                buildTranslate(
                                                                    "cropCultivations")!,
                                                                softWrap: true,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      'poppins-semibold',
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                      SizedBox(height: 10),
                                                      showCropDataVisible ==
                                                              index
                                                          ? ListView.builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              itemCount: 1,
                                                              itemBuilder:
                                                                  (context,
                                                                      cropIndex) {
                                                                if (cropDetails
                                                                    is List<
                                                                        CropDetails>) {
                                                                  return Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children:
                                                                        cropDetails
                                                                            .map((crop) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                5.0,
                                                                            left:
                                                                                20.0,
                                                                            right:
                                                                                20.0,
                                                                            bottom:
                                                                                12.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                                child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 2,
                                                                                  child: Text(
                                                                                    "${crop.crops}",
                                                                                    softWrap: true,
                                                                                    textAlign: TextAlign.start,
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF666666),
                                                                                      fontSize: 10,
                                                                                      fontFamily: 'poppins-semibold',
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: Text(
                                                                                    crop.typeOfCultivationPractice,
                                                                                    softWrap: true,
                                                                                    textAlign: TextAlign.start,
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF666666),
                                                                                      fontSize: 10,
                                                                                      fontFamily: 'poppins-semibold',
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                            Expanded(
                                                                                flex: 1,
                                                                                child: Align(
                                                                                  alignment: Alignment.centerRight,
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditCropCultivationPage(WhatsappNumber: WhatsappNumberData, selectedCrop: crop.crops, id: crop.id, variety: crop.variety, date: crop.dateOfSowing, geoLocation: crop.geolocation, cultivationType: crop.typeOfCultivationPractice, areaInArce: crop.areaInAcres.toString(), geoLinkArea: crop.geoLinkAreaOnMap)));
                                                                                    },
                                                                                    child: Text(
                                                                                      buildTranslate("editCropData")!,
                                                                                      softWrap: true,
                                                                                      style: const TextStyle(
                                                                                        color: Color(0XFF008000),
                                                                                        fontSize: 11,
                                                                                        fontFamily: 'poppins-semibold',
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  );
                                                                } else {
                                                                  return Text(
                                                                      cropDetails,
                                                                      softWrap:
                                                                          true,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              15.0,
                                                                          fontFamily:
                                                                              "poppins-semibold"));
                                                                }
                                                              })
                                                          : Container(),
                                                      showCropDataVisible ==
                                                              index
                                                          ? SizedBox(height: 5)
                                                          : Container(),
                                                      showCropDataVisible ==
                                                              index
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          10.0,
                                                                      top: 8.0,
                                                                      bottom:
                                                                          20.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          InkWell(
                                                                        highlightColor:
                                                                            Colors.transparent,
                                                                        splashColor:
                                                                            Colors.transparent,
                                                                        onTap:
                                                                            () {},
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              color: const Color(0XFF3FC041),
                                                                              border: Border.all(color: const Color(0XFF3FC041), width: 1),
                                                                              borderRadius: BorderRadius.circular(18)),
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              Text(
                                                                            buildTranslate("showMoreCrops")!,
                                                                            softWrap:
                                                                                true,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: const TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 12,
                                                                                fontFamily: 'poppins-regular'),
                                                                          ),
                                                                        ),
                                                                      )),
                                                                  Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child:
                                                                            InkWell(
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () {
                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CropCultivationPage(WhatsappNumber: WhatsappNumberData)));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            decoration: BoxDecoration(
                                                                                color: const Color(0XFF3FC041),
                                                                                border: Border.all(color: const Color(0XFF3FC041), width: 1),
                                                                                borderRadius: BorderRadius.circular(18)),
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text(
                                                                              buildTranslate("addNewCultivations")!,
                                                                              softWrap: true,
                                                                              style: const TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 11,
                                                                                fontFamily: 'poppins-regular',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                            )
                                                          : Container(),
                                                    ])));
                                  });
                            } else {
                              return Center(
                                  child:
                                      Text(buildTranslate("noDataAvailable")!));
                            }
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  )
                : selectedTopData == 1
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              buildTranslate("farmerRegistration")!,
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

                          // name
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("name")!,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF666666),
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  hintText: buildTranslate("enterName")!,
                                  hintStyle:
                                      const TextStyle(color: Color(0xFFe7e7e7)),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 0.5),
                                  )),
                              validator: (value) => value!.isEmpty
                                  ? 'Please, fill this field.'
                                  : null,
                              controller: nameController,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // whats app number
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("whatsappNumber")!,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF666666),
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              maxLength: 10,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]')),
                                //To remove first '0'
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^0+')),
                                //To remove first '94' or your country code
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^94+')),
                              ],
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                enabled: true,
                                alignLabelWithHint: true,
                                fillColor: Colors.white,
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                hintText: buildTranslate("mobileNumber"),
                                hintStyle:
                                    const TextStyle(color: Color(0xFFe7e7e7)),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                                suffixIcon: Container(
                                  margin: const EdgeInsets.all(8),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(80, 35),
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(fontSize: 18),
                                      backgroundColor: isOtpButtonEnabled
                                          ? const Color(
                                              0xFF3FC041) // Green when enabled
                                          : Colors
                                              .grey, // Grey when disabled (cooldown)
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    child: Text(buildTranslate("getOtp")!),
                                    onPressed: () {
                                      setState(() {
                                        otpVisible = true;
                                      });
                                      if (whatsAppNumberController
                                          .text.isNotEmpty) {
                                        if (isOtpButtonEnabled) {
                                          getOtpApiCall();
                                        } else {
                                          AlertHelper.showToast(
                                              "Please wait before requesting again.",
                                              context);
                                        }
                                      } else {
                                        AlertHelper.showToast(
                                            "Please enter details", context);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? 'Please, fill this field.'
                                  : null,
                              controller: whatsAppNumberController,
                            ),
                          ),

                          // Display the countdown timer if the button is disabled
                          Visibility(
                            visible: !isOtpButtonEnabled,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0),
                              child: Text(
                                countdownText, // This is the dynamic countdown text
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // verify otp
                          otpVisible
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0),
                                  child: Text(
                                    buildTranslate("verifyOtp")!,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF666666),
                                        fontFamily: 'poppins-semibold'),
                                  ),
                                )
                              : Container(),
                          otpVisible
                              ? const SizedBox(
                                  height: 20,
                                )
                              : Container(),
                          otpVisible
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: OTPTextField(
                                      controller: otpController,
                                      length: 4,
                                      // borderColor: const Color(0xFF3dc33b),
                                      // showFieldAsBox: true,
                                      // filled: true,
                                      width: MediaQuery.of(context).size.width,
                                      textFieldAlignment:
                                          MainAxisAlignment.spaceAround,
                                      fieldWidth: 55,
                                      fieldStyle: FieldStyle.box,
                                      outlineBorderRadius: 10,
                                      style: TextStyle(fontSize: 17),
                                      onChanged: (code) {
                                        print("Changed: " + code);
                                      },
                                      onCompleted: (code) {
                                        enteredOtp = code;
                                        print("Completed: " + enteredOtp);
                                      }),
                                )
                              : Container(),

                          const SizedBox(
                            height: 25,
                          ),

                          Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  bool isOtpVerified = await verifyOtp(
                                      whatsAppNumberController.text,
                                      enteredOtp,
                                      context);
                                  if (isOtpVerified) {
                                    AlertHelper.showToast(
                                        "OTP verified", context);
                                    _farmerRegistrationCall();
                                  } else {
                                    AlertHelper.showToast(
                                        "OTP verification failed. Please try again.",
                                        context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(12),
                                  textStyle: const TextStyle(fontSize: 18),
                                  backgroundColor: const Color(0xFF3FC041),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12), // <-- Radius
                                  ),
                                ),
                                child: Text(
                                  buildTranslate('SUBMIT')!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'poppins-medium'),
                                ),
                              )),
                        ],
                      )
                    : selectedTopData == 2
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  buildTranslate("cropCultivation")!,
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

                              // select farmer
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("selectFarmer")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Container(
                                    color: Colors.white,
                                    child: DropdownButtonFormField2<String>(
                                      dropdownStyleData:
                                          const DropdownStyleData(
                                              maxHeight: 200),
                                      hint:
                                          Text(buildTranslate("selectFarmer")!),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      buttonStyleData: const ButtonStyleData(
                                        padding: EdgeInsets.only(right: 8),
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black45,
                                        ),
                                        iconSize: 24,
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                      ),
                                      value: _selectedFarmersName,
                                      items: dropdownItems,
                                      onChanged: (String? newValue) {
                                        _selectedFarmersName = newValue;
                                      },
                                    )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // crops
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("selectCrops")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: crops.isEmpty
                                    ? Center(
                                        child: Text(
                                            buildTranslate("noDataAvailable")!))
                                    : DropdownButtonFormField2<String>(
                                        dropdownStyleData:
                                            DropdownStyleData(maxHeight: 200),
                                        hint: Text(
                                            buildTranslate("selectCrops")!),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 16),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        buttonStyleData: const ButtonStyleData(
                                          padding: EdgeInsets.only(right: 8),
                                        ),
                                        iconStyleData: const IconStyleData(
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black45,
                                          ),
                                          iconSize: 24,
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                        ),
                                        value: _selectedCrop,
                                        items: crops.map((String crop) {
                                          return DropdownMenuItem<String>(
                                            value: crop,
                                            child: Text(crop,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'poppins-regular')),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedCrop = newValue;
                                          });
                                        },
                                      ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // varity
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("variety")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      hintText: buildTranslate("enterVariety")!,
                                      hintStyle: const TextStyle(
                                          color: Color(0xFFe7e7e7)),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 0.5),
                                      )),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please, fill this field.'
                                      : null,
                                  controller: varietyController,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // date
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("dateOfSowing")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed: () {
                                          _selectDate(context);
                                        }, // Open date picker on icon press
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      hintText: 'DD/MM/YYYY',
                                      hintStyle: const TextStyle(
                                          color: Color(0xFFe7e7e7)),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 0.5),
                                      )),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please, fill this field.'
                                      : null,
                                  controller: dateController,
                                  readOnly: true,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // goe location
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("geoLocation")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      alignLabelWithHint: true,
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      hintText: '----',
                                      hintStyle:
                                          TextStyle(color: Color(0xFFe7e7e7)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 0.5),
                                      )),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please, fill this field.'
                                      : null,
                                  controller: geoLocationController,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // type of cultivation practice
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("typeofCultivationPractice")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Container(
                                  color: Colors.white,
                                  child: DropdownButtonFormField2<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    hint: const Text(
                                      '--',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    items: items
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              ),
                                            ))
                                        .toList(),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select type of Entity.';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        selectedItemValue = value.toString();
                                      });
                                    },
                                    onSaved: (value) {
                                      selectedItemValue = value.toString();
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding: EdgeInsets.only(right: 8),
                                    ),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black45,
                                      ),
                                      iconSize: 24,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // area in arcs
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("areaInAcres")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]')),
                                    //To remove first '0'
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'^0+')),
                                    //To remove first '94' or your country code
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'^94+')),
                                  ],
                                  decoration: const InputDecoration(
                                      alignLabelWithHint: true,
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      hintText: 'Enter area in acres',
                                      hintStyle:
                                          TextStyle(color: Color(0xFFe7e7e7)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 0.5),
                                      )),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please, fill this field.'
                                      : null,
                                  controller: areaInArcesController,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              // geo Link Area On Map
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  buildTranslate("geoLinkAreaOnMap")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      alignLabelWithHint: true,
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      hintText: 'Enter geoLink area on map',
                                      hintStyle:
                                          TextStyle(color: Color(0xFFe7e7e7)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 0.5),
                                      )),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please, fill this field.'
                                      : null,
                                  controller: geoLinkAreaOnMapController,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                  width: 180,
                                  height: 45,
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0),
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(12),
                                      textStyle: const TextStyle(fontSize: 18),
                                      backgroundColor: const Color(0xFF3FC041),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12), // <-- Radius
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.add),
                                        Text(
                                          "Add Crop",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'poppins-medium'),
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _cropCultivationRegisterApiCall();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(12),
                                      textStyle: const TextStyle(fontSize: 18),
                                      backgroundColor: const Color(0xFF3FC041),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      buildTranslate('SUBMIT')!,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'poppins-medium'),
                                    ),
                                  )),
                              const SizedBox(
                                height: 100,
                              ),
                            ],
                          )
                        : selectedTopData == 3
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, right: 20.0, left: 20.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(18))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          children: [
                                            // select crops
                                            Text(
                                              buildTranslate(
                                                  "searchByCrops/Villages")!,
                                              softWrap: true,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontFamily:
                                                      'poppins-semibold'),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    color: Colors.white,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child:
                                                        DropdownButtonFormField2<
                                                            String>(
                                                      dropdownStyleData:
                                                          const DropdownStyleData(
                                                              maxHeight: 200),
                                                      hint: Text(buildTranslate(
                                                          "selectCrops")!),
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.black,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                      buttonStyleData:
                                                          const ButtonStyleData(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8),
                                                      ),
                                                      iconStyleData:
                                                          const IconStyleData(
                                                        icon: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.black45,
                                                        ),
                                                        iconSize: 24,
                                                      ),
                                                      menuItemStyleData:
                                                          const MenuItemStyleData(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                      ),
                                                      value: _selectedCrop,
                                                      items: crops
                                                          .map((String crop) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: crop,
                                                          child: Text(crop,
                                                              style: const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'poppins-regular')),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          _selectedCrop =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 80,
                                                  height: 40,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  child: Center(
                                                    child: Text(
                                                      buildTranslate("crops")!,
                                                      textAlign:
                                                          TextAlign.center,
                                                      softWrap: true,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily:
                                                              'poppins-regular'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(
                                              height: 10,
                                            ),

                                            // select villages
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    color: Colors.white,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child:
                                                        DropdownButtonFormField2<
                                                            String>(
                                                      dropdownStyleData:
                                                          const DropdownStyleData(
                                                              maxHeight: 200),
                                                      hint: Text(buildTranslate(
                                                          "selectVillages")!),
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.black,
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                      buttonStyleData:
                                                          const ButtonStyleData(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8),
                                                      ),
                                                      iconStyleData:
                                                          const IconStyleData(
                                                        icon: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.black45,
                                                        ),
                                                        iconSize: 24,
                                                      ),
                                                      menuItemStyleData:
                                                          const MenuItemStyleData(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                      ),
                                                      value:
                                                          _selectedVillageName,
                                                      items: _villageNameData!
                                                          .data!
                                                          .map((String crop) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: crop,
                                                          child: Text(crop,
                                                              style: const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'poppins-regular')),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          _selectedVillageName =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 80,
                                                  height: 40,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  child: Center(
                                                    child: Text(
                                                      buildTranslate(
                                                          "villages")!,
                                                      textAlign:
                                                          TextAlign.center,
                                                      softWrap: true,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily:
                                                              'poppins-regular'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(
                                              height: 20,
                                            ),

                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      onSearchPressed();
                                                      searchCropsFlag = true;
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    textStyle: const TextStyle(
                                                        fontSize: 18),
                                                    backgroundColor:
                                                        const Color(0xFF3FC041),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10), // <-- Radius
                                                    ),
                                                  ),
                                                  child: Text(
                                                    buildTranslate('SEARCH')!,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontFamily:
                                                            'poppins-medium'),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Visibility(
                                    visible: searchCropsFlag,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, right: 20.0, left: 20.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              FutureBuilder<FrmInsight?>(
                                                future: _futureFrminSight,
                                                builder: (context, snapshot) {
                                                  // Log the connection state and snapshot data
                                                  print(
                                                      'Connection State: ${snapshot.connectionState}');
                                                  print(
                                                      'Has data: ${snapshot.hasData}');
                                                  print(
                                                      'Error:: ${snapshot.error}');
                                                  print(
                                                      'Data: ${snapshot.data}');

                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator()); // Loading state
                                                  } else if (snapshot
                                                      .hasError) {
                                                    // Handle the error case
                                                    return Center(
                                                        child: Text(
                                                            'Error: ${snapshot.error}'));
                                                  } else if (!snapshot
                                                      .hasData) {
                                                    // Handle the case where there's no data
                                                    return Center(
                                                        child: Text(
                                                            'No data available.'));
                                                  } else {
                                                    FrmInsight? frminSight =
                                                        snapshot.data;
                                                    if (frminSight == null) {
                                                      return Center(
                                                          child: Text(
                                                              'No data available.'));
                                                    }
                                                    print(
                                                        'Has data: ${frminSight.data}');
                                                    return listWidget(
                                                        frminSight); // Your list display widget
                                                  }
                                                },
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            : selectedTopData == 4
                                ? Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              highlightColor:
                                                  Colors.transparent,
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                setState(() {
                                                  selectedTopData = 3;
                                                });
                                              },
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color: Colors.black,
                                                size: 25.0,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              buildTranslate("goBack")!,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'poppins-medium',
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25.0, right: 20.0, top: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color(0xFF73C187),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: FutureBuilder<
                                                        FrmInsight?>(
                                                    future: _futureFrminSight,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return Center(
                                                            child:
                                                                CircularProgressIndicator()); // Show loading spinner while waiting
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Center(
                                                            child: Text(
                                                                'Error: ${snapshot.error}')); // Show error message
                                                      } else if (!snapshot
                                                          .hasData) {
                                                        return Center(
                                                            child: Text(
                                                                'No data available.')); // Show message if no data
                                                      } else {
                                                        // Successfully fetched data
                                                        FrmInsight? frminSight =
                                                            snapshot.data;
                                                        int totalFarmers = frminSight
                                                                ?.data
                                                                .numberOfFarmers ??
                                                            0; // Get total farmers
                                                        print(totalFarmers);

                                                        return Column(
                                                          children: [
                                                            // Display total farmers inside brackets dynamically
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          20.0),
                                                              child: Text(
                                                                "Farmers($totalFarmers)", // Fallback to default if buildTranslate fails
                                                                softWrap: true,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'poppins-semibold'),
                                                              ),
                                                            ),
                                                            // Other UI elements here...
                                                          ],
                                                        );
                                                      }
                                                    }),
                                              ),
                                            ),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Container(
                                                width: 150,
                                                height: 40,
                                                color: Colors.white,
                                                child: DropdownButtonFormField2<
                                                    String>(
                                                  isExpanded: true,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 5),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  hint: Text(
                                                    buildTranslate('sortBy')!,
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  items: sortItems
                                                      .map((item) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                            value: item,
                                                            child: Text(
                                                              item,
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    //Do something when selected item is changed.
                                                  },
                                                  onSaved: (value) {
                                                    selectedSortItemsValue =
                                                        value.toString();
                                                  },
                                                  buttonStyleData:
                                                      const ButtonStyleData(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                  ),
                                                  iconStyleData:
                                                      const IconStyleData(
                                                    icon: ImageIcon(AssetImage(
                                                        'assets/images/sortBy.png')),
                                                    iconSize: 20,
                                                    iconEnabledColor:
                                                        Colors.black,
                                                  ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 35,
                                      ),
                                      _buildHeaderTable(),
                                      FutureBuilder<FrmInsight?>(
                                        future:
                                            _futureFrminSight, // The future that fetches FrmInsight data
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator()); // Loading state
                                          } else if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}')); // Error handling
                                          } else if (!snapshot.hasData) {
                                            return Center(
                                                child:
                                                    Text('No data available.'));
                                          } else {
                                            FrmInsight? frminSight =
                                                snapshot.data;
                                            if (frminSight == null ||
                                                frminSight
                                                    .data.farmers.isEmpty) {
                                              return Center(
                                                  child: Text(
                                                      'No farmers data available.'));
                                            }
                                            // Get the farmers data
                                            var farmers =
                                                snapshot.data?.data.farmers ??
                                                    [];
                                            // Sort the farmers based on the selected sorting option
                                            if (selectedSortItemsValue ==
                                                buildTranslate(
                                                    "highExpYield")) {
                                              // Sort in descending order by expectedYield (high to low)
                                              farmers.sort((a, b) => b
                                                  .expectedYield
                                                  .compareTo(a.expectedYield));
                                            } else if (selectedSortItemsValue ==
                                                buildTranslate("lowExpYield")) {
                                              // Sort in ascending order by expectedYield (low to high)
                                              farmers.sort((a, b) => a
                                                  .expectedYield
                                                  .compareTo(b.expectedYield));
                                            }

                                            // Pass the fetched FrmInsight data to the table widget
                                            return Column(
                                              children: [
                                                // The header row of the table
                                                buildTable(context,
                                                    frminSight), // The table with farmer data
                                              ],
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  )
                                : Container(),
          ],
        ),
      ),
    );
  }

  Future<FrmInsight?> fetchInsightsData() async {
    String? number = await AppGlobal.getStringPreference('contactNumber');
    var num = number ?? "1";

    if (_selectedCrop == null || _selectedVillageName == null) {
      print('Please select both crop and village');
      return null;
    }

    final url =
        '${baseUrl}appFarmer/farmers/insight?dealerNumber=$num&village=$_selectedVillageName&crop=$_selectedCrop&sort=highToLow';

    try {
      final response = await getAPICall(apiUrl: url);
      if (response.statusCode == 200) {
        print('API Response: ${response.body}');
        return FrmInsight.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void onSearchPressed() {
    // Validate if both crop and village are selected
    if (_selectedCrop != null && _selectedVillageName != null) {
      setState(() {
        // Initialize the future here, which will trigger the API request
        _futureFrminSight = fetchInsightsData();
      });
    } else {
      // Show an error or prompt to select both crop and village
      print('Please select both crop and village');
    }
  }

  Future<void> _fetchFarmerNameData() async {
    try {
      String? number = await AppGlobal.getStringPreference('contactNumber');
      var num = number ?? "1";
      var response = await getAPICall(apiUrl: FARMER_NAME + num);
      print(num);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        dropdownItems = jsonData['data'].map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
            value: item['name'],
            child: Text(item['name']),
          );
        }).toList();
      } else {
        throw Exception('Failed to load farmers name');
      }
    } catch (e) {
      print('Error fetching farmer name data: $e');
    }
  }

  Future<void> _fetchVillageData() async {
    try {
      // Replace with your actual API endpoint
      // Retrieve the dealer number first
      String? number = await AppGlobal.getStringPreference('contactNumber');
      var dealerNumber = number ?? "1"; // Default to "1" if no number found

      var response = await getAPICall(apiUrl: VILLAGES_NAMES + dealerNumber);

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _villageNameData =
                SelectVillagesNameData.fromJson(jsonDecode(response.body));
          });
        }
      } else {
        throw Exception('Failed to load villages');
      }
    } catch (e) {
      print('Error fetching _village name data: $e');
    }
  }

  Future<void> fetchCrops() async {
    try {
      final response = await getAPICall(apiUrl: "${baseUrl}/all/crops");
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            crops = List<String>.from(jsonDecode(response.body)['data']);
          });
        }
      } else {
        print('Failed to retrieve crops');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> verifyOtp(
      String number, String enteredOtp, BuildContext context) async {
    // Define the URL for your API endpoint
    final url = "${baseUrl}whatsapp/check-otp/";

    // Create the payload data
    final data = json.encode({
      "phoneNumber": number,
      "otp": enteredOtp, // Use the entered OTP from the input
    });

    try {
      // Make the POST request to verify the OTP
      final response = await postAPICall(
        apiUrl: url,
        parameter: data,
      );

      // Check the response from the server
      if (response.statusCode == 200) {
        // Successfully verified OTP
        print("OTP verified successfully!");
        AlertHelper.showToast("OTP verified successfully", context);
        return true; // Return true for successful verification
      } else {
        // Handle OTP verification failure
        print("OTP verification failed!");
        AlertHelper.showToast("Invalid OTP. Please try again.", context);
        return false; // Return false for failure
      }
    } catch (e) {
      // Handle errors
      print("Error during OTP verification: $e");
      AlertHelper.showToast("OTP verification failed!", context);
      return false; // Return false for errors
    }
  }

  Future<bool> checkPhoneNumber(String number) async {
    // Define the URL for your API endpoint, appending the number directly
    final url = "${baseUrl}check-contact/$number";

    try {
      // Make the GET request to check the phone number
      final response = await getAPICall(
        apiUrl: url,
      );

      // Check the response from the server
      if (response.statusCode == 200) {
        // Phone number exists
        print("Phone number exists!");
        // AlertHelper.showToast("Phone number is valid.", context);
        return true; // Return true if the number exists
      } else {
        // Phone number does not exist
        print("Phone number does not exist!");
        AlertHelper.showToast(
            "Phone number does not exist. Please check and try again.",
            context);
        return false; // Return false if the number does not exist
      }
    } catch (e) {
      // Handle errors
      print("Error during phone number check: $e");
      // AlertHelper.showToast("Error occurred. Please try again.", context);
      return false; // Return false in case of an error
    }
  }

  Future<void> getOtpApiCall() async {
    String phoneNumber = whatsAppNumberController.text.toString();

    // Check if the phone number exists
    bool exists = await checkPhoneNumber(phoneNumber);

    if (!exists) {
      final body = json
          .encode({"phoneNumber": whatsAppNumberController.text.toString()});

      try {
        // Get OTP data from the API
        GetOtpData? userOtp =
            await OtpController.getOtp(body, context: context);

        if (userOtp != null) {
          print("otpData : ${userOtp.otp}");
          otpData = userOtp.otp ?? "";
          // Start the timer for 2 minutes (120 seconds)
          startOtpCooldown();
          AlertHelper.showToast("OTP sent on your mobile number", context);
        } else {
          print("Failed to get OTP data.");
          AlertHelper.showToast(
              "Failed to retrieve OTP. Please try again.", context);
        }
      } catch (e) {
        print("Error during OTP request: $e");
        // AlertHelper.showToast("Error occurred. Please try again.", context);
      }
    } else {
      AlertHelper.showToast(
          "Phone number exists. Please check and try again.", context);
      // Navigate to the login page
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    // Show the date picker dialog
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // Default date is the current date
      firstDate: DateTime(2000),
      // Earliest selectable date
      lastDate: DateTime.now(),
      // Latest selectable date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      setState(() {
        // Format the selected date and display it in the TextFormField
        dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  void _onSelectedTopDataTapped(int index) {
    setState(() {
      selectedTopData = index;
    });
    if (selectedTopData == 0) {
      if (mounted) {
        setState(() {
          futureFarmerProfiles = FarmerDashboardController.fetchFarmerDashboard(
              context, widget.villageName, widget.typeName);
        });
      }
    }
    print("Selected Top Page : $selectedTopData");
  }

  Widget listWidget(FrmInsight frminSight) {
    // Extracting required data from the API response
    int totalfarmers = frminSight.data.numberOfFarmers;
    int totalLandInAcres = frminSight.data.totalAreaInAcres;
    int expectedYield = 0; // Default value, can be updated if needed

    // You may need to fetch the expected yield for each crop if it's provided in the data
    // For now, we assume it's a generic value across the crops.
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: search_crops.length,
      itemBuilder: (_, index) {
        String displayText = '';

        // Condition to decide which value to display based on index
        if (index == 0) {
          // First index, show total number of farmers
          displayText =
              '$totalfarmers Farmers\n${search_crops[index].name ?? ""}';
        } else if (index == 1) {
          // Second index, show total land in acres
          displayText =
              '$totalLandInAcres Acres\n${search_crops[index].name ?? ""}';
        } else if (index == 2) {
          // Third index, show expected yield
          displayText =
              '$expectedYield Expected Yield\n${search_crops[index].name ?? ""}';
        } else {
          // For other items, show just the crop name
          displayText = search_crops[index].name ?? "";
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFd3d3d3),
                  )
                ],
                border: Border.all(color: const Color(0xFFd3d3d3), width: 1.0),
                borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                // Only set selectedTopData to 4 if the index is 0
                if (index == 0) {
                  setState(() {
                    selectedTopData = 4;
                  });
                  onSearchPressed();
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    search_crops[index].icon ?? "",
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        displayText, // Display the dynamic text based on the index
                        textAlign: TextAlign.center,
                        softWrap: true,
                        maxLines: 2,
                        style: const TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 15,
                            fontFamily: 'poppins-regular'),
                      ),
                    ),
                  ),
                  index == 0
                      ? Image.asset(
                          "assets/images/right_arrow.png",
                          width: 25,
                          height: 25,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        );
      },
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    );
  }

  Widget buildTable(BuildContext context, FrmInsight frminSight) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.black),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(4),
            1: FlexColumnWidth(5),
            2: FlexColumnWidth(5),
          },
          border: TableBorder.all(),
          children: [
            // Data rows: loop over the list of farmers in FrmInsight
            for (var farmer in frminSight.data.farmers)
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    farmer.name,
                    style: const TextStyle(
                        fontFamily: "poppins-semibold", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    farmer.whatsappNumber, // Use 'N/A' if number is null
                    style: const TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    farmer.expectedYield.toString(),
                    style: const TextStyle(
                        fontFamily: "poppins-regular", fontSize: 12.0),
                  ),
                ),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTable() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Container(
        width: double.maxFinite,
        height: 70,
        padding: const EdgeInsets.fromLTRB(
          10,
          16,
          45,
          16,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF73C187),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _titleHeaderTable('Name', 3),
              _titleHeaderTable('Mobile \nNumber', 4),
              _titleHeaderTable('Expected Yield \n(in Qtl)', 2),
            ]),
      ),
    );
  }

  Widget _titleHeaderTable(String title, int flexNum) {
    return Expanded(
      flex: flexNum,
      child: Container(
        child: Text(
          title,
          textAlign: TextAlign.left,
          maxLines: 2,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 11.0,
              fontFamily: "poppins-semibold"),
        ),
      ),
    );
  }

  _farmerRegistrationCall() async {
    if (nameController.text.trim().isNotEmpty &&
        whatsAppNumberController.text.trim().isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FarmerProfilePage(
              farmerName: nameController.text.toString(),
              farmerWhatsappNumber: whatsAppNumberController.text.toString())));
    } else {
      AlertHelper.showToast("Please enter details.", context);
    }
  }

  showAlertDialog(BuildContext context, String message) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.close,
                color: Colors.black,
                size: 20.0,
              ),
            ),
          ),
          Center(
              child: Image.asset(
            'assets/images/check_green.png',
            width: 100,
            height: 100,
          )),
          Text(
            message,
            softWrap: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: "poppins-semibold",
                fontSize: 15.0,
                color: Colors.grey),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            buildTranslate("thankYou")!,
            softWrap: true,
            style: const TextStyle(
                fontFamily: "poppins-semibold",
                fontSize: 20.0,
                color: Colors.black),
          ),
          const SizedBox(
            height: 20,
          ),
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

  _cropCultivationRegisterApiCall() async {
    if (varietyController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty &&
        geoLocationController.text.trim().isNotEmpty &&
        selectedItemValue.toString().isNotEmpty &&
        areaInArcesController.text.trim().isNotEmpty &&
        geoLinkAreaOnMapController.text.trim().isNotEmpty) {
      String? number = await AppGlobal.getStringPreference('contactNumber');

      // Parse the input date string
      DateTime parsedDate =
          DateFormat('dd-MM-yyyy').parse(dateController.text.toString());
      // Format it to YYYY-MM-DD
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      var body = json.encode({
        "dealerNumber": number ?? "1",
        // "fid": WhatsappNumberData,
        "fid": number,
        "farmerName": _selectedFarmersName.toString(),
        "crops": _selectedCrop.toString(),
        "variety": varietyController.text.toString(),
        "dateOfSowing": formattedDate,
        "geolocation": geoLocationController.text.toString(),
        "typeOfCultivationPractice": selectedItemValue.toString(),
        "areaInAcres": areaInArcesController.text.toString(),
        "geoLinkAreaOnMap": geoLinkAreaOnMapController.text.toString()
      });
      showLoading();
      var response = await postAPICall(
        apiUrl: CROP_CULTIVATION_REGISTR,
        parameter: body,
      );
      stopLoading();
      if (response.statusCode == 201 || response.statusCode == 200) {
        _selectedFarmersName = null;
        _selectedCrop = null;
        varietyController.text = '';
        formattedDate = '';
        geoLocationController.text = '';
        selectedItemValue = null;
        areaInArcesController.text = '';
        geoLinkAreaOnMapController.text = '';
        setState(() {});

        Future.delayed(const Duration(seconds: 1), () {
          print('crop cultivation registered successfully');
          showAlertDialog(context, 'crop cultivation registered successfully');
        });
      } else {
        setSnackbar('Something wrong! ${response.body.toString()}');
      }
    } else {
      AlertHelper.showToast("Please enter details.", context);
    }
  }
}

class cropsCategory {
  String? name;
  String? icon;
  String? id;

  cropsCategory({
    required this.name,
    required this.icon,
    required this.id,
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

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final List<String> sideMenu = ["Villages", "Types"];

  final List<String> typeData = [
    "Organic",
    "InOrganic",
  ];

  int? selectedVillageIndex;
  int? selectedTypeIndex;

  String villageName = "", typeName = "";

  int selectedMenuData = 0;

  SelectVillagesNameData? _villageNameData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSelectedVillageIndex();
    _loadSelectedTypeIndex();
    _fetchVillageData();
  }

  Future<void> _fetchVillageData() async {
    try {
      String? number = await AppGlobal.getStringPreference('contactNumber');
      var dealerNumber = number ?? "1"; // Default to "1" if no number found
      print('VILLAGES_NAMES + dealerNumber : ${VILLAGES_NAMES + dealerNumber}');
      showLoading();
      var response = await getAPICall(apiUrl: VILLAGES_NAMES + dealerNumber);
      stopLoading();
      if (response.statusCode == 200) {
        setState(() {
          _villageNameData =
              SelectVillagesNameData.fromJson(jsonDecode(response.body));
        });
      } else {
        throw Exception('Failed to load villages');
      }
    } catch (e) {
      print('Error fetching _village name data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: 800,
              decoration: const BoxDecoration(color: Color(0xFFC7BDBD)),
              child: ListView.builder(
                itemCount: sideMenu.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _onSelectedMenuDataTapped(index);
                        });
                      },
                      child: Container(
                        color: selectedMenuData == index
                            ? Colors.white
                            : const Color(0xFFC7BDBD),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              sideMenu[index].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "poppins-regular",
                                color: selectedMenuData == index
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: selectedMenuData == 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  _villageNameData == null ||
                                          _villageNameData!.data == null
                                      ? Center(
                                          child: Text(buildTranslate(
                                              "noDataAvailable")!))
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: SizedBox(
                                            height: 50,
                                            child: ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _villageNameData!
                                                  .data!.length,
                                              itemBuilder: (context, index) {
                                                return index.isEven
                                                    ? CardWidget(
                                                        _villageNameData!
                                                            .data![index],
                                                        index)
                                                    : Container();
                                              },
                                            ),
                                          ),
                                        ),
                                  _villageNameData == null ||
                                          _villageNameData!.data == null
                                      ? Center(
                                          child: Text(buildTranslate(
                                              "noDataAvailable")!))
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: SizedBox(
                                            height: 50,
                                            child: ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _villageNameData!
                                                  .data!.length,
                                              itemBuilder: (context, index) {
                                                return index.isOdd
                                                    ? CardWidget(
                                                        _villageNameData!
                                                            .data![index],
                                                        index)
                                                    : Container();
                                              },
                                            ),
                                          ),
                                        )
                                ],
                              )
                            : selectedMenuData == 1
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: SizedBox(
                                          height: 50,
                                          child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: typeData.length,
                                            itemBuilder: (context, index) {
                                              return CardTypeWidget(
                                                  typeData[index], index);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                      )),
                ),
                Container(
                  color: Color(0xFFe7e7e7),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 15.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  var route = ModalRoute.of(context);
                                  if (route != null) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                BottomTwoPage(
                                                    aapbarVisibility: true,
                                                    villageName: villageName,
                                                    typeName: typeName)));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(10),
                                  textStyle: const TextStyle(fontSize: 15),
                                  backgroundColor: const Color(0xFFffffff),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10), // <-- Radius
                                  ),
                                ),
                                child: const Text(
                                  'Apply',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'poppins-medium',
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 15.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => const MyHomePage()),
                                  // );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(10),
                                  textStyle: const TextStyle(fontSize: 15),
                                  backgroundColor: const Color(0xFFffffff),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10), // <-- Radius
                                  ),
                                ),
                                child: const Text(
                                  'Save All',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'poppins-medium',
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget CardWidget(String villageName, int index) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        print("villageName : $villageName");
        _onSelectedVillageDataTapped(index, villageName);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: selectedVillageIndex == index ? Colors.green : Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(5),
        )),
        elevation: 1,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Text(villageName,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "poppins-regular",
                  color: selectedVillageIndex == index
                      ? Colors.white
                      : Colors.black,
                )),
          ),
        ),
      ),
    );
  }

  Widget CardTypeWidget(String typeName, int index) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        print("TypeName : $typeName");
        _onSelectedTypeDataTapped(index, typeName);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: selectedTypeIndex == index ? Colors.green : Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(5),
        )),
        elevation: 1,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Text(typeName,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "poppins-regular",
                  color:
                      selectedTypeIndex == index ? Colors.white : Colors.black,
                )),
          ),
        ),
      ),
    );
  }

  void _loadSelectedVillageIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedVillageIndex = prefs.getInt('selectedVillageIndex') ?? 0;
    });
  }

  void _loadSelectedTypeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTypeIndex = prefs.getInt('selectedTypeIndex') ?? 0;
    });
  }

  Future<void> _onSelectedVillageDataTapped(int index, String village) async {
    setState(() {
      selectedVillageIndex = index;
      villageName = village;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedVillageIndex', index);
    // print("Selected Village Page : $selectedVillageData");
  }

  Future<void> _onSelectedTypeDataTapped(int index, String type) async {
    setState(() {
      selectedTypeIndex = index;
      typeName = type;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedTypeIndex', index);
    // print("Selected Type Page : $selectedTypeData");
  }

  void _onSelectedMenuDataTapped(int index) {
    setState(() {
      selectedMenuData = index;
    });
    // print("Selected Menu Page : $selectedMenuData");
  }
}
