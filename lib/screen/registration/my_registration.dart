import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishiyan/localization/AppLocalizations.dart';
import 'farmer_group_registration_page_one.dart';
import 'manufacture_registration.dart';
import 'other_registration.dart';
import 'my_trader_registration.dart';

class MyRegistration extends StatefulWidget {
  const MyRegistration({super.key});

  @override
  State<MyRegistration> createState() => _MyRegistrationState();
}

class _MyRegistrationState extends State<MyRegistration> {
  List<Category> ORG_CATEGORIES = [
    Category(
        name: buildTranslate("farmerGroups"),
        id: "1",
        icon: 'assets/images/team.png'),
    Category(
        name: buildTranslate("trader"),
        id: "2",
        icon: 'assets/images/deal.png'),
    Category(
        name: buildTranslate("manufacture"),
        id: "3",
        icon: 'assets/images/factory.png'),
    Category(
        name: buildTranslate("agent/Broker"),
        id: "4",
        icon: 'assets/images/broker.png'),
    Category(
        name: buildTranslate("others"),
        id: "5",
        icon: 'assets/images/option.png')
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 60,
            ),
            Center(child: Image.asset('assets/images/loginLogo.png')),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              buildTranslate("selectYourOrganization")!,
              style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 17,
                  fontFamily: 'poppins-semibold'),
            )),
            listWidget(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget listWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ORG_CATEGORIES.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFd3d3d3),
                    )
                  ],
                  border:
                      Border.all(color: const Color(0xFFd3d3d3), width: 1.5),
                  borderRadius: BorderRadius.circular(22)),
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  if (ORG_CATEGORIES[index].id == "1") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const FarmerGroupRegistrationPageOne()),
                    );
                  } else if (ORG_CATEGORIES[index].id == "2") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyTraderRegistration()),
                    );
                  } else if (ORG_CATEGORIES[index].id == "3") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ManufactureRegistration()),
                    );
                  } else if (ORG_CATEGORIES[index].id == "4") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyTraderRegistration()),
                    );
                  } else if (ORG_CATEGORIES[index].id == "5") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OtherRegistration()),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      ORG_CATEGORIES[index].icon ?? "",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      ORG_CATEGORIES[index].name ?? "",
                      style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 13,
                          fontFamily: 'poppins-regular'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      ),
    );
  }
}

class Category {
  String? name;
  String? icon;
  String? id;

  Category({
    required this.name,
    required this.icon,
    required this.id,
  });
}
