import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';
import 'package:krishiyan/screen/MyProfilePage.dart';

class MyEditProfilePage extends StatefulWidget {
  const MyEditProfilePage({super.key});

  @override
  State<MyEditProfilePage> createState() => _MyEditProfilePageState();
}

class _MyEditProfilePageState extends State<MyEditProfilePage> {

  TextEditingController? controller;
  TextEditingController? _userPasswordController;
  final List<String> fpoItems = [
    buildTranslate('farmerProducerOrganization')!,
    buildTranslate('farmerProducerCompany')!,
    buildTranslate('primaryAgriculturalCreditSociety')!,
    buildTranslate('farmerInterestedGroups')!,
    buildTranslate('co-operatives')!
  ];
  String? selectedFPOItemValue;
  bool otpVisible = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      backgroundColor: const Color(0xFFe7e7e7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Row(
          children: [
            InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset('assets/images/back.png')),
            const SizedBox(width: 10,),
            Text(
              buildTranslate("editProfile")!,
              style: const TextStyle(color: Colors.white, fontFamily: 'poppins-semibold', fontSize: 20),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30,),

            Center(
              child: SizedBox(
                height: 80,
                width: 80,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.asset("assets/images/user_profile.png", color: Colors.grey,),
                    ),
                    Positioned(
                        bottom: 35,
                        right: -45,
                        child: RawMaterialButton(
                          onPressed: () {},
                          elevation: 10.0,
                          // fillColor: const Color(0xFFF5F6F9),
                          padding: const EdgeInsets.all(25.0),
                          shape: const CircleBorder(),
                          child: const Icon(Icons.camera_alt, size: 30.0, color: Colors.grey,),
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10,),

            // fpo name
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("nameOfOrganization")!, style: const TextStyle(fontSize: 15,
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
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.all(Radius.circular(7.0),
                    //   ),
                    // ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                        // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('enterNameOfTheOrganization')!,
                    hintStyle: const TextStyle(color: Colors.grey),
                    focusedBorder: const OutlineInputBorder(
                      // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    )
                ),
                validator: (value) => value!.isEmpty ? 'Please, fill this field.' : null,
                controller: controller,
              ),
            ),

            const SizedBox(height: 20,),

            // type of fpo
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("typeOfOrganization")!, style: const
              TextStyle(fontSize: 15, color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Container(
                color: Colors.white,
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),),
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
                          fontSize: 14,
                          color: Colors.grey
                      ),
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

            const SizedBox(height: 20,),

            // date
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("dateOfOrganization")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _userPasswordController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: 'dd/mm/yyyy',
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20,),

            // registration number
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("registrationNumber")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _userPasswordController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: buildTranslate('registrationNumber')!,
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20,),

            // CBBOName
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("CBBOName")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _userPasswordController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: buildTranslate('CBBOName')!,
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20,),

            // contact number
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("officeContactNumberData")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _userPasswordController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: buildTranslate('officeContactNumberData')!,
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20,),

            // email id
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("emailId")!, style: const TextStyle(fontSize: 15,
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
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  hintText: buildTranslate('mailID')!,
                  hintStyle: const TextStyle(color: Colors.grey),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(70, 35),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 15),
                        backgroundColor: const Color(0xFF3FC041),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(buildTranslate("getOtp")!),
                      onPressed: () {
                       setState(() {
                         otpVisible = true;
                       });
                      },
                    ),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please, fill this field.' : null,
                controller: controller,
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
                showFieldAsBox: true,
                filled: true,
                fieldWidth: 55,
                onCodeChanged: (String code) {

                },
                onSubmit: (String verificationCode){

                }, // end onSubmit
              ),
            ),

            const SizedBox(height: 20,),

            // Name of Promoter or CEO
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("nameOfPromoterOrCEO")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _userPasswordController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: buildTranslate("nameOfPromoterOrCEO")!,
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(

                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20,),

            // Your Designation
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("yourDesignation")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _userPasswordController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: buildTranslate("yourDesignation")!,
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(

                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30,),

            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MyProfilePage()),
                    );
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
                  child: Text(buildTranslate('save')!, style: const TextStyle(fontSize: 15, fontFamily: 'poppins-medium'),),
                ),
              ),
            ),
            const SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }
}