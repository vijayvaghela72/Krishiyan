import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MyHomePage.dart';

class MyEnquiryDetailPage extends StatefulWidget {
  const MyEnquiryDetailPage({super.key});

  @override
  State<MyEnquiryDetailPage> createState() => _MyEnquiryDetailPageState();
}

class _MyEnquiryDetailPageState extends State<MyEnquiryDetailPage>
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Row(
          children: [
            InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset('assets/images/back.png')),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Enquiry Detail",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'poppins-medium',
                  fontSize: 20),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),

            // user card
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 210,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/enquiryBG.png"),
                              fit: BoxFit.cover)),
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Name :",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Ankit",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Purpose :",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "To sell",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Rs :",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "25000/-",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF008000),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Quantity :",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "10 Metric Ton (MT)",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Moisture :",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "25.45%",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Grade :",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "A",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Size :",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "4045",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Count :",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "35",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Targeted \nPrice :",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "25000",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Expected \Purchase Date :",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "25/07/2024",
                            softWrap: true,
                            style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 15,
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(5),
                                    textStyle: const TextStyle(fontSize: 18),
                                    backgroundColor: const Color(0xFF3FC041),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // <-- Radius
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Chat',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'poppins-medium'),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Image.asset(
                                        'assets/images/chat.png',
                                        height: 10,
                                        width: 10,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(3),
                                    textStyle: const TextStyle(fontSize: 18),
                                    backgroundColor: const Color(0xFF3FC041),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // <-- Radius
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Call',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'poppins-medium'),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Image.asset(
                                        'assets/images/call.png',
                                        height: 10,
                                        width: 10,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(5),
                                    textStyle: const TextStyle(fontSize: 15),
                                    backgroundColor: const Color(0xFF3FC041),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // <-- Radius
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      const Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.only(left:2.0),
                                          child: Text(
                                            'Interested',
                                            softWrap: true,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: 'poppins-medium'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Image.asset(
                                        'assets/images/like.png',
                                        height: 10,
                                        width: 10,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

          ],
        ),
      ),
      // drawer: MyDrawer(),
    );
  }
}
