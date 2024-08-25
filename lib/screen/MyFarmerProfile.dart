import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../localization/AppLocalizations.dart';
import 'MyCropCultivationPage.dart';

class MyFarmerProfilePage extends StatefulWidget {

  const MyFarmerProfilePage({super.key});

  @override
  State<MyFarmerProfilePage> createState() => _MyFarmerProfilePageState();
}

class _MyFarmerProfilePageState extends State<MyFarmerProfilePage> {

  TextEditingController? ownedAreaController;
  TextEditingController? goeLocationController;
  TextEditingController? leasedFarmController;
  TextEditingController? goeLocationLeasedController;
  TextEditingController? districtController;
  TextEditingController? stateController;
  TextEditingController? bankNameController;
  TextEditingController? accountNameController;
  TextEditingController? accountNumberController;
  TextEditingController? panNumberController;
  TextEditingController? aadharNumberController;

  final List<String> items = [
    buildTranslate('organic')!,
    buildTranslate('inOrganic')!,
  ];

  String? selectedItemValue;

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFe7e7e7),
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
              buildTranslate("farmerProfile")!,
              style: const TextStyle(color: Colors.white, fontFamily: 'poppins-medium', fontSize: 20),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            const SizedBox(
              height: 20,
            ),

            // owned farm
            Padding(
              padding:
              const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("totalOwnedFarmArea")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    hintText: buildTranslate('enterAreaInAcres'),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Please, fill this field.'
                    : null,
                controller: ownedAreaController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // geo location
            Padding(
              padding:
              const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("geoLocation(OwnedFarm)")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    hintText: '----',
                    hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Please, fill this field.'
                    : null,
                controller: goeLocationController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // total leased farm
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("totalLeasedFarmArea")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    hintText: buildTranslate('enterLeasedFarmArea'),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Please, fill this field.'
                    : null,
                controller: leasedFarmController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // geo location
            Padding(
              padding:
              const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("geoLocation(LeasedFarm)")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: '----',
                    hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Please, fill this field.'
                    : null,
                controller: goeLocationLeasedController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // pin code
            Padding(
              padding:
              const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("pinCode")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: '----',
                    hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Please, fill this field.'
                    : null,
                controller: goeLocationLeasedController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // state
            Padding(
              padding:
              const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("state")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: '----',
                    hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? buildTranslate('enterState')
                    : null,
                controller: stateController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // district
            Padding(
              padding:
              const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("district")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate("district")!,
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Enter District'
                    : null,
                controller: districtController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // address
            Padding(
              padding:
              const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("address")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate("address")!,
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? buildTranslate('enterAddress')
                    : null,
                controller: districtController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // cultivation practice
            Padding(
              padding:
              const EdgeInsets.only(left: 25.0, right: 25.0),
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
                      borderSide: BorderSide.none),
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

            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,

                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const MyHomePage()),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: const Color(0xFF1D8D4C),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // <-- Radius
                    ),
                  ),
                  child: Text(buildTranslate('editBankDetail')!, style: const TextStyle(fontSize: 18,
                      fontFamily: 'poppins-medium'),),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            // bank name
            Padding(
              padding:
              const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("bankName")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('enterBankName')!,
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? buildTranslate('enterBankName')!
                    : null,
                controller: bankNameController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // account name
            Padding(
              padding:
              const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("accountName")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('enterAccountName')!,
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? buildTranslate('enterAccountName')!
                    : null,
                controller: accountNameController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // account number
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("accountNumber")!,
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('enterAccountNumber'),
                    hintStyle: const TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? buildTranslate('enterAccountNumber')
                    : null,
                controller: accountNumberController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // ifs code
            Padding(
              padding:
              const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("IFSCode")!,
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
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('enterIFSCode')!,
                    hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Enter IFS Code'
                    : null,
                controller: accountNumberController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // pan number
            Padding(
              padding:
              EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("panNumber")!,
                style: TextStyle(
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
                decoration:  InputDecoration(
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
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('enterPanNumber'),
                    hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? buildTranslate('enterPanNumber')
                    : null,
                controller: panNumberController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // dharma number
            Padding(
              padding:
              EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                buildTranslate("aadhaarNumber")!,
                style: TextStyle(
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('enterAadhaarNumber')!,
                    hintStyle: TextStyle(color: Color(0xFFe7e7e7)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)),
                      borderSide: BorderSide(
                          color: Colors.white, width: 0.5),
                    )),
                validator: (value) => value!.isEmpty
                    ? 'Enter Aadhar Code'
                    : null,
                controller: aadharNumberController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // submit
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                            const MyCropCultivationPage()));
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
                  child: Text(buildTranslate('SUBMIT')!, style: const
                          TextStyle(fontSize: 15, fontFamily: 'poppins-medium'),),
                ),
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

}