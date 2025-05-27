import 'package:flutter/services.dart';
import 'package:krishiyan/helper/constant.dart';
import 'package:provider/provider.dart';
import '../../language/select_language.dart';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/helper/provider.dart';
import '../../../localization/app_localizations.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:krishiyan/screen/dashboard/home/widget/news.dart';
import 'package:krishiyan/screen/dashboard/home/home_provider.dart';
import 'package:krishiyan/screen/dashboard/home/widget/mandi_price.dart';
import 'package:krishiyan/screen/dashboard/home/widget/market_insight.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  bool aapbarVisibility;

  HomeScreen({super.key, required this.aapbarVisibility});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  update() {
    if (mounted) {
      setState(() {});
    }
  }

  int selectedTopData = 0;

  @override
  void initState() {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    super.initState();
    getData();
  }

  getData() async {
    showLoading();
    await homeProvider!.fetchStateData(update);
    stopLoading();
  }

  @override
  Widget build(BuildContext context) {
    print('homeProvider : ${homeProvider} ');
    // Check if stateItems or stateItems.data is null
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      appBar: widget.aapbarVisibility
          ? AppBar(
              automaticallyImplyLeading: false,
              title: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectLanguagePage()))
                      .then((value) {
                    setState(() {
                      // refresh state
                      MyLocalizations.load(Locale(localLang, ''));
                      print("HomeScreen Lang : $localLang");
                    });
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/loginLogo.png',
                      width: 150,
                      height: 60,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0, top: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/language.png',
                            width: 35,
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Container(
                height: 80,
                child: ListView.builder(
                  itemCount: homeProvider!.topData.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _onSelectedTopDataTapped(index);
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Chip(
                            backgroundColor: selectedTopData == index
                                ? Colors.green
                                : Colors.white,
                            padding: const EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: selectedTopData == index
                                        ? Colors.green
                                        : Colors.black),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                )),
                            label: Text(homeProvider!.topData[index].toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "poppins-regular",
                                  color: selectedTopData == index
                                      ? Colors.white
                                      : Colors.black,
                                )),
                          )),
                    );
                  },
                ),
              ),
            ),
            selectedTopData == 0
                ? NewsScreen()
                : selectedTopData == 1
                    ? MandiPriceScreen(
                        update: update,
                      )
                    : selectedTopData == 2
                        ? MarketInsightScreen(
                            update: update,
                          )
                        : Container(),
            Container(),
          ],
        ),
      ),
    );
  }

  void _onSelectedTopDataTapped(int index) {
    setState(() {
      selectedTopData = index;
    });
    print("Selected Top Page : $selectedTopData");
  }
}
