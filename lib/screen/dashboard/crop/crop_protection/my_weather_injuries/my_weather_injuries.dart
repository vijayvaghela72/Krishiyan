import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../helper/drive_image.dart';
import '../../../../language/select_language.dart';
import 'package:krishiyan/screen/dashboard/crop/crop_model.dart';

// ignore: must_be_immutable
class MyWeatherInjuriesPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<CropLibraryData?> cropData;
  String? selectedcrop;

  MyWeatherInjuriesPage(
      {super.key,
      required this.aapbarVisibility,
      required this.cropData,
      required this.selectedcrop});

  @override
  State<MyWeatherInjuriesPage> createState() => _MyWeatherInjuriesPageState();
}

class _MyWeatherInjuriesPageState extends State<MyWeatherInjuriesPage>
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
      resizeToAvoidBottomInset: false,
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
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
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
                "Weather Injuries",
                softWrap: true,
                style: TextStyle(
                    color: Color(0xFF3FC041),
                    fontSize: 22,
                    fontFamily: 'poppins-medium'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            listWidget(),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  listWidget() {
    return FutureBuilder<CropLibraryData?>(
      future: widget.cropData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          CropLibraryData? filteredData;
          if (snapshot.data?.localName == widget.selectedcrop) {
            filteredData = snapshot.data;
          }

          // Check if filteredData has any results
          if (filteredData == null) {
            return const Text('No data available for the selected crop.');
          }

          return Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredData.weatherInjuries!.length,
              itemBuilder: (context, injuryIndex) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: const Color(0xFFd3d3d3), width: 1),
                      boxShadow: const [BoxShadow(color: Color(0xFFd3d3d3))],
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: filteredData!.weatherInjuries![injuryIndex]
                                    .image!.isNotEmpty
                                ? Center(
                                    child: DriveImage(
                                        imageUrlData: filteredData
                                            .weatherInjuries![injuryIndex]
                                            .image!),
                                  )
                                : Container(),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showCausesAlertDialog(
                                          context,
                                          filteredData!
                                              .weatherInjuries![injuryIndex]
                                              .causes!);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      minimumSize: Size.zero,
                                      textStyle: const TextStyle(fontSize: 14),
                                      padding: const EdgeInsets.all(5),
                                      backgroundColor: const Color(0xFF278115),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                    ),
                                    child: const Text(
                                      'CAUSES',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'poppins-regular',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showSymptomAlertDialog(
                                          context,
                                          filteredData!
                                              .weatherInjuries![injuryIndex]
                                              .symptoms!);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      minimumSize: Size.zero,
                                      textStyle: const TextStyle(fontSize: 14),
                                      padding: const EdgeInsets.all(5),
                                      backgroundColor: const Color(0xFF3FC041),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                    ),
                                    child: const Text(
                                      'SYMPTOM',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'poppins-regular',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
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

  showSymptomAlertDialog(BuildContext context, String symptom) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Symptom",
                    softWrap: true,
                    style: TextStyle(
                        fontFamily: "poppins-semibold",
                        fontSize: 15.0,
                        color: Colors.black),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(color: Colors.grey),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 15.0,
              right: 15.0,
            ),
            child: Text(
              symptom,
              softWrap: true,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontFamily: "poppins-regular",
                  fontSize: 13.0,
                  color: Color(0xFF666666)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showCausesAlertDialog(BuildContext context, String causes) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Causes",
                    softWrap: true,
                    style: TextStyle(
                        fontFamily: "poppins-semibold",
                        fontSize: 15.0,
                        color: Colors.black),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(color: Colors.grey),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 15.0,
              right: 15.0,
            ),
            child: Text(
              causes,
              softWrap: true,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontFamily: "poppins-regular",
                  fontSize: 13.0,
                  color: Color(0xFF666666)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
