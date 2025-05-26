import 'package:krishiyan/screen/login/login.dart';

import '../../widgets/color.dart';
import '../../widgets/constant.dart';
import '../../helper/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard/dashborad.dart';
import '../../localization/AppLocalizations.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool checkLogin = false;

  @override
  void initState() {
    super.initState();
    print("localLang :  $localLang");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColor.transparentColor,
    ));
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/welcomeBg.png"),
            colorFilter: ColorFilter.mode(
                AppColor.blackColor.withOpacity(0.1), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: topWidget()),
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
        Center(
            child: Text(
          buildTranslate("welcomeTo")!,
          style: const TextStyle(
              color: Color(0xFF3dc33b), fontSize: 30, fontFamily: 'arvo'),
        )),
        const SizedBox(
          height: 35,
        ),
        Center(child: Image.asset('assets/images/welcome-logo.png')),
        const SizedBox(
          height: 35,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: ElevatedButton(
            onPressed: () async {
              checkLogin =
                  await SharedPref.readPreferenceValue(isLogin, PrefEnum.BOOL);

              if (!checkLogin) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            selectedIndex: 0,
                            typeOfOrganization: "",
                          )),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColor.whiteColor,
              padding: const EdgeInsets.all(22),
              textStyle: const TextStyle(fontSize: 18),
              backgroundColor: const Color(0xFF3287DE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              buildTranslate("getStarted")!,
              style: const TextStyle(fontSize: 18, fontFamily: 'arvo'),
            ),
          ),
        )
      ],
    );
  }

  Widget bottomWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Center(
                  child: Text(
                buildTranslate("supportedBy")!,
                style: TextStyle(
                    fontSize: 18,
                    color: AppColor.blackColor,
                    fontFamily: 'arvo'),
              )),
            ),
          ],
        ),
        const SizedBox(
          height: 35,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/client.png'),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/client.png'),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/client.png'),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/client.png'),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
