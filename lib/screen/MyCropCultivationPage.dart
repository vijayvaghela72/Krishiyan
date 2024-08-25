import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../localization/AppLocalizations.dart';
import '../utils/Constants.dart';
import 'MyHomePage.dart';

class MyCropCultivationPage extends StatefulWidget {

  const MyCropCultivationPage({super.key});

  @override
  State<MyCropCultivationPage> createState() => _MyCropCultivationPageState();
}

class _MyCropCultivationPageState extends State<MyCropCultivationPage> with TickerProviderStateMixin {

  TextEditingController? controller;

  final List<String> items = [
    buildTranslate('organic')!,
    buildTranslate('inOrganic')!,
  ];

  String? selectedItemValue;

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
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Row(
          children: [
            InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset('assets/images/back.png')),
            const SizedBox(width: 10,),
            Text(
              buildTranslate("cropCultivationData")!,
              style: const TextStyle(color: Colors.white, fontFamily: 'poppins-medium', fontSize: 20),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // crops
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
              child: Text(
                buildTranslate("crops")!,
                style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                    fontFamily: 'poppins-semibold'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25.0),
              child: TextFormField(
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    fillColor: Colors.white,
                    filled: true,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    hintText: buildTranslate("enterCropsName")!,
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.green, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Please, fill this field.'
                    : null,
                controller: controller,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // Variety
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("variety")!,
                style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                    fontFamily: 'poppins-semibold'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25.0),
              child: TextFormField(
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    fillColor: Colors.white,
                    filled: true,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    hintText: buildTranslate('enterVariety'),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.green, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Please, fill this field.'
                    : null,
                controller: controller,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // date
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("dateOfSowing")!,
                style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                    fontFamily: 'poppins-semibold'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    hintText: 'dd/mm/yyyy',
                    hintStyle:
                    TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.green, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Please, fill this field.'
                    : null,
                controller: controller,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // goe location
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("geoLocation")!,
                style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                    fontFamily: 'poppins-semibold'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    hintText: '----',
                    hintStyle:
                    TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.green, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Please, fill this field.'
                    : null,
                controller: controller,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // type of cultivation practice
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("typeofCultivationPractice")!,
                style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                    fontFamily: 'poppins-semibold'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Container(
                color: Colors.white,
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),),
                    // Add more decoration..
                  ),
                  hint: const Text(
                    '--',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                      ),
                    ),
                  ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select type of Entity.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    //Do something when selected item is changed.
                  },
                  onSaved: (value) {
                    selectedItemValue = value.toString();
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 24,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // area in arcs
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("areaInAcres")!,
                style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                    fontFamily: 'poppins-semibold'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25.0),
              child: TextFormField(
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    fillColor: Colors.white,
                    filled: true,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    hintText: buildTranslate('enterAreaInAcres'),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.green, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Please, fill this field.'
                    : null,
                controller: controller,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // geo link in area
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("geoLinkAreaOnMap")!,
                style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                    fontFamily: 'poppins-semibold'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25.0),
              child: TextFormField(
                decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    hintText: '----',
                    hintStyle:
                    TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.green, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Please, fill this field.'
                    : null,
                controller: controller,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            SizedBox(
              height: 35,
              child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    label: Text(buildTranslate('addCrop')!),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                      const Color(0xFF3FC041),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12.0),
                      ),
                    ),
                  )
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0),
                child: ElevatedButton(
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: const Color(0xFF3FC041),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  child: Text(
                    buildTranslate('SUBMIT')!,
                    style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'poppins-medium'),
                  ),
                )),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      // drawer: MyDrawer(),
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              // Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => MyHomePage(selectedIndex: 1,)));
            },
            child: const Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.close,
                color: Colors.black,
                size: 20.0,
              ),
            ),
          ),

          Center(child: Image.asset('assets/images/check_green.png', width: 100, height: 100,)),

          Text(buildTranslate("successfullySaved")!, softWrap: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: "poppins-semibold",
                fontSize: 15.0, color: Colors.grey),),

          const SizedBox(height: 20,),

          Text(buildTranslate("thankYou")!, softWrap: true,
            style: const TextStyle(fontFamily: "poppins-semibold",
                fontSize: 20.0, color: Colors.black),),

          const SizedBox(height: 20,),
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

}

class cropsCategory {
  String? name;
  String? icon;
  String? id;

  cropsCategory({
    required this.name,
    required this.icon,
    required this.id,
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
