import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:krishiyan/mvc/model/VarietyData.dart';


Future<List<VarietyData>> fetchVarieties(String selectedCrop) async {
  final response = await http.get(Uri.parse('https://krishiyanback.vercel.app/api/varity/$selectedCrop'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['success']) {
      List<dynamic> varietiesJson = data['data'];
      return varietiesJson.map((variety) => VarietyData.fromJson(variety)).toList();
    } else {
      throw Exception(data['message']);
    }
  } else {
    throw Exception('Failed to load varieties');
  }
}
