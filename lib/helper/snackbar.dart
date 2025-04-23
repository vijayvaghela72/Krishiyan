// import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

setSnackbar(String msg) {
  if (kIsWeb) {
    try {
      EasyLoading.showSuccess(msg);
    } catch (e) {
      print('Error in snackbar: $e ');
    }
  } else {
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 14,
    );
  }
}
