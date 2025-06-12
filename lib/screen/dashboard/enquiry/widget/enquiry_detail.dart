import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:krishiyan/helper/constant.dart';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/helper/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../helper/alert_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:krishiyan/mvc/model/all_enquiry_model.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class EnquiryDetailPage extends StatefulWidget {
  EnquiryData commodity;

  EnquiryDetailPage({super.key, required this.commodity});

  @override
  State<EnquiryDetailPage> createState() => _EnquiryDetailPageState();
}

class _EnquiryDetailPageState extends State<EnquiryDetailPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
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
              child: Image.asset('assets/images/back.png'),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Enquiry Detail",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'poppins-medium',
                fontSize: 20,
              ),
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
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 210,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        image: DecorationImage(
                          image: widget.commodity.photoVideoLink != null &&
                                  widget.commodity.photoVideoLink!.isNotEmpty
                              ? NetworkImage(
                                  widget.commodity.photoVideoLink ?? '',
                                )
                              : const AssetImage("assets/images/enquiryBG.png")
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10.0,
                  ),

                  //name
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Expanded(
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
                            widget.commodity.uid ?? "",
                            softWrap: true,
                            style: const TextStyle(
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

                  //Purpose
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Expanded(
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
                            widget.commodity.operation ?? "",
                            softWrap: true,
                            style: const TextStyle(
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
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Expanded(
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
                            widget.commodity.price.toString(),
                            softWrap: true,
                            style: const TextStyle(
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

                  //Quantity
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Expanded(
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
                            widget.commodity.quantity.toString(),
                            softWrap: true,
                            style: const TextStyle(
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

                  //Location
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "Location :",
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
                            widget.commodity.location.toString(),
                            softWrap: true,
                            style: const TextStyle(
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

                  //Moisture
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Expanded(
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
                            widget.commodity.moisture.toString(),
                            softWrap: true,
                            style: const TextStyle(
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

                  //Grade
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Expanded(
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
                            widget.commodity.localGradeSpecification ?? "",
                            softWrap: true,
                            style: const TextStyle(
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

                  //Size
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Expanded(
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
                            widget.commodity.size.toString(),
                            softWrap: true,
                            style: const TextStyle(
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

                  //Count
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Expanded(
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
                            widget.commodity.count.toString(),
                            softWrap: true,
                            style: const TextStyle(
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

                  //TargetedPrice
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Expanded(
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
                            widget.commodity.price.toString(),
                            softWrap: true,
                            style: const TextStyle(
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

                  //Expected Purchase Date
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Expanded(
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
                            convertDate(widget.commodity.date ?? ""),
                            softWrap: true,
                            style: const TextStyle(
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
                                  onPressed: () {
                                    AlertHelper.showToast(
                                        "This feature is locked", context);
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  onPressed: () async {
                                    PermissionStatus phonePermissionStatus =
                                        await Permission.phone.status;

                                    if (phonePermissionStatus.isGranted) {
                                      // Ensure `uid` is a valid phone number
                                      if (widget.commodity.uid != null &&
                                          widget.commodity.uid!.isNotEmpty) {
                                        final phoneNumber =
                                            widget.commodity.uid!;
                                        final Uri url =
                                            Uri.parse('tel:$phoneNumber');

                                        // Launch the URL to open the dialer
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url);
                                        } else {
                                          // Handle case when the dialer cannot be launched
                                          print(
                                              "Could not launch the phone dialer");
                                        }
                                      } else {
                                        // Handle the case when the uid is empty or null
                                        print("No valid phone number");
                                      }
                                    } else {
                                      // Handle the case when phone permission is not granted
                                      print("Phone permission not granted");
                                      AlertHelper.showToast(
                                          "Phone permission is not granted. Please enable it in settings.",
                                          context);

                                      // Optionally, request the permission
                                      await Permission.phone.request();

                                      // Recheck the permission after requesting
                                      if (await Permission.phone.isGranted) {
                                        // Retry calling the number after permission is granted
                                        final phoneNumber =
                                            widget.commodity.uid!;
                                        final Uri url =
                                            Uri.parse('tel:$phoneNumber');
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url);
                                        }
                                      } else {
                                        // If still not granted, guide user to settings
                                        openAppSettings();
                                      }
                                    }
                                  },
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String userId =
                                        await prefs.get('id').toString();
                                    var parameter = {
                                      "userId": userId,
                                    };
                                    showLoading();
                                    var response = await postAPICall(
                                      apiUrl:
                                          "${baseUrl}wishlist/add/${widget.commodity.sId}",
                                      parameter: json.encode(parameter),
                                    );

                                    if (response.statusCode == 201 ||
                                        response.statusCode == 202 ||
                                        response.statusCode == 200) {
                                      final data = json.decode(response.body);
                                      setSnackbar(data['message']);
                                    } else {
                                      setSnackbar(
                                          'Something went wrong! ${response.body.toString()}');
                                    }
                                    stopLoading();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(5),
                                    textStyle: const TextStyle(fontSize: 15),
                                    backgroundColor: const Color(0xFF3FC041),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 2),
                                          child: Text(
                                            'Interested',
                                            softWrap: true,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'poppins-medium',
                                            ),
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
    );
  }
}

String convertDate(String dateString) {
  try {
    // Parse the date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object into "dd-MM-yyyy"
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

    return formattedDate;
  } catch (e) {
    return dateString;
  }
}
