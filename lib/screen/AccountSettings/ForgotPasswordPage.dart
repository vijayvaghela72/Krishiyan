import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';
import 'package:krishiyan/mvc/model/GetOtpDetails.dart';
import 'package:krishiyan/screen/Login/LoginPage.dart';
import 'package:krishiyan/utils/Constants.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../helper/AlertHelper.dart';
import '../../mvc/controller/otpController.dart';
import '../../utils/AppColor.dart';
import 'package:dio/dio.dart';
// Ensure you have Flutter imports for AlertHelper and setState usage
import 'dart:convert';

import '../../utils/hashPassword.dart'; // For json.encode

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileNumberController = TextEditingController();
  bool passwordFieldVisible = false;
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  String? _passwordErrorText;
  late OtpFieldController otpController = OtpFieldController();
  String otpData = "";
  String enteredOtp = '';

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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 60,
                ),
                Center(child: Image.asset('assets/images/loginLogo.png')),
                const SizedBox(
                  height: 40,
                ),
                Center(
                    child: Text(
                  buildTranslate("forgotPassword")!,
                  style: const TextStyle(
                      color: Color(0xFF3dc33b),
                      fontSize: 20,
                      fontFamily: 'poppins-medium'),
                )),
                const SizedBox(
                  height: 30,
                ),

                // mobile number
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Text(
                    buildTranslate("enterMobileNumber")!,
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
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      //To remove first '0'
                      FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                      //To remove first '94' or your country code
                      FilteringTextInputFormatter.deny(RegExp(r'^94+')),
                    ],
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
                      hintText: buildTranslate('enterMobileNumber'),
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
                          child: Text(
                            buildTranslate("getOtp")!,
                            style: const TextStyle(
                                fontFamily: "poppins-regular", fontSize: 15.0),
                          ),
                          onPressed: () {
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

                otpData.isNotEmpty
                    ? const SizedBox(
                        height: 10,
                      )
                    : Container(),

                // verify otp
                Visibility(
                  visible: otpData.isNotEmpty,
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

                otpData.isNotEmpty
                    ? const SizedBox(
                        height: 15,
                      )
                    : Container(),

                Visibility(
                  visible: otpData.isNotEmpty,
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

                otpData.isNotEmpty
                    ? SizedBox(
                        height: 20,
                      )
                    : Container(),

                // newPassword
                passwordFieldVisible
                    ? Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("newPassword")!,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF666666),
                              fontFamily: 'poppins-semibold'),
                        ),
                      )
                    : Container(),
                passwordFieldVisible
                    ? SizedBox(
                        height: 10,
                      )
                    : Container(),
                passwordFieldVisible
                    ? Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          obscureText: !_passwordVisible,
                          onChanged: (value) {},
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
                              // Return error message for form validation
                              return 'Weak Password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            errorText: _passwordErrorText,
                            hintText: buildTranslate("enterYourPassword")!,
                            hintStyle:
                                const TextStyle(color: AppColor.greyColor),
                            fillColor: AppColor.whiteColor,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor.greyColor,
                                width: 1.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  color: AppColor.greenColor, width: 0.5),
                            ),
                            // Here is key idea
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColor.greyColor,
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
                      )
                    : Container(),

                const SizedBox(
                  height: 20,
                ),

                passwordFieldVisible
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _submit();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(12),
                            textStyle: const TextStyle(fontSize: 15),
                            backgroundColor: const Color(0xFF3FC041),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // <-- Radius
                            ),
                          ),
                          child: Text(
                            buildTranslate('SUBMIT')!,
                            style: const TextStyle(
                                fontSize: 18, fontFamily: 'poppins-medium'),
                          ),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: ElevatedButton(
                          onPressed: () {
                            verifyOtp(mobileNumberController.text);
                            print(otpData);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(12),
                            textStyle: const TextStyle(fontSize: 15),
                            backgroundColor: const Color(0xFF3FC041),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // <-- Radius
                            ),
                          ),
                          child: Text(
                            buildTranslate('verifyOtp')!,
                            style: const TextStyle(
                                fontSize: 18, fontFamily: 'poppins-medium'),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getOtpApiCall() async {
    String phoneNumber = mobileNumberController.text.toString();

    // Check if the phone number exists
    bool exists = await checkPhoneNumber(phoneNumber);

    if (exists) {
      // Phone number exists, proceed to get OTP
      var body = json.encode({"phoneNumber": phoneNumber});

      GetOtpData? userOtp = await OtpController.getOtp(body, context: context);
      print("otpData: ${userOtp!.otp}");
      otpData = userOtp.otp ?? "";

      setState(() {
        otpData = otpData;
      });
      // Start the timer for 2 minutes (120 seconds)
      startOtpCooldown();
      // You can add any additional handling here if needed
      AlertHelper.showToast("OTP sent on your mobile number", context);
    } else {
      // Phone number does not exist, show a prompt
      AlertHelper.showToast(
          "Phone number does not exist. Please check and try again.", context);
    }
    // List<String> stringList = otpData.split('');
    // // Setting OTP in the OtpTextField after widget build
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   otpController.set(stringList);
    // });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final mobileNumber = mobileNumberController.text;
      final password = passwordController.text;
      if (mobileNumber.isNotEmpty && password.isNotEmpty) {
        resetPassword(
            mobileNumber, password); // Call the resetPassword function
      } else {
        AlertHelper.showToast(
            "Please enter an mobile number & password", context);
      }
    }
  }

  Future<void> verifyOtp(String number) async {
    final dio = Dio(); // Create an instance of Dio

    // Define the URL for your API endpoint
    final url = "${baseUrl}whatsapp/check-otp/";

    // Create the payload data
    final data = {
      "phoneNumber": number,
      "otp": enteredOtp // Use the entered OTP from the onCompleted callback
    };

    try {
      // Make the POST request to the server to verify the OTP
      final response = await dio.request(
        url,
        data: data,
        options: Options(
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Check the response from the server
      if (response.statusCode == 200) {
        // Successfully verified OTP
        print("OTP verified successfully!");
        AlertHelper.showToast("OTP verified successfully", "");
        setState(() {
          passwordFieldVisible = true; // Make the password field visible
        });
      } else {
        // Handle OTP verification failure
        print("OTP verification failed!");
        AlertHelper.showToast("Invalid OTP. Please try again.", context);
      }
    } catch (e) {
      // Handle errors
      print("Error during OTP verification: $e");
      AlertHelper.showToast("OTP verification failed!", context);
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
        AlertHelper.showToast("Phone number is valid.", context);
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

  Future<void> resetPassword(String number, String password) async {
    final dio = Dio(); // Create an instance of Dio

    // Define the URL for your API endpoint
    final url = RESET_PASSWORD; // Replace with your API endpoint
    // Using the PasswordUtils to hash the password
    String hashedPassword = PasswordUtils.hashPassword(password);

    // Create the payload data
    final data = {"contactNumber": number, "newPassword": hashedPassword};

    try {
      // Make the POST request
      final response = await dio.request(
        url,
        data: data,
        options: Options(
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Check the response
      if (response.statusCode == 200) {
        AlertHelper.showToast("Password reset successfully", "");
        print('Password reset successfully');
        print(response.data); // Print response data if needed
        Navigator.pop(context);
      } else {
        AlertHelper.showToast("Failed to send password reset email", "");
        print('Failed to send password reset email');
        print('Response code: ${response.statusCode}');
        print('Response body: ${response.data}');
      }
    } catch (e) {
      print('Error: $e'); // Print error if something goes wrong
    }
  }
}
