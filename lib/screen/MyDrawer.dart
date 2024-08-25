import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final List<String> sideMenu = ["Villages", "Types", "Stages"];

  final List<String> villageData = [
    "Ahmadabad",
    "Shrirampur",
    "Berdapur",
    "Surat",
    "Pune"
  ];

  final List<String> typeData = [
    "Organic",
    "InOrganic",
  ];

  final List<String> stagesData = [
    "Seed Germination",
    "Harvesting",
    "Flowering",
    "Cab Development",
    "Vegitative"
  ];

  int selectedVillageData = 0;
  int selectedTypeData = 0;
  int selectedStageData = 0;

  int selectedMenuData = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.white,
      //   title: const Text(
      //     "",
      //     style: TextStyle(color: Colors.white, fontFamily: 'poppins-semibold', fontSize: 20),
      //   ),
      // ),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white, systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                    child:  Container(
                        width: MediaQuery.of(context).size.width * 0.70,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child:

                          selectedMenuData == 0 ?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: villageData.length,
                                    itemBuilder: (context, index) {
                                      return index.isEven ? CardWidget(villageData[index], index) : Container();
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: villageData.length,
                                    itemBuilder: (context, index) {
                                      return index.isOdd ? CardWidget(villageData[index], index) : Container();
                                    },
                                  ),
                                ),
                              )
                            ],
                          ) :
                          selectedMenuData == 1 ?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: typeData.length,
                                    itemBuilder: (context, index) {
                                      return CardTypeWidget(typeData[index], index);
                                    },
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              //   child: SizedBox(
                              //     height: 50,
                              //     child: ListView.builder(
                              //       physics: NeverScrollableScrollPhysics(),
                              //       shrinkWrap: true,
                              //       scrollDirection: Axis.horizontal,
                              //       itemCount: typeData.length,
                              //       itemBuilder: (context, index) {
                              //         return index.isEven ? CardTypeWidget(typeData[index], index) : Container();
                              //       },
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              //   child: SizedBox(
                              //     height: 50,
                              //     child: ListView.builder(
                              //       physics: NeverScrollableScrollPhysics(),
                              //       shrinkWrap: true,
                              //       scrollDirection: Axis.horizontal,
                              //       itemCount: typeData.length,
                              //       itemBuilder: (context, index) {
                              //         return index.isOdd ? CardTypeWidget(typeData[index], index) : Container();
                              //       },
                              //     ),
                              //   ),
                              // )
                            ],
                          )
                              :
                          selectedMenuData == 2 ?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: stagesData.length,
                                    itemBuilder: (context, index) {
                                      return index.isEven ? CardStageWidget(stagesData[index], index) : Container();
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: stagesData.length,
                                    itemBuilder: (context, index) {
                                      return index.isOdd ? CardStageWidget(stagesData[index], index) : Container();
                                    },
                                  ),
                                ),
                              )
                            ],
                          ) :
                          Container(),
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
                Container(color: Color(0xFFe7e7e7),
                  child:
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0, top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child:
                            Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
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
                                      borderRadius: BorderRadius.circular(10), // <-- Radius
                                    ),
                                  ),
                                  child: const Text('Apply', style:
                                  TextStyle(fontSize: 12, fontFamily: 'poppins-medium', color: Colors.black),),
                                ),
                              ),
                            ),
                        ),
                        Expanded(
                            child:
                            Align(
                              alignment: FractionalOffset.bottomCenter,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
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
                                      borderRadius: BorderRadius.circular(10), // <-- Radius
                                    ),
                                  ),
                                  child: const Text('Save All(5)', style:
                                  TextStyle(fontSize: 12, fontFamily: 'poppins-medium', color: Colors.black),),
                                ),
                              ),
                            ),),
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

  Widget CardWidget(String data, int index){
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        _onSelectedVillageDataTapped(index);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: selectedVillageData == index
            ? Colors.green
            : Colors.white,
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
                  color: selectedVillageData == index
                      ? Colors.white
                      : Colors.black,
                )),
          ),
        ),
      ),
    );
  }

  Widget CardStageWidget(String data, int index){
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        _onSelectedStageDataTapped(index);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: selectedStageData == index
            ? Colors.green
            : Colors.white,
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
                  color: selectedStageData == index
                      ? Colors.white
                      : Colors.black,
                )),
          ),
        ),
      ),
    );
  }

  Widget CardTypeWidget(String data, int index){
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        _onSelectedTypeDataTapped(index);
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: selectedTypeData == index
            ? Colors.green
            : Colors.white,
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
                  color: selectedTypeData == index
                      ? Colors.white
                      : Colors.black,
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

  void _onSelectedStageDataTapped(int index) {
    setState(() {
      selectedStageData = index;
    });
    print("Selected Stage Page : $selectedStageData");
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
