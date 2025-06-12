import 'package:flutter/material.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/mvc/model/crop_name_model.dart';
import 'package:krishiyan/mvc/model/enquiry_by_filter_model.dart';
import 'package:krishiyan/screen/dashboard/enquiry/enquiry_model.dart';

class EnquiryProvider extends ChangeNotifier {
  // Main Data Variable

  var bottomNavIndex = 0;
  int currentIndex = 0;
  int selectedTopData = 0;

  // first Tab Selected (View Enquiry)
  SelectCropNamesData? cropData;
  String? selectedCrop;

  // second Tab Selected (Post Enquiry)

  List<Enquiry> postEnquiry = [
    Enquiry(
      name: buildTranslate("buy"),
      icon: "assets/images/buy.png",
      id: "1",
    ),
    Enquiry(
      name: buildTranslate("sell"),
      icon: "assets/images/sell.png",
      id: "2",
    ),
  ];

  // third Tab Selected (My Enquiry)
  Future<List<EnquiryByFilterData>>? futureEnquiryFilterData;
  final List<String> chipNames = [
    buildTranslate("buy")!,
    buildTranslate("sell")!,
    'Wishlist',
  ];

  //

  initalizeVarible(Function update) {
    bottomNavIndex = 0;
    currentIndex = 0;
    selectedTopData = 0;
    selectedCrop = null;
    cropData = null;
    update();
  }
}
