import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../mvc/model/CropLibraryData.dart';
import '../../../Language/SelectLanguagePage.dart';

// ignore: must_be_immutable
class NutrientManagmentPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<List<CropLibraryData>?> cropData;
  String? selectedcrop;

  NutrientManagmentPage(
      {super.key,
      required this.aapbarVisibility,
      required this.cropData,
      required this.selectedcrop});

  @override
  State<NutrientManagmentPage> createState() => _NutrientManagmentPageState();
}

class _NutrientManagmentPageState extends State<NutrientManagmentPage>
    with TickerProviderStateMixin {
  List<dynamic> nutrients = [];
  bool isLoading = true;

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
              height: 20.0,
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
                  const Text(
                    "Go Back",
                    style: TextStyle(
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
            const Center(
              child: Text(
                "Nutrient-Management",
                softWrap: true,
                style: TextStyle(
                    color: Color(0xFF3FC041),
                    fontSize: 20,
                    fontFamily: 'poppins-medium'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<CropLibraryData>?>(
              future: widget.cropData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                // Filter data based on the selected crop (localName)
                List<CropLibraryData>? filteredData =
                    snapshot.data?.where((data) {
                  return data.localName ==
                      widget
                          .selectedcrop; // Assuming selectedCrop is passed via widget
                }).toList();

                // If no data matches the selected crop, show a message
                if (filteredData == null || filteredData.isEmpty) {
                  return const Center(
                      child: Text('No data available for the selected crop'));
                }

                filteredData.forEach((cropData) {
                  cropData.nutrient?.removeWhere((nutrient) =>
                      nutrient.dosage == null &&
                      nutrient.methodApplication == null &&
                      nutrient.age == null);
                });

                return ListView.builder(
                  itemCount: filteredData.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var nutrients = filteredData[index].nutrient;

                    // Check if nutrients is not empty
                    if (nutrients!.isEmpty) {
                      return const Center(
                          child: Text("No nutrients available."));
                    }

                    return ListView.builder(
                      itemCount: nutrients.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, nutrientIndex) {
                        var nutrient = nutrients[nutrientIndex];

                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xFFd3d3d3), width: 1),
                              boxShadow: const [
                                BoxShadow(color: Color(0xFFd3d3d3))
                              ],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                // Define the action on tap
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 20.0,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.all(12),
                                        textStyle:
                                            const TextStyle(fontSize: 18),
                                        backgroundColor:
                                            const Color(0xFF1E8E27),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              "assets/images/growing_seed.png",
                                              width: 20,
                                              height: 20),
                                          const SizedBox(width: 10),
                                          Text(
                                            nutrient.name ?? "No Name",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'poppins-regular',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Center(
                                        child: Text(
                                          nutrient.dosage ?? "No Dosage Info",
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: 'poppins-semibold',
                                          ),
                                        ),
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
                                        textStyle:
                                            const TextStyle(fontSize: 18),
                                        backgroundColor:
                                            const Color(0xFF1E8E27),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                    "assets/images/age.png",
                                                    width: 20,
                                                    height: 20),
                                                const SizedBox(width: 5),
                                                const Text(
                                                  'Age of Crops',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'poppins-regular',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              nutrient.age ?? "No Age Info",
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontFamily: 'poppins-regular',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  const Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0, right: 15.0, left: 15.0),
                                      child: Text(
                                        "Method of Application",
                                        softWrap: true,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'poppins-semibold',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, right: 15.0, left: 15.0),
                                      child: Text(
                                        nutrient.methodApplication ??
                                            "No Application Method Info",
                                        textAlign: TextAlign.justify,
                                        softWrap: true,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontFamily: 'poppins-regular',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}

class Nutrient {
  String? name;
  String? id;
  String? dosage;
  String? description;
  String? methodOfApplication;

  Nutrient({
    required this.id,
    required this.name,
    required this.dosage,
    required this.description,
    required this.methodOfApplication,
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
