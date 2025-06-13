import 'helper/price_history_page.dart';
import 'package:flutter/material.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/screen/dashboard/home/widget/helper/mandi_district.dart';
import 'package:krishiyan/screen/dashboard/home/widget/helper/commodity_sheet.dart';
import 'package:krishiyan/screen/dashboard/home/widget/helper/state_bottom_sheet.dart';

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
                                left: 15, right: 15, top: 15),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PriceHistoryPage(
                                      commodityId: homeProvider!
                                          .marketInsightList[index].id,
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
