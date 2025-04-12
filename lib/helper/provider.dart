import 'package:flutter/material.dart';
import 'package:krishiyan/screen/home_screen/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

HomeProvider? homeProvider;

List<SingleChildWidget> providerList = [
  ChangeNotifierProvider<HomeProvider>(create: (context) => HomeProvider()),
];

Future<void> intializeAllProviders(BuildContext context) async {
  homeProvider = Provider.of<HomeProvider>(context, listen: false);
  print('homeProvider :::::: ${homeProvider}');
}
