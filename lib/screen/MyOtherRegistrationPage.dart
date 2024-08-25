import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:krishiyan/screen/MyRegistrationPage.dart';

import '../helper/AlertHelper.dart';
import '../localization/AppLocalizations.dart';
import '../mvc/controller/loginController.dart';
import '../mvc/model/LoginData.dart';
import 'MyLoginPage.dart';

class MyOtherRegistrationPage extends StatefulWidget {
  const MyOtherRegistrationPage({super.key});

  @override
  State<MyOtherRegistrationPage> createState() => _MyOtherRegistrationPageState();
}

class _MyOtherRegistrationPageState extends State<MyOtherRegistrationPage> {

  int _radioSelected = 1;
  String _radioVal = "";

  bool otpVisible = false;

  TextEditingController nameOfEntityController = TextEditingController();
  TextEditingController typeOfEntityController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userConfirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

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
            const SizedBox(height: 40,),
            Center(child: Image.asset('assets/images/loginLogo.png')),
            const SizedBox(height: 30,),
            Center(child: Text(buildTranslate("createAccount")!,
              style: const TextStyle(color: Color(0xFF3dc33b), fontSize: 22,
                fontFamily: 'poppins-medium'),)),
            const SizedBox(height: 30,),

            // nameOfEntity
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("nameOfEntity")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                decoration:  InputDecoration(
                    alignLabelWithHint: true,
                    fillColor: Colors.white,
                    filled: true,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText: buildTranslate("enterName"),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    )
                ),
                validator: (value) => value!.isEmpty ? 'Please, fill this field.' : null,
                controller: nameOfEntityController,
              ),
            ),

            const SizedBox(height: 20,),

            // typeOfEntity
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("typeOfEntity")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    fillColor: Colors.white,
                    filled: true,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText: buildTranslate("selectTypeEntity")!,
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    )
                ),
                validator: (value) => value!.isEmpty ? 'Please, fill this field.' : null,
                controller: typeOfEntityController,
              ),
            ),

            const SizedBox(height: 20,),

            // mobile number
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("mobileNumber")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                decoration: InputDecoration(
                  enabled: true,
                  alignLabelWithHint: true,
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
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
                        backgroundColor: const Color(0xFF3FC041),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(buildTranslate("getOTP")!),
                      onPressed: () {
                       setState(() {
                         otpVisible = true;
                       });
                      },
                    ),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please, fill this field.' : null,
                controller: mobileNumberController,
              ),
            ),

            otpVisible ? const SizedBox(height: 15,) : Container(),

            // verify otp
            Visibility(
              visible: otpVisible,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Text(buildTranslate("verifyOtp")!, style: const TextStyle(fontSize: 15,
                    color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
              ),
            ),

            otpVisible ? const SizedBox(height: 15,) : Container(),

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
                onSubmit: (String verificationCode){
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

            const SizedBox(height: 15,),

            // password
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("newPassword")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: userPasswordController,
                obscureText: !_passwordVisible,//This will obscure text dynamically
                decoration: InputDecoration(
                  hintText: buildTranslate("enterYourPassword"),
                  hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
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

            const SizedBox(height: 20,),

            // confirm password
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("confirmPassword")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: userConfirmPasswordController,
                obscureText: !_confirmPasswordVisible,//This will obscure text dynamically
                decoration: InputDecoration(
                  hintText: buildTranslate("enterConfirmPassword"),
                  hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
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

            const SizedBox(height: 20,),

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
                        _radioVal = 'agreed';
                      });
                    },
                  ),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        text: buildTranslate("readAgree"),
                        style: const TextStyle(color: Colors.grey, fontFamily: "poppins-regular", fontSize: 12.0), /*defining default style is optional */
                        children: <TextSpan>[
                          TextSpan(
                              text: buildTranslate("agreementPolicy"),
                              style: const TextStyle(color: Colors.green, fontFamily: "poppins-regular", fontSize: 12.0)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15,),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  // showAlertDialog(context);
                  if(nameOfEntityController.text.isNotEmpty
                      && typeOfEntityController.text.isNotEmpty
                      && mobileNumberController.text.isNotEmpty
                      && userPasswordController.text.isNotEmpty){

                    _registrationApiCall(nameOfEntityController.text,
                      typeOfEntityController.text, mobileNumberController.text, userPasswordController.text.toString(),
                    );
                  }
                  else{
                    AlertHelper.showToast("Please enter credentials.",context);
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
                child: Text(buildTranslate("signup")!, style: const
                        TextStyle(fontSize: 17, fontFamily: 'poppins-medium'),),
              ),
            ),
            const SizedBox(height: 20,),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(left: 25.0,),
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
                                color: Color(0xFF666666),
                                offset: Offset(0, -5))
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
                            MaterialPageRoute(builder: (context) => const MyRegistrationPage()),
                          );
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 25.0, bottom: 5.0),
                              child:Text(
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
                                  decoration:
                                  TextDecoration.underline,
                                  decorationColor: Color(0xFF3FC041),
                                  decorationThickness: 4,
                                  decorationStyle:
                                  TextDecorationStyle.solid,
                                ),
                              )
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
            const SizedBox(height: 15,),
          ],
        ),
      ),
    );

  }

  _registrationApiCall(String name, String typeOfEntity,
      String number, String password,) async {

    var body = json.encode({
      "typeOfOrganization": "Others",
      "nameOfFpo": name,
      "typeOfFpo": typeOfEntity,
      "dateOfFpo": "",
      "organizationalEmail": "",
      "contactNumber": number,
      "promoterName": "",
      "password": password
    });

    Data? user = await LoginController.signup(body, context: context);

    if (user != null) {
      print("user token : " + user.token.toString());

      Future.delayed(const Duration(seconds: 1), () {
        print("Api success");

        // AlertHelper.showToast("Registration successfully.",context);

        showAlertDialog(context);

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           MyHomePage(
        //             selectedIndex: 0,
        //           )),
        // );
      });
    }
    else {
      print("Api error");
      AlertHelper.showToast("Registration unsuccessful",context);
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
                  builder: (BuildContext context) => const MyLoginPage()));
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

          Center(child: Image.asset('assets/images/check_green.png', width: 100, height: 100,)),

          Text(buildTranslate("youRegisterSuccessfully")!, softWrap: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: "poppins-semibold", fontSize: 15.0, color: Colors.grey),),

          const SizedBox(height: 20,),

          Text(buildTranslate("thankYou")!, softWrap: true,
            style: const TextStyle(fontFamily: "poppins-semibold", fontSize: 20.0, color: Colors.black),),

          const SizedBox(height: 20,),
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

}