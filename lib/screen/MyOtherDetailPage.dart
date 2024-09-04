import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';

import '../helper/AlertHelper.dart';
import '../mvc/controller/accountSettingController.dart';
import '../mvc/model/GetOtherDetails.dart';
import '../utils/AppGlobal.dart';
import '../utils/Constants.dart';
import 'MyProfilePage.dart';

class MyOtherDetailPage extends StatefulWidget {
  const MyOtherDetailPage({super.key});

  @override
  State<MyOtherDetailPage> createState() => _MyOtherDetailPageState();
}

class _MyOtherDetailPageState extends State<MyOtherDetailPage> {

  TextFormField? panCardController;
  TextFormField? gstController;
  TextFormField? udyamController;

  TextEditingController editPanCardController  = TextEditingController();
  TextEditingController editGstController  = TextEditingController();
  TextEditingController editUdyamController  = TextEditingController();

  String number = "";

  Future<OtherData?>? futureOtherDetails;

  String? panCard;
  String? gstNumber;
  String? udyamNumber;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOtherDetails();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      backgroundColor: const Color(0xFFe7e7e7),
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
            const SizedBox(width: 10,),
            Text(
              buildTranslate("otherDetails")!,
              style: TextStyle(color: Colors.white, fontFamily: 'poppins-semibold', fontSize: 20),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30,),

            FutureBuilder<OtherData?>(
              future: futureOtherDetails,
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While the future is still loading
                  return const Center(child: CircularProgressIndicator());
                }
                else if (snapshot.hasData) {
                  if (snapshot.data!.toString().isEmpty) {
                    // If the future returns data, but it's empty
                    return const Center(child: Text("No data found"));
                  }
                  else {
                    // If the future returns data, and it's non-empty
                    return Form(
                        key: _formKey,
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // pan card fpo
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                              child: Text(buildTranslate("PANCardForFPO")!, style: const TextStyle(fontSize: 15,
                                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
                            ),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                                      // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                    hintText: buildTranslate('panCard')!,
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    focusedBorder: const OutlineInputBorder(
                                      // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                                    )
                                ),
                                validator: (value) => value!.isEmpty ? 'Please, fill this field.' : null,
                                initialValue: snapshot.data!.panCardNumber.toString(),
                                onSaved: (value) => panCard = value,
                              ),
                            ),

                            const SizedBox(height: 20,),

                            // gst number
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                              child: Text(buildTranslate("GSTNumber")!, style: const TextStyle(fontSize: 15,
                                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
                            ),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                initialValue: snapshot.data!.gstNumber ?? "",
                                onSaved: (value) => gstNumber = value,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  hintText: buildTranslate("GSTNumber")!,
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),

                            // udhyam aadhaar
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                              child: Text(buildTranslate("udyamAadhaar")!, style: const TextStyle(fontSize: 15,
                                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
                            ),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                onSaved: (value) => udyamNumber = value,
                                initialValue: snapshot.data!.udyamNumber ?? "",
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  hintText: buildTranslate("udyamAadhaar")!,
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 35,),

                            Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _getValue();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(12),
                                    textStyle: const TextStyle(fontSize: 18),
                                    backgroundColor: const Color(0xFF3FC041),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12), // <-- Radius
                                    ),
                                  ),
                                  child: Text(buildTranslate('save')!,
                                    style: const TextStyle(fontSize: 15, fontFamily: 'poppins-medium'),),
                                ),
                              ),
                            ),
                          ],
                        )
                    );
                  }
                }
                else if (snapshot.hasError) {
                  // If the future returns an error
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // pan card fpo
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(buildTranslate("PANCardForFPO")!, style: const TextStyle(fontSize: 15,
                            color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                                // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              hintText: buildTranslate('panCard')!,
                              hintStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: const OutlineInputBorder(
                                // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.green, width: 0.5),
                              )
                          ),
                          validator: (value) => value!.isEmpty ? 'Please, fill this field.' : null,
                          controller: editPanCardController,
                          onSaved: (value) => panCard = value,
                        ),
                      ),

                      const SizedBox(height: 20,),

                      // gst number
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(buildTranslate("GSTNumber")!, style: const TextStyle(fontSize: 15,
                            color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: editGstController,
                          onSaved: (value) => gstNumber = value,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate("GSTNumber")!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.green, width: 0.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),

                      // udhyam aadhaar
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(buildTranslate("udyamAadhaar")!, style: const TextStyle(fontSize: 15,
                            color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (value) => udyamNumber = value,
                          controller: editUdyamController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate("udyamAadhaar")!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.green, width: 0.5),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 35,),

                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (editPanCardController.text.toString().isNotEmpty &&
                                  editGstController.text.toString().isNotEmpty &&
                                  editUdyamController.text.toString().isNotEmpty) {

                                _otherDetailsApiCall(
                                    editPanCardController.text.toString(),
                                    editGstController.text.toString(),
                                    editUdyamController.text.toString());
                              } else {
                                AlertHelper.showToast(
                                    "Please enter credentials.", context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(12),
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor: const Color(0xFF3FC041),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: Text(buildTranslate('save')!,
                              style: const TextStyle(fontSize: 15, fontFamily: 'poppins-medium'),),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),

          ],
        ),
      ),
    );
  }

  void _getValue() {

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // This triggers onSaved for each TextFormField
      print("panCard : $panCard");

      if (panCard != null && gstNumber != null && udyamNumber != null) {

        _otherDetailsApiCall(
            panCard.toString(),
            gstNumber.toString(),
            udyamNumber.toString());
      } else {
        AlertHelper.showToast(
            "Please enter data.", context);
      }
    }
  }

  _otherDetailsApiCall(String panCard, String gstNumber, String udyamNumber) async {

    var headers = {
      'Content-Type': 'application/json'
    };
    var data = json.encode({
      "uid": number,
      "panCardNumber": panCard,
      "gstNumber": gstNumber,
      "udyamNumber": udyamNumber,
      "aadhaarNumber": "1234-5678-9012"
    });
    var dio = Dio();
    var response = await dio.request(
      UPDATE_OTHER_DETAILS,
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 201) {
      print("Other details updated : "+json.encode(response.data));

      showAlertDialog(context);
    }
    else {
      print(response.statusMessage);
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyProfilePage()),
              );
            },
            child: const Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.close,
                color: Colors.black,
                size: 20.0,
              ),
            ),
          ),

          Center(child: Image.asset('assets/images/check_green.png', width: 100, height: 100,)),

          const Text("You've Details Updated Successfully!", softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "poppins-semibold", fontSize: 15.0, color: Colors.grey),),

          const SizedBox(height: 20,),

          const Text("Thank You", softWrap: true,
            style: TextStyle(fontFamily: "poppins-semibold", fontSize: 20.0, color: Colors.black),),

          const SizedBox(height: 20,),
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

  Future<void> getOtherDetails() async{
    number = (await AppGlobal.getStringPreference('contactNumber'))!;
    futureOtherDetails = AccountSettingController.fetchAccountDetails(context, number);
    setState(() {
      futureOtherDetails = futureOtherDetails;
    });
  }

}