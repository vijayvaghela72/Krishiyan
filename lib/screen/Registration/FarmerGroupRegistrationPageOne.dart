import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';
import 'package:krishiyan/screen/Login/LoginPage.dart';
import 'package:krishiyan/screen/Registration/MyRegistrationPage.dart';
import 'package:intl/intl.dart';
import 'package:krishiyan/utils/Constants.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import '../../helper/AlertHelper.dart';
import 'FarmerGroupRegistrationPageTwo.dart';
import 'package:krishiyan/mvc/model/GetOtpDetails.dart';
import '../../mvc/controller/otpController.dart';

import 'package:dio/dio.dart';
// Ensure you have Flutter imports for AlertHelper and setState usage
import 'dart:convert'; // For json.encode

class FarmerGroupRegistrationPageOne extends StatefulWidget {
  const FarmerGroupRegistrationPageOne({super.key});

  @override
  State<FarmerGroupRegistrationPageOne> createState() =>
      _FarmerGroupRegistrationPageOneState();
}

class _FarmerGroupRegistrationPageOneState
    extends State<FarmerGroupRegistrationPageOne> {
  TextEditingController nameOfOrganizationController = TextEditingController();
  TextEditingController dateOfOrganizationController = TextEditingController();
  TextEditingController organizationMailIDController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController nameOfPromoterController = TextEditingController();
  String enteredOtp = '';
  String otpData = "";

  bool otpVisible = false;

  bool isOtpButtonEnabled = true; // Track OTP button status
  String countdownText = ''; // To show countdown text (e.g., "Wait 1:45")
  Timer? otpCooldownTimer; // Timer to track cooldown

  final List<String> fpoItems = [
    'Farmer Producer Organization',
    'Farmer Producer Company',
    'Primary Agricultural credit society',
    'Farmer Interested groups',
    'Co-operatives'
  ];
  String selectedFPOItemValue = "";
  late OtpFieldController otpController = OtpFieldController();

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
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            Center(child: Image.asset('assets/images/loginLogo.png')),
            const SizedBox(
              height: 30,
            ),
            const Center(
                child: Text(
              "Create New Account",
              style: TextStyle(
                  color: Color(0xFF3dc33b),
                  fontSize: 22.0,
                  fontFamily: 'poppins-medium'),
            )),
            const SizedBox(
              height: 30,
            ),

            // name
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("nameOfOrganization")!,
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText: buildTranslate("enterOrganization"),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: nameOfOrganizationController,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // type of Organization
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("typeOfOrganization")!,
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Container(
                color: Colors.white,
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    // Add more decoration..
                  ),
                  hint: const Text(
                    '--',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: fpoItems
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
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
                    selectedFPOItemValue = value.toString();
                    //Do something when selected item is changed.
                  },
                  onSaved: (value) {
                    selectedFPOItemValue = value.toString();
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
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // date of Organization
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("dateOfOrganization")!,
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: dateOfOrganizationController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'DD/MM/YYYY',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    }, // Open date picker on icon press
                  ),
                  hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
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
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // organization mail id
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("organizationMailID")!,
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: organizationMailIDController,
                decoration: InputDecoration(
                  hintText: buildTranslate("organizationMailID")!,
                  hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
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
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // mobile number
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("officeContactNumber")!,
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                maxLength: 10,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  //To remove first '0'
                  FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                  //To remove first '94' or your country code
                  FilteringTextInputFormatter.deny(RegExp(r'^94+')),
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
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  hintText: buildTranslate("mobileNumber"),
                  hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(80, 35),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: isOtpButtonEnabled
                            ? const Color(0xFF3FC041) // Green when enabled
                            : Colors.grey, // Grey when disabled (cooldown)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(buildTranslate("getOtp")!),
                      onPressed: () {
                        if (contactNumberController.text.isNotEmpty) {
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
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: contactNumberController,
              ),
            ),

            // Display the countdown timer if the button is disabled
            Visibility(
              visible: !isOtpButtonEnabled,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Text(
                  countdownText, // This is the dynamic countdown text
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ),

            otpVisible
                ? const SizedBox(
                    height: 15,
                  )
                : Container(),

            // verify otp
            Visibility(
              visible: otpVisible,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Text(
                  buildTranslate("verifyOtp")!,
                  style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF666666),
                      fontFamily: 'poppins-semibold'),
                ),
              ),
            ),

            otpVisible
                ? const SizedBox(
                    height: 15,
                  )
                : Container(),
            Visibility(
              visible: otpVisible,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: OTPTextField(
                    controller: otpController,
                    length: 4,
                    // borderColor: const Color(0xFF3dc33b),
                    // showFieldAsBox: true,
                    // filled: true,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
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
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Check if the input fields are filled
                  if (nameOfOrganizationController.text.trim().isNotEmpty &&
                      selectedFPOItemValue.trim().isNotEmpty &&
                      contactNumberController.text.isNotEmpty) {
                    // Call verifyOtp and wait for the result
                    bool isOtpVerified = await verifyOtp(
                        contactNumberController.text, enteredOtp, context);

                    if (isOtpVerified) {
                      // If OTP is verified, navigate to the next page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FarmerGroupRegistrationPageTwo(
                            name: nameOfOrganizationController.text,
                            type: selectedFPOItemValue,
                            date: dateOfOrganizationController.text,
                            email: organizationMailIDController.text,
                            contactNumber: contactNumberController.text,
                          ),
                        ),
                      );
                    } else {
                      // Show error if OTP is not verified
                      AlertHelper.showToast(
                          "OTP verification failed. Please try again.",
                          context);
                    }
                  } else {
                    // Show error if required fields are not filled
                    AlertHelper.showToast("Please enter all details.", context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: const Color(0xFF3FC041),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
                child: Text(
                  buildTranslate("next")!,
                  style: const TextStyle(
                      fontSize: 15, fontFamily: 'poppins-regular'),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        buildTranslate("alreadyAccount")!,
                        style: const TextStyle(
                          fontFamily: 'poppins-regular',
                          fontSize: 15,
                          shadows: [
                            Shadow(
                                color: Color(0xFF666666), offset: Offset(0, -5))
                          ],
                          color: Colors.transparent,
                        ),
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MyRegistrationPage()),
                          );
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 25.0, bottom: 5.0),
                              child: Text(
                                buildTranslate("backToSignIn")!,
                                style: const TextStyle(
                                  fontFamily: 'poppins-medium',
                                  fontSize: 13,
                                  shadows: [
                                    Shadow(
                                        color: Color(0xFF3FC041),
                                        offset: Offset(0, -5))
                                  ],
                                  color: Colors.transparent,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFF3FC041),
                                  decorationThickness: 4,
                                  decorationStyle: TextDecorationStyle.solid,
                                ),
                              )),
                        ),
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // Show the date picker dialog
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default date is the current date
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime.now(), // Restrict to past and current date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      setState(() {
        // Format the selected date and display it in the TextFormField
        dateOfOrganizationController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  Future<bool> verifyOtp(
      String number, String enteredOtp, BuildContext context) async {
    final dio = Dio(); // Create an instance of Dio

    // Define the URL for your API endpoint
    final url = "${baseUrl}whatsapp/check-otp/";

    // Create the payload data
    final data = json.encode({
      "phoneNumber": number,
      "otp": enteredOtp, // Use the entered OTP from the input
    });

    try {
      // Make the POST request to verify the OTP
      final response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
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

  Future<void> getOtpApiCall() async {
    String phoneNumber = contactNumberController.text.toString();

    // Check if the phone number exists
    bool exists = await checkPhoneNumber(phoneNumber);

    if (!exists) {
      final body =
          json.encode({"phoneNumber": contactNumberController.text.toString()});
      setState(() {
        otpVisible = true;
      });

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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Future<bool> checkPhoneNumber(String number) async {
    final dio = Dio(); // Create an instance of Dio

    // Define the URL for your API endpoint, appending the number directly
    final url = "${baseUrl}check-contact/$number";

    try {
      // Make the GET request to check the phone number
      final response = await dio.get(url,
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));

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
}
