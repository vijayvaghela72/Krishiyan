import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../../helper/app_global.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../helper/alert_helper.dart';
import 'package:krishiyan/helper/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../mvc/model/crop_name_model.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import '../../../../mvc/controller/enquiry_dashboard_controller.dart';

class BuyCommodityPage extends StatefulWidget {
  const BuyCommodityPage({super.key});

  @override
  State<BuyCommodityPage> createState() => _BuyCommodityPageState();
}

class _BuyCommodityPageState extends State<BuyCommodityPage> {
  TextEditingController varietyController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController moistureController = TextEditingController();
  TextEditingController localGradeController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController dateOfDeliveryController = TextEditingController();
  TextEditingController originCommodityController = TextEditingController();
  TextEditingController deliveryLocationController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  bool _isUploading = false;

  String id = "";
  String? _selectedCrop;
  SelectCropNamesData? _cropData;

  final List<String> quantityItems = ['Ton', 'Kg', 'Qtl'];
  String? selectedQuantityItemValue;

  final List<String> sizeItems = ['MM', 'CM'];
  String? selectedSizeItemValue;

  final List<String> purchaseItems = ['Kg', 'Qtl', 'Ton'];
  String? selectedPurchaseItemValue;
  String? contactNumber;

  @override
  void initState() {
    super.initState();
    _fetchCropData();
    getProfileDetails();
  }

  Future<void> _fetchCropData() async {
    try {
      var response = await getAPICall(apiUrl: CROPS_NAMES);
      if (response.statusCode == 200) {
        _cropData = SelectCropNamesData.fromJson(jsonDecode(response.body));
        setState(() {});
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (e) {
      print('Buy Commodity : Error fetching crop data: $e');
    }
  }

  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _imageUrl;
  // Cache expiration in days
  final int cacheExpirationDays = 10;

  // Generate a unique file name for the image
  String generateFileName(String id) {
    String timestamp = DateFormat("yyyyMMdd_HHmmss").format(DateTime.now());
    String? crop = _selectedCrop;
    // Encode the crop name to handle spaces and special characters
    String encodedCrop = Uri.encodeComponent(crop ?? "");

    // Return the formatted file name with the encoded crop name
    return "${id}_${encodedCrop}_$timestamp.png";
  }

// Pick an image from the gallery with permission check
  Future<void> pickImage() async {
    // Check if the storage permission is granted
    PermissionStatus status = await Permission.storage.status;

    if (status.isGranted) {
      // Permission is granted, proceed to pick an image
      print("Storage permission granted");

      // Open the image picker
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        uploadImageToAWS(_image!); // Call your upload function here
      }
    } else if (status.isDenied) {
      // Permission is denied, request permission
      print("Storage permission denied, requesting permission...");
      await Permission.storage.request();

      // After requesting, check the permission status again
      if (await Permission.storage.isGranted) {
        print("Storage permission granted after request");

        // Proceed with picking an image if permission is granted
        final XFile? pickedFile =
            await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
          uploadImageToAWS(_image!); // Call your upload function here
        }
      } else {
        print("Storage permission still denied");

        // Optionally, prompt user to go to app settings to enable the permission manually
        openAppSettings();
      }
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, show a message or redirect user to settings
      print(
          "Storage permission permanently denied. Please enable it in settings.");

      // Optionally, open the app settings for the user to manually enable the permission
      openAppSettings();
    }
  }

  Future<void> uploadImageToAWS(File image) async {
    _isUploading = true;
    setState(() {});
    try {
      String fileName = generateFileName(id);
      print("FileName");
      print(fileName);

      // Create a multipart request
      var request =
          http.MultipartRequest('POST', Uri.parse('${baseUrl}upload'));

      // Add headers
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final signature = hmacSha256(encryptionKey, timestamp);
      request.headers.addAll({
        "Accept": "application/json",
        "Connection": "application/json",
        "Authorization": 'Bearer',
        'x-timestamp': timestamp,
        'x-signature': signature,
      });
      print("Image size: ${(await image.length()) / (1024 * 1024)} MB");
      // Add the image file
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        filename: fileName,
        contentType: MediaType('multipart', 'form-data'),
      ));

      // Send the request
      var response = await request.send();
      print('response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Parse the response
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        print('object: $jsonResponse');
        String imageKey = jsonResponse['Key'].toString();
        // Construct the image URL
        String imageUrl = jsonResponse['location'].toString();
        // await cacheImage(imageKey, imageUrl);
        _imageUrl = imageUrl;
        setState(() {});
        // Handle the successful response
        print("Image uploaded successfully. Image URL: $imageUrl");
        print(_imageUrl);
        print("Image key: $imageKey");
      } else {
        // Handle error response
        print("Failed to upload image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
    } finally {
      _isUploading = false;
      setState(() {});
    }
  }

  // Cache the image locally (stores URL and file)
  Future<void> cacheImage(String imageKey, String imageUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheDirectory = await getTemporaryDirectory();
      final imageCachePath = '${cacheDirectory.path}/$imageKey';
      print(imageCachePath);

      // Save the image URL and timestamp in shared preferences
      prefs.setString(imageKey, imageUrl);
      prefs.setInt(imageKey, DateTime.now().millisecondsSinceEpoch);

      // Download and store the image locally
      final response = await getAPICall(apiUrl: imageUrl);
      if (response.statusCode == 200) {
        File(imageCachePath)..writeAsBytes(response.bodyBytes);
      }
    } catch (e) {
      print("Error caching image: $e");
    }
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
              buildTranslate("buyCommodity")!,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'poppins-semibold',
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: ElevatedButton(
            onPressed: _isUploading
                ? null
                : () {
                    _buyCommodityApiCall();
                  },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
              textStyle: const TextStyle(fontSize: 18),
              backgroundColor: const Color(0xFF3FC041),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              buildTranslate("buyCommodity")!,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'poppins-medium',
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                buildTranslate("selectCommodity")!,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF666666),
                  fontFamily: 'poppins-semibold',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: _cropData == null || _cropData!.data == null
                  ? const Center(child: Text('No data available'))
                  : DropdownButtonFormField2<String>(
                      dropdownStyleData:
                          const DropdownStyleData(maxHeight: 200),
                      hint: const Text('Select Commodity'),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
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
                          child: Text(
                            crop,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontFamily: 'poppins-regular',
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        _selectedCrop = newValue;
                        setState(() {});
                      },
                    ),
            ),
            const SizedBox(
              height: 20,
            ),

            // variety
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                buildTranslate("Variety")!,
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
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: varietyController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: buildTranslate('Enter name of variety'),
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Quantity
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                buildTranslate("quantity")!,
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
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: quantityController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        hintText: buildTranslate('addYourQuantity'),
                        hintStyle: const TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none
                              // borderSide: const BorderSide(
                              //   color: Colors.grey,
                              //   width: 1,
                              // ),
                              ),
                          // Add more decoration..
                        ),
                        hint: const Text(
                          'Ton',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        items: quantityItems
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
                          //Do something when selected item is changed.
                        },
                        onSaved: (value) {
                          selectedQuantityItemValue = value.toString();
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
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Moisture
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                buildTranslate("moisture")!,
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
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: moistureController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: '__%',
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Any Local Grade Specification
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                buildTranslate("anyLocalGradeSpecification")!,
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
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: localGradeController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: buildTranslate("anyLocalGradeSpecification")!,
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // size
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                buildTranslate("size")!,
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
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: sizeController,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none
                              // borderSide: const BorderSide(
                              //   color: Colors.grey,
                              //   width: 1,
                              // ),
                              ),
                          // Add more decoration..
                        ),
                        hint: const Text(
                          'MM',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        items: sizeItems
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
                          //Do something when selected item is changed.
                        },
                        onSaved: (value) {
                          selectedSizeItemValue = value.toString();
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
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Count
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                buildTranslate("count")!,
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
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: countController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: buildTranslate('enterCount')!,
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // purchase
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                buildTranslate("purchasePriceInRs")!,
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
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: purchasePriceController,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none
                              // borderSide: const BorderSide(
                              //   color: Colors.grey,
                              //   width: 1,
                              // ),
                              ),
                          // Add more decoration..
                        ),
                        hint: const Text(
                          'Kg',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        items: purchaseItems
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
                          //Do something when selected item is changed.
                        },
                        onSaved: (value) {
                          selectedPurchaseItemValue = value.toString();
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
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // date of delivery
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                buildTranslate("dateOfExpectedDelivery")!,
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
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: dateOfDeliveryController,
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: 'DD/MM/YYYY',
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    }, // Open date picker on icon press
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // origin of commodity
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                buildTranslate("originOfCommodity")!,
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
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: originCommodityController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                buildTranslate("deliveryLocation")!,
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
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: deliveryLocationController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(17),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: const Color(0xFF3692FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Text(
                  buildTranslate('uploadImage')!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'poppins-medium',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Show image preview before upload
            if (_image != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                buildTranslate("addComments")!,
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
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: commentsController,
                maxLines: null,
                minLines: 5,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // Show the date picker dialog
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default date is the current date
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime(2101), // Latest selectable date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      setState(() {
        // Format the selected date and display it in the TextFormField
        dateOfDeliveryController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  _buyCommodityApiCall() async {
    if (quantityController.text.trim().isNotEmpty &&
        _selectedCrop.toString().isNotEmpty) {
      contactNumber = (await AppGlobal.getStringPreference('contactNumber'))!;
      var body = json.encode({
        "uid": contactNumber,
        "operation": "Buy",
        "commodity": _selectedCrop,
        "variety": varietyController.text.toString().isNotEmpty
            ? varietyController.text.toString()
            : "",
        "quantity": quantityController.text.toString().isNotEmpty
            ? quantityController.text.toString()
            : 0,
        "moisture": moistureController.text.toString().isNotEmpty
            ? moistureController.text.toString()
            : 0,
        "localGradeSpecification": localGradeController.text.toString(),
        "size": sizeController.text.toString(),
        "count": countController.text.toString().isNotEmpty
            ? countController.text.toString()
            : 0,
        "price": purchasePriceController.text.toString().isNotEmpty
            ? purchasePriceController.text.toString()
            : 0,
        "date": dateOfDeliveryController.text.isNotEmpty
            ? "${AppGlobal.convertToIsoFormat(dateOfDeliveryController.text)}Z"
            : "",
        "origin": originCommodityController.text.toString().isNotEmpty
            ? originCommodityController.text
            : "",
        "location": deliveryLocationController.text.toString().isNotEmpty
            ? deliveryLocationController.text.toString()
            : "",
        "photoVideoLink": _imageUrl,
        "comments": commentsController.text.toString().isNotEmpty
            ? commentsController.text.toString()
            : "",
        "verified": true
      });
      var buyCommodity = EnquiryDashboardController.buySellCommodityData(
        body,
        context: context,
      );
      if (buyCommodity.toString().isNotEmpty) {
        Future.delayed(const Duration(seconds: 1), () {
          print('Commodity created successfully');
          showAlertDialog(context);
        });
      } else {
        print("Api error");
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.close,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          Center(
              child: Image.asset(
            'assets/images/check_green.png',
            width: 100,
            height: 100,
          )),
          Text(
            buildTranslate("SuccessfullyUpdate")!,
            softWrap: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: "poppins-semibold",
                fontSize: 15,
                color: Colors.grey),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            buildTranslate("thankYou")!,
            softWrap: true,
            style: const TextStyle(
                fontFamily: "poppins-semibold",
                fontSize: 20,
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
  }
}
