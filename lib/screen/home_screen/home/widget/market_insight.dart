import '../../PriceHistoryPage.dart';
import 'package:flutter/material.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';

// ignore: must_be_immutable
class MarketInsightScreen extends StatefulWidget {
  Function update;
  MarketInsightScreen({
    super.key,
    required this.update,
  });

  @override
  State<MarketInsightScreen> createState() => _MarketInsightScreenState();
}

class _MarketInsightScreenState extends State<MarketInsightScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                  homeProvider!.mandiStateList.isEmpty
                      ? Center(child: Text(buildTranslate("noDataAvailable")!))
                      : Container(
                          color: Colors.white,
                          child: DropdownButtonFormField2<String>(
                            isExpanded: true,
                            dropdownStyleData:
                                const DropdownStyleData(maxHeight: 200),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            hint: Text(
                              buildTranslate("selectState")!,
                              style: const TextStyle(
                                  fontSize: 13, fontFamily: "poppins-regular"),
                            ),
                            items: homeProvider!.mandiStateList
                                .map((String crop1) {
                              return DropdownMenuItem<String>(
                                value: crop1,
                                child: Text(crop1,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontFamily: 'poppins-regular')),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select type of state.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              homeProvider!.selectedMarketStateItemValue =
                                  value;
                              homeProvider!.selectedMarketDistrictItemValue =
                                  null;
                              setState(() {});
                              if (homeProvider!.selectedMarketStateItemValue !=
                                  null) {
                                print(
                                    "selectedMarketStateItemValue : ${homeProvider!.selectedMarketStateItemValue}");
                                homeProvider!
                                    .fetchMarketDistrictData(widget.update);
                              }
                            },
                            onSaved: (value) {
                              homeProvider!.selectedMarketStateItemValue =
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
                  homeProvider!.districtMarketItems == null ||
                          homeProvider!.districtMarketItems!.data == null
                      ? Container(
                          color: Colors.white,
                          child: DropdownButtonFormField2<String>(
                            isExpanded: true,
                            dropdownStyleData:
                                const DropdownStyleData(maxHeight: 200),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // Add more decoration..
                            ),
                            hint: Text(
                              buildTranslate("selectDistrict")!,
                              style: const TextStyle(
                                  fontSize: 13, fontFamily: "poppins-regular"),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select type of district.';
                              }
                              return null;
                            },
                            onChanged: (value) {},
                            onSaved: (value) {},
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
                            items: [],
                          ),
                        )
                      : Container(
                          color: Colors.white,
                          child: DropdownButtonFormField2<String>(
                            isExpanded: true,
                            dropdownStyleData:
                                const DropdownStyleData(maxHeight: 200),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            hint: Text(
                              buildTranslate("selectDistrict")!,
                              style: const TextStyle(
                                  fontSize: 13, fontFamily: "poppins-regular"),
                            ),
                            items: homeProvider!.districtMarketItems!.data!
                                .map((String crop) {
                              return DropdownMenuItem<String>(
                                value: crop,
                                child: Text(crop,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontFamily: 'poppins-regular')),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select type of district.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                homeProvider!.selectedMarketDistrictItemValue =
                                    value;
                              });
                              homeProvider!.commodityMarketItems = null;
                              print(
                                  "selectedMarketDistrictItemValue : ${homeProvider!.selectedMarketDistrictItemValue}");
                              homeProvider!
                                  .fetchMarketCommodityData(widget.update);
                            },
                            onSaved: (value) {
                              homeProvider!.selectedMarketDistrictItemValue =
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
                  homeProvider!.commodityMarketItems == null ||
                          homeProvider!.commodityMarketItems!.data == null
                      ? Container(
                          color: Colors.white,
                          child: DropdownButtonFormField2<String>(
                            isExpanded: true,
                            dropdownStyleData:
                                const DropdownStyleData(maxHeight: 200),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // Add more decoration..
                            ),
                            hint: Text(
                              buildTranslate("selectCommodity")!,
                              style: const TextStyle(
                                  fontSize: 13, fontFamily: "poppins-regular"),
                            ),
                            items: [],
                            validator: (value) {
                              if (value == null) {
                                return 'Please select type of district.';
                              }
                              return null;
                            },
                            onChanged: (value) {},
                            onSaved: (value) {},
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
                        )
                      : Container(
                          color: Colors.white,
                          child: DropdownButtonFormField2<String>(
                            isExpanded: true,
                            dropdownStyleData:
                                const DropdownStyleData(maxHeight: 200),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // Add more decoration..
                            ),
                            hint: Text(
                              buildTranslate("selectCommodity")!,
                              style: const TextStyle(
                                  fontSize: 13, fontFamily: "poppins-regular"),
                            ),
                            items: homeProvider!.commodityMarketItems!.data!
                                .map((String crop) {
                              return DropdownMenuItem<String>(
                                value: crop,
                                child: Text(crop,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontFamily: 'poppins-regular')),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select type of district.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                homeProvider!.selectedMarketCommodityItemValue =
                                    value!;
                              });
                              print(
                                  "selectedMarketCommodityItemValue : ${homeProvider!.selectedMarketCommodityItemValue}");
                            },
                            onSaved: (value) {
                              homeProvider!.selectedMarketCommodityItemValue =
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
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          homeProvider!
                              .getMarketInsight(widget.update, context);
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
        homeProvider!.marketInsightList.isEmpty
            ? Center(child: Text(buildTranslate("noDataAvailable")!))
            : ListView.builder(
                itemCount: homeProvider!.marketInsightList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
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
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      homeProvider!
                                              .marketInsightList[index].state ??
                                          "Not Available",
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                    Container(
                                      width: 80, // Set the specific width here
                                      child: Text(
                                        homeProvider!.marketInsightList[index]
                                                .market ??
                                            "",
                                        softWrap: true,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'poppins-semibold',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  homeProvider!
                                          .marketInsightList[index].commodity ??
                                      "Not Available",
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'poppins-semibold'),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Today",
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                    Text(
                                      homeProvider!
                                          .marketInsightList[index].todaysPrice
                                          .toString(),
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                    Text(
                                      homeProvider!.marketInsightList[index]
                                          .todaysPriceChange
                                          .toString(),
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Yesterday",
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                    Text(
                                      homeProvider!.marketInsightList[index]
                                          .yesterdaysPrice
                                          .toString(),
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                    Text(
                                      homeProvider!.marketInsightList[index]
                                          .yesterdaysPriceChange
                                          .toString(),
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PriceHistoryPage(
                                      commodityId: homeProvider!
                                          .marketInsightList[index]
                                          .primaryKey, // Pass the primary key here
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(
                                    0xFF959595), // Keep the text color the same
                                overlayColor: Colors
                                    .transparent, // Remove the hover effect
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    "assets/images/right_arrow.png",
                                    width: 10,
                                    height: 10,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "View More",
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Color(0xFF959595),
                                        fontSize: 11,
                                        fontFamily: 'poppins-regular'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        const SizedBox(
          height: 60,
        ),
      ],
    );
  }
}
