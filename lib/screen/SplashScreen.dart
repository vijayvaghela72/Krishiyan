import 'package:flutter/material.dart';
import '../helper/SharedPref.dart';
import '../utils/Constants.dart';
import 'HomeScreen/HomePage.dart';
import 'Login/LoginPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkWelcomePage();
  }

  // Check if WelcomePage has been shown before
  Future<void> _checkWelcomePage() async {
    bool checkLogin = await SharedPref.readPreferenceValue(isLogin, PrefEnum.BOOL);

    if(!checkLogin) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()),);
    }
    else {
      Navigator.push(context, MaterialPageRoute(builder:
          (context) => HomePage(selectedIndex: 0, typeOfOrganization: "",)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show loading spinner
      ),
    );
  }
}
