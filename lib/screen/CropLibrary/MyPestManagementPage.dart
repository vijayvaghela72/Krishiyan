import '../../widgets/drive_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../language/SelectLanguagePage.dart';
import '../../mvc/model/CropLibraryData.dart';

// ignore: must_be_immutable
class MyPestManagementPage extends StatefulWidget {
  bool aapbarVisibility;
  Future<List<CropLibraryData>?> cropData;
  final String? selectedcrop;

  MyPestManagementPage(
      {super.key,
      required this.aapbarVisibility,
      required this.cropData,
      required this.selectedcrop});

  @override
  State<MyPestManagementPage> createState() => _MyPestManagementPageState();
}

class _MyPestManagementPageState extends State<MyPestManagementPage>
    with TickerProviderStateMixin {
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),
      extendBody: false,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      appBar: widget.aapbarVisibility
          ? AppBar(
              automaticallyImplyLeading: false,
              title: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const SelectLanguagePage()),
                  );
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
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 25.0,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Go Back",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'poppins-medium',
                        fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                "Pest Management",
                softWrap: true,
                style: TextStyle(
                    color: Color(0xFF3FC041),
                    fontSize: 22,
                    fontFamily: 'poppins-medium'),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                style: const TextStyle(
                    fontFamily: "poppins-regular", fontSize: 13.0),
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  fillColor: Colors.white,
                  filled: true,
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(7.0),
                  //   ),
                  // ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: 'Enter name of the pest',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 13.0,
                      fontFamily: "poppins-regular"),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please, fill this field.' : null,
                controller: controller,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            listWidget(),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  showSolutionAlertDialog(BuildContext context, String solutions) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Solution",
                    softWrap: true,
                    style: TextStyle(
                        fontFamily: "poppins-semibold",
                        fontSize: 15.0,
                        color: Colors.black),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(color: Colors.grey),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
            ),
            child: Text(
              solutions,
              softWrap: true,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                  fontFamily: "poppins-regular",
                  fontSize: 13.0,
                  color: Color(0xFF666666)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget listWidget() {
    return FutureBuilder<List<CropLibraryData>?>(
      future: widget.cropData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CropLibraryData>? filteredData = snapshot.data?.where((data) {
            return data.localName ==
                widget.selectedcrop; // Filter by selected crop
          }).toList();

          // Check if filteredData has any results
          if (filteredData == null || filteredData.isEmpty) {
            return const Text('No data available for the selected crop.');
          }
          // Filter out irrigation entries that have only '_id' without additional data
          filteredData.forEach((cropData) {
            cropData.pestManagement?.removeWhere((pestmanagement) =>
                pestmanagement.name == null &&
                pestmanagement.solutions == null);
          });
          return ListView.builder(
              itemCount: filteredData.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, parentIndex) {
                return Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredData[parentIndex].pestManagement!.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xFFd3d3d3), width: 1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFFd3d3d3),
                                )
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 200,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: filteredData[parentIndex]
                                            .pestManagement![index]
                                            .images!
                                            .isNotEmpty
                                        ? DriveImage(
                                            imageUrlData:
                                                filteredData[parentIndex]
                                                    .pestManagement![index]
                                                    .images![0])
                                        : Container(),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        filteredData[parentIndex]
                                                .pestManagement![index]
                                                .name ??
                                            "",
                                        softWrap: true,
                                        style: const TextStyle(
                                            color: Color(0xFF111111),
                                            fontSize: 14,
                                            fontFamily: 'poppins-semibold'),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0, bottom: 5.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showSolutionAlertDialog(
                                            context,
                                            filteredData[parentIndex]
                                                    .pestManagement![index]
                                                    .solutions ??
                                                "");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        minimumSize: Size.zero,
                                        textStyle:
                                            const TextStyle(fontSize: 14),
                                        padding: const EdgeInsets.all(7),
                                        backgroundColor:
                                            const Color(0xFF3FC041),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(17),
                                        ),
                                      ),
                                      child: const Text(
                                        'SOLUTION',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'poppins-regular'),
                                      ),
                                    )),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class Entity {
  String? name;
  String? id;
  String? image;

  Entity({
    required this.name,
    required this.id,
    required this.image,
  });
}

class bottomCategory {
  String? name;
  String? icon;
  String? id;

  bottomCategory({
    required this.name,
    required this.icon,
    required this.id,
  });
}
