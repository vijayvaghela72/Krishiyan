import 'dart:convert';

import '../../localization/AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/screen/Registration/MyRegistrationPage.dart';
import '../../helper/AlertHelper.dart';
import '../../helper/SharedPref.dart';
import '../../mvc/controller/loginController.dart';
import '../../mvc/model/LoginData.dart';
import '../../utils/AppColor.dart';
import '../../utils/Constants.dart';
import '../AccountSettings/ForgotPasswordPage.dart';
import '../HomeScreen/HomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? _usernameErrorText;
  String? _passwordErrorText;

  bool _passwordVisible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _submitted = false;

  @override
  Widget build(BuildContext context)
  {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColor.transparentColor,
    ));

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFf9f9f9),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 70,
            ),
            Center(child: Image.asset('assets/images/loginLogo.png')),
            const SizedBox(
              height: 50,
            ),
            Center(
                child: Text(
                  buildTranslate("signIn")!,
                  style: const TextStyle(
                      color: Color(0xFF3dc33b),
                      fontSize: 25,
                      fontFamily: 'poppins-medium'),
                )),
            const SizedBox(
              height: 30,
            ),

            // mobile number
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("enterMobileNumber")!,
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
                onChanged: (value) {
                  _login();
                },
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    fillColor: AppColor.whiteColor,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.greyColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText: buildTranslate("enterMobileNumber")!,
                    hintStyle: const TextStyle(color: AppColor.greyColor),
                    errorText: _usernameErrorText,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: AppColor.greenColor, width: 0.5),
                    )),
                controller: mobileNumberController,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // password
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("password")!,
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
                controller: passwordController,
                obscureText: !_passwordVisible,
                onChanged: (value) {
                  _login();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }

                  // Check if password meets the required conditions
                  String pattern = r'^(?=.*[a-z])(?=.*[A-Z]).{8,}$';
                  RegExp regExp = RegExp(pattern);

                  if (!regExp.hasMatch(value)) {
                    return 'Password must contain at least 1 uppercase letter, 1 '
                        'lowercase letter, and be at least 8 characters long';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  errorText: _passwordErrorText,
                  hintText: buildTranslate("enterYourPassword")!,
                  hintStyle: const TextStyle(color: AppColor.greyColor),
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
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: AppColor.greenColor, width: 0.5),
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
            ),

            const SizedBox(
              height: 20,
            ),
            InkWell(
              highlightColor: AppColor.transparentColor,
              splashColor: AppColor.transparentColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage()),
                );
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Text(
                      buildTranslate("forgotPassword")!,
                      style: const TextStyle(
                        fontFamily: 'poppins-medium',
                        fontSize: 13,
                        shadows: [
                          Shadow(
                              color: Color(0xFF3FC041), offset: Offset(0, -5))
                        ],
                        color: AppColor.transparentColor,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF3FC041),
                        decorationThickness: 4,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    )),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  _loginApiCall();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColor.whiteColor,
                  padding: const EdgeInsets.all(15),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: const Color(0xFF3FC041),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
                child: Text(
                  buildTranslate("login")!,
                  style: const TextStyle(fontSize: 15, fontFamily: 'poppins-regular'),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Text(
                    buildTranslate("don'tHaveAccount")!,
                    style: const TextStyle(
                      fontFamily: 'poppins-regular',
                      fontSize: 14,
                      shadows: [
                        Shadow(color: Color(0xFF666666), offset: Offset(0, -5))
                      ],
                      color: AppColor.transparentColor,
                    ),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              highlightColor: AppColor.transparentColor,
              splashColor: AppColor.transparentColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyRegistrationPage()),
                );
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Text(
                      buildTranslate("clickToRegister")!,
                      style: const TextStyle(
                        fontFamily: 'poppins-medium',
                        fontSize: 14,
                        shadows: [
                          Shadow(
                              color: Color(0xFF3FC041), offset: Offset(0, -5))
                        ],
                        color: AppColor.transparentColor,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF3FC041),
                        decorationThickness: 4,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _login() {
    setState(() {
      _submitted = false;
    });
    if ((mobileNumberController.text.isEmpty) ||
        (passwordController.text.isEmpty) ) {
      setState(() {
        _submitted = false;
      });
    } else {
      setState(() {
        _submitted = true;
      });
    }
  }

  _loginApiCall() async {
    if (mobileNumberController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty) {
      setState(() {
        _submitted = false;
      });

      var body = json.encode({
        "contactNumber": mobileNumberController.text.trim(),
        "password": passwordController.text.trim().toString()
      });

      Data? user = await LoginController.login(body, context: context);

      if (user != null) {
        print("user number : " + mobileNumberController.text.toString());
        print("user token : " + user.token.toString());

        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _submitted = true;
          });
          AlertHelper.showToast("Login successfully.",context);

          SharedPref.savePreferenceValue(isLogin, true);

          SharedPref.savePreferenceValue(name, user.fpoOrganization!.nameOfFpo ?? "");
          SharedPref.savePreferenceValue(email, user.fpoOrganization!.organizationalEmail ?? "");
          SharedPref.savePreferenceValue(contactNo, user.fpoOrganization!.contactNumber ?? "");
          SharedPref.savePreferenceValue(id, user.fpoOrganization!.sId ?? "");
          SharedPref.savePreferenceValue(token, user.token ?? "");

          SharedPref.savePreferenceValue(typeOfOrganization, user.fpoOrganization!.typeOfOrganization ?? "");

          print("Login Api Contact : ${user.fpoOrganization!.contactNumber}");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage(
                      selectedIndex: 0,
                    )),
          );
        });
      }
      else {
        print("Api error");
        AlertHelper.showToast("Login unsuccessful",context);
        setState(() {
          _submitted = true;
        });
      }
    }
    else{
      AlertHelper.showToast("Please enter credentials.",context);
    }
  }

}