import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';

import 'MyProfilePage.dart';

class MyEditBankDetailPage extends StatefulWidget {
  const MyEditBankDetailPage({super.key});

  @override
  State<MyEditBankDetailPage> createState() => _MyEditBankDetailPageState();
}

class _MyEditBankDetailPageState extends State<MyEditBankDetailPage> {

  TextEditingController? controller;
  TextEditingController? _userPasswordController;

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
              buildTranslate("editBankDetail")!,
              style: TextStyle(color: Colors.white, fontFamily: 'poppins-semibold', fontSize: 20),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30,),

            // bank name
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("bankName")!, style: TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    fillColor: Colors.white,
                    filled: true,
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.all(Radius.circular(7.0),
                    //   ),
                    // ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                        // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: buildTranslate('unionBankOfIndia')!,
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    )
                ),
                validator: (value) => value!.isEmpty ? 'Please, fill this field.' : null,
                controller: controller,
              ),
            ),

            const SizedBox(height: 20,),

            // account name
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("accountName")!, style: TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _userPasswordController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: buildTranslate("enterAccountName")!,
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20,),

            // account number
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("accountNumber")!, style: TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _userPasswordController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: buildTranslate('enterAccountNumber')!,
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20,),

            // ifs code
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("IFSCode")!, style: const TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: _userPasswordController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: buildTranslate("enterIFSCode"),
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0,),
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20,),

            // passbook upload
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(buildTranslate("uploadPhotoOfPassbook")!, style: TextStyle(fontSize: 15,
                  color: Color(0xFF666666), fontFamily: 'poppins-semibold'),),
            ),
            const SizedBox(height: 10,),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color(0xFFd3d3d3)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                  side: BorderSide(color: Color(0xFFe7e7e7))
                              )
                          )
                      ),
                    onPressed: () {},
                    child: Text(buildTranslate('chooseFile')!, softWrap: true,style: TextStyle(fontSize: 15,
                        color: Colors.black, fontFamily: 'poppins-regular')),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(buildTranslate("noChooseFile")!, style: TextStyle(fontSize: 15,
                      color: Color(0xFF666666), fontFamily: 'poppins-regular'),),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MyProfilePage()),
                    );
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
                  child: Text(buildTranslate('save')!, style: const TextStyle(fontSize: 15, fontFamily: 'poppins-medium'),),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}