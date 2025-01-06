import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';

import '../../helper/AlertHelper.dart';
import '../../mvc/controller/accountSettingController.dart';
import '../../mvc/model/GetBankDetails.dart';
import '../../utils/AppGlobal.dart';
import '../../utils/Constants.dart';
import 'ProfilePage.dart';

class EditBankDetailPage extends StatefulWidget {
  const EditBankDetailPage({super.key});

  @override
  State<EditBankDetailPage> createState() => _EditBankDetailPageState();
}

class _EditBankDetailPageState extends State<EditBankDetailPage> {
  TextFormField? bankNameController;
  TextFormField? accountNameController;
  TextFormField? accountNumberController;
  TextFormField? ifscController;

  TextEditingController editBankNameController = TextEditingController();
  TextEditingController editAccountNameController = TextEditingController();
  TextEditingController editAccountNumberController = TextEditingController();
  TextEditingController editIfscController = TextEditingController();

  String number = "";

  Future<BankData?>? futureBankDetails;

  String? bankName;
  String? accountName;
  String? accountNumber;
  String? ifscCode;
  String? _imageUrl;

  final _formKey = GlobalKey<FormState>();
    final ImagePicker _picker = ImagePicker();
  File? _image;

// Function to pick an image from the gallery or camera
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    // _uploadImage(_image!);
  }

  // Function to upload the image to AWS using Dio
  Future<void> _uploadImage(File image) async {
    try {
      // Generate a unique key using the bank name and last 6 digits of the account number
      String uniqueKey = _generateUniqueKey(bankName!, accountNumber!);
      print(uniqueKey);

      // Dio instance for HTTP requests
      Dio dio = Dio();

      // Prepare the form data for the upload
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path, filename: uniqueKey),
      });

      // Send the request
      Response response = await dio.post(
        'https://krishiyanback.vercel.app/api/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        var jsonResponse = response.data;
        String imageKey = jsonResponse['Key'];
         // Construct the image URL
        _imageUrl = 'https://krishiyanback.vercel.app/images/$imageKey';

        setState(() {
          _imageUrl = _imageUrl;
          print(_imageUrl);
        });

        // Handle the successful response
        print("Image uploaded successfully. Image URL: $_imageUrl");
        
        print("Image key: $imageKey");
      } else {
        print("Failed to upload image: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }
  

  // Function to generate a unique key from the bank name and account number
  String _generateUniqueKey(String bankName, String accountNumber) {
    // Remove spaces from the bank name
    String cleanedBankName = bankName.replaceAll(' ', '');

    // Get the last 6 digits of the account number
    String last6Digits = accountNumber.length > 6 ? accountNumber.substring(accountNumber.length - 6) : '';

    // Concatenate the cleaned bank name and the last 6 digits of the account number
    return "$cleanedBankName$last6Digits";
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBankDetails();
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
            const SizedBox(
              width: 10,
            ),
            Text(
              buildTranslate("editBankDetail")!,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'poppins-semibold',
                  fontSize: 20),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            FutureBuilder<BankData?>(
              future: futureBankDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While the future is still loading
                  return const Center(child: CircularProgressIndicator());
                }
                else if (snapshot.hasData) {
                  if (snapshot.data!.toString().isEmpty) {
                    // If the future returns data, but it's empty
                    return const Center(child: Text("No data found"));
                  } else {
                    // If the future returns data, and it's non-empty
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // bank name
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("bankName")!,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF666666),
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              onSaved: (value) => bankName = value,
                              decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  hintText: buildTranslate('enterBankName')!,
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.green, width: 0.5),
                                  )),
                              validator: (value) => value!.isEmpty
                                  ? 'Please, fill this field.'
                                  : null,
                              initialValue: bankNameController == null ? snapshot.data!.bankName.toString() : null,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // account name
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("accountName")!,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF666666),
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => accountName = value,
                              initialValue: accountNameController == null ? snapshot.data!.accountName.toString() : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate("enterAccountName")!,
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                  BorderSide(color: Colors.green, width: 0.5),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // account number
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("accountNumber")!,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF666666),
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => accountNumber = value,
                              initialValue: accountNumberController == null ? snapshot.data!.accountNumber.toString() : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate('enterAccountNumber')!,
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                  BorderSide(color: Colors.green, width: 0.5),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // ifs code
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("IFSCode")!,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF666666),
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => ifscCode = value,
                              initialValue: ifscController == null ? snapshot.data!.ifscCode.toString() : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate("enterIFSCode"),
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                  BorderSide(color: Colors.green, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // passbook upload
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("uploadPhotoOfPassbook")!,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF666666),
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Row(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                                child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          const Color(0xFFd3d3d3)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Color(0xFFe7e7e7))))),
                                  onPressed: _pickImage,
                                  child: Text(buildTranslate('chooseFile')!,
                                      softWrap: true,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontFamily: 'poppins-regular')),
                                ),
                              ),
                              // If an image is picked, display it
        if (_image != null) 
          Image.file(
            _image!,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Text(
                                  buildTranslate("noChooseFile")!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF666666),
                                      fontFamily: 'poppins-regular'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),

                          Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
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
                                    borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                                  ),
                                ),
                                child: Text(
                                  buildTranslate('save')!,
                                  style: const TextStyle(
                                      fontSize: 15, fontFamily: 'poppins-medium'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                      // bank name
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("bankName")!,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF666666),
                              fontFamily: 'poppins-semibold'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              fillColor: Colors.white,
                              filled: true,
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.all(Radius.circular(7.0),
                              //   ),
                              // ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              hintText: buildTranslate('unionBankOfIndia')!,
                              hintStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: const OutlineInputBorder(
                                // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                              )),
                          validator: (value) => value!.isEmpty
                              ? 'Please, fill this field.'
                              : null,
                          controller: editBankNameController,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // account name
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("accountName")!,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF666666),
                              fontFamily: 'poppins-semibold'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: editAccountNameController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate("enterAccountName")!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(color: Colors.green, width: 0.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // account number
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("accountNumber")!,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF666666),
                              fontFamily: 'poppins-semibold'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: editAccountNumberController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate('enterAccountNumber')!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(color: Colors.green, width: 0.5),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // ifs code
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("IFSCode")!,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF666666),
                              fontFamily: 'poppins-semibold'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: editIfscController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate("enterIFSCode"),
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(color: Colors.green, width: 0.5),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // passbook upload
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("uploadPhotoOfPassbook")!,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF666666),
                              fontFamily: 'poppins-semibold'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFFd3d3d3)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xFFe7e7e7))))),
                              onPressed:_pickImage,
                              child: Text(buildTranslate('chooseFile')!,
                                  softWrap: true,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontFamily: 'poppins-regular')),
                            ),
                          ),
                          // If an image is picked, display it
        // Show "No file chosen" text if no image is selected
        if (_image == null)
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              'No file chosen', // Use your translated text here
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF666666),
                fontFamily: 'poppins-regular',
              ),
            ),
          ),

        // If an image is selected, display the image
        if (_image != null)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.file(
              _image!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
                          
                        ],
                      ),

                      const SizedBox(height: 25),

                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                          const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (editBankNameController.text.toString().isNotEmpty &&
                                  editAccountNameController.text.toString().isNotEmpty &&
                                  editAccountNumberController.text.toString().isNotEmpty &&
                                  editIfscController.text.toString().isNotEmpty &&
                                  _imageUrl.toString().isNotEmpty) {
                                _bankDetailsApiCall(
                                    editBankNameController.text.toString(),
                                    editAccountNameController.text.toString(),
                                    editAccountNumberController.text.toString(),
                                    editIfscController.text.toString(),
                                    _imageUrl.toString());
                              } else {
                                AlertHelper.showToast(
                                    "Please enter details.", context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(12),
                              textStyle: const TextStyle(fontSize: 18),
                              backgroundColor: const Color(0xFF3FC041),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: Text(
                              buildTranslate('save')!,
                              style: const TextStyle(
                                  fontSize: 15, fontFamily: 'poppins-medium'),
                            ),
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

  void _getValue() async {

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // This triggers onSaved for each TextFormField
      print("bankName : $bankName");
      // Once the image is selected, proceed to upload it
      // Ensure the image is uploaded first
    if (_image != null) {
      await _uploadImage(_image!);
    }
      print("Image URL");
      print(_imageUrl);

      if (bankName != null && accountName != null &&
          accountNumber != null && ifscCode != null && _imageUrl != null) {
        print("AAAAAAAAAAAAA");
        print(_imageUrl);
        _bankDetailsApiCall(
            bankName.toString(),
            accountName.toString(),
            accountNumber.toString(),
            ifscCode.toString(),
            _imageUrl.toString());
      } else {
        AlertHelper.showToast(
            "Please enter data.", context);
      }
    }
  }

  _bankDetailsApiCall(String bankName, String accountName, String accountNumber,
      String ifscCode, String _imageUrl) async {

    if (bankName.isNotEmpty &&
        accountName.isNotEmpty &&
        accountNumber.isNotEmpty &&
        ifscCode.isNotEmpty &&
        _imageUrl.isNotEmpty ) {
          print("BANK DETAILS UPDATION");
      print(_imageUrl);
      var headers = {'Content-Type': 'application/json'};
      var data = json.encode({
        "uid": number,
        "bankName": bankName,
        "accountName": accountName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "URL": _imageUrl
      });
       print("Request Payload: $data"); // Log the request payload
      var dio = Dio();
      var response = await dio.request(
        UPDATE_BANK_DETAILS,
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 201) {
        print("Bank details updated : " + json.encode(response.data));
        showAlertDialog(context);
      } else {
        print(response.statusMessage);
      }
    }
    else {
      AlertHelper.showToast("Please enter details.", context);
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
                MaterialPageRoute(builder: (context) => const ProfilePage()),
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
          Center(
              child: Image.asset(
                'assets/images/check_green.png',
                width: 100,
                height: 100,
              )),
          const Text(
            "You've Details Updated Successfully!",
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "poppins-semibold",
                fontSize: 15.0,
                color: Colors.grey),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Thank You",
            softWrap: true,
            style: TextStyle(
                fontFamily: "poppins-semibold",
                fontSize: 20.0,
                color: Colors.black),
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

  Future<void> getBankDetails() async {
    number = (await AppGlobal.getStringPreference('contactNumber'))!;
    futureBankDetails = AccountSettingController.fetchBankDetails(context, number);
    setState(() {
      futureBankDetails = futureBankDetails;
    });
  }
}
