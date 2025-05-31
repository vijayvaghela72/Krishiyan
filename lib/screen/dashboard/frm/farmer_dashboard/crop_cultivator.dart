import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/helper/constant.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/helper/snackbar.dart';
import 'package:krishiyan/helper/app_global.dart';
import 'package:krishiyan/helper/alert_helper.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/screen/dashboard/frm/bottom_sheet/crop_bs.dart';
import 'package:krishiyan/screen/dashboard/frm/bottom_sheet/farmer_bs.dart';

Column thirdTabData(BuildContext context, Function update) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Text(
          buildTranslate("cropCultivation")!,
          softWrap: true,
          style: const TextStyle(
              color: Color(0xFF3FC041),
              fontSize: 20,
              fontFamily: 'poppins-medium'),
        ),
      ),
      const SizedBox(
        height: 20,
      ),

      // select farmer
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Text(
          buildTranslate("selectFarmer")!,
          style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF666666),
              fontFamily: 'poppins-semibold'),
        ),
      ),

      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
        child: GestureDetector(
          onTap: () {
            selectFarmer(
              context,
              update,
            );
          },
          child: Container(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withValues(alpha: 0.7)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        frmProvider!.selectedFarmersName ??
                            buildTranslate("selectFarmer")!,
                        style: TextStyle(
                          fontSize: frmProvider!.selectedFarmersName != null
                              ? 15
                              : 15,
                          fontFamily: "poppins-regular",
                          color: frmProvider!.selectedFarmersName != null
                              ? Colors.black
                              : Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // crops
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
        child: Text(
          buildTranslate("selectCrops")!,
          style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF666666),
              fontFamily: 'poppins-semibold'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
        child: GestureDetector(
          onTap: () {
            selectCrop(
              context,
              update,
            );
          },
          child: Container(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withValues(alpha: 0.7)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        frmProvider!.selectedCrop ??
                            buildTranslate("selectCrops")!,
                        style: TextStyle(
                          fontSize: frmProvider!.selectedCrop != null ? 15 : 15,
                          fontFamily: "poppins-regular",
                          color: frmProvider!.selectedCrop != null
                              ? Colors.black
                              : Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      // varity
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
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
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: TextFormField(
          decoration: InputDecoration(
              alignLabelWithHint: true,
              fillColor: Colors.white,
              filled: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: buildTranslate("enterVariety")!,
              hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.green, width: 0.5),
              )),
          validator: (value) =>
              value!.isEmpty ? 'Please, fill this field.' : null,
          controller: frmProvider!.varietyController,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      // date
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
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
        padding: const EdgeInsets.only(left: 25, right: 25),
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
                  Radius.circular(10),
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: 'DD/MM/YYYY',
              hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.green, width: 0.5),
              )),
          validator: (value) =>
              value!.isEmpty ? 'Please, fill this field.' : null,
          controller: frmProvider!.dateController,
          readOnly: true,
        ),
      ),
      const SizedBox(
        height: 20,
      ),

      // goe location
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
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
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: TextFormField(
          decoration: const InputDecoration(
              alignLabelWithHint: true,
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: '----',
              hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.green, width: 0.5),
              )),
          validator: (value) =>
              value!.isEmpty ? 'Please, fill this field.' : null,
          controller: frmProvider!.geoLocationController,
        ),
      ),
      const SizedBox(
        height: 20,
      ),

      // type of cultivation practice
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
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
        padding: const EdgeInsets.only(left: 25, right: 25),
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
            ),
            hint: const Text(
              '--',
              style: TextStyle(fontSize: 14),
            ),
            items: frmProvider!.items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
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
              frmProvider!.selectedItemValue = value.toString();
              update();
            },
            onSaved: (value) {
              frmProvider!.selectedItemValue = value.toString();
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
        padding: const EdgeInsets.only(left: 25, right: 25),
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
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            //To remove first '0'
            FilteringTextInputFormatter.deny(RegExp(r'^0+')),
            //To remove first '94' or your country code
            FilteringTextInputFormatter.deny(RegExp(r'^94+')),
          ],
          decoration: const InputDecoration(
              alignLabelWithHint: true,
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: 'Enter area in acres',
              hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.green, width: 0.5),
              )),
          validator: (value) =>
              value!.isEmpty ? 'Please, fill this field.' : null,
          controller: frmProvider!.areaInArcesController,
        ),
      ),
      const SizedBox(
        height: 20,
      ),

      // geo Link Area On Map
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
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
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: TextFormField(
          decoration: const InputDecoration(
              alignLabelWithHint: true,
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              hintText: 'Enter geoLink area on map',
              hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: Colors.green, width: 0.5),
              )),
          validator: (value) =>
              value!.isEmpty ? 'Please, fill this field.' : null,
          controller: frmProvider!.geoLinkAreaOnMapController,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
          width: 180,
          height: 45,
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
              textStyle: const TextStyle(fontSize: 18),
              backgroundColor: const Color(0xFF3FC041),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.add),
                Text(
                  "Add Crop",
                  style: const TextStyle(
                      fontSize: 16, fontFamily: 'poppins-medium'),
                ),
              ],
            ),
          )),
      const SizedBox(
        height: 20,
      ),
      Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: ElevatedButton(
            onPressed: () {
              _cropCultivationRegisterApiCall(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
              textStyle: const TextStyle(fontSize: 18),
              backgroundColor: const Color(0xFF3FC041),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              buildTranslate('SUBMIT')!,
              style:
                  const TextStyle(fontSize: 18, fontFamily: 'poppins-medium'),
            ),
          )),
      const SizedBox(
        height: 100,
      ),
    ],
  );
}

Future<void> _selectDate(BuildContext context) async {
  // Show the date picker dialog
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    // Default date is the current date
    firstDate: DateTime(2000),
    // Earliest selectable date
    lastDate: DateTime.now(),
    // Latest selectable date
    helpText: 'Select a date', // Optional help text
  );
  if (pickedDate != null) {
    frmProvider!.dateController.text =
        DateFormat('dd-MM-yyyy').format(pickedDate);
    update();
  }
}

_cropCultivationRegisterApiCall(BuildContext context) async {
  if (frmProvider!.selectedFarmersName == null) {
    AlertHelper.showToast("Please select farmer name", context);
    return;
  }
  if (frmProvider!.selectedCrop == null) {
    AlertHelper.showToast("Please select crop", context);
    return;
  }
  if (frmProvider!.varietyController.text.trim().isEmpty) {
    AlertHelper.showToast("Please enter variety", context);
    return;
  }
  if (frmProvider!.dateController.text.trim().isEmpty) {
    AlertHelper.showToast("Please select date of sowing", context);
    return;
  }

  if (frmProvider!.selectedItemValue.toString().isEmpty) {
    AlertHelper.showToast("Please select cultivation practice type", context);
    return;
  }
  if (frmProvider!.areaInArcesController.text.trim().isEmpty) {
    AlertHelper.showToast("Please enter area in acres", context);
    return;
  }

  String? number = await AppGlobal.getStringPreference('contactNumber');

  // Parse the input date string
  DateTime parsedDate = DateFormat('dd-MM-yyyy')
      .parse(frmProvider!.dateController.text.toString());
  // Format it to YYYY-MM-DD
  String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

  var body = json.encode({
    "dealerNumber": number ?? "1",
    // "fid": WhatsappNumberData,
    "fid": number,
    "farmerName": frmProvider!.selectedFarmersName.toString(),
    "crops": frmProvider!.selectedCrop.toString(),
    "variety": frmProvider!.varietyController.text.toString(),
    "dateOfSowing": formattedDate,
    "geolocation": frmProvider!.geoLocationController.text.toString(),
    "typeOfCultivationPractice": frmProvider!.selectedItemValue.toString(),
    "areaInAcres": frmProvider!.areaInArcesController.text.toString(),
    "geoLinkAreaOnMap": frmProvider!.geoLinkAreaOnMapController.text.toString()
  });
  showLoading();
  var response = await postAPICall(
    apiUrl: CROP_CULTIVATION_REGISTR,
    parameter: body,
  );
  stopLoading();
  if (response.statusCode == 201 || response.statusCode == 200) {
    frmProvider!.selectedFarmersName = null;
    frmProvider!.selectedCrop = null;
    frmProvider!.varietyController.text = '';
    formattedDate = '';
    frmProvider!.geoLocationController.text = '';
    frmProvider!.selectedItemValue = null;
    frmProvider!.areaInArcesController.text = '';
    frmProvider!.geoLinkAreaOnMapController.text = '';
    update();

    Future.delayed(const Duration(seconds: 1), () {
      print('crop cultivation registered successfully');
      showAlertDialog(context, 'crop cultivation registered successfully');
    });
  } else {
    setSnackbar('Something wrong! ${response.body.toString()}');
  }
}

showAlertDialog(BuildContext context, String message) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.white,
    title: Column(
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.close,
              color: Colors.black,
              size: 20,
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
          message,
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
              fontSize: 20,
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
