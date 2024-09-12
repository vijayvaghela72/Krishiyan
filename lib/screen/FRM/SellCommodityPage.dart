import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../helper/AlertHelper.dart';
import '../../localization/AppLocalizations.dart';
import '../../mvc/controller/cropController.dart';
import '../../mvc/controller/enquiryDashboardController.dart';
import '../../mvc/model/CropLibraryData.dart';
import '../../mvc/model/SelectCropNamesData.dart';
import '../../utils/AppGlobal.dart';
import '../../utils/Constants.dart';

class SellCommodityPage extends StatefulWidget {
  const SellCommodityPage({super.key});

  @override
  State<SellCommodityPage> createState() => _SellCommodityPageState();
}

class _SellCommodityPageState extends State<SellCommodityPage> {

  TextEditingController varietyController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController moistureController = TextEditingController();
  TextEditingController localGradeController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController supplyPriceController = TextEditingController();
  TextEditingController dateOfShipmentController = TextEditingController();
  TextEditingController originCommodityController = TextEditingController();
  TextEditingController commentsController = TextEditingController();

  // final List<String> commodityItems = ['Maize', 'Coriander', 'Soya'];
  // String? selectedCommodityItemValue;

  final List<String> quantityItems = ['Ton', 'Kg', 'Qtl'];
  String? selectedQuantityItemValue;

  final List<String> sizeItems = ['MM', 'CM'];
  String? selectedSizeItemValue;

  final List<String> purchaseItems = ['Kg', 'Qtl', 'Ton'];
  String? selectedPurchaseItemValue;

  late Future<List<CropLibraryData>?> futureCropData;
  String? _selectedCrop;
  SelectCropNamesData? _cropData;
  String? contactNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCropData = CropController.fetchCrop();
    _fetchCropData();
  }

  Future<void> _fetchCropData() async {
    try {
      // Replace with your actual API endpoint
      var response = await Dio().get(CROPS_NAMES);

      if (response.statusCode == 200) {
        setState(() {
          _cropData = SelectCropNamesData.fromJson(response.data);
        });
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (e) {
      print('My SellCommodity : Error fetching crop data: $e');
    }
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
            const SizedBox(width: 10,),
            Text(
              buildTranslate("sellCommodity")!,
              style: const TextStyle(color: Colors.white, fontFamily: 'poppins-semibold', fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: ElevatedButton(
            onPressed: () {
              _sellCommodityApiCall();
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
            child: Text(buildTranslate("sellCommodity")!,
              style: const TextStyle(fontSize: 15, fontFamily: 'poppins-medium'),),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30,),

            // Select Commodity
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("selectCommodity")!, style: const
              TextStyle(fontSize: 15, color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25.0),
              child: _cropData == null ||
                  _cropData!.data == null
                  ? const Center(child: Text('No data available'))
                  :
              DropdownButtonFormField2<String>(
                dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                hint: const Text('Select Commodity'),
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(
                      vertical: 16),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  // Add more decoration..
                ),
                buttonStyleData:
                const ButtonStyleData(
                  padding:
                  EdgeInsets.only(right: 8),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 24,
                ),
                menuItemStyleData:
                const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16),
                ),
                value: _selectedCrop,
                items: _cropData!.data!.map((String crop) {
                  return DropdownMenuItem<String>(
                    value: crop,
                    child: Text(crop, style: const TextStyle(
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
            const SizedBox(height: 20,),

            // variety
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("Variety")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: varietyController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: buildTranslate('enterNameOfVariety')!,
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20,),

            // Quantity
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("quantity")!,
                style: const TextStyle(fontSize: 15, color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: quantityController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        hintText: buildTranslate('addYourQuantity'),
                        hintStyle: const TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3,),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none
                            // borderSide: const BorderSide(
                            //   color: Colors.grey,
                            //   width: 1.0,
                            // ),
                          ),
                          // Add more decoration..
                        ),
                        hint: const Text(
                          'Ton',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        items: quantityItems
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
                          selectedQuantityItemValue = value.toString();
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
                ],
              ),
            ),
            const SizedBox(height: 20,),

            // Moisture%
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("moisture")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: moistureController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: '__%',
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20,),

            // Any Local Grade Specification
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("anyLocalGradeSpecification")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: localGradeController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: buildTranslate("anyLocalGradeSpecification")!,
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20,),

            // size
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("size")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: sizeController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3,),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none
                            // borderSide: const BorderSide(
                            //   color: Colors.grey,
                            //   width: 1.0,
                            // ),
                          ),
                          // Add more decoration..
                        ),
                        hint: const Text(
                          'MM',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        items: sizeItems
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
                          selectedSizeItemValue = value.toString();
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
                ],
              ),
            ),
            const SizedBox(height: 20,),

            // Count
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("count")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: countController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: buildTranslate('enterCount')!,
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20,),

            // supply
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("supplyPriceInRs")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: supplyPriceController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3,),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none
                            // borderSide: const BorderSide(
                            //   color: Colors.grey,
                            //   width: 1.0,
                            // ),
                          ),
                          // Add more decoration..
                        ),
                        hint: const Text(
                          'Kg',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        items: purchaseItems
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
                          selectedPurchaseItemValue = value.toString();
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
                ],
              ),
            ),
            const SizedBox(height: 20,),

            // date of delivery
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("dateOfExpectedShipmentLoading")!, style: const
              TextStyle(fontSize: 15, color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: dateOfShipmentController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: 'dd/mm/yyyy',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    }, // Open date picker on icon press
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
                readOnly: true,
              ),
            ),
            const SizedBox(height: 20,),

            // origin of commodity
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("originOfCommodity")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: originCommodityController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20,),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(17),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: const Color(0xFF3692FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22), // <-- Radius
                  ),
                ),
                child:Text(buildTranslate('uploadImage')!,
                  style: const TextStyle(fontSize: 15, fontFamily: 'poppins-medium'),),
              ),
            ),
            const SizedBox(height: 20,),

            // Add comments
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("addComments")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: commentsController,
                maxLines: null,
                minLines: 5,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 80,),
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
      lastDate: DateTime(2101), // Latest selectable date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      setState(() {
        // Format the selected date and display it in the TextFormField
        dateOfShipmentController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  _sellCommodityApiCall() async {
    if (varietyController.text.trim().isNotEmpty
        && quantityController.text.trim().isNotEmpty
        && moistureController.text.trim().isNotEmpty
        && localGradeController.text.trim().isNotEmpty
        && sizeController.text.trim().isNotEmpty
        && countController.text.trim().isNotEmpty
        && supplyPriceController.text.trim().isNotEmpty
        && dateOfShipmentController.text.trim().isNotEmpty
        && originCommodityController.text.trim().isNotEmpty
        && commentsController.text.trim().isNotEmpty
    ) {

      contactNumber = (await AppGlobal.getStringPreference('contactNumber'))!;

      var body = json.encode({
        "uid": contactNumber,
        "operation": "Sell",
        "commodity": _selectedCrop,
        "variety": varietyController.text.toString(),
        "quantity": quantityController.text.toString(),
        "moisture": moistureController.text.toString(),
        "localGradeSpecification": localGradeController.text.toString(),
        "size": sizeController.text.toString(),
        "count": countController.text.toString(),
        "price": supplyPriceController.text.toString(),
        "date": dateOfShipmentController.text.toString(),
        "origin": originCommodityController.text.toString(),
        "location": "",
        "photoVideoLink": "http://example.com/photo",
        "comments": commentsController.text.toString(),
        "verified": true
      });

      var buyCommodity = EnquiryDashboardController.buySellCommodityData(body, context: context);

      if (buyCommodity.toString().isNotEmpty) {
        Future.delayed(const Duration(seconds: 1), () {
          print('Commodity created successfully');

          // AlertHelper.showToast("Commodity created successfully",context);

          showAlertDialog(context);
        });
      }
      else {
        print("Api error");
      }
    }
    else{
      AlertHelper.showToast("Please enter details.",context);
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

          Center(child: Image.asset('assets/images/check_green.png', width: 100, height: 100,)),

          Text(buildTranslate("SuccessfullyUpdate")!, softWrap: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: "poppins-semibold", fontSize: 15.0, color: Colors.grey),),

          const SizedBox(height: 20,),

          Text(buildTranslate("thankYou")!, softWrap: true,
            style: const TextStyle(fontFamily: "poppins-semibold", fontSize: 20.0, color: Colors.black),),

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