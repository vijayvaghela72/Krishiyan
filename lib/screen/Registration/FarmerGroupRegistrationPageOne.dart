import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';
import 'package:krishiyan/screen/Registration/MyRegistrationPage.dart';
import 'package:intl/intl.dart';
import '../../helper/AlertHelper.dart';
import 'FarmerGroupRegistrationPageTwo.dart';

class FarmerGroupRegistrationPageOne extends StatefulWidget {
  const FarmerGroupRegistrationPageOne({super.key});

  @override
  State<FarmerGroupRegistrationPageOne> createState() => _FarmerGroupRegistrationPageOneState();
}

class _FarmerGroupRegistrationPageOneState extends State<FarmerGroupRegistrationPageOne> {

  TextEditingController nameOfOrganizationController = TextEditingController();
  TextEditingController dateOfOrganizationController = TextEditingController();
  TextEditingController organizationMailIDController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController nameOfPromoterController = TextEditingController();

  bool otpVisible = false;

  final List<String> fpoItems = [
    'Farmer Producer Organization',
    'Farmer Producer Company',
    'Primary Agricultural credit society',
    'Farmer Interested groups',
    'Co-operatives'
  ];
  String selectedFPOItemValue = "";

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
              style: TextStyle(color: Color(0xFF3dc33b), fontSize: 22.0,
                  fontFamily: 'poppins-medium'),)),
            const SizedBox(height: 30,),

            // name
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("nameOfOrganization")!,
                style: const TextStyle(fontSize: 15,
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
                    hintText: buildTranslate("enterOrganization"),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    )
                ),
                validator: (value) => value!.isEmpty ? 'Please, fill this field.' : null,
                controller: nameOfOrganizationController,
              ),
            ),

            const SizedBox(height: 20,),

            // type of Organization
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("typeOfOrganization")!,
                style: const TextStyle(fontSize: 15,
                    color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
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

            const SizedBox(height: 20,),

            // date of Organization
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("dateOfOrganization")!, style:
              const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
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
                ),
              ),
            ),

            const SizedBox(height: 20,),

            // organization mail id
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("organizationMailID")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
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
                ),
              ),
            ),

            const SizedBox(height: 20,),

            // mobile number
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("officeContactNumber")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
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
                    borderRadius: BorderRadius.all(Radius.circular(10.0),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
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
                controller: contactNumberController,
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
                onCodeChanged: (String code) {
                },
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

            const SizedBox(height: 25,),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  if(nameOfOrganizationController.text.trim().isNotEmpty &&
                      selectedFPOItemValue.trim().isNotEmpty
                      && contactNumberController.text.trim().isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          FarmerGroupRegistrationPageTwo(
                            name: nameOfOrganizationController.text,
                            type: selectedFPOItemValue,
                            date: dateOfOrganizationController.text,
                            email: organizationMailIDController.text,
                            contactNumber: contactNumberController.text,
                          )),
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
                child:  Text(buildTranslate("next")!, style: const
                TextStyle(fontSize: 15, fontFamily: 'poppins-regular'),),
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
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 25.0, bottom: 5.0),
                              child:Text(
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

  Future<void> _selectDate(BuildContext context) async {
    // Show the date picker dialog
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default date is the current date
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime.now(),  // Restrict to past and current date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      setState(() {
        // Format the selected date and display it in the TextFormField
        dateOfOrganizationController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

}