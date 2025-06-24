import '../dashboard/dashborad.dart';
import 'package:flutter/material.dart';
import '../../helper/shared_pref.dart';
import 'package:krishiyan/helper/constant.dart';
import 'package:krishiyan/screen/login/login.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  // Request gallery permission
  Future<void> _requestGalleryPermission() async {
    // Request photos permission (gallery access)
    var status = await Permission.photos.request();
    print('Permission.photos.request : $status');

    if (status.isGranted) {
      // Permission granted, proceed to check welcome page
      _checkWelcomePage();
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // Show dialog explaining why permission is needed
      _showPermissionDeniedDialog();
    }
  }

  // Show dialog when permission is denied
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gallery Access Required'),
          content: Text(
              'This app requires access to your gallery to upload photos. Please grant permission to continue.'),
          actions: [
            TextButton(
              onPressed: () async {
                // Open app settings if permanently denied
                if (await Permission.photos.isPermanentlyDenied) {
                  await openAppSettings();
                } else {
                  // Request permission again
                  _requestGalleryPermission();
                }
                Navigator.of(context).pop();
              },
              child: Text('Grant Permission'),
            ),
            TextButton(
              onPressed: () {
                // Exit app if user refuses permission
                Navigator.of(context).pop();
                // You can add SystemNavigator.pop() here if you want to close the app
              },
              child: Text('Deny'),
            ),
          ],
        );
      },
    );
  }

  // Check if WelcomePage has been shown before
  Future<void> _checkWelcomePage() async {
    bool checkLogin =
        await SharedPref.readPreferenceValue(isLogin, PrefEnum.BOOL);

    if (!checkLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            selectedIndex: 0,
            typeOfOrganization: "",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
