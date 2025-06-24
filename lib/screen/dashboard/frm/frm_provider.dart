import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/helper/constant.dart';
import 'package:krishiyan/helper/app_global.dart';
import 'package:krishiyan/helper/alert_helper.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:krishiyan/helper/snackbar.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/mvc/model/frm_insight_model.dart';
import 'package:krishiyan/mvc/model/villages_model.dart';
import 'package:krishiyan/mvc/model/otp_details_model.dart';
import 'package:krishiyan/mvc/controller/otp_controller.dart';
import 'package:krishiyan/mvc/model/farmer_dashboard_model.dart';
import 'package:krishiyan/screen/dashboard/frm/frm_model.dart';
import 'package:otp_text_field/otp_field.dart';

class FRMProvider extends ChangeNotifier {
  // widget data
  String? villageName, typeName;
  // farmer selection
  List<String> dropdownItems = [];
  List<FarmerDataModel> farmerDataList = [];
  Future<void> fetchFarmerNameData() async {
    // try {
    String? number = await AppGlobal.getStringPreference('contactNumber');
    var num = number ?? "1";
    var response = await getAPICall(apiUrl: FARMER_NAME + num);
    print('*****************');
    print(FARMER_NAME + num);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      dropdownItems = jsonData['data']
          .map<String>((item) => item['name'].toString())
          .toList();
    } else {
      throw Exception('Failed to load farmers name');
    }
    // } catch (e) {
    //   print('Error fetching farmer name data: $e');
    // }
  }

  // for crops selection
  String? selectedCrop;
  List<String> crops = [];
  Future<void> fetchCrops(Function update) async {
    try {
      final response = await getAPICall(apiUrl: "${baseUrl}all/crops");
      if (response.statusCode == 200) {
        crops = List<String>.from(jsonDecode(response.body)['data']);
        update();
      } else {
        print('Failed to retrieve crops');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // fetch village data
  String? selectedVillageName;
  SelectVillagesNameData? villageNameData;
  SelectVillagesNameData? drawerVillageNameData;
  Future<void> getVillageData(Function update, bool fromDrawer) async {
    try {
      // Retrieve the dealer number first
      String? number = await AppGlobal.getStringPreference('contactNumber');
      var dealerNumber = number ?? "1"; // Default to "1" if no number found
      showLoading();
      var response = await getAPICall(apiUrl: VILLAGES_NAMES + dealerNumber);
      stopLoading();
      if (response.statusCode == 200) {
        if (fromDrawer) {
          drawerVillageNameData =
              SelectVillagesNameData.fromJson(jsonDecode(response.body));
        } else {
          villageNameData =
              SelectVillagesNameData.fromJson(jsonDecode(response.body));
        }
        update();
      } else {
        throw Exception('Failed to load villages');
      }
    } catch (e) {
      print('Error fetching _village name data: $e');
    }
  }

  // First Tab - Farmer Dashboard
  TextEditingController searchByNaneController = TextEditingController();
  String searchText = '';
  late Future<List<FarmerDetails>> futureFarmerProfiles;
  String WhatsappNumberData = '';
  int? showCropDataVisible;

  // Second Tab - Farmer Registration
  TextEditingController whatsAppNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  late OtpFieldController otpController = OtpFieldController();
  bool isOtpButtonEnabled = true;
  String countdownText = '';
  Timer? otpCooldownTimer;
  bool otpVisible = false;
  String enteredOtp = '';
  String otpData = "";
  Future<void> getOtpApiCall(BuildContext context) async {
    String phoneNumber = whatsAppNumberController.text.toString();
    // Check if the phone number exists
    bool exists = await checkPhoneNumber(phoneNumber, context);
    if (!exists) {
      final body = json.encode({
        "phoneNumber": whatsAppNumberController.text.toString(),
      });
      try {
        GetOtpData? userOtp =
            await OtpController.getOtp(body, context: context);
        if (userOtp != null) {
          print("otpData : ${userOtp.otp}");
          otpData = userOtp.otp ?? "";
          // Start the timer for 2 minutes (120 seconds)
          startOtpCooldown(update);
          AlertHelper.showToast("OTP sent on your mobile number", context);
        } else {
          print("Failed to get OTP data.");
          AlertHelper.showToast(
              "Failed to retrieve OTP. Please try again.", context);
        }
      } catch (e) {
        print("Error during OTP request: $e");
      }
    } else {
      AlertHelper.showToast(
          "Phone number exists. Please check and try again.", context);
    }
  }

  Future<bool> checkPhoneNumber(String number, BuildContext context) async {
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
      return false; // Return false in case of an error
    }
  }

  void startOtpCooldown(Function update) {
    isOtpButtonEnabled = false;
    update();

    // Set the initial cooldown time (2 minutes = 120 seconds)
    int cooldownTime = 120; // 2 minutes in seconds

    // Update the countdown text every second
    otpCooldownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Calculate minutes and seconds
      int minutes = cooldownTime ~/ 60; // Integer division to get minutes
      int seconds = cooldownTime % 60; // Modulo operation to get seconds

      // Format as MM:SS, ensuring two digits for minutes and seconds
      countdownText =
          "Please wait ${_formatTime(minutes)}:${_formatTime(seconds)} before trying again.";
      update();

      if (cooldownTime == 0) {
        timer.cancel(); // Stop the timer when the cooldown is over
        isOtpButtonEnabled = true; // Re-enable the OTP button
        countdownText = ""; // Clear the countdown text
        ;
        update();
      } else {
        cooldownTime--; // Decrease the cooldown time by 1 second
      }
    });
  }

  String _formatTime(int time) {
    return time < 10 ? "0$time" : "$time";
  }

  Future<bool> verifyOtp(
    String number,
    String enteredOtp,
    BuildContext context,
  ) async {
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

  // Third Tab - Crop Cultivation
  initializeCrop() {
    selectedFarmersName = [''];
    selectedCropList = [''];
    selectedItemValue = [''];
    dateController = [TextEditingController()];
    varietyController = [TextEditingController()];
    geoLocationController = [TextEditingController()];
    areaInArcesController = [TextEditingController()];
    geoLinkAreaOnMapController = [TextEditingController()];
  }

  addCrop() {
    selectedFarmersName.add('');
    selectedCropList.add('');
    selectedItemValue.add('');
    dateController.add(TextEditingController());
    varietyController.add(TextEditingController());
    geoLocationController.add(TextEditingController());
    areaInArcesController.add(TextEditingController());
    geoLinkAreaOnMapController.add(TextEditingController());
  }

  removeCrop(int i) {
    selectedFarmersName.removeAt(i);
    selectedCropList.removeAt(i);
    selectedItemValue.removeAt(i);
    dateController.removeAt(i);
    varietyController.removeAt(i);
    geoLocationController.removeAt(i);
    areaInArcesController.removeAt(i);
    geoLinkAreaOnMapController.removeAt(i);
  }

  List<String> selectedFarmersName = [];
  List<String> selectedCropList = [];
  List<String> selectedItemValue = [];
  List<TextEditingController> dateController = [];
  List<TextEditingController> varietyController = [];
  List<TextEditingController> geoLocationController = [];
  List<TextEditingController> areaInArcesController = [];
  List<TextEditingController> geoLinkAreaOnMapController = [];

  final List<String> items = [
    buildTranslate('organic')!,
    buildTranslate('inOrganic')!,
  ];
  // Fourth Tab - Insight
  bool searchCropsFlag = false;

  Future<FrmInsight?>? futureFrminSight;
  int selectedTopData = 0;
  bool isNull = false;
  // farmmer list index = 5
  String? selectedSortItemsValue = '';

  Future<FrmInsight?> fetchInsightsData(bool fromInit) async {
    String? number = await AppGlobal.getStringPreference('contactNumber');
    var num = number ?? "1";
    if (!fromInit) {
      if (selectedCrop == null || selectedVillageName == null) {
        print('Please select both crop and village');
        return null;
      }
    }
    final url = fromInit
        ? '${baseUrl}appFarmer/farmers/insight?dealerNumber=$num'
        : '${baseUrl}appFarmer/farmers/insight?dealerNumber=$num&village=${selectedVillageName}&crop=${selectedCrop}&sort=${selectedSortItemsValue == 'highExpYield' ? 'highToLow' : 'lowToHigh'}';
    try {
      final response = await getAPICall(apiUrl: url);
      if (response.statusCode == 200) {
        return FrmInsight.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        var data = json.decode(response.body);
        setSnackbar(' ${data['message']}');
        return null;
      } else {
        setSnackbar('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
