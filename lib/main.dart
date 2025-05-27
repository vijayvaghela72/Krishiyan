import 'dart:io';
import 'package:krishiyan/helper/constant.dart';

import 'helper/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'localization/AppLocalizations.dart';
import 'localization/NavigationService.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/screen/welcome/welcome.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:krishiyan/screen/dashboard/dashborad.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  // Request all necessary permissions as soon as the app starts
  await MyApp._requestPermissions();

  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: providerList,
      child: MaterialApp(
        builder: EasyLoading.init(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1),
              ),
              child: child!,
            );
          },
        ),
        navigatorKey: NavigationService.navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          MyLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale(localLang),
        supportedLocales: const [
          Locale('en'), // English
          Locale('hi'), // Hindi
        ],
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<bool>(
          future: _checkLoginStatus(), // Call the method to check login status
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while waiting for the login status check
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Handle errors if any
              return const Center(child: Text("Error checking login status."));
            } else {
              // Navigate based on the login status
              if (snapshot.data == true) {
                return SafeArea(
                  child: HomePage(
                    selectedIndex: 0,
                    typeOfOrganization: "",
                  ),
                ); // User is logged in
              } else {
                return const WelcomePage(); // User is not logged in
              }
            }
          },
        ),
        routes: const <String, WidgetBuilder>{},
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    // Check the login status from shared preferences
    return await SharedPref.readPreferenceValue(isLogin, PrefEnum.BOOL) ??
        false;
  }

  // Request permissions when the app starts
  static Future<void> _requestPermissions() async {
    // Request individual permissions for storage and phone call
    PermissionStatus storagePermissionStatus =
        await Permission.storage.request();
    PermissionStatus phonePermissionStatus = await Permission.phone.request();

    // You can handle the status accordingly, for example:
    if (storagePermissionStatus.isGranted) {
      print("Storage permission granted");
    } else {
      print("Storage permission denied");
    }

    if (phonePermissionStatus.isGranted) {
      print("Phone permission granted");
    } else {
      print("Phone permission denied");
    }
  }
}
