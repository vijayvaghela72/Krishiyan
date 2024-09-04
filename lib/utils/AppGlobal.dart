import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mvc/model/LoginData.dart';
import 'Constants.dart';
import 'package:intl/intl.dart';

class AppGlobal {
  static printLog(dynamic val) {
    if (DEVELOPER_MODE) {
      if (kDebugMode) log(val.toString());
    }
  }

  // Function to extract the file ID from a Google Drive URL
  static String? extractCodeFromDriveLink(String url) {
    final RegExp pattern = RegExp(r'/d/([a-zA-Z0-9_-]+)/');
    final RegExpMatch? match = pattern.firstMatch(url);
    return match != null ? match.group(1) : null;
  }

  static Future<String?> getStringPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    return value;
  }

  static String convertToIsoFormat(String dateString) {
    // Define the input format
    DateFormat inputFormat = DateFormat('dd-MM-yyyy');

    // Parse the date string to a DateTime object
    DateTime dateTime = inputFormat.parse(dateString);

    // Format the DateTime object to the ISO format
    String isoFormattedDate =
    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(dateTime);

    // Adjust the format to match the specific format with '000Z' at the end
    // Replace the '+0000' with ':000Z'
    isoFormattedDate =
        isoFormattedDate.replaceFirst(RegExp(r'\+0000'), '.000Z');

    return isoFormattedDate;
  }

  static String convertToCustomDateFormat(String isoDate) {
    // Remove the trailing ':000Z' part to make it a standard ISO 8601 format
    String correctedIsoDate = isoDate.replaceFirst(RegExp(r':\d{3}Z$'), 'Z');

    // Parse the ISO date string
    DateTime parsedDate = DateTime.parse(correctedIsoDate);

    // Format the date to 'dd-MM-yyyy'
    String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);

    return formattedDate;
  }
}
