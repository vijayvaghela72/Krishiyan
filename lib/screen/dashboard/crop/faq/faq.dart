import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../language/select_language.dart';
import 'package:krishiyan/screen/dashboard/crop/crop_model.dart';

// ignore: must_be_immutable
class MyFaqPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<CropLibraryData> cropData;
  String? selectedcrop;

  MyFaqPage(
      {super.key,
      required this.aapbarVisibility,
      required this.selectedcrop,
      required this.cropData});

  @override
  State<MyFaqPage> createState() => _MyFaqPageState();
}

class _MyFaqPageState extends State<MyFaqPage> with TickerProviderStateMixin {
  List<bool> _expandedStates = [];
  bool firstCardVisible = false;
  bool secondCardVisible = false;
  bool thirdCardVisible = false;
  bool fourthCardVisible = false;
  bool fiveCardVisible = false;
  bool sixCardVisible = false;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                "FAQs",
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
            FutureBuilder<CropLibraryData>(
              future: widget.cropData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  CropLibraryData filteredData = snapshot.data!;

                  // Check if filteredData has any results
                  if (filteredData.faq == null || filteredData.faq!.isEmpty) {
                    return const Text(
                        'No data available for the selected crop.');
                  }

                  // Filter out irrigation entries that have only '_id' without additional data
                  filteredData.faq?.removeWhere(
                      (faq) => faq.answer == null && faq.question == null);

                  // Initialize expanded states list if not already initialized
                  if (_expandedStates.length != filteredData.faq!.length) {
                    _expandedStates =
                        List.filled(filteredData.faq!.length, false);
                  }
                  return ListView.builder(
                    // itemCount: filteredData.length,
                    itemCount: filteredData.faq!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _expandedStates[index] = !_expandedStates[index];
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.all(17),
                            textStyle: const TextStyle(fontSize: 18),
                            backgroundColor: const Color(0xFF02792A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        filteredData.faq![index].question ?? "",
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'poppins-medium'),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
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
                              _expandedStates[index]
                                  ? Container(
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
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 20,
                                              right: 10,
                                              left: 10,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                filteredData
                                                        .faq![index].answer ??
                                                    "",
                                                softWrap: true,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11,
                                                    fontFamily:
                                                        'poppins-regular'),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40.0,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
