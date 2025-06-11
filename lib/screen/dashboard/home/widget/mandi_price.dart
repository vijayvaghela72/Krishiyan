import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../../../helper/provider.dart';
import 'package:krishiyan/helper/snackbar.dart';
import 'package:krishiyan/helper/alert_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/screen/dashboard/home/widget/helper/mandi_district.dart';
import 'package:krishiyan/screen/dashboard/home/widget/helper/commodity_sheet.dart';
import 'package:krishiyan/screen/dashboard/home/widget/helper/state_bottom_sheet.dart';

// ignore: must_be_immutable
class MandiPriceScreen extends StatefulWidget {
  Function update;
  MandiPriceScreen({
    super.key,
    required this.update,
  });

  @override
  State<MandiPriceScreen> createState() => _MandiPriceScreenState();
}

class _MandiPriceScreenState extends State<MandiPriceScreen> {
  Future<void> _selectFromDate(BuildContext context) async {
    // Show the date picker dialog
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: homeProvider!.selectedDate != null
          ? homeProvider!.selectedDate
          : DateTime.now(),
      // Default date is the current date
      firstDate: DateTime(2000),
      // Earliest selectable date
      lastDate: DateTime(2101),
      // Latest selectable date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      print("pickedDate : $pickedDate");
      setState(() {
        // Format the selected date and display it in the TextFormField
        homeProvider!.fromDateController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
        homeProvider!.dateOfFromValue = homeProvider!.fromDateController.text;

        // Validate To Date
        if (homeProvider!.toDateController.text.isNotEmpty) {
          DateTime toDate = DateFormat('dd-MM-yyyy')
              .parse(homeProvider!.toDateController.text);
          if (pickedDate.isAfter(toDate)) {
            // Show error message using AlertHelper.showToast
            AlertHelper.showToast(
                'To Date cannot be earlier than From Date', context);
            homeProvider!.toDateController.clear();
          }
        }
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    // Show the date picker dialog
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: homeProvider!.selectedDate != null
          ? homeProvider!.selectedDate
          : DateTime.now(),
      // Default date is the current date
      firstDate: DateTime(2000),
      // Earliest selectable date
      lastDate: DateTime(2101),
      // Latest selectable date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      print("pickedDate : $pickedDate");
      setState(() {
        // Format the selected date and display it in the TextFormField
        homeProvider!.toDateController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
        homeProvider!.dateOfToValue = homeProvider!.toDateController.text;

        // Validate From Date
        if (homeProvider!.fromDateController.text.isNotEmpty) {
          DateTime fromDate = DateFormat('dd-MM-yyyy')
              .parse(homeProvider!.fromDateController.text);
          if (pickedDate.isBefore(fromDate)) {
            // Show error message
            // Show error message using AlertHelper.showToast
            setSnackbar('To Date cannot be earlier than From Date');

            homeProvider!.fromDateController.clear();
          }
        }
      });
    }
  }

  // for selected commodity inside markting

  void getValue() async {
    print('Data : 1');
    if (homeProvider!.selectedMandiStateList == null) {
      setSnackbar("Please select state");
    } else if (homeProvider!.selectedDistrictMasterList == null) {
      setSnackbar("Please select district");
    } else if (homeProvider!.selectedPriceMandiCoodityData == null) {
      setSnackbar("Please select commodity");
    } else if (homeProvider!.dateOfFromValue.isEmpty) {
      setSnackbar("Please select from date");
    } else if (homeProvider!.dateOfToValue.isEmpty) {
      setSnackbar("Please select to date");
    } else {
      await homeProvider!.getMandiPriceDetails(
        homeProvider!.selectedMandiStateList.toString(),
        homeProvider!.selectedDistrictMasterList.toString(),
        homeProvider!.selectedPriceMandiCoodityData.toString(),
        homeProvider!.dateOfFromValue,
        homeProvider!.dateOfToValue,
      );

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // select state
                  Text(
                    buildTranslate("selectState")!,
                    softWrap: true,
                    style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 13,
                        fontFamily: 'poppins-semibold'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      homeProvider!.selectedDistrictMasterList = null;
                      homeProvider!.selectedPriceMandiCoodityData = null;
                      selectState(
                        context,
                        widget.update,
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                homeProvider!.selectedMandiStateList ??
                                    buildTranslate("selectState")!,
                                style: TextStyle(
                                  fontSize:
                                      homeProvider!.selectedMandiStateList !=
                                              null
                                          ? 15
                                          : 13,
                                  fontFamily: "poppins-regular",
                                  color: homeProvider!.selectedMandiStateList !=
                                          null
                                      ? Colors.black
                                      : Colors.black54,
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
                  const SizedBox(
                    height: 20,
                  ),
                  // select district
                  Text(
                    buildTranslate("selectDistrict")!,
                    softWrap: true,
                    style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 13,
                        fontFamily: 'poppins-semibold'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      homeProvider!.selectedPriceMandiCoodityData = null;
                      selectDistrict(
                        context,
                        widget.update,
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  homeProvider!.selectedDistrictMasterList ??
                                      buildTranslate("selectDistrict")!,
                                  style: TextStyle(
                                    fontSize: homeProvider!
                                                .selectedDistrictMasterList !=
                                            null
                                        ? 15
                                        : 13,
                                    fontFamily: "poppins-regular",
                                    color: homeProvider!
                                                .selectedDistrictMasterList !=
                                            null
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
                  const SizedBox(
                    height: 20,
                  ),
                  // select commodity
                  Text(
                    buildTranslate("selectCommodity")!,
                    softWrap: true,
                    style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 13,
                        fontFamily: 'poppins-semibold'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      selectCommodity(
                        context,
                        widget.update,
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  homeProvider!.selectedPriceMandiCoodityData ??
                                      buildTranslate("selectCommodity")!,
                                  style: TextStyle(
                                    fontSize: homeProvider!
                                                .selectedPriceMandiCoodityData !=
                                            null
                                        ? 15
                                        : 13,
                                    fontFamily: "poppins-regular",
                                    color: homeProvider!
                                                .selectedPriceMandiCoodityData !=
                                            null
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
                  const SizedBox(
                    height: 20,
                  ),
                  // Search By Date Range
                  Text(
                    buildTranslate("searchByDateRange")!,
                    softWrap: true,
                    style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 13,
                        fontFamily: 'poppins-semibold'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              _selectFromDate(context);
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.calendar_month,
                                        size: 20.0,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        // _selectFromDate(context);
                                      },
                                    ),
                                    alignLabelWithHint: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(10.0),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    hintText: buildTranslate("from"),
                                    hintStyle: const TextStyle(
                                        color: Color(0xFF757575),
                                        fontFamily: "poppins-regular",
                                        fontSize: 13.0),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 0.5),
                                    )),
                                validator: (value) => value!.isEmpty
                                    ? 'Please, fill this field.'
                                    : null,
                                controller: homeProvider!.fromDateController,
                                readOnly: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              _selectToDate(context);
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.calendar_month,
                                        size: 20.0,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        // _selectToDate(context);
                                      },
                                    ),
                                    alignLabelWithHint: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(10.0),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    hintText: buildTranslate("to"),
                                    hintStyle: const TextStyle(
                                        color: Color(0xFF757575),
                                        fontFamily: "poppins-regular",
                                        fontSize: 13.0),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 0.5),
                                    )),
                                validator: (value) => value!.isEmpty
                                    ? 'Please, fill this field.'
                                    : null,
                                controller: homeProvider!.toDateController,
                                readOnly: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          getValue();
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
                          buildTranslate('SUBMIT')!,
                          style: const TextStyle(
                              fontSize: 15, fontFamily: 'poppins-regular'),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                width: 130,
                height: 40,
                color: Colors.white,
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF666666),
                        width: 1.0,
                      ),
                    ),
                    // Add more decoration..
                  ),
                  hint: Text(
                    buildTranslate('sortBy')!,
                    style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF666666),
                        fontFamily: "poppins-regular"),
                  ),
                  // Bind the selected value to the widget
                  value: homeProvider!.selectedSortItemsValue.isNotEmpty
                      ? homeProvider!.selectedSortItemsValue
                      : null,
                  items: homeProvider!.sortItems
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                  fontSize: 9, color: Color(0xFF666666)),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      homeProvider!.selectedSortItemsValue = value.toString();
                    });
                    print(
                        "Selected value: ${homeProvider!.selectedSortItemsValue}");
                  },
                  onSaved: (value) {
                    homeProvider!.selectedSortItemsValue = value.toString();
                    print({homeProvider!.selectedSortItemsValue});
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 10),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: ImageIcon(AssetImage('assets/images/sortBy.png')),
                    iconSize: 18,
                    iconEnabledColor: Colors.black,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/images/location.png",
                width: 15,
                height: 15,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                homeProvider!.selectedMandiStateList ?? '',
                softWrap: true,
                style: TextStyle(
                    color: Color(0xFF808080),
                    fontSize: 11,
                    fontFamily: 'poppins-semibold'),
              ),
            ],
          ),
        ),
        homeProvider!.mandiPriceData.isEmpty
            ? Center(child: Text(buildTranslate("noDataAvailable")!))
            : ListView.builder(
                itemCount: homeProvider!.mandiPriceData.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // Sort the data based on selected criteria
                  if (homeProvider!.selectedSortItemsValue.trim() ==
                      'Low To High Price') {
                    homeProvider!.mandiPriceData.sort((a, b) {
                      final priceA = a.modalPrice ?? double.infinity;
                      final priceB = b.modalPrice ?? double.infinity;
                      return priceA.compareTo(priceB);
                    });
                  } else {
                    homeProvider!.mandiPriceData.sort((a, b) {
                      final priceA = a.modalPrice ?? -double.infinity;
                      final priceB = b.modalPrice ?? -double.infinity;
                      return priceB.compareTo(priceA);
                    });
                  }

                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      right: 20.0,
                      left: 20.0,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15.0),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/location.png",
                                      width: 15,
                                      height: 15,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      homeProvider!
                                              .mandiPriceData[index].market ??
                                          "",
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Color(0xFF959595),
                                          fontSize: 11,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Image.asset(
                                        "assets/images/calendar.png",
                                        width: 15,
                                        height: 15,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        homeProvider!.mandiPriceData[index]
                                                .arrivalDate ??
                                            "",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Color(0xFF959595),
                                            fontSize: 11,
                                            fontFamily: 'poppins-semibold'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/Commodity.webp",
                                  width: 40,
                                  height: 40,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  homeProvider!
                                          .mandiPriceData[index].commodity ??
                                      "",
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Color(0xFF808080),
                                      fontSize: 14,
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Center(
                            child: Text(
                              "Price Per Quintal",
                              softWrap: true,
                              style: TextStyle(
                                  color: Color(0xFF808080),
                                  fontSize: 17,
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: const BoxDecoration(
                                color: Color(0xFF116B38),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Min ₹:",
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'poppins-regular'),
                                      ),
                                      Text(
                                        homeProvider!
                                            .mandiPriceData[index].minPrice
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'poppins-regular'),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Average ₹:",
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'poppins-regular'),
                                      ),
                                      Text(
                                        homeProvider!
                                            .mandiPriceData[index].modalPrice
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'poppins-regular'),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Max ₹:",
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'poppins-regular'),
                                      ),
                                      Text(
                                        homeProvider!
                                            .mandiPriceData[index].maxPrice
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'poppins-regular'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        SizedBox(
          height: 60,
        ),
      ],
    );
  }
}
