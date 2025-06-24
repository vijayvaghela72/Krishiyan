import 'package:flutter/material.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/mvc/model/frm_insight_model.dart';
import 'package:krishiyan/localization/app_localizations.dart';

Future<FrmInsight?> data() async {
  return FrmInsight.fromJson({
    "success": true,
    "message": "Intersected farmers' data retrieved successfully",
    "data": {
      "farmers": frmProvider!.farmerDataList.map((farmer) {
        // Get the first crop details if available, otherwise use defaults
        final cropDetails = farmer.cropCultivationDetails != null &&
                farmer.cropCultivationDetails!.isNotEmpty
            ? farmer.cropCultivationDetails!.first
            : null;

        return {
          "name": farmer.farmerDetails.name,
          "whatsappNumber": farmer.farmerDetails.whatsappNumber,
          "crop": cropDetails?.crops ?? "Unknown",
          "areaInAcres": cropDetails?.areaInAcres.toInt() ?? 0,
          "expectedYield": 0,
        };
      }).toList(),
      "totalAreaInAcres": () {
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
      }(),
      "numberOfFarmers": frmProvider!.farmerDataList.length,
    }
  });
}

getFarmerListing(
  BuildContext context,
  Function setStateNow,
) {
  if (frmProvider!.isNull) {
    frmProvider!.futureFrminSight = data();
  }
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                frmProvider!.selectedTopData = 3;
                setStateNow();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 25,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              buildTranslate("goBack")!,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'poppins-medium',
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 25, right: 20, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF73C187),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: FutureBuilder<FrmInsight?>(
                  future: frmProvider!.futureFrminSight,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData) {
                      return Center(
                        child: Text('No data available.'),
                      );
                    } else {
                      FrmInsight? frminSight = snapshot.data;
                      int totalFarmers = frminSight?.data.numberOfFarmers ?? 0;
                      print(totalFarmers);
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              "Farmers($totalFarmers)",
                              softWrap: true,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'poppins-semibold',
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            const Spacer(),
            // Padding(
            //   padding: const EdgeInsets.only(right: 8),
            //   child: Container(
            //     width: 150,
            //     height: 40,
            //     color: Colors.white,
            //     child: DropdownButtonFormField2<String>(
            //       isExpanded: true,
            //       decoration: InputDecoration(
            //         contentPadding: const EdgeInsets.symmetric(vertical: 5),
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(8),
            //           borderSide: const BorderSide(
            //             color: Colors.grey,
            //             width: 1,
            //           ),
            //         ),
            //       ),
            //       hint: Text(
            //         buildTranslate('sortBy')!,
            //         style: const TextStyle(fontSize: 10),
            //       ),
            //       items: sortItems
            //           .map(
            //             (item) => DropdownMenuItem<String>(
            //               value: item,
            //               child: Text(
            //                 item,
            //                 style: const TextStyle(
            //                   fontSize: 10,
            //                   color: Colors.grey,
            //                 ),
            //               ),
            //             ),
            //           )
            //           .toList(),
            //       onChanged: (value) {
            //         frmProvider!.futureFrminSight =
            //             frmProvider!.fetchInsightsData(false);
            //         setStateNow();
            //         //Do something when selected item is changed.
            //       },
            //       onSaved: (value) {
            //         frmProvider!.selectedSortItemsValue = value.toString();
            //       },
            //       buttonStyleData: const ButtonStyleData(
            //         padding: EdgeInsets.only(right: 10),
            //       ),
            //       iconStyleData: const IconStyleData(
            //         icon: ImageIcon(AssetImage('assets/images/sortBy.png')),
            //         iconSize: 20,
            //         iconEnabledColor: Colors.black,
            //       ),
            //       menuItemStyleData: const MenuItemStyleData(
            //         padding: EdgeInsets.symmetric(horizontal: 16),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      const SizedBox(
        height: 35,
      ),
      _buildHeaderTable(),
      FutureBuilder<FrmInsight?>(
        future: frmProvider!.futureFrminSight,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available.'));
          } else {
            FrmInsight? frminSight = snapshot.data;
            if (frminSight == null || frminSight.data.farmers.isEmpty) {
              return Center(
                child: Text('No farmers data available.'),
              );
            }
            var farmers = snapshot.data?.data.farmers ?? [];
            if (frmProvider!.selectedSortItemsValue ==
                buildTranslate("highExpYield")) {
              farmers
                  .sort((a, b) => b.expectedYield.compareTo(a.expectedYield));
            } else if (frmProvider!.selectedSortItemsValue ==
                buildTranslate("lowExpYield")) {
              farmers
                  .sort((a, b) => a.expectedYield.compareTo(b.expectedYield));
            }
            return Column(
              children: [
                buildTable(context, frminSight),
              ],
            );
          }
        },
      )
    ],
  );
}

final List<String> sortItems = [
  buildTranslate("highExpYield")!,
  buildTranslate("lowExpYield")!,
];

Widget _buildHeaderTable() {
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25),
    child: Container(
      width: double.maxFinite,
      height: 70,
      padding: const EdgeInsets.fromLTRB(10, 16, 45, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF73C187),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _titleHeaderTable('Name', 3),
          _titleHeaderTable('Mobile \nNumber', 4),
          _titleHeaderTable('Expected Yield \n(in Qtl)', 2),
        ],
      ),
    ),
  );
}

Widget _titleHeaderTable(String title, int flexNum) {
  return Expanded(
    flex: flexNum,
    child: Container(
      child: Text(
        title,
        textAlign: TextAlign.left,
        maxLines: 2,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontFamily: "poppins-semibold",
        ),
      ),
    ),
  );
}

buildTable(BuildContext context, FrmInsight frminSight) {
  return Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.black),
    child: Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(4),
          1: FlexColumnWidth(5),
          2: FlexColumnWidth(5),
        },
        border: TableBorder.all(),
        children: [
          for (var farmer in frminSight.data.farmers)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    farmer.name,
                    style: const TextStyle(
                      fontFamily: "poppins-semibold",
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    farmer.whatsappNumber,
                    style: const TextStyle(
                      fontFamily: "poppins-regular",
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    farmer.expectedYield.toString(),
                    style: const TextStyle(
                      fontFamily: "poppins-regular",
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}
