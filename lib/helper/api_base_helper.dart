import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart';

const encryptionKey =
    "c10a2499a46c1921688c6bf5f19b746f2eb4398b1d3c4d1c1f2e4a6c8b6a4f8c";

String hmacSha256(String key, String message) {
  final keyBytes = utf8.encode(key);
  final messageBytes = utf8.encode(message);

  final hmac = Hmac(sha256, keyBytes);
  final digest = hmac.convert(messageBytes);
  return digest.toString();
}

Map<String, String> commonHeader = {
  "Accept": "application/json",
  "Content-Type": "application/json",
  "Connection": "application/json",
  "test": 'false',
  "Authorization": 'Bearer',
};
bool isSuccessStatus(int statusCode) => statusCode >= 200 && statusCode <= 204;

Future<void> update() async {
  final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  final signature = hmacSha256(encryptionKey, timestamp);
  commonHeader = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Connection": "application/json",
    "Authorization": 'Bearer',
    'x-timestamp': timestamp,
    'x-signature': signature,
  };
  print('commonHeader : $commonHeader');
  return;
}

Future<Response> getAPICall({
  required String apiUrl,
  String headerValue = '',
  bool isSendMail = true,
  int retryCount = 1,
}) async {
  print('====================================================================');
  print('URL : (GET:) $apiUrl');
  await update();

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

  await update();
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
  await update();
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
  await update();
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
  await update();
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
