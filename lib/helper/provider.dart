import 'package:flutter/material.dart';
import 'package:krishiyan/screen/dashboard/frm/frm_provider.dart';
import 'package:krishiyan/screen/dashboard/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

HomeProvider? homeProvider;
FRMProvider? frmProvider;

List<SingleChildWidget> providerList = [
  ChangeNotifierProvider<HomeProvider>(create: (context) => HomeProvider()),
  ChangeNotifierProvider<FRMProvider>(create: (context) => FRMProvider()),
];

Future<void> intializeAllProviders(BuildContext context) async {
  homeProvider = Provider.of<HomeProvider>(context, listen: false);
  frmProvider = Provider.of<FRMProvider>(context, listen: false);
  print('homeProvider :::::: ${homeProvider}');
}
