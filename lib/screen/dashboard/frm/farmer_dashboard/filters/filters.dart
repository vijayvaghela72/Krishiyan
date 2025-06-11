import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/helper/loading.dart';
import 'package:krishiyan/helper/provider.dart';
import 'package:krishiyan/localization/app_localizations.dart';
import 'package:krishiyan/screen/dashboard/frm/frm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final List<String> sideMenu = ["Villages", "Types"];

  final List<String> typeData = [
    "Organic",
    "InOrganic",
  ];

  int? selectedVillageIndex;
  int? selectedTypeIndex;

  String villageName = "", typeName = "";

  int selectedMenuData = 0;
  setStateNow() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSelectedVillageIndex();
    _loadSelectedTypeIndex();
    frmProvider!.getVillageData(setStateNow, true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: 800,
              decoration: const BoxDecoration(color: Color(0xFFC7BDBD)),
              child: ListView.builder(
                itemCount: sideMenu.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        selectedMenuData = index;
                        setState(() {});
                      },
                      child: Container(
                        color: selectedMenuData == index
                            ? Colors.white
                            : const Color(0xFFC7BDBD),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              sideMenu[index].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "poppins-regular",
                                color: selectedMenuData == index
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: selectedMenuData == 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  frmProvider!.drawerVillageNameData == null ||
                                          frmProvider!.drawerVillageNameData!
                                                  .data ==
                                              null
                                      ? Center(
                                          child: Text(buildTranslate(
                                              "noDataAvailable")!))
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: SizedBox(
                                            height: 50,
                                            child: ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: frmProvider!
                                                  .drawerVillageNameData!
                                                  .data!
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return index.isEven
                                                    ? CardWidget(
                                                        frmProvider!
                                                            .drawerVillageNameData!
                                                            .data![index],
                                                        index)
                                                    : Container();
                                              },
                                            ),
                                          ),
                                        ),
                                  frmProvider!.drawerVillageNameData == null ||
                                          frmProvider!.drawerVillageNameData!
                                                  .data ==
                                              null
                                      ? Center(
                                          child: Text(buildTranslate(
                                              "noDataAvailable")!))
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: SizedBox(
                                            height: 50,
                                            child: ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: frmProvider!
                                                  .drawerVillageNameData!
                                                  .data!
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return index.isOdd
                                                    ? CardWidget(
                                                        frmProvider!
                                                            .drawerVillageNameData!
                                                            .data![index],
                                                        index)
                                                    : Container();
                                              },
                                            ),
                                          ),
                                        )
                                ],
                              )
                            : selectedMenuData == 1
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: SizedBox(
                                          height: 50,
                                          child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: typeData.length,
                                            itemBuilder: (context, index) {
                                              return CardTypeWidget(
                                                  typeData[index], index);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                      )),
                ),
                Container(
                  color: Color(0xFFe7e7e7),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 15.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  var route = ModalRoute.of(context);
                                  if (route != null) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => FRM(
                                          aapbarVisibility: true,
                                          villageName: villageName,
                                          typeName: typeName,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(10),
                                  textStyle: const TextStyle(fontSize: 15),
                                  backgroundColor: const Color(0xFFffffff),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10), // <-- Radius
                                  ),
                                ),
                                child: const Text(
                                  'Apply',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'poppins-medium',
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 15.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => const MyHomePage()),
                                  // );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(10),
                                  textStyle: const TextStyle(fontSize: 15),
                                  backgroundColor: const Color(0xFFffffff),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10), // <-- Radius
                                  ),
                                ),
                                child: const Text(
                                  'Save All',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'poppins-medium',
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget CardWidget(String villageName, int index) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () async {
        showLoading();
        print("villageName : $villageName");
        selectedVillageIndex = index;
        villageName = villageName;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('selectedVillageIndex', index);
        stopLoading();
        setState(() {});
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: selectedVillageIndex == index ? Colors.green : Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(5),
        )),
        elevation: 1,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Text(villageName,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "poppins-regular",
                  color: selectedVillageIndex == index
                      ? Colors.white
                      : Colors.black,
                )),
          ),
        ),
      ),
    );
  }

  CardTypeWidget(String typeName, int index) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () async {
        print("TypeName : $typeName");
        selectedTypeIndex = index;
        typeName = typeName;
        setState(() {});
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('selectedTypeIndex', index);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: selectedTypeIndex == index ? Colors.green : Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(5),
        )),
        elevation: 1,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Text(typeName,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "poppins-regular",
                  color:
                      selectedTypeIndex == index ? Colors.white : Colors.black,
                )),
          ),
        ),
      ),
    );
  }

  void _loadSelectedVillageIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedVillageIndex = prefs.getInt('selectedVillageIndex') ?? 0;
    });
  }

  void _loadSelectedTypeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedTypeIndex = prefs.getInt('selectedTypeIndex') ?? 0;
    setState(() {});
  }
}
