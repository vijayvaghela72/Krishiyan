import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/mvc/model/CropLibraryData.dart';
import '../Enquiry/BottomCenterEnquiryPage.dart';
import '../HomeScreen/BottomOnePage.dart';
import 'BottomThreePage.dart';
import '../FRM/BottomTwoPage.dart';
import '../AccountSettings/ProfilePage.dart';
import '../Language/SelectLanguagePage.dart';

class MyFaqPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<List<CropLibraryData>?> cropData;

  MyFaqPage({super.key, required this.aapbarVisibility, required this.cropData});

  @override
  State<MyFaqPage> createState() => _MyFaqPageState();
}

class _MyFaqPageState extends State<MyFaqPage>
    with TickerProviderStateMixin {
  var _bottomNavIndex = 2; //default index of a first screen

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  List<bottomCategory> iconList = [
    bottomCategory(name: "Home", id: "1", icon: 'assets/images/bottom1.png'),
    bottomCategory(name: "FRM", id: "2", icon: 'assets/images/bottom2.png'),
    bottomCategory(name: "Crop", id: "3", icon: 'assets/images/bottom3.png'),
    bottomCategory(name: "Profile", id: "4", icon: 'assets/images/bottom4.png'),
  ];

  bool firstCardVisible = false;
  bool secondCardVisible = false;
  bool thirdCardVisible = false;
  bool fourthCardVisible = false;
  bool fiveCardVisible = false;
  bool sixCardVisible = false;

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 1, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 1, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(
      const Duration(seconds: 1),
          () => _fabAnimationController.forward(),
    );
    Future.delayed(
      const Duration(seconds: 1),
          () => _borderRadiusAnimationController.forward(),
    );
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
          children: <Widget>[

            const SizedBox(height: 20.0,),
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
                  const SizedBox(width: 10,),
                  const Text(
                    "Go Back",
                    style: TextStyle(color: Colors.black, fontFamily: 'poppins-medium',
                        fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),

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
            const SizedBox(height: 10,),

            FutureBuilder<List<CropLibraryData>?>(
              future: widget.cropData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, parentIndex) {
                        return ListView.builder(
                          itemCount: snapshot.data![parentIndex].faq!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0, top: 20.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if(firstCardVisible){
                                          firstCardVisible = false;
                                        }
                                        else {
                                          firstCardVisible = true;
                                        }
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
                                                  snapshot.data![parentIndex].faq![index].question ?? "",
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'poppins-medium'),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Image.asset(
                                                  'assets/images/down_arrow_white.png', height: 20, width: 20,
                                                  // color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        firstCardVisible ? const SizedBox(height: 20,) : Container(),
                                        firstCardVisible ?
                                        Container(
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
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0, right: 10.0, left: 10.0),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    snapshot.data![parentIndex].faq![index].answer ?? "",
                                                    softWrap: true,
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                      // color: Color(0xFF666666),
                                                        color: Colors.black,
                                                        fontSize: 11,
                                                        fontFamily: 'poppins-regular'),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                            ],
                                          ),
                                        )
                                            : Container(),
                                      ],
                                    ),
                                  ));
                          },
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),

            // // 1st
            // Container(
            //     width: MediaQuery.of(context).size.width,
            //     padding: const EdgeInsets.only(
            //         left: 15.0, right: 15.0, top: 20.0),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           if(firstCardVisible){
            //             firstCardVisible = false;
            //           }
            //           else {
            //             firstCardVisible = true;
            //           }
            //         });
            //       },
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: Colors.white,
            //         shadowColor: Colors.transparent,
            //         padding: const EdgeInsets.all(17),
            //         textStyle: const TextStyle(fontSize: 18),
            //         backgroundColor: const Color(0xFF02792A),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //       child: Column(
            //         children: [
            //           Row(
            //             children: [
            //               const Expanded(
            //                 child: Align(
            //                   alignment: Alignment.centerLeft,
            //                   child: Text(
            //                     'How many growth stages in Maize crop?',
            //                     textAlign: TextAlign.start,
            //                     style: TextStyle(
            //                         fontSize: 14,
            //                         fontFamily: 'poppins-medium'),
            //                   ),
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            //                 child: Align(
            //                   alignment: Alignment.centerRight,
            //                   child: Image.asset(
            //                     'assets/images/down_arrow_white.png', height: 20, width: 20,
            //                     // color: Colors.white,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //           firstCardVisible ? const SizedBox(height: 20,) : Container(),
            //           firstCardVisible ?
            //           Container(
            //             decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 border: Border.all(
            //                     color: const Color(0xFFd3d3d3), width: 1),
            //                 boxShadow: const [
            //                   BoxShadow(
            //                     color: Color(0xFFd3d3d3),
            //                   )
            //                 ],
            //                 borderRadius: BorderRadius.circular(15)),
            //             child: const Column(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               mainAxisSize: MainAxisSize.min,
            //               children: <Widget>[
            //                 Flexible(
            //                   child: Padding(
            //                     padding: EdgeInsets.only(
            //                         top: 20.0, right: 10.0, left: 10.0),
            //                     child: Text(
            //                       "Four stages Germination & establishment phase, "
            //                           "Vegetative stage, Flowering Stage, Maturity Stage.",
            //                       softWrap: true,
            //                       style: TextStyle(
            //                         // color: Color(0xFF666666),
            //                           color: Colors.black,
            //                           fontSize: 11,
            //                           fontFamily: 'poppins-regular'),
            //                     ),
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   height: 20.0,
            //                 ),
            //               ],
            //             ),
            //           )
            //               : Container(),
            //         ],
            //       ),
            //     )),
            // const SizedBox(
            //   height: 5,
            // ),

            // //2nd
            // Container(
            //     width: MediaQuery.of(context).size.width,
            //     padding: const EdgeInsets.only(
            //         left: 15.0, right: 15.0, top: 20.0),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           if(secondCardVisible){
            //             secondCardVisible = false;
            //           }
            //           else {
            //             secondCardVisible = true;
            //           }
            //         });
            //       },
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: Colors.white,
            //         padding: const EdgeInsets.all(17),
            //         textStyle: const TextStyle(fontSize: 18),
            //         backgroundColor: const Color(0xFF02792A),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //       child: Column(
            //         children: [
            //           Row(
            //             children: [
            //               const Expanded(
            //                 child: Align(
            //                   alignment: Alignment.centerLeft,
            //                   child: Text(
            //                     'What about Vegetative stage of maize?',
            //                     textAlign: TextAlign.start,
            //                     style: TextStyle(
            //                         fontSize: 14,
            //                         fontFamily: 'poppins-medium'),
            //                   ),
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            //                 child: Align(
            //                   alignment: Alignment.centerRight,
            //                   child: Image.asset(
            //                     'assets/images/down_arrow_white.png', height: 20, width: 20,
            //                     // color: Colors.white,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //           secondCardVisible ? const SizedBox(height: 20,) : Container(),
            //           secondCardVisible ?
            //           Container(
            //             decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 border: Border.all(
            //                     color: const Color(0xFFd3d3d3), width: 1),
            //                 boxShadow: const [
            //                   BoxShadow(
            //                     color: Color(0xFFd3d3d3),
            //                   )
            //                 ],
            //                 borderRadius: BorderRadius.circular(15)),
            //             child: const Column(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               mainAxisSize: MainAxisSize.min,
            //               children: <Widget>[
            //                 Flexible(
            //                   child: Padding(
            //                     padding: EdgeInsets.only(
            //                         top: 20.0, right: 10.0, left: 10.0),
            //                     child: Text(
            //                       "During the vegetative growth phase the maize plant grows"
            //                           " quickly and the paint begins storing nutrients for the rest of the life "
            //                           "cycle. This is a period of high nutrient update and the plants progression is"
            //                           "influenced by moisture and temperature.",
            //                       softWrap: true,
            //                       style: TextStyle(
            //                         // color: Color(0xFF666666),
            //                           color: Colors.black,
            //                           fontSize: 12,
            //                           fontFamily: 'poppins-regular'),
            //                     ),
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   height: 10.0,
            //                 ),
            //               ],
            //             ),
            //           )
            //               : Container(),
            //         ],
            //       ),
            //     )),
            // const SizedBox(
            //   height: 5,
            // ),
            //
            // //3rd
            // Container(
            //     width: MediaQuery.of(context).size.width,
            //     padding: const EdgeInsets.only(
            //         left: 15.0, right: 15.0, top: 20.0),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           if(thirdCardVisible){
            //             thirdCardVisible = false;
            //           }
            //           else {
            //             thirdCardVisible = true;
            //           }
            //         });
            //       },
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: Colors.white,
            //         padding: const EdgeInsets.all(17),
            //         textStyle: const TextStyle(fontSize: 18),
            //         backgroundColor: const Color(0xFF02792A),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //       child: Column(
            //         children: [
            //           Row(
            //             children: [
            //               const Expanded(
            //                 child: Align(
            //                   alignment: Alignment.centerLeft,
            //                   child: Text(
            //                     'What about Flowering stage of maize?',
            //                     textAlign: TextAlign.start,
            //                     style: TextStyle(
            //                         fontSize: 14,
            //                         fontFamily: 'poppins-medium'),
            //                   ),
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            //                 child: Align(
            //                   alignment: Alignment.centerRight,
            //                   child: Image.asset(
            //                     'assets/images/down_arrow_white.png', height: 20, width: 20,
            //                     // color: Colors.white,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //           thirdCardVisible ? const SizedBox(height: 20,) : Container(),
            //           thirdCardVisible ?
            //           Container(
            //             decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 border: Border.all(
            //                     color: const Color(0xFFd3d3d3), width: 1),
            //                 boxShadow: const [
            //                   BoxShadow(
            //                     color: Color(0xFFd3d3d3),
            //                   )
            //                 ],
            //                 borderRadius: BorderRadius.circular(15)),
            //             child: const Column(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               mainAxisSize: MainAxisSize.min,
            //               children: <Widget>[
            //                 Flexible(
            //                   child: Padding(
            //                     padding: EdgeInsets.only(
            //                         top: 20.0, right: 10.0, left: 10.0),
            //                     child: Text(
            //                       "At this growth stage there is a great sensitivity to lack of water and"
            //                           "nitrogen, if water stress, grain development can be disrupted, High temperatures "
            //                           "can cause no exit of the bristles, Fertilization problems can cause distributed"
            //                           "grain development.",
            //                       softWrap: true,
            //                       style: TextStyle(
            //                         // color: Color(0xFF666666),
            //                           color: Colors.black,
            //                           fontSize: 11,
            //                           fontFamily: 'poppins-regular'),
            //                     ),
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   height: 10.0,
            //                 ),
            //
            //               ],
            //             ),
            //           )
            //               : Container(),
            //         ],
            //       ),
            //     )),
            // const SizedBox(
            //   height: 5,
            // ),
            //
            // //4th
            // Container(
            //     width: MediaQuery.of(context).size.width,
            //     padding: const EdgeInsets.only(
            //         left: 15.0, right: 15.0, top: 20.0),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           if(fourthCardVisible){
            //             fourthCardVisible = false;
            //           }
            //           else {
            //             fourthCardVisible = true;
            //           }
            //         });
            //       },
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: Colors.white,
            //         padding: const EdgeInsets.all(17),
            //         textStyle: const TextStyle(fontSize: 18),
            //         backgroundColor: const Color(0xFF02792A),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //       child: Column(
            //         children: [
            //           Row(
            //             children: [
            //               const Expanded(
            //                 child: Align(
            //                   alignment: Alignment.centerLeft,
            //                   child: Text(
            //                     'What is Tricho card and what is the purpose of using it in maize?',
            //                     textAlign: TextAlign.start,
            //                     style: TextStyle(
            //                         fontSize: 14,
            //                         fontFamily: 'poppins-medium'),
            //                   ),
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            //                 child: Align(
            //                   alignment: Alignment.centerRight,
            //                   child: Image.asset(
            //                     'assets/images/down_arrow_white.png', height: 20, width: 20,
            //                     // color: Colors.white,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //           fourthCardVisible ? const SizedBox(height: 20,) : Container(),
            //           fourthCardVisible ?
            //           Container(
            //             decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 border: Border.all(
            //                     color: const Color(0xFFd3d3d3), width: 1),
            //                 boxShadow: const [
            //                   BoxShadow(
            //                     color: Color(0xFFd3d3d3),
            //                   )
            //                 ],
            //                 borderRadius: BorderRadius.circular(15)),
            //             child: const Column(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               mainAxisSize: MainAxisSize.min,
            //               children: <Widget>[
            //                 Flexible(
            //                   child: Padding(
            //                     padding: EdgeInsets.only(
            //                         top: 20.0, right: 10.0, left: 10.0),
            //                     child: Text(
            //                       "Tricho cards are used for management of stem bores and FAW in "
            //                           "maize crop. Parasitoid Trichogramma spp. parasitize the eggs of these pests, "
            //                           "thus larvae fail to emerge from the eggs.",
            //                       softWrap: true,
            //                       style: TextStyle(
            //                         // color: Color(0xFF666666),
            //                           color: Colors.black,
            //                           fontSize: 11,
            //                           fontFamily: 'poppins-regular'),
            //                     ),
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   height: 10.0,
            //                 ),
            //               ],
            //             ),
            //           )
            //               : Container(),
            //         ],
            //       ),
            //     )),
            // const SizedBox(
            //   height: 5,
            // ),
            //
            // //5th
            // Container(
            //     width: MediaQuery.of(context).size.width,
            //     padding: const EdgeInsets.only(
            //         left: 15.0, right: 15.0, top: 20.0),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           if(fiveCardVisible){
            //             fiveCardVisible = false;
            //           }
            //           else {
            //             fiveCardVisible = true;
            //           }
            //         });
            //       },
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: Colors.white,
            //         padding: const EdgeInsets.all(17),
            //         textStyle: const TextStyle(fontSize: 18),
            //         backgroundColor: const Color(0xFF02792A),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //       child: Column(
            //         children: [
            //           Row(
            //             children: [
            //               const Expanded(
            //                 child: Align(
            //                   alignment: Alignment.centerLeft,
            //                   child: Text(
            //                     'What is IPM and how does it differ from farmers? practices?',
            //                     textAlign: TextAlign.start,
            //                     style: TextStyle(
            //                         fontSize: 14,
            //                         fontFamily: 'poppins-medium'),
            //                   ),
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            //                 child: Align(
            //                   alignment: Alignment.centerRight,
            //                   child: Image.asset(
            //                     'assets/images/down_arrow_white.png', height: 20, width: 20,
            //                     // color: Colors.white,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //           fiveCardVisible ? const SizedBox(height: 20,) : Container(),
            //           fiveCardVisible ?
            //           Container(
            //             decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 border: Border.all(
            //                     color: const Color(0xFFd3d3d3), width: 1),
            //                 boxShadow: const [
            //                   BoxShadow(
            //                     color: Color(0xFFd3d3d3),
            //                   )
            //                 ],
            //                 borderRadius: BorderRadius.circular(15)),
            //             child: const Column(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               mainAxisSize: MainAxisSize.min,
            //               children: <Widget>[
            //                 Flexible(
            //                   child: Padding(
            //                     padding: EdgeInsets.only(
            //                         top: 20.0, right: 10.0, left: 10.0),
            //                     child: Text(
            //                       "IPM is the integration of past management tactics in compatible"
            //                           "manner to keep the pest population below economic injury level without"
            //                           "adversely affecting our environment.",
            //                       softWrap: true,
            //                       style: TextStyle(
            //                         // color: Color(0xFF666666),
            //                           color: Colors.black,
            //                           fontSize: 11,
            //                           fontFamily: 'poppins-regular'),
            //                     ),
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   height: 10.0,
            //                 ),
            //               ],
            //             ),
            //           )
            //               : Container(),
            //         ],
            //       ),
            //     )),
            // const SizedBox(
            //   height: 5,
            // ),
            //
            // //6th
            // Container(
            //     width: MediaQuery.of(context).size.width,
            //     padding: const EdgeInsets.only(
            //         left: 15.0, right: 15.0, top: 20.0),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           if(sixCardVisible){
            //             sixCardVisible = false;
            //           }
            //           else {
            //             sixCardVisible = true;
            //           }
            //         });
            //       },
            //       style: ElevatedButton.styleFrom(
            //         foregroundColor: Colors.white,
            //         padding: const EdgeInsets.all(17),
            //         textStyle: const TextStyle(fontSize: 18),
            //         backgroundColor: const Color(0xFF02792A),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //       child: Column(
            //         children: [
            //           Row(
            //             children: [
            //               const Expanded(
            //                 child: Align(
            //                   alignment: Alignment.centerLeft,
            //                   child: Text(
            //                     'Can hand picking of eggs or leaf infested with larvae '
            //                         'facilitates the control of pests.',
            //                     textAlign: TextAlign.start,
            //                     style: TextStyle(
            //                         fontSize: 14,
            //                         fontFamily: 'poppins-medium'),
            //                   ),
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            //                 child: Align(
            //                   alignment: Alignment.centerRight,
            //                   child: Image.asset(
            //                     'assets/images/down_arrow_white.png', height: 20, width: 20,
            //                     // color: Colors.white,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //           sixCardVisible ? const SizedBox(height: 20,) : Container(),
            //           sixCardVisible ?
            //           Container(
            //             decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 border: Border.all(
            //                     color: const Color(0xFFd3d3d3), width: 1),
            //                 boxShadow: const [
            //                   BoxShadow(
            //                     color: Color(0xFFd3d3d3),
            //                   )
            //                 ],
            //                 borderRadius: BorderRadius.circular(15)),
            //             child: const Column(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               mainAxisSize: MainAxisSize.min,
            //               children: <Widget>[
            //                 Flexible(
            //                   child: Padding(
            //                     padding: EdgeInsets.only(
            //                         top: 20.0, right: 10.0, left: 10.0),
            //                     child: Text(
            //                       "Yes. Hand picking of eggs or leaves infested with larvae helps in managing"
            //                           "the inspects to some extent.",
            //                       softWrap: true,
            //                       style: TextStyle(
            //                         // color: Color(0xFF666666),
            //                           color: Colors.black,
            //                           fontSize: 11,
            //                           fontFamily: 'poppins-regular'),
            //                     ),
            //                   ),
            //                 ),
            //                 SizedBox(
            //                   height: 10.0,
            //                 ),
            //               ],
            //             ),
            //           )
            //               : Container(),
            //         ],
            //       ),
            //     )),
            // const SizedBox(
            //   height: 30,
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withAlpha(0),
        // add this line.
        elevation: 0,
        // also important, removes the shadow
        heroTag: "floatingActionBtn",
        shape: const RoundedRectangleBorder(
          // <= Change BeveledRectangleBorder to RoundedRectangularBorder
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              _onItemTapped(4);
            });
          },
          child: Image.asset(
            'assets/images/bottomCenter.png',
            // color: Colors.white,
          ),
        ),
        onPressed: () {
          _fabAnimationController.reset();
          _borderRadiusAnimationController.reset();
          _borderRadiusAnimationController.forward();
          _fabAnimationController.forward();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        height: 70,
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.green : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconList[index].icon ?? "",
                color: color,
                width: 25,
                height: 25,
              ),
              const SizedBox(height: 5),
              Text(
                iconList[index].name ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 13,
                    fontFamily: 'poppins-regular'),
              ),
            ],
          );
        },
        // backgroundColor: Colors.white,
        activeIndex: _bottomNavIndex,
        // splashColor: Colors.green,
        notchAndCornersAnimation: borderRadiusAnimation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        notchMargin: 7,
        onTap: (index) {
          setState(() {
            _onItemTapped(index);
          });
        },
        // setState(() => _bottomNavIndex = index),
        hideAnimationController: _hideBottomBarAnimationController,
        shadow: const BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          spreadRadius: 0.2,
          color: Colors.white,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigator.pop(context);
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => BottomOnePage(
              aapbarVisibility: true,
            )));
      }
    } else if (index == 1) {
      // Navigator.pop(context);
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => BottomTwoPage(
              aapbarVisibility: true,
            )));
      }
    } else if (index == 2) {
      // Navigator.pop(context);
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => BottomThreePage(
              aapbarVisibility: true,
            )));
      }
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } else if (index == 4) {
      var route = ModalRoute.of(context);
      if (route != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => BottomCenterEnquiryPage(
              aapbarVisibility: true,
            )));
      }
    } else {
      setState(() {
        _bottomNavIndex = index;
      });
      print("Profile : bottomNavIndex : $_bottomNavIndex");
    }
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
