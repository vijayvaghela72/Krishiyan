import 'dart:convert';
import '../../../../helper/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../helper/alert_helper.dart';
import '../../../../mvc/model/PincodeToStateData.dart';
import '../../../../localization/app_localizations.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// ignore: must_be_immutable
class FarmerEditProfilePage extends StatefulWidget {
  String? name,
      address,
      whatsappNumber,
      geoLocationOwnedFarm,
      totalOwnedFarm,
      totalLeaseFarm,
      geoLocationLeaseFarm,
      pincode,
      state,
      district,
      village,
      bankName,
      accountName,
      accountNumber,
      ifscCode,
      panNumber,
      aadhaarNumber,
      dealerNumber,
      typeOfCultivationPractice;

  String? farmerName, farmerWhatsappNumber;

  FarmerEditProfilePage(
      {super.key,
      this.name,
      this.address,
      this.whatsappNumber,
      this.geoLocationOwnedFarm,
      this.totalOwnedFarm,
      this.totalLeaseFarm,
      this.geoLocationLeaseFarm,
      this.pincode,
      this.state,
      this.district,
      this.village,
      this.farmerName,
      this.farmerWhatsappNumber,
      this.bankName,
      this.accountName,
      this.dealerNumber,
      this.accountNumber,
      this.ifscCode,
      this.panNumber,
      this.aadhaarNumber,
      this.typeOfCultivationPractice});

  @override
  State<FarmerEditProfilePage> createState() => _FarmerEditProfilePageState();
}

class _FarmerEditProfilePageState extends State<FarmerEditProfilePage> {
  TextEditingController ownedAreaController = TextEditingController();
  TextEditingController goeLocationController = TextEditingController();
  TextEditingController leasedFarmController = TextEditingController();
  TextEditingController goeLocationLeasedController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController villageController = TextEditingController();
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

  String selectedItemValue = "";

  String? _selectedStateName, _selectedDistrictName;
  List<DropdownMenuItem<String>>? dropdownStateItems;
  List<DropdownMenuItem<String>>? dropdownDistrictItems;

  PostOffice? selectedItem;
  late Future<List<PostOffice>> itemsFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // itemsFuture = fetchItems(); // Start fetching items
    ownedAreaController.text = widget.totalOwnedFarm ?? "";
    goeLocationController.text = widget.geoLocationOwnedFarm ?? "";
    leasedFarmController.text = widget.totalLeaseFarm ?? "";
    goeLocationLeasedController.text = widget.geoLocationLeaseFarm ?? "";
    pincodeController.text = widget.pincode ?? "";
    addressController.text = widget.address ?? "";
    villageController.text = widget.village ?? "";
    bankNameController.text = widget.bankName ?? "";
    accountNameController.text = widget.accountName ?? "";
    accountNumberController.text = widget.accountNumber ?? "";
    ifsCodeController.text = widget.ifscCode ?? "";
    panNumberController.text = widget.panNumber ?? "";
    aadharNumberController.text = widget.aadhaarNumber ?? "";

    selectedItemValue = widget.typeOfCultivationPractice ?? "";
    if (pincodeController.text.isNotEmpty) {
      _onTextChanged(pincodeController.text);
      _selectedStateName = widget.state;
      _selectedDistrictName = widget.district;
    }
    print("selectedItemValue : $selectedItemValue");
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
                    },
                  )),
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
                  hint: Text(
                    selectedItemValue,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
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
                  onPressed: () {},
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

            // aadhaarNumber number
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
                    _farmerEditRegistrationApiCall();
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

  _farmerEditRegistrationApiCall() async {
    if (ownedAreaController.text.trim().isNotEmpty &&
        pincodeController.text.trim().isNotEmpty &&
        villageController.text.trim().isNotEmpty &&
        selectedItemValue.toString().isNotEmpty) {
      var data = json.encode({
        "name": widget.name,
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
      var url = '${baseUrl}appFarmer/farmer/whatsapp/${widget.whatsappNumber}';
      var response = await putAPICall(
        apiUrl: url,
        parameter: data,
      );
      if (response.statusCode == 200) {
        print("Edit Profile Details updated : " + response.body);
        showAlertDialog(context);
      } else {
        AlertHelper.showToast(response.reasonPhrase, context);
        print(
            "Edit Profile Details Error : " + response.reasonPhrase.toString());
      }
    } else {
      AlertHelper.showToast("Please enter details.", context);
    }
  }

  void _onTextChanged(String text) async {
    try {
      var url = '$baseUrl$PincodeToState';
      final response = await postAPICall(
        apiUrl: url,
        parameter: json.encode({'pincode': text}),
      );

      if (response.statusCode == 200) {
        print('_onTextChanged API call successful: ${response.body}');

        var data = json.decode(response.body);

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
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
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
              Navigator.of(context).pop('Updated Data from FarmerEdit Profile');
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
