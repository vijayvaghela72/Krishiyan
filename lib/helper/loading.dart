import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

showLoading({String? titleValue, bool statucIcon = false}) {
  EasyLoading.show(
    status: titleValue ?? 'Loading...',
    indicator: statucIcon
        ? Icon(
            Icons.download_outlined,
            color: Colors.white,
            size: 70,
          )
        : SpinKitWaveSpinner(
            color: Colors.green,
            size: 100,
          ),
    maskType: EasyLoadingMaskType.black,
  );
}

stopLoading() {
  EasyLoading.dismiss(animation: true);
}
