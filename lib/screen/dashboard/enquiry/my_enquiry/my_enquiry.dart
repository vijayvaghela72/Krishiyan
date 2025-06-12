import 'package:flutter/material.dart';
import 'package:chip_list/chip_list.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/mvc/controller/enquiry_dashboard_controller.dart';
import 'package:krishiyan/mvc/model/enquiry_by_filter_model.dart';
import 'package:krishiyan/screen/dashboard/enquiry/widget/edit_buy_commodity.dart';
import 'package:krishiyan/screen/dashboard/enquiry/widget/edit_sell_commodity.dart';

myEnquiryWidget(BuildContext context, Function update) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Text(
          buildTranslate("myEnquiry")!,
          softWrap: true,
          style: const TextStyle(
              color: Color(0xFF3FC041),
              fontSize: 20,
              fontFamily: 'poppins-medium'),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Text(
          buildTranslate("selectYourCommodity")!,
          softWrap: true,
          style: const TextStyle(
              color: Colors.grey, fontSize: 15, fontFamily: 'poppins-semibold'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFd3d3d3), width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Container(
            width: 240,
            height: 60,
            color: Colors.white,
            child: Container(
              color: Colors.white,
              child: enquiryProvider!.cropData == null ||
                      enquiryProvider!.cropData!.data == null
                  ? Center(child: Text(buildTranslate("noDataAvailable")!))
                  : DropdownButtonFormField2<String>(
                      dropdownStyleData: DropdownStyleData(maxHeight: 200),
                      hint: Text(buildTranslate("selectYourCommodity")!),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
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
                        padding: EdgeInsets.symmetric(horizontal: 15),
                      ),
                      value: enquiryProvider!.selectedCrop,
                      items:
                          enquiryProvider!.cropData!.data!.map((String crop) {
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
                        enquiryProvider!.selectedCrop = newValue;
                        update();
                      },
                    ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: ElevatedButton(
            onPressed: () {
              if (enquiryProvider!.currentIndex == 0) {
                enquiryProvider!.futureEnquiryFilterData =
                    EnquiryDashboardController
                        .getEnquiryDetailsByFilterCommodity(
                            enquiryProvider!.selectedCrop.toString(), "Buy");
                enquiryProvider!.futureEnquiryFilterData =
                    enquiryProvider!.futureEnquiryFilterData;
              } else {
                enquiryProvider!.futureEnquiryFilterData =
                    EnquiryDashboardController
                        .getEnquiryDetailsByFilterCommodity(
                            enquiryProvider!.selectedCrop.toString(), "Sell");
                enquiryProvider!.futureEnquiryFilterData =
                    enquiryProvider!.futureEnquiryFilterData;
              }
              update();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
              textStyle: const TextStyle(fontSize: 15),
              backgroundColor: const Color(0xFF3FC041),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              ),
            ),
            child: Text(
              buildTranslate('SUBMIT')!,
              style:
                  const TextStyle(fontSize: 18, fontFamily: 'poppins-medium'),
            ),
          )),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            height: 45,
            alignment: Alignment.center,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFd3d3d3), width: 1),
                borderRadius: BorderRadius.circular(25)),
            child: ChipList(
              listOfChipNames: enquiryProvider!.chipNames,
              showCheckmark: false,
              extraOnToggle: (val) {
                enquiryProvider!.currentIndex = val;
                if (enquiryProvider!.currentIndex == 0) {
                  enquiryProvider!.futureEnquiryFilterData =
                      EnquiryDashboardController
                          .getEnquiryDetailsByFilterCommodity(
                              enquiryProvider!.selectedCrop.toString(), "Buy");

                  enquiryProvider!.futureEnquiryFilterData =
                      enquiryProvider!.futureEnquiryFilterData;
                } else {
                  enquiryProvider!.futureEnquiryFilterData =
                      EnquiryDashboardController
                          .getEnquiryDetailsByFilterCommodity(
                              enquiryProvider!.selectedCrop.toString(), "Sell");
                  enquiryProvider!.futureEnquiryFilterData =
                      enquiryProvider!.futureEnquiryFilterData;
                }
                enquiryProvider!.futureEnquiryFilterData =
                    enquiryProvider!.futureEnquiryFilterData;
                update();
                print("Chip index : ${enquiryProvider!.currentIndex}");
              },
              padding: const EdgeInsets.only(left: 30, right: 30),
              activeBgColorList: const [Color(0xFF2A9D8F)],
              inactiveBgColorList: const [Colors.white],
              activeTextColorList: const [Colors.white],
              inactiveTextColorList: const [Color(0xFF666666)],
              // borderColorList: [Theme.of(context).primaryColor],
              listOfChipIndicesCurrentlySelected: [
                enquiryProvider!.currentIndex
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      enquiryProvider!.futureEnquiryFilterData.toString().isNotEmpty
          ? FutureBuilder<List<EnquiryByFilterData>>(
              future: enquiryProvider!.futureEnquiryFilterData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");
                  return Center(
                      child: Text(buildTranslate("noDataAvailable")!));

                  // return Center(child: Text(snapshot.hasError.toString()));
                } else if (snapshot.hasData) {
                  final List<EnquiryByFilterData> enquiry = snapshot.data!;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: enquiry.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final enquiryFilterData = enquiry[index];
                      return Column(
                        children: [
                          Visibility(
                            visible: enquiryProvider!.currentIndex == 0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 30, left: 30),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 180,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            image: DecorationImage(
                                              image: enquiryFilterData
                                                              .photoVideoLink !=
                                                          null &&
                                                      enquiryFilterData
                                                          .photoVideoLink!
                                                          .isNotEmpty
                                                  ? NetworkImage(enquiryFilterData
                                                      .photoVideoLink!) // Use the URL from the API
                                                  : const AssetImage(
                                                          "assets/images/enquiryBG.png")
                                                      as ImageProvider, // Fallback to the default image
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 18, left: 18),
                                        child: IntrinsicWidth(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF008000),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 12,
                                                      right: 12,
                                                      top: 5,
                                                      bottom: 5),
                                                  child: Text(
                                                    'Price  Rs.${enquiryFilterData.price}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontFamily:
                                                            "poppins-semibold"),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ]),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Name : ${enquiryFilterData.commodity.toString()} ${enquiryFilterData.variety.toString()}",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Color(0xFF808080),
                                            fontSize: 15,
                                            fontFamily: 'poppins-semibold'),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: Text(
                                        "Purpose:  To ${enquiryFilterData.operation}",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Color(0xFF808080),
                                            fontSize: 15,
                                            fontFamily: 'poppins-semibold'),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: Text(
                                        "Quantity : ${enquiryFilterData.quantity.toString()}",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Color(0xFF808080),
                                            fontSize: 15,
                                            fontFamily: 'poppins-semibold'),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: Text(
                                        "Location : ${enquiryFilterData.location}",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Color(0xFF808080),
                                            fontSize: 15,
                                            fontFamily: 'poppins-semibold'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 20),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 40,
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditBuyCommodityPage(
                                                      enquiryData:
                                                          enquiryFilterData,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.all(3),
                                                textStyle: const TextStyle(
                                                    fontSize: 18),
                                                backgroundColor:
                                                    const Color(0xFF3FC041),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  buildTranslate('edit')!,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontFamily:
                                                        'poppins-medium',
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: enquiryProvider!.currentIndex == 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 30, left: 30),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 180,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            image: DecorationImage(
                                              image: enquiryFilterData
                                                              .photoVideoLink !=
                                                          null &&
                                                      enquiryFilterData
                                                          .photoVideoLink!
                                                          .isNotEmpty
                                                  ? NetworkImage(enquiryFilterData
                                                      .photoVideoLink!) // Use the URL from the API
                                                  : const AssetImage(
                                                          "assets/images/enquiryBG.png")
                                                      as ImageProvider, // Fallback to the default image
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 18, left: 18),
                                        child: IntrinsicWidth(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF008000),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                            ),
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 12,
                                                      right: 12,
                                                      top: 5,
                                                      bottom: 5),
                                                  child: Text(
                                                    'Price  Rs.${enquiryFilterData.price}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontFamily:
                                                            "poppins-semibold"),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ]),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Name : ${enquiryFilterData.commodity.toString()} ${enquiryFilterData.variety.toString()}",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Color(0xFF808080),
                                            fontSize: 15,
                                            fontFamily: 'poppins-semibold'),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: Text(
                                        "Purpose:  To ${enquiryFilterData.operation}",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Color(0xFF808080),
                                            fontSize: 15,
                                            fontFamily: 'poppins-semibold'),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: Text(
                                        "Quantity : ${enquiryFilterData.quantity.toString()}",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Color(0xFF808080),
                                            fontSize: 15,
                                            fontFamily: 'poppins-semibold'),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: Text(
                                        "Location : ${enquiryFilterData.location}",
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Color(0xFF808080),
                                            fontSize: 15,
                                            fontFamily: 'poppins-semibold'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 20),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 40,
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditSellCommodityPage(
                                                      enquiryData:
                                                          enquiryFilterData,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.all(3),
                                                textStyle: const TextStyle(
                                                    fontSize: 18),
                                                backgroundColor:
                                                    const Color(0xFF3FC041),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // <-- Radius
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  buildTranslate('edit')!,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily:
                                                          'poppins-medium'),
                                                ),
                                              ),
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Center(
                      child: Text(buildTranslate("noDataAvailable")!));
                }
              },
            )
          : Center(child: Text(buildTranslate("noDataAvailable")!)),
      const SizedBox(
        height: 40,
      ),
    ],
  );
}
