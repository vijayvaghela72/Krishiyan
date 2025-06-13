import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:krishiyan/helper/constant.dart';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/helper/snackbar.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/mvc/model/crop_name_model.dart';
import 'package:krishiyan/mvc/model/enquiry_by_filter_model.dart';
import 'package:krishiyan/screen/dashboard/enquiry/enquiry_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> fetchCropData(Function update) async {
    try {
      final response = await getAPICall(apiUrl: CROPS_NAMES);
      if (response.statusCode == 200) {
        cropData = SelectCropNamesData.fromJson(jsonDecode(response.body));
        update();
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (e) {
      print('My BottomCenterEnquiry : Error fetching crop data: $e');
    }
  }

  initalizeVarible(Function update) {
    bottomNavIndex = 0;
    currentIndex = 0;
    selectedTopData = 0;
    selectedCrop = null;
    cropData = null;
    update();
  }

  List<WishlistItem> wishList = [];
  getWishList() async {
    print('Testing A ');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = await prefs.get('id').toString();
    final response = await getAPICall(
      apiUrl: '${baseUrl}wishlist/?userId=$userId',
    );
    if (response.statusCode == 200) {
      wishList = WishlistResponse.fromJson(json.decode(response.body)).wishlist;
    } else {
      throw Exception('Failed to load wishlist');
    }
  }

  getRemoveFromWishList(
    String whishListId,
    int index,
    Function update,
  ) async {
    print('Testing B ');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = await prefs.get('id').toString();
    showLoading();
    final response = await deleteAPICall(
      apiUrl: '${baseUrl}wishlist/remove/whishListId',
      parameter: json.encode({'userId': userId}),
    );
    stopLoading();
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setSnackbar(data['message']);
      wishList.removeAt(index);
      update();
    } else {
      setSnackbar('Failed to load wishlist');
      update();
      throw Exception('Failed to load wishlist');
    }
  }
}
