import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../language/select_language.dart';
import 'package:krishiyan/helper/drive_image.dart';
import 'package:krishiyan/screen/dashboard/crop/crop_model.dart';

// ignore: must_be_immutable
class HarvestPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<CropLibraryData> cropData;
  String? selectedcrop;

  HarvestPage(
      {super.key,
      required this.aapbarVisibility,
      required this.cropData,
      required this.selectedcrop});

  @override
  State<HarvestPage> createState() => _HarvestPageState();
}

class _HarvestPageState extends State<HarvestPage>
    with TickerProviderStateMixin {
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
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 15,
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
              height: 15,
            ),
            const Center(
              child: Text(
                "Harvest",
                softWrap: true,
                style: TextStyle(
                    color: Color(0xFF3FC041),
                    fontSize: 22,
                    fontFamily: 'poppins-medium'),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            FutureBuilder<CropLibraryData>(
              future: widget.cropData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data available'));
                }
                CropLibraryData filteredData = snapshot.data!;
                if (filteredData.localName != widget.selectedcrop) {
                  return const Center(
                      child: Text('No data available for the selected crop'));
                }
                if (filteredData.newHarvest == null) {
                  return const Center(child: Text('No harvest data available'));
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
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
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                                      child: Text(
                                        filteredData.newHarvest!.index ?? "",
                                        softWrap: true,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'poppins-regular'),
                                      ),
                                    )),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 10),
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
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          filteredData.newHarvest!
                                                  .conditionsDuring ??
                                              "",
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontFamily: 'poppins-regular'),
                                        ),
                                      ),
                                    )),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, right: 15.0, left: 15.0),
                                    child: Text(
                                      filteredData.newHarvest!.prevent ?? "",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontFamily: 'poppins-semibold'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                if (filteredData.newHarvest!.postHarvest !=
                                        null &&
                                    filteredData
                                        .newHarvest!.postHarvest!.isNotEmpty)
                                  Container(
                                    height: 200,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: filteredData
                                          .newHarvest!.postHarvest!.length,
                                      itemBuilder: (context, imageIndex) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, bottom: 10),
                                          child: DriveImage(
                                            imageUrlData: filteredData
                                                .newHarvest!
                                                .postHarvest![imageIndex]
                                                .images![0],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
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
