import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../localization/AppLocalizations.dart';
import '../../utils/Constants.dart';

class SelectLanguagePage extends StatefulWidget {
  const SelectLanguagePage({super.key});

  @override
  State<SelectLanguagePage> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {

  List<Category> orgCategory = [
    Category(name: "Hindi", id: "1", pronous: "आ", text: "हिंदी"),
    Category(name: "English", id: "2", pronous: "A", text: "अंग्रेज़ी"),
    // Category(name: "Marathi", id: "3", pronous: "म", text: "मराठी"),
    // Category(name: "Assamese", id: "4", pronous: "অ", text: "অসমীয়া"),
    // Category(name: "Bengali", id: "5", pronous: "ব", text: "বাংলা"),
    // Category(name: "Bhojpuri", id: "6", pronous: "भ", text: "भोजपुरी"),
    // Category(name: "Dogri", id: "7", pronous: "ड", text: "डोगरी"),
    // Category(name: "Gujarati", id: "8", pronous: "ગ", text: "ગુજરાતી"),
    // Category(name: "Kannada", id: "9", pronous: "ಕ", text: "ಕನ್ನಡ"),
    // Category(name: "Malayalam", id: "10", pronous: "മ", text: "മലയാളം"),
    // Category(name: "Odia (Oriya)", id: "11", pronous: "ଓ", text: "ଓଡ଼ିଆ"),
    // Category(name: "Punjabi", id: "12", pronous: "ਪੰ", text: "ਪੰਜਾਬੀ"),
    // Category(name: "Sanskrit", id: "13", pronous: "स", text: "संस्कृत"),
    // Category(name: "Sinhala", id: "14", pronous: "සි", text: "සිංහල"),
    // Category(name: "Tamil", id: "15", pronous: "த", text: "தமிழ்"),
    // Category(name: "Telugu", id: "16", pronous: "టి", text: "తెలుగు"),
    // Category(name: "Urdu", id: "17", pronous: "یو", text: "اردو"),
    // Category(name: "Sindhi", id: "18", pronous: "ایس", text: "سندھی"),
  ];

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
              buildTranslate("selectLanguage")!,
              style: const TextStyle(color: Colors.white, fontFamily: 'poppins-semibold', fontSize: 15),
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

            listWidget(),

            const SizedBox(height: 35,),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pop(context);
                  setState(() {
                    if(selectedIndex == 0) {
                      MyLocalizations.load(const Locale('hi', ''));
                      localLang = "hi";
                      print("localLang change 1 :  $localLang");
                    }
                    else if(selectedIndex == 1){
                      MyLocalizations.load(const Locale('en', ''));
                      localLang = "en";
                      print("localLang change 2 :  $localLang");
                    }
                    // else if(selectedIndex == 2){
                    //   MyLocalizations.load(const Locale('marathi', ''));
                    //   localLang = "marathi";
                    //   print("localLang change 3 :  $localLang");
                    // }
                    Navigator.of(context).pop(true);
                  });
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
                child: const Text('Continue', style: TextStyle(fontSize: 18, fontFamily: 'poppins-medium'),),
              ),
            ),
            const SizedBox(height: 35,),

          ],
        ),
      ),
    );

  }

  Widget listWidget() {
    return Padding(
      padding: const EdgeInsets.only(left:12.0, right: 12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orgCategory.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFf9f9f9),
                    )
                  ],
                  border: Border.all(color: selectedIndex == index ? Colors.green : Colors.white,
                      width: 2),
                  borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    selectedIndex = index ;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orgCategory[index].text ?? "", style:
                          const TextStyle(color: Colors.black, fontSize: 18,
                              fontFamily: 'poppins-semibold'),),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: selectedIndex == index ? Colors.green : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: InkResponse(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index ;
                                  });
                                },
                                child: selectedIndex == index ? Icon(
                                  Icons.check,
                                  color: selectedIndex == index ? Colors.white : null,
                                ) : Container(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Text(orgCategory[index].name ?? "", style:
                      const TextStyle(color: Color(0xFF808080), fontSize: 15,
                          fontFamily: 'poppins-regular'),),
                      const SizedBox(height: 5,),
                      Text(orgCategory[index].pronous ?? "", style:
                      const TextStyle(color: Color(0xFF1D8D4C), fontSize: 15,
                          fontFamily: 'poppins-semibold'),),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2.5),
        ),
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      ),
    );
  }

}

class Category {
  String? name;
  String? pronous;
  String? text;
  String? id;

  Category({required this.name,required this.text,required this.id, required this.pronous});
}