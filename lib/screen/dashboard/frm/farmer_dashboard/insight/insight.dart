import 'package:flutter/material.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:krishiyan/mvc/model/frm_insight_model.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/screen/dashboard/enquiry/enquiry_model.dart';
import 'package:krishiyan/screen/dashboard/frm/farmer_dashboard/insight/farmer_listing/farmer_listing.dart';

class FourthTab extends StatefulWidget {
  const FourthTab({
    Key? key,
  }) : super(key: key);

  @override
  _FourthTabState createState() => _FourthTabState();
}

class _FourthTabState extends State<FourthTab> {
  setStateNow() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(18)),
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
                      fontFamily: 'poppins-semibold',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          alignment: Alignment.bottomCenter,
                          child: DropdownButtonFormField2<String>(
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 200,
                            ),
                            hint: Text(buildTranslate("selectCrops")!),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
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
                                child: Text(
                                  crop,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontFamily: 'poppins-regular',
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              frmProvider!.selectedCrop = newValue;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      const VerticalDivider(width: 10),
                      Container(
                        width: 80,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            buildTranslate("crops")!,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'poppins-regular',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // select villages
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          alignment: Alignment.bottomCenter,
                          child: DropdownButtonFormField2<String>(
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 200,
                            ),
                            hint: Text(buildTranslate("selectVillages")!),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
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
                            items: frmProvider!.villageNameData!.data!.map((
                              String crop,
                            ) {
                              return DropdownMenuItem<String>(
                                value: crop,
                                child: Text(
                                  crop,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontFamily: 'poppins-regular',
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              frmProvider!.selectedVillageName = newValue;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      const VerticalDivider(width: 10),
                      Container(
                        width: 80,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            buildTranslate("villages")!,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'poppins-regular',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (frmProvider!.selectedCrop != null &&
                            frmProvider!.selectedVillageName != null) {
                          // Initialize the future here, which will trigger the API request
                          frmProvider!.futureFrminSight =
                              frmProvider!.fetchInsightsData(false);
                          frmProvider!.searchCropsFlag = true;
                          setState(() {});
                        } else {
                          // Show an error or prompt to select both crop and village
                          print('Please select both crop and village');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: const Color(0xFF3FC041),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        buildTranslate('SEARCH')!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'poppins-medium',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Visibility(
          visible: true, // frmProvider!.searchCropsFlag,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    frmProvider!.selectedTopData == 3
                        ? FutureBuilder<FrmInsight?>(
                            future: frmProvider!.futureFrminSight,
                            builder: (context, snapshot) {
                              // Log the connection state and snapshot data
                              print(
                                  'Connection State: ${snapshot.connectionState}');
                              print('Has data: ${snapshot.hasData}');
                              print('Error:: ${snapshot.error}');
                              print('Data: ${snapshot.data}');
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return listWidget(
                                  null,
                                  setStateNow,
                                );
                              } else if (snapshot.hasError) {
                                return listWidget(
                                  null,
                                  setStateNow,
                                );
                              } else if (!snapshot.hasData) {
                                return listWidget(
                                  null,
                                  setStateNow,
                                );
                              } else {
                                FrmInsight? frminSight = snapshot.data;
                                // if (frminSight == null) {
                                //   return const Center(
                                //       child: Text('No data available.'));
                                // }
                                // print('Has data: ${frminSight.data}');
                                return listWidget(
                                  frminSight,
                                  setStateNow,
                                );
                              }
                            },
                          )
                        : getFarmerListing(
                            context,
                            setStateNow,
                          ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

Widget listWidget(FrmInsight? frminSight, Function update) {
  if (frminSight == null) {
    frmProvider!.isNull = true;
  } else {
    frmProvider!.isNull = false;
  }
  print('i am here ');
  List<cropsCategory> search_crops = [
    cropsCategory(
      name: "Total Farmer",
      id: "1",
      icon: 'assets/images/crops1.png',
    ),
    cropsCategory(
        name: "Total Farmer Land(in HA)",
        id: "2",
        icon: 'assets/images/crops2.png'),
    cropsCategory(
        name: "Expected Yield(in Qtl)",
        id: "3",
        icon: 'assets/images/crops1.png'),
  ];
  // Extracting required data from the API response
  int totalfarmers = frminSight == null
      ? frmProvider!.farmerDataList.length
      : frminSight.data.numberOfFarmers;
  int totalLandInAcres = frminSight == null
      ? () {
          int value = 0;
          for (var farmer in frmProvider!.farmerDataList) {
            print('farmer : ${farmer.cropCultivationDetails}');
            if (farmer.cropCultivationDetails != null) {
              for (var crop in farmer.cropCultivationDetails!) {
                value += crop.areaInAcres.toInt();
              }
            }
          }
          return value;
        }()
      : frminSight.data.totalAreaInAcres;
  int expectedYield = frminSight == null
      ? 0
      : () {
          int value = 0;
          for (var farmer in frminSight.data.farmers) {
            print('farmer : ${farmer.expectedYield}');
            value += farmer.expectedYield;
          }
          return value;
        }();
  // You may need to fetch the expected yield for each crop if it's provided in the data
  // For now, we assume it's a generic value across the crops.
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: search_crops.length,
    itemBuilder: (_, index) {
      String displayText = '';

      // Condition to decide which value to display based on index
      if (index == 0) {
        // First index, show total number of farmers
        displayText =
            '$totalfarmers Farmers\n${search_crops[index].name ?? ""}';
      } else if (index == 1) {
        // Second index, show total land in acres
        displayText =
            '$totalLandInAcres Acres\n${search_crops[index].name ?? ""}';
      } else if (index == 2) {
        // Third index, show expected yield
        displayText =
            '$expectedYield Expected Yield\n${search_crops[index].name ?? ""}';
      } else {
        // For other items, show just the crop name
        displayText = search_crops[index].name ?? "";
      }

      return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [BoxShadow(color: Color(0xFFd3d3d3))],
            border: Border.all(color: const Color(0xFFd3d3d3), width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
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
                      frmProvider!.fetchInsightsData(false);
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
                  search_crops[index].icon ?? "",
                  width: 35,
                  height: 35,
                ),
                const SizedBox(height: 5),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      displayText,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 15,
                        fontFamily: 'poppins-regular',
                      ),
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
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
    ),
  );
}
