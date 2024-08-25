import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'NavigationService.dart';

class MyLocalizations {
  MyLocalizations(this.locale);

  final Locale locale;

  static MyLocalizations? of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  static late Map<String, String> _localizedStrings;

  static Future<bool> load(Locale locale) async {
    String jsonString = await rootBundle.loadString('lib/lang/$locale.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String? getString(String? key) {
    if (!_localizedStrings.containsKey(key)) return "";
    return _localizedStrings[key!];
  }
}

String? buildTranslate(String? key) => MyLocalizations.of(NavigationService.navigatorKey.
currentContext!)!.getString(key);

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MyLocalizations> load(Locale locale) async {
    MyLocalizations localizations = MyLocalizations(locale);
    await MyLocalizations.load(locale);
    return localizations;
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}
