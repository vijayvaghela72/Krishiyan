import 'dart:convert';

import '../../utils/AppGlobal.dart';
import '../../utils/Constants.dart';
import '../model/APIResponse.dart';
import '../model/CropLibraryData.dart';
import 'package:http/http.dart' as http;

class CropController{

  static Future<List<CropLibraryData>> fetchCrop() async {
    final response = await http
        .get(Uri.parse(CROP_LIST));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("crop response : ${jsonDecode(response.body)}");

      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) =>  CropLibraryData.fromJson(job)).toList();

      // return CropLibraryData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

}