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
import 'package:krishiyan/screen/dashboard/frm/farmer_dashboard/crop_cultivation/helper/crop_bs.dart';
import 'package:krishiyan/screen/dashboard/frm/farmer_dashboard/crop_cultivation/helper/farmer_bs.dart';

thirdTabData(BuildContext context, Function update) {
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
      for (int i = 0; i < frmProvider!.selectedFarmersName.length; i++)
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.shade800,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        buildTranslate("selectFarmer")!,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF666666),
                            fontFamily: 'poppins-semibold'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          selectFarmer(
                            context,
                            update,
                            i,
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.7),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      frmProvider!.selectedFarmersName[i] == ''
                                          ? buildTranslate("selectFarmer")!
                                          : frmProvider!.selectedFarmersName[i],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "poppins-regular",
                                        color: frmProvider!
                                                    .selectedFarmersName[i] !=
                                                ''
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
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        buildTranslate("selectCrops")!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF666666),
                          fontFamily: 'poppins-semibold',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          selectCrop(
                            context,
                            update,
                            i,
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.7),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      frmProvider!.selectedCropList[i] == ''
                                          ? buildTranslate("selectCrops")!
                                          : frmProvider!.selectedCropList[i],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "poppins-regular",
                                        color:
                                            frmProvider!.selectedCropList[i] !=
                                                    ''
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
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        buildTranslate("variety")!,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF666666),
                            fontFamily: 'poppins-semibold'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          hintText: buildTranslate("enterVariety")!,
                          hintStyle: const TextStyle(
                            color: Color(0xFFe7e7e7),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please, fill this field.' : null,
                        controller: frmProvider!.varietyController[i],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        buildTranslate("dateOfSowing")!,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF666666),
                            fontFamily: 'poppins-semibold'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                              _selectDate(context, i);
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
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          hintText: 'DD/MM/YYYY',
                          hintStyle: const TextStyle(
                            color: Color(0xFFe7e7e7),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please, fill this field.' : null,
                        controller: frmProvider!.dateController[i],
                        readOnly: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        buildTranslate("geoLocation")!,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF666666),
                            fontFamily: 'poppins-semibold'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          hintText: '----',
                          hintStyle: TextStyle(
                            color: Color(0xFFe7e7e7),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please, fill this field.' : null,
                        controller: frmProvider!.geoLocationController[i],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        buildTranslate("typeofCultivationPractice")!,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF666666),
                            fontFamily: 'poppins-semibold'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          ),
                          hint: const Text(
                            '--',
                            style: TextStyle(fontSize: 14),
                          ),
                          items: frmProvider!.items
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                              )
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select type of Entity.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            frmProvider!.selectedItemValue[i] =
                                value.toString();
                            update();
                          },
                          onSaved: (value) {
                            frmProvider!.selectedItemValue[i] =
                                value.toString();
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
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        buildTranslate("areaInAcres")!,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF666666),
                            fontFamily: 'poppins-semibold'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                            RegExp('[0-9]'),
                          ),
                          //To remove first '0'
                          FilteringTextInputFormatter.deny(
                            RegExp(r'^0+'),
                          ),
                          //To remove first '94' or your country code
                          FilteringTextInputFormatter.deny(
                            RegExp(r'^94+'),
                          ),
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          hintText: 'Enter area in acres',
                          hintStyle: TextStyle(
                            color: Color(0xFFe7e7e7),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please, fill this field.' : null,
                        controller: frmProvider!.areaInArcesController[i],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        buildTranslate("geoLinkAreaOnMap")!,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF666666),
                            fontFamily: 'poppins-semibold'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
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
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          hintText: 'Enter geoLink area on map',
                          hintStyle: TextStyle(
                            color: Color(0xFFe7e7e7),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please, fill this field.' : null,
                        controller: frmProvider!.geoLinkAreaOnMapController[i],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            i == 0
                ? Container()
                : Positioned(
                    top: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: InkWell(
                        onTap: () {
                          frmProvider!.removeCrop(i);
                          update();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200, // light background
                            borderRadius: BorderRadius.circular(
                                8), // square-ish with soft corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      Center(
        child: Container(
          width: 180,
          height: 45,
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: ElevatedButton(
            onPressed: () {
              frmProvider!.addCrop();
              update();
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
            child: Row(
              children: [
                Icon(Icons.add),
                Text(
                  "Add Crop",
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'poppins-medium',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: ElevatedButton(
          onPressed: () async {
            bool isValidateDone = false;
            for (int i = 0; i < frmProvider!.selectedFarmersName.length; i++) {
              isValidateDone = await checkValidation(context, i);
              if (isValidateDone == false) {
                break;
              }
            }
            if (isValidateDone) {
              for (int i = 0;
                  i < frmProvider!.selectedFarmersName.length;
                  i++) {
                await _cropCultivationRegisterApiCall(
                  context,
                  i,
                  frmProvider!.selectedFarmersName.length - 1 == i,
                );
              }
              frmProvider!.initializeCrop();
            } else {}
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
            style: const TextStyle(fontSize: 18, fontFamily: 'poppins-medium'),
          ),
        ),
      ),
      const SizedBox(
        height: 130,
      ),
    ],
  );
}

Future<void> _selectDate(BuildContext context, int i) async {
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
    frmProvider!.dateController[i].text =
        DateFormat('dd-MM-yyyy').format(pickedDate);
    update();
  }
}

Future<bool> checkValidation(BuildContext context, int i) async {
  if (frmProvider!.selectedFarmersName[i] == '') {
    AlertHelper.showToast(
        "Please select farmer name at ${i + 1} crop detail", context);
    return false;
  }
  if (frmProvider!.selectedCropList[i] == '') {
    AlertHelper.showToast("Please select crop", context);
    return false;
  }
  if (frmProvider!.varietyController[i].text.trim().isEmpty) {
    AlertHelper.showToast("Please enter variety", context);
    return false;
  }
  if (frmProvider!.dateController[i].text.trim().isEmpty) {
    AlertHelper.showToast("Please select date of sowing", context);
    return false;
  }
  if (frmProvider!.selectedItemValue[i].toString().isEmpty) {
    AlertHelper.showToast("Please select cultivation practice type", context);
    return false;
  }
  if (frmProvider!.areaInArcesController[i].text.trim().isEmpty) {
    AlertHelper.showToast("Please enter area in acres", context);
    return false;
  }
  return true;
}

Future<void> _cropCultivationRegisterApiCall(
    BuildContext context, int i, bool isLastIndex) async {
  String? number = await AppGlobal.getStringPreference('contactNumber');

  // Parse the input date string
  DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(
    frmProvider!.dateController[i].text.toString(),
  );
  // Format it to YYYY-MM-DD
  String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

  var body = json.encode({
    "dealerNumber": number ?? "1",
    // "fid": WhatsappNumberData,
    "fid": number,
    "farmerName": frmProvider!.selectedFarmersName[i].toString(),
    "crops": frmProvider!.selectedCropList[i].toString(),
    "variety": frmProvider!.varietyController[i].text.toString(),
    "dateOfSowing": formattedDate,
    "geolocation": frmProvider!.geoLocationController[i].text.toString(),
    "typeOfCultivationPractice": frmProvider!.selectedItemValue[i].toString(),
    "areaInAcres": frmProvider!.areaInArcesController[i].text.toString(),
    "geoLinkAreaOnMap":
        frmProvider!.geoLinkAreaOnMapController[i].text.toString()
  });
  showLoading();
  var response = await postAPICall(
    apiUrl: CROP_CULTIVATION_REGISTR,
    parameter: body,
  );
  stopLoading();
  if (response.statusCode == 201 || response.statusCode == 200) {
    if (isLastIndex) {
      Future.delayed(const Duration(seconds: 1), () {
        print('crop cultivation registered successfully');
        showAlertDialog(context, 'crop cultivation registered successfully');
      });
    }
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
          ),
        ),
        Text(
          message,
          softWrap: true,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: "poppins-semibold",
            fontSize: 15,
            color: Colors.grey,
          ),
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
            color: Colors.black,
          ),
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
