import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/screen/Registration/MyRegistrationPage.dart';
import '../../helper/AlertHelper.dart';
import '../../mvc/controller/farmerDashboardController.dart';
import '../../utils/AppGlobal.dart';
import '../../utils/hashPassword.dart';
import '../Login/LoginPage.dart';

class FarmerGroupRegistrationPageTwo extends StatefulWidget {
  String name, type, date, email, contactNumber;

  FarmerGroupRegistrationPageTwo({super.key, required this.name, required this.type,
    required this.date, required this.email, required this.contactNumber});

  @override
  State<FarmerGroupRegistrationPageTwo> createState() => _FarmerGroupRegistrationPageTwoState();
}

class _FarmerGroupRegistrationPageTwoState extends State<FarmerGroupRegistrationPageTwo> {

  TextEditingController nameofPromoterController = TextEditingController();

  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userConfirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  int _radioSelected = 1;
  String _radioVal = "";

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
            const Center(child: Text("Create New Account",
              style: TextStyle(color: Color(0xFF3dc33b), fontSize: 22,
                  fontFamily: 'poppins-medium'),)),
            const SizedBox(height: 30,),

            // name
            const Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text("Name of the Promoter or CEO", style: TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText: 'Name of the Promoter or CEO',
                    hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    )
                ),
                validator: (value) => value!.isEmpty ? 'Please, fill this field.' : null,
                controller: nameofPromoterController,
              ),
            ),

            const SizedBox(height: 20,),

            // password
            const Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text("New Password", style: TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: userPasswordController,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  // Check if password meets the required conditions
                  String pattern = r'^(?=.*[a-z])(?=.*[A-Z]).{8,}$';
                  RegExp regExp = RegExp(pattern);

                  if (!regExp.hasMatch(value)) {
                    AlertHelper.showToast('Password must contain at least 1 uppercase letter, 1 '
                        'lowercase letter, and be at least 8 characters long', context) ;
                        return 'Weak Password';
                  }

                  return null;
                },
                obscureText: !_passwordVisible,//This will obscure text dynamically
                decoration: InputDecoration(
                  hintText: 'Enter your password',
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
            const Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text("Confirm Password", style: TextStyle(fontSize: 15,
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
                  hintText: 'Enter your confirm password',
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
              padding: const EdgeInsets.only(left: 10.0, right: 12.0),
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
                      text: const TextSpan(
                        text: "I've read and agreed to",
                        style: TextStyle(color: Colors.grey, fontFamily: "poppins-regular", fontSize: 12.0), /*defining default style is optional */
                        children: <TextSpan>[
                          TextSpan(
                              text: ' User Agreement and Privacy Policy',
                              style: TextStyle(color: Colors.green, fontFamily: "poppins-regular", fontSize: 12.0)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20,),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  if(widget.name.isNotEmpty && widget.type.isNotEmpty && widget.contactNumber.isNotEmpty
                      && userPasswordController.text.isNotEmpty
                      && userConfirmPasswordController.text.isNotEmpty){

                    _registrationApiCall(widget.name,
                        widget.type, widget.contactNumber, userPasswordController.text.toString(),
                        widget.date, widget.email, nameofPromoterController.text.toString()
                    );
                  }
                  else{
                    AlertHelper.showToast("Please enter details.",context);
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
                child: const Text('SIGN IN'
                    '', style: TextStyle(fontSize: 15, fontFamily: 'poppins-regular'),),
              ),
            ),
            const SizedBox(height: 20,),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(left: 20.0,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontFamily: 'poppins-regular',
                          fontSize: 15,
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
                        child: const Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                              padding: EdgeInsets.only(left: 5.0, right: 25.0, bottom: 5.0),
                              child:Text(
                                "Back to Sign in",
                                style: TextStyle(
                                  fontFamily: 'poppins-medium',
                                  fontSize: 13,
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

  _registrationApiCall(String name, String type, String number, String password,
      String date, String email, String nameOfPromoter) async {

        // Using the PasswordUtils to hash the password
  String hashedPassword = PasswordUtils.hashPassword(password);

    var data = json.encode({
      "typeOfOrganization": "Farmer groups",
      "nameOfFpo": name,
      "typeOfFpo": type,
      "dateOfFpo": "${AppGlobal.convertToIsoFormat(date)}Z",
      "organizationalEmail": email,
      "contactNumber": number,
      "promoterName": nameOfPromoter,
      "password": hashedPassword
    });

    var farmerRegistration = FarmerDashboardController.farmerGroupRegistration(data, context: context);

    if (farmerRegistration.toString().isNotEmpty) {
      Future.delayed(const Duration(seconds: 1), () {
        print('farmer registered successfully');

        showAlertDialog(context);
      });
    }
    else {
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

          Center(child: Image.asset('assets/images/check_green.png', width: 100, height: 100,)),

          const Text("You've been Successfully Registered!", softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "poppins-semibold", fontSize: 15.0, color: Colors.grey),),

          const SizedBox(height: 20,),

          const Text("Thank You", softWrap: true,
            style: TextStyle(fontFamily: "poppins-semibold", fontSize: 20.0, color: Colors.black),),

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