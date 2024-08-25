import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:krishiyan/screen/MyWelcomePage.dart';
import 'package:krishiyan/utils/Constants.dart';

import 'localization/AppLocalizations.dart';
import 'localization/NavigationService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey, // set property
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
      home: const MyWelcomePage(),
      routes: const <String, WidgetBuilder>{},
    );
    // return ChangeNotifierProvider(
    //     create: (BuildContext context) => appLanguage,
    //     child: Consumer<AppLanguageProvider>(builder: (context, model, child) {
    //       return MaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         title: 'Flutter Demo',
    //         theme: ThemeData(
    //           colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
    //           useMaterial3: true,
    //         ),
    //         home: const MyWelcomePage(),
    //         locale: model.appLocal,
    //         supportedLocales: const [
    //           Locale('en', 'US'),
    //         ],
    //         localizationsDelegates: const [
    //           AppLocalizations.delegate,
    //         ],
    //       );
    //     })
    // );
  }
}