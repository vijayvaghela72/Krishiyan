import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';
import 'MyEnquiryDetailPage.dart';

class MyEnquiryDashboardPage extends StatefulWidget {
  const MyEnquiryDashboardPage({super.key});

  @override
  State<MyEnquiryDashboardPage> createState() => _MyEnquiryDashboardPageState();
}

class _MyEnquiryDashboardPageState extends State<MyEnquiryDashboardPage>
    with TickerProviderStateMixin {
  TextEditingController? controller;

  final List<String> items = ['Maize', 'Coriander', 'Soya'];

  String? selectedItemValue;

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
            Text(
              buildTranslate("enquiryDashboard")!,
              style: const TextStyle(
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
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text(
                buildTranslate("selectYourCommodity")!,
                softWrap: true,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontFamily: 'poppins-semibold'),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xFFd3d3d3), width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Container(
                  width: 240,
                  height: 50,
                  color: Colors.white,
                  child: Container(
                    color: Colors.white,
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none),
                        // Add more decoration..
                      ),
                      hint: Text(
                        buildTranslate("selectYourCommodity")!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "poppins-regular",
                                      color: Colors.black),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select type of Entity.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        //Do something when selected item is changed.
                      },
                      onSaved: (value) {
                        selectedItemValue = value.toString();
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 20,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //         const MyEnquiryDashboardPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                    textStyle: const TextStyle(fontSize: 15),
                    backgroundColor: const Color(0xFF3FC041),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  child: Text(
                    buildTranslate('SUBMIT')!,
                    style: const TextStyle(fontSize: 18, fontFamily: 'poppins-medium'),
                  ),
                )),

            const SizedBox(
              height: 20,
            ),

            // user card
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 180,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/enquiryBG.png"),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, left: 12.0),
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 150,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF008000),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: const Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Price  Rs.25000',
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 11,
                                          fontFamily: "poppins-semibold"),
                                ),
                              )),
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Name :  Ankit",
                        softWrap: true,
                        style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 15,
                            fontFamily: 'poppins-semibold'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text(
                        "Purpose:  To sell",
                        softWrap: true,
                        style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 15,
                            fontFamily: 'poppins-semibold'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text(
                        "Quantity :  10 Metric Ton (MT)",
                        softWrap: true,
                        style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 15,
                            fontFamily: 'poppins-semibold'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text(
                        "Location :  Latur, Maharastra",
                        softWrap: true,
                        style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 15,
                            fontFamily: 'poppins-semibold'),
                      ),
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
                                        Text(
                                          buildTranslate('chat')!,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontFamily: 'poppins-medium'),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          'assets/images/chat.png',
                                          height: 11,
                                          width: 11,
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
                                        borderRadius: BorderRadius.circular(20), // <-- Radius
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          buildTranslate('call')!,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontFamily: 'poppins-medium'),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          'assets/images/call.png',
                                          height: 11,
                                          width: 11,
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const MyEnquiryDetailPage()));
                                    },
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
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:2.0),
                                            child: Text(
                                              buildTranslate('details')!,
                                              softWrap: true,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: 'poppins-medium'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          'assets/images/details.png',
                                          height: 11,
                                          width: 11,
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
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // user card
            Padding(
              padding:
              const EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 180,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              image: DecorationImage(
                                  image:
                                  AssetImage("assets/images/enquiryBG.png"),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, left: 12.0),
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 150,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF008000),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: const Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Price  Rs.25000',
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 11,
                                      fontFamily: "poppins-semibold"),
                                ),
                              )),
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Name :  Ankit",
                        softWrap: true,
                        style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 15,
                            fontFamily: 'poppins-semibold'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text(
                        "Purpose:  To sell",
                        softWrap: true,
                        style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 15,
                            fontFamily: 'poppins-semibold'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text(
                        "Quantity :  10 Metric Ton (MT)",
                        softWrap: true,
                        style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 15,
                            fontFamily: 'poppins-semibold'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text(
                        "Location :  Latur, Maharastra",
                        softWrap: true,
                        style: TextStyle(
                            color: Color(0xFF808080),
                            fontSize: 15,
                            fontFamily: 'poppins-semibold'),
                      ),
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
                                        Text(
                                          buildTranslate('chat')!,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontFamily: 'poppins-medium'),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          'assets/images/chat.png',
                                          height: 11,
                                          width: 11,
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          buildTranslate('call')!,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontFamily: 'poppins-medium'),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          'assets/images/call.png',
                                          height: 11,
                                          width: 11,
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const MyEnquiryDetailPage()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(5),
                                      textStyle: const TextStyle(fontSize: 18),
                                      backgroundColor: const Color(0xFF3FC041),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:2.0),
                                            child: Text(
                                              buildTranslate('details')!,
                                              softWrap: true,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: 'poppins-medium'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          'assets/images/details.png',
                                          height: 11,
                                          width: 11,
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
                      height: 15,
                    ),
                  ],
                ),
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