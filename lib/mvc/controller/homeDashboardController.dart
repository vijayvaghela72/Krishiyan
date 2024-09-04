import 'dart:convert';

import '../../utils/Constants.dart';
import '../model/DailyNewsDetails.dart';
import 'package:http/http.dart' as http;

class HomeDashboardController{

  static Future<List<NewsData>> getNewsDetails() async {
    final response = await http.get(Uri.parse(NEWS_LIST));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      print("News response : ${data}");
      return data.map((item) => NewsData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

}