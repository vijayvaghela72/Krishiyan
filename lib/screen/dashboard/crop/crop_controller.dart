import 'dart:convert';
import 'package:krishiyan/helper/constant.dart';
import 'package:krishiyan/helper/api_base_helper.dart';
import 'package:krishiyan/screen/dashboard/crop/crop_model.dart';

class CropController {
  static Future<CropLibraryData> fetchCrop(String cropName) async {
    final response = await getAPICall(apiUrl: '${baseUrl}crops/$cropName');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("crop response : ${jsonDecode(response.body)}");

      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
        return CropLibraryData.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load crop data');
    }
  }
}
