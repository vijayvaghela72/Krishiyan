import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';
import 'package:krishiyan/screen/MyProfilePage.dart';

class MyBuyCommodityPage extends StatefulWidget {
  const MyBuyCommodityPage({super.key});

  @override
  State<MyBuyCommodityPage> createState() => _MyBuyCommodityPageState();
}

class _MyBuyCommodityPageState extends State<MyBuyCommodityPage> {

  TextEditingController? controller;

  final List<String> commodityItems = ['Maize', 'Coriander', 'Soya'];
  String? selectedCommodityItemValue;

  final List<String> quantityItems = ['Ton', 'Kg', 'Qtl'];
  String? selectedQuantityItemValue;

  final List<String> sizeItems = ['MM', 'CM'];
  String? selectedSizeItemValue;

  final List<String> purchaseItems = ['Kg', 'Qtl', 'Ton'];
  String? selectedPurchaseItemValue;

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
              buildTranslate("buyCommodity")!,
              style: const TextStyle(color: Colors.white, fontFamily: 'poppins-semibold', fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
            child: Text(buildTranslate("buyCommodity")!, style: const TextStyle(fontSize: 15, fontFamily: 'poppins-medium'),),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 30,),

          // Select Commodity
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Text(buildTranslate("selectCommodity")!, style: const TextStyle(fontSize: 15,
                color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Container(
              color: Colors.white,
              child: DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none
                    // borderSide: const BorderSide(
                    //   color: Colors.grey,
                    //   width: 1.0,
                    // ),
                    ),
                  // Add more decoration..
                ),
                hint: Text(
                  buildTranslate("selectCommodity")!,
                  style: const TextStyle(fontSize: 14),
                ),
                items: commodityItems
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
                  selectedCommodityItemValue = value.toString();
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

          const SizedBox(height: 20,),

          // variety
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Text(buildTranslate("Variety")!, style: const TextStyle(fontSize: 15,
                color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintText: buildTranslate('Enter name of variety'),
                hintStyle: const TextStyle(color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 20,),

          // Quantity
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Text(buildTranslate("quantity")!,
              style: const TextStyle(fontSize: 15,
                color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: controller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      hintText: buildTranslate('addYourQuantity'),
                      hintStyle: const TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 3,),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none
                          // borderSide: const BorderSide(
                          //   color: Colors.grey,
                          //   width: 1.0,
                          // ),
                        ),
                        // Add more decoration..
                      ),
                      hint: const Text(
                        'Ton',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      items: quantityItems
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
                        selectedQuantityItemValue = value.toString();
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
              ],
            ),
          ),

          const SizedBox(height: 20,),

          // Moisture
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Text(buildTranslate("moisture")!, style: const
            TextStyle(fontSize: 15, color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintText: '__%',
                hintStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 20,),

          // Any Local Grade Specification
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Text(buildTranslate("anyLocalGradeSpecification")!, style: const
            TextStyle(fontSize: 15, color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintText: buildTranslate("anyLocalGradeSpecification")!,
                hintStyle: const TextStyle(color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 20,),

          // size
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Text(buildTranslate("size")!, style: const
            TextStyle(fontSize: 15, color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: controller,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      hintText: '',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 3,),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none
                          // borderSide: const BorderSide(
                          //   color: Colors.grey,
                          //   width: 1.0,
                          // ),
                        ),
                        // Add more decoration..
                      ),
                      hint: const Text(
                        'MM',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      items: sizeItems
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
                        selectedSizeItemValue = value.toString();
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
              ],
            ),
          ),

          const SizedBox(height: 20,),

          // Count
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Text(buildTranslate("count")!, style: const TextStyle(fontSize: 15,
                color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintText: buildTranslate('enterCount')!,
                hintStyle: const TextStyle(color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 20,),

          // purchase
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Text(buildTranslate("purchasePriceInRs")!, style: const TextStyle(fontSize: 15,
                color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: controller,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      hintText: '',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 3,),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none
                          // borderSide: const BorderSide(
                          //   color: Colors.grey,
                          //   width: 1.0,
                          // ),
                        ),
                        // Add more decoration..
                      ),
                      hint: const Text(
                        'Kg',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      items: purchaseItems
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
                        selectedPurchaseItemValue = value.toString();
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
              ],
            ),
          ),
          const SizedBox(height: 20,),

          // date of delivery
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Text(buildTranslate("dateOfExpectedDelivery")!, style: const
            TextStyle(fontSize: 15, color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintText: 'dd/mm/yyyy',
                hintStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 20,),

          // origin of commodity
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Text(buildTranslate("originOfCommodity")!, style: const TextStyle(fontSize: 15,
                color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintText: '',
                hintStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 20,),

          // delivery location
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Text(buildTranslate("deliveryLocation")!, style: const
            TextStyle(fontSize: 15, color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintText: '',
                hintStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 20,),

          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(17),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: const Color(0xFF3692FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22), // <-- Radius
                ),
              ),
              child: Text(buildTranslate('uploadImage')!,
                style: const TextStyle(fontSize: 15, fontFamily: 'poppins-medium'),),
            ),
          ),

          const SizedBox(height: 20,),

          // Add comments
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Text(buildTranslate("addComments")!, style: const TextStyle(fontSize: 15,
                color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
              maxLines: null,
              minLines: 5,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                hintText: '',
                hintStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 80,),
        ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop();
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

          Text(buildTranslate("SuccessfullyUpdate")!, softWrap: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: "poppins-semibold", fontSize: 15.0, color: Colors.grey),),

          const SizedBox(height: 20,),

          Text(buildTranslate("thankYou")!, softWrap: true,
            style: const TextStyle(fontFamily: "poppins-semibold", fontSize: 20.0, color: Colors.black),),

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