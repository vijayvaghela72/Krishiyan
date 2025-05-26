// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/Constants.dart';
import 'library_screens/FaqPage.dart';
import 'library_screens/CropProtectionPage.dart';
import 'library_screens/HarvestPage.dart';
import 'library_screens/MyVeritiesPage.dart';
import '../../Language/SelectLanguagePage.dart';
import '../../../mvc/model/CropLibraryData.dart';
import '../../../localization/AppLocalizations.dart';
import '../../../mvc/controller/cropController.dart';
import '../../../mvc/model/SelectCropNamesData.dart';
import 'library_screens/NutrientManagmentPage.dart';
import 'library_screens/general_Info.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'library_screens/IrrigationManagementPage.dart';
import 'library_screens/MyProSawingPracticesPage.dart';

class CropLibraryScreen extends StatefulWidget {
  bool aapbarVisibility;

  CropLibraryScreen({
    super.key,
    required this.aapbarVisibility,
  });

  @override
  State<CropLibraryScreen> createState() => _CropLibraryScreenState();
}

class _CropLibraryScreenState extends State<CropLibraryScreen>
    with TickerProviderStateMixin {
  List<Entity> ORG_Entity = [
    Entity(
      name: buildTranslate("generalInformation")!,
      id: "1",
    ),
    Entity(
      name: buildTranslate("varieties")!,
      id: "2",
    ),
    Entity(
      name: buildTranslate("preSowingPractices")!,
      id: "3",
    ),
    Entity(
      name: buildTranslate("nutrientManagement")!,
      id: "4",
    ),
    Entity(
      name: buildTranslate("cropProtection")!,
      id: "5",
    ),
    Entity(
      name: buildTranslate("irrigationManagement")!,
      id: "6",
    ),
    Entity(
      name: buildTranslate("harvest")!,
      id: "7",
    ),
    Entity(
      name: buildTranslate("FAQs")!,
      id: "8",
    ),
  ];

  bool showSelectedItemValue = false;
  late Future<List<CropLibraryData>?> futureCropData;
  String? _selectedCrop;
  SelectCropNamesData? _cropData;

  @override
  void initState() {
    super.initState();
    _fetchCropData();
  }

  Future<void> _fetchCropData() async {
    try {
      // Replace with your actual API endpoint
      var response = await getAPICall(apiUrl: CROPS_NAMES);

      if (response.statusCode == 200) {
        _cropData = SelectCropNamesData.fromJson(jsonDecode(response.body));
        futureCropData = CropController.fetchCrop(_cropData!.data!.first);
        setState(() {});
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (e) {
      print('My CropLibraryScreen : Error fetching crop data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: widget.aapbarVisibility
          ? AppBar(
              automaticallyImplyLeading: false,
              title: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const SelectLanguagePage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/loginLogo.png',
                      width: 150,
                      height: 60,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0, top: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/language.png',
                            width: 35,
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                buildTranslate("cropLibrary")!,
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
            // type of entity
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("selectTheCrop")!,
                style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                    fontFamily: 'poppins-semibold'),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: _cropData == null || _cropData!.data == null
                  ? Center(child: Text(buildTranslate("noDataAvailable")!))
                  : DropdownButtonFormField2<String>(
                      dropdownStyleData: DropdownStyleData(maxHeight: 200),
                      hint: Text(buildTranslate("selectCrops")!),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
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
                      value: _selectedCrop,
                      items: _cropData!.data!.map((String crop) {
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
                        setState(() {
                          _selectedCrop = newValue;
                        });
                      },
                    ),
            ),
            const SizedBox(
              height: 25,
            ),

            Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: ElevatedButton(
                  onPressed: () {
                    // if(selectedItemValue.isNotEmpty){
                    setState(() {
                      showSelectedItemValue = true;
                    });
                    // }
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
                    style: const TextStyle(
                        fontSize: 18, fontFamily: 'poppins-medium'),
                  ),
                )),
            const SizedBox(
              height: 25,
            ),
            showSelectedItemValue ? listWidget() : Container(),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget listWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ORG_Entity.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFd3d3d3), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFd3d3d3),
                    )
                  ],
                  borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  if (ORG_Entity[index].id == "1") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => GeneralInformationPage(
                              aapbarVisibility: true,
                              cropData: futureCropData,
                              selectedcrop: _selectedCrop ?? '')),
                    );
                  } else if (ORG_Entity[index].id == "2") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MyVeritiesPage(
                              aapbarVisibility: true,
                              cropData: futureCropData,
                              selectedcrop: _selectedCrop ?? '')),
                    );
                  } else if (ORG_Entity[index].id == "3") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MyProSawingPracticesPage(
                              aapbarVisibility: true,
                              cropData: futureCropData,
                              selectedcrop: _selectedCrop ?? '')),
                    );
                  } else if (ORG_Entity[index].id == "4") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => NutrientManagmentPage(
                              aapbarVisibility: true,
                              cropData: futureCropData,
                              selectedcrop: _selectedCrop ?? '')),
                    );
                  } else if (ORG_Entity[index].id == "5") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => CropProtectionPage(
                              aapbarVisibility: true,
                              cropData: futureCropData,
                              selectedcrop: _selectedCrop ?? '')),
                    );
                  } else if (ORG_Entity[index].id == "6") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => IrrigationManagementPage(
                              aapbarVisibility: true,
                              cropData: futureCropData,
                              selectedcrop: _selectedCrop ?? '')),
                    );
                  } else if (ORG_Entity[index].id == "7") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => HarvestPage(
                              aapbarVisibility: true,
                              cropData: futureCropData,
                              selectedcrop: _selectedCrop ?? '')),
                    );
                  } else if (ORG_Entity[index].id == "8") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MyFaqPage(
                              aapbarVisibility: true,
                              cropData: futureCropData,
                              selectedcrop: _selectedCrop ?? '')),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          ORG_Entity[index].name ?? "",
                          maxLines: 3,
                          softWrap: true,
                          style: const TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 14,
                              fontFamily: 'poppins-regular'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 3),
        ),
      ),
    );
  }
}

class Entity {
  String? name;
  String? id;

  Entity({
    required this.name,
    required this.id,
  });
}

class bottomCategory {
  String? name;
  String? icon;
  String? id;

  bottomCategory({
    required this.name,
    required this.icon,
    required this.id,
  });
}
