import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// variable for network checking
bool isNetworkAvailable = true;
bool isInternalServerError = false;

Future<bool> checkIsNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }
  return true;
}

Widget noInternet(
  BuildContext context,
  setStateNoInternet,
) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.8,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        noInternetImage(context),
        noInternetText(context),
        noInternetDescription(context),
        tryAgainButton(context, setStateNoInternet),
      ],
    ),
  );
}

noInternetImage(BuildContext context) {
  return Image.asset(
    'assets/no_internet.png',
    fit: BoxFit.contain,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.3,
  );
}

noInternetText(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 32.0),
    child: Text(
      'No Internet',
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
    ),
  );
}

noInternetDescription(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
    child: Text(
      'Connection Error: No Available Networks Found',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.grey[400],
            fontWeight: FontWeight.normal,
          ),
    ),
  );
}

tryAgainButton(
  BuildContext context,
  final VoidCallback? onBtnSelected,
) {
  return CupertinoButton(
    child: Container(
      width: 100,
      height: 45,
      alignment: FractionalOffset.center,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
      ),
      child: Text(
        'Try Again',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
      ),
    ),
    onPressed: () {
      onBtnSelected!();
    },
  );
}
