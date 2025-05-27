import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:krishiyan/helper/constant.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import '../../../../helper/alert_helper.dart';
import '../../../../mvc/controller/account_setting_controller.dart';
import '../../../../mvc/model/get_address_details_model.dart';
import '../../../../helper/app_global.dart';
import '../profile.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({super.key});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  TextFormField? pincodeController;
  TextFormField? districtController;
  TextFormField? stateController;
  TextFormField? addressController;
  TextFormField? villageController;

  TextEditingController editPincodeController = TextEditingController();
  TextEditingController editAddressController = TextEditingController();
  TextEditingController editVillageController = TextEditingController();

  Future<Address?>? futureAddressDetails;
  String number = "";

  String? pincode;
  String? district;
  String? state;
  String? address;
  String? village;

  final _formKey = GlobalKey<FormState>();

  String? _selectedStateName, _selectedDistrictName;
  List<DropdownMenuItem<String>>? dropdownStateItems;
  List<DropdownMenuItem<String>>? dropdownDistrictItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddressDetails();
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
              buildTranslate("editAddress")!,
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
            FutureBuilder<Address?>(
              future: futureAddressDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  if (snapshot.data!.toString().isEmpty) {
                    return const Center(child: Text("No data found"));
                  } else {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // pincode
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("pinCode")!,
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
                              onSaved: (value) => pincode = value,
                              decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  hintText: buildTranslate('enterPincode')!,
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
                              initialValue: snapshot.data!.pincode.toString(),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // district
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("district")!,
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
                              onSaved: (value) => district = value,
                              keyboardType: TextInputType.text,
                              initialValue: snapshot.data!.district.toString(),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate('enterDistrict')!,
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
                            height: 20,
                          ),
                          // state
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("state")!,
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
                              onSaved: (value) => state = value,
                              initialValue: snapshot.data!.state!.toString(),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate('enterState')!,
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
                            height: 20,
                          ),

                          // address
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("address")!,
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
                              onSaved: (value) => address = value,
                              initialValue: snapshot.data!.address.toString(),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate('enterStreet')!,
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

                          // Village
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("village")!,
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
                              onSaved: (value) => village = value,
                              initialValue: snapshot.data!.village.toString(),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate('enterVillage')!,
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
                            height: 35,
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
                        ],
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  // If the future returns an error
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // pincode
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("pinCode")!,
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
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              hintText: '----',
                              hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.5),
                              )),
                          validator: (value) => value!.isEmpty
                              ? 'Please, fill this field.'
                              : null,
                          controller: editPincodeController,
                          onChanged: _onTextChanged,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // district
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("district")!,
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
                              dropdownStyleData:
                                  const DropdownStyleData(maxHeight: 200),
                              hint: const Text('Select a district'),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                // Add more decoration..
                              ),
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
                              value: _selectedDistrictName,
                              items: dropdownDistrictItems,
                              onChanged: (newValue) {
                                if (newValue != null &&
                                    dropdownDistrictItems!.any(
                                        (item) => item.value == newValue)) {
                                  print("if newValue : $newValue");
                                  setState(() {
                                    _selectedDistrictName = newValue;
                                  });
                                  print(
                                      "if _selectedDistrictName : $_selectedDistrictName");
                                } else {
                                  print("else");
                                  // Handle case where newValue is not in items
                                }
                              },
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // state
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("state")!,
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
                              dropdownStyleData:
                                  const DropdownStyleData(maxHeight: 200),
                              hint: const Text('Select a state'),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                // Add more decoration..
                              ),
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
                              value: _selectedStateName,
                              items: dropdownStateItems,
                              onChanged: (newValue) {
                                if (newValue != null &&
                                    dropdownStateItems!.any(
                                        (item) => item.value == newValue)) {
                                  print("if newValue : $newValue");
                                  setState(() {
                                    _selectedStateName = newValue;
                                  });
                                  print(
                                      "if _selectedStateName : $_selectedStateName");
                                } else {
                                  print("else");
                                  // Handle case where newValue is not in items
                                }
                                // setState(() {
                                //   _selectedStateName = newValue;
                                // });
                              },
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // address
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("address")!,
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
                          controller: editAddressController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate('enterStreet')!,
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

                      // Village
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("village")!,
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
                          controller: editVillageController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate('enterVillage')!,
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
                        height: 35,
                      ),

                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                              const EdgeInsets.only(left: 25.0, right: 25.0),
                          child: ElevatedButton(
                            onPressed: () {
                              otherEditAddressApiCall(
                                  editPincodeController.text.toString(),
                                  _selectedDistrictName.toString(),
                                  _selectedStateName.toString(),
                                  editAddressController.text.toString(),
                                  editVillageController.text.toString());
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

  void _getValue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!
          .save(); // This triggers onSaved for each TextFormField
      print("pincode : $pincode");

      if (pincode != null && village != null) {
        // Proceed with the API call only if pincode and village are not null
        otherEditAddressApiCall(
          pincode.toString(),
          district?.toString() ?? '', // Allow district to be empty
          state?.toString() ?? '', // Allow state to be empty
          address?.toString() ?? '', // Allow address to be empty
          village.toString(),
        );
      } else {
        AlertHelper.showToast("Please enter pincode and village.", context);
      }
    }
  }

  otherEditAddressApiCall(String pincode, String district, String state,
      String address, String village) async {
    if (pincode.isNotEmpty && village.isNotEmpty) {
      var data = json.encode({
        "uid": number,
        "pincode": pincode,
        "district": district,
        "state": state,
        "address": address,
        "village": village
      });
      print('data : $data');
      print('link : ${UPDATE_ADDRESS_DETAILS}');

      var response = await postAPICall(
        apiUrl: UPDATE_ADDRESS_DETAILS,
        parameter: data,
      );
      if (response.statusCode == 201) {
        showAlertDialog(context);
      } else {
        var data = jsonDecode(response.body);
        AlertHelper.showToast(
            "Fail to update profile : Error ${data['message']}", context);
      }
    } else {
      AlertHelper.showToast("Please enter pincode and village.", context);
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

  Future<void> getAddressDetails() async {
    number = (await AppGlobal.getStringPreference('contactNumber'))!;
    futureAddressDetails =
        AccountSettingController.fetchAddressDetails(context, number);
    setState(() {
      futureAddressDetails = futureAddressDetails;
    });
  }

  void _onTextChanged(String text) async {
    try {
      final response = await postAPICall(
        apiUrl: baseUrl + PincodeToState,
        parameter: json.encode({'pincode': text}),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('_onTextChanged API call successful: ${response.body}');

        final data = json.decode(response.body);

        if (data['PostOffice'].isNotEmpty) {
          dropdownStateItems = [
            DropdownMenuItem<String>(
              value: data['PostOffice'][0]['State'],
              child: Text(data['PostOffice'][0]['State']),
            ),
          ];

          dropdownDistrictItems = [
            DropdownMenuItem<String>(
              value: data['PostOffice'][0]['District'],
              child: Text(data['PostOffice'][0]['District']),
            ),
          ];
        }

        setState(() {
          dropdownStateItems = dropdownStateItems;
          dropdownDistrictItems = dropdownDistrictItems;
        });
      } else {
        // Handle non-200 status codes
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      print('API call failed: $e');
    }
  }
}
