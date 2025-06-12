import 'package:flutter/material.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/screen/dashboard/enquiry/post_enquiry/buy_commodity/buy_commodity.dart';
import 'package:krishiyan/screen/dashboard/enquiry/post_enquiry/sell_commodity/sell_commodity.dart';

postEnquiryWidget(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Text(
          buildTranslate("postEnquiry")!,
          softWrap: true,
          style: const TextStyle(
            color: Color(0xFF3FC041),
            fontSize: 20,
            fontFamily: 'poppins-medium',
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: enquiryProvider!.postEnquiry.length,
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                if (enquiryProvider!.postEnquiry[index].id == "1") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BuyCommodityPage(),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SellCommodityPage(),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFd3d3d3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(22)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        enquiryProvider!.postEnquiry[index].icon ?? "",
                        color: Colors.grey,
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        enquiryProvider!.postEnquiry[index].name ?? "",
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 15,
                          fontFamily: 'poppins-regular',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
        ),
      ),
    ],
  );
}
