import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/screen/MyLoginPage.dart';
import '../helper/SharedPref.dart';
import '../localization/AppLocalizations.dart';
import '../localization/NavigationService.dart';
import '../utils/Constants.dart';
import 'MyHomePage.dart';

class MyWelcomePage extends StatefulWidget {
  const MyWelcomePage({super.key});

  @override
  State<MyWelcomePage> createState() => _MyWelcomePageState();
}

class _MyWelcomePageState extends State<MyWelcomePage> {

  bool checkLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("localLang :  $localLang");
    // print("---print context: ${NavigationService.navigatorKey.currentContext.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/welcomeBg.png"),
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // const SizedBox(height: 40,),
            Expanded(
                child: topWidget()
            ),
            // Expanded(
            //     child: bottomWidget()
            // ),
          ],
        ),
      ),
    );
  }

  Widget topWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Text(buildTranslate("welcomeTo")!,
          style: const TextStyle(color: Color(0xFF3dc33b), fontSize: 30,
              fontFamily: 'arvo'),)),
        const SizedBox(height: 35,),
        Center(child: Image.asset('assets/images/welcome-logo.png')),
        const SizedBox(height: 35,),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: ElevatedButton(
            onPressed: () async {
              checkLogin = await SharedPref.readPreferenceValue(isLogin, PrefEnum.BOOL);

              if(!checkLogin) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyLoginPage()),);
              }
              else {
                Navigator.push(context, MaterialPageRoute(builder:
                    (context) => MyHomePage(selectedIndex: 0,)),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(22),
              textStyle: const TextStyle(fontSize: 18),
              backgroundColor: const Color(0xFF3287DE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(buildTranslate("getStarted")!, style: const TextStyle(fontSize: 18, fontFamily: 'arvo'),),
          ),
        )
      ],
    );
  }

  Widget bottomWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Stack(children: <Widget>[
          Align(alignment: Alignment.center,
            child:
            Center(child: Text(buildTranslate("supportedBy")!, style: const TextStyle(fontSize: 18, color:
            Colors.black, fontFamily: 'arvo'),)),
          ),
        ],),
        const SizedBox(height: 35,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/client.png'),),
            ),
            Expanded(
              child: Align(alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/client.png'),),
            ),
            Expanded(
              child: Align(alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/client.png'),),
            ),
            Expanded(
              child: Align(alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/client.png'),),
            ),
          ],
        ),
        const SizedBox(height: 20,),
      ],
    );
  }
}