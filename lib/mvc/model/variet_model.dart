import 'dart:convert';
import 'package:krishiyan/utils/Constants.dart';
import 'package:krishiyan/mvc/model/VarietyData.dart';
import 'package:krishiyan/helper/api_base_helper.dart';

Future<List<VarietyData>> fetchVarieties(String selectedCrop) async {
  final response = await getAPICall(apiUrl: '${baseUrl}varity/$selectedCrop');

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['success']) {
      List<dynamic> varietiesJson = data['data'];
      return varietiesJson
          .map((variety) => VarietyData.fromJson(variety))
          .toList();
    } else {
      throw Exception(data['message']);
    }
  } else {
    throw Exception('Failed to load varieties');
  }
}
