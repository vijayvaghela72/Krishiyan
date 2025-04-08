import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

Map<String, String> commonHeader = {
  "Accept": "application/json",
  "Content-Type": "application/json",
  "Connection": "application/json",
  "test": 'false',
  'ArdentSport': 'QXJkZW50U3BvcnQ',
  "Authorization": 'Bearer',
};
bool isSuccessStatus(int statusCode) => statusCode >= 200 && statusCode <= 204;

Future<Response> getAPICall({
  required String apiUrl,
  String headerValue = '',
  bool isSendMail = true,
  int retryCount = 1,
}) async {
  print('====================================================================');
  print('URL : (GET:) $apiUrl');

  Map<String, String>? temp;
  if (headerValue != '') {
    temp = {
      "authToken": headerValue,
    };
  }

  Response? response;

  // Retry logic
  for (int attempt = 0; attempt < retryCount + 1; attempt++) {
    try {
      // API call with timeout
      response = await get(
        Uri.parse(apiUrl),
        headers: headerValue.isNotEmpty ? temp : commonHeader,
      ).timeout(const Duration(seconds: 8));

      print('Status Code : ${response.statusCode}');
      print('Response : ${response.body.toString()}');

      if (isSuccessStatus(response.statusCode)) {
        return response; // Return successful response
      } else {
        print('Error: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      print('Request timed out');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }
  return response ?? Response('Check your internet connectivity', 500);
}

Future<Response> deleteAPICall({
  required String apiUrl,
  required Object? parameter,
  bool isSendMail = true,
  int retryCount = 1,
}) async {
  print('====================================================================');
  print('URL : (DELETE) : $apiUrl');

  Response? response;

  for (int attempt = 0; attempt < retryCount + 1; attempt++) {
    try {
      response = await delete(
        Uri.parse(apiUrl),
        body: parameter,
        headers: commonHeader,
      ).timeout(const Duration(seconds: 8));

      print('Status Code : ${response.statusCode}');
      print('Response : ${response.body.toString()}');

      // Return the response if it's successful
      if (isSuccessStatus(response.statusCode)) {
        return response;
      } else {
        print('Error: ${response.statusCode}');
        if (attempt == retryCount) {}
      }
    } on TimeoutException catch (_) {
      print('Request timed out');
      if (attempt == retryCount) {}
    } catch (e) {
      print('An unexpected error occurred: $e');
      if (attempt == retryCount) {}
    }
  }
  return response ?? Response('Check your internet connectivity', 500);
}

Future<Response> postAPICall({
  required String apiUrl,
  required Object? parameter,
  String headerValue = '',
  bool isSendMail = true,
  int retryCount = 1,
}) async {
  print('====================================================================');
  print('URL : (POST) : $apiUrl');
  print('Parameter : $parameter');
  Map<String, String>? temp;
  if (headerValue != '') {
    temp = {
      "authToken": headerValue,
    };
  }

  Response? response;
  for (int attempt = 0; attempt < retryCount + 1; attempt++) {
    try {
      response = await post(
        Uri.parse(apiUrl),
        headers: headerValue.isNotEmpty ? temp : commonHeader,
        body: parameter,
        encoding: Encoding.getByName("utf-8"),
      ).timeout(const Duration(seconds: 8));

      print('Status Code : ${response.statusCode}');
      print('Response : ${response.body.toString()}');

      // If the response is successful, return it
      if (isSuccessStatus(response.statusCode)) {
        return response;
      } else {
        print('Error: ${response.statusCode}');
        if (attempt == retryCount) {}
      }
    } on TimeoutException catch (_) {
      print('Request timed out');
      if (attempt == retryCount) {}
    } catch (e) {
      print('An unexpected error occurred: $e');
      if (attempt == retryCount) {}
    }
  }
  return response ?? Response('Check your internet connectivity', 500);
}

Future<Response> patchAPICall({
  required String apiUrl,
  required Object? parameter,
  bool isSendMail = true,
  int retryCount = 1,
}) async {
  print('====================================================================');
  print('URL : (PATCH) : $apiUrl');
  print('Parameter : $parameter');
  Response? response;
  for (int attempt = 0; attempt < retryCount + 1; attempt++) {
    try {
      response = await patch(
        Uri.parse(apiUrl),
        headers: commonHeader,
        body: parameter,
        encoding: Encoding.getByName("utf-8"),
      ).timeout(const Duration(seconds: 8));

      print('Status Code : ${response.statusCode}');
      print('Response : ${response.body.toString()}');

      // Return if the response is successful
      if (isSuccessStatus(response.statusCode)) {
        return response;
      } else {
        print('Error: ${response.statusCode}');
        if (attempt == retryCount) {}
      }
    } on TimeoutException catch (_) {
      print('Request timed out');
      if (attempt == retryCount) {}
    } catch (e) {
      print('An unexpected error occurred: $e');
      if (attempt == retryCount) {}
    }
  }

  return response ?? Response('Check your internet connectivity', 500);
}

Future<Response> putAPICall({
  required String apiUrl,
  required Object? parameter,
  bool isSendMail = true,
  int retryCount = 1,
}) async {
  print('====================================================================');
  print('URL : (PUT) : $apiUrl');
  print('Parameter : $parameter');

  Response? response;

  for (int attempt = 0; attempt < retryCount + 1; attempt++) {
    try {
      response = await put(
        Uri.parse(apiUrl),
        headers: commonHeader,
        body: parameter,
        encoding: Encoding.getByName("utf-8"),
      ).timeout(const Duration(seconds: 8));

      print('Status Code : ${response.statusCode}');
      print('Response : ${response.body.toString()}');

      // If the response is successful, return it
      if (isSuccessStatus(response.statusCode)) {
        return response;
      } else {
        print('Error: ${response.statusCode}');
        if (attempt == retryCount) {}
      }
    } on TimeoutException catch (_) {
      print('Request timed out');
      if (attempt == retryCount) {}
    } catch (e) {
      print('An unexpected error occurred: $e');
      if (attempt == retryCount) {}
    }
  }
  return response ?? Response('Check your internet connectivity', 500);
}
