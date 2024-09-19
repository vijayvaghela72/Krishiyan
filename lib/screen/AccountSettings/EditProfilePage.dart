import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';
import 'package:krishiyan/mvc/model/GetFRMProfileData.dart';
import 'package:krishiyan/screen/AccountSettings/ProfilePage.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import '../../helper/AlertHelper.dart';
import '../../mvc/controller/accountSettingController.dart';
import '../../mvc/model/GetProfileData.dart';
import '../../utils/AppGlobal.dart';
import '../../utils/Constants.dart';
import 'package:intl/intl.dart'; // Required for date formatting

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  TextFormField? nameOfOrganizationController;
  TextEditingController dateOfOrganizationController = TextEditingController();
  TextFormField? registrationNumberController;
  TextFormField? cbboNameController;
  TextFormField? officeContactNumberController;
  TextFormField? emailIdController;
  TextFormField? nameOfPromoterController;
  TextFormField? yourDesignationController;

  TextEditingController editNameOfOrganizationController = TextEditingController();
  TextEditingController editDateOfOrganizationController = TextEditingController();
  TextEditingController editRegistrationNumberController = TextEditingController();
  TextEditingController editCbboNameController = TextEditingController();
  TextEditingController editOfficeContactNumberController = TextEditingController();
  TextEditingController editEmailIdController = TextEditingController();
  TextEditingController editNameOfPromoterController = TextEditingController();
  TextEditingController editYourDesignationController = TextEditingController();

  String id = "", contactNumber = "", dateOfOrganizationValue = "", typeOfOrg = "";

  final List<String> fpoItems = [
    buildTranslate('farmerProducerOrganization')!,
    buildTranslate('farmerProducerCompany')!,
    buildTranslate('primaryAgriculturalCreditSociety')!,
    buildTranslate('farmerInterestedGroups')!,
    buildTranslate('co-operatives')!
  ];

  String? selectedFPOItemValue;
  bool otpVisible = false;

  Future<GetFRMProfileDetails?>? futureProfileDetails;

  String? nameOfOrganization;
  String? dateOfOrganization;
  String? registrationNumber;
  String? cbboName;
  String? officeContactNumber;
  String? emailId;
  String? nameOfPromoter;
  String? yourDesignation;
  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>();
  late OtpFieldController otpController = OtpFieldController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileDetails();
  }

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
            const SizedBox(
              width: 10,
            ),
            Text(
              buildTranslate("editProfile")!,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'poppins-semibold',
                  fontSize: 20),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
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
                      child: Image.asset(
                        "assets/images/user_profile.png",
                        color: Colors.grey,
                      ),
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
                          child: const Icon(
                            Icons.camera_alt,
                            size: 30.0,
                            color: Colors.grey,
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<GetFRMProfileDetails?>(
              future: futureProfileDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While the future is still loading
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  if (snapshot.data!.toString().isEmpty) {
                    // If the future returns data, but it's empty
                    return const Center(child: Text("No data found"));
                  } else {
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // fpo name
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
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
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              onSaved: (value) => nameOfOrganization = value,
                              initialValue: nameOfOrganizationController == null
                                  ? snapshot.data!.nameOfFpo.toString()
                                  : null,
                              decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  hintText: buildTranslate(
                                      'enterNameOfTheOrganization')!,
                                  hintStyle:
                                  const TextStyle(color: Colors.grey),
                                  focusedBorder: const OutlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 0.5),
                                  )),
                              validator: (value) => value!.isEmpty
                                  ? 'Please, fill this field.'
                                  : null,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // type of fpo
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
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
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Container(
                              color: Colors.white,
                              child: DropdownButtonFormField2<String>(
                                value: selectedFPOItemValue,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
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
                                        fontSize: 14,
                                        color: Colors.grey),
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
                                  setState(() {
                                    selectedFPOItemValue = value.toString();
                                  });
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

                          // date
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
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
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              controller: dateOfOrganizationController,
                              keyboardType: TextInputType.text,
                              onSaved: (value) => dateOfOrganization = value,
                              // initialValue:
                              // dateOfOrganizationController == null
                              //     ? AppGlobal.convertToCustomDateFormat(snapshot.data!.dateOfFpo.toString())
                              //     : null,
                              // initialValue: AppGlobal.convertToCustomDateFormat(snapshot.data!.dateOfFpo.toString()),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: 'DD/MM/YYYY',
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () {
                                    print("OnPressed : $dateOfOrganizationValue");
                                    _selectDate(context, dateOfOrganizationValue.toString());
                                  }, // Open date picker on icon press
                                ),
                                border: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // registration number
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("registrationNumber")!,
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
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => registrationNumber = value,
                              initialValue:
                              registrationNumberController == null
                                  ? snapshot.data!.registrationNumber.toString()
                                  : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate('registrationNumber')!,
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // CBBOName
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("CBBOName")!,
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
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => cbboName = value,
                              initialValue:
                              cbboNameController == null
                                  ? snapshot.data!.cBBOName.toString()
                                  : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate('CBBOName')!,
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // contact number
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("officeContactNumberData")!,
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
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => officeContactNumber = value,
                              initialValue:
                              officeContactNumberController == null
                                  ? snapshot.data!.contactNumber.toString()
                                  : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText:
                                buildTranslate('officeContactNumberData')!,
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // email id
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("emailId")!,
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
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              onSaved: (value) => emailId = value,
                              initialValue: emailIdController == null
                                  ? snapshot.data!.organizationalEmail
                                  .toString()
                                  : null,
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
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                hintText: buildTranslate('mailID')!,
                                hintStyle: const TextStyle(color: Colors.grey),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
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
                                        borderRadius:
                                        BorderRadius.circular(12.0),
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
                              validator: (value) => value!.isEmpty
                                  ? 'Please, fill this field.'
                                  : null,
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
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0),
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
                                    print("Completed: " + code);
                                  }),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // Name of Promoter or CEO
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("nameOfPromoterOrCEO")!,
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
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => nameOfPromoter = value,
                              initialValue: nameOfPromoter == null
                                  ? snapshot.data!.promoterName.toString()
                                  : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText:
                                buildTranslate("nameOfPromoterOrCEO")!,
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // Your Designation
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("yourDesignation")!,
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
                            padding:
                            const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => yourDesignation = value,
                              initialValue: yourDesignationController == null
                                  ? snapshot.data!.yourDesignation.toString()
                                  : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate("yourDesignation")!,
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),

                          Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _getValue();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(12),
                                  textStyle: const TextStyle(fontSize: 18),
                                  backgroundColor: const Color(0xFF3FC041),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                                  ),
                                ),
                                child: Text(
                                  buildTranslate('save')!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'poppins-medium'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  // If the future returns an error
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // fpo name
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
                          onSaved: (value) => nameOfOrganization = value,
                          controller: editNameOfOrganizationController,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              hintText:
                              buildTranslate('enterNameOfTheOrganization')!,
                              hintStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: const OutlineInputBorder(
                                // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                              )),
                          validator: (value) => value!.isEmpty
                              ? 'Please, fill this field.'
                              : null,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // type of fpo
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
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
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
                             setState(() {
                               selectedFPOItemValue = value.toString();
                             });
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

                      // date
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
                          onSaved: (value) => dateOfOrganization = value,
                          controller: editDateOfOrganizationController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: 'DD/MM/YYYY',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () {
                                _selectDate(context, dateOfOrganization ?? "");
                              }, // Open date picker on icon press
                            ),
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.green, width: 0.5),
                            ),
                          ),
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // registration number
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("registrationNumber")!,
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
                          onSaved: (value) => registrationNumber = value,
                          controller: editRegistrationNumberController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate('registrationNumber')!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(color: Colors.green, width: 0.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // CBBOName
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("CBBOName")!,
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
                          onSaved: (value) => cbboName = value,
                          controller: editCbboNameController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate('CBBOName')!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(color: Colors.green, width: 0.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // contact number
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("officeContactNumberData")!,
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
                          onSaved: (value) => officeContactNumber = value,
                          controller: editOfficeContactNumberController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText:
                            buildTranslate('officeContactNumberData')!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(color: Colors.green, width: 0.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // email id
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("emailId")!,
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
                          onSaved: (value) => emailId = value,
                          controller: editEmailIdController,
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
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: buildTranslate('mailID')!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(color: Colors.green, width: 0.5),
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
                          validator: (value) => value!.isEmpty
                              ? 'Please, fill this field.'
                              : null,
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
                          padding:
                          const EdgeInsets.only(left: 25.0, right: 25.0),
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
                                print("Completed: " + code);
                              }),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // Name of Promoter or CEO
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("nameOfPromoterOrCEO")!,
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
                          onSaved: (value) => nameOfPromoter = value,
                          controller: editNameOfPromoterController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate("nameOfPromoterOrCEO")!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(color: Colors.green, width: 0.5),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // Your Designation
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("yourDesignation")!,
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
                          onSaved: (value) => yourDesignation = value,
                          controller: editYourDesignationController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate("yourDesignation")!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.green, width: 0.5),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (editNameOfOrganizationController.text.toString().isNotEmpty &&
                                  selectedFPOItemValue.toString().isNotEmpty &&
                                  editDateOfOrganizationController.text.toString().isNotEmpty &&
                                  editRegistrationNumberController.text.toString().isNotEmpty &&
                                  editOfficeContactNumberController.text.toString().isNotEmpty &&
                                  editEmailIdController.text.toString().isNotEmpty &&
                                  editNameOfPromoterController.text.toString().isNotEmpty &&
                                  editCbboNameController.text.toString().isNotEmpty &&
                                  editYourDesignationController.text.toString().isNotEmpty) {

                                _updateProfileDetailsApiCall(
                                  editNameOfOrganizationController.text.toString(),
                                  selectedFPOItemValue.toString(),
                                  editDateOfOrganizationController.text.toString(),
                                  editRegistrationNumberController.text.toString(),
                                  editOfficeContactNumberController.text.toString(),
                                  editEmailIdController.text.toString(),
                                  editNameOfPromoterController.text.toString(),
                                    editCbboNameController.text.toString(),
                                    editYourDesignationController.text.toString()
                                );
                              }
                              else {
                                AlertHelper.showToast(
                                    "Please enter details.", context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(12),
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor: const Color(0xFF3FC041),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: Text(
                              buildTranslate('save')!,
                              style: const TextStyle(
                                  fontSize: 15, fontFamily: 'poppins-medium'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String date) async {
    // Show the date picker dialog
    if(date.isNotEmpty) {
      selectedDate = DateTime.parse(date).toLocal();
      print("selectedDate : $selectedDate");
    }
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate !=null ? selectedDate : DateTime.now(), // Default date is the current date
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime.now(),  // Latest selectable date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      print("pickedDate : $pickedDate");
      setState(() {
        // Format the selected date and display it in the TextFormField
        dateOfOrganizationController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        dateOfOrganizationValue = "${pickedDate}Z";
      });
    }
  }

  void _getValue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // This triggers onSaved for each TextFormField

      if (nameOfOrganization != null &&
          selectedFPOItemValue != null &&
          dateOfOrganization != null &&
          registrationNumber != null &&
          officeContactNumber != null &&
          emailId != null &&
          nameOfPromoter != null && cbboName !=null && yourDesignation !=null) {

        _updateProfileDetailsApiCall(
            nameOfOrganization.toString(),
            selectedFPOItemValue.toString(),
            dateOfOrganization.toString(),
            registrationNumber.toString(),
            officeContactNumber.toString(),
            emailId.toString(),
            nameOfPromoter.toString(), cbboName.toString(), yourDesignation.toString());
      }
      else {
        AlertHelper.showToast("Please enter data.", context);
      }
    }
  }

  _updateProfileDetailsApiCall(
      String nameOfOrganization,
      String typeOfOrganization,
      String dateOrganization,
      String registrationNumber,
      String officeNumber,
      String emailID,
      String promoterName, String cbboName, String designation) async {

    if (nameOfOrganization.isNotEmpty &&
        typeOfOrganization.isNotEmpty &&
        dateOfOrganization.toString().isNotEmpty &&
        registrationNumber.isNotEmpty &&
        officeNumber.isNotEmpty &&
        emailID.isNotEmpty &&
        promoterName.isNotEmpty && cbboName.isNotEmpty && designation.isNotEmpty) {

      var headers = {'Content-Type': 'application/json'};

      var data = json.encode({
      "nameOfFpo": nameOfOrganization,
      "typeOfFpo": typeOfOrganization,
      "dateOfFpo": dateOfOrganization,
      "organizationalEmail": emailID,
      "contactNumber": officeNumber,
      "yourDesignation": designation,
      "promoterName": promoterName,
      "RegistrationNumber": registrationNumber,
      "CBBOName": cbboName
      });

      var dio = Dio();
      var response = await dio.request(
        FRM_UPDATE_PROFILE_DETAILS+contactNumber,
        options: Options(
          method: 'PUT',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print("Profile details updated : " + json.encode(response.data));

        showAlertDialog(context);
      } else {
        print(response.statusMessage);
      }
    } else {
      AlertHelper.showToast("Please enter details.", context);
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
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
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
          const Text(
            "You've Details Updated Successfully!",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "poppins-semibold",
                fontSize: 15.0,
                color: Colors.grey),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Thank You",
            softWrap: true,
            style: TextStyle(
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

  Future<void> getProfileDetails() async {
    // id = (await AppGlobal.getStringPreference('id'))!;
    contactNumber = (await AppGlobal.getStringPreference('contactNumber'))!;
    print("contactNumber : $contactNumber");
    futureProfileDetails = AccountSettingController.fetchFRMEditProfileDetails(context, contactNumber);
    setState(() {
      futureProfileDetails = futureProfileDetails;
    });
    Future.delayed(Duration(seconds: 2), () async {
      dateOfOrganizationValue = (await AppGlobal.getStringPreference('dateOfOrganization'))!;
      typeOfOrg = (await AppGlobal.getStringPreference('typeOfOrg'))!;
      setState(() {
      dateOfOrganizationValue = dateOfOrganizationValue;
      selectedFPOItemValue = typeOfOrg;
      });
      dateOfOrganizationController.text = AppGlobal.convertToCustomDateFormat(dateOfOrganizationValue);
    });
  }
}
