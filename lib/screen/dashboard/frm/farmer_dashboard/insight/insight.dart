import 'package:flutter/material.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:krishiyan/mvc/model/frm_insight_model.dart';
import 'package:krishiyan/localization/app_localizations.dart';

Column fourthTabData(BuildContext context, Function update) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // select crops
                Text(
                  buildTranslate("searchByCrops/Villages")!,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'poppins-semibold'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.bottomCenter,
                        child: DropdownButtonFormField2<String>(
                          dropdownStyleData:
                              const DropdownStyleData(maxHeight: 200),
                          hint: Text(buildTranslate("selectCrops")!),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
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
                          value: frmProvider!.selectedCrop,
                          items: frmProvider!.crops.map((String crop) {
                            return DropdownMenuItem<String>(
                              value: crop,
                              child: Text(crop,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontFamily: 'poppins-regular')),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            frmProvider!.selectedCrop = newValue;
                            update();
                          },
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      width: 10,
                    ),
                    Container(
                      width: 80,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Center(
                        child: Text(
                          buildTranslate("crops")!,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'poppins-regular'),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                // select villages
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.bottomCenter,
                        child: DropdownButtonFormField2<String>(
                          dropdownStyleData:
                              const DropdownStyleData(maxHeight: 200),
                          hint: Text(buildTranslate("selectVillages")!),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
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
                          value: frmProvider!.selectedVillageName,
                          items: frmProvider!.villageNameData!.data!
                              .map((String crop) {
                            return DropdownMenuItem<String>(
                              value: crop,
                              child: Text(crop,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontFamily: 'poppins-regular')),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            frmProvider!.selectedVillageName = newValue;
                            update();
                          },
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      width: 10,
                    ),
                    Container(
                      width: 80,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Center(
                        child: Text(
                          buildTranslate("villages")!,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'poppins-regular'),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (frmProvider!.selectedCrop != null &&
                            frmProvider!.selectedVillageName != null) {
                          // Initialize the future here, which will trigger the API request
                          frmProvider!.futureFrminSight =
                              frmProvider!.fetchInsightsData();
                          update();
                        } else {
                          // Show an error or prompt to select both crop and village
                          print('Please select both crop and village');
                        }
                        frmProvider!.searchCropsFlag = true;
                        update();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: const Color(0xFF3FC041),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // <-- Radius
                        ),
                      ),
                      child: Text(
                        buildTranslate('SEARCH')!,
                        style: const TextStyle(
                            fontSize: 18, fontFamily: 'poppins-medium'),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Visibility(
        visible: frmProvider!.searchCropsFlag,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  FutureBuilder<FrmInsight?>(
                    future: frmProvider!.futureFrminSight,
                    builder: (context, snapshot) {
                      // Log the connection state and snapshot data
                      print('Connection State: ${snapshot.connectionState}');
                      print('Has data: ${snapshot.hasData}');
                      print('Error:: ${snapshot.error}');
                      print('Data: ${snapshot.data}');

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:
                                CircularProgressIndicator()); // Loading state
                      } else if (snapshot.hasError) {
                        // Handle the error case
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        // Handle the case where there's no data
                        return Center(child: Text('No data available.'));
                      } else {
                        FrmInsight? frminSight = snapshot.data;
                        if (frminSight == null) {
                          return Center(child: Text('No data available.'));
                        }
                        print('Has data: ${frminSight.data}');
                        return listWidget(
                          frminSight,
                          update,
                        ); // Your list display widget
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
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
    ],
  );
}

Widget listWidget(FrmInsight frminSight, Function update) {
  // Extracting required data from the API response
  int totalfarmers = frminSight.data.numberOfFarmers;
  int totalLandInAcres = frminSight.data.totalAreaInAcres;
  int expectedYield = 0; // Default value, can be updated if needed

  // You may need to fetch the expected yield for each crop if it's provided in the data
  // For now, we assume it's a generic value across the crops.
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: frmProvider!.search_crops.length,
    itemBuilder: (_, index) {
      String displayText = '';

      // Condition to decide which value to display based on index
      if (index == 0) {
        // First index, show total number of farmers
        displayText =
            '$totalfarmers Farmers\n${frmProvider!.search_crops[index].name ?? ""}';
      } else if (index == 1) {
        // Second index, show total land in acres
        displayText =
            '$totalLandInAcres Acres\n${frmProvider!.search_crops[index].name ?? ""}';
      } else if (index == 2) {
        // Third index, show expected yield
        displayText =
            '$expectedYield Expected Yield\n${frmProvider!.search_crops[index].name ?? ""}';
      } else {
        // For other items, show just the crop name
        displayText = frmProvider!.search_crops[index].name ?? "";
      }

      return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFd3d3d3),
                )
              ],
              border: Border.all(color: const Color(0xFFd3d3d3), width: 1),
              borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              // Only set selectedTopData to 4 if the index is 0
              if (index == 0) {
                frmProvider!.selectedTopData = 4;
                update();
                if (frmProvider!.selectedCrop != null &&
                    frmProvider!.selectedVillageName != null) {
                  // Initialize the future here, which will trigger the API request
                  frmProvider!.futureFrminSight =
                      frmProvider!.fetchInsightsData();
                  update();
                } else {
                  // Show an error or prompt to select both crop and village
                  print('Please select both crop and village');
                }
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  frmProvider!.search_crops[index].icon ?? "",
                  width: 35,
                  height: 35,
                ),
                const SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      displayText, // Display the dynamic text based on the index
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 2,
                      style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 15,
                          fontFamily: 'poppins-regular'),
                    ),
                  ),
                ),
                index == 0
                    ? Image.asset(
                        "assets/images/right_arrow.png",
                        width: 25,
                        height: 25,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      );
    },
    gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  );
}
