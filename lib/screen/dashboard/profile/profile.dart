import 'package:krishiyan/helper/constant.dart';
import 'package:krishiyan/screen/login/login.dart';

import 'other_detail/other_detail.dart';
import 'forgot_password/forgot_password.dart';
import '../../../helper/app_global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'edit_profile/edit_profile.dart';
import 'edit_address/edit_address.dart';
import '../../../helper/shared_pref.dart';
import 'edit_bank_detail/edit_bank_detail.dart';
import 'other_profile_edit/other_profile_edit.dart';
import '../../../localization/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishiyan/screen/dashboard/profile/delete_account/delete_account.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  var _bottomNavIndex = 3; //default index of a first screen

  String name = "", email = "", contactNumber = "";
  String typeOfOrganizationData = "";

  @override
  void initState() {
    super.initState();
    getDetails();
    getPrefValue();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This will be called every time the page is pushed or the dependencies change
    getDetails(); // Make sure to call getDetails here to update the values
  }

  String? _imageUrl;

  // Method to load the saved image from SharedPreferences
  Future<void> _loadImageUrl(String organizationName) async {
    if (organizationName.isEmpty) {
      print("Organization name is empty. Please enter a valid name.");
      return;
    }

    // Construct the image URL
    String imageUrl =
        '${baseUrlEnd}images/${organizationName}_profile_image.jpg';
    print("Fetching image from URL: $imageUrl");

    // Update the UI with the fetched image URL
    setState(() {
      _imageUrl = imageUrl; // Store the fetched image URL to display it
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Text(
          buildTranslate("myProfile")!,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'poppins-semibold',
              fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 40.0, bottom: 18.0, right: 18.0, left: 18.0),
              child: Row(
                children: [
                  Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _imageUrl != null
                            ? NetworkImage(
                                _imageUrl!) // If an image is selected, show it
                            : AssetImage("assets/images/user_profile.png")
                                as ImageProvider, // Default image
                        fit: BoxFit
                            .cover, // Ensure the image covers the container
                      ),
                      border: Border.all(
                        color: Colors.green, // Border color
                        width: 2.0, // Border width
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: 0.1), // Shadow color
                          blurRadius: 4.0, // Blur radius
                          offset: Offset(0, 2), // Shadow position
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        softWrap: true,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'poppins-semibold'),
                      ),
                      Text(
                        email,
                        softWrap: true,
                        style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 14,
                            fontFamily: 'poppins-regular'),
                      ),
                      Text(
                        contactNumber,
                        softWrap: true,
                        style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 14,
                            fontFamily: 'poppins-regular'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Text(
                buildTranslate("updateYourProfile")!,
                softWrap: true,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'poppins-semibold'),
              ),
            ),

            // edit profile
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                typeOfOrganizationData == "Farmer groups"
                    ? Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const EditProfileScreen()),
                      )
                    : Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const EditOtherProfilePage()),
                      );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 30.0, bottom: 20.0, right: 18.0, left: 18.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/edit_profile.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      buildTranslate("editProfile")!,
                      softWrap: true,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'poppins-regular'),
                    ),
                  ],
                ),
              ),
            ),

            // edit address
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const EditAddressScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 20.0, right: 18.0, left: 18.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/edit_profile.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      buildTranslate("editAddress")!,
                      softWrap: true,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'poppins-regular'),
                    ),
                  ],
                ),
              ),
            ),

            // edit bank details
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const EditBankDetailPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 20.0, right: 18.0, left: 18.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/edit_bankDetails.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      buildTranslate("editBankDetails")!,
                      softWrap: true,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'poppins-regular'),
                    ),
                  ],
                ),
              ),
            ),

            // other details
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const OtherDetailPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 20.0, right: 18.0, left: 18.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/edit_profile.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      buildTranslate("otherDetails")!,
                      softWrap: true,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'poppins-regular'),
                    ),
                  ],
                ),
              ),
            ),

            // reset password
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 20.0, right: 18.0, left: 18.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/reset_password.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      buildTranslate("resetPassword")!,
                      softWrap: true,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'poppins-regular'),
                    ),
                  ],
                ),
              ),
            ),
            // delete account
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DeleteAccountPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 20.0, right: 18.0, left: 18.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      buildTranslate('Delete Account')!,
                      softWrap: true,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'poppins-regular'),
                    ),
                  ],
                ),
              ),
            ),
            // logout
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear user data
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 20.0, right: 18.0, left: 18.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logout.png',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      buildTranslate("logout")!,
                      softWrap: true,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'poppins-regular'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getDetails() async {
    name = (await AppGlobal.getStringPreference('name'))!;
    email = (await AppGlobal.getStringPreference('email'))!;
    contactNumber = (await AppGlobal.getStringPreference('contactNumber'))!;
    print("Organization name");
    print(name);

    setState(() {
      name = name;
      email = email;
      contactNumber = contactNumber;
      _loadImageUrl(name);
    });
  }

  Future<void> getPrefValue() async {
    typeOfOrganizationData = await SharedPref.readPreferenceValue(
        typeOfOrganization, PrefEnum.STRING);
    print("Profile TypeOfOrganizationData : $typeOfOrganizationData");
    if (typeOfOrganizationData == "Farmer groups") {
      _bottomNavIndex = 3;
    } else {
      _bottomNavIndex = 1;
    }
    setState(() {
      typeOfOrganizationData = typeOfOrganizationData;
      _bottomNavIndex = _bottomNavIndex;
    });
  }
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
