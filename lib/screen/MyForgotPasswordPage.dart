import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';
import 'package:krishiyan/screen/MyLoginPage.dart';
import 'package:krishiyan/utils/Constants.dart';

import '../helper/AlertHelper.dart';

class MyForgotPasswordPage extends StatefulWidget {
  const MyForgotPasswordPage({super.key});

  @override
  State<MyForgotPasswordPage> createState() => _MyForgotPasswordPageState();
}

class _MyForgotPasswordPageState extends State<MyForgotPasswordPage> {
  TextEditingController mobileNumberController = TextEditingController();
  bool otpVisible = false;

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
                        backgroundColor: const Color(0xFF3FC041),
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
                        setState(() {
                          otpVisible = true;
                        });
                      },
                    ),
                  ),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Please, fill this field.' : null,
                controller: mobileNumberController,
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
              child: OtpTextField(
                numberOfFields: 4,
                borderColor: const Color(0xFF3dc33b),
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                filled: true,
                fieldWidth: 55,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  // showDialog(
                  //     context: context,
                  //     builder: (context){
                  //       return AlertDialog(
                  //         title: Text("Verification Code"),
                  //         content: Text('Code entered is $verificationCode'),
                  //       );
                  //     }
                  // );
                }, // end onSubmit
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  // if(otpVisible) {
                  //   Navigator.pop(context);
                  //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //       builder: (
                  //           BuildContext context) => const MyLoginPage()));
                  // }
                  _submit();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                  textStyle: const TextStyle(fontSize: 15),
                  backgroundColor: const Color(0xFF3FC041),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
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
    );
  }

  void _submit() {
    final mobileNumber = mobileNumberController.text;
    if (mobileNumber.isNotEmpty) {
      resetPassword(mobileNumber); // Call the resetPassword function
    } else {
      AlertHelper.showToast("Please enter an mobile number", context);
    }
  }

  Future<void> resetPassword(String number) async {
    final dio = Dio(); // Create an instance of Dio

    // Define the URL for your API endpoint
    final url = RESET_PASSWORD; // Replace with your API endpoint

    // Create the payload data
    final data = {"contactNumber": number, "newPassword": ""};

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
