import 'dart:async';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:krishiyan/screen/registration/MyRegistrationPage.dart';
import 'package:krishiyan/widgets/constant.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import '../../helper/AlertHelper.dart';
import '../../localization/AppLocalizations.dart';
import '../../mvc/controller/farmerDashboardController.dart';
import '../../mvc/controller/otpController.dart';
import '../../mvc/model/GetOtpDetails.dart';
import '../Login/LoginPage.dart';

class ManufactureRegistrationPage extends StatefulWidget {
  const ManufactureRegistrationPage({super.key});

  @override
  State<ManufactureRegistrationPage> createState() =>
      _ManufactureRegistrationPageState();
}

class _ManufactureRegistrationPageState
    extends State<ManufactureRegistrationPage> {
  int _radioSelected = 1;
  bool otpVisible = false;

  final List<String> items = [
    'Unit Grading, Sorting',
    'Dal Mills',
    'Processors',
  ];
  List<String> selectedItems = [];

  TextEditingController nameOfEntityController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userConfirmPasswordController = TextEditingController();
  String enteredOtp = '';
  String otpData = "";
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  late OtpFieldController otpController = OtpFieldController();
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
            Center(
                child: Text(
              buildTranslate("createAccount")!,
              style: const TextStyle(
                  color: Color(0xFF3dc33b),
                  fontSize: 22,
                  fontFamily: 'poppins-medium'),
            )),
            const SizedBox(
              height: 30,
            ),

            // name
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("nameOfEntity")!,
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
                    hintText: buildTranslate("enterName"),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: nameOfEntityController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            //typeOfEntity
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("typeOfEntity")!,
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
              child: DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  // Add more decoration..
                ),
                hint: Text(
                  buildTranslate("selectTypeEntity")!,
                  style: const TextStyle(color: Color(0xFFe7e7e7)),
                ),
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    //disable default onTap to avoid closing menu when selecting an item
                    enabled: false,
                    child: StatefulBuilder(
                      builder: (context, menuSetState) {
                        final isSelected = selectedItems.contains(item);
                        return InkWell(
                          onTap: () {
                            isSelected
                                ? selectedItems.remove(item)
                                : selectedItems.add(item);
                            //This rebuilds the StatefulWidget to update the button's text
                            setState(() {});
                            //This rebuilds the dropdownMenu Widget to update the check mark
                            menuSetState(() {});
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            height: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isSelected)
                                  const Icon(Icons.check_box_outlined)
                                else
                                  const Icon(Icons.check_box_outline_blank),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
                //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                value: selectedItems.isEmpty ? null : selectedItems.last,
                onChanged: (value) {},
                selectedItemBuilder: (context) {
                  return items.map(
                    (item) {
                      return Container(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          selectedItems.join(', '),
                          style: const TextStyle(
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      );
                    },
                  ).toList();
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  height: 40,
                  width: 140,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            //mobileNumber
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("mobileNumber")!,
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
                  hintText: buildTranslate("mobileNumber")!,
                  hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(80, 40),
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
                        setState(() {
                          otpVisible = true;
                        });
                        if (mobileNumberController.text.isNotEmpty) {
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
                controller: mobileNumberController,
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
              height: 15,
            ),

            // password
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("newPassword")!,
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
                controller: userPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  // Check if password meets the required conditions
                  String pattern = r'^(?=.*[a-z])(?=.*[A-Z]).{8,}$';
                  RegExp regExp = RegExp(pattern);

                  if (!regExp.hasMatch(value)) {
                    AlertHelper.showToast(
                        'Password must contain at least 1 uppercase letter, 1 '
                        'lowercase letter, and be at least 8 characters long',
                        context);
                    return 'Weak Password';
                  }

                  return null;
                },
                obscureText:
                    !_passwordVisible, //This will obscure text dynamically
                decoration: InputDecoration(
                  hintText: buildTranslate("enterYourPassword"),
                  hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
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
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                  // Here is key idea
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // confirm password
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("confirmPassword")!,
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
                controller: userConfirmPasswordController,
                obscureText:
                    !_confirmPasswordVisible, //This will obscure text dynamically
                decoration: InputDecoration(
                  hintText: buildTranslate("enterConfirmPassword"),
                  hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
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
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                  // Here is key idea
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    value: 1,
                    groupValue: _radioSelected,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        _radioSelected = value!;
                      });
                    },
                  ),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: buildTranslate("readAgree"),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontFamily: "poppins-regular",
                            fontSize: 12.0),
                        /*defining default style is optional */
                        children: <TextSpan>[
                          TextSpan(
                              text: buildTranslate("agreementPolicy"),
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontFamily: "poppins-regular",
                                  fontSize: 12.0)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (nameOfEntityController.text.isNotEmpty &&
                      selectedItems.isNotEmpty &&
                      mobileNumberController.text.isNotEmpty &&
                      userPasswordController.text.isNotEmpty) {
                    bool isOtpVerified = await verifyOtp(
                        mobileNumberController.text, enteredOtp, context);

                    if (isOtpVerified) {
                      _registrationApiCall(
                        nameOfEntityController.text,
                        selectedItems.toString(),
                        mobileNumberController.text.toString(),
                        userPasswordController.text.toString(),
                      );
                    } else {
                      // Show error if OTP is not verified
                      AlertHelper.showToast(
                          "OTP verification failed. Please try again.",
                          context);
                    }
                  } else {
                    AlertHelper.showToast("Please enter details.", context);
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
                  buildTranslate("signup")!,
                  style: TextStyle(fontSize: 17, fontFamily: 'poppins-medium'),
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
                          fontSize: 14,
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
                                buildTranslate("backSignIn")!,
                                style: const TextStyle(
                                  fontFamily: 'poppins-regular',
                                  fontSize: 14,
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

  Future<void> getOtpApiCall() async {
    String phoneNumber = mobileNumberController.text.toString();
    // Check if the phone number exists
    bool exists = await checkPhoneNumber(phoneNumber);

    if (!exists) {
      final body =
          json.encode({"phoneNumber": mobileNumberController.text.toString()});

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

  _registrationApiCall(
    String name,
    String type,
    String number,
    String password,
  ) async {
    var data = json.encode({
      "typeOfOrganization": "Manufacture",
      "nameOfFpo": name,
      "typeOfFpo": type,
      "dateOfFpo": "",
      "organizationalEmail": "",
      "contactNumber": number,
      "promoterName": "",
      "password": password,
    });

    var farmerRegistration = FarmerDashboardController.farmerGroupRegistration(
        data,
        context: context);

    if (farmerRegistration.toString().isNotEmpty) {
      Future.delayed(const Duration(seconds: 1), () {
        print('farmer trader registered successfully');

        showAlertDialog(context);
      });
    } else {
      print("Api error");
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              // Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const LoginPage()));
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
            buildTranslate("youRegisterSuccessfully")!,
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
}
