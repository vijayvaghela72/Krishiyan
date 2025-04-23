import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Language/SelectLanguagePage.dart';
import '../../mvc/model/CropLibraryData.dart';

// ignore: must_be_immutable
class IrrigationManagementPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<List<CropLibraryData>?> cropData;
  String? selectedcrop;

  IrrigationManagementPage(
      {super.key,
      required this.aapbarVisibility,
      required this.selectedcrop,
      required this.cropData});

  @override
  State<IrrigationManagementPage> createState() =>
      _IrrigationManagementPageState();
}

class _IrrigationManagementPageState extends State<IrrigationManagementPage>
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
              height: 20,
            ),
            const Center(
              child: Text(
                "Irrigation Management",
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
                if (snapshot.hasData) {
                  List<CropLibraryData>? filteredData =
                      snapshot.data?.where((data) {
                    return data.localName ==
                        widget.selectedcrop; // Filter by selected crop
                  }).toList();

                  // Check if filteredData has any results
                  if (filteredData == null || filteredData.isEmpty) {
                    return const Text(
                        'No data available for the selected crop.');
                  }

                  // Filter out irrigation entries that have only '_id' without additional data
                  filteredData.forEach((cropData) {
                    cropData.irrigation?.removeWhere((irrigation) =>
                        irrigation.criticalStage == null &&
                        irrigation.age == null &&
                        irrigation.methodology == null &&
                        irrigation.operations == null);
                  });

                  return ListView.builder(
                    itemCount: filteredData.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, parentIndex) {
                      return ListView.builder(
                        itemCount: filteredData[parentIndex].irrigation!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
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
                                  children: <Widget>[
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/images/clock.png",
                                                width: 20,
                                                height: 20,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                filteredData[parentIndex]
                                                        .irrigation![index]
                                                        .age ??
                                                    "",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'poppins-medium'),
                                              ),
                                            ],
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0, left: 10.0, right: 10.0),
                                        child: Center(
                                          child: Text(
                                            filteredData[parentIndex]
                                                    .irrigation![index]
                                                    .criticalStage ??
                                                "",
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                            style: const TextStyle(
                                                // color: Color(0xFF666666),
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'poppins-semibold'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                              const Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  'Methodology',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily:
                                                          'poppins-regular'),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  filteredData[parentIndex]
                                                          .irrigation![index]
                                                          .methodology ??
                                                      "",
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      fontFamily:
                                                          'poppins-medium'),
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    const Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.0, right: 15.0, left: 15.0),
                                        child: Text(
                                          "Operations:",
                                          softWrap: true,
                                          style: TextStyle(
                                              // color: Color(0xFF666666),
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontFamily: 'poppins-semibold'),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, right: 15.0, left: 15.0),
                                        child: Text(
                                          filteredData[parentIndex]
                                                  .irrigation![index]
                                                  .operations ??
                                              "",
                                          textAlign: TextAlign.justify,
                                          softWrap: true,
                                          style: const TextStyle(
                                              // color: Color(0xFF666666),
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontFamily: 'poppins-regular'),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
