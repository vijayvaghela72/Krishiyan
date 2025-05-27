import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:krishiyan/helper/constant.dart';
import '../../../../helper/alert_helper.dart';
import '../../../../helper/shared_pref.dart';
import '../../../../localization/app_localizations.dart';
import '../../../../mvc/controller/farmer_dashboard_controller.dart';
import '../../../../mvc/model/farmer_registration_model.dart';
import '../../../../mvc/model/pincode_to_state_model.dart';
import '../../../../helper/app_global.dart';

// ignore: must_be_immutable
class FarmerProfilePage extends StatefulWidget {
  String? farmerName, farmerWhatsappNumber;

  FarmerProfilePage({super.key, this.farmerName, this.farmerWhatsappNumber});

  @override
  State<FarmerProfilePage> createState() => _FarmerProfilePageState();
}

class _FarmerProfilePageState extends State<FarmerProfilePage> {
  TextEditingController ownedAreaController = TextEditingController();
  TextEditingController goeLocationController = TextEditingController();
  TextEditingController leasedFarmController = TextEditingController();
  TextEditingController goeLocationLeasedController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController ifsCodeController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController aadharNumberController = TextEditingController();

  final List<String> items = [
    buildTranslate('organic')!,
    buildTranslate('inOrganic')!,
  ];

  String? selectedItemValue;

  String? _selectedStateName, _selectedDistrictName;
  List<DropdownMenuItem<String>>? dropdownStateItems;
  List<DropdownMenuItem<String>>? dropdownDistrictItems;

  PostOffice? selectedItem;
  late Future<List<PostOffice>> itemsFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              buildTranslate("farmerProfile")!,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'poppins-medium',
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
              height: 20,
            ),

            // owned farm
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("totalOwnedFarmArea")!,
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
                // initialValue: widget.totalOwnedFarm.toString() ?? "",
                decoration: InputDecoration(
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    hintText: buildTranslate('enterAreaInAcres'),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: ownedAreaController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // geo location
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("geoLocation(OwnedFarm)")!,
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
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    hintText: '----',
                    hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: goeLocationController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // total leased farm
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("totalLeasedFarmArea")!,
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
                decoration: InputDecoration(
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    hintText: buildTranslate('enterLeasedFarmArea'),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: leasedFarmController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // geo location
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("geoLocation(LeasedFarm)")!,
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
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: '----',
                    hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: goeLocationLeasedController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // pin code
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
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: '----',
                    hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: pincodeController,
                onChanged: _onTextChanged,
              ),
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
                    dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                    hint: const Text('Select a state'),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
                          dropdownStateItems!
                              .any((item) => item.value == newValue)) {
                        print("if newValue : $newValue");
                        setState(() {
                          _selectedStateName = newValue;
                        });
                        print("if _selectedStateName : $_selectedStateName");
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
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 25.0, right: 25.0),
            //   child: TextFormField(
            //     decoration: const InputDecoration(
            //         alignLabelWithHint: true,
            //         fillColor: Colors.white,
            //         filled: true,
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.all(
            //             Radius.circular(10.0),
            //           ),
            //         ),
            //         enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(
            //             color: Colors.white,
            //             width: 1.0,
            //           ),
            //           borderRadius: BorderRadius.all(
            //               Radius.circular(8.0)),
            //         ),
            //         contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            //         hintText: '----',
            //         hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
            //         focusedBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.all(
            //               Radius.circular(8.0)),
            //           borderSide: BorderSide(
            //               color: Colors.white, width: 0.5),
            //         )),
            //     validator: (value) => value!.isEmpty
            //         ? buildTranslate('enterState')
            //         : null,
            //     controller: stateController,
            //   ),
            // ),
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
                    dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                    hint: const Text('Select a district'),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
                          dropdownDistrictItems!
                              .any((item) => item.value == newValue)) {
                        print("if newValue : $newValue");
                        setState(() {
                          _selectedDistrictName = newValue;
                        });
                        print(
                            "if _selectedDistrictName : $_selectedDistrictName");
                      } else {
                        print("else _selectedDistrictName");
                        // Handle case where newValue is not in items
                      }
                      // setState(() {
                      //   _selectedStateName = newValue;
                      // });
                    },
                  )),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 25.0, right: 25.0),
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //         alignLabelWithHint: true,
            //         fillColor: Colors.white,
            //         filled: true,
            //         border: const OutlineInputBorder(
            //           borderRadius: BorderRadius.all(
            //             Radius.circular(10.0),
            //           ),
            //         ),
            //         enabledBorder: const OutlineInputBorder(
            //           borderSide: BorderSide(
            //             color: Colors.white,
            //             width: 1.0,
            //           ),
            //           borderRadius: BorderRadius.all(
            //               Radius.circular(8.0)),
            //         ),
            //         contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            //         hintText: buildTranslate("district")!,
            //         hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
            //         focusedBorder: const OutlineInputBorder(
            //           borderRadius: BorderRadius.all(
            //               Radius.circular(8.0)),
            //           borderSide: BorderSide(
            //               color: Colors.white, width: 0.5),
            //         )),
            //     validator: (value) => value!.isEmpty
            //         ? 'Enter District'
            //         : null,
            //     controller: districtController,
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),

            // village
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
                decoration: InputDecoration(
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate("village")!,
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? buildTranslate('enterVillage') : null,
                controller: villageController,
              ),
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
                decoration: InputDecoration(
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate("address")!,
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? buildTranslate('enterAddress') : null,
                controller: addressController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // cultivation practice
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("typeofCultivationPractice")!,
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                    // Add more decoration..
                  ),
                  hint: const Text(
                    '--',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: items
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
                      selectedItemValue = value.toString();
                    });
                    //Do something when selected item is changed.
                  },
                  onSaved: (value) {
                    selectedItemValue = value.toString();
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

            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const MyHomePage()),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: const Color(0xFF1D8D4C),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // <-- Radius
                    ),
                  ),
                  child: Text(
                    buildTranslate('editBankDetail')!,
                    style: const TextStyle(
                        fontSize: 18, fontFamily: 'poppins-medium'),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            // bank name
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("bankName")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('enterBankName')!,
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? buildTranslate('enterBankName')! : null,
                controller: bankNameController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // account name
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("accountName")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('enterAccountName')!,
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? buildTranslate('enterAccountName')! : null,
                controller: accountNameController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // account number
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("accountNumber")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('enterAccountNumber'),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? buildTranslate('enterAccountNumber')
                    : null,
                controller: accountNumberController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // ifs code
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("IFSCode")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('enterIFSCode')!,
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty ? 'Enter IFS Code' : null,
                controller: ifsCodeController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // pan number
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("panNumber")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('enterPanNumber'),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? buildTranslate('enterPanNumber') : null,
                controller: panNumberController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // dharma number
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("aadhaarNumber")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('enterAadhaarNumber')!,
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'Enter Aadhaar Code' : null,
                controller: aadharNumberController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // submit
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: ElevatedButton(
                  onPressed: () {
                    _farmerRegistrationApiCall();
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
                  child: Text(
                    buildTranslate('SUBMIT')!,
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
        ),
      ),
    );
  }

  _farmerRegistrationApiCall() async {
    if (ownedAreaController.text.trim().isNotEmpty &&
        pincodeController.text.trim().isNotEmpty &&
        villageController.text.trim().isNotEmpty &&
        selectedItemValue.toString().isNotEmpty) {
      String? number = await AppGlobal.getStringPreference('contactNumber');

      var body = json.encode({
        "dealerNumber": number ?? "1",
        "name": widget.farmerName,
        "whatsappNumber": widget.farmerWhatsappNumber,
        "totalOwnedFarm": int.parse(ownedAreaController.text.toString()),
        "geoLocationOwnedFarm": goeLocationController.text.toString(),
        "totalLeaseFarm": int.parse(leasedFarmController.text.toString()),
        "geoLocationLeaseFarm": goeLocationLeasedController.text.toString(),
        "pincode": pincodeController.text.toString(),
        "village": villageController.text.toString(),
        "district": _selectedDistrictName.toString(),
        "state": _selectedStateName.toString(),
        "address": addressController.text.toString(),
        "typeOfCultivationPractice": selectedItemValue.toString(),
        "bankName": bankNameController.text.toString(),
        "accountName": accountNameController.text.toString(),
        "accountNumber": accountNumberController.text.toString(),
        "ifscCode": ifsCodeController.text.toString(),
        "pan": panNumberController.text.toString(),
        "aadhaarNumber": aadharNumberController.text.toString()
      });

      FRMRegistrationData? user =
          await FarmerDashboardController.farmerRegistration(body,
              context: context);

      if (user != null) {
        Future.delayed(const Duration(seconds: 1), () {
          print('Farmer registered successfully');

          if (user.farmer != null) {
            SharedPref.savePreferenceValue(
                contactNo, user.farmer!.dealerNumber);
            SharedPref.savePreferenceValue(farmerName, user.farmer!.name);
          }
          showAlertDialog(context);
        });
      } else {
        AlertHelper.showToast("Api error", context);
        print("Api error");
      }
    } else {
      AlertHelper.showToast("Please enter details.", context);
    }
  }

  void _onTextChanged(String text) async {
    try {
      final response = await postAPICall(
        apiUrl: baseUrl + PincodeToState,
        parameter: json.encode({'pincode': text}),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        final data = json.decode(response.body);
        print('_onTextChanged API call successful: $data');

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

  Future<List<PostOffice>> fetchItems() async {
    final response = await postAPICall(
      apiUrl: baseUrl + PincodeToState,
      parameter: json.encode({'pincode': '360001'}),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      List<PostOffice> items =
          data.map((item) => PostOffice.fromJson(item)).toList();
      return items;
    } else {
      throw Exception('Failed to load items');
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
          Text(
            buildTranslate("SuccessfullyUpdate")!,
            softWrap: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: "poppins-semibold",
                fontSize: 15.0,
                color: Colors.grey),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            buildTranslate("thankYou")!,
            softWrap: true,
            style: const TextStyle(
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
}
