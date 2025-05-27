import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:krishiyan/helper/constant.dart';
import '../../../../helper/app_global.dart';
import 'package:flutter/material.dart';
import '../../../../helper/alert_helper.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/style.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:krishiyan/mvc/model/GetFRMProfileData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../mvc/controller/accountSettingController.dart';
import 'package:krishiyan/screen/dashboard/dashborad.dart';
import 'package:krishiyan/localization/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image; // To store the selected image file
  final ImagePicker _picker = ImagePicker();
  TextFormField? nameOfOrganizationController;
  TextEditingController dateOfOrganizationController = TextEditingController();
  TextFormField? registrationNumberController;
  TextFormField? cbboNameController;
  TextFormField? officeContactNumberController;
  TextFormField? emailIdController;
  TextFormField? nameOfPromoterController;
  TextFormField? yourDesignationController;

  TextEditingController editNameOfOrganizationController =
      TextEditingController();
  TextEditingController editDateOfOrganizationController =
      TextEditingController();
  TextEditingController editRegistrationNumberController =
      TextEditingController();
  TextEditingController editCbboNameController = TextEditingController();
  TextEditingController editOfficeContactNumberController =
      TextEditingController();
  TextEditingController editEmailIdController = TextEditingController();
  TextEditingController editNameOfPromoterController = TextEditingController();
  TextEditingController editYourDesignationController = TextEditingController();

  String id = "",
      contactNumber = "",
      dateOfOrganizationValue = "",
      typeOfOrg = "";
  // Method to pick an image from the gallery
  String? _imageUrl; // AWS image URL

  Future<void> _pickImage(String organizationName) async {
    // Check if the organization name is empty and handle accordingly
    if (organizationName.isEmpty) {
      print("Please provide the organization name before uploading an image.");
      return;
    }

    // Pick image from the gallery
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Generate a custom file name with the organization name
      String modifiedFileName = '${organizationName}_profile_image.jpg';

      // Get the app's document directory to store the image
      final appDir = await getApplicationDocumentsDirectory();
      final directory = Directory('${appDir.path}/images');

      // Create the directory if it doesn't exist
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Define the local file path with the modified file name
      final File localImageFile = File('${directory.path}/$modifiedFileName');

      // Copy the picked image to the new local file path
      await File(pickedFile.path).copy(localImageFile.path);

      // Save the new image path in SharedPreferences for caching
      await _saveImagePath(localImageFile.path);

      // Update the UI with the new image
      setState(() {
        _image = localImageFile; // Display the local image on the UI
      });

      // Upload the image to AWS
      await _uploadImageToAWS(localImageFile,
          organizationName); // Pass the org name to upload function
    }
  }

  Future<void> _saveImagePath(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        '${editNameOfOrganizationController.text}_image_path', imagePath);
    print("Image path saved: $imagePath");
  }

  Future<void> _loadImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    final savedImagePath =
        prefs.getString('${editNameOfOrganizationController.text}_image_path');
    if (savedImagePath != null && savedImagePath.isNotEmpty) {
      setState(() {
        _image = File(savedImagePath); // Load the saved image file
      });
    }
  }

  Future<void> _uploadImageToAWS(
      File imageFile, String organizationName) async {
    Dio dio = Dio();

    if (organizationName.isEmpty) {
      print("Organization name is empty. Please enter a valid name.");
      return;
    }

    // Modify the file name based on the organization name
    String modifiedFileName = '${organizationName}_profile_image.jpg';

    try {
      // Prepare the image for upload with the modified file name
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path,
            filename: modifiedFileName), // Use the modified name
      });

      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final signature = hmacSha256(encryptionKey, timestamp);

      // Send the request to the API
      Response response = await dio.post('${baseUrl}upload',
          data: formData,
          options: Options(headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Connection": "application/json",
            "Authorization": 'Bearer',
            'x-timestamp': timestamp,
            'x-signature': signature,
          }));

      // Debugging: Print the full response to check the returned data
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        // The server has responded with a success (HTTP 200)
        var responseData = response.data;

        // You can retrieve the Location or the key for the uploaded image
        String uploadedImageUrl = responseData[
            'Location']; // This is the full URL to access the image

        // Debugging: Print the uploaded image URL
        print("Image uploaded successfully: $uploadedImageUrl");

        // Save the uploaded image URL to SharedPreferences for caching
        await _saveImageUrl(uploadedImageUrl);

        // Update the UI with the uploaded image URL
        setState(() {
          _imageUrl =
              uploadedImageUrl; // Store the image URL in state to display it
        });
      } else {
        // In case of an error response from the server (non-200 status)
        print("Failed to upload image. Status code: ${response.statusCode}");
        print(
            "Error details: ${response.data}"); // Print the error response body
      }
    } catch (e) {
      // Handle any errors that occur during the image upload process
      print("Error uploading image: $e");

      if (e is DioError) {
        // If the error is a DioError, print more specific details
        print("Dio error type: ${e.type}");
        print("Dio error message: ${e.message}");
        if (e.response != null) {
          // Print the server's response, even if it's an error
          print("Dio error response: ${e.response?.data}");
        }
      }
    }

    // Optionally load the saved image URL to make sure the image is reflected on the UI
    _loadImageUrl(organizationName);
  }

  Future<void> _saveImageUrl(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('uploaded_image_url',
        imageUrl); // Save URL to shared preferences (cache)
    print("Image URL saved: $imageUrl");
  }

  Future<void> _loadImageUrl(String organizationName) async {
    if (organizationName.isEmpty) {
      print("Organization name is empty. Please enter a valid name.");
      return;
    }

    // Construct the image URL
    String imageUrl =
        '${baseUrlEnd}images/${organizationName}_profile_image.jpg';
    print("Fetching image from URL: $imageUrl");

    // Update the UI with the fetched image URL
    setState(() {
      _imageUrl = imageUrl; // Store the fetched image URL to display it
    });
  }

  String convertDateFormat(String date) {
    try {
      // Parse the input date string in "dd-MM-yyyy" format

      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);

      // Format the parsed date to "yyyy-MM-dd" format

      String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

      return formattedDate;
    } catch (e) {
      // Handle invalid date formats

      print("Error parsing date: $e");

      return date;
    }
  }

  final List<String> fpoItems = [
    buildTranslate('farmerProducerOrganization')!,
    buildTranslate('farmerProducerCompany')!,
    buildTranslate('primaryAgriculturalCreditSociety')!,
    buildTranslate('farmerInterestedGroups')!,
    buildTranslate('co-operatives')!
  ];

  String? selectedFPOItemValue;
  bool otpVisible = false;

  Future<GetFRMProfileDetails?>? futureProfileDetails;

  String? nameOfOrganization;
  String? dateOfOrganization;
  String? registrationNumber;
  String? cbboName;
  String? officeContactNumber;
  String? emailId;
  String? nameOfPromoter;
  String? yourDesignation;
  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>();
  late OtpFieldController otpController = OtpFieldController();
  String enteredOtp = '';
  String otpData = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileDetails();
    _loadImagePath();
  }

  update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("Selected FPO Item");
    print(selectedFPOItemValue);
    print('fpoItems : ');
    fpoItems.forEach((e) {
      print("i : $e");
    });
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
              buildTranslate("editProfile")!,
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
            FutureBuilder<GetFRMProfileDetails?>(
              future: futureProfileDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While the future is still loading
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  if (snapshot.data!.toString().isEmpty) {
                    // If the future returns data, but it's empty
                    return const Center(child: Text("No data found"));
                  } else {
                    print('snapshot : ${snapshot.data!.toJson()}');

                    print(
                        'snapshot.data!.registrationNumber : ${snapshot.data!.registrationNumber}');

                    print('_imageUrl : ${_imageUrl}');

                    print('_image : ${_image}');

                    print(
                        'condition : ${_imageUrl != null && _imageUrl!.isNotEmpty}');
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: Stack(
                                clipBehavior: Clip.none,
                                fit: StackFit.expand,
                                children: [
                                  CircleAvatar(
                                    key: ValueKey<File>(_image ??
                                        File(
                                            '')), // Use _imageUrl to refresh widget
                                    backgroundColor: Colors.white,
                                    backgroundImage: _imageUrl != null &&
                                            _imageUrl!.isNotEmpty
                                        ? NetworkImage(
                                            "${_imageUrl!}?${DateTime.now().millisecondsSinceEpoch}") // Show AWS image URL

                                        : _image != null
                                            ? FileImage(
                                                _image!) // Show local selected image

                                            : AssetImage(
                                                    "assets/images/user_profile.png")
                                                as ImageProvider, // Default image
                                  ),
                                  // Positioned camera icon button to upload new image
                                  Positioned(
                                    bottom: 35,
                                    right: -45,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        String organizationName = snapshot
                                                .data!.nameOfFpo
                                                ?.toString() ??
                                            "";

                                        if (organizationName.isNotEmpty) {
                                          _pickImage(
                                              organizationName); // Pass the organization name to the function
                                        } else {
                                          print(
                                              "Please provide the organization name before uploading an image.");
                                        }
                                      }, // Open image picker when tapped
                                      elevation: 10.0,
                                      padding: const EdgeInsets.all(15.0),
                                      shape: const CircleBorder(),
                                      fillColor: Colors.white,
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 20.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // fpo name
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("nameOfOrganization")!,
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
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              onSaved: (value) => nameOfOrganization = value,
                              initialValue:
                                  snapshot.data!.nameOfFpo?.toString() ?? "",
                              decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  hintText: buildTranslate(
                                      'enterNameOfTheOrganization')!,
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  focusedBorder: const OutlineInputBorder(
                                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 0.5),
                                  )),
                              validator: (value) => value!.isEmpty
                                  ? 'Please, fill this field.'
                                  : null,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // Image Upload Section

                          const SizedBox(height: 20),

                          // type of fpo
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("typeOfOrganization")!,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF666666),
                                  fontFamily: 'poppins-semibold'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // GestureDetector(
                          //   onTapDown: (TapDownDetails details) {
                          //     servingPopupMenu(
                          //       context,
                          //       details.globalPosition,
                          //       update,
                          //     );
                          //   },
                          //   child: Container(
                          //     margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          //     height: 30,
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(20),
                          //     ),
                          //     child: Padding(
                          //       padding:
                          //           const EdgeInsets.symmetric(horizontal: 8),
                          //       child: Row(
                          //         children: [
                          //           Expanded(
                          //             child: Text(
                          //               selectedFPOItemValue == null ? "" : selectedFPOItemValue,
                          //               style: const TextStyle(
                          //                 color: Colors.black,
                          //                 fontSize: 9,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //               overflow: TextOverflow.ellipsis,
                          //             ),
                          //           ),
                          //           const Icon(
                          //             Icons.keyboard_arrow_down,
                          //             color: Colors.black,
                          //             size: 25,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Container(
                              color: Colors.white,
                              child: DropdownButtonFormField2<String>(
                                value: () {
                                  if (!fpoItems
                                      .contains(selectedFPOItemValue)) {
                                    selectedFPOItemValue =
                                        null; // Reset to null if not valid
                                    return null;
                                  }
                                  return selectedFPOItemValue;
                                }(),
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                hint: const Text(
                                  '--',
                                  style: TextStyle(fontSize: 14),
                                ),
                                items: fpoItems
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
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
                                  setState(() {
                                    selectedFPOItemValue = value.toString();
                                  });
                                },
                                onSaved: (value) {
                                  selectedFPOItemValue = value.toString();
                                },
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
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // date
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("dateOfOrganization")!,
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
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              controller: dateOfOrganizationController,
                              keyboardType: TextInputType.text,
                              onSaved: (value) => dateOfOrganization = value,
                              // initialValue:
                              // dateOfOrganizationController == null
                              //     ? AppGlobal.convertToCustomDateFormat(snapshot.data!.dateOfFpo.toString())
                              //     : null,
                              // initialValue: AppGlobal.convertToCustomDateFormat(snapshot.data!.dateOfFpo.toString()),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: 'DD/MM/YYYY',
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () {
                                    print(
                                        "OnPressed : $dateOfOrganizationValue");
                                    _selectDate(context,
                                        dateOfOrganizationValue.toString());
                                  }, // Open date picker on icon press
                                ),
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
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // registration number
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("registrationNumber")!,
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
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => registrationNumber = value,
                              initialValue: snapshot.data!.registrationNumber
                                      ?.toString() ??
                                  "",
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate('registrationNumber')!,
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
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // CBBOName
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("CBBOName")!,
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
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => cbboName = value,
                              initialValue:
                                  snapshot.data!.cBBOName?.toString() ?? "",
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate('CBBOName')!,
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
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // contact number
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("officeContactNumberData")!,
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
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => officeContactNumber = value,
                              initialValue:
                                  snapshot.data!.contactNumber?.toString() ??
                                      "",
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText:
                                    buildTranslate('officeContactNumberData')!,
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
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // email id
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("emailId")!,
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
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              onSaved: (value) => emailId = value,
                              initialValue: snapshot.data!.organizationalEmail
                                      ?.toString() ??
                                  "",
                              decoration: InputDecoration(
                                enabled: true,
                                alignLabelWithHint: true,
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                hintText: buildTranslate('mailID')!,
                                hintStyle: const TextStyle(color: Colors.grey),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? 'Please, fill this field.'
                                  : null,
                            ),
                          ),

                          otpVisible
                              ? const SizedBox(
                                  height: 15,
                                )
                              : Container(),

                          // verify otp
                          Visibility(
                            visible: otpVisible,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0),
                              child: Text(
                                buildTranslate("verifyOtp")!,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF666666),
                                    fontFamily: 'poppins-semibold'),
                              ),
                            ),
                          ),
                          otpVisible
                              ? const SizedBox(
                                  height: 15,
                                )
                              : Container(),
                          Visibility(
                            visible: otpVisible,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: OTPTextField(
                                  controller: otpController,
                                  length: 4,
                                  // borderColor: const Color(0xFF3dc33b),
                                  // showFieldAsBox: true,
                                  // filled: true,
                                  width: MediaQuery.of(context).size.width,
                                  textFieldAlignment:
                                      MainAxisAlignment.spaceAround,
                                  fieldWidth: 55,
                                  fieldStyle: FieldStyle.box,
                                  outlineBorderRadius: 10,
                                  style: TextStyle(fontSize: 17),
                                  onChanged: (code) {
                                    print("Changed: " + code);
                                  },
                                  onCompleted: (code) {
                                    print("Completed: " + code);
                                  }),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // Name of Promoter or CEO
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("nameOfPromoterOrCEO")!,
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
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => nameOfPromoter = value,
                              initialValue: nameOfPromoter == null
                                  ? snapshot.data!.promoterName.toString()
                                  : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText:
                                    buildTranslate("nameOfPromoterOrCEO")!,
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // Your Designation
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              buildTranslate("yourDesignation")!,
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
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (value) => yourDesignation = value,
                              initialValue: yourDesignationController == null
                                  ? snapshot.data!.yourDesignation.toString()
                                  : null,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                hintText: buildTranslate("yourDesignation")!,
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),

                          Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0),
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
                                      fontSize: 15,
                                      fontFamily: 'poppins-medium'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  // If the future returns an error
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // fpo name
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("nameOfOrganization")!,
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
                          onSaved: (value) => nameOfOrganization = value,
                          controller: editNameOfOrganizationController,
                          decoration: InputDecoration(
                              alignLabelWithHint: true,
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              hintText:
                                  buildTranslate('enterNameOfTheOrganization')!,
                              hintStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: const OutlineInputBorder(
                                // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.green, width: 0.5),
                              )),
                          validator: (value) => value!.isEmpty
                              ? 'Please, fill this field.'
                              : null,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // type of fpo
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("typeOfOrganization")!,
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
                        child: Container(
                          color: Colors.white,
                          child: DropdownButtonFormField2<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              // Add more decoration..
                            ),
                            hint: const Text(
                              '--',
                              style: TextStyle(fontSize: 14),
                            ),
                            items: fpoItems
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
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
                              setState(() {
                                selectedFPOItemValue = value.toString();
                              });
                            },
                            onSaved: (value) {
                              selectedFPOItemValue = value.toString();
                            },
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
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // date
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("dateOfOrganization")!,
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
                          onSaved: (value) => dateOfOrganization = value,
                          controller: editDateOfOrganizationController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: 'DD/MM/YYYY',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () {
                                _selectDate(context, dateOfOrganization ?? "");
                              }, // Open date picker on icon press
                            ),
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
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // registration number
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("registrationNumber")!,
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
                          onSaved: (value) => registrationNumber = value,
                          controller: editRegistrationNumberController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate('registrationNumber')!,
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

                      // CBBOName
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("CBBOName")!,
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
                          onSaved: (value) => cbboName = value,
                          controller: editCbboNameController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate('CBBOName')!,
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

                      // contact number
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("officeContactNumberData")!,
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
                          onSaved: (value) => officeContactNumber = value,
                          controller: editOfficeContactNumberController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText:
                                buildTranslate('officeContactNumberData')!,
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

                      // email id
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("emailId")!,
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
                          onSaved: (value) => emailId = value,
                          controller: editEmailIdController,
                          decoration: InputDecoration(
                            enabled: true,
                            alignLabelWithHint: true,
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            hintText: buildTranslate('mailID')!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.green, width: 0.5),
                            ),
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(70, 35),
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(fontSize: 15),
                                  backgroundColor: const Color(0xFF3FC041),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                child: Text(buildTranslate("getOtp")!),
                                onPressed: () {
                                  setState(() {
                                    otpVisible = true;
                                  });
                                },
                              ),
                            ),
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please, fill this field.'
                              : null,
                        ),
                      ),

                      otpVisible
                          ? const SizedBox(
                              height: 15,
                            )
                          : Container(),

                      // verify otp
                      Visibility(
                        visible: otpVisible,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 25.0, right: 25.0),
                          child: Text(
                            buildTranslate("verifyOtp")!,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF666666),
                                fontFamily: 'poppins-semibold'),
                          ),
                        ),
                      ),
                      otpVisible
                          ? const SizedBox(
                              height: 15,
                            )
                          : Container(),
                      Visibility(
                        visible: otpVisible,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: OTPTextField(
                              controller: otpController,
                              length: 4,
                              // borderColor: const Color(0xFF3dc33b),
                              // showFieldAsBox: true,
                              // filled: true,
                              width: MediaQuery.of(context).size.width,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldWidth: 55,
                              fieldStyle: FieldStyle.box,
                              outlineBorderRadius: 10,
                              style: TextStyle(fontSize: 17),
                              onChanged: (code) {
                                print("Changed: " + code);
                              },
                              onCompleted: (code) {
                                print("Completed: " + code);
                              }),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // Name of Promoter or CEO
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("nameOfPromoterOrCEO")!,
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
                          onSaved: (value) => nameOfPromoter = value,
                          controller: editNameOfPromoterController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate("nameOfPromoterOrCEO")!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
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

                      // Your Designation
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          buildTranslate("yourDesignation")!,
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
                          onSaved: (value) => yourDesignation = value,
                          controller: editYourDesignationController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: buildTranslate("yourDesignation")!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
                            border: const OutlineInputBorder(),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 0.5),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                              const EdgeInsets.only(left: 25.0, right: 25.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (editNameOfOrganizationController.text.toString().isNotEmpty &&
                                  selectedFPOItemValue.toString().isNotEmpty &&
                                  editDateOfOrganizationController.text
                                      .toString()
                                      .isNotEmpty &&
                                  editRegistrationNumberController.text
                                      .toString()
                                      .isNotEmpty &&
                                  editOfficeContactNumberController.text
                                      .toString()
                                      .isNotEmpty &&
                                  editEmailIdController.text
                                      .toString()
                                      .isNotEmpty &&
                                  editNameOfPromoterController.text
                                      .toString()
                                      .isNotEmpty &&
                                  editCbboNameController.text
                                      .toString()
                                      .isNotEmpty &&
                                  editYourDesignationController.text
                                      .toString()
                                      .isNotEmpty) {
                                _saveImagePath(_image?.path ?? '');
                                _updateProfileDetailsApiCall(
                                    editNameOfOrganizationController.text
                                        .toString(),
                                    selectedFPOItemValue.toString(),
                                    editDateOfOrganizationController.text
                                        .toString(),
                                    editRegistrationNumberController.text
                                        .toString(),
                                    editOfficeContactNumberController.text
                                        .toString(),
                                    editEmailIdController.text.toString(),
                                    editNameOfPromoterController.text
                                        .toString(),
                                    editCbboNameController.text.toString(),
                                    editYourDesignationController.text
                                        .toString());
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
                      const SizedBox(
                        height: 20,
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

  Future<void> _selectDate(BuildContext context, String date) async {
    // Show the date picker dialog
    if (date.isNotEmpty) {
      selectedDate = DateTime.parse(date).toLocal();
      print("selectedDate : $selectedDate");
    }
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate != null
          ? selectedDate
          : DateTime.now(), // Default date is the current date
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime.now(), // Latest selectable date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      print("pickedDate : $pickedDate");
      setState(() {
        // Format the selected date and display it in the TextFormField
        dateOfOrganizationController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
        dateOfOrganizationValue = "${pickedDate}Z";
      });
    }
  }

  void _getValue() {
    print('Testing A');
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!
          .save(); // This triggers onSaved for each TextFormField
      print('Testing B');

      if (nameOfOrganization != null &&
          selectedFPOItemValue != null &&
          dateOfOrganization != null &&
          registrationNumber != null &&
          officeContactNumber != null &&
          emailId != null &&
          nameOfPromoter != null &&
          cbboName != null &&
          yourDesignation != null) {
        print('Testing C');

        _updateProfileDetailsApiCall(
            nameOfOrganization.toString(),
            selectedFPOItemValue.toString(),
            dateOfOrganization.toString(),
            registrationNumber.toString(),
            officeContactNumber.toString(),
            emailId.toString(),
            nameOfPromoter.toString(),
            cbboName.toString(),
            yourDesignation.toString());
      } else {
        AlertHelper.showToast("Please enter data.", context);
      }
    }
  }

  _updateProfileDetailsApiCall(
      String nameOfOrganization,
      String typeOfOrganization,
      String dateOrganization,
      String registrationNumber,
      String officeNumber,
      String emailID,
      String promoterName,
      String cbboName,
      String designation) async {
    print('Testing D');

    if (nameOfOrganization.isNotEmpty &&
        typeOfOrganization.isNotEmpty &&
        dateOfOrganization.toString().isNotEmpty &&
        registrationNumber.isNotEmpty &&
        officeNumber.isNotEmpty &&
        emailID.isNotEmpty &&
        promoterName.isNotEmpty &&
        cbboName.isNotEmpty &&
        designation.isNotEmpty) {
      print('Testing E');
      var data = json.encode({
        "nameOfFpo": nameOfOrganization,
        "typeOfFpo": typeOfOrganization,
        "dateOfFpo": convertDateFormat(dateOfOrganization!),
        "organizationalEmail": emailID,
        "contactNumber": officeNumber,
        "yourDesignation": designation,
        "promoterName": promoterName,
        "RegistrationNumber": registrationNumber,
        "CBBOName": cbboName
      });
      print('data  : $data');

      // var dio = Dio();
      print('link : ${FRM_UPDATE_PROFILE_DETAILS + contactNumber}');
      var response = await putAPICall(
        apiUrl: FRM_UPDATE_PROFILE_DETAILS + contactNumber,
        parameter: data,
      );
      print('response1 : ${response.statusCode}');
      print('response2 : ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("Profile details updated : ${data}");

        showAlertDialog(context);
      } else {
        print(response);
        var data = jsonDecode(response.body);
        AlertHelper.showToast(
            "Fail to update profile : Error ${data['message']}", context);
      }
    } else {
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
                MaterialPageRoute(
                    builder: (context) => HomePage(
                        selectedIndex: 3, typeOfOrganization: "Farmer groups")),
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

  Future<void> getProfileDetails() async {
    id = (await AppGlobal.getStringPreference('id'))!;
    print("IDDD");
    print(id);
    contactNumber = (await AppGlobal.getStringPreference('contactNumber'))!;
    print("contactNumber : $contactNumber");
    futureProfileDetails = AccountSettingController.fetchFRMEditProfileDetails(
        context, contactNumber);
    setState(() {
      futureProfileDetails = futureProfileDetails;
    });
    Future.delayed(Duration(seconds: 2), () async {
      dateOfOrganizationValue =
          (await AppGlobal.getStringPreference('dateOfOrganization'))!;
      typeOfOrg = (await AppGlobal.getStringPreference('typeOfOrg'))!;
      setState(() {
        dateOfOrganizationValue = dateOfOrganizationValue;
        selectedFPOItemValue = typeOfOrg;
      });
      dateOfOrganizationController.text =
          AppGlobal.convertToCustomDateFormat(dateOfOrganizationValue);
    });
  }
}
