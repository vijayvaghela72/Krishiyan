import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/mvc/model/CropLibraryData.dart';
import 'package:krishiyan/mvc/model/VarietyData.dart';
import 'package:krishiyan/mvc/model/variet_model.dart';
import '../../../../localization/AppLocalizations.dart';
import '../../../Language/SelectLanguagePage.dart';

// ignore: must_be_immutable
class MyVeritiesPage extends StatefulWidget {
  bool aapbarVisibility;
  String? selectedcrop;
  Future<List<CropLibraryData>?> cropData;

  MyVeritiesPage(
      {super.key,
      required this.aapbarVisibility,
      required this.selectedcrop,
      required this.cropData});

  @override
  State<MyVeritiesPage> createState() => _MyVeritiesPageState();
}

class _MyVeritiesPageState extends State<MyVeritiesPage>
    with TickerProviderStateMixin {
  String? currentCrop; // To hold the current crop
  List<Verities>? varieties; // To hold the fetched varieties

  List<Verities> ORG_Verities = [
    Verities(
        id: "1",
        name: "Name of the variety/hybrid: MM 9344 (DMH192)",
        productCondition: "Product Condition: 35-37 qtl/acre",
        area: "Area of adoption: Maharashtra",
        cropCycle: "Crop Cycle: Suitable for Kharif season",
        spaciality:
            "1. Drought tolerant.\n2.Resistant to Common rust and Charcoal rot"),
    Verities(
        id: "2",
        name: "Name of variety/Hybrid: CP. 999 Hybrid",
        productCondition: "Product Condition: 34-35 qtl/acre",
        area:
            "Area of adoption: Karnataka, Tamilnadu, Telangana and Maharashtra",
        cropCycle: "Crop Cycle: 1. Suitable for irrigated and rainfed areas "
            "2.Suitable for rabi season under irrigated areas",
        spaciality: "Moderately resistant to common diseases"),
    Verities(
        id: "3",
        name: "Name of variety/Hybrid: ADV-756 (ADV 0990296) Hybrid",
        productCondition: "Product Condition: 30-35 qtl/acre",
        area:
            "Area of adoption: Karnataka, Maharashtra, Andra Pradesh, Tamilnadu, Telangana, Rajasthan,"
            " Gujarat, MP and Chhattisgarh",
        cropCycle: "Crop Cycle: 1. Suitable for irrigated and rainfed "
            "areas 2.Suitable for rabi season under irrigated",
        spaciality:
            "1. Multiple disease resistance 2. Resistant to Curvularia leaf spot"),
    Verities(
        id: "4",
        name:
            "Name of variety/Hybrid: Gujarat An and White Maize Hybrid-2 (GAWMH-2)",
        productCondition: "Product Condition: 15-18 qtl/acre",
        area: "Area of adoption: Gujarat",
        cropCycle: "Crop Cycle: Suitable for Kharif season",
        spaciality: "White flint grain"),
    Verities(
        id: "5",
        name: "Name of variety/Hybrid: HTMH 5108 Hybrid",
        productCondition: "Product Condition: 35 qtl/acre",
        area:
            "Area of adoption: Karnataka, Maharashtra, Andhra Pradesh, Tamilnadu and Telangana",
        cropCycle: "Crop Cycle: Suitable for rainfed and irrigated areas",
        spaciality: "Resistant to lodging"),
    Verities(
        id: "6",
        name:
            "Name of variety/Hybrid: Gujarat Anand Yellow Maize Hybrid 3 (GAYMH 3)",
        productCondition: "Product Condition: 25-28 qtl/acre",
        area: "Area of adoption: Middle Gujarat",
        cropCycle: "Crop Cycle: Suitable for rabi season",
        spaciality: "1. Moderately resistant to Turcicum leaf blight "
            "\n2. Moderately resistant to Downy mildew \n3. Resistant to common rust and stem borer"),
    Verities(
        id: "7",
        name: "Name of variety/Hybrid: Gujarat Yellow Hybrid (GYH 0363)",
        productCondition: "Product Condition: 25-28 qtl/acre",
        area: "Area of adoption: Middle Gujarat",
        cropCycle: "Crop Cycle: Suitable for rabi season",
        spaciality: "1. Moderately resistant to Turcicum leaf blight "
            "\n2. Moderately resistant to Downy mildew \n3. Resistant to common rust and stem borer"),
  ];

  @override
  void initState() {
    super.initState();
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
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 25.0,
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
                        fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                buildTranslate("varieties")!,
                softWrap: true,
                style: const TextStyle(
                    color: Color(0xFF3FC041),
                    fontSize: 20,
                    fontFamily: 'poppins-medium'),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            FutureBuilder<List<VarietyData>>(
              future: fetchVarieties(widget
                  .selectedcrop!), // Fetch varieties based on the selected crop
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child:
                          Text('No varieties available for the selected crop'));
                }

                final varieties = snapshot.data!;

                return ListView.builder(
                  itemCount: varieties.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: const Color(0xFFd3d3d3), width: 1),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFFd3d3d3),
                              )
                            ],
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, right: 10.0, left: 10.0),
                                child: Text(
                                  varieties[index]
                                      .nameOfVariety, // Use nameOfVariety from VarietyData
                                  softWrap: true,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, right: 10.0, left: 10.0),
                                child: Text(
                                  varieties[index].productCondition,
                                  softWrap: true,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, right: 10.0, left: 10.0),
                                child: Text(
                                  varieties[index]
                                      .areaOfAdoption, // Use areaOfAdoption from VarietyData
                                  softWrap: true,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, right: 10.0, left: 10.0),
                                child: Text(
                                  varieties[index].cropCycle,
                                  softWrap: true,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontFamily: 'poppins-semibold'),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 20.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(12),
                                  textStyle: const TextStyle(fontSize: 18),
                                  backgroundColor: const Color(0xFF1E8E27),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Column(children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Speciality:',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'poppins-regular'),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      varieties[index]
                                          .salientFeatures, // Use salientFeatures from VarietyData
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'poppins-regular'),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class Verities {
  String? name;
  String? id;
  String? productCondition;
  String? area;
  String? cropCycle;
  String? spaciality;

  Verities({
    required this.id,
    required this.name,
    required this.productCondition,
    required this.area,
    required this.cropCycle,
    required this.spaciality,
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

class Variety {
  final String id;
  final String name;
  final String productCondition;
  final String area;
  final String cropCycle;
  final String speciality;

  Variety({
    required this.id,
    required this.name,
    required this.productCondition,
    required this.area,
    required this.cropCycle,
    required this.speciality,
  });

  factory Variety.fromJson(Map<String, dynamic> json) {
    return Variety(
      id: json['id'],
      name: json['name'],
      productCondition: json['productCondition'],
      area: json['area'],
      cropCycle: json['cropCycle'],
      speciality: json['speciality'],
    );
  }
}
