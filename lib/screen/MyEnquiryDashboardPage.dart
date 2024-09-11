import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';
import '../mvc/controller/enquiryDashboardController.dart';
import '../mvc/model/GetAllEnquiryData.dart';
import '../mvc/model/GetEnquiryByFilterData.dart';
import '../mvc/model/SelectCropNamesData.dart';
import '../utils/Constants.dart';
import 'MyEnquiryDetailPage.dart';

class MyEnquiryDashboardPage extends StatefulWidget {
  String? selectedCrop;

  MyEnquiryDashboardPage({super.key, this.selectedCrop});

  @override
  State<MyEnquiryDashboardPage> createState() => _MyEnquiryDashboardPageState();
}

class _MyEnquiryDashboardPageState extends State<MyEnquiryDashboardPage>
    with TickerProviderStateMixin {
  TextEditingController? controller;

  late Future<List<EnquiryData>> futureEnquiryData;
  String? _selectedCrop;
  SelectCropNamesData? _cropData;
  bool showData = false;

  @override
  void initState() {
    super.initState();
    _selectedCrop = widget.selectedCrop;
    futureEnquiryData = EnquiryDashboardController.getEnquiryDetailsByCommodity(_selectedCrop.toString());
    _fetchCropData();
  }

  Future<void> _fetchCropData() async {
    try {
      // Replace with your actual API endpoint
      var response = await Dio().get(CROPS_NAMES);

      if (response.statusCode == 200) {
        setState(() {
          _cropData = SelectCropNamesData.fromJson(response.data);
        });
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (e) {
      print('Enquiry Dashboard : Error fetching crop data: $e');
    }
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
        physics: const AlwaysScrollableScrollPhysics(),
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
                    child: _cropData == null || _cropData!.data == null
                        ? const Center(child: Text('No data available'))
                        : DropdownButtonFormField2<String>(
                      dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                      hint: const Text('Select your Commodity'),
                      decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 16),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        // Add more decoration..
                      ),
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 24,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      value: _selectedCrop,
                      items: _cropData!.data!.map((String crop) {
                        return DropdownMenuItem<String>(
                          value: crop,
                          child: Text(crop,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontFamily: 'poppins-regular')),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCrop = newValue;
                        });
                      },
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
                    futureEnquiryData = EnquiryDashboardController.getEnquiryDetailsByCommodity(_selectedCrop.toString());
                    setState(() {
                      futureEnquiryData = futureEnquiryData;
                    });
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
                    style: const TextStyle(
                        fontSize: 18, fontFamily: 'poppins-medium'),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            // showData
            //     ?
            FutureBuilder<List<EnquiryData>>(
              future: futureEnquiryData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('No Data Available'));
                } else if (snapshot.hasData) {
                  final List<EnquiryData> commodities = snapshot.data!;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: commodities.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final commodity = commodities[index];
                      return
                        // user card
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, right: 20.0, left: 20.0),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      width:
                                      MediaQuery.of(context).size.width,
                                      height: 180,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/enquiryBG.png"),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, left: 12.0),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 150,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF008000),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(5.0),
                                            child: Text(
                                              'Price  Rs.${commodity.price.toString()}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontFamily:
                                                  "poppins-semibold"),
                                            ),
                                          )),
                                    ),
                                  ),
                                ]),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    "Name : ${commodity.uid.toString()}",
                                    softWrap: true,
                                    style: const TextStyle(
                                        color: Color(0xFF808080),
                                        fontSize: 15,
                                        fontFamily: 'poppins-semibold'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, top: 10.0),
                                  child: Text(
                                    "Purpose: ${commodity.operation.toString()}",
                                    softWrap: true,
                                    style: const TextStyle(
                                        color: Color(0xFF808080),
                                        fontSize: 15,
                                        fontFamily: 'poppins-semibold'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, top: 10.0),
                                  child: Text(
                                    "Quantity :  ${commodity.quantity.toString()}",
                                    softWrap: true,
                                    style: const TextStyle(
                                        color: Color(0xFF808080),
                                        fontSize: 15,
                                        fontFamily: 'poppins-semibold'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, top: 10.0),
                                  child: Text(
                                    "Location : ${commodity.location.toString()}",
                                    softWrap: true,
                                    style: const TextStyle(
                                        color: Color(0xFF808080),
                                        fontSize: 15,
                                        fontFamily: 'poppins-semibold'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, top: 10.0),
                                  child: Container(
                                    width:
                                    MediaQuery.of(context).size.width,
                                    height: 50,
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton
                                                    .styleFrom(
                                                  foregroundColor:
                                                  Colors.white,
                                                  padding:
                                                  const EdgeInsets.all(
                                                      5),
                                                  textStyle:
                                                  const TextStyle(
                                                      fontSize: 18),
                                                  backgroundColor:
                                                  const Color(
                                                      0xFF3FC041),
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        20), // <-- Radius
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text(
                                                      buildTranslate(
                                                          'chat')!,
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          fontFamily:
                                                          'poppins-medium'),
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton
                                                    .styleFrom(
                                                  foregroundColor:
                                                  Colors.white,
                                                  padding:
                                                  const EdgeInsets.all(
                                                      3),
                                                  textStyle:
                                                  const TextStyle(
                                                      fontSize: 18),
                                                  backgroundColor:
                                                  const Color(
                                                      0xFF3FC041),
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        20), // <-- Radius
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text(
                                                      buildTranslate(
                                                          'call')!,
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          fontFamily:
                                                          'poppins-medium'),
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyEnquiryDetailPage(
                                                                  commodity:
                                                                  commodities[
                                                                  index])));
                                                },
                                                style: ElevatedButton
                                                    .styleFrom(
                                                  foregroundColor:
                                                  Colors.white,
                                                  padding:
                                                  const EdgeInsets.all(
                                                      5),
                                                  textStyle:
                                                  const TextStyle(
                                                      fontSize: 18),
                                                  backgroundColor:
                                                  const Color(
                                                      0xFF3FC041),
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        20), // <-- Radius
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 2.0),
                                                        child: Text(
                                                          buildTranslate(
                                                              'details')!,
                                                          softWrap: true,
                                                          maxLines: 2,
                                                          style: const TextStyle(
                                                              fontSize: 11,
                                                              fontFamily:
                                                              'poppins-medium'),
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
                        );
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
            // : Container(),
          ],
        ),
      ),
      // drawer: MyDrawer(),
    );
  }
}
