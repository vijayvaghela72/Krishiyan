import 'package:flutter/material.dart';
import 'dashboard/enquiry_dashboard.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:krishiyan/localization/app_localizations.dart';

viewEnquery(BuildContext context, Function update) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Text(
          buildTranslate("enquiryDashboard")!,
          softWrap: true,
          style: const TextStyle(
            color: Color(0xFF3FC041),
            fontSize: 20,
            fontFamily: 'poppins-medium',
          ),
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
            color: Colors.grey,
            fontSize: 15,
            fontFamily: 'poppins-semibold',
          ),
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
            height: 50,
            color: Colors.white,
            child: Container(
              color: Colors.white,
              child: enquiryProvider!.cropData == null ||
                      enquiryProvider!.cropData!.data == null
                  ? Center(
                      child: Text(
                        buildTranslate("noDataAvailable")!,
                      ),
                    )
                  : DropdownButtonFormField2<String>(
                      dropdownStyleData: DropdownStyleData(maxHeight: 200),
                      hint: Text(
                        buildTranslate("selectYourCommodity")!,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
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
                        padding: EdgeInsets.symmetric(horizontal: 16),
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
            if (enquiryProvider!.selectedCrop != null &&
                enquiryProvider!.selectedCrop!.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EnquiryDashboardPage(
                    selectedCrop: enquiryProvider!.selectedCrop,
                  ),
                ),
              );
            }
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
            style: const TextStyle(fontSize: 18, fontFamily: 'poppins-medium'),
          ),
        ),
      ),
    ],
  );
}
