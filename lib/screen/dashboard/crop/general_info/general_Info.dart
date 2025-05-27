import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../helper/drive_image.dart';
import '../../../language/select_language.dart';
import '../../../../localization/app_localizations.dart';
import 'package:krishiyan/screen/dashboard/crop/crop_model.dart';

// ignore: must_be_immutable
class GeneralInformationPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<CropLibraryData> cropData;
  String? selectedcrop;

  GeneralInformationPage(
      {super.key,
      required this.aapbarVisibility,
      required this.cropData,
      required this.selectedcrop});

  @override
  State<GeneralInformationPage> createState() => _GeneralInformationPageState();
}

class _GeneralInformationPageState extends State<GeneralInformationPage>
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
          children: <Widget>[
            const SizedBox(
              height: 20,
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
                buildTranslate("generalInformations")!,
                softWrap: true,
                style: const TextStyle(
                    color: Color(0xFF3FC041),
                    fontSize: 20,
                    fontFamily: 'poppins-medium'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            listWidget(),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<CropLibraryData>(
              future: widget.cropData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Continue with building the table with data
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: Table(
                        border: TableBorder.all(),
                        children: [
                          // Table Header
                          const TableRow(
                            decoration: BoxDecoration(color: Color(0xFF73C187)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text('Parameter',
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                          fontFamily: "poppins-semibold")),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text('Specifications',
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                          fontFamily: "poppins-semibold")),
                                ),
                              ),
                            ],
                          ),

                          // Table Rows for crop data
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Kharif(Sowing Month)',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-semibold")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  snapshot.data?.generalInformation?.kharif ??
                                      "",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-regular")),
                            ),
                          ]),

                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Rabi(Sowing Month)',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-semibold")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  snapshot.data?.generalInformation?.rabi ?? "",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-regular")),
                            ),
                          ]),

                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Zaid(Sowing Mouth)',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-semibold")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  snapshot.data?.generalInformation?.zaid ?? "",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-regular")),
                            ),
                          ]),

                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Optimum temperature for growing',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-semibold")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  snapshot.data?.generalInformation
                                          ?.optimumTemperature ??
                                      "",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-regular")),
                            ),
                          ]),

                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Rainfall requirement',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-semibold")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  snapshot.data?.generalInformation
                                          ?.rainfallRequirement ??
                                      "",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-regular")),
                            ),
                          ]),

                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Recommended soil',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-semibold")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  snapshot.data?.generalInformation
                                          ?.recommendedSoil ??
                                      "",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-regular")),
                            ),
                          ]),

                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('pH of soil',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-semibold")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  snapshot.data?.generalInformation?.pHSoil ??
                                      "",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-regular")),
                            ),
                          ]),

                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Spacing',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-semibold")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  snapshot.data?.generalInformation?.spacing ??
                                      "",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-regular")),
                            ),
                          ]),

                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Seed Rate',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-semibold")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  snapshot.data?.generalInformation?.seedRate ??
                                      "",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-regular")),
                            ),
                          ]),

                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Average Yield',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-semibold")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  snapshot.data?.generalInformation
                                          ?.averageYield ??
                                      "",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-regular")),
                            ),
                          ]),

                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Intercrop details and pattern',
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-semibold")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  snapshot.data?.generalInformation
                                          ?.intercrop ??
                                      "",
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.black,
                                      fontFamily: "poppins-regular")),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
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

  Widget listWidget() {
    return FutureBuilder<CropLibraryData>(
      future: widget.cropData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: ListView.builder(
              itemCount: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, parentIndex) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.stages!.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
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
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {},
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  height: 180,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: DriveImage(
                                    imageUrlData: snapshot
                                        .data!.stages![index].images![0],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    snapshot.data!.stages![index].name ?? "",
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: const TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 12,
                                      height: 1.2,
                                      fontFamily: 'poppins-semibold',
                                    ),
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
                        (MediaQuery.of(context).size.height / 2),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class Entity {
  String? name;
  String? id;
  String? image;

  Entity({
    required this.name,
    required this.id,
    required this.image,
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
