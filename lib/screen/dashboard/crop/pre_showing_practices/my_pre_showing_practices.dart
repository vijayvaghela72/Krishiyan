import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/screen/dashboard/crop/crop_model.dart';
import '../../../language/select_language.dart';

// ignore: must_be_immutable
class MyProSawingPracticesPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<CropLibraryData> cropData;
  String? selectedcrop;

  MyProSawingPracticesPage(
      {super.key,
      required this.aapbarVisibility,
      required this.cropData,
      required this.selectedcrop});

  @override
  State<MyProSawingPracticesPage> createState() =>
      _MyProSawingPracticesPageState();
}

class _MyProSawingPracticesPageState extends State<MyProSawingPracticesPage>
    with TickerProviderStateMixin {
  bool firstCardVisible = false;
  bool secondCardVisible = false;
  bool thirdCardVisible = false;
  bool fourthCardVisible = false;

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
      backgroundColor: Colors.white,
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
        scrollDirection: Axis.vertical,
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
                "Pre-sowing practices",
                softWrap: true,
                style: TextStyle(
                    color: Color(0xFF3FC041),
                    fontSize: 20,
                    fontFamily: 'poppins-medium'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //1st
            FutureBuilder<CropLibraryData>(
              future: widget.cropData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              firstCardVisible = !firstCardVisible;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.all(17),
                            textStyle: const TextStyle(fontSize: 18),
                            backgroundColor: const Color(0xFF02792A),
                            shape: firstCardVisible
                                ? const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(17),
                                      topRight: Radius.circular(17),
                                    ),
                                  )
                                : const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(17)),
                                  ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Land Preparation',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'poppins-medium'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Image.asset(
                                        'assets/images/down_arrow_white.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      firstCardVisible
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xFF02792A),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(17.0),
                                        bottomRight: Radius.circular(17.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0, bottom: 20.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: const Color(0xFFd3d3d3),
                                                width: 1),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0xFFd3d3d3),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0,
                                                    right: 10.0,
                                                    left: 10.0),
                                                child: Text(
                                                  snapshot
                                                          .data!
                                                          .presowingPractices!
                                                          .landPreparation ??
                                                      "",
                                                  softWrap: true,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11,
                                                      fontFamily:
                                                          'poppins-regular'),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),

            //2nd
            FutureBuilder<CropLibraryData>(
              future: widget.cropData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                secondCardVisible = !secondCardVisible;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.all(17),
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor: const Color(0xFF02792A),
                              shape: secondCardVisible
                                  ? const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(17),
                                      topRight: Radius.circular(17),
                                    ))
                                  : const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                      Radius.circular(17),
                                    )),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Seed Treatment',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'poppins-medium'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Image.asset(
                                          'assets/images/down_arrow_white.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      secondCardVisible
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xFF02792A),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(17.0),
                                        bottomRight: Radius.circular(17.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                            bottom: 20.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFd3d3d3),
                                                  width: 1),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xFFd3d3d3),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              const Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20.0,
                                                      right: 10.0,
                                                      left: 10.0),
                                                  child: Text(
                                                    "Name of the Chemical and Methodology",
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'poppins-semibold'),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0,
                                                          left: 10.0),
                                                  child: Text(
                                                    snapshot
                                                            .data!
                                                            .presowingPractices!
                                                            .seedTreatment!
                                                            .nameOfChemical ??
                                                        "",
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11,
                                                        fontFamily:
                                                            'poppins-regular'),
                                                  ),
                                                ),
                                              ),
                                              const Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0,
                                                      right: 10.0,
                                                      left: 10.0),
                                                  child: Text(
                                                    "Dosage",
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'poppins-semibold'),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0,
                                                          right: 10.0,
                                                          left: 10.0),
                                                  child: Text(
                                                    snapshot
                                                            .data!
                                                            .presowingPractices!
                                                            .seedTreatment!
                                                            .dosage ??
                                                        "",
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11,
                                                        fontFamily:
                                                            'poppins-regular'),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(
              height: 5,
            ),

            //3rd
            FutureBuilder<CropLibraryData>(
              future: widget.cropData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (thirdCardVisible) {
                                  thirdCardVisible = false;
                                } else {
                                  thirdCardVisible = true;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.all(17),
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor: const Color(0xFF02792A),
                              shape: thirdCardVisible
                                  ? const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(17),
                                      topRight: Radius.circular(17),
                                    ))
                                  : const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                      Radius.circular(17),
                                    )),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Intercultural Operation',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'poppins-medium'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Image.asset(
                                          'assets/images/down_arrow_white.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      thirdCardVisible
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xFF02792A),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(17.0),
                                        bottomRight: Radius.circular(17.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                            bottom: 20.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFd3d3d3),
                                                  width: 1),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xFFd3d3d3),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0,
                                                          right: 10.0,
                                                          left: 10.0),
                                                  child: Text(
                                                    snapshot
                                                        .data!
                                                        .presowingPractices!
                                                        .interculturalOperations
                                                        .toString(),
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11,
                                                        fontFamily:
                                                            'poppins-regular'),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),

            const SizedBox(
              height: 5,
            ),

            //4th
            FutureBuilder<CropLibraryData>(
              future: widget.cropData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (fourthCardVisible) {
                                  fourthCardVisible = false;
                                } else {
                                  fourthCardVisible = true;
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.all(17),
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor: const Color(0xFF02792A),
                              shape: fourthCardVisible
                                  ? const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(17),
                                      topRight: Radius.circular(17),
                                    ))
                                  : const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                      Radius.circular(17),
                                    )),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Soil Condition',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'poppins-medium'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Image.asset(
                                          'assets/images/down_arrow_white.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      fourthCardVisible
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF02792A),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(17),
                                    bottomRight: Radius.circular(17),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                            bottom: 20.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFd3d3d3),
                                                  width: 1),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xFFd3d3d3),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0,
                                                          right: 10.0,
                                                          left: 10.0),
                                                  child: Text(
                                                    snapshot
                                                            .data!
                                                            .presowingPractices!
                                                            .soilConditions ??
                                                        "",
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11,
                                                        fontFamily:
                                                            'poppins-regular'),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
