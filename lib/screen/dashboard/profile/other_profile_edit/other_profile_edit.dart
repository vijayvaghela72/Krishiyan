import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';
import 'package:krishiyan/screen/dashboard/profile/profile.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../helper/AlertHelper.dart';
import '../../../../mvc/controller/accountSettingController.dart';
import '../../../../mvc/model/GetProfileData.dart';
import '../../../../utils/AppGlobal.dart';
import '../../../../widgets/constant.dart';
import 'package:intl/intl.dart';

class EditOtherProfilePage extends StatefulWidget {
  const EditOtherProfilePage({super.key});

  @override
  State<EditOtherProfilePage> createState() => _EditOtherProfilePageState();
}

class _EditOtherProfilePageState extends State<EditOtherProfilePage> {
  TextFormField? nameOfEntityController;
  TextEditingController dateOfIncorporationController = TextEditingController();
  TextFormField? incorporationNumberController;
  TextFormField? businessLocationController;
  TextFormField? primaryContactPersonNameController;
  TextFormField? primaryContactPersonDesignationController;
  TextFormField? officeContactNumberController;
  TextFormField? emailIdController;
  late OtpFieldController otpController = OtpFieldController();

  TextEditingController editNameOfEntityController = TextEditingController();
  TextEditingController editDateOfIncorporationController =
      TextEditingController();
  TextEditingController editIncorporationNumberController =
      TextEditingController();
  TextEditingController editBusinessLocationController =
      TextEditingController();
  TextEditingController editPrimaryContactPersonNameController =
      TextEditingController();
  TextEditingController editPrimaryContactPersonDesignationController =
      TextEditingController();
  TextEditingController editOfficeContactNumberController =
      TextEditingController();
  TextEditingController editEmailIdController = TextEditingController();

  String id = "",
      contactNumber = "",
      dateOfIncorporationNumberValue = "",
      typeOfOrg = "";

  bool otpVisibleContactNumber = false;
  bool otpVisibleEmailID = false;

  Future<GetProfileDetails?>? futureProfileDetails;

  String? nameOfEntity;
  String? dateOfIncorporation;
  String? incorporationNumber;
  String? businessLocationName;
  String? primaryContactPersonName;
  String? primaryContactPersonDesignation;
  String? officeContactNumber;
  String? emailId;
  DateTime? selectedDate;

  final _formKey = GlobalKey<FormState>();
  final List<String> traderItems = [
    'Trader',
    'Retailer',
    'Exporter',
    'Importer',
    'Wholesaler'
  ];
  List<String> selectedTraderItems = [];
  // List<String> selectedTraderItemsValue = [];

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
            FutureBuilder<GetProfileDetails?>(
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
                          // name of entity
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("nameofEntity")!,
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
                              onSaved: (value) => nameOfEntity = value,
                              initialValue: nameOfEntityController == null
                                  ? snapshot.data!.nameOfEntity.toString()
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

                          // type
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
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
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: DropdownButtonFormField2<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 8),
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
                                style:
                                    const TextStyle(color: Color(0xFFe7e7e7)),
                              ),
                              items: traderItems.map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  //disable default onTap to avoid closing menu when selecting an item
                                  enabled: false,
                                  child: StatefulBuilder(
                                    builder: (context, menuSetState) {
                                      final isSelected =
                                          selectedTraderItems.contains(item);
                                      return InkWell(
                                        onTap: () {
                                          isSelected
                                              ? selectedTraderItems.remove(item)
                                              : selectedTraderItems.add(item);
                                          setState(() {});
                                          menuSetState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          height: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (isSelected)
                                                const Icon(
                                                    Icons.check_box_outlined)
                                              else
                                                const Icon(Icons
                                                    .check_box_outline_blank),
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
                              value: selectedTraderItems.isEmpty
                                  ? null
                                  : selectedTraderItems.last,
                              onChanged: (value) {},
                              selectedItemBuilder: (context) {
                                return traderItems.map(
                                  (item) {
                                    return Container(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(
                                        selectedTraderItems.join(', '),
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

                          // incorporationDate
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("incorporationDate")!,
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
                              child: TextFormField(
                                controller: dateOfIncorporationController,
                                keyboardType: TextInputType.text,
                                onSaved: (value) => dateOfIncorporation = value,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  hintText: 'DD/MM/YYYY',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  fillColor: Colors.white,
                                  filled: true,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () {
                                      print(
                                          "OnPressed : $dateOfIncorporationNumberValue");
                                      _selectDate(
                                          context,
                                          dateOfIncorporationNumberValue
                                              .toString());
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
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // incorporation number
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("incorporationNumber")!,
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
                              onSaved: (value) => incorporationNumber = value,
                              initialValue:
                                  incorporationNumberController == null
                                      ? snapshot.data!.incorporationNumber
                                          .toString()
                                      : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText:
                                    buildTranslate("incorporationNumber")!,
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

                          // businessLocation
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("businessLocation")!,
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
                              onSaved: (value) => businessLocationName = value,
                              initialValue: businessLocationController == null
                                  ? snapshot.data!.businessLocation.toString()
                                  : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate("businessLocation")!,
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

                          // Primary Contact Person Name
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("primaryContactPersonName")!,
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
                              onSaved: (value) =>
                                  primaryContactPersonName = value,
                              initialValue:
                                  primaryContactPersonNameController == null
                                      ? snapshot.data!.contactNumber.toString()
                                      : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText:
                                    buildTranslate("primaryContactPersonName")!,
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

                          // Primary Contact Person Designation
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate(
                                  "primaryContactPersonDesignation")!,
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
                              onSaved: (value) =>
                                  primaryContactPersonDesignation = value,
                              initialValue:
                                  primaryContactPersonDesignationController ==
                                          null
                                      ? snapshot.data!.yourDesignation
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
                                hintText: "Primary Contact Person Designation",
                                hintStyle: const TextStyle(color: Colors.grey),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? 'Please, fill this field.'
                                  : null,
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
                                        otpVisibleContactNumber = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          otpVisibleContactNumber
                              ? const SizedBox(
                                  height: 15,
                                )
                              : Container(),

                          // verify otp
                          Visibility(
                            visible: otpVisibleContactNumber,
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
                          otpVisibleContactNumber
                              ? const SizedBox(
                                  height: 15,
                                )
                              : Container(),
                          Visibility(
                            visible: otpVisibleContactNumber,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: OTPTextField(
                                  controller: otpController,
                                  length: 4,
                                  // borderColor: const Color(0xFF3dc33b),
                                  // showFieldAsBox: true,
                                  // filled: true,
                                  width: MediaQuery.of(context).size.width,
                                  textFieldAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                  ? snapshot.data!.email.toString()
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
                                        otpVisibleEmailID = true;
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

                          otpVisibleEmailID
                              ? const SizedBox(
                                  height: 15,
                                )
                              : Container(),

                          // verify otp
                          Visibility(
                            visible: otpVisibleEmailID,
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
                          otpVisibleEmailID
                              ? const SizedBox(
                                  height: 15,
                                )
                              : Container(),
                          Visibility(
                            visible: otpVisibleEmailID,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: OTPTextField(
                                  controller: otpController,
                                  length: 4,
                                  // borderColor: const Color(0xFF3dc33b),
                                  // showFieldAsBox: true,
                                  // filled: true,
                                  width: MediaQuery.of(context).size.width,
                                  textFieldAlignment:
                                      MainAxisAlignment.spaceAround,
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
                      // name of entity
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("nameofEntity")!,
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
                          onSaved: (value) => nameOfEntity = value,
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
                          controller: editNameOfEntityController,
                          validator: (value) => value!.isEmpty
                              ? 'Please, fill this field.'
                              : null,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // type
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
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
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
                          items: traderItems.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              //disable default onTap to avoid closing menu when selecting an item
                              enabled: false,
                              child: StatefulBuilder(
                                builder: (context, menuSetState) {
                                  final isSelected =
                                      selectedTraderItems.contains(item);
                                  return InkWell(
                                    onTap: () {
                                      isSelected
                                          ? selectedTraderItems.remove(item)
                                          : selectedTraderItems.add(item);
                                      //This rebuilds the StatefulWidget to update the button's text
                                      setState(() {});
                                      //This rebuilds the dropdownMenu Widget to update the check mark
                                      menuSetState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      height: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (isSelected)
                                            const Icon(Icons.check_box_outlined)
                                          else
                                            const Icon(
                                                Icons.check_box_outline_blank),
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
                          value: selectedTraderItems.isEmpty
                              ? null
                              : selectedTraderItems.last,
                          onChanged: (value) {},
                          selectedItemBuilder: (context) {
                            return traderItems.map(
                              (item) {
                                return Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    selectedTraderItems.join(', '),
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

                      // incorporationDate
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("incorporationDate")!,
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
                          child: TextFormField(
                            controller: editDateOfIncorporationController,
                            keyboardType: TextInputType.text,
                            onSaved: (value) => dateOfIncorporation = value,
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
                                  print(
                                      "OnPressed : $dateOfIncorporationNumberValue");
                                  _selectDate(
                                      context,
                                      dateOfIncorporationNumberValue
                                          .toString());
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
                                borderSide:
                                    BorderSide(color: Colors.green, width: 0.5),
                              ),
                            ),
                            readOnly: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // incorporation number
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("incorporationNumber")!,
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
                          controller: editIncorporationNumberController,
                          onSaved: (value) => incorporationNumber = value,
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

                      // businessLocation
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("businessLocation")!,
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
                          onSaved: (value) => businessLocationName = value,
                          controller: editBusinessLocationController,
                          // initialValue:
                          // businessLocationController == null
                          //     ? snapshot.data!.cBBOName.toString()
                          //     : null,
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

                      // Primary Contact Person Name
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("primaryContactPersonName")!,
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
                          controller: editPrimaryContactPersonNameController,
                          onSaved: (value) => primaryContactPersonName = value,
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

                      // Primary Contact Person Designation
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("primaryContactPersonDesignation")!,
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
                          onSaved: (value) =>
                              primaryContactPersonDesignation = value,
                          controller:
                              editPrimaryContactPersonDesignationController,
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
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please, fill this field.'
                              : null,
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
                                    otpVisibleContactNumber = true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      otpVisibleContactNumber
                          ? const SizedBox(
                              height: 15,
                            )
                          : Container(),

                      // verify otp
                      Visibility(
                        visible: otpVisibleContactNumber,
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
                      otpVisibleContactNumber
                          ? const SizedBox(
                              height: 15,
                            )
                          : Container(),
                      Visibility(
                        visible: otpVisibleContactNumber,
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
                                    otpVisibleEmailID = true;
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

                      otpVisibleEmailID
                          ? const SizedBox(
                              height: 15,
                            )
                          : Container(),

                      // verify otp
                      Visibility(
                        visible: otpVisibleEmailID,
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
                      otpVisibleEmailID
                          ? const SizedBox(
                              height: 15,
                            )
                          : Container(),
                      Visibility(
                        visible: otpVisibleEmailID,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
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
                        height: 30,
                      ),

                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                              const EdgeInsets.only(left: 25.0, right: 25.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _updateProfileDetailsApiCall(
                                  editNameOfEntityController.text.toString(),
                                  selectedTraderItems.toString(),
                                  editDateOfIncorporationController.toString(),
                                  editIncorporationNumberController.toString(),
                                  editBusinessLocationController.text
                                      .toString(),
                                  editPrimaryContactPersonNameController.text
                                      .toString(),
                                  editPrimaryContactPersonDesignationController
                                      .text
                                      .toString(),
                                  editOfficeContactNumberController.text
                                      .toString(),
                                  editEmailIdController.text.toString());
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
    if (date.isNotEmpty) {
      selectedDate = DateTime.parse(date).toLocal();
      print("selectedDate : $selectedDate");
    }
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate != null ? selectedDate : DateTime.now(),
      // Default date is the current date
      firstDate: DateTime(2000),
      // Earliest selectable date
      lastDate: DateTime.now(),
      // Latest selectable date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      print("pickedDate : $pickedDate");
      setState(() {
        // Format the selected date and display it in the TextFormField
        dateOfIncorporationController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
        dateOfIncorporationNumberValue = "${pickedDate}Z";
      });
    }
  }

  void _getValue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!
          .save(); // This triggers onSaved for each TextFormField

      if (nameOfEntity != null &&
          selectedTraderItems.isNotEmpty &&
          dateOfIncorporationController.text.isNotEmpty &&
          incorporationNumber != null &&
          businessLocationName != null &&
          primaryContactPersonName != null &&
          primaryContactPersonDesignation != null &&
          officeContactNumber != null &&
          emailId != null) {
        _updateProfileDetailsApiCall(
            nameOfEntity.toString(),
            selectedTraderItems.toString(),
            dateOfIncorporationController.text.toString(),
            incorporationNumber.toString(),
            businessLocationName.toString(),
            primaryContactPersonName.toString(),
            primaryContactPersonDesignation.toString(),
            officeContactNumber.toString(),
            emailId.toString());
      } else {
        print("nameOfEntity : $nameOfEntity");
        print("selectedTraderItems : $selectedTraderItems");
        print("selectedDate : $selectedDate");
        print("incorporationNumber : $incorporationNumber");
        print("businessLocationName : $businessLocationName");
        print("primaryContactPersonName : $primaryContactPersonName");
        print(
            "primaryContactPersonDesignation : $primaryContactPersonDesignation");
        print("officeContactNumber : $officeContactNumber");
        print("emailId : $emailId");

        AlertHelper.showToast("Please enter details.", context);
      }
    }
  }

  _updateProfileDetailsApiCall(
      String nameOfEntity,
      String typeOfTraders,
      String dateTrader,
      String incorporationNumber,
      String businessLocationName,
      String primaryContactPersonName,
      String primaryContactPersonDesignation,
      String officeContactNumber,
      String emailId) async {
    if (selectedTraderItems.isNotEmpty &&
        dateOfIncorporationController.text.isNotEmpty) {
      var body = json.encode({
        "nameOfEntity": nameOfEntity,
        "typeOfEntity": typeOfTraders,
        "Email": emailId,
        "incorporationDate": dateTrader,
        "incorporationNumber": incorporationNumber,
        "businessLocation": businessLocationName,
        "contactPersonName": primaryContactPersonName,
        "yourDesignation": primaryContactPersonDesignation,
        "contactNumber": officeContactNumber,
        "URL": ""
      });

      var response = await putAPICall(
        apiUrl: UPDATE_PROFILE_DETAILS + contactNumber,
        parameter: body,
      );

      if (response.statusCode == 200) {
        print("Profile details updated : " + response.body);
        showAlertDialog(context);
      } else {
        print(response.reasonPhrase);
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
                MaterialPageRoute(builder: (context) => const Profile()),
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
    // contactNumber = (await AppGlobal.getStringPreference('contactNumber')) ?? "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    contactNumber = await prefs.getString(contactNo) ?? '1';
    futureProfileDetails = AccountSettingController.fetchEditProfileDetails(
        context, contactNumber);
    setState(() {
      futureProfileDetails = futureProfileDetails;
    });
    Future.delayed(Duration(seconds: 1), () async {
      dateOfIncorporationNumberValue =
          (await AppGlobal.getStringPreference('dateOfIncorporation')) ?? "";
      typeOfOrg = (await AppGlobal.getStringPreference('typeOfEntity')) ?? "";
      // Convert string to List<String> by splitting with a comma
      // List<String> listOfEntity = typeOfOrg.split(',');
      setState(() {
        dateOfIncorporationNumberValue = dateOfIncorporationNumberValue;
        // selectedTraderItemsValue = listOfEntity;
      });
      dateOfIncorporationController.text =
          AppGlobal.convertToCustomDateFormat(dateOfIncorporationNumberValue);
    });
  }
}
