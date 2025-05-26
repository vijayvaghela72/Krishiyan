import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import '../../../../helper/AlertHelper.dart';
import '../../../../localization/AppLocalizations.dart';
import '../../../../mvc/controller/farmerDashboardController.dart';
import '../../../../mvc/model/SelectCropNamesData.dart';
import '../../../../utils/AppGlobal.dart';
import '../../../../utils/Constants.dart';
import '../../dashborad.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CropCultivationPage extends StatefulWidget {
  String WhatsappNumber;

  CropCultivationPage({super.key, required this.WhatsappNumber});

  @override
  State<CropCultivationPage> createState() => _CropCultivationPageState();
}

class _CropCultivationPageState extends State<CropCultivationPage>
    with TickerProviderStateMixin {
  TextEditingController geoLocationController = TextEditingController();
  TextEditingController areaInArcsController = TextEditingController();
  TextEditingController varietyController = TextEditingController();
  TextEditingController dateOfSowingController = TextEditingController();
  TextEditingController geoLinkAreaOnMapController = TextEditingController();

  final List<String> items = [
    buildTranslate('organic')!,
    buildTranslate('inOrganic')!,
  ];

  String? selectedItemValue;

  List<DropdownMenuItem<String>>? dropdownItems;
  String? _selectedFarmersName;

  String? _selectedCrop;
  SelectCropNamesData? _cropData;
  String typeOfOrganizationData = "";

  @override
  void initState() {
    super.initState();
    print('crop : crop');
    _fetchFarmerNameData();
    _fetchCropData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),
      extendBody: false,
      extendBodyBehindAppBar: false,
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
              buildTranslate("cropCultivationData")!,
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
          children: [
            const SizedBox(
              height: 20,
            ),

            // select farmer
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("selectFarmer")!,
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
                    hint: const Text('Select a farmer'),
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
                    value: _selectedFarmersName,
                    items: dropdownItems,
                    onChanged: (String? newValue) {
                      _selectedFarmersName = newValue;
                    },
                  )),
            ),
            const SizedBox(
              height: 20,
            ),

            // crops
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("selectCrops")!,
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
              child: _cropData == null || _cropData!.data == null
                  ? const Center(child: Text('No data available'))
                  : DropdownButtonFormField2<String>(
                      dropdownStyleData: DropdownStyleData(maxHeight: 200),
                      hint: const Text('Select a Crop'),
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
                      value: _selectedCrop,
                      items: _cropData!.data!.map((String crop) {
                        return DropdownMenuItem<String>(
                          value: crop,
                          child: Text(crop,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontFamily: 'poppins-regular')),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCrop = newValue;
                        });
                      },
                    ),
            ),
            const SizedBox(
              height: 20,
            ),

            // varity
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("variety")!,
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
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    hintText: buildTranslate("enterVariety")!,
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: varietyController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // date
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("dateOfSowing")!,
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
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      }, // Open date picker on icon press
                    ),
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
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    hintText: 'DD/MM/YYYY',
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: dateOfSowingController,
                readOnly: true,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // goe location
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("geoLocation")!,
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
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    hintText: '----',
                    hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: geoLocationController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // type of cultivation practice
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
                  },
                  onSaved: (value) {
                    setState(() {
                      selectedItemValue = value.toString();
                    });
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

            // area in arcs
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("areaInAcres")!,
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
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  //To remove first '0'
                  FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                  //To remove first '94' or your country code
                  FilteringTextInputFormatter.deny(RegExp(r'^94+')),
                ],
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
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    hintText: buildTranslate('enterAreaInAcres'),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: areaInArcsController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // geo Link Area On Map
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("geoLinkAreaOnMap")!,
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
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    hintText: 'Enter geoLink area on map',
                    hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    )),
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: geoLinkAreaOnMapController,
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
                    _cropCultivationRegisterApiCall();
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
                )),
            const SizedBox(
              height: 30,
            ),
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
      lastDate: DateTime.now(), // Latest selectable date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      setState(() {
        // Format the selected date and display it in the TextFormField
        dateOfSowingController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () async {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(
                        selectedIndex: 1,
                        typeOfOrganization: typeOfOrganizationData,
                      )));
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
            buildTranslate("successfullySaved")!,
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

  Future<void> _fetchFarmerNameData() async {
    try {
      String? number = await AppGlobal.getStringPreference('contactNumber');
      var num = number ?? "1";
      var response = await getAPICall(apiUrl: FARMER_NAME + num);

      print("Farmer name : ${response.body}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        dropdownItems = jsonData['data'].map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
            value: item['name'],
            child: Text(item['name']),
          );
        }).toList();
      } else {
        throw Exception('Failed to load farmers name');
      }
    } catch (e) {
      print('Error fetching farmer name data: $e');
    }
  }

  Future<void> _fetchCropData() async {
    try {
      var response = await getAPICall(apiUrl: CROPS_NAMES);

      if (response.statusCode == 200) {
        setState(() {
          _cropData = SelectCropNamesData.fromJson(jsonDecode(response.body));
        });
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (e) {
      print('Crop Cultivation : Error fetching crop data: $e');
    }
  }

  _cropCultivationRegisterApiCall() async {
    if (varietyController.text.trim().isNotEmpty &&
        dateOfSowingController.text.trim().isNotEmpty &&
        geoLocationController.text.trim().isNotEmpty &&
        selectedItemValue.toString().isNotEmpty &&
        areaInArcsController.text.trim().isNotEmpty &&
        geoLinkAreaOnMapController.text.trim().isNotEmpty) {
      String? number = await AppGlobal.getStringPreference('contactNumber');

      // Parse the input date string
      DateTime parsedDate = DateFormat('dd-MM-yyyy')
          .parse(dateOfSowingController.text.toString());
      // Format it to YYYY-MM-DD
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      var body = json.encode({
        "dealerNumber": number ?? "1",
        "fid": widget.WhatsappNumber,
        "farmerName": _selectedFarmersName.toString(),
        "crops": _selectedCrop.toString(),
        "variety": varietyController.text.toString(),
        "dateOfSowing": formattedDate,
        "geolocation": geoLocationController.text.toString(),
        "typeOfCultivationPractice": selectedItemValue.toString(),
        "areaInAcres": areaInArcsController.text.toString(),
        "geoLinkAreaOnMap": geoLinkAreaOnMapController.text.toString()
      });

      var farmerRegistration =
          FarmerDashboardController.cropCultivationRegister(body,
              context: context);

      if (farmerRegistration.toString().isNotEmpty) {
        Future.delayed(const Duration(seconds: 1), () {
          print('crop cultivation registered successfully');

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
}

class cropsCategory {
  String? name;
  String? icon;
  String? id;

  cropsCategory({
    required this.name,
    required this.icon,
    required this.id,
  });
}

class bottomCategory {
  String? name;
  String? icon;
  String? id;

  bottomCategory({
    required this.name,
    required this.icon,
    required this.id,
  });
}
