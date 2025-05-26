import 'dart:convert';
import '../../widgets/constant.dart';
import '../model/CropLibraryData.dart';
import 'package:krishiyan/helper/api_base_helper.dart';

class CropController {
  static Future<List<CropLibraryData>> fetchCrop(String cropName) async {
    final response = await getAPICall(apiUrl: '${baseUrl}crops/$cropName');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("crop response : ${jsonDecode(response.body)}");

      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => CropLibraryData.fromJson(job)).toList();

      // return CropLibraryData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
