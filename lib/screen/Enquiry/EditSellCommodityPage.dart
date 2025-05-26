import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../utils/AppGlobal.dart';
import '../../utils/Constants.dart';
import 'package:flutter/material.dart';
import '../../helper/AlertHelper.dart';
import 'package:flutter/services.dart';
import '../../mvc/model/CropLibraryData.dart';
import 'package:image_picker/image_picker.dart';
import '../../mvc/model/SelectCropNamesData.dart';
import 'package:path_provider/path_provider.dart';
import '../../localization/AppLocalizations.dart';
import '../../mvc/controller/cropController.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishiyan/mvc/model/GetEnquiryByFilterData.dart';

// ignore: must_be_immutable
class EditSellCommodityPage extends StatefulWidget {
  EnquiryByFilterData enquiryData;

  EditSellCommodityPage({super.key, required this.enquiryData});

  @override
  State<EditSellCommodityPage> createState() => _EditSellCommodityPageState();
}

class _EditSellCommodityPageState extends State<EditSellCommodityPage> {
  TextEditingController varietyController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController moistureController = TextEditingController();
  TextEditingController localGradeController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController supplyPriceController = TextEditingController();
  TextEditingController dateOfShipmentController = TextEditingController();
  TextEditingController originCommodityController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  TextEditingController deliveryLocationController = TextEditingController();
  bool _isUploading = false;

  final List<String> quantityItems = ['Ton', 'Kg', 'Qtl'];
  String? selectedQuantityItemValue;

  final List<String> sizeItems = ['MM', 'CM'];
  String? selectedSizeItemValue;

  final List<String> purchaseItems = ['Kg', 'Qtl', 'Ton'];
  String? selectedPurchaseItemValue;

  late Future<List<CropLibraryData>?> futureCropData;
  String? _selectedCrop;
  SelectCropNamesData? _cropData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCropData();
    getSellCommoditiyValue();
  }

  void getSellCommoditiyValue() {
    _selectedCrop = widget.enquiryData.commodity ?? "";
    varietyController.text = widget.enquiryData.variety ?? "";
    quantityController.text = widget.enquiryData.quantity.toString();
    moistureController.text = widget.enquiryData.moisture.toString();
    localGradeController.text =
        widget.enquiryData.localGradeSpecification.toString();
    sizeController.text = widget.enquiryData.size.toString();
    countController.text = widget.enquiryData.count.toString();
    supplyPriceController.text = widget.enquiryData.price.toString();

    dateOfShipmentController.text =
        AppGlobal.convertToCustomDateFormat(widget.enquiryData.date.toString());
    originCommodityController.text = widget.enquiryData.origin.toString();
    deliveryLocationController.text = widget.enquiryData.location.toString();
    commentsController.text = widget.enquiryData.comments.toString();
  }

  Future<void> _fetchCropData() async {
    try {
      // Replace with your actual API endpoint
      var response = await getAPICall(apiUrl: CROPS_NAMES);

      if (response.statusCode == 200) {
        futureCropData = CropController.fetchCrop(_cropData!.data!.first);
        _cropData = SelectCropNamesData.fromJson(jsonDecode(response.body));
        setState(() {});
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (e) {
      print('My SellCommodity : Error fetching crop data: $e');
    }
  }

  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _imageUrl;
  Dio _dio = Dio();
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

  // Upload the image to AWS using Dio
  Future<void> uploadImageToAWS(File image) async {
    setState(() {
      _isUploading = true; // Start uploading
    });
    try {
      String fileName = generateFileName(id); // Example id (can be dynamic)
      print("FileName");
      print(fileName);

      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path, filename: fileName),
      });
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final signature = hmacSha256(encryptionKey, timestamp);

      // Send the POST request to the API
      Response response = await _dio.post('${baseUrl}upload',
          data: formData,
          options: Options(headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Connection": "application/json",
            "Authorization": 'Bearer',
            'x-timestamp': timestamp,
            'x-signature': signature,
          }));

      if (response.statusCode == 200) {
        var jsonResponse = response.data;
        String imageKey = jsonResponse['Key'];
        // Construct the image URL
        String imageUrl = '${baseUrlEnd}images/$imageKey';

        // Store the image URL in cache and local storage
        await cacheImage(imageKey, imageUrl);

        setState(() {
          _imageUrl = imageUrl;
        });

        // Handle the successful response
        print("Image uploaded successfully. Image URL: $imageUrl");
        print(_imageUrl);
        print("Image key: $imageKey");
      } else {
        // Handle error response
        print("Failed to upload image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exceptions
      print("Error uploading image: $e");
    } finally {
      // Regardless of success or failure, re-enable the button
      setState(() {
        _isUploading = false; // End the upload process
      });
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
        File(imageCachePath)..writeAsBytesSync(response.bodyBytes);
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
              buildTranslate("sellCommodity")!,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'poppins-semibold',
                  fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: ElevatedButton(
            onPressed: _isUploading
                ? null
                : () {
                    _sellCommodityApiCall();
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
            child: Text(
              buildTranslate("sellCommodity")!,
              style:
                  const TextStyle(fontSize: 15, fontFamily: 'poppins-medium'),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),

            // Select Commodity
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("selectCommodity")!,
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
            const SizedBox(
              height: 20,
            ),

            // variety
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: varietyController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  hintText: buildTranslate('enterNameOfVariety')!,
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
                            vertical: 10.0, horizontal: 10.0),
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
                              //   width: 1.0,
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

            // Moisture%
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: moistureController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: localGradeController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: sizeController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
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
                              //   width: 1.0,
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: countController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
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

            // supply
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("supplyPriceInRs")!,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: supplyPriceController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
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
                              //   width: 1.0,
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("dateOfExpectedShipmentLoading")!,
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
                controller: dateOfShipmentController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  hintText: 'DD/MM/YYYY',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    }, // Open date picker on icon press
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                ),
                readOnly: true,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // origin of commodity
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: originCommodityController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
                    borderRadius: BorderRadius.circular(22), // <-- Radius
                  ),
                ),
                child: Text(
                  buildTranslate('uploadImage')!,
                  style: const TextStyle(
                      fontSize: 15, fontFamily: 'poppins-medium'),
                ),
              ),
            ),
            if (_image != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else if (widget.enquiryData.photoVideoLink != null)
              Center(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(widget.enquiryData.photoVideoLink!,
                        height: 200, width: 200, fit: BoxFit.cover)),
              )
            else
              SizedBox(
                height: 10,
              ),
            const SizedBox(
              height: 20,
            ),

            // Add comments
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: commentsController,
                maxLines: null,
                minLines: 5,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
      initialDate: DateTime.now(),
      // Default date is the current date
      firstDate: DateTime(2000),
      // Earliest selectable date
      lastDate: DateTime.now(),
      // Latest selectable date
      helpText: 'Select a date', // Optional help text
    );
    if (pickedDate != null) {
      setState(() {
        // Format the selected date and display it in the TextFormField
        dateOfShipmentController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  _sellCommodityApiCall() async {
    if (varietyController.text.trim().isNotEmpty &&
        quantityController.text.trim().isNotEmpty &&
        moistureController.text.trim().isNotEmpty &&
        localGradeController.text.trim().isNotEmpty &&
        sizeController.text.trim().isNotEmpty &&
        countController.text.trim().isNotEmpty &&
        supplyPriceController.text.trim().isNotEmpty &&
        dateOfShipmentController.text.trim().isNotEmpty &&
        originCommodityController.text.trim().isNotEmpty &&
        commentsController.text.trim().isNotEmpty) {
      String contactNumber =
          (await AppGlobal.getStringPreference('contactNumber'))!;

      var data = json.encode({
        "operation": widget.enquiryData.operation,
        "commodity": _selectedCrop,
        "variety": varietyController.text.toString(),
        "quantity": quantityController.text.toString(),
        "moisture": moistureController.text.toString(),
        "localGradeSpecification": localGradeController.text.toString(),
        "size": sizeController.text.toString(),
        "count": countController.text.toString(),
        "price": supplyPriceController.text.toString(),
        "date": dateOfShipmentController.text.toString(),
        "origin": originCommodityController.text.toString(),
        "location": "",
        "photoVideoLink": "",
        "comments": commentsController.text.toString(),
        "verified": true
      });

      var url =
          "${baseUrl}commodities/$contactNumber/${widget.enquiryData.sId}";
      var response = await putAPICall(apiUrl: url, parameter: data);

      if (response.statusCode == 200) {
        print("Enquiry sell details updated : " + response.body);
        showAlertDialog(context);
      } else {
        print("Error response received:");
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        AlertHelper.showToast(response.reasonPhrase.toString(), context);
        print(response.reasonPhrase);
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
          Text(
            buildTranslate("SuccessfullyUpdate")!,
            softWrap: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: "poppins-semibold",
                fontSize: 15.0,
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
}
