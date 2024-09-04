import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../mvc/model/SelectVillagesNameData.dart';
import '../utils/Constants.dart';

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

  int selectedVillageData = 0;
  int selectedTypeData = 0;

  int selectedMenuData = 0;

  SelectVillagesNameData? _villageNameData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchVillageData();
  }

  Future<void> _fetchVillageData() async {
    try {
      // Replace with your actual API endpoint
      var response = await Dio().get(VILLAGES_NAMES);

      if (response.statusCode == 200) {
        setState(() {
          _villageNameData = SelectVillagesNameData.fromJson(response.data);
        });
      } else {
        throw Exception('Failed to load villages');
      }
    } catch (e) {
      print('Error fetching _village name data: $e');
    }
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
      // backgroundColor: Colors.white,
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
                        setState(() {
                          _onSelectedMenuDataTapped(index);
                        });
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
                            _villageNameData == null ||
                                _villageNameData!.data == null
                                ? const Center(
                                child: Text('No data available'))
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
                                  itemCount: _villageNameData!
                                      .data!.length,
                                  itemBuilder: (context, index) {
                                    return index.isEven
                                        ? CardWidget(
                                        _villageNameData!
                                            .data![index],
                                        index)
                                        : Container();
                                  },
                                ),
                              ),
                            ),
                            _villageNameData == null ||
                                _villageNameData!.data == null
                                ? const Center(
                                child: Text('No data available'))
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
                                  itemCount: _villageNameData!
                                      .data!.length,
                                  itemBuilder: (context, index) {
                                    return index.isOdd
                                        ? CardWidget(
                                        _villageNameData!
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: typeData.length,
                                  itemBuilder: (context, index) {
                                    return CardTypeWidget(typeData[index], index);
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                            : Container(),
                      )
                    // child: GridView.builder(
                    //   padding: EdgeInsets.zero,
                    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                    //   itemCount: villageData.length,
                    //   itemBuilder: (context, index) {
                    //     return InkWell(
                    //       onTap: () {
                    //         setState(() {
                    //           _onSelectedVillageDataTapped(index);
                    //         });
                    //       },
                    //       child: Card(
                    //         semanticContainer: true,
                    //         clipBehavior: Clip.antiAliasWithSaveLayer,
                    //         color: selectedVillageData == index
                    //             ? Colors.green
                    //             : Colors.white,
                    //         shape: const RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.all(Radius.circular(10),)),
                    //         margin: const EdgeInsets.all(20),
                    //         elevation: 2,
                    //         child : Center(
                    //           child: Text(
                    //               villageData[index].toString(),
                    //               style: TextStyle(
                    //                 fontSize: 15,
                    //                 fontWeight: FontWeight.w600,
                    //                 color: selectedVillageData == index
                    //                     ? Colors.white
                    //                     : Colors.black,
                    //               )),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ),
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
                                  'Save All(5)',
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
      onTap: () {
        print("villageName : $villageName");
        _onSelectedVillageDataTapped(index);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: selectedVillageData == index ? Colors.green : Colors.white,
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
                  color: selectedVillageData == index
                      ? Colors.white
                      : Colors.black,
                )),
          ),
        ),
      ),
    );
  }

  Widget CardTypeWidget(String data, int index) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        _onSelectedTypeDataTapped(index);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: selectedTypeData == index ? Colors.green : Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            )),
        elevation: 1,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Text(data,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "poppins-regular",
                  color:
                  selectedTypeData == index ? Colors.white : Colors.black,
                )),
          ),
        ),
      ),
    );
  }

  void _onSelectedVillageDataTapped(int index) {
    setState(() {
      selectedVillageData = index;
    });
    print("Selected Village Page : $selectedVillageData");
  }

  void _onSelectedTypeDataTapped(int index) {
    setState(() {
      selectedTypeData = index;
    });
    print("Selected Type Page : $selectedTypeData");
  }

  void _onSelectedMenuDataTapped(int index) {
    setState(() {
      selectedMenuData = index;
    });
    print("Selected Menu Page : $selectedMenuData");
  }
}
